//
//  ViewController.swift
//  table
//
//  Created by Alisa Mylnikova on 02.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var models: [Model] = []
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.transform = CGAffineTransform(rotationAngle: .pi)

        models = (0..<10).map { _ in Model(property: .three) }
        models[1].property = .two
        models[0].property = .one

        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    @objc func fireTimer() {
        let prevModels = models
        models[1].property = .three
        models[0].property = .two
        models.insert(Model(), at: 0)

        tableView.beginUpdates()
        let dif = models.difference(from: prevModels)

        // if a single message has both a removal and an insertion - then it's an edit and shouldn't be animated
        // collect all duplicate ids to determine where the edits are
        var ids: [String] = []
        var editIds: [String] = []
        for change in dif {
            switch change {
            case let .remove(_, model, _), let .insert(_, model, _):
                if ids.contains(model.id) {
                    editIds.append(model.id)
                } else {
                    ids.append(model.id)
                }
            }
        }

        // animate insertions and removals, but not edits
        for change in dif {
            switch change {
            case let .remove(offset, model, _):
                let isEdit = editIds.contains(model.id)
                print("removal", isEdit ? "edit" : "", offset, model.property, model.text.prefix(10))

                tableView.deleteRows(at: [IndexPath(row: offset, section: 0)], with: isEdit ? .none: .top)
            case let .insert(offset, model, _):
                let isEdit = editIds.contains(model.id)
                print("insertion", isEdit ? "edit" : "", offset, model.property, model.text.prefix(10))

                tableView.insertRows(at: [IndexPath(row: offset, section: 0)], with: isEdit ? .none: .top)
            }
        }
        print()

        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell
        cell?.titleLabel?.text = models[indexPath.row].text
        cell?.propertyLabel?.text = models[indexPath.row].property.rawValue
        cell?.bgView?.backgroundColor = models[indexPath.row].property.color
        cell?.bgView?.layer.cornerRadius = 10
        cell?.transform = CGAffineTransform(rotationAngle: .pi)
        return cell ?? UITableViewCell()
    }
}

