//
//  SettingViewController.swift
//  UpSing
//
//  Created by 남경민 on 2023/03/30.
//

import UIKit

class SettingViewController: UIViewController {
    lazy var dataManager: RankingDataManager = RankingDataManager()
    let cellId = "RankingTableViewCell"
    
    var ranking : [Ranking] = []
    
    @IBOutlet weak var rankingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title = "랭킹"
        self.setUpTableView()
        self.dataManager.readRanking(delegate: self)
    }
    func setUpTableView() {
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }

}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RankingTableViewCell
        let cellData = ranking[indexPath.row]
        cell.get(index: indexPath.row+1,data: cellData)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  (rankingTableView.bounds.height) * 0.15
    }
}

extension SettingViewController {
    func didSuccess(ranking: [Ranking]){
        print("success :\(ranking)")
        print("self :\(self.ranking)")
        self.ranking = ranking
        print("self :\(self.ranking)")
        print("count :\(self.ranking.count)")
        rankingTableView.reloadData()
    }
    /*
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
     */
}
