//
//  AccountSummaryTableHeader.swift
//  bankey
//
//  Created by Bruno Guirra on 26/03/22.
//

import UIKit

class AccountSummaryTableHeader: UITableViewHeaderFooterView {
    
    static let identifier = "TableHeader"
    
    let containerStackView = UIStackView()
    let infoStackView = UIStackView()
    
    let brandLabel = UILabel()
    let greetingLabel = UILabel()
    let usernameLabel = UILabel()
    let dateLabel = UILabel()
    let weatherImage = UIImageView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Functions

extension AccountSummaryTableHeader {
    
    func style() {
        contentView.backgroundColor = appColor
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .fill
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        
        brandLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        brandLabel.text = "Bankey"
        
        greetingLabel.text = "Good morning"
        
        usernameLabel.text = "Bruno"
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.text = "Date"
        
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.image = UIImage(systemName: "sun.max.fill")
        weatherImage.tintColor = .systemYellow
    }
    
    func layout() {
        infoStackView.addArrangedSubview(brandLabel)
        infoStackView.addArrangedSubview(greetingLabel)
        infoStackView.addArrangedSubview(usernameLabel)
        infoStackView.addArrangedSubview(dateLabel)
        
        containerStackView.addArrangedSubview(infoStackView)
        containerStackView.addArrangedSubview(weatherImage)
        contentView.addSubview(containerStackView)
        
        // ContainerStackView Constraints
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: containerStackView.trailingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: containerStackView.bottomAnchor, multiplier: 2),
            containerStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ])
        
        // WeatherImage Constraints
        NSLayoutConstraint.activate([
            weatherImage.heightAnchor.constraint(equalToConstant: 100),
            weatherImage.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
