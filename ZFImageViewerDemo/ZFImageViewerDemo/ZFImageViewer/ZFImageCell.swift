//
//  ZFImageCell.swift
//  XELAppProject
//
//  Created by 陈兆方 on 2019/5/9.
//  Copyright © 2019 WangBinPeng. All rights reserved.
//

import UIKit

class ZFImageCell: UICollectionViewCell, UIScrollViewDelegate {
	
	var respondSaveImage: ((_ image: UIImage) -> ())?
	
	var urlItem: String? {
		didSet {
			photoView.image = nil
			if let url = urlItem {
				self.loadingView.startAnimating()
				self.photoView.qx_setBigImage(URL(string: url)!, progress: { (per) in
					print(per)
				}) {
					self.loadingView.stopAnimating()
					self.fixImageSize()
				}
			}
		}
	}
	
	var imageItem: UIImage? {
		didSet {
			photoView.image = nil
			if let image = imageItem {
				self.photoView.image = image
				self.fixImageSize()
			}
		}
	}
	
	func fixImageSize() {
		if let image = photoView.image {
			var w: CGFloat = 0
			var h: CGFloat = 0
			var x: CGFloat = 0
			var y: CGFloat = 0
			let winSize = UIScreen.main.bounds.size
			let imgSize = image.size
			
			if imgSize.width <= 0 || imgSize.height <= 0 {
				photoView.frame = CGRect.zero
				scrollView.contentSize = CGSize.zero
				scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
				scrollView.maximumZoomScale = 0
				return
			}
			
			let k = winSize.width / winSize.height
			let k1 = imgSize.width / imgSize.height
			
			if (k > k1) {
				h = winSize.height
				w = h * k1
				x = (winSize.width - w) / 2
				y = 0
			} else {
				w = winSize.width
				h = w / k1
				x = 0
				y = (winSize.height - h) / 2
			}
			
			photoView.frame = CGRect(x: 0, y: 0, width: w, height: h)
			scrollView.contentSize = CGSize(width: w, height: h)
			scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: 0, right: 0)
			scrollView.maximumZoomScale = 3 * imgSize.width * imgSize.height / 1000 * 1000
		}
	}
	
	lazy var scrollView: UIScrollView = {
		let one = UIScrollView()
		one.maximumZoomScale = 2.0
		one.minimumZoomScale = 1.0
		one.delegate = self
		one.showsHorizontalScrollIndicator = false
		one.showsVerticalScrollIndicator = false
		one.backgroundColor = UIColor.clear
		one.translatesAutoresizingMaskIntoConstraints = false
		return one
	}()
	
	lazy var photoView: UIImageView = {
		let one = UIImageView()
		one.isUserInteractionEnabled = true
		return one
	}()
	
	lazy var loadingView: UIActivityIndicatorView = {
		let one = UIActivityIndicatorView()
		one.hidesWhenStopped = true
		one.translatesAutoresizingMaskIntoConstraints = false
		return one
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(scrollView)
		scrollView.addSubview(photoView)
		scrollView.addSubview(loadingView)
		
		let a = NSLayoutConstraint.init(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
		let b = NSLayoutConstraint.init(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
		let c = NSLayoutConstraint.init(item: scrollView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
		let d = NSLayoutConstraint.init(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
		let e = NSLayoutConstraint.init(item: scrollView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 10)
		let f = NSLayoutConstraint.init(item: scrollView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 10)
		self.contentView.addConstraints([a, b, c, d, e, f])

		let long = UILongPressGestureRecognizer(target: self, action: #selector(longGes(_:)))
		self.addGestureRecognizer(long)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func longGes(_ recognizer: UILongPressGestureRecognizer) {
		if recognizer.state == .began {
			if let image = photoView.image {
				self.respondSaveImage?(image)
			}
		}
	}
	
	//MARK: UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return photoView
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		if let view = view {
			var offsetX = (scrollView.bounds.size.width - view.frame.size.width) * 0.5
			if (offsetX < 0) {
				offsetX = 0;
			}
			var offsetY = (scrollView.bounds.size.height - view.frame.size.height) * 0.5
			if (offsetY < 0) {
				offsetY = 0;
			}
			scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
		}
	}
	
}
