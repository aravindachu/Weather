//
//  DetailsViewModel.swift
//  Weather
//
//  Created by Aravind Vijayan on 03/03/22.
//

import UIKit

final class DetailsViewModel {
    private var currentLocation: Location
    private var currentWeather: [Weather] = [] {
        didSet {
            setupWeatherData()
        }
    }

    init(location: Location) {
        self.currentLocation = location
        fetchWeather()
        self.setupPlaceData()
    }

    private func setupPlaceData() {
        placeObservable.value = currentLocation.title
    }

    private func setupWeatherData() {
        if let first = currentWeather.first {
            tempObservable.value = String(Int(first.temp))
            iconObservable.value = WeatherImage.getImage(for: first.stateAbbr)
            descObservable.value = first.state
            let limit = currentWeather.count > 10 ? 10 : currentWeather.count
            var viewModelArray = [DetailCellViewModel]()
            for index in 0..<limit {
                let model = currentWeather[index]
                let cellViewModel = DetailCellViewModel(temp: String(Int(first.temp)), desc: model.state, image: WeatherImage.getImage(for: model.stateAbbr))
                viewModelArray.append(cellViewModel)
            }
            dataSource.value = viewModelArray
        }
    }

    //MARK: View outputs
    let placeObservable = Observable<(String)>("")
    let tempObservable = Observable<(String)>("")
    let iconObservable = Observable<(UIImage)>(UIImage())
    let descObservable = Observable<(String)>("")
    let dataSource = Observable<([DetailCellViewModel])>([])

    //MARK: Backend
    private func fetchWeather() {
        let url = String(format: API.weather.withbaseURL, String(currentLocation.woeid))
        NetworkManager.shared.sendRequest(url: url) { [weak self] (result: Result<ConsolidatedWeather?, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                if let weatherArray = weather?.weatherArray {
                    self.currentWeather = weatherArray
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
