//
//  CalendarVC.swift
//  ar_view
//
//  Created by Aneesh Pandoh on 3/8/24.
//

import Foundation
import CalendarKit
import SwiftUI
import EventKit



class CalendarVC: DayViewController {
    private let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccessToCalender()
        title = "Your Calendar"
    }
    func requestAccessToCalender() {
        eventStore.requestAccess(to: .event) {success, error in
        }
    }
    
    override func eventsForDate(_ date: Date)  -> [any EventDescriptor] {
        let startDate = date
        var yearComponents = DateComponents()
        yearComponents.day = 365
        guard let endDate = calendar.date(byAdding: yearComponents, to: startDate) else {
            return []
        }
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map { ekEvent -> Event in
            let ckEvent = Event()
            ckEvent.dateInterval.start = ekEvent.startDate
            ckEvent.dateInterval.end = ekEvent.endDate
            ckEvent.isAllDay = ekEvent.isAllDay
            ckEvent.text = ekEvent.title
            if let eventColor = ekEvent.calendar.cgColor {
            ckEvent.color = UIColor(cgColor: eventColor)
            }
            return ckEvent
        }
        
        return calendarKitEvents
    }
    
}


//Convert from UIKit to SwiftUI
struct CalendarView: UIViewControllerRepresentable {
    
    
    func makeUIViewController(context: Context) -> DayViewController {
        let Calendar = CalendarVC()
        return Calendar
        // Return MyViewController instance
    }
    
    func updateUIViewController(_ uiViewController: DayViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
