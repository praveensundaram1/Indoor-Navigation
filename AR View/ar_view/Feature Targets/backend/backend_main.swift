//
//  backend_main.swift
//  shortPath
//
//  Created by Last Lock
//

import Foundation

//print("Hello, World!")


/// Consolidates consecutive identical steps in a path.
///
/// This function takes an array of steps, where each step is represented as an array of `Double`
/// values (typically representing movement in 3D space). It then combines consecutive identical
/// steps into single steps, each represented by their cumulative effect.
///
/// - Parameter steps: An array of steps, where each step is an array of `Double`.
/// - Returns: An array of consolidated steps.
func consolidateSteps(steps: [[Double]]) -> [[Double]] {
    var consolidatedSteps: [[Double]] = []

    // Check if the steps array is empty, return empty array if true
    guard let firstStep = steps.first, steps.count > 0 else {
        return consolidatedSteps
    }

    var currentStep = firstStep
    var stepCount = 0

    // Iterate through the steps array
    for step in steps {
        if step == currentStep {
            // If the step is the same as the current step, increase the count
            stepCount += 1
        } else {
            // If a different step is encountered, multiply the current step by its count and add to consolidated list
            consolidatedSteps.append(currentStep.map { $0 * Double(stepCount) })
            currentStep = step
            stepCount = 1
        }
    }

    // Add the last accumulated step to the consolidated list
    consolidatedSteps.append(currentStep.map { $0 * Double(stepCount) })

    return consolidatedSteps
}

/**
 As it stands, I am currently struggling with figuring out how to manually read in a usd file
 into swift, which is the step that directly needs to happen before this. The file must be read in,
 and a Building object must be created, which contains all the rooms that are detailed in the usd
 file.
 
 Within the USD file, it has the features of a room, such as the floor dimensions, door dimensions
 and wall dimensions, and any other furniture that may be inside the room
 
 We only really care about the doors. When turning this building object
 into an unweighted graph by using the nodify function, the algorithm matches up doors present in different rooms,
 and creates a path between two nodes (rooms) in the unweighted graph.
 
 Eventually we will care more about the floorspace and the walls, but I'm just trying to get it working
 for one floor structures.

 Because I can't figure out how to read from the usd file, I'm just going to create a bunch of rooms with doors manually
 from a diagram that I have drawn, so the graph-making algorithm works 
 */

//Room A
//var roomAdoor1 = Door(doorCorner1: [15, 10, 0], doorCorner2: [16,10.5, 3])
//var roomAdoor7 = Door(doorCorner1: [11, 15, 0], doorCorner2: [12, 14.5, 3])
//var roomAdoor5 = Door(doorCorner1: [9, 12, 0], doorCorner2: [9.5, 13, 3])
//var roomADoors = [roomAdoor1, roomAdoor7, roomAdoor5]
//
//var roomA = Room(roomCorner1: [9,15,0], roomCorner2: [19,10,4], doors: roomADoors, name: "RoomA")
//
////Room B
//var roomBdoor6 = Door(doorCorner1: [9, 17, 0], doorCorner2: [9.5, 18, 3])
//var roomBdoor7 = Door(doorCorner1: [12, 15, 0], doorCorner2: [11, 15.5, 3])
//var roomBDoors = [roomBdoor6, roomBdoor7]
//
//var roomB = Room(roomCorner1: [9,15,0], roomCorner2: [14,20,4], doors: roomBDoors, name: "RoomB")
//
////Room C
//var roomCdoor6 = Door(doorCorner1: [9, 17, 0], doorCorner2: [8.5, 18, 3])
//var roomCdoor5 = Door(doorCorner1: [9, 12, 0], doorCorner2: [8.5, 13, 3])
//var roomCdoor4 = Door(doorCorner1: [5, 10, 0], doorCorner2: [6, 10.5, 3])
//var roomCDoors = [roomCdoor4, roomCdoor5, roomCdoor6]
//
//var roomC = Room(roomCorner1: [3, 20, 0], roomCorner2: [9, 10, 4], doors: roomCDoors, name: "RoomC")
//
////Room D
//var roomDdoor4 = Door(doorCorner1: [5, 10, 0], doorCorner2: [6, 9.5, 3])
//var roomDdoor3 = Door(doorCorner1: [7, 2, 0], doorCorner2: [6.5, 3, 3])
//var roomDdoors = [roomDdoor4, roomDdoor3]
//
//var roomD = Room(roomCorner1: [7, 1, 0], roomCorner2: [4, 17, 4], doors: roomDdoors, name: "RoomD")
//
////Room E
//var roomEdoor3 = Door(doorCorner1: [7, 2, 0], doorCorner2: [7.5, 3, 3])
//var roomEdoor2 = Door(doorCorner1: [16, 4, 0], doorCorner2: [15, 3.5, 3])
//var roomEdoors = [roomEdoor2, roomEdoor3]
//
//var roomE = Room(roomCorner1: [7, 1, 0], roomCorner2: [4, 17, 4], doors: roomEdoors, name: "RoomE")
//
////Room F
//var roomFdoor2 = Door(doorCorner1: [16, 4, 0], doorCorner2: [15, 4.5, 3])
//var roomFdoor1 = Door(doorCorner1: [15, 10, 0], doorCorner2: [16,9.5, 3])
//var roomFdoors = [roomFdoor1, roomFdoor2]
//
//var roomF = Room(roomCorner1: [4, 17, 0], roomCorner2: [14, 10, 4], doors: roomFdoors, name: "RoomF")
//
////Making the building object
//var structure = Building(rooms: [roomA, roomB, roomC, roomD, roomE, roomF])
//
////print(structure.rooms.description)
//
//var graph = Graph(building: structure)
//
//graph.nodifyRooms()
//graph.createPaths()
//
//
//// Find the shortest path between Room1 and Room3
//let shortestPath = graph.dijkstraShortestPath(from: graph.nodes["RoomA"]!, to: graph.nodes["RoomE"]!)
//print("ShortestPath:", shortestPath)
//
//print(graph.description)

var northWall = Obstacle(obstacleCorner1: [0,0,0], obstacleCorner2: [10,0,0])
var southWall = Obstacle(obstacleCorner1: [0,0,-10], obstacleCorner2: [10,0,-10])
var westWall = Obstacle(obstacleCorner1: [0,0,0], obstacleCorner2: [0,0,-10])
var eastWall = Obstacle(obstacleCorner1: [10,0,0], obstacleCorner2: [10,0,-10])

var table = Obstacle(obstacleCorner1: [3, 0, -1], obstacleCorner2: [8, 0, -5])

var testRoom = Room(doors: [], name: "testroom", obstacles: [northWall,southWall,eastWall,westWall, table])

//print(testRoom.isCollision(prevLocation: [5, 0, -1.5], step: [0, 0, 1]))

let startCoor = Room.Coordinate(x: 1, y: 0, z: -1)
let endCoor = Room.Coordinate(x: 9, y: 0, z: -9)

let testSteps = testRoom.shortestNodePath(startCoord: startCoor, endCoord: endCoor)
//print(testSteps)

let consolidateTestSteps = consolidateSteps(steps: testSteps)

//func readAndPrintOBJFile(atPath filePath: String) {
//    do {
//        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
//        print(fileContents)
//    } catch {
//        print("Error reading the file: \(error)")
//    }
//}
//
//// Construct the path to the "room_obj.obj" file in the same directory as main.swift
//let fileName = "room_obj.obj"
//let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(fileName).path

// Example usage:
//readAndPrintOBJFile(atPath: filePath)
