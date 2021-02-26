//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Maria Kramer on 22.02.2021.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var resultText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate: ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.layer.cornerRadius = dialogView.frame.height / 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        resultLabel.text = resultText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        // Hide UI elements
        darkView.alpha = 0
        resultLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            
            self.darkView.alpha = 1
            self.resultLabel.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.darkView.alpha = 0
        } completion: { (completed) in
            self.dismiss(animated: true, completion: nil)
            
            self.delegate?.dialogDismissed()
        }
    }
}
