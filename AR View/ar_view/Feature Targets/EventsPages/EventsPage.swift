import SwiftUI

struct EventsView: View {
    @State private var isClicked = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.offBlue.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Events")
                        .bold()
                        .font(.system(size: 32, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
//                        .padding(.top, 40)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            NavigationLink(destination: MyEventsView()) {
                                RectangularButtonView(text: "My Events")
                            }
                            NavigationLink(destination: CalendarView()) {
                                RectangularButtonView(text: "My Calendar")
                            }
                            NavigationLink(destination: AllEventsView()) {
                                RectangularButtonView(text: "All Events")
                            }
                            NavigationLink(destination: OfficeHoursView()) {
                                RectangularButtonView(text: "Office Hours")
                            }
                            NavigationLink(destination: ClubEventsView()) {
                                RectangularButtonView(text: "New Events")
                            }
                            NavigationLink(destination: ClubEventsView()) {
                                RectangularButtonView(text: "Club Events")
                            }
                        }
                    }
                    .padding(.horizontal, 10)
//                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct RectangularButtonView: View {
    let text: String

    var body: some View {
        Text(text)
            .bold()
            .font(.system(size: 25))
            .foregroundColor(.offBlue)
            .padding(20)
            .frame(height: 240)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
    }
}

extension Color {
    static let offBlue = Color(red: 0.271, green: 0.557, blue: 0.969)
}
