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
        
        // Add mock events to the list
        addEvent(event1)
        addEvent(event2)
        addEvent(event3)
        addEvent(event4)
        addEvent(event5)
        addEvent(event6)
        
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

