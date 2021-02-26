//
//  ViewController.swift
//  QuizApp
//
//  Created by Maria Kramer on 17.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rootStackView: UIStackView!
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog: ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.getQuestions()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
    }
    
    func slideInQuestion(){
        
        stackViewTrailingConstraint.constant = -1000
        stackViewLeadingConstraint.constant = 1000
        rootStackView.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewTrailingConstraint.constant = 0
            self.stackViewLeadingConstraint.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideOutQuestion(){
        
        stackViewTrailingConstraint.constant = 0
        stackViewLeadingConstraint.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.stackViewTrailingConstraint.constant = 1000
            self.stackViewLeadingConstraint.constant = -1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func displayQuestion(){
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        questionLabel.text = questions[currentQuestionIndex].question
        
        tableView.reloadData()
        
        slideInQuestion()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, QuizProtocol,  ResultViewControllerProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else {
            return 0
        }
        
        let currectQuestions = questions[currentQuestionIndex]
        
        if currectQuestions.answers != nil {
            return currectQuestions.answers!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        
        let answerLabel = cell.viewWithTag(1) as? UILabel
        
        if answerLabel != nil {
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                answerLabel!.text = question.answers![indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var resultText = ""
        
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            print("user got it right")
            
            resultText = "Correct!"
            numCorrect += 1
            
        } else {
            print("user got it wrong")
            resultText = "Wrong!"
        }
        
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        // Show the popup
        if resultDialog != nil {
            
            // Customize the dialog text
            resultDialog!.resultText = resultText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
        }
    }
    
    //    MARK: - QuizProtocol Method
    
    func questionRetrieved(_ questions: [Question]) {
        
        // Get a reference to the questions
        self.questions = questions
        
        // Check if we should restore the state, before showing question #1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            // Set the currect question to the saved index
            currentQuestionIndex = savedIndex!
            
            //            Retrieve the number correct from storage
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect!
            }
        }
        
        // Display the first question
        displayQuestion()
    }
    
    //    MARK: - ResultViewControllerProtocol Method
    
    func dialogDismissed() {
        // Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            // Show the popup
            if resultDialog != nil {
                // Customize the dialog text
                resultDialog!.resultText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count) questions"
                resultDialog!.buttonText = "Restart"
                
                present(resultDialog!, animated: true, completion: nil)
                
                // Clear state
                StateManager.clearState()
            }
        }
        else if currentQuestionIndex > questions.count {
            // Restart
            numCorrect = 0
            currentQuestionIndex = 0
            
            // Display the next question
            displayQuestion()
            
        }
        else if currentQuestionIndex < questions.count {
            // Display the next question
            displayQuestion()
            
            // Save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
            
        }
    }
}
