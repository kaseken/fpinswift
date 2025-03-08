@testable import FPSwift
import Testing

@Test func testFib() async throws {
    #expect(fib(1) == 0)
    #expect(fib(2) == 1)
    #expect(fib(3) == 2)
    #expect(fib(4) == 3)
    #expect(fib(5) == 5)
    #expect(fib(6) == 8)
    #expect(fib(7) == 13)
    #expect(fib(8) == 21)
    #expect(fib(9) == 34)
    #expect(fib(10) == 55)
}
