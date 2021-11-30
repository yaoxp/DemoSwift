//
//  DesignPatternsViewController.swift
//  DemoSwift
//
//  Created by yaoxp on 2021/11/30.
//  Copyright © 2021 yaoxp. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - DesignPatterns
enum DesignPatterns: Int, CaseIterable {
    case simpleFactory
    case factory
}

extension DesignPatterns {
    var name: String {
        switch self {
        case .simpleFactory:
            return "简单工厂模式"
        case .factory:
            return "工厂模式"
        }
    }

    func enaction() {
        switch self {
        case .simpleFactory:
            let factory = SFFactory.operationBreakfast(.manTou)
            factory.productBreakfast()
        case .factory:
            print("")
        }
    }
}

// MARK: - DesignPatternsViewController
class DesignPatternsViewController: UIViewController {

    // MARK: - private property
    private let tableView = UITableView()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

}

// MARK: - UITableViewDataSource
extension DesignPatternsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = DesignPatterns(rawValue: indexPath.row)?.name ?? "error"
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DesignPatterns.allCases.count
    }
}

// MARK: - UITableViewDelegate
extension DesignPatternsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pattern = DesignPatterns(rawValue: indexPath.row)
        pattern?.enaction()
    }
}

// MARK: - UI
private extension DesignPatternsViewController {
    func setupUI() {
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
