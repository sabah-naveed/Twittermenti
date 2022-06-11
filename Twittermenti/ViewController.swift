//  SABrain
//  ViewController.swift
//  Twittermenti
//
//  Created by Sabah Naveed on 08/06/2022.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    let sentimentClassifier = MyTextClassifierTwitter2()
    
    // Instantiation using Twitter's OAuth Consumer Key and secret
    let swifter = Swifter(consumerKey: "KIiGFBT2uKA4c51WHksJJjoSC", consumerSecret: "bAybtIzOaE5cNnXOMuw58SNN7Oc27ScmMTB7KTelWSJE1BhP6R")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        
    }
    
    func fetchTweets(){
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { results, searchMetadata in
                //print(results)
                var tweets = [MyTextClassifierTwitter2Input]()
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = MyTextClassifierTwitter2Input(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePrediction(with: tweets)
                
            } failure: { error in
                print("error with the twitter api request \(error)")
            }
        }
    }
    
    func makePrediction(with tweets: [MyTextClassifierTwitter2Input]){
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var score = 0
            for prediction in predictions {
                let sentiment = prediction.label
                
                if sentiment == "Pos"{
                    score += 1
                } else if sentiment == "Neg"{
                    score -= 1
                }
            }
            updateUI(with: score)
            
        } catch {
                print("error with making prediction\(error)")
            }
    }
    
    func updateUI(with score: Int){
        if score > 20 {
            self.sentimentLabel.text = "🤩"
        } else if score > 10 {
            self.sentimentLabel.text = "🙂"
        } else if score > 0 {
            self.sentimentLabel.text = "🙃"
        } else if score == 0 {
            self.sentimentLabel.text = "😐"
        } else if score > -10 {
            self.sentimentLabel.text = "😔"
        } else if score > -20 {
            self.sentimentLabel.text = "😠"
        } else if score > -30 {
            self.sentimentLabel.text = "😡"
            
        } else {
            self.sentimentLabel.text = "💀"
        }
    }
    
}

