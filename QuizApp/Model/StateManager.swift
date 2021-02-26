//
//  StateManager.swift
//  QuizApp
//
//  Created by Maria Kramer on 24.02.2021.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect: Int, questionIndex: Int){
        //        Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        //        Set the state data
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
    }
    
    static func retrieveValue(key: String) -> Any? {
        //        Get a reference to user defaults
        let defaults = UserDefaults.standard
        //        Retrieve the data
        return defaults.value(forKey: key)
    }
    
    static func clearState() {
        //        Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        //        Clear the state data in the user defaults
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
    
}
