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
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    Text("Events")
                        .bold()
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Grid(horizontalSpacing: 30, verticalSpacing: 100) {
                        GridRow {
                            Button(action: {
                                self.isClicked = true
                            }) {
                                textLabelStylize(text: "My Events", color: .green)
                            }
                            .buttonStyle(CircleButtonStyle())

                            NavigationLink(destination: CalendarView()) {
                                textLabelStylize(text: "My Calendar", color: .green)
                            }
                            .buttonStyle(CircleButtonStyle())
                        }
                        GridRow {
                            NavigationLink(destination: AllEventsView()) {
                                textLabelStylize(text: "All Events", color: .blue)
                            }
                            .buttonStyle(CircleButtonStyle())

                            Button(action: {
                                self.isClicked = true
                            }) {
                                textLabelStylize(text: "Office Hours", color: .blue)
                            }
                            .buttonStyle(CircleButtonStyle())
                        }
                        GridRow {
                            NavigationLink(destination: PublicEventsView()) {
                                textLabelStylize(text: "Public Events", color: .blue)
                            }
                            .buttonStyle(CircleButtonStyle())

                            NavigationLink(destination: ClubEventsView()) {
                                textLabelStylize(text: "Club Events", color: .blue)
                            }
                            .buttonStyle(CircleButtonStyle())
                        }

                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

func textLabelStylize(text: String, color: Color) -> some View{
    let textObj: some View = Text(text)
        .bold()
        .font(.system(size: 20))
        .foregroundColor(color)
//        .backgroundColor(.green)
//        .padding()
//        .cornerRadius(10)
    
    return textObj
}



struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 16)) // Adjusted font size
            .foregroundColor(.white)
            .padding(20) // Adjust padding to ensure the text fits within the circle
            .background(
                Circle()
                    .fill(Color.offWhite)
                    .frame(width: 150, height: 150) // Explicitly size the circle
                    .shadow(color: Color.black.opacity(configuration.isPressed ? 0.2 : 0.7), radius: 10, x: configuration.isPressed ? -5 : 10, y: configuration.isPressed ? -5 : 10)
                    .shadow(color: Color.white.opacity(configuration.isPressed ? 0.7 : 0.2), radius: 10, x: configuration.isPressed ? 10 : -5, y: configuration.isPressed ? 10 : -5)
                
            )
    }
}
extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}





