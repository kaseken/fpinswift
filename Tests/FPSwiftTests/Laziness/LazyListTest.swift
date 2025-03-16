@testable import FPSwift
import Testing

struct LazyTestList {
    @Test func toList() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).toList() ==
            List.apply(1, 2, 3, 4, 5))
    }

    @Test func take() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).take(0).toList() ==
            List.Nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).take(2).toList() ==
            List.apply(1, 2))
        #expect(LazyList.apply(1, 2, 3, 4, 5).take(5).toList() ==
            List.apply(1, 2, 3, 4, 5))
        #expect(LazyList.apply(1, 2, 3, 4, 5).take(6).toList() ==
            List.apply(1, 2, 3, 4, 5))
    }

    @Test func drop() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).drop(0).toList() ==
            List.apply(1, 2, 3, 4, 5))
        #expect(LazyList.apply(1, 2, 3, 4, 5).drop(2).toList() ==
            List.apply(3, 4, 5))
        #expect(LazyList.apply(1, 2, 3, 4, 5).drop(5).toList() ==
            List.Nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).drop(6).toList() ==
            List.Nil)
    }

    @Test func testWhile() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhile { $0 < 4 }.toList() ==
            List.apply(1, 2, 3))
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhile { $0 < 1 }.toList() ==
            List.Nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhile { $0 < 6 }.toList() ==
            List.apply(1, 2, 3, 4, 5))
    }

    @Test func exists() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).exists { $0 == 1 })
        #expect(LazyList.apply(1, 2, 3, 4, 5).exists { $0 == 5 })
        #expect(!LazyList.apply(1, 2, 3, 4, 5).exists { $0 == 6 })
    }

    @Test func forAll() {
        #expect(LazyList.Empty.forAll { $0 < 6 })
        #expect(LazyList.apply(1, 2, 3, 4, 5).forAll { $0 < 6 })
        #expect(!LazyList.apply(1, 2, 3, 4, 5).forAll { $0 < 5 })
    }

    @Test func headOption() {
        #expect(LazyList<Int>.Empty.headOption() == nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).headOption() == 1)
    }

    @Test func map() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).map { $0 * 2 }.toList() ==
            List.apply(2, 4, 6, 8, 10))
    }

    @Test func filter() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).filter { $0 % 2 == 1 }.toList() ==
            List.apply(1, 3, 5))
    }

    @Test func append() {
        #expect(LazyList.apply(1, 2, 3).append(LazyList.apply(4, 5, 6)).toList() ==
            List.apply(1, 2, 3, 4, 5, 6))
    }

    @Test func flatMap() {
        #expect(
            LazyList.apply(1, 2, 3).flatMap { a in LazyList.apply(a * 2, a * 3) }.toList() ==
                List.apply(2, 3, 4, 6, 6, 9)
        )
    }

    @Test func traceMapAndFilter() {
        var calls: [String] = []
        let lazyList = LazyList.apply(1, 2, 3, 4).map {
            calls.append("map \($0)")
            return $0 + 10
        }.filter {
            calls.append("filter \($0)")
            return $0 % 2 == 0
        }
        #expect(calls == ["map 1", "filter 11", "map 2", "filter 12"])
        #expect(lazyList.toList() == List.apply(12, 14))
        #expect(calls == [
            "map 1", "filter 11", "map 2", "filter 12",
            "map 3", "filter 13", "map 4", "filter 14",
        ])
    }

    @Test func find() {
        var calls: [String] = []
        let result = LazyList.apply(1, 2, 3, 4, 5).find {
            calls.append("find \($0)")
            return $0 >= 3
        }
        #expect(calls == ["find 1", "find 2", "find 3"])
        #expect(result == 3)
    }

    @Test func continually() {
        #expect(LazyList.continually(1).take(5).toList() == List.apply(1, 1, 1, 1, 1))
    }

    @Test func from() {
        #expect(LazyList<Int>.from(3).take(5).toList() == List.apply(3, 4, 5, 6, 7))
        #expect(LazyList<Int>.from(3).drop(2).take(5).toList() == List.apply(5, 6, 7, 8, 9))
    }

    @Test func fibs() {
        #expect(LazyList<Int>.fibs().take(1).toList() == List.apply(0))
        #expect(LazyList<Int>.fibs().take(2).toList() == List.apply(0, 1))
        #expect(LazyList<Int>.fibs().take(10).toList() ==
            List.apply(0, 1, 1, 2, 3, 5, 8, 13, 21, 34))
    }

    @Test func mapUnfold() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).mapUnfold { $0 * 2 }.toList() ==
            List.apply(2, 4, 6, 8, 10))
    }

    @Test func takeUnfold() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeUnfold(0).toList() ==
            List.Nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeUnfold(2).toList() ==
            List.apply(1, 2))
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeUnfold(5).toList() ==
            List.apply(1, 2, 3, 4, 5))
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeUnfold(6).toList() ==
            List.apply(1, 2, 3, 4, 5))
    }

    @Test func takeWhileUnfold() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhileUnfold { $0 < 4 }.toList() ==
            List.apply(1, 2, 3))
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhileUnfold { $0 < 1 }.toList() ==
            List.Nil)
        #expect(LazyList.apply(1, 2, 3, 4, 5).takeWhileUnfold { $0 < 6 }.toList() ==
            List.apply(1, 2, 3, 4, 5))
    }

    @Test func zipWith() {
        #expect(
            LazyList.apply(1, 2, 3).zipWith(LazyList.apply(4, 5, 6, 7)).toList() ==
                List.apply(Pair(1, 4), Pair(2, 5), Pair(3, 6))
        )
    }

    @Test func zipAll() {
        #expect(
            LazyList.apply(1, 2, 3).zipAll(LazyList.apply(4, 5, 6, 7)).toList() ==
                List<Pair<Int?, Int?>>.apply(Pair(1, 4), Pair(2, 5), Pair(3, 6), Pair(nil, 7))
        )
        #expect(
            LazyList.apply(1, 2, 3, 4).zipAll(LazyList.apply(5)).toList() ==
                List<Pair<Int?, Int?>>.apply(Pair(1, 5), Pair(2, nil), Pair(3, nil), Pair(4, nil))
        )
    }

    @Test func startsWith() {
        #expect(LazyList.apply(1, 2, 3, 4, 5).startsWith(LazyList.apply(1, 2, 3)))
        #expect(LazyList.apply(1, 2, 3, 4, 5).startsWith(LazyList.apply(1, 2, 3, 4, 5)))
        #expect(LazyList.apply(1, 2, 3, 4, 5).startsWith(LazyList.Empty))
        #expect(!LazyList.apply(1, 2, 3, 4, 5).startsWith(LazyList.apply(1, 2, 3, 4, 5, 6)))
        #expect(!LazyList.apply(1, 2, 3, 4, 5).startsWith(LazyList.apply(1, 2, 3, 5)))
        #expect(!LazyList.Empty.startsWith(LazyList.apply(1, 2, 3)))
        #expect(LazyList<Int>.Empty.startsWith(LazyList.Empty))
    }

    @Test func tails() {
        #expect(
            LazyList.apply(1, 2, 3).tails().map { $0.toList() }.toList() ==
                List.apply(
                    List.apply(1, 2, 3),
                    List.apply(2, 3),
                    List.apply(3),
                    List.Nil
                )
        )
    }
}
