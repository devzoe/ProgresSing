//
//  SearchViewController.swift
//  Javis
//
//  Created by 남경민 on 2023/02/08.
//

import UIKit

class SearchViewController: BaseViewController {
    let searchData = SearchService()
    let chartCell = "ChartTableViewCell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "탐색"
        //self.searchTableView.isHidden = true
        self.setUpSearchTableView()
        self.searchTableView.keyboardDismissMode = .onDrag
    }
    private func setUpSearchTableView() {
        searchTableView.register(
            UINib(nibName: chartCell, bundle: nil),
            forCellReuseIdentifier: chartCell
        )
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //feedTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: chartCell, for: indexPath) as! ChartTableViewCell
        let cellData = searchData.read(at: indexPath.row)
        cell.get2(data: cellData)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  (searchTableView.bounds.height) * 0.1
    }
     
}
