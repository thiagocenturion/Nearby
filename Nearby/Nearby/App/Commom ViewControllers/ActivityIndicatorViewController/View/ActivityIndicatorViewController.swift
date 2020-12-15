//
//  ActivityIndicatorViewController.swift
//  Nearby
//
//  Created by Thiago Rodrigues Centurion on 13/12/20.
//

import UIKit

final class ActivityIndicatorViewController: UIViewController {
    
    private let loading = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        view.addSubview(loading)
        
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
