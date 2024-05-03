import Foundation
import SwiftUI







struct AllEventsView: View {
    @ObservedObject var eventList = EventList()  // ViewModel managing the data
        @State private var activeEventId: UUID?  // State to manage which event is currently selected

        var body: some View {
            NavigationView {
                List(eventList.events) { event in
                    VStack(alignment: .leading) {
                        Text(event.title).font(.headline)
                        Text(event.description).font(.subheadline)
                        Text(event.time).font(.caption)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            // Set the active event ID to trigger navigation
                            activeEventId = event.id
                        } label: {
                            Label("Current", systemImage: "mappin")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = eventList.events.firstIndex(where: { $0.id == event.id }) {
                                eventList.removeEvent(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    // Background NavigationLink to manage navigation programmatically
                    .background(
                        NavigationLink(
                            destination: ARViewWithBars(roomNum: .constant("Your Room Num"), showToast: Binding.constant(true), destinationInfo: .constant(["CS Building", "Go to room 1240 on the first floor"])),
                            tag: event.id,
                            selection: $activeEventId
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    )
                }
                .navigationTitle("Events")
            }
        }
    }

