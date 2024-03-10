//
//  EventList.swift
//  ar_view
//
//  Created by Ethan Xi on 3/7/24.
//

import Foundation

// Define the Event structure
struct Event {
    var title: String
    var description: String
    var date: Date
    var time: String
    var location: String
}

// Define the EventList structure to manage a list of events
struct EventList {
    // Static property to hold the list of events
    static var events: [Event] = []
    
    // Static method to add an event to the list
    static func addEvent(_ event: Event) {
        events.append(event)
    }
    
    // Static method to remove an event from the list
    static func removeEvent(at index: Int) {
        guard index >= 0, index < events.count else {
            return // Index out of bounds
        }
        events.remove(at: index)
    }
    
    // Function to add mock events to the list
    static func addMockEvents() {
        let event1 = Event(title: "Birthday Party", description: "Join us for a fun celebration!", date: Date(), time: "3:00 PM", location: "Computer Sciences Conference Center")
        let event2 = Event(title: "Club Meeting", description: "Robotics club meeting!", date: Date(), time: "6:00 PM", location: "Conference Center")
        let event3 = Event(title: "Office Hours", description: "Get help with CS639 homework!", date: Date(), time: "11:00 AM", location: "Computer Sciences 154")
        let event4 = Event(title: "Class Discussion", description: "Weekly class discussion!", date: Date(), time: "12:00 PM", location: "Computer Sciences 133")
        let event5 = Event(title: "Exam", description: "Midterm exam!", date: Date(), time: "10:00 AM", location: "Computer Sciences 182")
        let event6 = Event(title: "Conference", description: "Learn about the latest technologies!", date: Date(), time: "10:00 AM", location: "Computer Sciences Conference Center")
        let event7 = Event(title: "Seminar", description: "Guest speaker discussing AI ethics.", date: Date(), time: "2:00 PM", location: "Computer Sciences 206")
        let event8 = Event(title: "Hackathon Kickoff", description: "Start of the annual coding competition!", date: Date(), time: "5:00 PM", location: "Computer Sciences 225")
        let event9 = Event(title: "Research Presentation", description: "Graduate student presenting thesis findings.", date: Date(), time: "4:00 PM", location: "Computer Sciences 312")
        let event10 = Event(title: "Networking Workshop", description: "Tips and tricks for effective networking.", date: Date(), time: "3:30 PM", location: "Computer Sciences 401")
        let event11 = Event(title: "Panel Discussion", description: "Experts debating the future of cybersecurity.", date: Date(), time: "1:00 PM", location: "Computer Sciences 512")
        let event12 = Event(title: "Job Fair", description: "Opportunities to meet with tech companies!", date: Date(), time: "10:00 AM", location: "Computer Sciences Lobby")
        let event13 = Event(title: "Study Group", description: "Collaborative study session for upcoming exam.", date: Date(), time: "7:00 PM", location: "Computer Sciences 202")
        let event14 = Event(title: "Workshop", description: "Introduction to machine learning concepts.", date: Date(), time: "11:00 AM", location: "Computer Sciences 318")
        let event15 = Event(title: "Code Review", description: "Peer review session for coding projects.", date: Date(), time: "6:30 PM", location: "Computer Sciences 433")
        
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
        
        // Add more mock events as needed...
    }
    
    static func printEvents() {
        for event in events {
            print("Title: \(event.title)")
            print("Description: \(event.description)")
            print("Date: \(event.date)")
            print("Time: \(event.time)")
            print("Location: \(event.location)")
            print("-------------------------")
        }
    }
    
    static func getEvent(at index: Int) -> Event? {
        guard index >= 0, index < events.count else {
            return nil
        }
        return events[index]
    }
}

// Call the function to add mock events when the file is loaded
// EventList.addMockEvents()

