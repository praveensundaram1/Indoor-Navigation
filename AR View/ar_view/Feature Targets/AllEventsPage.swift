//
//  AllEventsPage.swift
//  ar_view
//
//  Created by Sara Chin on 3/7/24.
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

struct AllEventsView: View {
    init() {
            // Call addMockEvents() here to set up your mock events
            EventList.addMockEvents()
        }
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
                    //  .padding(.trailing, 10)
                    //  .padding(.top, 5)
                    //    .position(x:100, y:50)
                    Spacer()
                    
                    
                    ScrollView {
                        VStack(spacing: 10) { // Adjust spacing as needed
                            ForEach(0..<EventList.getEventListSize()) { index in
                                if let event = EventList.getEvent(at: index) {
                                    Text(event.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .bold()
                                    Text(event.time)
                                        .foregroundColor(.white)
                                        .padding()
                                        .bold()
//                                        .background(Color.white)
//                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    // .padding()
                        //.frame(width: 100, height: 400, alignment: .topLeading)
                        //.padding(.top, 5)
                    // NavigationLink to transition to ARViewWithBars when "Start AR View" is tapped.
//                    Grid(horizontalSpacing: 30, verticalSpacing: 30){
//                        GridRow {
//                            NavigationLink(destination: PublicEventsView()) {
//                                Text("Public Events")
//                                    .bold()
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                            }
//                            NavigationLink(destination: ClubEventsView()) {
//                                Text("Club Events")
//                                    .bold()
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                            }
//                        }
                        
                        //                    NavigationLink(destination: OHEventsView()) {
                        //                        Text("Public Events")
                        //                            .bold()
                        //                            .font(.system(size: 20))
                        //                            .foregroundColor(.white)
                        //                            .padding()
                        //                            .background(Color.blue)
                        //                            .cornerRadius(10)
                        //                    }
//                    }
                    
                }
            }
        }
    }
}
