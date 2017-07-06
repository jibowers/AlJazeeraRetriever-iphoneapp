//
//  ViewController.swift
//  NewsAPITester
//
//  Created by appleone on 7/4/17.
//  Copyright © 2017 jbowers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myButton: UIButton!
    
    
    let apiKey = "3ef9a8998d3c41fc91be676868b5fffd"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get info from News API
        myTextView.text = "Press the above button to load news from Al-Jazeera (English)"
        myButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTapped(sender: UIButton) {
        let source = "al-jazeera-english"
        let urlWithParams =  "https://newsapi.org/v1/articles?source=" + source + "&sortBy=top&apiKey=" + apiKey
        
        var articleInfo = ""
        var bigDict = NSDictionary()
        
        
        // Create NSURL object
        let myUrl = NSURL(string: urlWithParams)
        
        // Create URL Request
        let request = NSMutableURLRequest(URL: myUrl!)
        
        // Set request HTTP method to GET, it could be POST as well for other purposes
        request.HTTPMethod = "GET"
        
        // Here is where you might add Authorization header value
        //
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            // Check for error
            if error != nil{
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString=NSString(data: data!, encoding:NSUTF8StringEncoding)
            print("responseString= \(responseString)")

            do{
                
                // Convert server json response to NSDictionary
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    bigDict = convertedJsonIntoDict
                    
                    let myArticles = bigDict["articles"] as! NSArray
                    
                    for article in myArticles{
                        let title = article["title"] as! String
                        let urlToArticle = article["url"] as! String
                        
                        articleInfo += title + "\n" + urlToArticle + "\n\n"
                    }
                    
                    
                    print("master list: " + articleInfo)
                    
                    // have to do this on the main thread
                    dispatch_async(dispatch_get_main_queue()){
                        /* Do UI work here */
                        self.myTextView.text = "Top articles from Al-Jazeera \n\n \(articleInfo)  \n *"
                    }

                    
                }
            }catch let error as NSError{
                print("The error")
                print(error.localizedDescription)
            }

        }

        task.resume()
       
    }
    
    

}

