import Foundation
public func downloadFileWithBuffer(from url: URL, bufferSize: Int = 512 * 1024) async throws -> (stream: AsyncStream<Result<Data, Error>>, size: Int64) {
    let (bytes, response) = try await URLSession.shared.bytes(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200
    else {
        throw URLError(.badServerResponse)
    }
    
    guard let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length").flatMap(Int64.init)
    else {
        throw URLError(.cannotParseResponse)
    }
    
    let stream = AsyncStream(Result<Data, Error>.self) { continuation in
        Task {
            var buffer = Data(capacity: bufferSize)
            do {
                for try await byte in bytes {
                    buffer.append(byte)
                    if buffer.count >= bufferSize {
                        continuation.yield(.success(buffer))
                        buffer.removeAll(keepingCapacity: true)
                    }
                }
                // 发送剩余数据
                if !buffer.isEmpty {
                    continuation.yield(.success(buffer))
                }
                continuation.finish()
            } catch {
                continuation.yield(.failure(error))
                continuation.finish()
            }
        }
    }
    
    return (stream, contentLength)
}
