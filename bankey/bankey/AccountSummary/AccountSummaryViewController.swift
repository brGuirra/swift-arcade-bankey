//
//  AccountSummaryViewController.swift
//  bankey
//
//  Created by Bruno Guirra on 26/03/22.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    
    // View Models
    var headerViewModel = AccountSummaryTableHeader.ViewModel(greetMessage: "Welcome", name: "", date: Date())
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    var tableView = UITableView()
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        logoutBarButtonItem.tintColor = .label
        
        return logoutBarButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - Layout and Style

extension AccountSummaryViewController {
    private func setup() {
        setupTableView()
        setupNavigationBar()
        fetchDataAndLoadViews()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountSummaryTableHeader.self, forHeaderFooterViewReuseIdentifier: AccountSummaryTableHeader.reuseID)
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.resuseID)
        tableView.backgroundColor = appColor
        
        // Removes white space before the header in the TableView
        tableView.sectionHeaderTopPadding = 0.0
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
}

//MARK: - UITableViewDataSource

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        
        
        let account = accountCellViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.resuseID, for: indexPath) as! AccountSummaryCell
        cell.confingure(with: account)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

//MARK: - UITableViewDelegate

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountSummaryTableHeader.reuseID) as? AccountSummaryTableHeader
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AccountSummaryTableHeader.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountSummaryCell.cellHeight
    }
}

//MARK: - Actions

extension AccountSummaryViewController {
    
    @objc func logoutTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

//MARK: - Networking

extension AccountSummaryViewController {
    
    private func fetchDataAndLoadViews() {
        fetchProfile(forUserId: "1") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let profile):
                    self.profile = profile
                    self.configureTableHeaderView(with: profile)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        fetchAccounts(forUserId: "1") { result in
            switch result {
                case .success(let accounts):
                    self.accounts = accounts
                    self.configureTableCells(with: accounts)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryTableHeader.ViewModel(greetMessage: "Good Afternoon,", name: profile.firstName, date: Date())
        
        if let headerView = tableView.headerView(forSection: 0) as? AccountSummaryTableHeader {
            headerView.configure(viewModel: vm)
        }
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map { acc in
            AccountSummaryCell.ViewModel(accountType: acc.type,
                                         accountName: acc.name,
                                         balance: acc.amount)
        }
    }
}
