#if !os(macOS)
import UIKit
#endif
import WebKit

public class ReCAPTCHAViewController: UIViewController {
    private var webView: WKWebView!
    private let viewModel: ReCAPTCHAViewModel

    init(viewModel: ReCAPTCHAViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        contentController.add(viewModel, name: "recaptcha")
        webConfiguration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.customUserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15"
       
        view = webView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didSelectCloseButton)
        )

        webView.loadHTMLString(viewModel.html, baseURL: viewModel.url)
    }
}

// MARK: - Target-Actions
private extension ReCAPTCHAViewController {
    @IBAction func didSelectCloseButton() {
        dismiss(animated: true)
    }
}
