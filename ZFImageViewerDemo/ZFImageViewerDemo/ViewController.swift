//
//  ViewController.swift
//  ZFImageViewerDemo
//
//  Created by 陈兆方 on 2019/5/15.
//  Copyright © 2019 陈兆方. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	lazy var imageURLs: [String] = [
		"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557922969316&di=25e5ece0fb194e06c76caf50c5adb2e3&imgtype=0&src=http%3A%2F%2Fp2.qhimgs4.com%2Ft01ab2be7821e2c87c1.jpg",
		"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557922969316&di=8c72c75864298bf2b2d1b10f6774b31b&imgtype=0&src=http%3A%2F%2Fdesk.fd.zol-img.com.cn%2Ft_s960x600c5%2Fg5%2FM00%2F02%2F05%2FChMkJlbKyaGIYHY0AAdqId0Xs0kAALIQQJWRHwAB2o5600.jpg",
		"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557922969314&di=ea1c26037f33a92c3beb4b72fadd81e2&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201305%2F04%2F20130504023520_SGian.jpeg",
		"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557922969313&di=d32c86c6ecb3ee866ee8d6fc9a9b2601&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201309%2F20%2F20130920120552_mNUuk.jpeg",
		"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557923213318&di=471f3fef1fbf16dc4f2effd46fc27801&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201303%2F31%2F20130331124639_svhNV.thumb.700_0.jpeg",
	]
	
	lazy var btn: UIButton = {
		let one = UIButton()
		one.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
		one.setTitle("show", for: .normal)
		one.backgroundColor = UIColor.orange
		one.setTitleColor(UIColor.white, for: .normal)
		one.layer.cornerRadius = 10
		one.addTarget(self, action: #selector(click), for: .touchUpInside)
		return one
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		view.addSubview(btn)
	}
	
	@objc func click() {
		let vc = ZFImageViewerViewController(urls: NSMutableArray.init(array: self.imageURLs), index: 0)
		self.present(vc, animated: true, completion: nil)
	}
}
