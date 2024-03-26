//
//  ArNavView..swift
//  ar_view
//
//  Created by Last Lock
//
import SwiftUI
import SSToastMessage

// ARViewWithBars is a SwiftUI view that combines a CustomARViewRep with top and bottom bars.
struct ARViewWithBars: View {
    @State private var isFlashing = false // State variable to control flashing behavior.
    @State private var direction = "" // State variable to store the navigation direction.
    @Binding var roomNum: String // Binding to the room number entered by the user.
    @State private var isClicked = false
    
    @State private var calendarPresented = false // State variable to control calendarView behavior.
    @State var showToast = false

    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            
            
            CustomARViewRep(isFlashing: $isFlashing, direction: $direction, roomNum: $roomNum)
            

            VStack {
////                HStack {
////                    
//////                    Button(action: {
//////                                    self.showToast.toggle()
//////                                }) {
//////                                    Text("Show Toast")
//////                                        .foregroundColor(.black)
//////                                }
//////                            .present(isPresented: self.$showToast, type: .toast, position: .top) {
//////                               /// create your own view for toast
//////                                self.createTopToastView()
//////                    }
////                
////                    
////                    Spacer()
////                    if isFlashing {
////                        Text("Turn Around")
////                            .font(.title)
////                            .foregroundColor(Color.white)
////                            .multilineTextAlignment(.center)
////                            .padding()
////                        
////                        Image(systemName: "arrow.clockwise")
////                            .resizable()
////                            .frame(width: 24, height: 24)
////                            .foregroundColor(Color.white)
////                            .padding()
////                    } else {
////                        Text(direction)
////                            .font(.title)
////                            .foregroundColor(Color.white)
////                            .multilineTextAlignment(.center)
////                            .padding()
////                    }
////                    Spacer()
////                }
////                
////                .padding(.top)
////                .background(Color.blue.opacity(0.5))
////                .frame(height: 120) // Adjust the height of the top bar
//
//                Spacer()
////                Spacer()
////                Button(action: {calendarPresented = true}, label: {
////                    Text("Calendar")
////                        .bold()
////                        .font(.system(size: 20))
////                        .foregroundColor(.black)
////                        .padding()
////                        .background(Color.green)
////                        .cornerRadius(10)
////                }).sheet(isPresented: $calendarPresented) {
////                           CalendarView()
////                }
//
//                HStack {
//                    Spacer()
//                    Text("")
//                        .font(.title)
//                        .foregroundColor(Color.white)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    Spacer()
//                }
                Spacer(minLength: UIScreen.main.bounds.height - 150)
                VStack {
                    HStack(alignment: .bottom) {
                        //                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer(minLength: 5)
                        NavigationLink(destination: EventsView()) {
                            
                            Text("Events")
                                .frame(alignment: .center)
                                .bold()
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.85, green: 0.65, blue: 0.56))
                                .cornerRadius(10)
                        }
                        Spacer(minLength: 5)
                        Button(action: {
                            self.isClicked = true
                            self.showToast.toggle()
                        }) {
                            Text("Friends")
                                .frame(alignment: .center)

                                .bold()
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.85, green: 0.65, blue: 0.56))
                                .cornerRadius(10)
                        }
                        Spacer(minLength: 5)
                        Button(action: {
                            self.isClicked = true
                        }) {
                            Text("Reserve")
                                .frame(alignment: .center)
                                .bold()
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.85, green: 0.65, blue: 0.56))
                                .cornerRadius(10)
                        }
                        Spacer(minLength: 5)
                        
                    }
//                    .padding(10)
//                    .background().cornerRadius(20)

                }
//                .padding(.bottom)
                
                .frame(width: UIScreen.main.bounds.width-80) // Adjust the height of the bottom bar
                .padding(15)
                .background(Color(red: 0.55, green: 0.65, blue: 0.56)).cornerRadius(10)
                Spacer(minLength: 50)

            }
            .present(isPresented: self.$showToast, type: .floater(verticalPadding: CGFloat(75)), position: .top, autohideDuration: 10000.0) {
                /// create your own view for toast
                self.createTopToastView()
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
    func createTopToastView() -> some View {
        VStack(alignment: .center) {
                Spacer(minLength: 10)
                HStack() {
//                    Image("mike")
//                        .resizable()
//                        .aspectRatio(contentMode: ContentMode.fill)
//                        .frame(width: 50, height: 50)
//                        .cornerRadius(25)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Navigating in: CS Building")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
//                            Spacer(minLength: 5)
                            Text("1000 ft")
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                        HStack {
                            Text("Go to room 3109 on the third floor")
                                .lineLimit(2)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Spacer(minLength: 5)
                            Button(action: {
                                self.isClicked = true
                            }) {
                                Text("X")
                                    .bold()
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .background(Color(red: 0.85, green: 0.15, blue: 0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }.padding(15)
                Spacer(minLength: 10)
            }
            .frame(width: UIScreen.main.bounds.width-40, height: 100)
            .background(Color(red: 0.55, green: 0.65, blue: 0.56))
            .zIndex(1)
            .cornerRadius(10)
        }
}
