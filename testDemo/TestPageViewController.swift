//
//  TestPageViewController.swift
//  testDemo
//
//  Created by SpegaTechnology on 1/3/19.
//

import UIKit
import Foundation

class TestPageViewController: UIPageViewController {
    
    var datas = [TestModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.dataSource = self
        
        //function for api calling
        jsonParsing()
        
        setFirstPage()
    }
    
    fileprivate func setFirstPage() {
        if datas.count != 0
        {
            if let firstWalkVc = self.viewControllerAtIndex(index: 0)
            {
                setViewControllers([firstWalkVc], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    //json parsing 
    func jsonParsing(){
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let dataResponse = data, error == nil else
            {
                print(error?.localizedDescription ?? "Response Error")
                return            }
            
            do{
                let jsonDta = try JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments) as? [String: Any]
                guard let jsonData = jsonDta else
                {
                    return
                }
                print(jsonData)
                guard let items = jsonData["items"] as? [[String:Any]] else {
                    return
                }
                print(items)
                for item in items
                {
                    guard let title = item["title"] as? String else {
                        return
                    }
                    guard let media = item["media"] as? [String:Any] else {
                        return
                    }
                    guard let imageUrl = media["m"] as? String else {
                        return
                    }
                    let newData = TestModel(title: title, imageUrl: imageUrl)
                    self.datas.append(newData)
                }
                DispatchQueue.main.async {
                    self.setFirstPage()
                }
            }catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func viewControllerAtIndex(index:Int)-> WalkThroughViewController?
    {
        if index == NSNotFound || index < 0 || index >= self.datas.count{
            return nil
        }
        if let walkViewController = storyboard?.instantiateViewController(withIdentifier: "WalkThroughViewController") as? WalkThroughViewController{
            walkViewController.titleText = datas[index].title
            walkViewController.imageUrl = datas[index].imageUrl
            walkViewController.total = datas.count
            walkViewController.index = index
            return walkViewController
        }
        return nil 
    }
    
}

//UIPageViewController data source
extension TestPageViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: WalkThroughViewController = viewController as! WalkThroughViewController
        var index = pageContent.index
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: WalkThroughViewController = viewController as! WalkThroughViewController
        var index = pageContent.index
        if (index == NSNotFound)
        {
            return nil
        }
        index += 1
        return viewControllerAtIndex(index: index)
    }
}

