//
//  Binary Search Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 12/5/21.
//

import Foundation

struct AlgorithmBook {
    
    //to sort bus codes ascending order
    
    // 1/2
    func mergeSort(forArray array: [Vertex]) -> [Vertex] {
        guard array.count > 1 else { return array }
        
        let middleIndex = array.count / 2
        
        //recursion
        let leftArray = mergeSort(forArray: Array(array[0..<middleIndex]))
        let rightArray = mergeSort(forArray: Array(array[middleIndex..<array.count]))
        
        let result = merge(leftArray, rightArray)
        return result
        
    }
    
    // 2/2
    internal func merge(_ left: [Vertex], _ right: [Vertex]) -> [Vertex] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedArray: [Vertex] = []
        
        while leftIndex < left.count && rightIndex < right.count {
            //start at 0th index at respective left and right arrays, returning element
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]
            
            //make comparison
            if leftElement.vertexLabel < rightElement.vertexLabel {
                orderedArray.append(leftElement)
                leftIndex += 1
            } else if leftElement.vertexLabel > rightElement.vertexLabel {
                orderedArray.append(rightElement)
                rightIndex += 1
            } else {
                orderedArray.append(leftElement)
                leftIndex += 1
                orderedArray.append(rightElement)
                rightIndex += 1
            }
        }
        
        while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
        }
        
        return orderedArray
    }
    
    func BinarySearch(sortedArray: [Vertex], for value: String) -> Int? {
        
        var left = 0
        var right = sortedArray.count - 1
        
        while left <= right {
            let middle = Int(floor(Double(left + right) / 2.0))
            
            if sortedArray[middle].vertexLabel < value {
                left = middle + 1
            } else if sortedArray[middle].vertexLabel > value {
                right = middle - 1
            } else {
                return middle
            }
            }
        print("Search term is not in array")
        return nil
        }
    
    func retrieveIdx(array: [Vertex], target: String) -> Int? {
        var retrievedIdx: Int?
        
        for idx in (0..<array.count) {
            if array[idx].vertexLabel == target {
                retrievedIdx = idx
            }
        }
        return retrievedIdx 
    }
    
    func CheckAdjacencyList(BusStopCode: String, VertexSet: [Vertex]) -> [Vertex: [Edge]] {
        var checkThis: [Vertex: [Edge]] = [:]
        for elements in VertexSet {
            if elements.vertexLabel == BusStopCode {
                checkThis = elements.adjacencyList
            }
        }
        return checkThis
    }
    
    func AfterRemoveLast(string: String) -> String {
        var placeholder = string
        placeholder.removeLast()
        return placeholder
    }
}
