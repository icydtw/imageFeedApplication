import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    var ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<5).map{ "\($0)" }
    private var photos: [Photo] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(forName: ImagesListService.notificationPhotos, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let destinationController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: "\(photosName[indexPath.row])_full_size") ?? UIImage(named: photosName[indexPath.row])
            destinationController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) { (result: Result<Void, Error>) in
            switch result {
            case .success(_):
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(liked: self.photos[indexPath.row].isLiked)
            case .failure(_):
                return
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        let url = URL(string: photos[indexPath.row].thumbImageURL)
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(with: url, placeholder: UIImage(named: "Stub"))
        cell.dateLabel.text = dateFormatter.string(from: Date())
        cell.setIsLiked(liked: photos[indexPath.row].isLiked)
    }
    
    private func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            let oldCount = photos.count
            let newCount = ImagesListService.shared.photos.count
            photos = ImagesListService.shared.photos
            var indexes: [IndexPath] = []
            if oldCount != newCount {
                for i in oldCount..<newCount {
                    indexes.append(IndexPath(row: i, section: 0))
                }
                self.tableView.insertRows(at: indexes, with: .automatic)
            }
        }
    }
}
