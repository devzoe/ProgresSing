//
//  VideoViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import UIKit

class VideoViewController: BaseViewController {
    let chartData = ChartService()
    let chartCell = "ChartTableViewCell"
    @IBOutlet weak var popularityButton: UIButton!
    @IBOutlet weak var balladButton: UIButton!
    @IBOutlet weak var danceButton: UIButton!
    @IBOutlet weak var hiphopButton: UIButton!
    @IBOutlet weak var popsongButton: UIButton!
    
    @IBOutlet weak var chartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "차트"
        self.setUpUI()
        self.setUpChartTableView()
    }
    

    func setUpUI() {
        self.popularityButton.setCornerRadius(25)
        self.balladButton.setCornerRadius(25)
        self.danceButton.setCornerRadius(25)
        self.hiphopButton.setCornerRadius(25)
        self.popsongButton.setCornerRadius(25)
        
    }
    
    private func setUpChartTableView() {
        chartTableView.register(
            UINib(nibName: chartCell, bundle: nil),
            forCellReuseIdentifier: chartCell
        )
        chartTableView.delegate = self
        chartTableView.dataSource = self
        //feedTableView.rowHeight = UITableView.automaticDimension
        chartTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chartTableView.dequeueReusableCell(withIdentifier: chartCell, for: indexPath) as! ChartTableViewCell
        let cellData = chartData.read(at: indexPath.row)
        cell.get(data: cellData)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  (chartTableView.bounds.height) * 0.1
    }
     
}
