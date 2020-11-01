//
//  SearchViewController.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    var cellSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size = UIScreen.main.bounds.size.width / 3
        cellSize = CGSize(width: size, height: size)
        
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }

    func configure() {
        // view tap, 키패드 searchButton 클릭, collectionView 스크롤 시 키패드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
                
        Observable.merge(tap.rx.event.map({ _ in }).asObservable(),
                         collectionView.rx.contentOffset.map({ _ in }).asObservable(),
                         searchBar.rx.searchButtonClicked.asObservable())
            .bind(to: resignFirstResponder)
            .disposed(by: disposeBag)
        
        // 1초 후 입력값 방출
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ Observable.just($0) })
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        // collectionView paging 처리
        collectionView.rx.willDisplayCell
            .subscribe { [weak self] (_, indexPath) in
                self?.viewModel.fetchNextPage(indexPath.row)
            }.disposed(by: disposeBag)
        
        // prefetchItems 이미지 다운로드 설정
        collectionView.rx.prefetchItems
            .map({ $0.map({ $0.item }) })
            .bind(to: viewModel.prefetchItems)
            .disposed(by: disposeBag)
                                        
        viewModel.documents.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "SearchCollectionViewCell", cellType: SearchCollectionViewCell.self)) { (_, element, cell) in
                cell.configure(element.thumbnailUrl)
        }.disposed(by: disposeBag)
                
        collectionView.rx.modelSelected(Document.self)
            .subscribe(onNext: { [weak self] document in
                guard let self = self,
                      let navi = self.storyboard?.instantiateViewController(withIdentifier: "DetailNavigationController") as? UINavigationController,
                      let vc = navi.viewControllers.first as? DetailViewController else {
                    return
                }
                
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
                
                vc.document = document
                self.present(navi, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
               
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.hiddenEmptyView
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
                
        viewModel.viewStateStream.subscribe(onNext: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .message(message):
                self.showAlert(message)
                
            case let .error(message):
                self.showAlert(message)
                
            case .ok: break
            }
        }).disposed(by: disposeBag)
          
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest({ Observable.just($0) })
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                let size = self.collectionView.bounds.width / 3
                self.cellSize = CGSize(width: size, height: size)
                self.collectionView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    private func showAlert(_ messages: String?) {
        guard let messages = messages else { return }
        
        let alert = UIAlertController(title: "", message: messages, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private var resignFirstResponder: AnyObserver<Void> {
        return Binder(self) { me, _ in
            me.searchBar.resignFirstResponder()
        }.asObserver()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
