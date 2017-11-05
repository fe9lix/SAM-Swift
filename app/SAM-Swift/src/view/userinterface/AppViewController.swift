import UIKit
import FLAnimatedImage
import SafariServices

/// Main ViewController that controls the entire view hierarchy by processing the view updates and
/// further delegating to child components.
final class AppViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    /// Intents can be triggered using this function type.
    private var trigger: Trigger?
    /// Called when the view is loaded so that the inital action can be externally triggered.
    private var didLoad: (() -> Void)?
    
    /// This view state is only required for wired IBActions that would otherwise not be able
    /// to access data from the view descriptions.
    private var gifDetails: GifDetails?
    
    // MARK: - Lifecycle
    
    class func create(trigger: Trigger?, _ didLoad: @escaping () -> Void) -> AppViewController {
        let appViewController = UIStoryboard(name: "App", bundle: Bundle(for: self)).instantiateInitialViewController() as! AppViewController
        appViewController.trigger = trigger
        appViewController.didLoad = didLoad
        return appViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didLoad?()
    }
    
    // MARK: - Navigation Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Updates
    
    /// Takes a view description and renders it.
    /// This part should setup the view hierarchy and pass data down to child components if needed.
    /// Since we cannot simply replace the current screen with another one through markup as in a HTML/JS app,
    /// we need to do "manual diffing" here, e.g. select tabs, dismiss/present views etc.
    func display(_ view: View.Description) {
        switch view {
        case .empty: break            
        case let .gifDetails(details):
            self.gifDetails = details
            updateGif(details)
        case let .openedGif(url):
            openGif(url: url)
        }
    }
    
    /// Updates the title and the animated Gif.
    private func updateGif(_ gifDetails: GifDetails) {
        titleLabel.attributedText = gifDetails.attributedTitle
        gifImageView.animatedImage = gifDetails.animatedImage
        setButtonsEnabled(gifDetails.viewMode != .loading)
        animate(gifDetails)
    }
    
    /// Enable/disable buttons.
    private func setButtonsEnabled(_ isEnabled: Bool) {
        buttonsStackView.arrangedSubviews.forEach { ($0 as? UIButton)?.isEnabled = isEnabled }
    }
    
    /// Simple fade transition.
    private func animate(_ gifDetails: GifDetails) {
        titleLabel.alpha = 0
        if gifDetails.viewMode != .loading {
            gifImageView.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1
            self.gifImageView.alpha = 1
        }
    }
    
    /// Opens a Gif in an in-app Safari instance.
    private func openGif(url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        safariViewController.modalTransitionStyle = .crossDissolve
        safariViewController.modalPresentationStyle = .overFullScreen
        safariViewController.modalPresentationCapturesStatusBarAppearance = true
        present(safariViewController, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        trigger?(.openGif(url: nil))
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLatest(_ sender: Any) {
        trigger?(.latestGif)
    }
    
    @IBAction func didTapRandom(_ sender: Any) {
        trigger?(.randomGif)
    }
    
    @IBAction func didTapCopy(_ sender: Any) {
        guard let title = gifDetails?.title, let url = gifDetails?.sourceUrl else { return }
        trigger?(.copyGif(title: title, url: url))
    }
    
    @IBAction func didTapOpen(_ sender: Any) {
        guard let url = gifDetails?.webUrl else { return }
        trigger?(.openGif(url: url))
    }
}
