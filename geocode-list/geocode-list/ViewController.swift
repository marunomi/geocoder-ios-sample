//
//  ViewController.swift
//  geocode-list
//
//  Created by 新井まりな on 2020/08/15.
//  Copyright © 2020 Marina Arai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        GeocorderAPI.fetchAddress(query: "") { (areas) in
            self.areas = areas
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        let margins = view.layoutMarginsGuide
        
        
        let guide = view.safeAreaLayoutGuide
        titleView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.sizeToFit()
        
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    //MARK: View Components
    var searchBar = UISearchBar()
    var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Geocoder Search"
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        return label
    }()
    var tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    fileprivate var areas: [Area] = []
    
    func searchAddress(name: String){
        // processing here
        GeocorderAPI.fetchAddress(query: name) { (areas) in
            self.areas = areas
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UISearchBarDelegate{
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let area = areas[indexPath.row]
        cell.textLabel?.text = area.name
        cell.detailTextLabel?.text = "lat: \(String(describing: area.lat)), long: \(String(describing: area.long))"
        return cell
    }
    
    //MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        self.searchAddress(name: newText)
        return true
    }
    
}

