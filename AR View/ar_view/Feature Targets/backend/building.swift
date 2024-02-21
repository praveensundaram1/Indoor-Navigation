//
//  building.swift
//  shortPath
//
//  Created by Last Lock
//

import Foundation

let STEP_SIZE = 1.0 //MUST BE A DOUBLE VALUE

public class Door: CustomStringConvertible{
    var doorCorner1: [Double]
    var doorCorner2: [Double]

    init(doorCorner1: [Double], doorCorner2: [Double]) {
        self.doorCorner1 = doorCorner1
        self.doorCorner2 = doorCorner2
    }
    
    public var description: String {
        return doorCorner1.description + " " + doorCorner2.description
    }
}


public class Obstacle: CustomStringConvertible {
    var obstacleCorner1: [Double]
    var obstacleCorner2: [Double]
    
    init(obstacleCorner1: [Double], obstacleCorner2: [Double]) {
        self.obstacleCorner1 = obstacleCorner1
        self.obstacleCorner2 = obstacleCorner2
    }
    
    public var description: String {
        return obstacleCorner1.description + " " + obstacleCorner2.description
    }
    
}

public class Room: CustomStringConvertible{
    var doors: [Door]
    var obstacles: [Obstacle]
    var name: String

    init(doors: [Door], name: String, obstacles: [Obstacle]) {
        self.doors = doors
        self.name = name
        self.obstacles = obstacles
        
    }
    
    public var description: String {
        return "\n" + name + " \nDoors: " + doors.description +  "\nObstacles: " + obstacles.description + "\n"
    }
    
    //creating struct so it can be used as key in hashtable
    struct Coordinate: Hashable {
        var x: Double
        var y: Double
        var z: Double
        
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
            hasher.combine(z)
        }
        
        func toArray() -> [Double] {
            return [x, y, z]
        }
    }
    
    /*
        DP algorithm that finds the easiest way to get from one coordinate in a room to another accounting obstacles in the calculation
     
     [[0,0,1], [1,0,0]
     */
    func shortestNodePath(startCoord: Coordinate, endCoord: Coordinate) -> [[Double]] {
        
        var distanceToCoordinate: [ Coordinate : Int ] = [:] //stores current cost to get to a spot in the room
        var shortestPathSteps: [[Double]] = []
        
        func recurNodePath(steps: [[Double]], currLocation: Coordinate) {
            //print("Entering Recursive Case")
            //base case, if we have arrived at our destination node
            if hasArrived(curr: currLocation.toArray(), dest: endCoord.toArray()) {
                //print("Recursive Case has Arrived with " + steps.count.description + "steps")
                if shortestPathSteps.count == 0 || steps.count < shortestPathSteps.count {
                    shortestPathSteps = steps
                }
                return
            }
            
            if let pathSteps = distanceToCoordinate[currLocation] {
                if pathSteps > steps.count { //if current amount of steps to coordinate is less than the stored count, update it
                    distanceToCoordinate[currLocation] = steps.count
                } else {
                    return //if it is greater or equal to it, this is a useless recursion as another instance will already traverse it
                }
            } else {
                distanceToCoordinate[currLocation] = steps.count //if current coordinate has never been visited, add how many steps it took
            }
            
            let neighbors = [
                Coordinate(x: currLocation.x + STEP_SIZE, y: currLocation.y, z: currLocation.z),
                Coordinate(x: currLocation.x - STEP_SIZE, y: currLocation.y, z: currLocation.z),
                Coordinate(x: currLocation.x, y: currLocation.y, z: currLocation.z + STEP_SIZE),
                Coordinate(x: currLocation.x, y: currLocation.y, z: currLocation.z - STEP_SIZE),
                Coordinate(x: currLocation.x + STEP_SIZE, y: currLocation.y, z: currLocation.z + STEP_SIZE),
                Coordinate(x: currLocation.x - STEP_SIZE, y: currLocation.y, z: currLocation.z - STEP_SIZE),
                Coordinate(x: currLocation.x + STEP_SIZE, y: currLocation.y, z: currLocation.z - STEP_SIZE),
                Coordinate(x: currLocation.x - STEP_SIZE, y: currLocation.y, z: currLocation.z + STEP_SIZE),
                
                ]
            
            if !isCollision(prevLocation: currLocation.toArray(), step: [STEP_SIZE, 0, 0]) { // if moving to the right won't cause a collision
                var newSteps = steps
                newSteps.append([STEP_SIZE, 0, 0])
                recurNodePath(steps: newSteps, currLocation: neighbors[0]) //recursively call one unit to the right
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [-(STEP_SIZE), 0, 0]) { // if moving to the left won't cause a collision
                var newSteps = steps
                newSteps.append([-(STEP_SIZE), 0, 0])
                recurNodePath(steps: newSteps, currLocation: neighbors[1]) //recursively call one unit to the left
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [0, 0, STEP_SIZE]) { // if moving to the left won't cause a collision
                var newSteps = steps
                newSteps.append([0, 0, STEP_SIZE])
                recurNodePath(steps: newSteps, currLocation: neighbors[2]) //recursively call one unit forwards
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [0, 0, -(STEP_SIZE)]) { // if moving to the left won't cause a collision
                var newSteps = steps
                newSteps.append([0, 0, -(STEP_SIZE)])
                recurNodePath(steps: newSteps, currLocation: neighbors[3]) //recursively call one backwards
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [STEP_SIZE, 0, STEP_SIZE]) {
                var newSteps = steps
                newSteps.append([STEP_SIZE, 0, STEP_SIZE])
                recurNodePath(steps: newSteps, currLocation: neighbors[4])
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [-(STEP_SIZE), 0, -(STEP_SIZE)]) {
                var newSteps = steps
                newSteps.append([-(STEP_SIZE), 0, -(STEP_SIZE)])
                recurNodePath(steps: newSteps, currLocation: neighbors[5])
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [STEP_SIZE, 0, -(STEP_SIZE)]) {
                var newSteps = steps
                newSteps.append([STEP_SIZE, 0, -(STEP_SIZE)])
                recurNodePath(steps: newSteps, currLocation: neighbors[6])
            }
            if !isCollision(prevLocation: currLocation.toArray(), step: [-(STEP_SIZE), 0, STEP_SIZE]) {
                var newSteps = steps
                newSteps.append([-(STEP_SIZE), 0, STEP_SIZE])
                recurNodePath(steps: newSteps, currLocation: neighbors[7])
            }
            

            
        }
        recurNodePath(steps: [[]], currLocation: startCoord)
        return shortestPathSteps
    }
    
    func hasArrived(curr: [Double], dest: [Double]) -> Bool {
        if abs(curr[0] - dest[0]) < TOLERANCE && abs(curr[2] - dest[2]) < TOLERANCE {
            return true
        }
        return false
    }
    /*
    prevLocation is an xyz representation of where the user is in the coordinate plane.
     Ex: [5, 0, 4], where x=5, y=0, z=4
     
    step is an xyz representation of the change of location that the algorithm is attempting
     Ex: [0, 0, 1], where the algorithm is stepping the user 1 unit in the z direction
     */
    func isCollision(prevLocation: [Double], step: [Double]) -> Bool {
    //if user is moving in the x direction, going right or left
        if step[0] != 0 {
            for obstacle in obstacles {
                if isXObstacleCollision(prevLocation: prevLocation, step: step, obstacle: obstacle) {
                    return true
                }
            }
        }
        //if user is moving in y direction (probably not happening unless they are climbing stairs or something)
        if step[1] != 0 {
            //unimplemented for now, as we are currently only working in two dimensions
        }
        //if user is moving in z direction
        if step[2] != 0 {
            for obstacle in obstacles {
                if isZObstacleCollision(prevLocation: prevLocation, step: step, obstacle: obstacle) {
                    return true
                }
            }
        }
        //if user is moving diagonally, ALSO check if the spot they are moving to is obstructed
        if step[0] != 0 && step[2] != 0 {
            for obstacle in obstacles {
                if isDiagObstacleCollision(prevLocation: prevLocation, step: step, obstacle: obstacle) {
                    return true
                }
            }
        }
    
        return false
    }
    /*
     Helper method to see if moving in the x direction causes a wall collision
     */
    func isXObstacleCollision(prevLocation: [Double], step: [Double], obstacle: Obstacle) -> Bool {
        //compares the Z location of the wall and the current location, to see if stepping in x direction could even hit wall
        if !isBetween(value: prevLocation[2], bound1: obstacle.obstacleCorner1[2], bound2: obstacle.obstacleCorner2[2]) {
            return false//if we aren't even positioned in front of wall, collision is impossible
        }
        //if we are stepping in positive x direction, we must check the smaller of the wall x dimensions to see if we step through it
        if step[0] > 0 {
            var boundary = min(obstacle.obstacleCorner1[0], obstacle.obstacleCorner2[0])
            if isBetween(value: boundary, bound1: prevLocation[0], bound2: prevLocation[0] + step[0]) {
                return true
            }
        //this means that we are stepping in negative x direction
        } else {
            let boundary = max(obstacle.obstacleCorner1[0], obstacle.obstacleCorner2[0])
            if isBetween(value: boundary, bound1: prevLocation[0], bound2: prevLocation[0] + step[0]) {
                return true
            }
        }
        return false
    }
    
    func isZObstacleCollision(prevLocation: [Double], step: [Double], obstacle: Obstacle) -> Bool {
        //compares the X location of the wall and the current location, to see if stepping in Z direction could even hit wall
        if !isBetween(value: prevLocation[0], bound1: obstacle.obstacleCorner1[0], bound2: obstacle.obstacleCorner2[0]) {
            return false//if we aren't even positioned in front of wall, collision is impossible
        }
        //if we are stepping in positive x direction, we must check the smaller of the wall x dimensions to see if we step through it
        if step[2] > 0 {
            var boundary = min(obstacle.obstacleCorner1[2], obstacle.obstacleCorner2[2])
            if isBetween(value: boundary, bound1: prevLocation[2], bound2: prevLocation[2] + step[2]) {
                return true
            }
        //this means that we are stepping in negative x direction
        } else {
            var boundary = max(obstacle.obstacleCorner1[2], obstacle.obstacleCorner2[2])
            if isBetween(value: boundary, bound1: prevLocation[2], bound2: prevLocation[2] + step[2]) {
                return true
            }
        }
        return false
    }

    /*
    isCollision() helper method to see if a specified diagonal move will cause a collision
    */
    func isDiagObstacleCollision(prevLocation: [Double], step: [Double], obstacle: Obstacle) -> Bool{
        let newLocation = addArraysElements(array1: prevLocation, array2: step)

        if isXObstacleCollision(prevLocation: [prevLocation[0], newLocation[1], newLocation[2]], step: [step[0], 0, 0], obstacle: obstacle) {
            return true
        }
        if isZObstacleCollision(prevLocation: [newLocation[0], newLocation[1], prevLocation[2]], step: [0, 0, step[2]], obstacle: obstacle) {
            return true
        }
        return false
        
    }
    
    
    func isBetween(value: Double, bound1: Double, bound2: Double) -> Bool {
        let lowerBound = min(bound1, bound2)
        let upperBound = max(bound1, bound2)
        return value >= lowerBound && value <= upperBound
    }
    
    func addArraysElements(array1: [Double], array2: [Double]) -> [Double] {
        guard array1.count == array2.count else {
            fatalError("Arrays must have the same size.")
        }

        let result = zip(array1, array2).map { $0 + $1 }
        return result
    }
    
    
}


public class Building {
    var rooms: [Room]
    
    init(rooms: [Room]) {
        self.rooms = rooms
    }
    
    
}
