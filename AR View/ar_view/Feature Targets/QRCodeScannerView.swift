//
//  QRCodeScannerView.swift
//  ar_view
//
//  Created by Last Lock
//

import SwiftUI
import AVFoundation

// QRCodeScannerView is a SwiftUI view representing a QR code scanner.
// The provided code for QRCodeScannerView and QRCodeScannerViewController is designed
// to handle QR code scanning and set the roomNumber when a QR code is successfully scanned.
struct QRCodeScannerView: UIViewControllerRepresentable {
    // Closure to handle the scanned QR code result.
    var handleScannedCode: (Result<String, Error>) -> Void
    
    // Create and return a UIViewController for the QR code scanner.
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = QRCodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
    
    // Create and return a Coordinator to manage communication between SwiftUI and UIViewController.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle AVCaptureMetadataOutputObjectsDelegate methods.
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }
        
        // Handle the detected metadata output (QR code).
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            // Check if there is a metadata object.
            if let metadataObject = metadataObjects.first {
                // Try to cast it as AVMetadataMachineReadableCodeObject (QR code).
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                // Get the string value from the QR code.
                guard let stringValue = readableObject.stringValue else { return }
                // Play a vibration sound when a QR code is successfully scanned.
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                // Trigger the handleScannedCode closure with the scanned QR code.
                parent.handleScannedCode(.success(stringValue))
            }
        }
    }
}

// QRCodeScannerViewController is a UIViewController responsible for the QR code scanning functionality.
class QRCodeScannerViewController: UIViewController {
    var captureSession: AVCaptureSession! // AVCaptureSession for managing the camera input.
    var previewLayer: AVCaptureVideoPreviewLayer! // AVCaptureVideoPreviewLayer to display the camera feed.
    var delegate: AVCaptureMetadataOutputObjectsDelegate? // Delegate to handle AVCaptureMetadataOutputObjectsDelegate methods.
    
    // Called when the view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()
        
        // Get the default video capture device (camera).
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            // Handle error (e.g., camera access denied)
            return
        }
        // Add the metadata output to the capture session.
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            // Handle the failure (e.g., camera input not supported)
            return
        }
        // Create AVCaptureMetadataOutput for processing metadata (QR code).
        let metadataOutput = AVCaptureMetadataOutput()

        // Add the metadata output to the capture session.
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            // Handle the failure (e.g., QR code output not supported)
            return
        }
        // Create AVCaptureVideoPreviewLayer to display the camera feed.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        // Add the preview layer to the view's layer.
        view.layer.addSublayer(previewLayer)
        // Start running the capture session to begin QR code scanning.
        captureSession.startRunning()
    }
    // Called when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start the capture session if it is not already running.
        if (!captureSession.isRunning) {
            captureSession.startRunning()
        }
    }
    // Called when the view is about to disappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the capture session when the view is no longer visible.
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
}

