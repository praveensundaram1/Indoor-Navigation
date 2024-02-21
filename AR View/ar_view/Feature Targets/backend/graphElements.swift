//
//  node.swift
//  shortPath
//
//  Created by Last Lock
//

public class Path: CustomStringConvertible {
    var beginNode: Node
    var finishNode: Node
    var weight: Int
    
    init(beginNode: Node, finishNode: Node) {
        self.beginNode = beginNode
        self.finishNode = finishNode
        weight = 1 //subject to change, placeholder for now
    }
    
    public var description: String {
        return beginNode.name + " -> " + finishNode.name
    }
    
    
    
}

public class Node: CustomStringConvertible {
    var paths: [Path]
    var name: String
    
    init(name: String){
        self.name = name
        self.paths = []
    }
    
    public var description: String {
        return "name: " + name + " Paths: " + paths.description
    }
    
    
    func addPath(startNode: Node, endNode: Node) {
        paths.append(Path(beginNode: startNode, finishNode: endNode))
    }
}
