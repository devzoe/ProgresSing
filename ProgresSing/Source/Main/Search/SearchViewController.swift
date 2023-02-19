//
//  SearchViewController.swift
//  Javis
//
//  Created by 남경민 on 2023/02/08.
//

import UIKit

class SearchViewController: BaseViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let searchData = SearchService()
    let chartCell = "ChartTableViewCell"
    let searchCell = "SearchTableViewCell"
    let searchWord : [String] = ["너의 모든 순간", "Ditto", "OMG", "Hype boy", "사건의 지평선", "Attention", "After Like"]
    var tableState = true
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "탐색"
        self.searchTableView.isHidden = true
        self.setUpSearchTableView()
        self.searchTableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.searchTableView.isHidden = true
        self.tableState = true
    }
    private func setUpSearchTableView() {
        searchTableView.register(
            UINib(nibName: chartCell, bundle: nil),
            forCellReuseIdentifier: chartCell
        )
        searchTableView.register(
            UINib(nibName: searchCell, bundle: nil),
            forCellReuseIdentifier: searchCell
        )
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //feedTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.tableState {
        case true :
            return searchWord.count
        case false :
            return searchData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.tableState {
        case true :
            let cell = searchTableView.dequeueReusableCell(withIdentifier: searchCell, for: indexPath) as! SearchTableViewCell
            cell.get(data: searchWord[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case false :
            let cell = searchTableView.dequeueReusableCell(withIdentifier: chartCell, for: indexPath) as! ChartTableViewCell
            let cellData = searchData.read(at: indexPath.row)
            cell.get2(data: cellData)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.tableState {
        case true :
            return  (searchTableView.bounds.height) * 0.07
        case false :
            return  (searchTableView.bounds.height) * 0.1
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.tableState {
        case true :
            print("search word")
        case false :
            print("chart")
            
            let vocalLessonVC = self.storyboard?.instantiateViewController(withIdentifier: "VocalLessonViewController") as! VocalLessonViewController
            self.tabBarController?.tabBar.isHidden = true
            appDelegate.shouldSupportAllOrientation = false
            self.navigationController?.pushViewController(vocalLessonVC, animated: true)
            
        }
    }
     
}

extension SearchViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.isFiltering = true
        //self.searchBar.showsCancelButton = true
        self.tableState = true
        self.searchTableView.separatorStyle = .singleLine
        self.searchTableView.isHidden = false
        self.searchTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //guard let text = searchController.searchBar.text?.lowercased() else { return }
        //self.filterredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
       
        //self.tableView.reloadData()
        self.searchTableView.isHidden = true
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        self.tableState = false
        self.searchTableView.isHidden = false
        self.searchTableView.separatorStyle = .none
        self.searchTableView.reloadData()
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
