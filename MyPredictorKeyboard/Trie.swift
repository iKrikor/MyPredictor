//
//  Trie.swift
//  MyPredictor
//
//  Created by Krikor Bisdikian on 11/19/15.
//  Copyright © 2015 Krikor Bisdikian. All rights reserved.
//

import Foundation

extension String
{
    
    func substringToIndex(to: Int) -> String
    {
        return self.substringToIndex(self.startIndex.advancedBy(to))
        
    }
}

public class TrieNode
{
    var key: String!
    var children: Array<TrieNode>
    var isFinal: Int
    var level: Int
    
    init()
    {
        self.children = Array<TrieNode>()
        self.isFinal = -1
        self.level = 0
    }
}

public class Trie
{
    private var root: TrieNode!
    
    init()
    {
        root = TrieNode()
    }
    
    func getRoot() -> TrieNode
    {
        return root
    }
    
    
    func addWord(var keyword: String, frec: Int) -> TrieNode
    {
        keyword = keyword.lowercaseString
        
        if (keyword.characters.count == 0)
        {
            var node: TrieNode!
            
            return node
        } else
        {
            return addWord(keyword, current: root, frec: frec)
        }
    }
    
    
    func addWord(keyword: String,  current: TrieNode, frec : Int) -> TrieNode
    {
        
        
        var childToUse: TrieNode!
        
        if (keyword.characters.count == current.level){
            current.isFinal = frec
            return current
        } else
        {
            let searchKey = keyword.substringToIndex(current.level + 1)
            
            for child in current.children
            {
                if (child.key == searchKey)
                {
                    childToUse = child
                    break
                }
            }
            
            if(childToUse != nil)
            {
                return addWord(keyword, current: childToUse, frec: frec)
            }else
            {
                
                childToUse = TrieNode()
                childToUse.key = searchKey
                childToUse.level = current.level + 1
                current.children.append(childToUse)
                return addWord(keyword, current: childToUse, frec: frec)
            }
        }
    }
    
    
    
    func findWord(var keyword: String) -> Array<TrieNode>!
    {
        keyword = keyword.lowercaseString
        
        if (keyword.characters.count == 0)
        {
            return nil
        }
        var current: TrieNode = root
        var searchKey: String!
        var wordList: Array<TrieNode>! = Array<TrieNode>()
        
        
        while(keyword.characters.count != current.level)
        {
            var childToUse: TrieNode!
            searchKey = keyword.substringToIndex(current.level + 1)
            
            //iterate through any children
            for child in current.children
            {
                if (child.key == searchKey)
                {
                    childToUse = child
                    current = childToUse
                    break
                }
            }
            //prefix not found
            if (childToUse == nil)
            {
                return nil
            }
        }
        //end while
        
        wordList.appendContentsOf(getWordList(current))
        
        wordList = wordList.sort({(s1: TrieNode, s2: TrieNode) -> Bool in
            return s1.isFinal > s2.isFinal
        })
        
        return wordList
    }
    
    func getWordList(current: TrieNode) -> Array<TrieNode>!
    {
        var wordList: Array<TrieNode>! = Array<TrieNode>()
        if(current.children.isEmpty)
        {
            if(current.isFinal >= 0){
                wordList.append(current)
                return wordList;
            } else
            {
                return nil
            }
            
        } else
        {
            if(current.isFinal >= 0){
                wordList.append(current)
            }
            
            for child in current.children
            {
                wordList.appendContentsOf(getWordList(child))
            }
            
            return wordList;
        }
    }
}
