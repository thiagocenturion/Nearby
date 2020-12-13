//
//  RequestAddressViewController.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import UIKit
import RxSwift

class RequestAddressViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: RequestAddressViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(viewModel: RequestAddressViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
