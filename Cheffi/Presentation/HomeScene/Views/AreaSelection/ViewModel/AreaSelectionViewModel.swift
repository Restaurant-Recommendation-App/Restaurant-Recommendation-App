//
//  AreaSelectionViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/22.
//

import Combine

struct CityInfo: Codable {
    var province: String
    var city: String
}

struct AreaSelection: Hashable {
    let areaName: String
    var isSelected: Bool
}

final class AreaSelectionViewModel: ViewModelType {
        
    struct Input {
        let initialize: AnyPublisher<Void, Never>
        let didSelectProvince: AnyPublisher<Int, Never>
        let didSelectCity: AnyPublisher<Int, Never>
        let didTappedComplteSelection: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let provinces: AnyPublisher<[AreaSelection], Never>
        let cities: AnyPublisher<[AreaSelection], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    let useCase: AreaUseCase
    
    private var provinces: [AreaSelection] = []
    private var cities: [[AreaSelection]] = [[]]
    
    init(useCase: AreaUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let provinces = PassthroughSubject<[AreaSelection], Never>()
        let cities = PassthroughSubject<[AreaSelection], Never>()
        let initialize = input.initialize.share()
            .flatMap { self.useCase.getAreas() }
        
        let provinceName = UserDefaultsManager.AreaInfo.area.province
        let cityName = UserDefaultsManager.AreaInfo.area.city
        
        var prevTappedProvinceIndex = 0
        var currentTappedProvinceIndex = 0
        var currentTappedCityIndex = 0
        
        var selectedProvinceIndex = 0
        var selectedCityIndex = 0
        
        initialize
            .sink { completion in
                switch completion {
                // TODO: 에러 처리
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] areas in
                guard let self else { return }
                
                self.provinces = areas.map { area in
                    let isSelected = provinceName == area.province
                    return AreaSelection(areaName: area.province, isSelected: isSelected)
                }
                
                provinces.send(self.provinces)
            }.store(in: &cancellables)

        initialize
            .sink { completion in
                switch completion {
                // TODO: 에러 처리
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] areas in
                guard let self else { return }
                
                currentTappedProvinceIndex = areas.firstIndex(where: { $0.province == provinceName }) ?? 0
                prevTappedProvinceIndex = currentTappedProvinceIndex
                selectedProvinceIndex = currentTappedProvinceIndex
                self.cities = areas.map { area in
                    area.cities.map { city in
                        let isSelected = city == cityName
                        return AreaSelection(areaName: city, isSelected: isSelected)
                    }
                }
                
                currentTappedCityIndex = self.cities[selectedProvinceIndex].firstIndex(where: { $0.areaName == cityName }) ?? 0
                selectedCityIndex = currentTappedCityIndex
                cities.send(self.cities[currentTappedProvinceIndex])
            }.store(in: &cancellables)
        
        input.didSelectProvince
            .sink {
                prevTappedProvinceIndex = currentTappedProvinceIndex
                currentTappedProvinceIndex = $0
                self.provinces[prevTappedProvinceIndex].isSelected = false
                self.provinces[currentTappedProvinceIndex].isSelected = true
                provinces.send(self.provinces)
                cities.send(self.cities[currentTappedProvinceIndex])
            }.store(in: &cancellables)
        
        input.didSelectCity
            .sink {
                currentTappedCityIndex = $0
                self.cities[selectedProvinceIndex][selectedCityIndex].isSelected = false
                self.cities[currentTappedProvinceIndex][currentTappedCityIndex].isSelected = true
                selectedProvinceIndex = currentTappedProvinceIndex
                selectedCityIndex = currentTappedCityIndex
                cities.send(self.cities[currentTappedProvinceIndex])
            }.store(in: &cancellables)
        
        input.didTappedComplteSelection
            .sink { _ in
                UserDefaultsManager.AreaInfo.area = CityInfo(
                    province: self.provinces[selectedProvinceIndex].areaName,
                    city: self.cities[selectedProvinceIndex][selectedCityIndex].areaName
                )
            }.store(in: &cancellables)
        
        return Output(
            provinces: provinces.eraseToAnyPublisher(),
            cities: cities.eraseToAnyPublisher()
        )
    }
}
