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

                VStack(spacing: 2) {
                    Text("Events")
                        .bold()
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.bottom, 5)

                    Grid(horizontalSpacing: 30, verticalSpacing: 30) {
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
                            }
                            .buttonStyle(GreenCircleButtonStyle())

                            NavigationLink(destination: CalendarView()) {
                                Text("Calendar")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(GreenCircleButtonStyle())
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
                            }
                            .buttonStyle(BlueCircleButtonStyle())

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
                            .buttonStyle(BlueCircleButtonStyle())
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
                            .buttonStyle(BlueCircleButtonStyle())

                            NavigationLink(destination: ClubEventsView()) {
                                Text("Club Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(BlueCircleButtonStyle())
                        }

                        Spacer()
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            NavigationLink(destination: EventsView()) {
                                Text("All Events")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }

                            NavigationLink(destination: CalendarView()) {
                                Text("Calendar")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
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

    @State var size: CGFloat = 3000
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
