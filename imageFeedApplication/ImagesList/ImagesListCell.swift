//
//  ImagesListCell.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 20.12.2022.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
}
