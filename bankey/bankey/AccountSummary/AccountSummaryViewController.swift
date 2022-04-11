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
    
    // Components
    var tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    // Networking
    var profileManager: ProfileManageable = ProfileManager()
    
    var isDataLoaded = false
    
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
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountSummaryTableHeader.self, forHeaderFooterViewReuseIdentifier: AccountSummaryTableHeader.reuseID)
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
}

//MARK: - UITableViewDataSource

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        
        let account = accountCellViewModels[indexPath.row]
        
        if isDataLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.confingure(with: account)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        
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
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset() {
        profile = nil
        accounts = []
        isDataLoaded = false
    }
}

//MARK: - Networking

extension AccountSummaryViewController {
    
    private func fetchData() {
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let profile):
                    self.profile = profile
                case .failure(let error):
                    self.displayError(error)
            }
            group.leave()
        }
        
        group.enter()
        fetchAccounts(forUserId: userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let accounts):
                    self.accounts = accounts
                case .failure(let error):
                    self.displayError(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            self.tableView.refreshControl?.endRefreshing()
            
            guard let profile = self.profile else { return }
            
            self.isDataLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
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
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
            case .serverError:
                title = "Server Error"
                message = "We could not process your request. Please try again."
            case .decodingError:
                title = "Network Error"
                message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Unit testing
extension AccountSummaryViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
        return titleAndMessage(for: error)
    }
}
