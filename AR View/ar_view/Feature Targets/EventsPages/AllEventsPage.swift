//
//  AllEventsPage.swift
//  ar_view
//
//  Created by Sara Chin on 3/7/24.
//


import Foundation
import SwiftUI


struct AllEventsView: View {
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
                        .position(x:100, y:50)
                        //.padding(.top, 5)
                    // NavigationLink to transition to ARViewWithBars when "Start AR View" is tapped.
//                    NavigationLink(destination: ARViewWithBars()) {
//                        Text("Start AR View")
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

