@testable import FPSwift
import Testing

@Test func testCurry() async throws {
    #expect(curry(f: { $0 + $1 })(2)(3) == 5)
}
