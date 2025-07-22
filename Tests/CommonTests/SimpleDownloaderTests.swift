import Testing
import Common
import Foundation

@Test(arguments: [
    "https://fill-data.papermc.io/v1/objects/9457d1279efcc2094e818cacb2f17670d9479e5f6b4ea2517eb93a6a3face51f/paper-1.21.8-11.jar"
])
func downloadFile(url: String) async throws {
    let fileURL = try #require(URL(string: url))
    let (dataStream, fileSize) = try #require(await downloadFileWithBuffer(from: fileURL))
    print("开始下载，文件大小: \(fileSize) 字节")
    var receivedBytes: Int64 = 0
    for await chunkResult in dataStream {
        switch chunkResult {
        case .success(let chunk):
            receivedBytes += Int64(chunk.count)
            let progress = Double(receivedBytes) / Double(fileSize)
            print("下载进度: \(Double(Int(progress * 10000)) / 100)%")
        case .failure(let error):
            throw error
        }
    }
    print("下载完成")
    #expect(fileSize == receivedBytes)
}
