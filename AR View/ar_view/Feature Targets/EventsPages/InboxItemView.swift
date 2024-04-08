//
//  InboxItemView.swift
//  ar_view
//
//  Created by Ethan Xi on 4/3/24.
//

import Foundation
import SwiftUI

struct InboxItemView: View {
    
    let item: InboxItem
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top) {
               
                HStack {
                    /*
                    if !item.isRead {
                        Circle()
                            .frame(width: 10,
                               height: 10)
                            .foregroundColor(.accentColor)
                    }
                    */
                    Text(item.title)
                        .font(.headline)
                }
                Spacer()
                Text(item.formattedDate)
                    .font(.caption)
                    .opacity(0.5)
            }
            HStack {
                Text(item.location)
                    .font(.callout)
                    .lineLimit(1)
                Spacer()
                if item.hasAttached {
                    Image(systemName: "paperclip")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color.gray)
                }
                if item.isFlagged {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.red)
                }
            }
            
            HStack(spacing: 0) {
                Text(item.description)
                    .lineLimit(2)
                    .font(.callout)
                    .opacity(0.5)
                Spacer()
            }
        }
    }
}

struct InboxItemView_Previews: PreviewProvider {
    static var previews: some View {
        let item = InboxItem(title: "Birthday Party", description: "Join us for a fun celebration!", date: Date(), time: "3:00 PM", location: "Computer Sciences Conference Center",
                             dateRecieved: Date(timeIntervalSince1970: 1627924568),
                             hasAttached: true,
                             isFlagged: false,
                             isRead: false)
        InboxItemView(item: item)
    }
}
