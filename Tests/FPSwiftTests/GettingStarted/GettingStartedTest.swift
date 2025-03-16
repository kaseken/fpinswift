@testable import FPSwift
import Testing

struct GettingStartedTest {
    @Test func fib() async throws {
        #expect(GettingStarted.fib(1) == 0)
        #expect(GettingStarted.fib(2) == 1)
        #expect(GettingStarted.fib(3) == 2)
        #expect(GettingStarted.fib(4) == 3)
        #expect(GettingStarted.fib(5) == 5)
        #expect(GettingStarted.fib(6) == 8)
        #expect(GettingStarted.fib(7) == 13)
        #expect(GettingStarted.fib(8) == 21)
        #expect(GettingStarted.fib(9) == 34)
        #expect(GettingStarted.fib(10) == 55)
    }

    @Test func isSorted() async throws {
        #expect(GettingStarted.isSorted(arr: [Int](), gt: { $0 > $1 }))
        #expect(GettingStarted.isSorted(arr: [1], gt: { $0 > $1 }))
        #expect(GettingStarted.isSorted(arr: [1], gt: { $0 < $1 }))
        #expect(GettingStarted.isSorted(arr: [1, 2, 3], gt: { $0 > $1 }))
        #expect(!GettingStarted.isSorted(arr: [1, 2, 1], gt: { $0 > $1 }))
        #expect(GettingStarted.isSorted(arr: [3, 2, 1], gt: { $0 < $1 }))
        #expect(!GettingStarted.isSorted(arr: [1, 2, 3], gt: { $0 < $1 }))
    }

    @Test func testCurry() async throws {
        #expect(GettingStarted.curry(f: { $0 + $1 })(2)(3) == 5)
    }

    @Test func testUncurry() async throws {
        let f: (Int) -> (Int) -> Int = { a in { b in a + b } }
        #expect(GettingStarted.uncurry(f: f)(2, 3) == 5)
    }

    @Test func testCompose() async throws {
        #expect(
            GettingStarted.compose(
                f: { (b: Int) in String(b) },
                g: { (a: Int) in a * 2 }
            )(2) == "4"
        )
    }
}
