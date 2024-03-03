//
//  CustomARView.swift
//  ar_view
//
//  Created by Last Lock
//

import ARKit
import RealityKit
import SwiftUI
import UIKit
import AVFoundation
import simd

// CustomARView is a UIViewController that manages the AR experience for indoor navigation.
class CustomARView: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    var anchors: [ARAnchor] = []
    var arrowQueue: [[Float]] = []
    var isUserFacingAnchor = false

    var coordinator: ARCoordinator?
    
    // State variables to control AR view behavior when isFlashing changes
    var isFlashing: Bool = false {
        didSet {
            if isFlashing {
                self.updateFlashingState()
            } else {
                self.updateFlashingState()
            }
        }
    }
    var direction: String = "" {
        didSet {
            self.updateDistDisplay()
        }
    }
    var roomNum = ""
    
    // Called after the view controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init backend
        getRoomScanInfo()
        
        // Initialize the scene view
        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene and assign it to the scene view
        sceneView.scene = SCNScene()
        
        // Setup Auto Layout constraints for scene view
        setupSceneViewConstraints()
        
        // Place Location Markers
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.placeArrows()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run AR session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
        
        // Stop QR code scanning if it's running
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the AR session
        sceneView.session.pause()
    }
    
    func setupSceneViewConstraints() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // Place arrows in the AR scene based on navigation steps
    func placeArrows() {
        // Ideally, we can pass this roomNumber to consolidatedTestSteps and get the directions for this specific room
        print(roomNum)
        
        // Might make more sense if we consolidate all the steps to only be concerned with one singular direction as
        // I think this would improve the ability for the ARAnchors to have better tracking. Ex: instead of having
        // [-0.5, 0.0, -1.0], we can split this into 2 steps [-0.5, 0.0, 0.0] and [0.0, 0.0, -1.0]. This is because
        // the ARAnchors really struggle when it comes to walls/obstacles, so if we can just limit the directions to
        // things directly in the user's line of sight, this would probably make the ARAnchors more reliable
        
        //let consolidatedTestSteps = consolidateSteps(steps: testRoom.shortestNodePath(startCoord: startCoor, endCoord: endCoor))
        let consolidatedTestSteps = [[0.0, 0.0, -2.0], [0.0, 0.0, -2.0], [0.0, 0.0, -3.0], [0.0, 0.0, -3.0]]
        for coordinates in consolidatedTestSteps {
            if coordinates.count == 3 {
                arrowQueue.append(coordinates.map { Float($0) })
            }
        }

        if let firstArrowCoordinates = arrowQueue.first {
            placeArrow(x_dist: firstArrowCoordinates[0], y_dist: firstArrowCoordinates[1], z_dist: firstArrowCoordinates[2])
        }
    }
    
    // Place a single arrow in the AR scene
    func placeArrow(x_dist: Float, y_dist: Float, z_dist: Float) {
        // Get the current camera transform
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            print("Unable to get the current camera transform.")
            return
        }
        
        // z_dist is front (neg) and back (positive)
        // x_dist and y_dist refers same value, left (neg) or right (positive);
        // Adjust translation vector based on arrow position
        var translationVector = SIMD3<Float>(x_dist, y_dist, z_dist)
        if x_dist != 0 {
            translationVector = SIMD3<Float>(x_dist, x_dist, z_dist)
        }
        else {
            translationVector = SIMD3<Float>(y_dist, y_dist, z_dist)
        }
        // Translate the camera transform to place the arrow
        let translationMatrix = simd_float4x4.translate(matrix: cameraTransform, vector: translationVector)
        // Create a custom AR anchor and add it to the session
        let anchor = BeaconAnchor(transform: translationMatrix)
        sceneView.session.add(anchor: anchor)
        anchors.append(anchor)
    }
    
    func calculateDistanceFromUser(to anchor: ARAnchor) -> Float {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            print("Unable to get the current camera transform.")
            return -1
        }
        
        // Convert the anchor's transform to a vector
        let anchorPosition = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
        
        // Convert the camera's transform to a vector
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        // Calculate the distance between the camera and the anchor
        let distanceVector = simd_distance(simd_float3(anchorPosition), simd_float3(cameraPosition))
        return distanceVector
    }
    
    //  This function is called whenever a new anchor is added to the AR scene. In this specific case, it's triggered when a BeaconAnchor is added. The function performs the following actions:
    //    Checks if the anchor is of type BeaconAnchor.
    //    Loads a 3D model of an arrow (Arrow.usdz) from the app's bundle using SCNReferenceNode and sets its position based on the anchor's transform.
    //    Creates a text node displaying the distance from the camera to the arrow and positions it above the arrow.
    //    Ensures that the text node always faces the camera using a billboard constraint.
    //    Adds both the arrow node and the text node to the provided SCNNode, which is a representation of the AR scene graph.
    //    Stores references to the arrow node and text node in the corresponding properties of the BeaconAnchor for later updates.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let beaconAnchor = anchor as? BeaconAnchor {
            if let modelPath = Bundle.main.url(forResource: "Arrow", withExtension: "usdz") {
                let referenceNode = SCNReferenceNode(url: modelPath)
                referenceNode?.load()
                
                let arrowPosition = SCNVector3(beaconAnchor.transform.columns.3.x, beaconAnchor.transform.columns.3.y, beaconAnchor.transform.columns.3.z)
                referenceNode?.position = arrowPosition
                
                DispatchQueue.main.async {
                    if let referenceNode = referenceNode {
                        node.addChildNode(referenceNode)
                        beaconAnchor.arrowNode = referenceNode
                        
                        // Distance from camera to the arrow
                        let distance = self.calculateDistanceFromUser(to: beaconAnchor)
                        
                        // text node todisplay the distance
                        let text = SCNText(string: String(format: "%.2f ft", distance), extrusionDepth: 0.1)
                        text.font = UIFont.systemFont(ofSize: 10)
                        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
                        text.firstMaterial?.diffuse.contents = UIColor.white
                        
                        let textNode = SCNNode(geometry: text)
                        // Scale down the size of the text node
                        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
                        // Position the text node above the arrow
                        textNode.position = SCNVector3(arrowPosition.x-0.5, arrowPosition.y, arrowPosition.z)
                        
                        // Ensure the text faces the camera
                        textNode.constraints = [SCNBillboardConstraint()]
                        
                        // Add the text node to the scene
                        node.addChildNode(textNode)
                        // Assign the text node to the anchor
                        beaconAnchor.textNode = textNode
                    }
                }
                
            } else {
                print("Failed to load USDZ model.")
            }
        }
    }
    //This function is called continuously during the AR scene rendering loop, allowing for real-time updates. Key actions in this function include:
    //    Iterates through all anchors stored in the anchors array.
    //    Checks if each anchor has associated arrow and text nodes.
    //    Determines whether the user is facing the arrow node and updates the isFlashing state accordingly.
    //    Calculates the updated distance between the camera and the arrow for each anchor.
    //    If the distance is less than or equal to 0.5 units, removes the arrow and text nodes, updates the arrowQueue, and triggers the placement of the next arrow.
    //    Updates the text node's content to display the current distance.
    //    Updates the direction state based on the current arrow's coordinates, providing guidance for the user's movement.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            for anchor in self.anchors {
                guard let beaconAnchor = anchor as? BeaconAnchor,
                      let textNode = beaconAnchor.textNode,
                      let arrowNode = beaconAnchor.arrowNode else {
                    continue
                }

                let updatedDistance = self.calculateDistanceFromUser(to: beaconAnchor)

                if self.isUserFacingArrow(arrowNode) {
                    self.isUserFacingAnchor = true
                    self.isFlashing = true
                } else {
                    self.isUserFacingAnchor = false
                    self.isFlashing = false
                }

                if updatedDistance <= 0.5 {
                    print("Arrow removed, updated arrow queue: \(self.arrowQueue)")
                    textNode.removeFromParentNode()
                    beaconAnchor.arrowNode?.removeFromParentNode()
                    self.anchors.removeAll { $0 === beaconAnchor }

                    if !self.arrowQueue.isEmpty {
                        self.arrowQueue.removeFirst()
                        if let nextArrowCoordinates = self.arrowQueue.first {
                            self.placeArrow(x_dist: nextArrowCoordinates[0], y_dist: nextArrowCoordinates[1], z_dist: nextArrowCoordinates[2])
                        }
                    }
                    if self.arrowQueue.isEmpty {
                        self.showCompletionScreen()
                        break
                    }
                } else {
                    if let textGeometry = textNode.geometry as? SCNText {
                        textGeometry.string = String(format: "%.2f meter(s)", updatedDistance)
                    }
                    
                    // Update display text based on distance and current direction
                    if let currArrowCoords = self.arrowQueue.first {
                        // Check if there is a left/right element
                        if currArrowCoords[0] != 0 {
                            if currArrowCoords[0] < 0 {
                                self.direction = "Turn Left, then move forward \(String(format: "%.2f", Float(updatedDistance))) m"
                            }
                            else {
                                self.direction = "Turn right, then move forward \(String(format: "%.2f", Float(updatedDistance))) m"
                            }
                        }
                        // Otherwise, only moving forward
                        else {
                            self.direction = "Move forward \(String(format: "%.2f", Float(updatedDistance))) m"
                        }
                    }
                    
                }
            }
        }
    }
    

    func isUserFacingArrow(_ arrowNode: SCNNode) -> Bool {
        guard let cameraTransform = sceneView.session.currentFrame?.camera.transform else {
            print("Unable to get the current camera transform.")
            return false
        }
        
        // Get arrow position and camera position, then see if they are in the same view or not
        let arrowWorldPosition = arrowNode.worldPosition
        let cameraWorldPosition = sceneView.pointOfView?.worldPosition ?? SCNVector3Zero

        let vectorToArrow = arrowWorldPosition - cameraWorldPosition
        let cameraForward = SCNVector3(cameraTransform[2].x, cameraTransform[2].y, cameraTransform[2].z)
        let dotProduct = simd_dot(simd_normalize(simd_float3(vectorToArrow)),
                                  simd_normalize(simd_float3(cameraForward)))

        // Adjust this threshold as needed
        let facingThreshold: Float = 0.01

        return dotProduct > facingThreshold
    }

    func updateFlashingState() {
        coordinator?.parent.isFlashing = isFlashing
    }
    
    func updateDistDisplay() {
        coordinator?.parent.direction = direction
    }
    
    func showCompletionScreen() {
        let alert = UIAlertController(title: "Destination Reached!", message: "All arrows have been removed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension simd_float4x4 {
    static func translate(matrix: simd_float4x4, vector: SIMD3<Float>) -> simd_float4x4 {
        var result = matrix
        result.columns.3 += SIMD4<Float>(vector.x, vector.y, vector.z, 0)
        return result
    }
}

extension SCNVector3 {
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
}

class BeaconAnchor: ARAnchor {
    var textNode: SCNNode?
    var arrowNode: SCNNode?
}
