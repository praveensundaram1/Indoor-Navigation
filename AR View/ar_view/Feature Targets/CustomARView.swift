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
import SCNPath

// CustomARView is a UIViewController that manages the AR experience for indoor navigation.
class CustomARView: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var anchors: [ARAnchor] = []
    var arrowQueue: [[Float]] = []
    var isUserFacingAnchor = false
    
    var coordinator: ARCoordinator?
    var pathNode = SCNPathNode(path: [
        // X Y Z (-Y because below camera,-Z because back of camera)
        SCNVector3(0, -1, 0), //Test Anchor Origin
        SCNVector3(0, -1, -5), //Test anchor 5 m in front
        SCNVector3(1, -1, -5) //Test anchor 5 m in front 1 m left
      ])
    
    
    var roomNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init backend
        getRoomScanInfo()
        
        // Initialize the scene view
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene and assign it to the scene view
        sceneView.scene = SCNScene()
        
        // Setup Auto Layout constraints for scene view
        setupSceneViewConstraints()
        
        
        // the next chunk of lines are just things I've added to make the path look nicer
        let pathMat = SCNMaterial()
        self.pathNode.materials = [pathMat]
        self.pathNode.position.y += 0.05
        pathMat.diffuse.contents = UIImage(named: "path_with_fade")
        
        self.pathNode.width = 0.5
        
        self.sceneView.scene.rootNode.addChildNode(self.pathNode)
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical, let geom = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!) {
            geom.update(from: planeAnchor.geometry)
            geom.firstMaterial?.colorBufferWriteMask = .alpha
            node.geometry = geom
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical, let geom = node.geometry as? ARSCNPlaneGeometry {
            geom.update(from: planeAnchor.geometry)
        }
    }
}
