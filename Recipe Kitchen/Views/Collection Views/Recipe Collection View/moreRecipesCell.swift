//
//  moreRecipesCell.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/3/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import UIKit
import Lottie

class moreRecipesCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: moreRecipesCell.self)
    
    private let loadingView = AnimationView()
    private var isLoading : Bool = false
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startLoadingAnimation() {
        if !isLoading {
            isLoading = true
            plusImageView.isHidden = true
            addSubview(loadingView)
            loadingView.play()
        }
    }
    
    func stopLoadingAnimation() {
        loadingView.stop()
        loadingView.removeFromSuperview()
        plusImageView.isHidden = false
        isLoading = false
    }
    
    private func getLoadingAnimationFilePath() -> String {
        
        let animationFileName = "loading_animation"
        if let filePath = Bundle.main.path(forResource: animationFileName, ofType: "json") {
            return filePath
        } else {
            fatalError("Couldn't get file path")
        }
    }
    
    public func configure() {
        let animationViewFilePath = getLoadingAnimationFilePath()
        loadingView.animation = Animation.filepath(animationViewFilePath, animationCache: nil)
        loadingView.loopMode = .loop
        loadingView.frame = plusImageView.frame
        plusImageView.isHidden = false
        isLoading = false
    }
}
