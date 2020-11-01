//
//  SearchCollectionViewCell.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    func configure(_ url: String) {
        imgView.setImage(url: url) { (_) in }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.kf.cancelDownloadTask()
        imgView.image = nil
    }
}

