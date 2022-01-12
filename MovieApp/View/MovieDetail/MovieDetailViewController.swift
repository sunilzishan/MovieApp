//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var movie: Movie
    private var image: AsyncImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    init(withMovie movie: Movie) {
           self.movie = movie
           super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        titleLabel.text = movie.title
        if let releaseDate = movie.releaseDate {
            self.releaseYearLabel.text = String(releaseDate.prefix(4))
        }
        descriptionLabel.text = movie.overview
        self.setPosterImage(movie: movie)
        setupViews()
    }
    
    private func setPosterImage(movie: Movie) {
        image = AsyncImage(url: movie.backdropFullPath)
        self.posterImage.image = image?.image
        image?.startDownload()
        image?.completeDownload = { [weak self] image in
            self?.posterImage.image = image
        }
    }
    
    private func setupViews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.withSize(22)
        descriptionLabel.numberOfLines = 0
        view.backgroundColor = .white
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(releaseYearLabel)
        view.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            posterImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            posterImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            posterImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.268949),
            
            titleLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            releaseYearLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            releaseYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseYearLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            releaseYearLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
        ])
    }

}
