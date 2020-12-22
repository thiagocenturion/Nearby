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
    }
}
