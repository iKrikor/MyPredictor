//
//  ViewController.swift
//  MyPredictor
//
//  Created by Krikor Bisdikian on 11/19/15.
//  Copyright © 2015 Krikor Bisdikian. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var deleteWordIndexPath: NSIndexPath? = nil
    
    var results: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Word")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            results =  try context.executeFetchRequest(request)
        }
        catch
        {
            
        }
//
//        request.predicate = NSPredicate(format: "word = %@", "mango")
        
//        request.returnsObjectsAsFaults = false
//
//        do
//        {
//            let results =  try context.executeFetchRequest(request)
//
//            if results.count > 0
//            {
//                for result in results as! [NSManagedObject]
//                {
//                    
//                    //result.setValue("mango", forKey: "word")
//                    
//                    context.deleteObject(result)
//                    
//                    do
//                    {
//                        try context.save()
//                    }
//                    catch
//                    {
//                        
//                    }
//                    
//                    
//                    if let word = result.valueForKey("word") as? String
//                    {
//                        print(word)
//                    }
//                    
//                }
//            }
//        }
//        catch
//        {
//            print("Fetch failed")
//        }
//        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWordButtonAction(sender: AnyObject) {
        
        let word = textField.text! + " "
        
        if(word != " ")
        {
            let words = word.componentsSeparatedByString(" ")
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            var newWord = NSEntityDescription.insertNewObjectForEntityForName("Word", inManagedObjectContext: context)
            
            newWord.setPrimitiveValue(words[0].lowercaseString, forKey: "word")
            newWord.setPrimitiveValue(0, forKey: "frec")
            
            do
            {
                try context.save()
            }
            catch
            {
                print("Error while saving the word")
            }
            
            
            
            let request = NSFetchRequest(entityName: "Word")
            
            request.returnsObjectsAsFaults = false
            
            do
            {
                results =  try context.executeFetchRequest(request)
            }
            catch
            {
                
            }

            
            

            tableView.reloadData()
            
            textField.text = ""
        }
        
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        
        
        if let word = (results as! [NSManagedObject])[indexPath.row].valueForKey("word") as? String
        {
                cell.textLabel?.text = word
        }
        
        
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteWordIndexPath = indexPath
            let wordToDelete = (results as! [NSManagedObject])[indexPath.row].valueForKey("word") as? String
            confirmDelete(wordToDelete!)
        }
    }
    
    // Delete Confirmation and Handling
    func confirmDelete(word: String) {
        let alert = UIAlertController(title: "Delete Word", message: "Are you sure you want to permanently delete \(word)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handledeleteWord)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: canceldeleteWord)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handledeleteWord(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteWordIndexPath {
            tableView.beginUpdates()
            
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            var request = NSFetchRequest(entityName: "Word")
            
            request.returnsObjectsAsFaults = false
            
            request.predicate = NSPredicate(format: "word = %@", (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!)
            
            do
            {
                let result =  try context.executeFetchRequest(request)
                context.deleteObject((result as! [NSManagedObject])[0])
                
                do
                {
                    try context.save()
                }
                catch
                {
                    
                }
            }
            catch
            {
                
            }
            
            request = NSFetchRequest(entityName: "Word")
            request.returnsObjectsAsFaults = false
            
            do
            {
                results =  try context.executeFetchRequest(request)
            }
            catch
            {
                
            }

            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteWordIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func canceldeleteWord(alertAction: UIAlertAction!) {
        deleteWordIndexPath = nil
    }

}

