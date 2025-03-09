@testable import FPSwift
import Testing

@Test func testUncurry() async throws {
    let f: (Int) -> (Int) -> Int = { a in { b in a + b } }
    #expect(uncurry(f: f)(2, 3) == 5)
}
