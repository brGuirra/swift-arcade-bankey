//
//  MainViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 26/03/22.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTabBar()
    }
    
    func setupViews() {
        let summaryVC = AccountSummaryViewController()
        let moneyVC = MoveMoneyViewController()
        let moreVC = MoreViewController()
        
        summaryVC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "Summary")
        moneyVC.setTabBarImage(imageName: "arrow.left.arrow.right", title: "Move Money")
        moreVC.setTabBarImage(imageName: "ellipsis.circle", title: "More")
        
        let summaryNC = UINavigationController(rootViewController: summaryVC)
        let moneyNC = UINavigationController(rootViewController: moneyVC)
        let moreNC = UINavigationController(rootViewController: moreVC)
        
        summaryNC.navigationBar.barTintColor = appColor
        hideNavigationBarLine(summaryNC.navigationBar)
        
        let tabBarList = [summaryNC, moneyNC, moreNC]
        viewControllers = tabBarList
    }

    func setupTabBar() {
        tabBar.tintColor = appColor
        tabBar.isTranslucent = false
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let image = UIImage()
        navigationBar.shadowImage = image
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.isTranslucent = false
    }
}

class MoveMoneyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

class MoreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}
