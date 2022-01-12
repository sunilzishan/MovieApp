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
    
    private func loadData(){
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
    
    private func configureDataSource() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieTableViewCell")
        
        dataSource = TableDataSource(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: Movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.configureCell(movie: item)
            return cell
        }
        updateTableView()
    }
    
    private func updateTableView(section: Int = 0) {
        snapShot.appendSections([section])
        snapShot.appendItems(viewModel.movies, toSection: 0)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    private func handleNewItems(_ newItems: [Movie]) {
        var snapShot = dataSource?.snapshot()
        snapShot!.appendItems(newItems)
        dataSource!.apply(snapShot!, animatingDifferences: false)
    }
    
    private func loadNewMovies() {
        guard !viewModel.isPaginating,
              let page = viewModel.movieResponse?.page,
              let totalPages = viewModel.movieResponse?.totalPages,
              page <= totalPages //check if it's the last page
        else {
            //Already fetching more data
            return
        }
        viewModel.getMoivesListData(pagination: true) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let response):
                    DispatchQueue.main.async {
                        let resultResponse = response as! MovieResponse
                        self?.handleNewItems(resultResponse.results)
                    }
                case .failure(_):
                    print("Failed")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = MovieDetailViewController(withMovie: viewModel.movies[indexPath.row])
        self.present(detailViewController, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height-scrollView.frame.size.height && tableView.contentSize.height > 0 {
            loadNewMovies()
        }
    }

}
