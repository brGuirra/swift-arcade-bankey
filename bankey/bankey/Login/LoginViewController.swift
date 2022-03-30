//
//  ViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 20/03/22.
//

import UIKit

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    lazy var loginView = LoginView()
    lazy var signInButton = UIButton(type: .system)
    lazy var errorMessageLabel = UILabel()
    
    // Animation
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEggeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var subtitleLeadingAnchor: NSLayoutConstraint?
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
    }
}

//MARK: - Layout

extension LoginViewController {
    
    private func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.isHidden = false
        titleLabel.text = "Bankey"
        titleLabel.alpha = 0
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Your premium source for all things banking!"
        subtitleLabel.alpha = 0
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // Title Label
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
        ])
        
        titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEggeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        // Subtitle Label
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEggeOffScreen)
        subtitleLeadingAnchor?.isActive = true
        
        // LoginView
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1)
        ])
        
        // SignIn Button
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Error Message Label
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
    }
}

//MARK: - Actions

extension LoginViewController {
    
    @objc func signInTapped() {
        errorMessageLabel.isHidden = true
        
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username or password should never be nil")
            return
        }
        
        if username.isEmpty || password.isEmpty {
            configureErrorMessageLabel(withMessage: "Username or password cannot be blank")
            return
        }
        
        if username == "Bruno" && password == "123" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureErrorMessageLabel(withMessage: "Incorrect username or password")
        }
    }
    
    private func configureErrorMessageLabel(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        
        shakeButton()
    }
}

//MARK: - Animations

extension LoginViewController {
    
    private func animate() {
        let duration = 0.8
        let delay = 0.2
        
        let titleEntranceAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) { [titleLeadingAnchor, leadingEdgeOnScreen, view] in
            titleLeadingAnchor?.constant = leadingEdgeOnScreen
            view?.layoutIfNeeded()
        }
        
        titleEntranceAnimator.startAnimation()
        
        let subtitleEntranceAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) { [subtitleLeadingAnchor, leadingEdgeOnScreen, view] in
            subtitleLeadingAnchor?.constant = leadingEdgeOnScreen
            view?.layoutIfNeeded()
        }
        
        subtitleEntranceAnimator.startAnimation(afterDelay: delay)
        
        let opacityAnimator = UIViewPropertyAnimator(duration: duration * 2.0, curve: .easeInOut) { [titleLabel, subtitleLabel] in
            titleLabel.alpha = 1
            subtitleLabel.alpha = 1
        }
        
        opacityAnimator.startAnimation(afterDelay: delay)
    }
    
    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        
        signInButton.layer.add(animation, forKey: "shake")
    }
}
