//
//  TasksTests.swift
//  TasksTests
//
//  Created by Edgar Ramirez on 3/17/25.
//

import XCTest
@testable import Tasks

final class TasksTests: XCTestCase {

    func testShuffleAnArray() throws {
        
        class Solution {
            var array: [Int]
            var original: [Int]

            init(_ nums: [Int]) {
                self.array = nums
                self.original = self.array
            }
            
            func reset() -> [Int] {
                self.array = self.original
                return self.original
            }
            
            func shuffle() -> [Int] {
                for idx in 0..<self.array.count {
                    let indexToSwap = Int.random(in: idx..<(self.array.count))
                    let aux = self.array[idx]
                    self.array[idx] = self.array[indexToSwap]
                    self.array[indexToSwap] = aux
                }
                return self.array
            }
        }

        /**
         * Your Solution object will be instantiated and called as such:
         * let obj = Solution(nums)
         * let ret_1: [Int] = obj.reset()
         * let ret_2: [Int] = obj.shuffle()
         */
        let solution = Solution([1, 2, 3])
        XCTAssertEqual(solution.reset(), [1, 2, 3])
        let output = solution.shuffle()
        print(output)
        XCTAssertNotEqual(output, [1, 2, 3])
    }
    
    func testMinStack() {
        
        class MinStack {
            var stack: [Int]
            var secondStack: [Int]

            init() {
                stack = []
                secondStack = []
            }
            
            func push(_ val: Int) {
                self.stack.append(val)
                if let last = self.secondStack.last, val <= last {
                    self.secondStack.append(val)
                } else if self.secondStack.isEmpty {
                    self.secondStack.append(val)
                }
            }
            
            func pop() {
                let last = self.stack.popLast()
                
                if self.secondStack.last == last {
                    self.secondStack.removeLast()
                }
            }
            
            func top() -> Int {
                return self.stack.last ?? Int.max
            }
            
            func getMin() -> Int {
                return self.secondStack.last ?? Int.max
            }
        }

        /**
         * Your MinStack object will be instantiated and called as such:
         * let obj = MinStack()
         * obj.push(val)
         * obj.pop()
         * let ret_3: Int = obj.top()
         * let ret_4: Int = obj.getMin()
         */
        
//        ["MinStack","push","push","push","getMin","pop","top","getMin"]
//        [[],[-2],[0],[-3],[],[],[],[]]
        
        let solution = MinStack()
        solution.push(-2)
        solution.push(0)
        solution.push(-3)
        XCTAssertEqual(solution.getMin(), -3)
        solution.pop()
        XCTAssertEqual(solution.top(), 0)
        XCTAssertEqual(solution.getMin(), -2)
    }
    
    func testTwoSum() {
        class Solution {
            func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
                var dict = [Int: Int]()
                for (index, number) in nums.enumerated() {
                    let complement = target - number
                    if let storedIndex = dict[complement], storedIndex != index {
                        return [index, storedIndex]
                    }
                    dict[number] = index
                }
                
                return []
            }
        }
        
        let solution = Solution()
        
        XCTAssertEqual(solution.twoSum([2, 7, 11, 15], 9).sorted(), [0, 1])
        XCTAssertEqual(solution.twoSum([3, 2, 4], 6).sorted(), [1, 2])
        XCTAssertEqual(solution.twoSum([3, 3], 6).sorted(), [0, 1])
    }

}
