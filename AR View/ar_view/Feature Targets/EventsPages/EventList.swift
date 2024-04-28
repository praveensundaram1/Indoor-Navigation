import Foundation
import SwiftUI

// Make sure CustomEvent conforms to Identifiable
struct CustomEvent: Identifiable {
    var id = UUID()  // Unique identifier for each event
    var title: String
    var description: String
    var date: Date
    var time: String
    var location: String
}

// Define the EventList structure to manage a list of events
class EventList: ObservableObject {
    @Published var events: [CustomEvent] = []  // Observable list of events

    init() {
        addMockEvents()  // Load initial mock data
    }

    func addEvent(_ event: CustomEvent) {
            events.append(event)
    }
    
    func removeEvent(at index: Int) {
        events.remove(at: index)
    }

    func addMockEvents() {
        let event1 = CustomEvent(title: "Birthday Party", description: "Join us for a fun celebration!", date: Date(), time: "3:00 PM", location: "Computer Sciences Conference Center")
        let event2 = CustomEvent(title: "Club Meeting", description: "Robotics club meeting!", date: Date(), time: "6:00 PM", location: "Conference Center")
        let event3 = CustomEvent(title: "Office Hours", description: "Get help with CS639 homework!", date: Date(), time: "11:00 AM", location: "Computer Sciences 154")
        let event4 = CustomEvent(title: "Class Discussion", description: "Weekly class discussion!", date: Date(), time: "12:00 PM", location: "Computer Sciences 133")
        let event5 = CustomEvent(title: "Exam", description: "Midterm exam!", date: Date(), time: "10:00 AM", location: "Computer Sciences 182")
        let event6 = CustomEvent(title: "Conference", description: "Learn about the latest technologies!", date: Date(), time: "10:00 AM", location: "Computer Sciences Conference Center")
        let event7 = CustomEvent(title: "Seminar", description: "Guest speaker discussing AI ethics.", date: Date(), time: "2:00 PM", location: "Computer Sciences 206")
        let event8 = CustomEvent(title: "Hackathon Kickoff", description: "Start of the annual coding competition!", date: Date(), time: "5:00 PM", location: "Computer Sciences 225")
        let event9 = CustomEvent(title: "Research Presentation", description: "Graduate student presenting thesis findings.", date: Date(), time: "4:00 PM", location: "Computer Sciences 312")
        let event10 = CustomEvent(title: "Networking Workshop", description: "Tips and tricks for effective networking.", date: Date(), time: "3:30 PM", location: "Computer Sciences 401")
        let event11 = CustomEvent(title: "Panel Discussion", description: "Experts debating the future of cybersecurity.", date: Date(), time: "1:00 PM", location: "Computer Sciences 512")
        let event12 = CustomEvent(title: "Job Fair", description: "Opportunities to meet with tech companies!", date: Date(), time: "10:00 AM", location: "Computer Sciences Lobby")
        let event13 = CustomEvent(title: "Study Group", description: "Collaborative study session for upcoming exam.", date: Date(), time: "7:00 PM", location: "Computer Sciences 202")
        let event14 = CustomEvent(title: "Workshop", description: "Introduction to machine learning concepts.", date: Date(), time: "11:00 AM", location: "Computer Sciences 318")
        let event15 = CustomEvent(title: "Code Review", description: "Peer review session for coding projects.", date: Date(), time: "6:30 PM", location: "Computer Sciences 433")
        
        // Add mock events to the list
        addEvent(event1)
        addEvent(event2)
        addEvent(event3)
        addEvent(event4)
        addEvent(event5)
        addEvent(event6)
        addEvent(event7)
        addEvent(event8)
        addEvent(event9)
        addEvent(event10)
        addEvent(event11)
        addEvent(event12)
        addEvent(event13)
        addEvent(event14)
        addEvent(event15)
    }
}


