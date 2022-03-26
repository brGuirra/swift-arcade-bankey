//
//  OnboardingViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 24/03/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let heroImageName: String
    private let onboardingText: String

    lazy var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = 20
        return containerStackView
    }()
    
    lazy var onboardingImage: UIImageView = {
       let onboardingImage = UIImageView()
        onboardingImage.translatesAutoresizingMaskIntoConstraints = false
        onboardingImage.contentMode = .scaleAspectFit
        onboardingImage.image = UIImage(named: self.heroImageName)
        return onboardingImage
    }()
    
    lazy var onboardingTextLabel: UILabel = {
        let onboardingTextLabel = UILabel()
        onboardingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        onboardingTextLabel.text = self.onboardingText
        onboardingTextLabel.textAlignment = .center
        onboardingTextLabel.numberOfLines = 0
        onboardingTextLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        return onboardingTextLabel
    }()
    
    init(heroImageName: String, onboardingText: String) {
        self.heroImageName = heroImageName
        self.onboardingText = onboardingText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
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
