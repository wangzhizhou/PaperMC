import Testing
import Common
import Foundation

@Test(arguments: [
    "https://fill-data.papermc.io/v1/objects/9457d1279efcc2094e818cacb2f17670d9479e5f6b4ea2517eb93a6a3face51f/paper-1.21.8-11.jar"
])
func downloadFile(url: String) async throws {
    let fileURL = try #require(URL(string: url))
    let (dataStream, fileSize) = try #require(await downloadFileWithBuffer(from: fileURL))
    var receivedBytes: Int64 = 0
    for await chunkResult in dataStream {
        switch chunkResult {
        case .success(let chunk):
            receivedBytes += Int64(chunk.count)
//            let progress = Double(receivedBytes) / Double(fileSize)
//            print("下载进度: \(Double(Int(progress * 10000)) / 100)%")
        case .failure(let error):
            throw error
        }
    }
    #expect(fileSize == receivedBytes)
}
