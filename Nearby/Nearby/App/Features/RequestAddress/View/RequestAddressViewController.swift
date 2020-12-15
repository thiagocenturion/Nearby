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
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "request_address_description".localized
        }
    }
    @IBOutlet private weak var currentLocationButton: UIButton! {
        didSet {
            currentLocationButton.setTitle("request_address_current_location".localized, for: .normal)
        }
    }
    @IBOutlet private weak var registerAddressButton: UIButton! {
        didSet {
            registerAddressButton.setTitle("request_address_register_address".localized, for: .normal)
        }
    }
    
    // MARK: - Properties
    
    private let viewModel: RequestAddressViewModel
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
        
        title = viewModel.title
        
        bind()
    }
}


// MARK: - Binding

extension RequestAddressViewController {
    
    func bind() {
        currentLocationButton.rx.tap
            .bind(to: viewModel.willUseCurrentLocation)
            .disposed(by: disposeBag)
        
        registerAddressButton.rx.tap
            .bind(to: viewModel.willRegisterAddress)
            .disposed(by: disposeBag)
    }
}
