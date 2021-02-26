//
//  Question.swift
//  QuizApp
//
//  Created by Maria Kramer on 17.02.2021.
//

import Foundation

struct Question: Codable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?

}
