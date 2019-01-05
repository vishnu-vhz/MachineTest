//
//  WalkThroughViewController.swift
//  testDemo
//
//  Created by SpegaTechnology on 1/3/19.
//

import UIKit

class WalkThroughViewController: UIViewController {
    var index: Int = 0
    var titleText = ""
    var imageUrl = ""
    var total = 0
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var testPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        titleLabel.text = titleText
        setImage(Url: imageUrl)
        testPageControl.numberOfPages = total
        testPageControl.currentPage = index
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("deinit done")
    }
    
    fileprivate func setImage(Url :String?)
    {
        if let imageUrl = Url
        {
            if imageUrl == ""
            {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                return
            }
            guard let url = URL(string: imageUrl) else
            {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if error != nil
                {
                    print(error!)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    return
                }
                guard let imageData = data else
                {
                    print("no image data")
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    return
                }
                
                DispatchQueue.main.async
                    {
                        if let downloadedImage = UIImage(data: imageData)
                        {
                            self.testImageView.image = downloadedImage
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                }
            }).resume()
        }
    }
}
