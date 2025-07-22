import Foundation

public struct TimestampParser {
    // 创建线程安全的日期格式化器
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // 支持的格式列表（按优先级排序）
    private static let formats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",  // 带毫秒（2025-07-22T08:54:27.185Z）
        "yyyy-MM-dd'T'HH:mm:ssXXXXX",      // 不带毫秒（2025-07-22T08:42:22Z）
        "yyyyMMdd'T'HHmmss.SSSXXXXX",      // 精简带毫秒
        "yyyyMMdd'T'HHmmssXXXXX",          // 精简不带毫秒
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",      // 旧格式兼容
        "yyyy-MM-dd'T'HH:mm:ssZ",          // 旧格式兼容
        "yyyy-MM-dd'T'HHmmssZ"             // 不带冒号时间
    ]
    /// 解析 ISO 8601 时间戳
    public static func parse(_ timestamp: String) -> Date? {
        // 遍历所有支持的格式
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: timestamp) {
                return date
            }
        }
        
        // 终极回退：尝试处理常见变体
        if let date = fallbackParse(timestamp) {
            return date
        }
        
        return nil
    }
    
    /// 统一格式化为标准 ISO 8601 字符串（带毫秒）
    public static func format(_ date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.string(from: date)
    }
    
    // 处理特殊变体的回退解析
    private static func fallbackParse(_ timestamp: String) -> Date? {
        var modified = timestamp
        
        // 处理缺少秒数的情况（2025-07-22T08:42Z → 2025-07-22T08:42:00Z）
        if timestamp.count == 17 && timestamp.hasSuffix("Z") {
            modified = timestamp.replacingOccurrences(of: "Z", with: ":00Z")
        }
        
        // 处理空格代替T的情况
        if timestamp.contains(" ") {
            modified = modified.replacingOccurrences(of: " ", with: "T")
        }
        
        // 尝试处理不带冒号的时间（2025-07-22T084222Z）
        if modified.contains("T") && modified.contains("Z") && !modified.contains(":") {
            let pattern = #"(\d{4}-\d{2}-\d{2}T)(\d{2})(\d{2})(\d{2})"#
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let range = NSRange(modified.startIndex..., in: modified)
                if let match = regex.firstMatch(in: modified, range: range),
                   let timeRange = Range(match.range(at: 2), in: modified),
                   let minuteRange = Range(match.range(at: 3), in: modified),
                   let secondRange = Range(match.range(at: 4), in: modified) {
                    
                    let hour = String(modified[timeRange])
                    let minute = String(modified[minuteRange])
                    let second = String(modified[secondRange])
                    
                    modified = modified.replacingCharacters(in: timeRange, with: "\(hour):\(minute):\(second)")
                }
            }
        }
        
        // 再次尝试所有格式
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: modified) {
                return date
            }
        }
        
        return nil
    }
}
