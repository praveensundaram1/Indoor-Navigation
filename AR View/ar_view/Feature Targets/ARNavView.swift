//
//  ArNavView..swift
//  ar_view
//
//  Created by Last Lock
//
import SwiftUI

// ARViewWithBars is a SwiftUI view that combines a CustomARViewRep with top and bottom bars.
struct ARViewWithBars: View {
    @State private var isFlashing = false // State variable to control flashing behavior.
    @State private var direction = "" // State variable to store the navigation direction.
    @Binding var roomNum: String // Binding to the room number entered by the user.
    @State private var isClicked = false
    
    @State private var calendarPresented = false // State variable to control calendarView behavior.

    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            
            
            CustomARViewRep(isFlashing: $isFlashing, direction: $direction, roomNum: $roomNum)
            

            VStack {
                HStack {
                    
                    Spacer()
                    if isFlashing {
                        Text("Turn Around")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.white)
                            .padding()
                    } else {
                        Text(direction)
                            .font(.title)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Spacer()
                }
                
                .padding(.top)
                .background(Color.blue.opacity(0.5))
                .frame(height: 120) // Adjust the height of the top bar

                Spacer()
//                Spacer()
//                Button(action: {calendarPresented = true}, label: {
//                    Text("Calendar")
//                        .bold()
//                        .font(.system(size: 20))
//                        .foregroundColor(.black)
//                        .padding()
//                        .background(Color.green)
//                        .cornerRadius(10)
//                }).sheet(isPresented: $calendarPresented) {
//                           CalendarView()
//                }

                HStack {
                    Spacer()
                    Text("")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        NavigationLink(destination: EventsView()) {
                        //NavigationLink(destination: EventsView()) {
                            Text("Events")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                       
                        Button(action: {
                            self.isClicked = true
                        }) {
                            Text("Friends")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                     
                        Button(action: {
                            self.isClicked = true
                        }) {
                            Text("Reservations")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                      
//                        Button(action: {
//                            self.isClicked = true
//                        }) {
//                            Text("Other")
//                                .bold()
//                                .font(.system(size: 20))
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.green)
//                                .cornerRadius(10)
//                        }
                    }
                }
//                .padding(.bottom)
                .background(Color.blue.opacity(0.5))
                .frame(height: 150) // Adjust the height of the bottom bar
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
