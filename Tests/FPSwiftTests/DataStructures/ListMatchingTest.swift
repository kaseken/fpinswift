@testable import FPSwift
import Testing

@Test func testListMatching() throws {
    let result = switch List<Int>.apply(1, 2, 3, 4, 5) {
    case let .Cons(x, .Cons(2, .Cons(4, _))): x
    case .Nil: 42
    case let .Cons(x, .Cons(y, .Cons(3, .Cons(4, _)))): x + y
    case let .Cons(h, t): h + t.sum()
    }
    #expect(result == 1 + 2)
}
