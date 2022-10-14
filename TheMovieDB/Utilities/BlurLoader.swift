//
//  BlurLoader.swift
//  TheMovieDB
//
//  Created by Sinuhé Ruedas on 14/10/22.
//

import UIKit

class BlurLoader: UIView {

  var blurEffectView: UIVisualEffectView?

  override init(frame: CGRect) {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = frame
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.blurEffectView = blurEffectView
    super.init(frame: frame)
    backgroundColor = .lightGray
    addSubview(blurEffectView)
    addLoader()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addLoader() {
    guard let blurEffectView = blurEffectView else { return }
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    blurEffectView.contentView.addSubview(activityIndicator)
    activityIndicator.center = blurEffectView.contentView.center
    activityIndicator.startAnimating()
  }
}
