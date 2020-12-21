//
//  RequestAddressViewController.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import UIKit
import RxSwift

class RequestAddressViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var registerAddressButton: UIButton!
    
    // MARK: - Properties
    
    let viewModel: RequestAddressViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(viewModel: RequestAddressViewModel) {
        self.viewModel = viewModel
        
        super.init(
            nibName: String(describing: RequestAddressViewController.self),
            bundle: Bundle(for: RequestAddressViewController.self)
        )
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

// MARK: - View Lifecycle

extension RequestAddressViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
}


// MARK: - Private methods

extension RequestAddressViewController {
    
    private func setup() {
        title = viewModel.title
        descriptionLabel.text = viewModel.description
        currentLocationButton.setTitle(viewModel.currentLocationText, for: .normal)
        registerAddressButton.setTitle(viewModel.registerAddressText, for: .normal)
    }
    
    private func bind() {
        currentLocationButton.rx.tap
            .bind(to: viewModel.willUseCurrentLocation)
            .disposed(by: disposeBag)
        
        registerAddressButton.rx.tap
            .bind(to: viewModel.willRegisterAddress)
            .disposed(by: disposeBag)
    }
}
