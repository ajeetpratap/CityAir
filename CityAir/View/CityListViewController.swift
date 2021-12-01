//
//  CityListViewController.swift
//  CityAir
//
//  Created by Ajeet Pratap Maurya on 27/11/21.
//

import UIKit

class CityListViewController: UITableViewController {
    
    private var viewModel: CityListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CityListViewModel(cityAirService: CityAirService())
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.connect()
    }
    
    func setupView() {
        viewModel?.publishCityListData.bind({ [weak self] _ in
            self?.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cityListData.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier, for: indexPath) as! CityTableViewCell
        cell.loadCell(data: viewModel?.cityListData[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityData = viewModel?.cityListData[indexPath.row] {
            let cityDetailScreen = self.storyboard?.instantiateViewController(identifier: "CityDetailViewController") as! CityDetailViewController
            cityDetailScreen.initialCityData = cityData
            cityDetailScreen.viewModel = self.viewModel
            cityDetailScreen.name = cityData.name
            self.navigationController?.pushViewController(cityDetailScreen, animated: true)
        }
    }

}
