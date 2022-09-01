//
//  FavoritesViewCell.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 01.09.2022.
//

import UIKit

class FavoritesViewCell: UICollectionViewCell {
    
    var imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    let nameLabel = UILabel()
    let authorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylingViewCell()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func stylingViewCell() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        nameLabel.text = "Podcast name"
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        authorLabel.text = "Author name"
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .lightGray
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, authorLabel])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}
