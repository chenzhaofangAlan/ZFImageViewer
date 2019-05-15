//
//  QXBigImageUpdater.swift
//  QXImageCacher
//
//  Created by Richard.q.x on 16/6/14.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

extension UIImageView {
    func qx_setBigImage(_ url: URL, progress: QXBigImageProgress?, done: @escaping () -> ()) {
        updateBigImage(url, progress: progress) { [weak self] (image, error) in
            if let image = image {
                self?.image = image
				done()
            }
			if let err = error {
				print(err)
			}
        }
    }
}

private var QX_BIG_IMAGE_ASSOCIATE_OBJ_KEY: UInt = 123782130
extension NSObject {
    func updateBigImage(_ url: URL, progress: QXBigImageProgress?, done: @escaping QXBigImageWebDone) {
        objc_setAssociatedObject(self, &QX_BIG_IMAGE_ASSOCIATE_OBJ_KEY, url, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        QXBigImage.image(url, progress: { [weak self] (percentage) in
            if let s = self {
                if let url1 = objc_getAssociatedObject(s, &QX_BIG_IMAGE_ASSOCIATE_OBJ_KEY) as? URL {
                    if url.absoluteString == url1.absoluteString  {
                        progress?(percentage)
                    }
                }
            }
            }) { [weak self] (image, error) in
                if let s = self {
                    if let url1 = objc_getAssociatedObject(s, &QX_BIG_IMAGE_ASSOCIATE_OBJ_KEY) as? URL {
                        if url.absoluteString == url1.absoluteString  {
                            done(image, error)
                        }
                    }
                }
        }
    }
}
