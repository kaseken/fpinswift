@testable import FPSwift
import Testing

@Test func testIsSorted() async throws {
    #expect(isSorted(arr: [Int](), gt: { $0 > $1 }))
    #expect(isSorted(arr: [1], gt: { $0 > $1 }))
    #expect(isSorted(arr: [1], gt: { $0 < $1 }))
    #expect(isSorted(arr: [1, 2, 3], gt: { $0 > $1 }))
    #expect(!isSorted(arr: [1, 2, 1], gt: { $0 > $1 }))
    #expect(isSorted(arr: [3, 2, 1], gt: { $0 < $1 }))
    #expect(!isSorted(arr: [1, 2, 3], gt: { $0 < $1 }))
}
