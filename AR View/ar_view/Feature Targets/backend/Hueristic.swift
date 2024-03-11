//
//  Hueristic.swift
//  ar_view
//
//  Created by Sara Chin on 4/2/24.
//
//

import Foundation

// Abstract class in Java can be represented as a protocol in Swift,
// but since protocols can't have stored properties, we use a base class instead.
class Heuristic: NSObject {
    var heuristicInt: Int = 0

    // Initializer doesn't do anything specific in your Java code,
    // so we can safely omit it in Swift if it remains empty.

    func h(_ s: States) -> Int {
        return goalCount(s)
    }

    func goalCount(_ s: States) -> Int {
        heuristicInt = 0
//        for row in 1..<(States.g.count - 1) {
//            for col in 1..<(States.g[row].count - 1) {
//                let goal = States.g[row][col]
//
//                // Checking conditions without boxes, focusing on goals and agent positions.
//                if ("A" <= goal && goal <= "Z" && !(s.agentRows[Int(goal.asciiValue!)] == row && s.agentCols[Int(goal.asciiValue!)] == col)) {
//                    heuristicInt += 1
//                }
//            }
//        }
        return heuristicInt
    }

    // Assuming manhattanDistance needs to remain but simplified without boxes.
    func manhattanDistance(_ s: States) -> Int {
        heuristicInt = 0
        // Implement the logic here as needed.
        return heuristicInt
    }

    func f(_ s: States) -> Int {
        fatalError("This method should be overridden")
    }

//    override func compare(_ object1: Any?, to object2: Any?) -> ComparisonResult {
//        guard let s1 = object1 as? States, let s2 = object2 as? States else {
//            return .orderedSame
//        }
//        let comparison = f(s1) - f(s2)
//        if comparison < 0 {
//            return .orderedAscending
//        } else if comparison > 0 {
//            return .orderedDescending
//        } else {
//            return .orderedSame
//        }
//    }
}

// Derived classes
class HeuristicAStar: Heuristic {
    override func f(_ s: States) -> Int {
        // Assuming s.g() is a method to get some value related to the state.
//        return s.g() + self.manhattanDistance(s)
        return self.manhattanDistance(s)
    }

    override var description: String {
        return "A* evaluation"
    }
}

class HeuristicWeightedAStar: Heuristic {
    var w: Int

    init(w: Int) {
        self.w = w
    }

    override func f(_ s: States) -> Int {
//        return s.goals() + self.w * self.h(s)
        return  self.w * self.h(s)
    }

    override var description: String {
        return "WA* (\(w)) evaluation"
    }
}

class HeuristicGreedy: Heuristic {
    override func h(_ s: States) -> Int {
        return goalCount(s)
    }

    override func f(_ s: States) -> Int {
        return self.h(s)
    }

    override var description: String {
        return "greedy evaluation"
    }
}

// Note: State class definition needs to be added. It should include goals, agentRows, agentCols, and any other properties or methods needed for the calculations.


//import Foundation
//
//class Heuristic: NSObject, Comparator {
//    var heuristicInt: Int = 0
//    
//    override init() {
//        super.init()
//    }
//
//    func h(state: State) -> Int {
//        return goalCount(state: state)
//    }
//
//    func goalCount(state: State) -> Int {
//        heuristicInt = 0
//        for row in 1..<(State.goals.count - 1) {
//            for col in 1..<(State.goals[row].count - 1) {
//                let goal = State.goals[row][col]
//                if (('A' <= goal && goal <= "Z" && state.agentAt(row: row, col: col) != goal) ||
//                        ("0" <= goal && goal <= "9" && !(state.agentRows[Int(goal.asciiValue!) - 48] == row && state.agentCols[Int(goal.asciiValue!) - 48] == col))) {
//                    heuristicInt += 1
//                }
//            }
//        }
//        return heuristicInt
//    }
//
//    func improvedManDistHeuristic(state: State) -> Int {
//        heuristicInt = 0
//        // Adjust the implementation according to your requirement without using boxes
//        // For demonstration, let's assume we are calculating the Manhattan distance without considering boxes
//        // Replace this logic with your actual implementation
//        // You might need to modify the State class to provide the necessary information for the heuristic calculation
//        // For instance, you could add methods to get the positions of agents or any other relevant information
//        return heuristicInt
//    }
//
//    func manhattanDistance(state: State) -> Int {
//        heuristicInt = 0
//        for row in 1..<(State.goals.count - 1) {
//            for col in 1..<(State.goals[row].count - 1) {
//                let goal = State.goals[row][col]
//                if (('A' <= goal && goal <= "Z" && state.agentAt(row: row, col: col) != goal) ||
//                        ("0" <= goal && goal <= "9" && !(state.agentRows[Int(goal.asciiValue!) - 48] == row && state.agentCols[Int(goal.asciiValue!) - 48] == col))) {
//                    heuristicInt += abs(state.agentRows[Int(goal.asciiValue!) - 48] - row) + abs(state.agentCols[Int(goal.asciiValue!) - 48] - col)
//                }
//            }
//        }
//        return heuristicInt
//    }
//
//    func f(state: State) -> Int {
//        // Override this method in subclasses
//        fatalError("This method must be overridden in subclasses")
//    }
//
//    func compare(_ s1: State, _ s2: State) -> ComparisonResult {
//        return ComparisonResult(rawValue: self.f(state: s1) - self.f(state: s2)) ?? .orderedSame
//    }
//}
