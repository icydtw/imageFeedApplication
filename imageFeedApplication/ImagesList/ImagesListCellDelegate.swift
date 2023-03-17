//
//  ImagesListCellDelegate.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 17.03.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
