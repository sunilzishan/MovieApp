//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    private var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: AsyncImage?
    
    func configureCell(movie: Movie) {
        self.titleLabel.text = movie.title
        if let releaseDate = movie.releaseDate {
            self.releaseYearLabel.text = String(releaseDate.prefix(4))
        }
        self.setPosterImage(movie: movie)
        setupViews()
    }
    
    private func setPosterImage(movie: Movie) {
        image = AsyncImage(url: movie.posterFullPath)
        self.posterImage.image = image?.image
        image?.startDownload()
        image?.completeDownload = { [weak self] image in
            self?.posterImage.image = image
        }
    }
    
    private func setupViews() {
        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.withSize(17)
        releaseYearLabel.font = releaseYearLabel.font.withSize(14)
        self.contentView.addSubview(posterImage)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(releaseYearLabel)
        setupConstraints()
        setNeedsLayout()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            posterImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.248),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            
            releaseYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseYearLabel.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 12),
            releaseYearLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            releaseYearLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
