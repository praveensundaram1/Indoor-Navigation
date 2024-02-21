# Last-Lock-Team-02 - `Main` Branch

## Introduction 
The provided code represents an iOS app using SwiftUI and ARKit for a partial solution to indoor navigation. Here's a general overview of how the app works:
Backend:
The backend does not currently generate the graph from the RoomPlan object file. The file must be read in and a Building object must be created,
which contains all the rooms that are detailed in the usd file. Instead, the building object is currently hard-coded and the graph-making algorithm is ran on it.

Frontend: 
The frontend is using a hard-coded path in the CustomARView due to the partial implementation of the backend.

ContentView (Initial Screen): 
The app starts with the ContentView, which is the initial screen the user sees.
It includes a gradient background, an image (presumably a logo), a text field for entering the destination (roomNumber), and buttons for starting an AR view and scanning a QR code.

ARViewWithBars:
When the user taps "Start AR View" in ContentView, it navigates to the ARViewWithBars.
ARViewWithBars is a SwiftUI view that combines a custom AR view (CustomARViewRep) with top and bottom bars.
It receives the roomNumber as a binding and manages flashing behavior and navigation directions.

CustomARViewRep (AR Coordinator): 
CustomARViewRep is a coordinator between SwiftUI and the AR view.
It sets up the AR view (CustomARView) and updates its properties based on SwiftUI state changes.

CustomARView (AR Navigation): 
CustomARView is a UIViewController conforming to ARSCNViewDelegate for AR navigation.
It uses ARKit to create an AR session and displays arrows indicating navigation directions.
Arrows are placed based on the roomNumber entered by the user, and their positions are calculated and updated in the AR world.
The app continuously checks the user's position and adjusts the display, such as updating distances and directions.

AR Anchors and Distance Calculation: 
AR Anchors (BeaconAnchor) are used to place arrows in the AR environment.
The distance from the user to each arrow is calculated based on the camera's transform and anchor positions.
Flashing and Direction Display:

The app determines if the user is facing an arrow, triggering flashing and updating the navigation direction accordingly.

Completion Screen: 
When all arrows are removed (indicating the destination is reached), a completion screen is displayed.

QR Code Scanning: 
The app allows users to scan a QR code to set the roomNumber.
Tapping "Scan QR Code" in ContentView opens a sheet with a QR code scanner (QRCodeScannerView).

QRCodeScannerView: 
QRCodeScannerView is a UIViewControllerRepresentable that utilizes AVFoundation for QR code scanning.
When a QR code is successfully scanned, it updates the roomNumber in the SwiftUI view hierarchy.
