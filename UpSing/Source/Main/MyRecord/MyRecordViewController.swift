//
//  MyRecordViewController.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import UIKit

class MyRecordViewController: BaseViewController {
    let recordCell = "ChartTableViewCell"
    // 레코드 객체 생성 - 데이터를 가져오기 위함
    private var recordService: MyRecordViewModel = MyRecordViewModel.shared
    var myRecord : [MyRecord] = []
    @IBOutlet weak var recordTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "목록"
        self.setUpRecordTableView()
        self.myRecord = self.recordService.readAll()
    }

    private func setUpRecordTableView() {
        
        recordTableView.register(
            UINib(nibName: recordCell, bundle: nil),
            forCellReuseIdentifier: recordCell
        )
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.estimatedRowHeight = UITableView.automaticDimension
    }

}

extension MyRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = recordTableView.dequeueReusableCell(withIdentifier: recordCell, for: indexPath) as! ChartTableViewCell
            cell.get3(data: recordService.read(at: indexPath.row))
            cell.selectionStyle = .none
            return cell
            }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  (recordTableView.bounds.height) * 0.2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playRecordingVC = self.storyboard?.instantiateViewController(withIdentifier: "PlayRecordingViewController") as! PlayRecordingViewController
        playRecordingVC.myRecord = self.myRecord[indexPath.row]
        self.navigationController?.pushViewController(playRecordingVC, animated: true)
    }
     
}
