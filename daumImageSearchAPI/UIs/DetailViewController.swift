//
//  DetailViewController.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var desView: UIView!
    @IBOutlet weak var siteNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    let disposeBag = DisposeBag()
    var document: Document?
    var loaded: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if loaded == true { return }
        updateConstraintsForSize()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
    }
    
    private func configure() {
        guard let document = document else {
            showErrorAlert("잘못된 이미지입니다")
            return
        }
        
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest({ Observable.just($0) })
            .subscribe { [weak self] (_) in
                self?.updateConstraintsForSize()
            }.disposed(by: disposeBag)
        
        closeBtn.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        imageView.setImage(url: document.imageUrl) { [weak self] (error) in
            if let e = error {
                self?.showErrorAlert(e.localizedDescription)
            }
        }
        
        if document.displaySitename.isEmpty {
            siteNameLbl.text = ""
        } else {
            siteNameLbl.text = "출처 : \(document.displaySitename)"
        }
        
        if document.dateTime.isEmpty {
            dateLbl.text = ""
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            if let date = formatter.date(from: document.dateTime) {
                formatter.dateFormat = "yyyy-MM-dd a hh:mm"
                
                if document.displaySitename.isEmpty {
                    siteNameLbl.text = "문서 작성 시간 : \(formatter.string(from: date))"
                    dateLbl.text = ""
                } else {
                    dateLbl.text = "문서 작성 시간 : \(formatter.string(from: date))"
                }
            }
        }
    }
    
    // 디바이스 width 기준 이미지 height 구하여 가운데 배치
    private func updateConstraintsForSize() {
        guard let document = document else { return }
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else { return }
        
        let topPadding = window.safeAreaInsets.left
        let bottomPadding = window.safeAreaInsets.right
        let vSize = self.view.bounds.size
        let viewWidth = vSize.width - topPadding - bottomPadding
        let h = ((viewWidth * CGFloat(document.height)) / CGFloat(document.width)).rounded(.up)
        imageViewHeightConstraint.constant = h

        let yOffset = max(0, (vSize.height - h - desView.bounds.height) / 2)
        imageViewTopConstraint.constant = yOffset
        view.layoutIfNeeded()
    }
    
    private func showErrorAlert(_ messages: String?) {
        let alert = UIAlertController(title: "", message: messages, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
