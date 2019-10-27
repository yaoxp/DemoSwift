//
//  OffScreenTableViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/10/22.
//  Copyright © 2018 yaoxp. All rights reserved.
//

import UIKit

class OffScreenTableViewController: UIViewController {

    let tableView = UITableView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
    let cellID = "tableviewcell"
    var cellType: CustomCellRenderType = .cornerRadiusOffScreenRender {
        didSet {
            title = cellType.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = cellType.description
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OffScreenTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OffScreenTableViewControllerCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        cell.fillCell(renderType: cellType)
        return cell
    }
}
