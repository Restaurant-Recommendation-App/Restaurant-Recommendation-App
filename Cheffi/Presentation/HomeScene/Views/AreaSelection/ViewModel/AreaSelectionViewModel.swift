//
//  AreaSelectionViewModel.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/22.
//

import Combine

struct CityInfo: Codable {
    var si: String
    var gu: String
}

struct AreaSelection: Hashable {
    let areaName: String
    var isSelected: Bool
}

final class AreaSelectionViewModel: ViewModelType {
        
    struct Input {
        let initialize: AnyPublisher<Void, Never>
        let didSelectSiArea: AnyPublisher<Int, Never>
        let didSelectGuArea: AnyPublisher<Int, Never>
        let didTappedComplteSelection: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let siAreas: AnyPublisher<[AreaSelection], Never>
        let guAreas: AnyPublisher<[AreaSelection], Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    let useCase: AreaUseCase
    
    private var siAreas: [AreaSelection] = []
    private var guAreas: [[AreaSelection]] = [[]]
    
    init(useCase: AreaUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        
        let siAreas = PassthroughSubject<[AreaSelection], Never>()
        let guAreas = PassthroughSubject<[AreaSelection], Never>()
        let initialize = input.initialize.share()
            .flatMap { self.useCase.getAreas() }
        
        let siName = UserDefaultsManager.AreaInfo.area.si
        let guName = UserDefaultsManager.AreaInfo.area.gu
        
        var prevTappedSiIndex = 0
        var currentTappedSiIndex = 0
        var currentTappedGuIndex = 0
        
        var selectedSiIndex = 0
        var selectedGuIndex = 0
        
        initialize
            .map { areas  -> [AreaSelection] in
                areas.map { area in
                    let isSelected = siName == area.si
                    return AreaSelection(areaName: area.si, isSelected: isSelected)
                }
            }.sink { [weak self] areas in
                guard let self else { return }
                self.siAreas = areas
                siAreas.send(self.siAreas)
            }.store(in: &cancellables)
        
        initialize
            .map { areas -> [[AreaSelection]] in
                currentTappedSiIndex = areas.firstIndex(where: { $0.si == siName }) ?? 0
                prevTappedSiIndex = currentTappedSiIndex
                selectedSiIndex = currentTappedSiIndex
                return areas.map { area in
                    area.gu.map { gu in
                        let isSelected = gu == guName
                        return AreaSelection(areaName: gu, isSelected: isSelected)
                    }
                }
            }.sink { [weak self] areas in
                guard let self else { return }
                self.guAreas = areas
                currentTappedGuIndex = self.guAreas[selectedSiIndex].firstIndex(where: { $0.areaName == guName }) ?? 0
                selectedGuIndex = currentTappedGuIndex
                guAreas.send(self.guAreas[currentTappedSiIndex])
            }.store(in: &cancellables)
        
        input.didSelectSiArea
            .sink {
                prevTappedSiIndex = currentTappedSiIndex
                currentTappedSiIndex = $0
                self.siAreas[prevTappedSiIndex].isSelected = false
                self.siAreas[currentTappedSiIndex].isSelected = true
                siAreas.send(self.siAreas)
                guAreas.send(self.guAreas[currentTappedSiIndex])
            }.store(in: &cancellables)
        
        input.didSelectGuArea
            .sink {
                currentTappedGuIndex = $0
                self.guAreas[selectedSiIndex][selectedGuIndex].isSelected = false
                self.guAreas[currentTappedSiIndex][currentTappedGuIndex].isSelected = true
                selectedSiIndex = currentTappedSiIndex
                selectedGuIndex = currentTappedGuIndex
                guAreas.send(self.guAreas[currentTappedSiIndex])
            }.store(in: &cancellables)
        
        input.didTappedComplteSelection
            .sink { _ in
                UserDefaultsManager.AreaInfo.area = CityInfo(
                    si: self.siAreas[selectedSiIndex].areaName,
                    gu: self.guAreas[selectedSiIndex][selectedGuIndex].areaName
                )
            }.store(in: &cancellables)
        
        return Output(
            siAreas: siAreas.eraseToAnyPublisher(),
            guAreas: guAreas.eraseToAnyPublisher()
        )
    }
}
