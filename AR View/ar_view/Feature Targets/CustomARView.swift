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
import CoreLocation


// CustomARView is a UIViewController that manages the AR experience for indoor navigation.
class CustomARView: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var anchors: [ARAnchor] = []
    var arrowQueue: [[Float]] = []
    var isUserFacingAnchor = false
    
    var coordinator: ARCoordinator?

    var current_angle: Double = 0.0

    
    
    var roomNum = ""
    
    let locationManager = CLLocationManager()



    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        print (heading.magneticHeading)
        current_angle = heading.magneticHeading
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if (CLLocationManager.headingAvailable()) {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
        
        //init backend
//        getRoomScanInfo()
        let url = URL(string: "https://lastlock.shreymodi.tech/find_path")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "name": "Final Demo",
            "start": [
                0,
                1
            ],
            "end": [
                -8,
                15
            ]
            ]
            var list_of_points: [SCNVector3] = []
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)
                    print("Received data:\n\(str ?? "")")
                    let data = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let path = data["path"] as! [[Double]]
                    
                    for coordinates in path {
                        if coordinates.count == 2 {
                            // should be coordinates[0], 0.0, coordinates[1]
                            // add to pathNode
                            list_of_points.append(SCNVector3(coordinates[0], -1.0, coordinates[1]))
                        }
                    }
                    
                }
            }
            
            task.resume()
            sleep(2)
//            var list_of_points: [SCNVector3] = []
//            list_of_points.append(SCNVector3(0, -1.0, 0))

        task.resume()
        var wait_counter = 0
        while list_of_points.isEmpty || wait_counter < 8 {
            wait_counter+=1
            sleep(1)
        }

        let starting_angle = 30.001

        // rotate the path by difference between starting angle and current angle around the origin
        let angle_diff = starting_angle - locationManager.heading!.magneticHeading
        let angle_diff_rad = angle_diff * Double.pi / 180.0
        for i in 0..<list_of_points.count {
            let x = Double(list_of_points[i].x)
            let z = Double(list_of_points[i].z)
            let angle_diff_rad = Double(angle_diff_rad)

            // guard let x = x, let z = z, let angle_diff_rad = angle_diff_rad else {
            //     print("Error: Unable to convert to Double")
            //     return
            // }

            let cos_angle_diff_rad = cos(angle_diff_rad)
            let sin_angle_diff_rad = sin(angle_diff_rad)

            let x_cos_angle_diff_rad = x * cos_angle_diff_rad
            let z_sin_angle_diff_rad = z * sin_angle_diff_rad
            let x_sin_angle_diff_rad = x * sin_angle_diff_rad
            let z_cos_angle_diff_rad = z * cos_angle_diff_rad

            let new_x = x_cos_angle_diff_rad - z_sin_angle_diff_rad
            let new_z = x_sin_angle_diff_rad + z_cos_angle_diff_rad

            list_of_points[i].x = Float(new_x)
            list_of_points[i].z = Float(new_z)
        }




        

        let pathNode = SCNPathNode(path: list_of_points)
        print(pathNode.path)
        
        
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
        pathNode.materials = [pathMat]
        pathNode.position.y += 0.05
        pathMat.diffuse.contents = UIImage(named: "path_with_fade")
        
        pathNode.width = 0.5
        
        self.sceneView.scene.rootNode.addChildNode(pathNode)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if roomNum != "" {
            
            // Run AR session configuration
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal, .vertical]
            configuration.environmentTexturing = .automatic
            sceneView.session.run(configuration)
        //}
        
        // Stop QR code scanning if it's running
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the AR session
//        if roomNum != "" {
            sceneView.session.pause()
        //}
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
    
}
