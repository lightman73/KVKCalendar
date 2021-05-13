//
//  KVKCalendarView+Extension.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 14.12.2020.
//

import UIKit
import EventKit

extension KVKCalendarView {
    // MARK: Public methods
    
    /// **DEPRECATED**
    @available(*, deprecated, renamed: "CalendarDataSource.willDisplayEventViewer")
    public func addEventViewToDay(view: UIView) {
        
    }
    
    public func set(type: KVKCalendarType, date: Date? = nil) {
        self.type = type
        switchTypeCalendar(type: type)
        
        if let dt = date {
            scrollTo(dt)
        }
    }
    
    public func reloadData() {
        if !style.systemCalendars.isEmpty {
            authForSystemCalendars()
        }
        
        let events = dataSource?.eventsForCalendar(systemEvents: systemEvents) ?? []
        
        switch type {
        case .day:
            dayView.reloadData(events)
        case .week:
            weekView.reloadData(events)
        case .month:
            monthView.reloadData(events)
        case .list:
            listView.reloadData(events)
        default:
            break
        }
    }
    
    public func scrollTo(_ date: Date) {
        switch type {
        case .day:
            dayView.setDate(date)
        case .week:
            weekView.setDate(date)
        case .month:
            monthView.setDate(date)
        case .year:
            yearView.setDate(date)
        case .list:
            listView.setDate(date)
        }
    }
    
    public func deselectEvent(_ event: KVKCalendarEvent, animated: Bool) {
        switch type {
        case .day:
            dayView.timelinePages.timelineView?.deselectEvent(event, animated: animated)
        case .week:
            weekView.timelinePages.timelineView?.deselectEvent(event, animated: animated)
        default:
            break
        }
    }
    
    public func activateMovingEventInMonth(eventView: KVKCalendarEventViewGeneral, snapshot: UIView, gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            monthView.didStartMoveEvent(eventView, snapshot: snapshot, gesture: gesture)
        case .cancelled, .ended, .failed:
            monthView.didEndMoveEvent(gesture: gesture)
        default:
            break
        }
    }
    
    public func movingEventInMonth(eventView: KVKCalendarEventViewGeneral, snapshot: UIView, gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            monthView.didChangeMoveEvent(gesture: gesture)
        default:
            break
        }
    }
    
    // MARK: Private methods
    
    func getSystemEvents(eventStore: EKEventStore, calendars: [EKCalendar]) -> [EKEvent] {
        var startOffset = 0
        if calendarData.yearsCount.count > 1 {
            startOffset = calendarData.yearsCount.first ?? 0
        }
        var endOffset = 1
        if calendarData.yearsCount.count > 1 {
            endOffset = calendarData.yearsCount.last ?? 1
        }
        
        guard let startDate = style.calendar.date(byAdding: .year, value: startOffset, to: calendarData.date),
              let endDate = style.calendar.date(byAdding: .year, value: endOffset, to: calendarData.date) else {
            return []
        }
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        return eventStore.events(matching: predicate)
    }
    
    private func authForSystemCalendars() {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch (status) {
        case .notDetermined:
            requestAccessToSystemCalendar { (_) in
                DispatchQueue.main.async { [weak self] in
                    self?.reloadData()
                }
            }
        default:
            break
        }
    }
    
    private func requestAccessToSystemCalendar(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { [weak self] (access, error) in
            print("System calendars = \(self?.style.systemCalendars ?? []) - access = \(access), error = \(error?.localizedDescription ?? "nil")")
            completion(access)
        }
    }
    
    private func switchTypeCalendar(type: KVKCalendarType) {
        self.type = type
        currentViewCache?.removeFromSuperview()
        
        switch self.type {
        case .day:
            addSubview(dayView)
            currentViewCache = dayView
        case .week:
            addSubview(weekView)
            currentViewCache = weekView
        case .month:
            addSubview(monthView)
            currentViewCache = monthView
        case .year:
            addSubview(yearView)
            currentViewCache = yearView
        case .list:
            addSubview(listView)
            currentViewCache = listView
            reloadData()
        }
        
        if let cacheView = currentViewCache as? CalendarSettingProtocol, cacheView.currentStyle != style {
            cacheView.updateStyle(style)
        }
    }
}

extension KVKCalendarView: DisplayDataSource {
    public func dequeueCell<T>(dateParameter: KVKCalendarDateParameter, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? where T : UIScrollView {
        return dataSource?.dequeueCell(dateParameter: dateParameter, type: type, view: view, indexPath: indexPath)
    }
    
    public func dequeueHeader<T>(date: Date?, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarHeaderProtocol? where T : UIScrollView {
        return dataSource?.dequeueHeader(date: date, type: type, view: view, indexPath: indexPath)
    }
    
    public func willDisplayCollectionView(frame: CGRect, type: KVKCalendarType) -> UICollectionView? {
        return dataSource?.willDisplayCollectionView(frame: frame, type: type)
    }
    
    public func willDisplayEventView(_ event: KVKCalendarEvent, frame: CGRect, date: Date?) -> KVKCalendarEventViewGeneral? {
        return dataSource?.willDisplayEventView(event, frame: frame, date: date)
    }

    public func willDisplayHeaderSubview(date: Date?, frame: CGRect, type: KVKCalendarType) -> UIView? {
        return dataSource?.willDisplayHeaderSubview(date: date, frame: frame, type: type)
    }
    
    public func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? {
        return dataSource?.willDisplayEventViewer(date: date, frame: frame)
    }
}

extension KVKCalendarView: DisplayDelegate {
    public func sizeForHeader(_ date: Date?, type: KVKCalendarType) -> CGSize? {
        delegate?.sizeForHeader(date, type: type)
    }
    
    public func sizeForCell(_ date: Date?, type: KVKCalendarType) -> CGSize? {
        delegate?.sizeForCell(date, type: type)
    }
    
    func didDisplayEvents(_ events: [KVKCalendarEvent], dates: [Date?], type: KVKCalendarType) {
        guard self.type == type else { return }
        
        delegate?.didDisplayEvents(events, dates: dates)
    }
    
    public func didSelectDates(_ dates: [Date], type: KVKCalendarType, frame: CGRect?) {
        delegate?.didSelectDates(dates, type: type, frame: frame)
    }
    
    public func didDeselectEvent(_ event: KVKCalendarEvent, animated: Bool) {
        delegate?.didDeselectEvent(event, animated: animated)
    }
    
    public func didSelectEvent(_ event: KVKCalendarEvent, type: KVKCalendarType, frame: CGRect?) {
        delegate?.didSelectEvent(event, type: type, frame: frame)
    }
    
    public func didSelectMore(_ date: Date, frame: CGRect?) {
        delegate?.didSelectMore(date, frame: frame)
    }
    
    public func didAddNewEvent(_ event: KVKCalendarEvent, _ date: Date?) {
        delegate?.didAddNewEvent(event, date)
    }
    
    public func didChangeEvent(_ event: KVKCalendarEvent, start: Date?, end: Date?) {
        delegate?.didChangeEvent(event, start: start, end: end)
    }
    
    public func didChangeViewerFrame(_ frame: CGRect) {
        var newFrame = frame
        newFrame.origin = .zero
        delegate?.didChangeViewerFrame(newFrame)
    }
}

extension KVKCalendarView: CalendarSettingProtocol {
    var currentStyle: KVKCalendarStyle {
        return style
    }
    
    public func reloadFrame(_ frame: CGRect) {
        self.frame = frame
        
        if let currentView = currentViewCache as? CalendarSettingProtocol {
            currentView.reloadFrame(frame)
        }
    }
    
    public func updateStyle(_ style: KVKCalendarStyle) {
        self.style = style
        
        if let currentView = currentViewCache as? CalendarSettingProtocol {
            currentView.updateStyle(style)
        }
    }
    
    func setUI() {
        
    }
}
