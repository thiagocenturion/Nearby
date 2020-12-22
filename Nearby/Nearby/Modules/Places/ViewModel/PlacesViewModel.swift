//
//  PlacesViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import Foundation
import RxCocoa
import RxSwift

final class PlacesViewModel {
    
    // MARK: - Properties
    let placeServices: PlaceServicesType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    let isLoading: BehaviorRelay<Bool>
    let coordinate: BehaviorRelay<Coordinate>
    let radius: BehaviorRelay<Int>
    let selectedTypes: BehaviorRelay<[Place.PlaceType]>
    
    let viewDidAppear = PublishRelay<Void>()
    let fetchPlaces = PublishRelay<Void>()
    let selectedPlace = PublishRelay<PlaceViewModel>()
    
    let alert = PublishRelay<AlertViewModel>()
    
    // MARK: - Table View Model and Data Source
    let places: BehaviorRelay<[PlaceViewModel]>
    
    // MARK: - Initialization
    init(placeServices: PlaceServicesType,
         isLoading: Bool,
         places: [PlaceViewModel],
         coordinate: Coordinate,
         radius: Int,
         selectedTypes: [Place.PlaceType]) {

        self.placeServices = placeServices
        self.isLoading = BehaviorRelay(value: isLoading)
        self.places = BehaviorRelay(value: places)
        self.coordinate = BehaviorRelay(value: coordinate)
        self.radius = BehaviorRelay(value: radius)
        self.selectedTypes = BehaviorRelay(value: selectedTypes)
        
        bind()
    }
}

// MARK: - Binding
extension PlacesViewModel {
    
    private func bind() {
        fetchPlaces
            .bind(to: fetchPlacesBinder)
            .disposed(by: disposeBag)
        
        viewDidAppear
            .bind(to: fetchPlaces)
            .disposed(by: disposeBag)
        
        Observable.merge(
            coordinate.skip(1).map { _ in () }.asObservable(),
            radius.skip(1).map { _ in () }.asObservable(),
            selectedTypes.skip(1).map { _ in () }.asObservable()
        )
        .bind(to: fetchPlaces)
        .disposed(by: disposeBag)
    }
    
    private var fetchPlacesBinder: Binder<Void> {
        return Binder(self) { target, _ in
            target.placeServices.requestPlacesSearch(
                location: target.coordinate.value,
                radius: target.radius.value,
                types: target.selectedTypes.value
            )
            .do(onSubscribe: { target.isLoading.accept(true) })
            .do(onDispose: { target.isLoading.accept(false) })
            .subscribe(
                onSuccess: { places in
                    let placeViewModels = places.map { PlaceViewModel(place: $0) }
                    target.places.accept(placeViewModels)
                },
                onError: { error in
                    guard let networkingError = error as? NetworkingError else { return }
                    let alertViewModel = AlertViewModel(
                        title: "error_message_title".localized,
                        message: networkingError.rawValue,
                        preferredStyle: .alert,
                        confirmActionViewModel: .init(title: "error_message_confirm_button".localized),
                        cancelActionViewModel: .init(title: "request_address_denied_cancel".localized)
                    )
                    target.alert.accept(alertViewModel)
                }
            )
            .disposed(by: target.disposeBag)
        }
    }
}
