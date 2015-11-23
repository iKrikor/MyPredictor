///
//  KeyboardViewController.swift
//  MyPredictorKeyboard
//
//  Created by Krikor Bisdikian on 11/6/15.
//  Copyright © 2015 Krikor Bisdikian. All rights reserved.
//

import UIKit
import CoreData

var trie = Trie()

var caps = true;
var predictiveButtons = [UIButton]()
var word = ""

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDel.managedObjectContext
//        
//        let request = NSFetchRequest(entityName: "Word")
//        
//        request.returnsObjectsAsFaults = false
//        
//        do
//        {
//           let result =  try context.executeFetchRequest(request)
//        }
//        catch
//        {
//            
//        }

        
        
        
        
        
        
        trie.addWord("balls", frec: 1)
        trie.addWord("ball", frec: 2)
        trie.addWord("ballard",frec: 3)
        trie.addWord("batter", frec:4)
        trie.addWord("bat",frec: 10)
        trie.addWord("beauty",frec: 20)
        trie.addWord("bar",frec: 1)
        trie.addWord("cat",frec: 2)
        trie.addWord("cataclismo",frec: 4)
        trie.addWord("cosa",frec: 5)
        trie.addWord("dog",frec: 4)
        trie.addWord("dagger",frec: 2)
        trie.addWord("dikjstra",frec: 3)
        trie.addWord("krikor",frec: 1000)
        
        
        let buttonTitles0 = ["","",""]
        let buttonTitles1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let buttonTitles2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let buttonTitles3 = ["CP", "Z", "X", "C", "V", "B", "N", "M", "BP"]
        let buttonTitles4 = ["CHG", "SPACE", "RETURN"]
        
        let row0 = createRowOfPredictiveButtons(buttonTitles0)
        let row1 = createRowOfButtons(buttonTitles1)
        let row2 = createRowOfButtons(buttonTitles2)
        let row3 = createRowOfButtons(buttonTitles3)
        let row4 = createRowOfButtons(buttonTitles4)
        
        self.view.addSubview(row0)
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)
        
        row0.translatesAutoresizingMaskIntoConstraints = false
        row1.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        row3.translatesAutoresizingMaskIntoConstraints = false
        row4.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsToInputView(self.view, rowViews: [row0, row1, row2, row3, row4])
        
        self.nextKeyboardButton = UIButton(type: .System)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
    
    func createRowOfButtons(buttonTitles: [NSString]) -> UIView {
        
        var buttons = [UIButton]()
        let keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
        
        for buttonTitle in buttonTitles{
            
            let button = createButtonWithTitle(buttonTitle as String)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons, mainView: keyboardRowView)
        
        return keyboardRowView
    }
    
    func createRowOfPredictiveButtons(buttonTitles: [NSString]) -> UIView {
        
        predictiveButtons = [UIButton]()
        let keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
        
        for buttonTitle in buttonTitles{
            
            let button = createPredictiveButtonWithTitle(buttonTitle as String)
            predictiveButtons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(predictiveButtons, mainView: keyboardRowView)
        
        return keyboardRowView
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
    func createButtonWithTitle (title: String) -> UIButton {
        let button = UIButton(type:UIButtonType.System) as  UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel!.font = UIFont.systemFontOfSize(15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor (white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor() , forState: .Normal)
        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        return button
    }
    
    func createPredictiveButtonWithTitle (title: String) -> UIButton {
        let button = UIButton(type:UIButtonType.System) as  UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel!.font = UIFont.systemFontOfSize(15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor (white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor() , forState: .Normal)
        button.addTarget(self, action: "didTapPredictiveButton:", forControlEvents: .TouchUpInside)
        return button
    }
    
    func didTapPredictiveButton(sender: AnyObject?)
    {
        let button = sender as! UIButton
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        if let title = button.titleForState(.Normal) {
            if(!title.isEmpty)
            {
                proxy.insertText(title.substringFromIndex(title.startIndex.advancedBy(word.characters.count))+" ")
                word = ""
                findWords()
            }
        }
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        if let title = button.titleForState(.Normal)
        {
            switch title
            {
            case "BP" :
                proxy.deleteBackward()
                if(!word.isEmpty)
                {
                    word = word.substringToIndex(word.endIndex.predecessor())
                }
            case "RETURN" :
                proxy.insertText("\n")
                word=""
            case "SPACE" :
                proxy.insertText(" ")
            case "CHG" :
                self.advanceToNextInputMode()
                word=""
            case "CP" :
                caps = !caps
            default :
                if(caps)
                {
                    proxy.insertText(title)
                    
                    caps = !caps
                } else
                {
                    proxy.insertText(title.lowercaseString)
                }
                word+=title.lowercaseString
            }
            
            findWords()
        }
        
    }
    
    func findWords()
    {
        var words = trie.findWord(word)
        
        var i: Int
        if(words != nil)
        {
            for (i=0; (i<3 && i<words.count) ; i++)
            {
                predictiveButtons[i].setTitle(words[i].key, forState: UIControlState.Normal)
            }
            for(i; i<3; i++)
            {
                predictiveButtons[i].setTitle("", forState: UIControlState.Normal)
            }
        }else
        {
            for buttons in predictiveButtons
            {
                buttons.setTitle("", forState: UIControlState.Normal)
            }
        }
    }
    
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView){
        
        for (index, button) in buttons.enumerate() {
            let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -1)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -1)
                
            }else{
                
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -1)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: 1)
                
            }else{
                
                let prevtButton = buttons[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: 1)
                
                let firstButton = buttons[0]
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
                
                widthConstraint.priority = 800
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    
    
    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in rowViews.enumerate() {
            let rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: inputView, attribute: .Right, multiplier: 1.0, constant: -1)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: inputView, attribute: .Left, multiplier: 1.0, constant: 1)
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1.0, constant: 0)
                
            }else{
                
                let prevRow = rowViews[index-1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 0)
                
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: rowView, attribute: .Height, multiplier: 1.0, constant: 0)
                
                heightConstraint.priority = 800
                inputView.addConstraint(heightConstraint)
            }
            inputView.addConstraint(topConstraint)
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: inputView, attribute: .Bottom, multiplier: 1.0, constant: 0)
                
            }else{
                
                let nextRow = rowViews[index+1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 0)
            }
            
            inputView.addConstraint(bottomConstraint)
        }
        
    }
}
