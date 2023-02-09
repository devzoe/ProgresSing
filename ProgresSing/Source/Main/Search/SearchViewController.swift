//
//  SearchViewController.swift
//  Javis
//
//  Created by 남경민 on 2023/02/08.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "탐색"
        self.searchTableView.isHidden = true
    }
}
