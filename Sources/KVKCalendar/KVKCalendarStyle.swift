//
//  KVKCalendarStyle.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 02/01/2019.
//

import UIKit

private let gainsboro: UIColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)

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
    public var timeSystem: KVKCalendarTimeHourSystem = .twentyFour
    public var startWeekDay: KVKCalendarStartDayType = .monday
    public var followInSystemTheme: Bool = true
    public var systemCalendars: Set<String> = []
    
    public init() {}
}

// MARK: Header scroll style

public struct KVKCalendarHeaderScrollStyle {
    public var titleDays: [String] = []
    public var heightHeaderWeek: CGFloat = 50
    public var heightSubviewHeader: CGFloat = 30
    
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "heightSubviewHeader")
    public var heightTitleDate: CGFloat = 30
    
    public var colorBackground: UIColor = gainsboro.withAlphaComponent(0.4)
    public var isHiddenSubview: Bool = false
    
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "isHiddenSubview")
    public var isHiddenTitleDate: Bool = false
    
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "isHiddenSubview")
    public var isHiddenCornerTitleDate: Bool = true
    
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "titleFormatter")
    public var formatterTitle: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .full
        return format
    }()
    
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .full
        return format
    }()
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    
    public var colorTitleDate: UIColor = .black
    public var colorTitleCornerDate: UIColor = .red
    public var colorDate: UIColor = .black
    public var fontDate: UIFont = .systemFont(ofSize: 17)
    public var colorNameDay: UIColor = .black
    public var fontNameDay: UIFont = .systemFont(ofSize: 10)
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .red
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorCurrentSelectDateForDarkStyle: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var isScrollEnabled: Bool = true
    public var colorWeekdayBackground: UIColor = .clear
    public var colorWeekendBackground: UIColor = .clear
    public var isHidden: Bool = false
    public var dotCorners: UIRectCorner = .allCorners
    public var dotCornersRadius: CGSize?
    public var titleDateAlignment: NSTextAlignment = .left
    public var titleDateFont: UIFont = .boldSystemFont(ofSize: 20)
    public var isAnimateTitleDate: Bool = false
    public var colorNameEmptyDay: UIColor = gainsboro
    public var showDatesForOtherMonths: Bool = true
    public var isAnimateSelection: Bool = true
    
    var backgroundBlurStyle: UIBlurEffect.Style? = nil
}

// MARK: Timeline style

public struct KVKCalendarTimelineStyle {
    public var startFromFirstEvent: Bool = false
    public var eventFont: UIFont = .boldSystemFont(ofSize: 12)
    public var offsetEvent: CGFloat = 3
    public var startHour: Int = 0
    public var heightLine: CGFloat = 0.5
    public var widthLine: CGFloat = 0.5
    public var offsetLineLeft: CGFloat = 10
    public var offsetLineRight: CGFloat = 10
    public var backgroundColor: UIColor = .white
    public var widthTime: CGFloat = 40
    public var heightTime: CGFloat = 20
    public var offsetTimeX: CGFloat = 10
    public var offsetTimeY: CGFloat = 80
    public var timeColor: UIColor = .systemGray
    public var timeFont: UIFont = .systemFont(ofSize: 12)
    public var widthEventViewer: CGFloat? = nil
    
    @available(swift, deprecated: 0.4.2, obsoleted: 0.4.3, renamed: "showLineHourMode")
    public var showCurrentLineHour: Bool = true
    public var showLineHourMode: CurrentLineHourShowMode = .today
    
    @available(swift, deprecated: 0.4.2, obsoleted: 0.4.3, renamed: "scrollLineHourMode")
    public var scrollToCurrentHour: Bool = true
    public var scrollLineHourMode: CurrentLineHourScrollMode = .today
    
    public var currentLineHourFont: UIFont = .systemFont(ofSize: 12)
    public var currentLineHourColor: UIColor = .red
    public var currentLineHourDotSize: CGSize = CGSize(width: 5, height: 5)
    public var currentLineHourDotCornersRadius: CGSize = CGSize(width: 2.5, height: 2.5)
    public var currentLineHourWidth: CGFloat = 60
    public var currentLineHourHeight: CGFloat = 1
    public var separatorLineColor: UIColor = .gray
    public var movingMinutesColor: UIColor = .systemBlue
    public var shadowColumnColor: UIColor = .systemTeal
    public var shadowColumnAlpha: CGFloat = 0.1
    public var minimumPressDuration: TimeInterval = 0.5
    public var isHiddenStubEvent: Bool = false
    public var isEnabledCreateNewEvent: Bool = true
    public var maxLimitChachedPages: UInt = 10
    public var scrollDirections: Set<ScrollDirectionType> = Set(ScrollDirectionType.allCases)
    
    public enum ScrollDirectionType: Int, CaseIterable {
        case vertical, horizontal
    }
    
    public enum CurrentLineHourShowMode: Equatable {
        case always, today, forDate(Date)
        
        func showForDates(_ dates: [Date?]) -> Bool {
            switch self {
            case .always:
                return true
            case .today:
                let todayDate = Date()
                return dates.contains(where: { todayDate.year == $0?.year && todayDate.month == $0?.month && todayDate.day == $0?.day })
            case let .forDate(customDate):
                return dates.contains(where: { customDate.year == $0?.year && customDate.month == $0?.month && customDate.day == $0?.day })
            }
        }

    }
    
    public enum CurrentLineHourScrollMode: Equatable {
        case always, today, forDate(Date)
        
        func scrollForDates(_ dates: [Date?]) -> Bool {
            switch self {
            case .always:
                return true
            case .today:
                let todayDate = Date()
                return dates.contains(where: { todayDate.year == $0?.year && todayDate.month == $0?.month && todayDate.day == $0?.day })
            case let .forDate(customDate):
                return dates.contains(where: { customDate.year == $0?.year && customDate.month == $0?.month && customDate.day == $0?.day })
            }
        }
    }
}

// MARK: Week style

public struct KVKCalendarWeekStyle {
    public var colorBackground: UIColor = gainsboro.withAlphaComponent(0.2)
    public var colorDate: UIColor = .black
    public var colorNameDay: UIColor = .black
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var colorWeekendBackground: UIColor = .clear
    public var colorWeekdayBackground: UIColor = .clear
    public var selectCalendarType: KVKCalendarType = .day
    public var showVerticalDayDivider: Bool = true
}

// MARK: Month style

public struct KVKCalendarMonthStyle {
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "titleFormatter")
    public var formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MMMM yyyy"
        return format
    }()
    
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MMMM yyyy"
        return format
    }()
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    public var shortInDayMonthFormatter: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "MMM"
        return format
    }
    public var heightHeaderWeek: CGFloat = 25
    public var heightTitleDate: CGFloat = 40
    public var isHiddenTitleDate: Bool = false
    public var colorDate: UIColor = .black
    public var colorNameEmptyDay: UIColor = gainsboro
    public var fontNameDate: UIFont = .boldSystemFont(ofSize: 16)
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var moreTitle: String = "more"
    public var isHiddenMoreTitle: Bool = false
    public var colorMoreTitle: UIColor = .gray
    public var colorEventTitle: UIColor = .black
    public var weekFont: UIFont = .boldSystemFont(ofSize: 14)
    public var fontEventTitle: UIFont = .systemFont(ofSize: 14)
    public var fontEventTime: UIFont = .systemFont(ofSize: 10)
    public var fontEventBullet: UIFont = .boldSystemFont(ofSize: 18)
    public var isHiddenSeparator: Bool = false
    public var isHiddenSeparatorOnEmptyDate: Bool = false
    public var widthSeparator: CGFloat = 0.4
    public var colorSeparator: UIColor = gainsboro.withAlphaComponent(0.9)
    public var colorBackgroundWeekendDate: UIColor = gainsboro.withAlphaComponent(0.2)
    public var colorBackgroundDate: UIColor = .white
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    public var selectCalendarType: KVKCalendarType = .week
    public var isAnimateSelection: Bool = true
    public var isPagingEnabled: Bool = true
    public var isScrollEnabled: Bool = true
    
    @available(swift, deprecated: 0.4.7, obsoleted: 0.4.8, renamed: "autoSelectionDateWhenScrolling")
    public var isAutoSelectDateScrolling: Bool = false
    public var autoSelectionDateWhenScrolling: Bool = false
    
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 5, height: 5)
    public var isHiddenDotInTitle: Bool = false
    public var isHiddenTitle: Bool = false
    public var weekDayAlignment: NSTextAlignment = .right
    public var titleDateAlignment: NSTextAlignment = .left
    public var fontTitleDate: UIFont = .boldSystemFont(ofSize: 30)
    public var colorTitleDate: UIColor = .black
    public var showDatesForOtherMonths: Bool = false
    public var colorBackground: UIColor = .white
    public var selectionMode: SelectionMode = .multiple
    
    public enum SelectionMode: Int {
        case single, multiple
    }
}

// MARK: Year style

public struct KVKCalendarYearStyle {
    @available(swift, deprecated: 0.4.1, obsoleted: 0.4.2, renamed: "titleFormatter")
    public var formatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        return format
    }()
    public var titleFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        return format
    }()
    
    public var weekdayFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "EE"
        return format
    }()
    
    public var colorCurrentDate: UIColor = .white
    public var colorBackgroundCurrentDate: UIColor = .systemRed
    public var colorBackgroundSelectDate: UIColor = .black
    public var colorSelectDate: UIColor = .white
    public var colorWeekendDate: UIColor = .gray
    public var colorBackgroundWeekendDate: UIColor = .clear
    public var weekFontPad: UIFont = .boldSystemFont(ofSize: 14)
    public var weekFontPhone: UIFont = .boldSystemFont(ofSize: 8)
    public var weekFont: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return weekFontPhone
        default:
            return weekFontPad
        }
    }
    public var fontTitle: UIFont = .systemFont(ofSize: 19)
    public var colorTitle: UIColor = .black
    public var colorBackgroundHeader: UIColor = gainsboro.withAlphaComponent(0.2)
    public var fontTitleHeader: UIFont = .boldSystemFont(ofSize: 40)
    public var colorTitleHeader: UIColor = .black
    public var heightTitleHeader: CGFloat = 50
    public var alignmentTitleHeader: NSTextAlignment = .left
    public var fontDayTitlePad: UIFont = .systemFont(ofSize: 15)
    public var fontDayTitlePhone: UIFont = .systemFont(ofSize: 11)
    public var fontDayTitle: UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return fontDayTitlePhone
        default:
            return fontDayTitlePad
        }
    }
    public var colorDayTitle: UIColor = .black
    public var selectCalendarType: KVKCalendarType = .month
    public var isAnimateSelection: Bool = true
    public var isPagingEnabled: Bool = true
    public var isAutoSelectDateScrolling: Bool = true
    public var weekDayAlignment: NSTextAlignment = .center
    public var titleDateAlignment: NSTextAlignment = .left
    public var colorBackground: UIColor = .white
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
}

// MARK: All Day style

public struct KVKCalendarAllDayStyle {
    public var backgroundColor: UIColor = gainsboro
    public var titleText: String = "all-day"
    public var titleColor: UIColor = .black
    public var textColor: UIColor = .black
    public var backgroundColorEvent: UIColor = .clear
    public var font: UIFont = .systemFont(ofSize: 12)
    public var offsetWidth: CGFloat = 2
    public var offsetHeight: CGFloat = 4
    public var height: CGFloat = 25
    public var fontTitle: UIFont = .systemFont(ofSize: 10)
    public var isPinned: Bool = true
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 5, height: 5)
    public var axis: AxisMode = .vertical
    
    public enum AxisMode: Int {
        case horizontal, vertical
    }
}

// MARK: KVKCalendarEvent style

public struct KVKCalendarEventStyle {
    @available(swift, deprecated: 0.3.8, obsoleted: 0.3.9, renamed: "states")
    public var isEnableMoveEvent: Bool = true
    
    public var minimumPressDuration: TimeInterval = 0.5
    public var alphaWhileMoving: CGFloat = 0.5
    public var textForNewEvent: String = "New Event"
    public var iconFile: UIImage? = nil
    public var colorIconFile: UIColor = .black
    public var isEnableVisualSelect: Bool = true
    public var colorStubView: UIColor? = nil
    public var heightStubView: CGFloat = 5
    public var alignmentStubView: NSLayoutConstraint.Axis = .vertical
    public var spacingStubView: CGFloat = 1
    public var eventCorners: UIRectCorner = .allCorners
    public var eventCornersRadius: CGSize = CGSize(width: 2.5, height: 2.5)
    public var delayForStartMove: TimeInterval = 1.5
    public var states: Set<KVKCalendarEventViewGeneral.EventViewState> = [.move, .resize]
    public var defaultHeight: CGFloat? = nil
    
    var defaultWidth: CGFloat? = nil
    var isEnableContextMenu: Bool = false
}

// MARK: List View KVKCalendarStyle

public struct KVKCalendarListViewStyle {
    public var fontBullet: UIFont = .boldSystemFont(ofSize: 50)
    public var fontTitle: UIFont = .systemFont(ofSize: 17)
    public var heightHeaderView: CGFloat = 50
    public var backgroundColor: UIColor = .white
}

extension KVKCalendarStyle {
    var checkStyle: KVKCalendarStyle {
        guard followInSystemTheme else { return self }
        
        var newStyle = self
        if #available(iOS 13.0, *) {            
            // event
            newStyle.event.colorIconFile = UIColor.useForStyle(dark: .systemGray, white: newStyle.event.colorIconFile)
            
            // header
            newStyle.headerScroll.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6, white: newStyle.headerScroll.colorNameEmptyDay)
            newStyle.headerScroll.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.headerScroll.colorBackground)
            newStyle.headerScroll.colorTitleDate = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorTitleDate)
            newStyle.headerScroll.colorTitleCornerDate = UIColor.useForStyle(dark: .systemRed, white: newStyle.headerScroll.colorTitleCornerDate)
            newStyle.headerScroll.colorDate = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorDate)
            newStyle.headerScroll.colorNameDay = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorNameDay)
            newStyle.headerScroll.colorCurrentDate = UIColor.useForStyle(dark: .systemGray6, white: newStyle.headerScroll.colorCurrentDate)
            newStyle.headerScroll.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed, white: newStyle.headerScroll.colorBackgroundCurrentDate)
            newStyle.headerScroll.colorBackgroundSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorBackgroundSelectDate)
            newStyle.headerScroll.colorSelectDate = UIColor.useForStyle(dark: .black, white: newStyle.headerScroll.colorSelectDate)
            newStyle.headerScroll.colorCurrentSelectDateForDarkStyle = UIColor.useForStyle(dark: .white, white: newStyle.headerScroll.colorCurrentSelectDateForDarkStyle)
            newStyle.headerScroll.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.headerScroll.colorWeekendDate)
            
            // timeline
            newStyle.timeline.backgroundColor = UIColor.useForStyle(dark: .black, white: newStyle.timeline.backgroundColor)
            newStyle.timeline.timeColor = UIColor.useForStyle(dark: .systemGray, white: newStyle.timeline.timeColor)
            newStyle.timeline.currentLineHourColor = UIColor.useForStyle(dark: .systemRed, white: newStyle.timeline.currentLineHourColor)
            
            // week
            newStyle.week.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.week.colorBackground)
            newStyle.week.colorDate = UIColor.useForStyle(dark: .white, white: newStyle.week.colorDate)
            newStyle.week.colorNameDay = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorNameDay)
            newStyle.week.colorCurrentDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorCurrentDate)
            newStyle.week.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorBackgroundSelectDate)
            newStyle.week.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.week.colorBackgroundCurrentDate)
            newStyle.week.colorSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.week.colorSelectDate)
            newStyle.week.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.week.colorWeekendDate)
            newStyle.week.colorWeekendBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekendBackground)
            newStyle.week.colorWeekdayBackground = UIColor.useForStyle(dark: .clear, white: newStyle.week.colorWeekdayBackground)
            
            // month
            newStyle.month.colorDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorDate)
            newStyle.month.colorNameEmptyDay = UIColor.useForStyle(dark: .systemGray6, white: newStyle.month.colorNameEmptyDay)
            newStyle.month.colorCurrentDate = UIColor.useForStyle(dark: .white, white: newStyle.month.colorCurrentDate)
            newStyle.month.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed, white: newStyle.month.colorBackgroundCurrentDate)
            newStyle.month.colorBackgroundSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.month.colorBackgroundSelectDate)
            newStyle.month.colorSelectDate = UIColor.useForStyle(dark: .black, white: newStyle.month.colorSelectDate)
            newStyle.month.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.month.colorWeekendDate)
            newStyle.month.colorMoreTitle = UIColor.useForStyle(dark: .systemGray3, white: newStyle.month.colorMoreTitle)
            newStyle.month.colorEventTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorEventTitle)
            newStyle.month.colorSeparator = UIColor.useForStyle(dark: .systemGray, white: newStyle.month.colorSeparator)
            newStyle.month.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .systemGray6, white: newStyle.month.colorBackgroundWeekendDate)
            newStyle.month.colorBackgroundDate = UIColor.useForStyle(dark: .black, white: newStyle.month.colorBackgroundDate)
            newStyle.month.colorTitleDate = UIColor.useForStyle(dark: .white, white: newStyle.month.colorTitleDate)
            newStyle.month.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.month.colorBackground)
            
            // year
            newStyle.year.colorCurrentDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorCurrentDate)
            newStyle.year.colorBackgroundCurrentDate = UIColor.useForStyle(dark: .systemRed, white: newStyle.year.colorBackgroundCurrentDate)
            newStyle.year.colorBackgroundSelectDate = UIColor.useForStyle(dark: .systemGray, white: newStyle.year.colorBackgroundSelectDate)
            newStyle.year.colorSelectDate = UIColor.useForStyle(dark: .white, white: newStyle.year.colorSelectDate)
            newStyle.year.colorWeekendDate = UIColor.useForStyle(dark: .systemGray2, white: newStyle.year.colorWeekendDate)
            newStyle.year.colorBackgroundWeekendDate = UIColor.useForStyle(dark: .clear, white: newStyle.year.colorBackgroundWeekendDate)
            newStyle.year.colorTitle = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitle)
            newStyle.year.colorBackgroundHeader = UIColor.useForStyle(dark: .black, white: newStyle.year.colorBackgroundHeader)
            newStyle.year.colorTitleHeader = UIColor.useForStyle(dark: .white, white: newStyle.year.colorTitleHeader)
            newStyle.year.colorDayTitle = UIColor.useForStyle(dark: .systemGray, white: newStyle.year.colorDayTitle)
            newStyle.year.colorBackground = UIColor.useForStyle(dark: .black, white: newStyle.year.colorBackground)
            
            // all day
            newStyle.allDay.backgroundColor = UIColor.useForStyle(dark: .systemGray6, white: newStyle.allDay.backgroundColor)
            newStyle.allDay.titleColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.titleColor)
            newStyle.allDay.textColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.textColor)
            
            // list view
            newStyle.list.backgroundColor = UIColor.useForStyle(dark: .black, white: newStyle.list.backgroundColor)
        }
        return newStyle
    }
}

extension KVKCalendarStyle: Equatable {
    
    public static func == (lhs: KVKCalendarStyle, rhs: KVKCalendarStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.event)
            && compare(\.timeline)
            && compare(\.allDay)
            && compare(\.week)
            && compare(\.headerScroll)
            && compare(\.month)
            && compare(\.year)
            && compare(\.list)
            && compare(\.locale)
            && compare(\.timezone)
            && compare(\.defaultType)
            && compare(\.timeSystem)
            && compare(\.startWeekDay)
            && compare(\.followInSystemTheme)
            && compare(\.systemCalendars)
    }
    
}

extension KVKCalendarYearStyle: Equatable {
    
    public static func == (lhs: KVKCalendarYearStyle, rhs: KVKCalendarYearStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarYearStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleFormatter)
            && compare(\.weekdayFormatter)
            && compare(\.colorCurrentDate)
            && compare(\.colorBackgroundCurrentDate)
            && compare(\.colorBackgroundSelectDate)
            && compare(\.colorSelectDate)
            && compare(\.colorWeekendDate)
            && compare(\.weekFont)
            && compare(\.colorBackgroundWeekendDate)
            && compare(\.scrollDirection)
            && compare(\.isAnimateSelection)
            && compare(\.isPagingEnabled)
            && compare(\.weekDayAlignment)
            && compare(\.titleDateAlignment)
            && compare(\.colorBackground)
            && compare(\.weekFontPad)
            && compare(\.weekFontPhone)
            && compare(\.fontTitle)
            && compare(\.colorTitle)
            && compare(\.colorBackgroundHeader)
            && compare(\.fontTitleHeader)
            && compare(\.colorTitleHeader)
            && compare(\.heightTitleHeader)
            && compare(\.alignmentTitleHeader)
            && compare(\.fontDayTitlePad)
            && compare(\.fontDayTitlePhone)
            && compare(\.fontDayTitle)
            && compare(\.colorDayTitle)
            && compare(\.selectCalendarType)
            && compare(\.isAutoSelectDateScrolling)
            && compare(\.weekDayAlignment)
            && compare(\.titleDateAlignment)
    }
    
}

extension KVKCalendarMonthStyle: Equatable {
    
    public static func == (lhs: KVKCalendarMonthStyle, rhs: KVKCalendarMonthStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarMonthStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleFormatter)
            && compare(\.weekdayFormatter)
            && compare(\.shortInDayMonthFormatter)
            && compare(\.heightHeaderWeek)
            && compare(\.heightTitleDate)
            && compare(\.isHiddenTitleDate)
            && compare(\.colorDate)
            && compare(\.colorNameEmptyDay)
            && compare(\.fontNameDate)
            && compare(\.colorCurrentDate)
            && compare(\.colorBackgroundCurrentDate)
            && compare(\.colorBackgroundSelectDate)
            && compare(\.colorSelectDate)
            && compare(\.colorWeekendDate)
            && compare(\.moreTitle)
            && compare(\.isHiddenMoreTitle)
            && compare(\.colorMoreTitle)
            && compare(\.colorEventTitle)
            && compare(\.weekFont)
            && compare(\.fontEventTitle)
            && compare(\.fontEventTime)
            && compare(\.fontEventBullet)
            && compare(\.isHiddenSeparator)
            && compare(\.isHiddenSeparatorOnEmptyDate)
            && compare(\.widthSeparator)
            && compare(\.colorSeparator)
            && compare(\.colorBackgroundWeekendDate)
            && compare(\.colorBackgroundDate)
            && compare(\.scrollDirection)
            && compare(\.isAnimateSelection)
            && compare(\.isPagingEnabled)
            && compare(\.isScrollEnabled)
            && compare(\.autoSelectionDateWhenScrolling)
            && compare(\.eventCorners)
            && compare(\.eventCornersRadius)
            && compare(\.isHiddenDotInTitle)
            && compare(\.isHiddenTitle)
            && compare(\.weekDayAlignment)
            && compare(\.titleDateAlignment)
            && compare(\.fontTitleDate)
            && compare(\.colorTitleDate)
            && compare(\.showDatesForOtherMonths)
            && compare(\.colorBackground)
            && compare(\.selectionMode)
    }
    
}

extension KVKCalendarListViewStyle: Equatable {
    
    public static func == (lhs: KVKCalendarListViewStyle, rhs: KVKCalendarListViewStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarListViewStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.fontBullet)
            && compare(\.fontTitle)
            && compare(\.heightHeaderView)
            && compare(\.backgroundColor)
    }
    
}

extension KVKCalendarHeaderScrollStyle: Equatable {
    
    public static func == (lhs: KVKCalendarHeaderScrollStyle, rhs: KVKCalendarHeaderScrollStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarHeaderScrollStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.titleDays)
            && compare(\.heightHeaderWeek)
            && compare(\.heightSubviewHeader)
            && compare(\.colorBackground)
            && compare(\.isHidden)
            && compare(\.isHiddenSubview)
            && compare(\.titleFormatter)
            && compare(\.weekdayFormatter)
            && compare(\.colorTitleDate)
            && compare(\.colorTitleCornerDate)
            && compare(\.colorDate)
            && compare(\.fontDate)
            && compare(\.colorNameDay)
            && compare(\.fontNameDay)
            && compare(\.colorCurrentDate)
            && compare(\.colorBackgroundCurrentDate)
            && compare(\.colorBackgroundSelectDate)
            && compare(\.colorSelectDate)
            && compare(\.colorCurrentSelectDateForDarkStyle)
            && compare(\.colorWeekendDate)
            && compare(\.isScrollEnabled)
            && compare(\.colorWeekdayBackground)
            && compare(\.colorWeekendBackground)
            && compare(\.isHidden)
            && compare(\.dotCorners)
            && compare(\.dotCornersRadius)
            && compare(\.titleDateAlignment)
            && compare(\.titleDateFont)
            && compare(\.isAnimateTitleDate)
            && compare(\.colorNameEmptyDay)
            && compare(\.showDatesForOtherMonths)
            && compare(\.isAnimateSelection)
    }
    
}

extension KVKCalendarWeekStyle: Equatable {
    
    public static func == (lhs: KVKCalendarWeekStyle, rhs: KVKCalendarWeekStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarWeekStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.colorBackground)
            && compare(\.colorDate)
            && compare(\.colorNameDay)
            && compare(\.colorCurrentDate)
            && compare(\.colorBackgroundCurrentDate)
            && compare(\.colorBackgroundSelectDate)
            && compare(\.colorSelectDate)
            && compare(\.colorWeekendDate)
            && compare(\.colorWeekendBackground)
            && compare(\.colorWeekdayBackground)
            && compare(\.selectCalendarType)
            && compare(\.showVerticalDayDivider)
    }
    
}

extension KVKCalendarAllDayStyle: Equatable {
    
    public static func == (lhs: KVKCalendarAllDayStyle, rhs: KVKCalendarAllDayStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarAllDayStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.backgroundColor)
            && compare(\.titleText)
            && compare(\.titleColor)
            && compare(\.textColor)
            && compare(\.backgroundColorEvent)
            && compare(\.font)
            && compare(\.offsetWidth)
            && compare(\.offsetHeight)
            && compare(\.height)
            && compare(\.fontTitle)
            && compare(\.isPinned)
            && compare(\.eventCorners)
            && compare(\.eventCornersRadius)
            && compare(\.axis)
    }
    
}

extension KVKCalendarTimelineStyle: Equatable {
    
    public static func == (lhs: KVKCalendarTimelineStyle, rhs: KVKCalendarTimelineStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarTimelineStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.minimumPressDuration)
            && compare(\.startFromFirstEvent)
            && compare(\.eventFont)
            && compare(\.offsetEvent)
            && compare(\.startHour)
            && compare(\.heightLine)
            && compare(\.widthLine)
            && compare(\.offsetLineLeft)
            && compare(\.offsetLineRight)
            && compare(\.backgroundColor)
            && compare(\.widthTime)
            && compare(\.heightTime)
            && compare(\.offsetTimeX)
            && compare(\.offsetTimeY)
            && compare(\.timeColor)
            && compare(\.timeFont)
            && compare(\.widthEventViewer)
            && compare(\.showLineHourMode)
            && compare(\.scrollLineHourMode)
            && compare(\.currentLineHourFont)
            && compare(\.currentLineHourColor)
            && compare(\.currentLineHourDotSize)
            && compare(\.currentLineHourDotCornersRadius)
            && compare(\.currentLineHourWidth)
            && compare(\.currentLineHourHeight)
            && compare(\.separatorLineColor)
            && compare(\.movingMinutesColor)
            && compare(\.shadowColumnColor)
            && compare(\.shadowColumnAlpha)
            && compare(\.minimumPressDuration)
            && compare(\.isHiddenStubEvent)
            && compare(\.isEnabledCreateNewEvent)
            && compare(\.maxLimitChachedPages)
            && compare(\.scrollDirections)
    }
    
}

extension KVKCalendarEventStyle: Equatable {
    
    public static func == (lhs: KVKCalendarEventStyle, rhs: KVKCalendarEventStyle) -> Bool {
        func compare<E: Equatable>(_ kp: KeyPath<KVKCalendarEventStyle, E>) -> Bool {
            return lhs[keyPath: kp] == rhs[keyPath: kp]
        }
        
        return compare(\.minimumPressDuration)
            && compare(\.alphaWhileMoving)
            && compare(\.textForNewEvent)
            && compare(\.iconFile)
            && compare(\.colorIconFile)
            && compare(\.isEnableVisualSelect)
            && compare(\.colorStubView)
            && compare(\.heightStubView)
            && compare(\.alignmentStubView)
            && compare(\.spacingStubView)
            && compare(\.eventCorners)
            && compare(\.eventCornersRadius)
            && compare(\.delayForStartMove)
            && compare(\.states)
            && compare(\.defaultHeight)
    }
    
}