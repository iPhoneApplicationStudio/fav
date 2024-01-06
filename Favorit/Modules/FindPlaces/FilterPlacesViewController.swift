//
//  FilterPlacesViewController.swift
//  Favorit
//
//  Created by Abhinay Maurya on 06/01/24.
//

import UIKit

protocol FilterPlacesViewControllerDelegate: AnyObject {
    func didChangeRadiusFrequencyAndCategories(frequency: RadiusFrequency,
                                               categoties: [String])
}

class FilterPlacesViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    private var viewModel: FilterPlacesProtocol?
    private var selectedIndexPathForSectionOne: IndexPath?
    
    weak var delegate: FilterPlacesViewControllerDelegate?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = FilterPlacesViewModel()
        self.tableView.register(UITableViewCell.self, 
                                forCellReuseIdentifier: "FilterPlacesCell")
        
        self.viewModel?.bindViewModelToController = {[weak self] frequency, categories in
            self?.delegate?.didChangeRadiusFrequencyAndCategories(frequency: frequency,
                                                                  categoties: categories)
        }
    }
}

extension FilterPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.totalSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        guard let viewModel else {
            return 0
        }
        
        return viewModel.numberOfItemsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, 
                   titleForHeaderInSection section: Int) -> String? {
        guard let viewModel else {
            return nil
        }
        
        return viewModel.titleFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPlacesCell", 
                                                 for: indexPath)
        cell.selectionStyle = .none
        cell.tintColor = .accentColor
        cell.textLabel?.text = viewModel.getItemFor(index: index, section: section)
        cell.textLabel?.textColor = .accentColor
        cell.accessoryType = viewModel.getAccessoryTypeFor(index: index, section: section) == .checkmark ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        guard let viewModel else {
            return
        }
        
        viewModel.setAccessoryTypeFor(index: indexPath.row, section: indexPath.section)
        tableView.reloadData()
    }
}
