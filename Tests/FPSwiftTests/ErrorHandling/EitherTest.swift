@testable import FPSwift
import Testing

struct EitherTest {
    @Test func testMap() {
        typealias E = Either<String, Int>
        #expect(E.Right(2).map { $0 * 2 } == .Right(4))
        #expect(E.Left("Error").map { $0 * 2 } == .Left("Error"))
    }

    @Test func testFlatMap() {
        typealias E = Either<String, Int>
        #expect(E.Right(2).flatMap { .Right($0 * 2) } == .Right(4))
        #expect(E.Left("Error").flatMap { .Right($0 * 2) } == .Left("Error"))
    }

    @Test func testOrElse() {
        typealias E = Either<String, Int>
        #expect(E.Right(2).orElse(E.Right(3)) == .Right(2))
        #expect(E.Left("Error").orElse(E.Right(3)) == .Right(3))
        #expect(E.Left("Error").orElse(E.Left("Error2")) == .Left("Error2"))
    }

    @Test func testMap2() {
        typealias E = Either<String, Int>
        let f: (Int, Double) -> String = { String(Double($0) * $1) }
        #expect(E.Right(2).map2(.Right(2.5), f) == .Right("5.0"))
        #expect(E.Left("E1").map2(.Right(2.5), f) == .Left("E1"))
        #expect(E.Right(2).map2(.Left("E2"), f) == .Left("E2"))
        #expect(E.Left("E1").map2(.Left("E2"), f) == .Left("E1"))
    }

    @Test func testSequence() {
        typealias E = Either<String, Int>
        #expect(
            sequence(List<E>.apply(E.Right(1), E.Right(2), E.Right(3))) ==
                Either<String, List<Int>>.Right(List<Int>.apply(1, 2, 3))
        )
        #expect(
            sequence(List<E>.apply(E.Right(1), E.Left("Error"), E.Right(3))) ==
                Either<String, List<Int>>.Left("Error")
        )
    }

    @Test func testTraverse() {
        typealias E = Either<String, String>
        let f: (String) -> Either<String, Int> = { x in
            if let i = Int(x) { .Right(i) } else { .Left("Error_\(x)") }
        }
        #expect(
            traverse(List.apply("1", "2", "3"), f) ==
                Either<String, List<Int>>.Right(List<Int>.apply(1, 2, 3))
        )
        #expect(
            traverse(List.apply("1", "HOGE", "3"), f) ==
                Either<String, List<Int>>.Left("Error_HOGE")
        )
    }
}
