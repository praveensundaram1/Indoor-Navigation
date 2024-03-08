//
//  EventsPage.swift
//  ar_view
//
//  Created by Sara Chin on 3/11/24.
//

import Foundation
import SwiftUI

//func setupSceneViewConstraints() {
//    sceneView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//        sceneView.topAnchor.constraint(equalTo: view.topAnchor),
//        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//    ])
//}

struct EventsView: View {
    @State private var isClicked = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.white, .blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                // Column displaying team name "First Direction", logo and direction prompt
                VStack (spacing: 2) {
                    Text("All Events")
                        .bold()
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
//                        .padding(.trailing, 10)
//                        .padding(.top, 5)
                        .position(x:100, y:50)
                        //.frame(width: 100, height: 400, alignment: .topLeading)
                        //.padding(.top, 5)
                    // NavigationLink to transition to ARViewWithBars when "Start AR View" is tapped.
                    Grid(horizontalSpacing: 30, verticalSpacing: 30){
                        GridRow {
                            NavigationLink(destination: AllEventsView()) {
                                Text("All Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            Button(action: {
                                self.isClicked = true
                            }) {
                                Text("Office Hours")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        GridRow {
                            NavigationLink(destination: PublicEventsView()) {
                                Text("Public Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            NavigationLink(destination: ClubEventsView()) {
                                Text("Club Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        
                        //                    NavigationLink(destination: OHEventsView()) {
                        //                        Text("Public Events")
                        //                            .bold()
                        //                            .font(.system(size: 20))
                        //                            .foregroundColor(.white)
                        //                            .padding()
                        //                            .background(Color.blue)
                        //                            .cornerRadius(10)
                        //                    }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            NavigationLink(destination: EventsView()) {
                                //NavigationLink(destination: EventsView()) {
                                Text("All Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
//                            NavigationLink(destination: EventsView()) {
//                                //NavigationLink(destination: EventsView()) {
//                                Text("My Events")
//                                    .bold()
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                            }
//                            NavigationLink(destination: EventsView()) {
//                                //NavigationLink(destination: EventsView()) {
//                                Text("Calendar")
//                                    .bold()
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                            }
                        }
                    }
                    .background(Color.blue.opacity(0.5))
                    .frame(height: 150) // Adjust the height of the bottom bar
                }
            }
        }
    }
}
