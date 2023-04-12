//
//  ViewController.swift
//  table
//
//  Created by Alisa Mylnikova on 02.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var models: [Model] = []
    var timer: Timer?

    private let cellReuseIdentifier = "cell"
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.transform = CGAffineTransform(rotationAngle: .pi)

        //tableView.register(Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = dataSource

        models = (0..<10).map { _ in Model(property: .three) }
        models[1].property = .two
        models[0].property = .one

        update(with: models, animate: true)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    @objc func fireTimer() {
        let prevModels = models
        models[1].property = .three
        models[0].property = .two
        update(with: models, animate: false)

        models.insert(Model(), at: 0)
        update(with: models, animate: true)
    }

    func update(with list: [Model], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Model>()
        snapshot.appendSections([0])
        snapshot.appendItems(list, toSection: 0)
        dataSource.defaultRowAnimation = .top
        dataSource.apply(snapshot, animatingDifferences: animate)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Int, Model> {
        let reuseIdentifier = cellReuseIdentifier

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell
                cell?.titleLabel?.text = model.text
                cell?.propertyLabel?.text = model.property.rawValue
                cell?.bgView?.backgroundColor = model.property.color
                cell?.bgView?.layer.cornerRadius = 10
                cell?.transform = CGAffineTransform(rotationAngle: .pi)
                return cell ?? UITableViewCell()
            }
        )
    }
}

