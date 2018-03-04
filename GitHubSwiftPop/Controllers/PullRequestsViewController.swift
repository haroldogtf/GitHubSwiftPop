//
//  PullRequestsViewController.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 25/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import PagingTableView
import PKHUD
import Reachability
import SDWebImage
import UIKit

class PullRequestsViewController: UIViewController {

    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: PagingTableView!

    let reachability = Reachability()!

    var repositoryName:String!
    var repositoryFullName:String!
    
    var pullRequests:[PullResquest] = []
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNavigationItem.title = repositoryName
        
        tableView.pagingDelegate = self
        HUD.show(.progress)
        
        checkInternetConnection()
    }
    
    func loadPullRequests() {
        if page > 1 {
            tableView.isLoading = true
        }
        APIConnection.getPullResquestsFrom(repository: repositoryFullName, page: page) { (result, error) in
            HUD.hide(animated: true)
            if let pullResquests = result {
                self.page += 1
                self.pullRequests.append(contentsOf: pullResquests)
                self.tableView.isLoading = false
                
                if self.pullRequests.count == 0 {
                    self.tableView(message: Constants.STRING_NO_PULL_RESQUEST)
                }
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
            if self.pullRequests.count == 0 {
                HUD.show(.progress)
                self.loadPullRequests()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch { print("Unable to start notifier") }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.IDENTIFIER_PULL_REQUESTS_DETAIL_VIEWCONTROLLER {
            let viewController = segue.destination as! PullRequestDetailViewController
            let pullRequest = (sender as! PullResquest)
            viewController.repositoryName = pullRequest.title
            viewController.url = pullRequest.url
        }
    }
    
}

extension PullRequestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIER_PULL_REQUESTS_TABLEVIEWCELL, for: indexPath) as! PullRequestTableViewCell
        
        let pullRequest = pullRequests[indexPath.row]
        cell.repositoryNameLabel.text = pullRequest.title
        cell.descriptionLabel.text = pullRequest.body
        cell.userFullNameLabel.text = repositoryFullName
        
        let user = pullRequest.user
        cell.usernameLabel.text = user?.name
        if let url = user?.photoURL {
            cell.photoImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user"))
        }

        return cell
    }
    
}

extension PullRequestsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pullRequest = pullRequests[indexPath.row]
        performSegue(withIdentifier: Constants.IDENTIFIER_PULL_REQUESTS_DETAIL_VIEWCONTROLLER, sender: pullRequest)
    }
    
}

extension PullRequestsViewController: PagingTableViewDelegate {
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        loadPullRequests()
    }
    
}
