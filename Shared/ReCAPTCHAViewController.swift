import UIKit
import WebKit

public class ReCAPTCHAViewController: UIViewController {
    private var webView: PWKWebView!
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

        webView = PWKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate=self
        webView.navigationDelegate=self
        webView.customUserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36"
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
