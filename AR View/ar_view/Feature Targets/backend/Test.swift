////
////  Test.swift
////  ar_view
////
////  Created by Sara Chin on 4/2/24.
////
//
//// Example setup
//import Foundation
//
//State.walls = [
//    [false, false, false, false, false],
//    [false, true,  true,  true,  false],
//    [false, false, false, false, false]
//]
//
//State.agentColors = [.blue] // Assuming you have an enum for colors
//State.boxColors = [.red] // Same assumption as above
//State.goals = [
//    [" ", " ", " ", " ", " "],
//    [" ", " ", "A", " ", " "],
//    [" ", " ", " ", " ", " "]
//]
//
//let initialState = State(agentRows: [1], agentCols: [1], boxes: [
//    [" ", " ", " ", " ", " "],
//    [" ", " ", "0", " ", " "],
//    [" ", " ", " ", " ", " "]
//])
//
//
//let heuristicAStar = HeuristicAStar()
//let heuristicWeightedAStar = HeuristicWeightedAStar(w: 2) // Weight of 2 as an example
//let heuristicGreedy = HeuristicGreedy()
//
//print("Heuristic A* Score: \(heuristicAStar.f(initialState))")
//print("Heuristic Weighted A* Score: \(heuristicWeightedAStar.f(initialState))")
//print("Heuristic Greedy Score: \(heuristicGreedy.f(initialState))")
//
//
//// This test should show that the initial state is not a goal state, and it should
//// print details about each expanded state, such as the agent's new position.
