//
//  HomeViewModel.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import Foundation
import UIKit

final class HomeViewModel {

    private var searchedString = ""
    private var currentLocation: Location? {
        didSet {
            self.placeObservable.value = currentLocation?.title ?? "Search"
            self.fetchWeather()
        }
    }
    private var currentWeather: Weather? {
        didSet {
            updateWeatherObservables()
        }
    }

    private var searchLocations = [Location]() {
        didSet {
            setupHistoryDataSource()
        }
    }

    init() {
        askForPermission()
        loadWeatherData()
    }

    private func updateWeatherObservables() {
        guard let currentWeather = currentWeather else {
            return
        }
        tempObservable.value = String(Int(currentWeather.temp))
        iconObservable.value = WeatherImage.getImage(for: currentWeather.stateAbbr)
        descObservable.value = currentWeather.state

    }

    private func saveToDB(_ insertLocation: Location) {
        let manager = CoreDataManager.shared
        guard manager.getLocation(by: insertLocation.woeid) == nil else { return }
        let location = LocationModel(context: manager.persistentContainer.viewContext)
        location.title = insertLocation.title
        location.woeid = insertLocation.woeid
        location.type = insertLocation.type
        manager.save()
    }

    private func fetchHistoryFromDB() {
        let manager = CoreDataManager.shared
        DispatchQueue.main.async { [unowned self] in
            self.searchLocations = manager.getAllLocations().map { Location.init(dbModel: $0) }
        }

    }

    private func setupHistoryDataSource() {
        guard searchLocations.isEmpty == false else {
            historyDataSource.value = []
            return
        }
        let dataSource = searchLocations.map { HistoryCellViewModel(title: $0.title, coreModel: $0) }
        historyDataSource.value = dataSource
    }

    //MARK: View Inputs
    func search(using searchString: String, showOld: Bool = false) {
        self.searchedString = searchString
        if showOld && searchString.isEmpty  {
            fetchHistoryFromDB()
        } else {
            fetchLocations()
        }
    }

    func itemSelected(at indexPath: IndexPath) -> DetailsViewController {
        let location = self.historyDataSource.value[indexPath.row].coreModel
        saveToDB(location)
        return DetailsBuilder.build(location: location)
    }

    //MARK: View outputs
    let placeObservable = Observable<(String)>("Searching...")
    let tempObservable = Observable<(String)>("")
    let iconObservable = Observable<(UIImage)>(UIImage())
    let descObservable = Observable<(String)>("")
    let historyDataSource = Observable<([HistoryCellViewModel])>([])


    //MARK: Backend
    private func askForPermission() {
        LocationManager.shared.requestLocationAuthorization()
    }

    private func loadWeatherData() {
        LocationManager.shared.latestCordinates = { [weak self] (lat, long) in
            let url = String(format: API.cordinatesSearch.withbaseURL, String(lat), String(long))
            NetworkManager.shared.sendRequest(url: url) { [weak self] (result: Result<[Location]?, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let locations):
                    self.currentLocation = locations?.first
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    private func fetchWeather() {
        if let currentLocation = currentLocation {
            let url = String(format: API.weather.withbaseURL, String(currentLocation.woeid))
            NetworkManager.shared.sendRequest(url: url) { [weak self] (result: Result<ConsolidatedWeather?, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.currentWeather = weather?.weatherArray.first
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    private func fetchLocations() {
        guard searchedString.isEmpty == false else {
            self.searchLocations = []
            return
        }
        let url = String(format: API.querySearch.withbaseURL, searchedString)
        NetworkManager.shared.sendRequest(url: url) { [weak self] (result: Result<[Location]?, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let locations):
                if let locations = locations {
                    self.searchLocations = locations
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
