//
//  RepositoriesViewController.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 24/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import PagingTableView
import PKHUD
import Reachability
import SDWebImage
import UIKit

class RepositoriesViewController: UIViewController {
    
    let reachability = Reachability()!

    var repositories:[Repository] = []
    var page = 1
    
    @IBOutlet weak var tableView: PagingTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.pagingDelegate = self
        HUD.show(.progress)
        
        checkInternetConnection()
    }
    
    func loadRepositories() {
        if page > 1 {
            tableView.isLoading = true
        }
        APIConnection.getGitHubRepositories(page: page) { (result, error) in
            HUD.hide(animated: true)
            if let repositories = result {
                self.page += 1
                self.repositories.append(contentsOf: repositories)
                self.tableView.isLoading = false
            }
        }
    }

    func tableView(message :String) {
        tableView.separatorStyle = .none;
        tableView.backgroundView = Util.createMessageLabel(message: message,
                                                           width: Int(self.tableView.bounds.size.width),
                                                           height: Int(self.tableView.bounds.size.height))
    }

    func checkInternetConnection() {
        reachability.whenUnreachable = { _ in
            HUD.hide(animated: true)
            self.tableView(message: Constants.STRING_NO_INTERNET_CONNECTION)
        }
        
        reachability.whenReachable = { reachability in
            if self.repositories.count == 0 {
                HUD.show(.progress)
                self.loadRepositories()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch { print(Constants.STRING_UNABLE_NOTIFIER) }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.IDENTIFIER_PULL_REQUESTS_VIEWCONTROLLER {
            let viewController = segue.destination as! PullRequestsViewController
            let repository = (sender as! Repository)
            viewController.repositoryName = repository.name
            viewController.repositoryFullName = repository.fullName
        }
    }

}

extension RepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIER_REPOSITORY_TABLEVIEWCELL, for: indexPath) as! RepositoryTableViewCell
        
        let repository = repositories[indexPath.row]
        cell.repositoryNameLabel.text = repository.name
        cell.descriptionLabel.text = repository.description
        cell.forksQuantityLabel.text = String(describing: repository.forks ?? 0)
        cell.starsQuantityLabel.text = String(describing: repository.stars ?? 0)
        cell.userFullNameLabel.text = repository.fullName
        
        let user = repository.owner
        cell.usernameLabel.text = user?.username
        if let url = user?.photoURL {
            cell.photoImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user"))
        }
        
        return cell
    }
    
}

extension RepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        performSegue(withIdentifier: Constants.IDENTIFIER_PULL_REQUESTS_VIEWCONTROLLER, sender: repository)
    }
    
}

extension RepositoriesViewController: PagingTableViewDelegate {
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        loadRepositories()
    }
    
}
