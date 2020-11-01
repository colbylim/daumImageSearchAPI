//
//  SearchViewModel.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

enum SearchViewStateType {
    case ok
    case message(message: String?)
    case error(message: String?)
}

class SearchViewModel: ViewStateStreamModel<SearchViewStateType> {
    
    private var page: Int = 1
    private var isEnd: Bool = false
    private var fetching: Bool = false
    
    let documents = BehaviorRelay<[Document]>(value: [])
    let searchText = BehaviorRelay<String>(value: "")
    let prefetchItems = BehaviorRelay<[Int]>(value: [])
    let hiddenEmptyView = BehaviorRelay<Bool>(value: true)
    
    override init() {
        super.init()

        searchText.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] t in
                self?.changedSearchText(t)
            })
            .disposed(by: disposeBag)
        
        prefetchItems.asObservable()
            .flatMapLatest({ Observable.just($0) })
            .subscribe(onNext: { [weak self] rows in
                guard let self = self else { return }
                let urls = rows.compactMap({ URL(string: self.documents.value[$0].thumbnailUrl) })
                ImagePrefetcher(urls: urls).start()
                
            })
            .disposed(by: disposeBag)
    }
 
    func changedSearchText(_ text: String) {
        page = 1
        isEnd = false
        
        if !documents.value.isEmpty {
            documents.accept([])
        }
        
        fetch(text)
    }
    
    func fetchNextPage(_ row: Int) {
        if row == documents.value.count - 1 {
            fetch(searchText.value)
        }
    }
    
    func fetch(_ text: String?) {
        if fetching == true || isEnd == true {
            return
        }
        
        guard let query = text, query.isEmpty == false else {
            hiddenEmptyView.accept(true)
            return
        }
        
        fetching = true
        
        APIManager.call(KakaoImageSearchAPI.get(query: query, page: page))
            .subscribe { [weak self] (res) in
                guard let self = self else { return }
                self.fetching = false
                
                if self.page == 1 {
                    self.hiddenEmptyView.accept(!res.documents.isEmpty)
                }
                
                self.page += 1
                self.isEnd = res.meta.isEnd
                
                if !res.documents.isEmpty {
                    self.documents.accept(self.documents.value + res.documents)
                }
            } onError: { [weak self] (error) in
                self?.fetching = false
                self?.viewState = .error(message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
