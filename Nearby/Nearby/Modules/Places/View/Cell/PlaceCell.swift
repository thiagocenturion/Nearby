//
//  PlaceTableViewCell.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 22/12/20.
//

import RxSwift
import UIKit

final class PlaceTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typesLabel: UILabel!
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
}

//-----------------------------------------------------------------------------
// MARK: Overrides
//-----------------------------------------------------------------------------

extension PlaceTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

//-----------------------------------------------------------------------------
// MARK: Public methods
//-----------------------------------------------------------------------------

extension PlaceTableViewCell {

    func configure(with viewModel: PlaceCellViewModel) {
        bind(with: viewModel)
    }
}

//-----------------------------------------------------------------------------
// MARK: Private methods - Setup
//-----------------------------------------------------------------------------

extension PlaceTableViewCell {

//    private func setup() {
//    }

    private func bind(with viewModel: PlaceCellViewModel) {
        addressLabel.text = viewModel.address
        titleLabel.text = viewModel.title
        typesLabel.text = viewModel.types.map { $0.rawValue }.joined(separator: ", ")
    }
}
