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
    let searchCell = "SearchTableViewCell"
    let searchWord : [String] = ["너의 모든 순간", "Ditto", "OMG", "Hype boy", "사건의 지평선", "Attention", "After Like"]
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "탐색"
        //self.searchTableView.isHidden = true
        self.setUpSearchTableView()
        self.searchTableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
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

extension SearchViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.isFiltering = true
        self.searchBar.showsCancelButton = true
        //self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //guard let text = searchController.searchBar.text?.lowercased() else { return }
        //self.filterredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
       
        //self.tableView.reloadData()
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        //self.tableView.reloadData()
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        //self.tableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.tableView.reloadData()
    }
    
    // 서치바 키보드 내리기
    override func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
