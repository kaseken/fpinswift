@testable import FPSwift
import Testing

@Test func testCompose() async throws {
    #expect(
        compose(
            f: { (b: Int) in String(b) },
            g: { (a: Int) in a * 2 }
        )(2) == "4"
    )
}
