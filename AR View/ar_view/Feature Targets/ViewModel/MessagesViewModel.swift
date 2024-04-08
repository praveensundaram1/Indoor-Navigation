//
//  MessagesViewModel.swift
//  ar_view
//
//  Created by Ethan Xi on 4/3/24.
//

import Foundation

final class MessagesViewModel: ObservableObject {
    
   @Published private(set) var data = [
        
        InboxItem(title: "Birthday Party", description: "Join us for a fun celebration!", date: Date(), time: "3:00 PM", location: "Computer Sciences Conference Center",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Club Meeting", description: "Robotics club meeting!", date: Date(), time: "6:00 PM", location: "Conference Center",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Office Hours", description: "Get help with CS639 homework!", date: Date(), time: "11:00 AM", location: "Computer Sciences 154",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Class Discussion", description: "Weekly class discussion!", date: Date(), time: "12:00 PM", location: "Computer Sciences 133",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Exam", description: "Midterm exam!", date: Date(), time: "10:00 AM", location: "Computer Sciences 182",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Conference", description: "Learn about the latest technologies!", date: Date(), time: "10:00 AM", location: "Computer Sciences Conference Center",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Hackathon Kickoff", description: "Start of the annual coding competition!", date: Date(), time: "5:00 PM", location: "Computer Sciences 225",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false),
        InboxItem(title: "Research Presentation", description: "Graduate student presenting thesis findings.", date: Date(), time: "4:00 PM", location: "Computer Sciences 312",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: false,
                             isFlagged: false,
                             isRead: false)
    ]
    
    func toggleRead(for item: InboxItem) {
        if let index = data.firstIndex(where: { $0.id == item.id }) {
            data[index].isRead.toggle()
        }
    }
    
    func toggleFlagged(for item: InboxItem) {
        if let index = data.firstIndex(where: { $0.id == item.id }) {
            data[index].isFlagged.toggle()
        }
    }
    
    func delete(_ item: InboxItem) {
        data.removeAll(where: { $0.id == item.id })
    }
}
