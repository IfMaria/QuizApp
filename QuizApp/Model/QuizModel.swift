//
//  QuizModel.swift
//  QuizApp
//
//  Created by Maria Kramer on 17.02.2021.
//

import Foundation

protocol QuizProtocol {
    
    func questionRetrieved (_ question:[Question])
    
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        // Fetch the questions
        getRemoteJsonFile()
    }
    
    func getRemoteJsonFile(){

        // Get a URL object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Couldn't create the URL object")
            return
        }
        
        // Get a URL Session object
        let session = URLSession.shared
        
        // Get a data task object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                do {
                    let decoder = JSONDecoder()
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    // Use the main thread to notify the view controller for UI work
                    DispatchQueue.main.async {
                        // Notify the delegate
                        self.delegate?.questionRetrieved(array)
                    }
                }
                catch {
                    print("Couldn't parse JSON")
                }
            }
        }
        // Call resume on the data task
        dataTask.resume()
    }
}
