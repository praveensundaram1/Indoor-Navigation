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
    @Binding var showToast: Bool // Add this line
    @State var showToastArrived = false
    @Binding var destinationInfo: [String]

    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            
            
            CustomARViewRep(roomNum: $roomNum)
            

            VStack {
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
                                .background(Color(red: 0.271, green: 0.557, blue: 0.969))
                                .cornerRadius(10)
                        }
                        Spacer(minLength: 5)
                        Button(action: {
                            self.isClicked = true
                            self.showToastArrived.toggle()
                        }) {
                            Text("Friends")
                                .frame(alignment: .center)

                                .bold()
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.271, green: 0.557, blue: 0.969))
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
                                .background(Color(red: 0.271, green: 0.557, blue: 0.969))
                                .cornerRadius(10)
                        }
                        Spacer(minLength: 5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width-80) // Adjust the height of the bottom bar
                .padding(15)
                .background(Color(.white).opacity(0.8)).cornerRadius(10)
                Spacer(minLength: 50)

            }
            .present(isPresented: self.$showToast, type: .floater(verticalPadding: CGFloat(90)), position: .top, autohideDuration: Double.infinity){
                /// create your own view for toast
                self.createTopToastView()
            }
            .present(isPresented: self.$showToastArrived, type: .alert) {
                /// create your own view for toast
                self.createAlert()
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    func createTopToastView() -> some View {
        VStack(alignment: .center) {
                Spacer(minLength: 10)
                HStack() {

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Navigating in: " + destinationInfo[0])
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("1000 ft")
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        }
                        HStack {
                            Text(destinationInfo[1])
                                .lineLimit(2)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Spacer(minLength: 5)
                            Label("",systemImage: "mappin.circle.fill")
                        }
                    }
                }.padding(15)
                Spacer(minLength: 10)
            }
            .frame(width: UIScreen.main.bounds.width-40, height: 100)
            .background(.black.opacity(0.8))
            .zIndex(1)
            .cornerRadius(10)
        }
    func createAlert() -> some View {
        VStack(alignment: .center) {
                Spacer(minLength: 5)
                HStack() {

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("You have arrived" )
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }.padding(15)
                Spacer(minLength: 5)
            }
        .frame(width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height/2)
            .background(.green.opacity(0.8))
            .zIndex(1)
            .cornerRadius(10)
        }
}
