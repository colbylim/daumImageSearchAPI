//
//  Extension+UIImageView.swift
//  daumImageSearchAPI
//
//  Created by colbylim on 2020/11/01.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String?, failImg: UIImage? = UIImage(named: "fail"), completion: @escaping (Error?) -> Void) {
        guard let s = url, let _url = URL(string: s) else {
            image = failImg
            return
        }
        
        kf.setImage(with: _url,
                    placeholder: nil,
                    options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                    progressBlock: { _, _ in
                        
                    }) { [weak self] (result) in
            switch result {
            case .success:
                completion(nil)
                
            case .failure(let error):
                if !error.isTaskCancelled && !error.isNotCurrentTask {
                    self?.image = failImg
                    print("image failed: \(error.localizedDescription)")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
