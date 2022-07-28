//
//  FavoritesViewCell.swift
//  PodcastsCourse
//
//  Created by Maks Kokos on 28.07.2022.
//

import UIKit

class FavoritesViewCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"))
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    
    fileprivate func labelStyling() {
        nameLabel.text = "Name Label"
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        artistLabel.text = "Artist Label"
        artistLabel.font = .systemFont(ofSize: 14)
        artistLabel.textColor = .lightGray
    }
    
    fileprivate func setupViews() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistLabel])
        stackView.axis = .vertical
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelStyling()
        setupViews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
