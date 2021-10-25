//
//  MinHeap Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import Foundation

struct MinHeap: Hashable {
    //init
    var name: String
    init(name: String) {
        self.name = name
    }
    
    //instance property
    var elements: [Vertex] = []
    var dvDict: [Vertex: Double] = [:]
    var aStarScoreDict: [Vertex: Double] = [:]
    
    //Get Index Functions
    private func getLeftChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 1
    }
    
    private func getRightChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 2
    }
    
    private func getParentIndex(_ childIndex: Int) -> Int {
        return (childIndex - 1) / 2
    }
    
    //addElement
    mutating func addElement(_ element: Vertex) {
        self.elements.append(element)
    }
    
    // Check for existence of family member
    private func hasLeftChild(_ index: Int) -> Bool {
        return getLeftChildIndex(index) < elements.count - 1
    }
    
    private func hasRightChild(_ index: Int) -> Bool {
        return getRightChildIndex(index) < elements.count - 1
    }
    
    private func hasParent(_ index: Int) -> Bool {
        guard index > 0 else {
            return false
        }
        return getParentIndex(index) >= 0
    }
    // Return value from heap at index
    private func leftChild(_ index: Int) -> Vertex {
        return elements[getLeftChildIndex(index)]
    }
    
    private func rightChild(_ index: Int) -> Vertex {
        return elements[getRightChildIndex(index)]
    }
    
    private func parent(_ index: Int) -> Vertex {
        return elements[getParentIndex(index)]
    }
    // Get Smaller Child Index
    private func getSmallerChildIndex(_ index: Int) -> Int {
        guard self.hasRightChild(index) else {
            return self.getLeftChildIndex(index)
        }
        let leftChild = self.leftChild(index)
        let rightChild = self.rightChild(index)
        if self.aStarScoreDict[leftChild]! < self.aStarScoreDict[rightChild]! {
            return self.getLeftChildIndex(index)
        } else {
            return self.getRightChildIndex(index)
        }
    }
    
    private mutating func swap(index1: Int, index2: Int) {
        let placeholder = elements[index1]
        elements[index1] = elements[index2]
        elements[index2] = placeholder
    }
    
    //heapify up
    mutating func heapifyUp() {
        var idx = self.elements.count - 1
        //var swap_count = 0
        while self.hasParent(idx) {
            if self.aStarScoreDict[parent(idx)]! > self.aStarScoreDict[elements[idx]]! {
                swap(index1: getParentIndex(idx), index2: idx)
            }
            idx = self.getParentIndex(idx)
        }
    }
    
    //heapify down
    mutating func heapifyDown() {
        var idx = 0
        
        while self.hasLeftChild(idx) {
            let smallerChildIndex = self.getSmallerChildIndex(idx)
            if self.aStarScoreDict[elements[idx]]! > self.aStarScoreDict[elements[smallerChildIndex]]! {
                swap(index1: idx, index2: smallerChildIndex)
            }
            idx = smallerChildIndex
        }
    }
    
    mutating func retrieveMin() -> Any {
        if self.elements.count == 0 {
            return print("No items in heap")
        }
        let min = self.elements[0]
        self.elements[0] = self.elements[self.elements.count - 1]
        self.elements[self.elements.count - 1] = min
        self.elements.popLast()
        return min
    }
    
    mutating internal func heapSort() {
        let placeholder: [Vertex] = self.elements //capture last
        self.elements = [] //reset
        for value in placeholder {
            self.addElement(value)
            self.heapifyUp()
        }
    }
}

