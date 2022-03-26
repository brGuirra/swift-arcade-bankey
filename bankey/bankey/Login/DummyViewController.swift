//
//  DummyViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 26/03/22.
//

import UIKit

class DummyViewController: UIViewController {
    
    weak var delegate: LogoutDelegate?

    let label = UILabel()
    let stackView = UIStackView()
    let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        style()
        layout()
    }
}

extension DummyViewController {
    
    func style() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.configuration = .filled()
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .primaryActionTriggered)
    }
    
    func layout() {
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func logoutTapped(_ sender: UIButton) {
        delegate?.didLogout()
    }
}
