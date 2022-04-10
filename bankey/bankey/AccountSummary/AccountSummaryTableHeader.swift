//
//  AccountSummaryTableHeader.swift
//  bankey
//
//  Created by Bruno Guirra on 26/03/22.
//

import UIKit

class AccountSummaryTableHeader: UITableViewHeaderFooterView {
    
    static let reuseID = "AccountSummaryTableHeader"
    static let headerHeight: CGFloat = 148
    
    let containerStackView = UIStackView()
    let infoStackView = UIStackView()
    
    let brandLabel = UILabel()
    let greetingLabel = UILabel()
    let usernameLabel = UILabel()
    let dateLabel = UILabel()
    let weatherImage = UIImageView()
    
    let shakeBellView = ShakeyBellView()
    
    struct TableHeaderViewModel {
        let greetMessage: String
        let name: String
        let date: Date
        
        var dateFormatted: String {
            return date.monthDayYearString
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        style()
        layout()
        setupShakeBell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Functions

extension AccountSummaryTableHeader {
    
    private func style() {
        contentView.backgroundColor = appColor
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .horizontal
        containerStackView.alignment = .top
        containerStackView.distribution = .fill
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        
        brandLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        brandLabel.text = "Bankey"
        
        greetingLabel.text = "Good morning"
        
        usernameLabel.text = "Bruno"
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.text = "Date"
        
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.image = UIImage(systemName: "sun.max.fill")
        weatherImage.tintColor = .systemYellow
    }
    
    private func layout() {
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
    
    private func setupShakeBell() {
        shakeBellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shakeBellView)
        
        NSLayoutConstraint.activate([
            shakeBellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shakeBellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configure(vm: TableHeaderViewModel) {
        greetingLabel.text = vm.greetMessage
        usernameLabel.text = vm.name
        dateLabel.text = vm.dateFormatted
    }
}
