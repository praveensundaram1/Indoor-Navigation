//
//  State.swift
//  ar_view
//
//  Created by Sara Chin on 4/2/24.
//


import Foundation
import SwiftUI
import RealityKit

class States {
    private static let RNG = Random(1)
    
    var agentRows: [Int]
    var agentCols: [Int]
    static var agentColors: [Color] = []
    
    static var walls: [[Bool]] = []
    var boxes: [[Character]]
    static var goals: [[Character]] = []
    
    static var boxColors: [Color] = []
    
    let parent: States?
    let jointAction: [Action]?
    let g: Int
    
    private var hash = 0
    
    init(agentRows: [Int], agentCols: [Int], boxes: [[Character]], parent: States?, jointAction: [Action]?, g: Int) {
        self.agentRows = agentRows
        self.agentCols = agentCols
        self.boxes = boxes
        self.parent = parent
        self.jointAction = jointAction
        self.g = g
    }
    
    convenience init(agentRows: [Int], agentCols: [Int], boxes: [[Character]], parent: States? = nil, jointAction: [Action]? = nil) {
        self.init(agentRows: agentRows, agentCols: agentCols, boxes: boxes, parent: parent, jointAction: jointAction, g: 0)
    }
    
    //    func g() -> Int {
    //        return self.g
    //    }
    
    func isGoalState() -> Bool {
        for row in 1..<(Self.goals.count - 1) {
            for col in 1..<(Self.goals[row].count - 1) {
                let goal = Self.goals[row][col]
                
                if ("A" <= goal && goal <= "Z" && self.boxes[row][col] != goal) {
                    return false
                }
                //                } else if ("0" <= goal && goal <= "9" && !(self.agentRows[Int(goal.asciiValue!) - Int("0").asciiValue!)] == row && self.agentCols[Int(goal.asciiValue!) - Int("0".asciiValue!)] == col)) {
                //                    return false
                //                }
            }
        }
        return true
    }
    
    func getExpandedStates() -> [States] {
        let numAgents = self.agentRows.count
        var applicableActions = [[Action]]()
        
        for agent in 0..<numAgents {
            var agentActions = [Action]()
            //            for action in ActionType {
            //                if self.isApplicable(agent: agent, action: action) {
            //                    agentActions.append(action)
            //                }
            //            }
            applicableActions.append(agentActions)
        }
        
        var expandedStates = [States]()
        var jointAction = [Action?](repeating: nil, count: numAgents)
        var actionsPermutation = [Int](repeating: 0, count: numAgents)
        
        while true {
            for agent in 0..<numAgents {
                jointAction[agent] = applicableActions[agent][actionsPermutation[agent]]
            }
            
            if !self.isConflicting(jointAction: jointAction.compactMap { $0 }) {
                expandedStates.append(States(agentRows: self.agentRows, agentCols: self.agentCols, boxes: self.boxes, parent: self, jointAction: jointAction.compactMap { $0 }, g: self.g + 1))
            }
            
            var done = false
            for agent in 0..<numAgents {
                if actionsPermutation[agent] < applicableActions[agent].count - 1 {
                    actionsPermutation[agent] += 1
                    break
                } else {
                    actionsPermutation[agent] = 0
                    if agent == numAgents - 1 {
                        done = true
                    }
                }
            }
            
            if done {
                break
            }
        }
        
        expandedStates.shuffle(using: &States.RNG)
        return expandedStates
    }
    
    private func isApplicable(agent: Int, action: Action) -> Bool {
        let agentRow = self.agentRows[agent]
        let agentCol = self.agentCols[agent]
        let boxRow: Int
        let boxCol: Int
        let destinationRow: Int
        let destinationCol: Int
        
        //        switch Action.type {
        //            case .NoOp:
        //                return true
        //            case .Move:
        //                destinationRow = agentRow + action.agentRowDelta
        //                destinationCol = agentCol + action.agentColDelta
        //                return self.cellIsFree(row: destinationRow, col: destinationCol)
        //            case .Push:
        //                boxRow = agentRow + action.agentRowDelta
        //                boxCol = agentCol + action.agentColDelta
        //                let box = self.boxes[boxRow][boxCol]
        //                guard box != "0" && Self.boxColors[Int(box.asciiValue!) - Int("A".asciiValue!)] == State.agentColors[agent] else {
        //                    return false
        //                }
        //                destinationRow = boxRow + action.boxRowDelta
        //                destinationCol = boxCol + action.boxColDelta
        //                return self.cellIsFree(row: destinationRow, col: destinationCol)
        //            case .Pull:
        //                boxRow = agentRow - action.boxRowDelta
        //                boxCol = agentCol - action.boxColDelta
        //                let box = self.boxes[boxRow][boxCol]
        //                guard box != "0" && Self.boxColors[Int(box.asciiValue!) - Int("A".asciiValue!)] == State.agentColors[agent] else {
        //                    return false
        //                }
        //                destinationRow = agentRow + action.agentRowDelta
        //                destinationCol = agentCol + action.agentColDelta
        //                return self.cellIsFree(row: destinationRow, col: destinationCol)
        //        }
    }
    
    private func isConflicting(jointAction: [Action]) -> Bool {
        let numAgents = self.agentRows.count
        
        var destinationRows = [Int](repeating: 0, count: numAgents)
        var destinationCols = [Int](repeating: 0, count: numAgents)
        var boxRows = [Int](repeating: 0, count: numAgents)
        var boxCols = [Int](repeating: 0, count: numAgents)
        
        for agent in 0..<numAgents {
            let action = jointAction[agent]
            let agentRow = self.agentRows[agent]
            let agentCol = self.agentCols[agent]
            //            var boxRow: Int
            //            var boxCol: Int
            
            //            switch action.type {
            //            case .NoOp:
            //                break
            //            case .Move:
            //                destinationRows[agent] = agentRow + action.agentRowDelta
            //                destinationCols[agent] = agentCol + action.agentColDelta
            //                boxRows[agent] = -1 // Dummy value
            //                boxCols[agent] = -1 // Dummy value
            //            case .Push:
            //                boxRow = agentRow + action.agentRowDelta
            //                boxCol = agentCol + action.agentColDelta
            //                let box = self.boxes[boxRow][boxCol]
            //                boxRows[agent] = boxRow
            //                boxCols[agent] = boxCol
            //                destinationRows[agent] = boxRow + action.boxRowDelta
            //                destinationCols[agent] = boxCol + action.boxColDelta
            //            case .Pull:
            //                boxRow = agentRow - action.boxRowDelta
            //                boxCol = agent
        }
    }
}

                
                
//
//import Foundation
//
//// Enums for actions and colors
//enum ActionType {
//    case NoOp
//    case Move
//    case Push
//    case Pull
//}
//
//enum Color {
//    case Red
//    case Blue
//    // Add other colors as needed
//}
//
//// Action struct
//struct Action {
//    let type: ActionType
//    let agentRowDelta: Int
//    let agentColDelta: Int
//    let boxRowDelta: Int
//    let boxColDelta: Int
//}
//
//// State class
//class State {
//    static var agentColors: [Color] = []
//
//    var agentRows: [Int]
//    var agentCols: [Int]
//    static var walls: [[Bool]] = []
//    var boxes: [[Character]]
//    static var goals: [[Character]] = []
//    static var boxColors: [Color] = []
//
//    let parent: State?
//    let jointAction: [Action]?
//    let g: Int
//
//    // Hash value for state
//    private var hash: Int = 0
//
//    init(agentRows: [Int], agentCols: [Int], boxes: [[Character]], parent: State?, jointAction: [Action]?, g: Int) {
//        self.agentRows = agentRows
//        self.agentCols = agentCols
//        self.boxes = boxes
//        self.parent = parent
//        self.jointAction = jointAction
//        self.g = g
//    }
//
//    func isGoalState() -> Bool {
//        for row in 1..<(State.goals.count - 1) {
//            for col in 1..<(State.goals[row].count - 1) {
//                let goal = State.goals[row][col]
//                if ('A' <= goal && goal <= 'Z' && self.boxes[row][col] != goal) || ('0' <= goal && goal <= '9' && !(self.agentRows[Int(goal.asciiValue!) - 48] == row && self.agentCols[Int(goal.asciiValue!) - 48] == col)) {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//
//    func extractPlan() -> [[Action]] {
//        var plan: [[Action]] = []
//        var state: State? = self
//        while state?.jointAction != nil {
//            if let jointAction = state?.jointAction {
//                plan.append(jointAction)
//            }
//            state = state?.parent
//        }
//        return plan.reversed()
//    }
//
//    // Override hash function
//    func hashCode() -> Int {
//        if self.hash == 0 {
//            var result = 1
//            result = result &* 31 &+ self.agentColors.hashValue
//            result = result &* 31 &+ State.boxColors.hashValue
//            result = result &* 31 &+ State.walls.hashValue
//            result = result &* 31 &+ State.goals.hashValue
//            result = result &* 31 &+ self.agentRows.hashValue
//            result = result &* 31 &+ self.agentCols.hashValue
//            for row in 0..<self.boxes.count {
//                for col in 0..<self.boxes[row].count {
//                    let c = self.boxes[row][col]
//                    if c != "0" {
//                        result = result &* 31 &+ (row * self.boxes[row].count + col) &* Int(c.asciiValue!)
//                    }
//                }
//            }
//            self.hash = result
//        }
//        return self.hash
//    }
//
//    // Override equals function
//    static func == (lhs: State, rhs: State) -> Bool {
//        return lhs.agentRows == rhs.agentRows &&
//               lhs.agentCols == rhs.agentCols &&
//               lhs.boxes == rhs.boxes &&
//               lhs.parent == rhs.parent &&
//               lhs.jointAction == rhs.jointAction &&
//               lhs.g == rhs.g
//    }
//
//    // Override description
//    var description: String {
//        var s = ""
//        for row in 0..<State.walls.count {
//            for col in 0..<State.walls[row].count {
//                if self.boxes[row][col] > "0" {
//                    s.append(self.boxes[row][col])
//                } else if State.walls[row][col] {
//                    s.append("+")
//                } else if let agentChar = self.agentAt(row: row, col: col) {
//                    s.append(agentChar)
//                } else {
//                    s.append(" ")
//                }
//            }
//            s.append("\n")
//        }
//        return s
//    }
//
//    // Function to get agent at specific location
//    private func agentAt(row: Int, col: Int) -> Character? {
//        for i in 0..<self.agentRows.count {
//            if self.agentRows[i] == row && self.agentCols[i] == col {
//                return Character(String(i))
//            }
//        }
//        return nil
//    }
//}

