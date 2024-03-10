//
//  ContentView.swift
//  ar_view
//
//  Created by Last Lock
//

import SwiftUI
import AVFoundation

import Foundation
// import EventList

/*
 
 List of things to learn / know before attempting to figure out the codebase (to make your lives easier)
 - Swift UI (VStack, HStack, ZStack, how to create UI components in swift from a design)
 - @State tag and defining source of truths in an application
 - Protocols and Delegates (vvv important to understand this. Everything will be alien until this is understood)
 - DispatchQueue and running async functions with priority
 - SceneView + its delegates - https://developer.apple.com/documentation/scenekit/sceneview
 - Vector computations  - scalar vector products, basic transformations, Jacobian transformations, ....
    - if you don't know these topics, how come you're in this advanced class? hmmmm
    
 
 Decently complicated topic, read after going though the codebase and understanding the above mentioned topics
 A quick note on what the hell SCNVector3 and simd_float are (you'll see them being used a lot in the codebase
 
 SIMD - Single Instruction Multiple Data - tdlr this data type enables a processor to execute multiple instructions from a single command.
    Works similar to Matrices
 SCNVector - "Extension" of SIMD to support usage in SceneKit - tdlr to efficiently store and use data in AR/VR SCNVector was created
 
 In theory both of these can work hand in hand with SCNVector having slightly more initializers and support for more data types. 
 */


// ContentView is the initial view presented to the user.
struct ContentView: View {
    // State variables to track the room number entered by the user and whether the QR code scanner should be shown.
    @State private var roomNumber: String = ""
    @State private var isShowingScanner = false

    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.white, .blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                // Column displaying team name "First Direction", logo and direction prompt
                VStack (spacing: 8) {
                    Text("First Direction")
                        .bold()
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, 50)
                    VStack {
                        Image("lastlocklogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height: 180, alignment: .center)
                    }
                    Text("Enter your destination")
                        .bold()
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, 100)
                    TextField("Destination", text: $roomNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    // NavigationLink to transition to ARViewWithBars when "Start AR View" is tapped.
                    NavigationLink(destination: ARViewWithBars(roomNum: $roomNumber).ignoresSafeArea()) {
                        Text("Start AR View")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            /*
                            // testing out usage of EventList
                            .onTapGesture {
                                // Call printEvents function here
                                EventList.addMockEvents()
                                EventList.printEvents()
                                // print the title of the event at index 3
                                let index: Int = 3
                                if let event = EventList.getEvent(at: index) {
                                    print("The title of the event at index \(index) is \(event.title)")
                                }
                            }
                            */
                    }
                    Button(action: {
                        self.isShowingScanner = true
                    }) {
                        Text("Scan QR Code")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $isShowingScanner) {
                        QRCodeScannerView { result in
                            switch result {
                            case .success(let code):
                                // If the QR code is successfully scanned, set the roomNumber.
                                self.roomNumber = code
                                self.isShowingScanner = false
                            case .failure(let error):
                                self.isShowingScanner = false
                                // Handle any errors
                                print(error.localizedDescription)
                            }
                        }
                    }
                    Spacer()
                    /*
                    HStack {
                        Button(action: {
                            // Button action here
                        }) {
                            Text("Button 1")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Button action here
                        }) {
                            Text("Button 2")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Button action here
                        }) {
                            Text("Button 3")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)
                     */
                }
            }
        }
    }
}



