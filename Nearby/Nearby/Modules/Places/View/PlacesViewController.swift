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
    @IBOutlet weak var typesSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
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
        
        let segmenteds = viewModel.segmenteds
        typesSegmentedControl.replaceSegments(withTitles: segmenteds.map { $0.text })
        typesSegmentedControl.selectedSegmentIndex = segmenteds.firstIndex { $0.type == viewModel.selectedType.value } ?? 0
        
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceTableViewCell")
    }
    
    private func bind() {
        rx.viewDidAppear
            .map { _ in () }
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
            })
            .disposed(by: disposeBag)
        
        typesSegmentedControl.rx.selectedSegmentIndex
            .map { [viewModel] in viewModel.segmenteds[$0].type }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
        viewModel.places
            .bind(to: tableView.rx.items(cellIdentifier: "PlaceTableViewCell", cellType: PlaceTableViewCell.self)) { _, cellViewModel, cell in
                cell.configure(with: cellViewModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { [tableView] indexPath in tableView?.deselectRow(at: indexPath , animated: true) })
            .map { [viewModel] indexPath in viewModel.places.value[indexPath.row] }
            .bind(to: viewModel.selectedPlace)
            .disposed(by: disposeBag)
    }
}
