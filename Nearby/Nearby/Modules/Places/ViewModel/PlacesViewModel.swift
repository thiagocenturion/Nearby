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
    let segmenteds: [Segmented]
    let placeServices: PlaceServicesType
    let locale: Locale
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    let isLoading: BehaviorRelay<Bool>
    let coordinate: BehaviorRelay<Coordinate>
    let radius: BehaviorRelay<Int>
    let selectedType: BehaviorRelay<Place.PlaceType>
    
    let viewDidAppear = PublishRelay<Void>()
    let fetchPlaces = PublishRelay<Void>()
    
    let alert = PublishRelay<AlertViewModel>()
    
    // MARK: - Table View Model and Data Source
    let places: BehaviorRelay<[PlaceCellViewModel]>
    
    // MARK: - Initialization
    init(segmenteds: [Segmented],
         placeServices: PlaceServicesType,
         locale: Locale,
         isLoading: Bool,
         places: [PlaceCellViewModel],
         coordinate: Coordinate,
         radius: Int,
         selectedType: Place.PlaceType) {

        self.segmenteds = segmenteds
        self.placeServices = placeServices
        self.locale = locale
        self.isLoading = BehaviorRelay(value: isLoading)
        self.places = BehaviorRelay(value: places)
        self.coordinate = BehaviorRelay(value: coordinate)
        self.radius = BehaviorRelay(value: radius)
        self.selectedType = BehaviorRelay(value: selectedType)
        
        bind()
    }
}

// MARK: - Inner type
extension PlacesViewModel {
    
    struct Segmented {
        let type: Place.PlaceType
        let text: String
    }
}

// MARK: - Binding
extension PlacesViewModel {
    
    private func bind() {
        fetchPlaces
            .bind(to: fetchPlacesBinder)
            .disposed(by: disposeBag)
        
        Observable.merge(
            viewDidAppear.asObservable(),
            coordinate.skip(1).map { _ in () }.asObservable(),
            radius.skip(1).map { _ in () }.asObservable(),
            selectedType.skip(1).map { _ in () }.asObservable()
        )
        .bind(to: fetchPlaces)
        .disposed(by: disposeBag)
    }
    
    private var fetchPlacesBinder: Binder<Void> {
        return Binder(self) { target, _ in
            target.placeServices.requestPlacesSearch(
                coordinate: target.coordinate.value,
                radius: target.radius.value,
                type: target.selectedType.value,
                locale: target.locale
            )
            .do(onSubscribe: { target.isLoading.accept(true) })
            .do(onDispose: { target.isLoading.accept(false) })
            .subscribe(
                onSuccess: { places in
                    let formatter = MeasurementFormatter.shortNaturalScaleFormatter(with: target.locale)
                    let placeViewModels = places.map { PlaceCellViewModel(place: $0, measurementFormatter: formatter) }
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

#if UNIT_TEST

// MARK: - Equatable
extension PlacesViewModel.Segmented: Equatable {
    
    static func == (lhs: PlacesViewModel.Segmented, rhs: PlacesViewModel.Segmented) -> Bool {
        return lhs.type == rhs.type &&
            lhs.text == rhs.text
    }
}

// MARK: - Mock
extension PlacesViewModel {
    
    static func mock(
        segmenteds: [Segmented] = [.init(type: .restaurant, text: "places_restaurant".localized)],
        placeServices: PlaceServicesType = PlaceServicesStub(responseType: .none),
        locale: Locale = Locale.current,
        isLoading: Bool = true,
        places: [PlaceCellViewModel] = [],
        coordinate: Coordinate = .mock(),
        radius: Int = 2500,
        selectedType: Place.PlaceType = .restaurant) -> PlacesViewModel {
        
        return .init(
            segmenteds: segmenteds,
            placeServices: placeServices,
            locale: locale,
            isLoading: isLoading,
            places: places,
            coordinate: coordinate,
            radius: radius,
            selectedType: selectedType
        )
    }
}

#endif
