//
//  PlacesViewController.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import UIKit
import RxSwift

final class PlacesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var restaurantSwitch: UISwitch!
    @IBOutlet private weak var barSwitch: UISwitch!
    @IBOutlet private weak var cafeSwitch: UISwitch!
    @IBOutlet private weak var restaurantLabel: UILabel!
    @IBOutlet private weak var barLabel: UILabel!
    @IBOutlet private weak var cafeLabel: UILabel!
    
    // MARK: - Properties
    let viewModel: PlacesViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(viewModel: PlacesViewModel) {
        self.viewModel = viewModel
        
        super.init(
            nibName: String(describing: PlacesViewController.self),
            bundle: Bundle(for: PlacesViewController.self)
        )
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: - View Lifecycle
extension PlacesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
}

// MARK: - Private methods
extension PlacesViewController {
    
    private func setup() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        restaurantLabel.text = viewModel.restaurantText
        barLabel.text = viewModel.barText
        cafeLabel.text = viewModel.cafeText
        
        restaurantSwitch.isOn = viewModel.selectedTypes.value.contains(.restaurant)
        barSwitch.isOn = viewModel.selectedTypes.value.contains(.bar)
        cafeSwitch.isOn = viewModel.selectedTypes.value.contains(.cafe)
    }
    
    private func bind() {
        rx.viewDidAppear
            .map { _ in () }
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
            })
            .disposed(by: disposeBag)
        
        let restaurantValueChanged = restaurantSwitch.rx.controlEvent(.valueChanged).withLatestFrom(restaurantSwitch.rx.value).share()
        let barValueChanged = barSwitch.rx.controlEvent(.valueChanged).withLatestFrom(barSwitch.rx.value).share()
        let cafeValueChanged = cafeSwitch.rx.controlEvent(.valueChanged).withLatestFrom(cafeSwitch.rx.value).share()
        
        Observable.merge(
            restaurantValueChanged.filter { $0 }.map { _ in Place.PlaceType.restaurant },
            barValueChanged.filter { $0 }.map { _ in Place.PlaceType.bar },
            cafeValueChanged.filter { $0 }.map { _ in Place.PlaceType.cafe }
        )
        .bind(to: viewModel.appendSelectedType)
        .disposed(by: disposeBag)
        
        Observable.merge(
            restaurantValueChanged.filter { !$0 }.map { _ in Place.PlaceType.restaurant },
            barValueChanged.filter { !$0 }.map { _ in Place.PlaceType.bar },
            cafeValueChanged.filter { !$0 }.map { _ in Place.PlaceType.cafe }
        )
        .bind(to: viewModel.removeSelectedType)
        .disposed(by: disposeBag)
    }
}
