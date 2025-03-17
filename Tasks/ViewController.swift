//
//  ViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove me
        let label = UILabel()
        label.text = "Hello, UIKit!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            label.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }


}

