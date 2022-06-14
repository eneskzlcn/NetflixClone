//
//  MediaDetailViewController.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 13.06.2022.
//

import UIKit
import WebKit

class MediaDetailViewController: UIViewController {

    struct UIConstants {
        static let overviewLabelMaximumHeight: CGFloat = 300
    }
    //MARK: UI Variables
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = UIFont(name: "Tiro Devanagari Sanskrit Regular", size: 30)
        return label
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Tiro Devanagari Sanskrit Regular", size: 18)
        label.text = "Overviewasfasfasfas asfasfa fasf asf asf asf asfasfsafasfasf asfasfasfasf af asfaskgashflasfals fjlsafjaslfalsflasfjaslfjlasflasjfalsfasjflalsfk asfasfasfasfasfasfasfasasfasfasfasfafasfa"
        label.numberOfLines =  Int(UIConstants.overviewLabelMaximumHeight / label.font.lineHeight)
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: Applying Constraints
    
    func applyConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 400)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ]
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)  
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    //MARK: Setters
    
    public func configure(with model: MediaDetailViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "\(YoutubeApiManager.Constants.embedUrl)\(model.youtubeView.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }
    // MARK: Overriding Inherited Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}
