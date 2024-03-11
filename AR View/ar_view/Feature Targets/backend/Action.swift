//
//  Action.swift
//  ar_view
//
//  Created by Sara Chin on 4/3/24.
//

import Foundation


enum ActionType {
    case noOp, move, push, pull
}

enum Action {
    case noOp(name: String)
    case move(name: String, agentRowDelta: Int, agentColDelta: Int)
    case push(name: String, agentRowDelta: Int, agentColDelta: Int, boxRowDelta: Int, boxColDelta: Int)
    case pull(name: String, agentRowDelta: Int, agentColDelta: Int, boxRowDelta: Int, boxColDelta: Int)
    
    var details: (name: String, type: ActionType, agentRowDelta: Int, agentColDelta: Int, boxRowDelta: Int, boxColDelta: Int) {
        switch self {
        case .noOp(let name):
            return (name, .noOp, 0, 0, 0, 0)
        case .move(let name, let agentRowDelta, let agentColDelta):
            return (name, .move, agentRowDelta, agentColDelta, 0, 0)
        case .push(let name, let agentRowDelta, let agentColDelta, let boxRowDelta, let boxColDelta):
            return (name, .push, agentRowDelta, agentColDelta, boxRowDelta, boxColDelta)
        case .pull(let name, let agentRowDelta, let agentColDelta, let boxRowDelta, let boxColDelta):
            return (name, .pull, agentRowDelta, agentColDelta, boxRowDelta, boxColDelta)
        }
    }
}

// Example Usage
//let action = Action.push(name: "Push(N,N)", agentRowDelta: -1, agentColDelta: 0, boxRowDelta: -1, boxColDelta: 0)
//let actionDetails = action.details
//
//print("Action Name: \(actionDetails.name)")
//print("Action Type: \(actionDetails.type)")
//print("Agent Row Delta: \(actionDetails.agentRowDelta)")
//print("Agent Col Delta: \(actionDetails.agentColDelta)")
//print("Box Row Delta: \(actionDetails.boxRowDelta)")
//print("Box Col Delta: \(actionDetails.boxColDelta)")
//
