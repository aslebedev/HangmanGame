//
//  ViewController.swift
//  HangmanGame
//
//  Created by alexander on 05.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var completedLabel: UILabel!
    var attempsLabel: UILabel!
    var letterButtons = [UIButton]()
    var word = "ТРАНСПОРТИР"
    
    var completedLevels = 0 {
        didSet {
            completedLabel.text = "Слов угадано: \(completedLevels)"
        }
    }
    
    var attempsLeft = 0 {
        didSet {
            attempsLabel.text = "Осталось попыток: \(attempsLeft)"
        }
    }


    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        completedLabel = UILabel()
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.font = UIFont.systemFont(ofSize: 18)
        completedLabel.textAlignment = .right
        completedLabel.text = "Слов угадано: 0"
        view.addSubview(completedLabel)
        
        attempsLabel = UILabel()
        attempsLabel.translatesAutoresizingMaskIntoConstraints = false
        attempsLabel.font = UIFont.systemFont(ofSize: 18)
        attempsLabel.textAlignment = .right
        attempsLabel.text = "Осталось попыток: 0"
        view.addSubview(attempsLabel)
        
        let hiddenWordView = UIView()
        hiddenWordView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hiddenWordView)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let iKnowWord = UIButton(type: .system)
        iKnowWord.translatesAutoresizingMaskIntoConstraints = false
//        submit.layer.borderColor = UIColor.lightGray.cgColor
//        submit.layer.borderWidth = 1
        iKnowWord.setTitle("Я знаю слово!", for: .normal)
        view.addSubview(iKnowWord)
        iKnowWord.addTarget(self, action: #selector(promptForWord), for: .touchUpInside)
        
        
        // set some values for the width and height of each button
        let width = 30
        let height = 40
/*
        // create 20 buttons as a 4x5 grid
        for row in 0..<6 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 23)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("*", for: .normal)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                //letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
*/
        for (index, _) in self.word.enumerated() {
            let letterLabel = UILabel()
            letterLabel.font = UIFont.systemFont(ofSize: 24)
            letterLabel.text = "?"
            letterLabel.backgroundColor = .gray
            let frame = CGRect(x: index * width, y: height, width: width, height: height)
            letterLabel.frame = frame
            
            hiddenWordView.addSubview(letterLabel)
        }
        
        NSLayoutConstraint.activate([
            completedLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 70),
            completedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            attempsLabel.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 20),
            attempsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hiddenWordView.widthAnchor.constraint(equalToConstant: CGFloat(word.count * width - 2)),
            hiddenWordView.topAnchor.constraint(equalTo: attempsLabel.bottomAnchor, constant: 30),
            hiddenWordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hiddenWordView.heightAnchor.constraint(equalToConstant: 100),
            
            iKnowWord.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            iKnowWord.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
/*
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            submit.widthAnchor.constraint(equalToConstant: 88),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            clear.widthAnchor.constraint(equalToConstant: 88),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
*/
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loadLevel() {
        
    }
    
    @objc func promptForWord() {
        let ac = UIAlertController(title: "Введите ответ", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Подтвердить", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.checkForAnswer(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func checkForAnswer(_ answer: String) {
        
    }
}

