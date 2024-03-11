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
                VStack (/*spacing: 2*/) {
                    Text("Events")
                        .bold()
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
//                        .padding(.trailing, 10)
//                        .padding(.top, 5)
                        .position(x:100, y:50)
                        //.frame(width: 100, height: 400, alignment: .topLeading)
                        .padding(.bottom, 5)
                    // NavigationLink to transition to ARViewWithBars when "Start AR View" is tapped.
                    Grid(horizontalSpacing: 30, verticalSpacing: 3){
                        GridRow {
                            Button(action: {
                                self.isClicked = true
                            }) {
                                Text("My Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
//                                    .fill(Color.offWhite)
//                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                    .clipShape(Circle())
//                                    .frame(width: 200, height: 200)
                            } .buttonStyle(GreenCircleButtonStyle())
                            NavigationLink(destination: CalendarView()) {
                                Text("Calendar")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            } .buttonStyle(GreenCircleButtonStyle())
                        }
                        GridRow {
                            NavigationLink(destination: AllEventsView()) {
                                Text("All Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
//                                    .fill(Color.offWhite)
//                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                    .clipShape(Circle())
//                                    .frame(width: 200, height: 200)
                            } .buttonStyle(BlueCircleButtonStyle())
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
//                                    .fill(Color.offWhite)
//                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                    .clipShape(Circle())
//                                    .frame(width: 200, height: 200)
                            } .buttonStyle(BlueCircleButtonStyle())
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
//                                    .fill(Color.offWhite)
//                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                    .clipShape(Circle())
//                                    .frame(width: 200, height: 200)
                            } .buttonStyle(BlueCircleButtonStyle())
                            NavigationLink(destination: ClubEventsView()) {
                                Text("Club Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
//                                    .fill(Color.offWhite)
//                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//                                    .clipShape(Circle())
//                                    .frame(width: 200, height: 200)
                            } .buttonStyle(BlueCircleButtonStyle())
                            
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
                        Spacer()
                    }

                    //.background(Color.white.opacity(0.5))
                    .frame(height: 150) // Adjust the height of the bottom bar
                }
            }
        }
    }
}


struct BlueCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.padding().modifier(MakeSquareBounds()).background(Circle().fill(Color.blue))

    }
}
struct GreenCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label.padding().modifier(MakeSquareBounds()).background(Circle().fill(Color.green))

    }
}

struct MakeSquareBounds: ViewModifier {

    @State var size: CGFloat = 1000
    func body(content: Content) -> some View {
        let c = ZStack {
            content.alignmentGuide(HorizontalAlignment.center) { (vd) -> CGFloat in
                DispatchQueue.main.async {
                    self.size = max(vd.height, vd.width)
                }
                return vd[HorizontalAlignment.center]
            }
        }
        return c.frame(width: size, height: size)
    }
}
