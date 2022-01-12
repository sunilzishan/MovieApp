//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import UIKit

typealias TableDataSource = UITableViewDiffableDataSource<Int, Movie>

class HomeViewController: UITableViewController {
    private var viewModel = MovieViewModel()
    private var dataSource: UITableViewDiffableDataSource<Int, Movie>?
    private var snapShot = NSDiffableDataSourceSnapshot<Int, Movie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    private func setupView() {
        self.title = "Movies"
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
    }
    
    func loadData(){
        viewModel.getMoivesListData(pagination: false) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                    self?.configureDataSource()
                case .failure(_):
                    print("Failed")
                }
            }
        }
    }
    
    func configureDataSource() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieTableViewCell")
        
        dataSource = TableDataSource(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: Movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.configureCell(movie: item)
            return cell
        }
        updateTableView()
    }
    
    func updateTableView(section: Int = 0) {
        snapShot.appendSections([section])
        snapShot.appendItems(viewModel.movies, toSection: 0)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    func handleNewItems(_ newItems: [Movie]) {
        var snapShot = dataSource?.snapshot()
        snapShot!.appendItems(newItems)
        dataSource!.apply(snapShot!, animatingDifferences: false)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }

}
