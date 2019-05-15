//
//  ZFImageViewerViewController.swift
//  XELAppProject
//
//  Created by 陈兆方 on 2019/5/9.
//  Copyright © 2019 WangBinPeng. All rights reserved.
//

import UIKit
import Photos

class ZFImageViewerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	private var currentIndex = -1
	
	private var imageItems = [UIImage]()
	
	private var urlItems = [String]()
	
	private lazy var flowLayout: UICollectionViewFlowLayout = {
		let one = UICollectionViewFlowLayout()
		one.itemSize = CGSize(width: UIScreen.main.bounds.size.width + 10 * 2, height: UIScreen.main.bounds.size.height)
		one.minimumInteritemSpacing = 0
		one.minimumLineSpacing = 0
		one.scrollDirection = .horizontal
		return one
	}()
	
	private lazy var collectionView: UICollectionView = {
		let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
		one.backgroundColor = UIColor.clear
		one.dataSource = self
		one.delegate = self
		one.isPagingEnabled = true
		one.bounces = true
		one.showsHorizontalScrollIndicator = false
		one.showsVerticalScrollIndicator = false
		one.register(ZFImageCell.self, forCellWithReuseIdentifier: "ZFImageCell")
		one.translatesAutoresizingMaskIntoConstraints = false
		return one
	}()
	
	private lazy var pageControl: UIPageControl = {
		let one = UIPageControl()
		one.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 50)
		return one
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
		

	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if currentIndex >= 0 {
			let indexPath = IndexPath(item: currentIndex, section: 0)
			collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
			currentIndex = -1
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let scroll = UIScrollView()
		view.addSubview(scroll)
		scroll.isHidden = true
		view.backgroundColor = UIColor.black
		view.addSubview(collectionView)
		view.addSubview(pageControl)
		
		let a = NSLayoutConstraint.init(item: collectionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width + 10 * 2)
		let b = NSLayoutConstraint.init(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.height)
		let c = NSLayoutConstraint.init(item: collectionView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
		let d = NSLayoutConstraint.init(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		
		view.addConstraints([a, b, c, d])

		let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
		view.addGestureRecognizer(tap)
	}
	
	@objc convenience init(images: NSMutableArray, index: Int = 0) {
		self.init()
		imageItems = images as! [UIImage]
		collectionView.reloadData()
		currentIndex = index
		pageControl.numberOfPages = imageItems.count
		pageControl.currentPage = currentIndex
	}
	
	@objc convenience init(urls: NSMutableArray, index: Int = 0) {
		self.init()
		urlItems = urls as? [String] ?? []
		collectionView.reloadData()
		self.currentIndex = index
		pageControl.numberOfPages = urlItems.count
		pageControl.currentPage = currentIndex
	}
	
	@objc func tap(_ recognizer: UITapGestureRecognizer) {
		self.dismiss(animated: false, completion: nil)
	}
	
	override var prefersStatusBarHidden : Bool {
		return false
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if imageItems.count > 0 {
			return imageItems.count
		} else if urlItems.count > 0 {
			return urlItems.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZFImageCell", for: indexPath) as! ZFImageCell
		if imageItems.count > 0 {
			cell.imageItem = imageItems[indexPath.item]
		} else if urlItems.count > 0 {
			cell.urlItem = urlItems[indexPath.item]
		}
		cell.respondSaveImage = { [weak self] image in
			let alertController = UIAlertController(title: "保存图片", message: nil,
													preferredStyle: .actionSheet)
			let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
			let archiveAction = UIAlertAction(title: "保存", style: .default, handler: { (act) in
				self?.saveImage(image)
			})
			alertController.addAction(cancelAction)
			alertController.addAction(archiveAction)
			self?.present(alertController, animated: true, completion: nil)
		}
		return cell
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let deltaX = scrollView.contentOffset.x
		let idx = Int(deltaX / (UIScreen.main.bounds.size.width + 20))
		self.pageControl.currentPage = idx
	}
	
	private func saveImage(_ image: UIImage) {
		PHPhotoLibrary.shared().performChanges({
			PHAssetChangeRequest.creationRequestForAsset(from: image)
		}, completionHandler: { success, error in
			if success {
				print("保存成功")
			} else {
				print("保存失败")
			}
		})
	}
	
}


