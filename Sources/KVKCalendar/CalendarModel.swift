//
//  CalendarModel.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 25.02.2020.
//

import UIKit
import EventKit

public struct KVKCalendarDateParameter {
    public var date: Date?
    public var type: KVKCalendarDayType?
}

public enum KVKCalendarTimeHourSystem: Int {
    @available(swift, deprecated: 0.3.6, obsoleted: 0.3.7, renamed: "twelve")
    case twelveHour = 0
    @available(swift, deprecated: 0.3.6, obsoleted: 0.3.7, renamed: "twentyFour")
    case twentyFourHour = 1
    
    case twelve = 12
    case twentyFour = 24
    
    var hours: [String] {
        switch self {
        case .twelveHour, .twelve:
            let array = ["12"] + Array(1...11).map({ String($0) })
            let am = array.map { $0 + " AM" } + ["Noon"]
            var pm = array.map { $0 + " PM" }
            
            pm.removeFirst()
            if let item = am.first {
                pm.append(item)
            }
            return am + pm
        case .twentyFourHour, .twentyFour:
            let array = ["00:00"] + Array(1...24).map({ (i) -> String in
                let i = i % 24
                var string = i < 10 ? "0" + "\(i)" : "\(i)"
                string.append(":00")
                return string
            })
            return array
        }
    }
    
    @available(*, deprecated, renamed: "current")
    public static var currentSystemOnDevice: KVKCalendarTimeHourSystem? {
        let locale = NSLocale.current
        guard let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale) else { return nil }
        
        if formatter.contains("a") {
            return .twelve
        } else {
            return .twentyFour
        }
    }
    
    public static var current: KVKCalendarTimeHourSystem? {
        let locale = NSLocale.current
        guard let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale) else { return nil }
        
        if formatter.contains("a") {
            return .twelve
        } else {
            return .twentyFour
        }
    }
    
    public var format: String {
        switch self {
        case .twelveHour, .twelve:
            return "h:mm a"
        case .twentyFourHour, .twentyFour:
            return "HH:mm"
        }
    }
}

public enum KVKCalendarType: String, CaseIterable {
    case day, week, month, year, list
}

// MARK: KVKCalendarEvent model

@available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "Event.Color")
public struct EventColor {
    let value: UIColor
    let alpha: CGFloat
    
    public init(_ color: UIColor, alpha: CGFloat = 0.3) {
        self.value = color
        self.alpha = alpha
    }
}

public struct KVKCalendarEvent {
    static let idForNewEvent = "-999"
    
    /// unique identifier of Event
    public var ID: String
    public var text: String = ""
    public var start: Date = Date()
    public var end: Date = Date()
    public var color: KVKCalendarEvent.Color? = KVKCalendarEvent.Color(.systemBlue) {
        didSet {
            guard let tempColor = color else { return }
            
            let value = prepareColor(tempColor)
            backgroundColor = value.background
            textColor = value.text
        }
    }
    public var backgroundColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.3)
    public var textColor: UIColor = .white
    public var isAllDay: Bool = false
    public var isContainsFile: Bool = false
    public var textForMonth: String = ""
    public var textForList: String = ""
    
    @available(swift, deprecated: 0.4.6, obsoleted: 0.4.7, renamed: "data")
    public var eventData: Any? = nil
    public var data: Any? = nil
    
    public var recurringType: KVKCalendarEvent.RecurringType = .none
    
    ///individual event customization
    ///(in-progress) works only with a default height
    public var style: KVKCalendarEventStyle? = nil
    
    public init(ID: String) {
        self.ID = ID
        
        if let tempColor = color {
            let value = prepareColor(tempColor)
            backgroundColor = value.background
            textColor = value.text
        }
    }
    
    func prepareColor(_ color: KVKCalendarEvent.Color) -> (background: UIColor, text: UIColor) {
        let bgColor = color.value.withAlphaComponent(color.alpha)
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        color.value.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let txtColor = UIColor(hue: hue, saturation: saturation,
                               brightness: UIScreen.isDarkMode ? brightness : brightness * 0.4,
                               alpha: alpha)
        
        return (bgColor, txtColor)
    }
}

extension KVKCalendarEvent {
    var hash: Int {
        return ID.hashValue
    }
}

public extension KVKCalendarEvent {
    var isNew: Bool {
        return ID == KVKCalendarEvent.idForNewEvent
    }
    
    enum RecurringType: Int {
        case everyDay, everyWeek, everyMonth, everyYear, none
    }
    
    struct Color {
        let value: UIColor
        let alpha: CGFloat
        
        public init(_ color: UIColor, alpha: CGFloat = 0.3) {
            self.value = color
            self.alpha = alpha
        }
    }
}

@available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "Event.RecurringType")
public enum RecurringType: Int {
    case everyDay, everyWeek, everyMonth, everyYear, none
}

extension KVKCalendarEvent: KVKCalendarEventProtocol {
    public func compare(_ event: KVKCalendarEvent) -> Bool {
        return hash == event.hash
    }
}

extension KVKCalendarEvent {
    func updateDate(newDate: Date?, calendar: Calendar = Calendar.current) -> KVKCalendarEvent? {
        var startComponents = DateComponents()
        startComponents.year = newDate?.year
        startComponents.month = newDate?.month
        startComponents.hour = start.hour
        startComponents.minute = start.minute
        
        var endComponents = DateComponents()
        endComponents.year = newDate?.year
        endComponents.month = newDate?.month
        endComponents.hour = end.hour
        endComponents.minute = end.minute
        
        switch recurringType {
        case .everyDay:
            startComponents.day = newDate?.day
        case .everyWeek where newDate?.weekday == start.weekday:
            startComponents.day = newDate?.day
            startComponents.weekday = newDate?.weekday
            endComponents.weekday = newDate?.weekday
        case .everyMonth where newDate?.month != start.month && newDate?.day == start.day:
            startComponents.day = newDate?.day
        case .everyYear where newDate?.year != start.year && newDate?.month == start.month && newDate?.day == start.day:
            startComponents.day = newDate?.day
        default:
            return nil
        }
        
        let offsetDay = end.day - start.day
        if start.day == end.day {
            endComponents.day = newDate?.day
        } else if let newDay = newDate?.day {
            endComponents.day = newDay + offsetDay
        } else {
            endComponents.day = newDate?.day
        }
        
        guard let newStart = calendar.date(from: startComponents), let newEnd = calendar.date(from: endComponents) else { return nil }
        
        var newEvent = self
        newEvent.start = newStart
        newEvent.end = newEnd
        return newEvent
    }
}

// MARK: - KVKCalendarEvent protocol

public protocol KVKCalendarEventProtocol {
    func compare(_ event: KVKCalendarEvent) -> Bool
}

// MARK: - Settings protocol

protocol CalendarSettingProtocol: AnyObject {
    
    var currentStyle: KVKCalendarStyle { get }
    
    func reloadFrame(_ frame: CGRect)
    func updateStyle(_ style: KVKCalendarStyle)
    func reloadData(_ events: [KVKCalendarEvent])
    func setDate(_ date: Date)
    func setUI()
    
}

extension CalendarSettingProtocol {
    
    func reloadData(_ events: [KVKCalendarEvent]) {}
    func setDate(_ date: Date) {}
    
}

// MARK: - Data source protocol

public protocol KVKCalendarDataSource: AnyObject {
    /// get events to display on view
    /// also this method returns a system events from iOS calendars if you set the property `systemCalendar` in style
    func eventsForCalendar(systemEvents: [EKEvent]) -> [KVKCalendarEvent]
    
    func willDisplayDate(_ date: Date?, events: [KVKCalendarEvent])
    
    /// Use this method to add a custom event view
    func willDisplayEventView(_ event: KVKCalendarEvent, frame: CGRect, date: Date?) -> KVKCalendarEventViewGeneral?
    
    /// Use this method to add a custom header view (works on Day, Week, Month)
    func willDisplayHeaderSubview(date: Date?, frame: CGRect, type: KVKCalendarType) -> UIView?
    
    /// Use the method to replace the collectionView. Works for month/year View
    func willDisplayCollectionView(frame: CGRect, type: KVKCalendarType) -> UICollectionView?
    
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView?
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueCell")
    func dequeueDateCell(date: Date?, type: KVKCalendarType, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueHeader")
    func dequeueHeaderView(date: Date?, type: KVKCalendarType, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView?
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueCell")
    func dequeueListCell(date: Date?, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell?
    
    /// Use this method to add a custom day cell
    func dequeueCell<T: UIScrollView>(dateParameter: KVKCalendarDateParameter, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol?
    
    /// Use this method to add a header view
    func dequeueHeader<T: UIScrollView>(date: Date?, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarHeaderProtocol?
}

public extension KVKCalendarDataSource {
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? { return nil }
    
    func willDisplayDate(_ date: Date?, events: [KVKCalendarEvent]) {}
    
    func willDisplayEventView(_ event: KVKCalendarEvent, frame: CGRect, date: Date?) -> KVKCalendarEventViewGeneral? { return nil }
    
    func willDisplayHeaderSubview(date: Date?, frame: CGRect, type: KVKCalendarType) -> UIView? { return nil }
    
    func willDisplayCollectionView(frame: CGRect, type: KVKCalendarType) -> UICollectionView? { return nil }
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueCell")
    func dequeueDateCell(date: Date?, type: KVKCalendarType, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? { return nil }
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueHeader")
    func dequeueHeaderView(date: Date?, type: KVKCalendarType, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? { return nil }
        
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "dequeueCell")
    func dequeueListCell(date: Date?, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? { return nil }
    
    func dequeueCell<T: UIScrollView>(dateParameter: KVKCalendarDateParameter, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? { return nil }
    
    func dequeueHeader<T: UIScrollView>(date: Date?, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarHeaderProtocol? { return nil }
}

// MARK: - Delegate protocol

public protocol KVKCalendarDelegate: AnyObject {
    func sizeForHeader(_ date: Date?, type: KVKCalendarType) -> CGSize?
    
    /// size cell for (month, year, list) view
    func sizeForCell(_ date: Date?, type: KVKCalendarType) -> CGSize?
    
    /// get a selecting date
    @available(*, deprecated, renamed: "didSelectDates")
    func didSelectDate(_ date: Date?, type: KVKCalendarType, frame: CGRect?)
    
    /// get selected dates
    func didSelectDates(_ dates: [Date], type: KVKCalendarType, frame: CGRect?)
    
    /// get a selecting event
    func didSelectEvent(_ event: KVKCalendarEvent, type: KVKCalendarType, frame: CGRect?)
    
    /// tap on more fro month view
    func didSelectMore(_ date: Date, frame: CGRect?)
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "didChangeViewerFrame")
    func eventViewerFrame(_ frame: CGRect)
    
    /// event's viewer for iPad
    func didChangeViewerFrame(_ frame: CGRect)
    
    /// drag & drop events and resize
    func didChangeEvent(_ event: KVKCalendarEvent, start: Date?, end: Date?)
    
    /// add new event
    func didAddNewEvent(_ event: KVKCalendarEvent, _ date: Date?)
    
    /// get current displaying events
    func didDisplayEvents(_ events: [KVKCalendarEvent], dates: [Date?])
    
    /// get next date when the calendar scrolls (works for month view)
    func willSelectDate(_ date: Date, type: KVKCalendarType)
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "didDeselectEvent")
    func deselectEvent(_ event: KVKCalendarEvent, animated: Bool)
    
    /// deselect event on timeline
    func didDeselectEvent(_ event: KVKCalendarEvent, animated: Bool)
}

public extension KVKCalendarDelegate {
    func sizeForHeader(_ date: Date?, type: KVKCalendarType) -> CGSize? { return nil }
    
    func sizeForCell(_ date: Date?, type: KVKCalendarType) -> CGSize? { return nil }
    
    @available(*, deprecated, renamed: "didSelectDates")
    func didSelectDate(_ date: Date?, type: KVKCalendarType, frame: CGRect?) {}
    
    func didSelectDates(_ dates: [Date], type: KVKCalendarType, frame: CGRect?)  {}
    
    func didSelectEvent(_ event: KVKCalendarEvent, type: KVKCalendarType, frame: CGRect?) {}
    
    func didSelectMore(_ date: Date, frame: CGRect?) {}
    
    @available(*, deprecated, renamed: "didChangeViewerFrame")
    func eventViewerFrame(_ frame: CGRect) {}
    
    func didChangeEvent(_ event: KVKCalendarEvent, start: Date?, end: Date?) {}
        
    func didAddNewEvent(_ event: KVKCalendarEvent, _ date: Date?) {}
    
    func didDisplayEvents(_ events: [KVKCalendarEvent], dates: [Date?]) {}
    
    func willSelectDate(_ date: Date, type: KVKCalendarType) {}
    
    @available(*, deprecated, renamed: "didDeselectEvent")
    func deselectEvent(_ event: KVKCalendarEvent, animated: Bool) {}
    
    func didDeselectEvent(_ event: KVKCalendarEvent, animated: Bool) {}
    
    func didChangeViewerFrame(_ frame: CGRect) {}
}

// MARK: - Private Display dataSource

protocol DisplayDataSource: KVKCalendarDataSource {}

extension DisplayDataSource {
    public func eventsForCalendar(systemEvents: [EKEvent]) -> [KVKCalendarEvent] { return [] }
}

// MARK: - Private Display delegate

protocol DisplayDelegate: KVKCalendarDelegate {
    func didDisplayEvents(_ events: [KVKCalendarEvent], dates: [Date?], type: KVKCalendarType)
}

extension DisplayDelegate {
    public func willSelectDate(_ date: Date, type: KVKCalendarType) {}
    
    func deselectEvent(_ event: KVKCalendarEvent, animated: Bool) {}
}

// MARK: - EKEvent

public extension EKEvent {
    func transform(text: String? = nil, textForMonth: String? = nil, textForList: String? = nil) -> KVKCalendarEvent {
        var event = KVKCalendarEvent(ID: eventIdentifier)
        event.text = text ?? title
        event.start = startDate
        event.end = endDate
        event.color = KVKCalendarEvent.Color(UIColor(cgColor: calendar.cgColor))
        event.isAllDay = isAllDay
        event.textForMonth = textForMonth ?? title
        event.textForList = textForList ?? title
        return event
    }
}

// MARK: - Protocols to customize calendar

public protocol KVKCalendarCellProtocol: AnyObject {}

extension UICollectionViewCell: KVKCalendarCellProtocol {}
extension UITableViewCell: KVKCalendarCellProtocol {}

public protocol KVKCalendarHeaderProtocol: AnyObject {}

extension UIView: KVKCalendarHeaderProtocol {}
