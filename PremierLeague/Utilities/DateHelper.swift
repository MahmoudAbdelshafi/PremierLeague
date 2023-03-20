//
//  DateHelper.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 17/03/2023.
//

import Foundation
public struct DateHelper {
    public static func formate(date: Date, with pattern: DatePattern) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = pattern.rawValue
        return dateFormatter.string(from: date)
    }
    
    public static func date(from string: String, with pattern: DatePattern = DatePattern.json) -> Date? {
        let jsonDateFormat = pattern.rawValue
        let formatter = Date.formatter()
        formatter.dateFormat = jsonDateFormat
        return formatter.date(from: string)
    }
    
    public func formatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = tempLocale
        return dateFormatter
    }
    
    public func formatToStr(str:String,format: DatePattern, toFormat: DatePattern) -> String {
        let dateFormatter = formatter()
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.date(from: str)!
        dateFormatter.dateFormat = toFormat.rawValue
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    public func getCurrentDate(with pattern: DatePattern) -> Date?{
        let dateFormatter = formatter()
        dateFormatter.dateFormat = pattern.rawValue
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let toDate = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = DatePattern.dd_MM_yyyy.rawValue
        return toDate
    }
    
    public func getMatchDate(val:String) -> Date?{
        let dateFormatter = formatter()
        dateFormatter.dateFormat = DatePattern.json.rawValue
        let date = dateFormatter.date(from: val)!
        return date
    }
    
}

public enum DatePattern: String {
    /// format: "yyyy-MM-dd'T'HH:mm:ss" as a  default format from backend
    case json = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    /// format: "yyyy-MM-dd"
    case yyyyDashMMDashdd = "yyyy-MM-dd"
    /// format: "yyyy/MM/dd"
    case yyyySlashMMSlashdd = "yyyy/MM/dd"
    /// format: "MMMM yyyy"
    case MMMMSpaceyyyy = "MMMM yyyy"
    /// format: "MM/yyyy"
    case MMSlashyyyy = "MM/yyyy"
    case ddSlashMMMMSlashyyyy = "dd / MMMM / yyyy"
    /// format: "MMMM dd"
    case MMMMSpacedd = "MMMM dd"
    /// format: "dd/MM/yyyy"
    case ddMMYYYY = "dd/MM/yyyy"
    /// format: "ddMMyyyy"
    case ddMMyyyy = "ddMMyyyy"
    /// format: "MM/dd/yyyy"
    case MMddYYYY = "MM/dd/yyyy"
    /// format: "MMMM"
    case MMMM = "MMMM"
    /// format: "MMM"
    case MMM = "MMM"
    /// format: "dd MMM"
    case ddMMM = "dd MMM"
    /// ex: 12
    case dd = "dd"
    case MMyyyy = "MM-yy"
    /// format: "MMM yyyy"
    case MMMSpaceyyyy = "MMM yyyy"
    /// ex: Monday
    case EEEE = "EEEE"
    /// ex: Saturday 25 February 2021 10:00 AM
    case EEEEddMMMMyyyHHmma = "EEEE dd MMMM yyyy HH:mm a"
    case time = "HH:mm a"
    
    case dd_MM_yyyy = "dd-MM-yyyy"

    case dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

}

extension Date {
    /// Retruns the date formatter with the default configuration
    ///
    public static func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
