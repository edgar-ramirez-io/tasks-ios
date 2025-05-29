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
    
    func testConvert() {
        
        func convert(_ s: String, _ numRows: Int) -> String {
            guard numRows > 1 else { return s }
            let n = s.count
            let sectionSize = 2 * numRows - 2
            let sections = Int(ceil(Double(n) / Double(sectionSize)))
            let numCols = sections * (numRows - 1)
            var matrix = Array(repeating: Array(repeating: " ", count: numCols), count: numCols)
            let chars = Array(s)
            var index = 0
            var currRow = 0
            var currCol = 0
            
            // Fill the matrix in zig-zag pattern
            while index < n {
                // move down (rows)
                while currRow < numRows && index < n {
                    matrix[currRow][currCol] = String(chars[index])
                    currRow += 1
                    index += 1
                }
                
                currRow -= 2
                currCol += 1
                
                // move up diagonally
                while index < n && currRow > 0 && currCol < numCols {
                    matrix[currRow][currCol] = String(chars[index])
                    currRow -= 1
                    currCol += 1
                    index += 1
                }
            }
            
            var i = 0
            while i < numRows {
                print("\(matrix[i].joined())")
                i += 1
            }
            
            let result = matrix.map { $0.filter({ $0 != " " }).joined() }.joined()
            
            return result
        }
        
        XCTAssertEqual(convert("test", 1), "test")
        XCTAssertEqual(convert("PAYPALISHIRING", 3), "PAHNAPLSIIGYIR")
    }
    
    func testHasCycle() {
        class ListNode {
            let val: Int
            var next: ListNode?
            
            init(_ val: Int, _ next: ListNode? = nil) {
                self.val = val
                self.next = next
            }
        }
        func hasCycle(_ head: ListNode?) -> Bool {
            guard head != nil else { return false }
            var slow = head
            var fast = head?.next
            
            while slow !== fast {
                print("slow: \(slow?.val ?? -1)")
                print("fast: \(fast?.val ?? -1)")
                if fast == nil || fast?.next == nil {
                    return false
                }
                slow = slow?.next
                fast = fast?.next?.next
            }
            
            return true
        }
        
        let node1 = ListNode(1)
        let node2 = ListNode(2)
        let node3 = ListNode(3)
        
        node1.next = node2
        node2.next = node3
        node3.next = node1
        
        XCTAssertEqual(hasCycle(node1), true)
        
        XCTAssertEqual(hasCycle(nil), false)
        
        var maxNumber = 0
        let array = [1, 2]
        
        array.forEach { num in
            maxNumber = max(maxNumber, num)
        }
        
        XCTAssertEqual(maxNumber, 2)
        
        XCTAssertEqual(ceil(3/2), 2)
        XCTAssertEqual(ceil(2/3), 1)
    }
    
    func testMinEatingSpeed() {
        func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
            var left = 1
            var right = 1
            var workHours = 0

            piles.forEach { num in
                right = max(right, num)
            }

            while left < right {
                let middle = (left + right) / 2

                for pile in piles {
                    workHours = workHours + Int(ceil(Double(pile) / Double(middle)))
                }

                if workHours <= h {
                    right = middle
                } else {
                    left = middle + 1
                }
            }

            return left
        }
    }
    
    func testIsAnagram() {
        func isAnagram(_ s: String, _ t: String) -> Bool {
            guard s.count == t.count else { return false }
            var dict = [String: Int]()
            let sChars = Array(s)
            let tChars = Array(t)

            for i in 0..<s.count {
                dict[String(sChars[i])] = (dict[String(sChars[i])] ?? 0) + 1
                dict[String(tChars[i])] = (dict[String(tChars[i])] ?? 0) - 1
            }

            for (_, value) in dict {
                if value != 0 {
                    return false
                }
            }

            return true
        }
        
        XCTAssertEqual(isAnagram("abc", "cba"), true)
        XCTAssertEqual(isAnagram("car", "rat"), false)
    }
    
    func testSearch() {
        func search(_ nums: [Int], _ target: Int) -> Int {
            var start = 0
            var end = nums.count - 1
            
            while start <= end {
                let mid = Int((start + end) / 2)
                
                if nums[mid] == target {
                    return mid
                } else if nums[mid] < target {
                    start = mid + 1
                } else {
                    end = mid - 1
                }
            }
            
            return -1
        }
        
        XCTAssertEqual(search([-1,0,3,5,9,12], 9), 4)
        XCTAssertEqual(search([-1,0,3,5,9,12], 2), -1)
    }
    
    func testInorderTraversal() {
        
        class TreeNode {
            var val: Int?
            var left: TreeNode?
            var right: TreeNode?
            
            init(val: Int? = 0, left: TreeNode? = nil, right: TreeNode? = nil) {
                self.val = val
                self.left = left
                self.right = right
            }
        }
        
        func inorderTraversal(_ root: TreeNode) -> [Int] {
            var result = [Int]()
            
            helper(root, result: &result)
            
            return result
        }
        
        func helper(_ node: TreeNode?, result: inout [Int]) {
            if node != nil {
                helper(node?.left, result: &result)
                result.append(node?.val ?? -1)
                helper(node?.right, result: &result)
            }
        }
        
        let root = TreeNode(val: 1, right: TreeNode(val: 2, left: TreeNode(val: 3)))
        XCTAssertEqual(inorderTraversal(root), [1, 3, 2])
    }

}
