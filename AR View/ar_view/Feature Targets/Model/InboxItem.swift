//
//  InboxItem.swift
//  ar_view
//
//  Created by Ethan Xi on 4/3/24.
//

import Foundation

struct InboxItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let time: String
    let location: String
    
    let dateRecieved: Date
    let hasAttached: Bool
    
    var isFlagged: Bool
    var isRead: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: dateRecieved)
    }
}
