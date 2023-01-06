//
//  SingleImageViewController.swift
//  imageFeedApplication
//
//  Created by Илья Тимченко on 06.01.2023.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
