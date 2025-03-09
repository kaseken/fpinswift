@testable import FPSwift
import Testing

struct OptionTest {
    @Test func map() {
        #expect(Option<Int>.Some(1).map { $0 * 2 } == .Some(2))
        #expect(Option<Int>.None.map { $0 * 2 } == .None)
    }

    @Test func flatMap() {
        #expect(Option<Int>.Some(1).flatMap { .Some($0 * 2) } == .Some(2))
        #expect(Option<Int>.None.flatMap { .Some($0 * 2) } == .None)
    }

    @Test func getOrElse() {
        #expect(Option<Int>.Some(1).getOrElse(2) == 1)
        #expect(Option<Int>.None.getOrElse(2) == 2)
    }

    @Test func orElse() {
        #expect(Option<Int>.Some(1).orElse(.Some(2)) == .Some(1))
        #expect(Option<Int>.None.orElse(.Some(2)) == .Some(2))
    }

    @Test func filter() {
        #expect(Option<Int>.Some(1).filter { $0 > 0 } == .Some(1))
        #expect(Option<Int>.Some(1).filter { $0 < 0 } == .None)
    }

    @Test func variance() {
        #expect([1.0, 2.0, 3.0, 4.0, 5.0].variance() == .Some(2.0))
        #expect([4.0, 4.0, 4.0, 4.0, 4.0].variance() == .Some(0))
        #expect([].variance() == .None)
    }

    @Test func map2() {
        let option1: Option<Int> = .Some(2)
        let option2: Option<Int> = .Some(3)
        #expect(FPSwift.map2(option1, option2) { $0 * $1 } == .Some(6))
        #expect(FPSwift.map2(option1, .None) { $0 * $1 } == .None)
        #expect(FPSwift.map2(.None, option2) { $0 * $1 } == .None)
    }

    @Test func sequence() {
        #expect(
            FPSwift.sequence(as: List<Option<Int>>.apply(
                Option<Int>.Some(1),
                Option<Int>.Some(2),
                Option<Int>.None
            )) == Option.None
        )
        #expect(
            FPSwift.sequence(as: List<Option<Int>>.apply(
                Option<Int>.Some(1),
                Option<Int>.Some(2),
                Option<Int>.Some(3)
            )) == Option.Some(List<Int>.apply(1, 2, 3))
        )
        #expect(FPSwift.sequence(as: List<Option<Int>>.Nil) == .Some(List.Nil))
    }

    @Test func traverse() {
        let toIntOption: (String) -> Option<Int> = {
            if let i = Int($0) { .Some(i) } else { .None }
        }
        #expect(
            FPSwift.traverse(List<String>.apply(
                "1",
                "2",
                "3"
            ), toIntOption) ==
                Option.Some(List<Int>.apply(1, 2, 3))
        )
        #expect(
            FPSwift.traverse(List<String>.apply(
                "1",
                "2",
                "HOGE"
            ), toIntOption) ==
                Option.None
        )
    }
}
