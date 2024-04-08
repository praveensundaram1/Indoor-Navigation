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






// original working stuff

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
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                // Remove the event from the list
                                                /*
                                                if let index = EventList.events.firstIndex(where: { $0.title == event.title }) {
                                                    EventList.removeEvent(at: index)
                                                }
                                                 */
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    /*
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
                                     */
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

