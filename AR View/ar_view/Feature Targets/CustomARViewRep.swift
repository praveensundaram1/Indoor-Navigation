//
//  CustomARViewRep.swift
//  ar_view
//
//  Created by Last Lock
//

import SwiftUI

// ARCoordinator is a class that acts as a coordinator for communication between SwiftUI and CustomARView.
class ARCoordinator: NSObject {
    var parent: CustomARViewRep
     
    init(parent: CustomARViewRep) {
        self.parent = parent
    }
}

// CustomARViewRep is a SwiftUI representation of a UIViewController for AR functionality.
struct CustomARViewRep: UIViewControllerRepresentable {
    @Binding var isFlashing: Bool
    @Binding var direction: String
    @Binding var roomNum: String
    
    // Create and return an instance of ARCoordinator.
    func makeCoordinator() -> ARCoordinator {
        return ARCoordinator(parent: self)
    }
    
    // Create and return a UIViewController for AR functionality.
    func makeUIViewController(context: Context) -> CustomARView {
        let viewController = CustomARView()
        // Set the coordinator for communication with SwiftUI.
        viewController.coordinator = context.coordinator
        return viewController
    }
    
    // Update the UIViewController when SwiftUI state changes.
    func updateUIViewController(_ uiView: CustomARView, context: Context) {
        // Ensure updates are performed on the main thread.
        DispatchQueue.main.async {
            // Update AR view properties based on SwiftUI state.
            uiView.isFlashing = isFlashing
            uiView.direction = direction
            uiView.roomNum = roomNum
        }
    }
}
