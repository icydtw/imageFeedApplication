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
    
    @IBOutlet var tableImage: UIImageView!
    @IBOutlet var tableLabel: UILabel!
    @IBOutlet var tableButton: UIButton!
}
