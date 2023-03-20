import UIKit

final class SingleImageViewController: UIViewController {
    var fullImageURL: URL! {
        didSet{
            guard isViewLoaded else { return }
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let sendImage = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        present(sendImage, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let horizontalScale = visibleRectSize.width / imageSize.width
        let verticalScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(horizontalScale, verticalScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setupImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let result):
                self.rescaleAndCenterImageInScrollView(image: result.image)
            case .failure(_):
                self.present(self.makeAlert(), animated: true)
            }
        }
    }
    
    private func makeAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}
