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
    var displayedLattersLabel: UILabel!
    var iKnowWord: UIButton!
    var letterButtons = [UIButton]()
    var usedLetterButtons = [UIButton]()
    
    let letters = ["А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"]
    var wordsStorage = [String]()
    var hiddenWord = ""
    var isGameOver = false
    
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

    var displayedLatters = "" {
        didSet {
            displayedLattersLabel.text = displayedLatters
        }
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        completedLabel = UILabel()
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.font = UIFont.systemFont(ofSize: 18)
        completedLabel.textAlignment = .center
        completedLabel.text = "Слов угадано: 0"
        completedLabel.alpha = 0.0
        view.addSubview(completedLabel)
        
        attempsLabel = UILabel()
        attempsLabel.translatesAutoresizingMaskIntoConstraints = false
        attempsLabel.font = UIFont.systemFont(ofSize: 18)
        attempsLabel.textAlignment = .center
        attempsLabel.text = "Осталось попыток: 0"
        attempsLabel.alpha = 0.0
        view.addSubview(attempsLabel)
        
        displayedLattersLabel = UILabel()
        displayedLattersLabel.translatesAutoresizingMaskIntoConstraints = false
        displayedLattersLabel.textAlignment = .center
        displayedLattersLabel.text = "?"
        displayedLattersLabel.alpha = 0.0
        view.addSubview(displayedLattersLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        iKnowWord = UIButton(type: .system)
        iKnowWord.translatesAutoresizingMaskIntoConstraints = false
        iKnowWord.contentEdgeInsets = UIEdgeInsets(top: 5, left: 22, bottom: 5, right: 22)
        iKnowWord.setTitle("Я знаю слово!", for: .normal)
        iKnowWord.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        iKnowWord.alpha = 0.0
        view.addSubview(iKnowWord)
        iKnowWord.addTarget(self, action: #selector(promptForKnownWord), for: .touchUpInside)
        
        // set some values for word button
        let columns = 5
        let rows = 7
        let width = 60
        let height = 42
        
        // create grid of buttons
        for row in 0..<rows {
            for col in 0..<columns {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .roundedRect)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.alpha = 0.0

                //  for last row where 1 letter
                if row == rows - 1 {
                    if col == 2 {
                        letterButton.setTitle(letters.last, for: .normal)
                    } else {
                        continue
                    }
                } else {
                    letterButton.setTitle(letters[5 * row + col], for: .normal)
                }

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)

                letterButton.addTarget(self, action: #selector(letterWasTapped), for: .touchUpInside)
            }
        }
        
        NSLayoutConstraint.activate([
            completedLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            completedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            attempsLabel.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 15),
            attempsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            displayedLattersLabel.topAnchor.constraint(equalTo: attempsLabel.bottomAnchor, constant: 20),
            displayedLattersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: displayedLattersLabel.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(columns * width)),
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(rows * height)),

            iKnowWord.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            iKnowWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String(contentsOf: wordsURL) {
                wordsStorage = startWords.components(separatedBy: "\n")
            } else {
                fatalError("Could not load words from words.txt")
            }
        } else {
            fatalError("Could not load words.txt from bundle")
        }
        
        loadLevel()
    }

    func loadLevel() {
        //  generate hidden word
        if let randomWord = wordsStorage.randomElement() {
            hiddenWord = randomWord
            displayedLatters = String(repeating: "?", count: hiddenWord.count)
            attempsLeft = hiddenWord.count
            
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                self.completedLabel.alpha = 1.0
                self.attempsLabel.alpha = 1.0
                self.displayedLattersLabel.alpha = 1.0
                self.iKnowWord.alpha = 1.0
                for letterButton in self.letterButtons {
                    letterButton.alpha = 1.0
                }
            })
        } else {
            fatalError("Cant receive hiddenWord")
        }
    }
    
    func playAgain(_: UIAlertAction) {
        isGameOver = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.completedLabel.alpha = 0.0
            self.attempsLabel.alpha = 0.0
            self.displayedLattersLabel.alpha = 0.0
            self.iKnowWord.alpha = 0.0
            for letterButton in self.letterButtons {
                letterButton.alpha = 0.0
            }
        }, completion: { _ in
            self.loadLevel()
        })
    }
    
    @objc func letterWasTapped(_ sender: UIButton) {
        if isGameOver { return }
        
        guard let tappedLetter = sender.titleLabel?.text else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [],
            animations: {
                sender.alpha = 0.0

        })
        usedLetterButtons.append(sender)
        
        if hiddenWord.contains(Character(tappedLetter)) {
            //  show correct letter
            for (index, hiddenLetter) in hiddenWord.enumerated() {
                if String(hiddenLetter) == tappedLetter {
                    self.displayedLatters.replace(index, Character(tappedLetter))
                }
            }
        } else {
            self.attempsLeft -= 1
        }
        
        if attempsLeft == 0 || !displayedLatters.contains("?") {
            isGameOver = true
            
            if displayedLatters.contains("?") {
                gameOver(isWin: false)
            } else {
                gameOver(isWin: true)
            }
        }
    }
    
    @objc func promptForKnownWord() {
        let ac = UIAlertController(title: "Введите ответ", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Подтвердить", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.checkForKnownWord(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func checkForKnownWord(_ answer: String) {
        if hiddenWord == answer {
            gameOver(isWin: true)
        } else {
            gameOver(isWin: false)
        }
    }
    
    func gameOver(isWin: Bool) {
        isGameOver = true
        
        var titleGameOver = ""
        var message = ""
        
        if isWin {
            titleGameOver = "Вы выиграли!"
            completedLevels += 1
        } else {
            titleGameOver = "Вы проиграли!"
            message = "Было загадано слово \(hiddenWord)\n"
        }
        
        let ac = UIAlertController(title: titleGameOver, message: "\(message)Желаете поигрть еще раз?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Начать", style: .default, handler: playAgain))
        present(ac, animated: true)
    }
}

