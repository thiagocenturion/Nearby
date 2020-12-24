//
//  MapsActionSheetViewModel.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 23/12/20.
//

import UIKit
import RxCocoa
import RxSwift

final class MapsActionSheetViewModel {
    
    // MARK: - Properties
    let coordinate: Coordinate
    let application: UIApplication
    let appleURL: URL?
    let googleURL: URL?
    let wazeURL: URL?
    var actionsViewModels: [AlertActionViewModel] = []
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    let alert = PublishRelay<AlertViewModel>()
    let selectedURL = PublishSubject<URL>()
    
    // MARK: - Initialization
    init(coordinate: Coordinate, application: UIApplication) {
        self.coordinate = coordinate
        self.application = application
        appleURL = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")
        googleURL = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")
        wazeURL = URL(string: "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=false")
        
        setup()
        bind()
    }
}

// MARK: - Methods
extension MapsActionSheetViewModel {
    
    private func setup() {
        if let url = appleURL, application.canOpenURL(url) {
            actionsViewModels.append(actionViewModel(with: url, title: "maps_action_sheet_apple".localized))
        }
        
        if let url = googleURL, application.canOpenURL(url) {
            actionsViewModels.append(actionViewModel(with: url, title: "maps_action_sheet_google".localized))
        }
        
        if let url = wazeURL, application.canOpenURL(url) {
            actionsViewModels.append(actionViewModel(with: url, title: "maps_action_sheet_waze".localized))
        }
    }
    
    private func bind() {
        let alertViewModel = AlertViewModel(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet,
            actionsViewModels: actionsViewModels,
            cancelActionViewModel: .init(title: "maps_action_sheet_alert_cancel".localized)
        )
        
        Observable.just(alertViewModel)
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: alert)
            .disposed(by: disposeBag)
    }
    
    private func actionViewModel(with url: URL, title: String) -> AlertActionViewModel {
        let actionViewModel = AlertActionViewModel(title: title)
        
        actionViewModel.tap
            .map { url }
            .bind(to: selectedURL)
            .disposed(by: disposeBag)
        
        return actionViewModel
    }
}

#if UNIT_TEST

// MARK: - Mock
extension MapsActionSheetViewModel {
    
    static func mock(coordinate: Coordinate = .mock(),
                     application: UIApplication = .shared) -> MapsActionSheetViewModel {
        return .init(
            coordinate: coordinate,
            application: application
        )
    }
}

#endif
