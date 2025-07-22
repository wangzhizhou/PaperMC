import Testing
import Common

@Test(arguments: [
    "2025-07-22T08:54:27.185Z",  // 标准带毫秒
    "2025-07-22T08:42:22Z",      // 标准不带毫秒
    "20250722T084222Z",          // 精简不带毫秒
    "2025-07-22T08:42:22+00:00", // 带时区偏移
//    "2025-07-22T084222Z",        // 不带冒号的时间
    "2025-07-22 08:42:22Z",      // 空格代替T
    "2025-07-22T08:42Z",         // 缺少秒数
    "2025-07-22T08:42:22.1Z",    // 1位毫秒
    "2025-07-22T08:42:22.12Z",   // 2位毫秒
    "2025-07-22T08:42:22.12345Z" // 多位毫秒
])
func testTimestampParser(timestamp: String) async throws {
    _ = try #require(TimestampParser.parse(timestamp))
}
