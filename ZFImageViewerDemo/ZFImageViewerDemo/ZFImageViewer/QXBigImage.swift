//
//  QXBigImage.swift
//  QXImageCacher
//
//  Created by Richard.q.x on 16/6/14.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

typealias QXBigImageDone = () -> ()
typealias QXBigImageCode = () -> ()
typealias QXBigImageImageDone = (_ image: UIImage?) -> ()
typealias QXBigImageWebDone = (_ image: UIImage?, _ error: NSError?) -> ()
typealias QXBigImageProgress = (_ percentage: CGFloat) -> ()

class QXBigImage: NSObject {
    
    static var tasks = [URL: QXBigImageTask]()
    
    class func image(_ url: URL, progress: QXBigImageProgress?, done: QXBigImageWebDone?) {
        
        if let task = tasks[url] {
            if let progress = progress {
                task.progresses.append(progress)
            }
            if let done = done {
                task.dones.append(done)
            }
            task.done = {
                task.cancel()
                tasks.removeValue(forKey: url)
            }
            
        } else {
            let task = QXBigImageTask(url: url)
            if let progress = progress {
                task.progresses.append(progress)
            }
            if let done = done {
                task.dones.append(done)
            }
            task.done = {
                task.cancel()
                tasks.removeValue(forKey: url)
            }
            tasks[url] = task
            task.start()
        }
    }
    
}

let QXBigImageDownloadQueue = OperationQueue()
class QXBigImageTask: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    var url: URL
    var percentage: CGFloat = 0
    var progresses = [QXBigImageProgress]()
    var dones = [QXBigImageWebDone]()
    var done: QXBigImageDone?
    
    func start() {
        let request = URLRequest(url: self.url)
        let task = self.session.dataTask(with: request)
        task.resume()
    }
    
    func cancel() {
        session.invalidateAndCancel()
    }
    
    fileprivate lazy var session: Foundation.URLSession = {
        let cfg = URLSessionConfiguration.default
        let one = Foundation.URLSession(configuration: cfg, delegate: self, delegateQueue: QXBigImageDownloadQueue)
        return one
    }()
    
    fileprivate var tmpData = NSMutableData()
    
    required init(url: URL) {
        self.url = url
        super.init()
    }
    
    //MARK: NSURLSessionDelegate
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        DispatchQueue.main.sync(execute: {
            for done in self.dones {
                done(nil, error as NSError?)
            }
            self.done?()
        })
    }

    //MARK: NSURLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        var image: UIImage?
        if error == nil {
            image = UIImage(data: tmpData as Data)
        }
        DispatchQueue.main.sync(execute: {
            for done in self.dones {
                done(image, error as NSError?)
            }
            self.done?()
        })
    }
    
    //MARK: NSURLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let response = dataTask.response as! HTTPURLResponse
        if response.statusCode == 200 {
            tmpData.append(data)
            percentage = CGFloat(dataTask.countOfBytesReceived) / CGFloat(dataTask.countOfBytesExpectedToReceive)
            DispatchQueue.main.sync(execute: {
                for progress in self.progresses {
                    progress(self.percentage)
                }
            })
        }
    }
}
