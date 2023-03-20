import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    @IBAction private func likeButtonTapped(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.kf.cancelDownloadTask()
    }
    
    func setIsLiked(liked: Bool) {
        let likeImage = liked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.imageView?.image = likeImage
    }
}
