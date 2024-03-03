//
//  graph.swift
//  shortPath
//
//  Created by Last Lock
//


import Foundation

let TOLERANCE = 1.2 // the margin of error allowed between doors on either
                  // side of a wall and have it still be considered a door

public class Graph: CustomStringConvertible {
    var nodes = [String: Node]()
    var paths: [Path]
    var building: Building
    
    
    init(building: Building) {
        nodes = [:]
        paths = []
        self.building = building
    }
    
    public var description: String {
        var strBuilder = ""
        for (key, _) in nodes {
            strBuilder += ("\n" + nodes[key]!.description)
        }
        return strBuilder
    }
    /**
     Turns all rooms into nodes, without paths added
     */
    func nodifyRooms(){
        for room in building.rooms {
            nodes[room.name] = Node(name: room.name)
            //nodes.append(Node(name: room.name))
        }
        for n in nodes {
            print(n)
        }
    }
    
    func createPaths(){
        if nodes.isEmpty {
            print("Node array is empty, nodifyRooms() first")
            return
        }
        let rooms = building.rooms
        for room in rooms {
            var borderingRooms = [String]()
            let currNode = nodes[room.name]!
            for door in room.doors {
                let matchingDoor = findMatches(currDoor: door, currRoom: room)
                if matchingDoor == "" {
                    continue
                } else {
                    borderingRooms.append(matchingDoor)
                }
            }
            //print("For " + room.name + ": " + borderingRooms.description)
            addPathsToNode(currNode: currNode, borderingRooms: borderingRooms)
        }
    }
    
    func addPathsToNode(currNode: Node, borderingRooms: [String]) {
        for roomString in borderingRooms {
            currNode.addPath(startNode: currNode, endNode: nodes[roomString]!)
        }
    }
    
    
    // For a door, searches all other doors besides for the room that the door is in
    func findMatches(currDoor: Door, currRoom: Room) -> String {
        var matchingRoomString: String = ""
        for room in building.rooms {
            //ensures the current room is skipped over
            if currRoom.name == room.name {
                continue
            }
            //this iterates through every other door in other rooms
            for door in room.doors {
                if isMatchingDoor(currDoor: currDoor, newDoor: door) {
                    matchingRoomString = room.name
                }
                
            }
        }
        return matchingRoomString
    }
    
    func isMatchingDoor(currDoor: Door, newDoor: Door) -> Bool {
        var xAxisMatches = false
        var yAxisMatches = false
        
        if abs(currDoor.doorCorner1[0] - newDoor.doorCorner1[0]) <= TOLERANCE {
            xAxisMatches = true
        }
        if abs(currDoor.doorCorner1[0] - newDoor.doorCorner2[0]) <= TOLERANCE {
            xAxisMatches = true
        }
        if abs(currDoor.doorCorner2[0] - newDoor.doorCorner1[0]) <= TOLERANCE {
            xAxisMatches = true
        }
        if abs(currDoor.doorCorner2[0] - newDoor.doorCorner2[0]) <= TOLERANCE {
            xAxisMatches = true
        }
        if abs(currDoor.doorCorner1[1] - newDoor.doorCorner1[1]) <= TOLERANCE {
            yAxisMatches = true
        }
        if abs(currDoor.doorCorner1[1] - newDoor.doorCorner2[1]) <= TOLERANCE {
            yAxisMatches = true
        }
        if abs(currDoor.doorCorner2[1] - newDoor.doorCorner1[1]) <= TOLERANCE {
            yAxisMatches = true
        }
        if abs(currDoor.doorCorner2[1] - newDoor.doorCorner2[1]) <= TOLERANCE {
            yAxisMatches = true
        }
        
        if xAxisMatches && yAxisMatches {
            return true
        }
        
        
        return false
    }
}

extension Graph {

    //implement dijkstra's shortest path
    func dijkstraShortestPath(from start: Node, to end: Node) -> [String] {
        var distances: [String: Int] = [:]
        var previous: [String: String?] = [:]
        
        var unvisited: Set<String> = Set(nodes.keys)
        
        for node in unvisited {
            distances[node] = Int.max
        }
        
        distances[start.name] = 0
        
        while !unvisited.isEmpty {
            let currentNode = unvisited.min { distances[$0, default: Int.max] < distances[$1, default: Int.max] }
            
            guard let current = currentNode else {
                break
            }
            
            if current == end.name {
                var path: [String] = [end.name]
                var currentNode = end.name
                while let prev = previous[currentNode], prev != nil {
                    path.insert(prev!, at: 0)
                    currentNode = prev!
                }
                return path
            }
            
            for path in nodes[current]!.paths {
                let alternative = distances[current, default: Int.max] + path.weight
                if alternative < distances[path.finishNode.name, default: Int.max] {
                    distances[path.finishNode.name] = alternative
                    previous[path.finishNode.name] = current
                }
            }
            
            unvisited.remove(current)
        }
        
        return [] // No path found
    }
}

