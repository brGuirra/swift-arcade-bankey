//
//  OnboardingViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 24/03/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var onboardingImage: UIImageView = {
       let onboardingImage = UIImageView()
        onboardingImage.translatesAutoresizingMaskIntoConstraints = false
        onboardingImage.contentMode = .scaleAspectFill
        onboardingImage.image = UIImage(named: "delorean")
        return onboardingImage
    }()
    
    lazy var onboardingTextLabel: UILabel = {
        let onboardingTextLabel = UILabel()
        onboardingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        onboardingTextLabel.text = "Bankey is faster, easy to use, and has brand new look and feel that will make you feel like you're back in 1989."
        onboardingTextLabel.textAlignment = .center
        onboardingTextLabel.numberOfLines = 0
        onboardingTextLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        return onboardingTextLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
}

extension OnboardingViewController {
    func layout() {
        containerStackView.addArrangedSubview(onboardingImage)
        containerStackView.addArrangedSubview(onboardingTextLabel)
        
        view.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: containerStackView.trailingAnchor, multiplier: 1 )
        ])
    }
}
