<img src="Screenshots/iphone_month.png" width="280"> <img src="Screenshots/ipad_white.png" width="530">

[![CI Status](https://img.shields.io/travis/kvyatkovskys/KVKCalendar.svg?style=flat)](https://travis-ci.org/kvyatkovskys/KVKCalendar)
[![Version](https://img.shields.io/cocoapods/v/KVKCalendar.svg?style=flat)](https://cocoapods.org/pods/KVKCalendar)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=fla)](https://github.com/Carthage/Carthage/)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](https://swiftpackageindex.com/kvyatkovskys/KVKCalendar)
[![Platform](https://img.shields.io/cocoapods/p/KVKCalendar.svg?style=flat)](https://cocoapods.org/pods/KVKCalendar)
[![License](https://img.shields.io/cocoapods/l/KVKCalendar.svg?style=flat)](https://cocoapods.org/pods/KVKCalendar)

# KVKCalendar

**KVKCalendar** is a most fully customization calendar and timeline library. Library consists of four modules for displaying various types of calendar (*day*, *week*, *month*, *year*). You can choose any module or use all. It is designed based on a standard iOS calendar, but with additional features. Timeline displays the schedule for the day and week.

## Note for version **0.5.x**

Version **0.5.x** has major breaking changes. All public facing classes/structs/enums have been renamed so as to avoid possible name clashes with user definitions.

## Need Help?

If you have a **question** about how to use KVKCalendar in your application, ask it on StackOverflow using the [KVKCalendar](https://stackoverflow.com/questions/tagged/kvkcalendar) tag.

Please, use [Issues](https://github.com/kvyatkovskys/KVKCalendar/issues) only for reporting **bugs** or requesting a new **features** in the library.

## Requirements

- iOS 10.0+, iPadOS 10.0+, MacOS 10.15+ (Supports Mac Catalyst)
- Swift 5.0+

## Installation

**KVKCalendar** is available through [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage) or [Swift Package Manager](https://swift.org/package-manager/).

### CocoaPods
~~~bash
pod 'KVKCalendar'
~~~

[Adding Pods to an Xcode project](https://guides.cocoapods.org/using/using-cocoapods.html)

### Carthage
~~~bash
github "kvyatkovskys/KVKCalendar"
~~~

[Adding Frameworks to an Xcode project](https://github.com/Carthage/Carthage#quick-start)

### Swift Package Manager (Xcode 12 or higher)

1. In Xcode navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Select a project
3. Paste the repository URL (`https://github.com/kvyatkovskys/KVKCalendar.git`) and click **Next**.
4. For **Rules**, select **Version (Up to Next Major)** and click **Next**.
5. Click **Finish**.

[Adding Package Dependencies to Your App](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

## Usage for UIKit

Import `KVKCalendar`.
Create a subclass view `KVKCalendarView` and implement `KVKCalendarDataSource` protocol. Create an array of class `[KVKCalendarEvent]` and return the array.

```swift
import KVKCalendar

class ViewController: UIViewController {
    var events = [KVKCalendarEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = KVKCalendarView(frame: frame)
        calendar.dataSource = self
        view.addSubview(calendar)
        
        createEvents { (events) in
            self.events = events
            self.calendarView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.reloadFrame(view.frame)
    }
}

extension ViewController {
    func createEvents(completion: ([KVKCalendarEvent]) -> Void) {
        let models = // Get events from storage / API
        
        let events = models.compactMap({ (item) in
            var event = KVKCalendarEvent(ID: item.id)
            event.start = item.startDate // start date event
            event.end = item.endDate // end date event
            event.color = item.color
            event.isAllDay = item.allDay
            event.isContainsFile = !item.files.isEmpty
            event.recurringType = // recurring event type - .everyDay, .everyWeek
        
            // Add text event (title, info, location, time)
            if item.allDay {
                event.text = "\(item.title)"
            } else {
                event.text = "\(startTime) - \(endTime)\n\(item.title)"
            }
            return event
        })
        completion(events)
    }
}

extension ViewController: KVKCalendarDataSource {
    func eventsForCalendar(systemEvents: [EKEvent]) -> [KVKCalendarEvent] {
        // if you want to get events from iOS calendars
        // set calendar names to style.systemCalendars = ["Test"]
        let mappedEvents = systemEvents.compactMap({ $0.transform() })
        return events + mappedEvents
    }
}
```

Implement `KVKCalendarDelegate` to handle user action and control calendar behaviour.

```swift
calendar.delegate = self
```

To use a custom view for specific event or date you need to create a new view of class `KVKCalendarEventViewGeneral` and return the view in function.

```swift
class CustomViewEvent: KVKCalendarEventViewGeneral {
    override init(style: KVKCalendarStyle, event: KVKCalendarEvent, frame: CGRect) {
        super.init(style: style, event: event, frame: frame)
    }
}

// an optional function from KVKCalendarDataSource
func willDisplayEventView(_ event: KVKCalendarEvent, frame: CGRect, date: Date?) -> KVKCalendarEventViewGeneral? {
    guard event.ID == id else { return nil }
    
    return customEventView
}
```

<img src="Screenshots/custom_event_view.png" width="300">

To use a custom date cell, just subscribe on this optional method from `KVKCalendarDataSource` (works for Day/Week/Month/Year views).
```swift
func dequeueCell<T>(date: Date?, type: KVKCalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView { 
    switch type {
    case .year:
        let cell = (view as? UICollectionView)?.dequeueCell(indexPath: indexPath) { (cell: CustomYearCell) in
            // configure the cell
        }
        return cell
    case .day, .week, .month:    
        let cell = (view as? UICollectionView)?.dequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
            // configure the cell
        }
        return cell
    case .list:    
        let cell = (view as? UITableView)?.dequeueCell { (cell: CustomListCell) in
            // configure the cell
        }
        return cell
    }
}
```

<img src="Screenshots/custom_day_cell.png" width="300">

## Usage for SwiftUI

Add a new `SwiftUI` file and import `KVKCalendar`.
Create a struct `CalendarDisplayView` and declare the protocol `UIViewRepresentable` for connection `UIKit` with `SwiftUI`.

```swift
import SwiftUI
import KVKCalendar

struct CalendarDisplayView: UIViewRepresentable {
    @Binding var events: [KVKCalendarEvent]

    private var calendar: KVKCalendarView = {
        return KVKCalendarView(frame: frame, style: style)
    }()
        
    func makeUIView(context: UIViewRepresentableContext<CalendarDisplayView>) -> KVKCalendarView {
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.reloadData()
        return calendar
    }
    
    func updateUIView(_ uiView: KVKCalendarView, context: UIViewRepresentableContext<CalendarDisplayView>) {
        context.coordinator.events = events
    }
    
    func makeCoordinator() -> CalendarDisplayView.Coordinator {
        Coordinator(self)
    }
    
    public init(events: Binding<[KVKCalendarEvent]>) {
        self._events = events
    }
    
    // MARK: Calendar DataSource and Delegate
    class Coordinator: NSObject, KVKCalendarDataSource, KVKCalendarDelegate {
        private let view: CalendarDisplayView
        
        var events: [KVKCalendarEvent] = [] {
            didSet {
                view.calendar.reloadData()
            }
        }
        
        init(_ view: CalendarDisplayView) {
            self.view = view
            super.init()
        }
        
        func eventsForCalendar(systemEvents: [EKEvent]) -> [KVKCalendarEvent] {
            return events
        }
    }
}
```

Create a new `SwiftUI` file and add `CalendarDisplayView` to `body`.

```swift
import SwiftUI

struct CalendarContentView: View {
    @State var events: [KVKCalendarEvent] = []

    var body: some View {
        NavigationView {
            CalendarDisplayView(events: $events)
        }
    }
}
```

## Styles

To customize calendar create an object `KVKCalendarStyle` and add to `init` class `CalendarView`.

```swift
public struct KVKCalendarStyle {
    public var event = KVKCalendarEventStyle()
    public var timeline = KVKCalendarTimelineStyle()
    public var week = KVKCalendarWeekStyle()
    public var allDay = KVKCalendarAllDayStyle()
    public var headerScroll = KVKCalendarHeaderScrollStyle()
    public var month = KVKCalendarMonthStyle()
    public var year = KVKCalendarYearStyle()
    public var list = KVKCalendarListViewStyle()
    public var locale = Locale.current
    public var calendar = Calendar.current
    public var timezone = TimeZone.current
    public var defaultType: KVKCalendarType?
    public var timeHourSystem: TimeHourSystem = .twentyFourHour
    public var startWeekDay: StartDayType = .monday
    public var followInSystemTheme: Bool = false 
    public var systemCalendars: Set<String> = []
}
```

## Author

[Sergei Kviatkovskii](https://github.com/kvyatkovskys)

## License

KVKCalendar is available under the [MIT license](https://github.com/kvyatkovskys/KVKCalendar/blob/master/LICENSE.md)
