//
//  AppDelegate.swift
//  bankey
//
//  Created by Bruno Guirra on 20/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingContainerViewController.delegate = self
        
        window?.rootViewController =  loginViewController
        
        return true
    }
}

//MARK: - LoginViewControllerDelegate

extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        setRootViewController(onboardingContainerViewController)
    }
}

//MARK: - OnboardingContainerViewControllerDelegate

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        print("did finish onboarding")
    }
}


//MARK: - Functions

extension AppDelegate {
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        
        guard animated, let window = window.self else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        // Animation to transitions on root ViewControllers
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
