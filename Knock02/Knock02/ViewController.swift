//
//  ViewController.swift
//  Knock02
//
//  Created by Takuya OHASHI on 2017/07/07.
//  Copyright © 2017年 Takuya OHASHI. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var notificationToken: NotificationToken!
    var realm: Realm!
    var items = List<TodoItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ToDo List"
        delegate.todoItem = nil

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self, action: #selector(addItem))
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        setupRealm()
    }
    
    func setupRealm() {
        realm = try! Realm()
        
        // 初めてアプリを起動した時
        if realm.objects(ItemList.self).first == nil {
            let list = ItemList()
            try! realm.write {
                realm.add(list)
            }
        }
        // 必ず入ってるので force unwrap する
        items = realm.objects(ItemList.self).first!.items

        func updateList() {
            self.tableView.reloadData()
        }
        updateList()

        // Realm が更新されたらリストを更新する
        notificationToken = self.realm.addNotificationBlock { _ in
            updateList()
        }
    }
    
    func addItem() {
        let addItemViewController = AddItemViewController()
        // 自身を保持してる navigationController を使用する
        navigationController?.pushViewController(addItemViewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let item = self.delegate.todoItem {
            try! self.realm.write {
                self.items.append(item)
            }
            self.delegate.todoItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 行の数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // デフォルトの　cell を返す
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.alpha = item.done ? 0.5 : 1
        return cell
    }
    
    // 削除するため
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            try! self.realm.write {
                let item = self.items[indexPath.row]
                self.realm.delete(item)
            }
        }
        deleteButton.backgroundColor = UIColor.red
        return [deleteButton]
    }
    
    // 入れ替える
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            items.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
}
