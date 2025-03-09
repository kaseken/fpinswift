@testable import FPSwift
import Testing

@Test func testSum() throws {
    #expect(List<Int>.apply(1, 2, 3, 4).sumFoldRight() == 10)
    #expect(List<Int>.apply(1, 2, 3, 4).sumFoldLeft() == 10)
}

@Test func testProduct() throws {
    #expect(List<Double>.apply(1, 2, 3, 4).productFoldRight() == 24)
    #expect(List<Double>.apply(1, 2, 3, 0).productFoldRight() == 0)
    #expect(List<Double>.apply(1, 2, 3, 4).productFoldLeft() == 24)
    #expect(List<Double>.apply(1, 2, 3, 0).productFoldLeft() == 0)
}

@Test func testTail() throws {
    #expect(List<Int>.Nil.tail() == nil)
    #expect(List<Int>.apply(1, 2, 3, 4).tail() == List<Int>.apply(2, 3, 4))
}

@Test func testSetHead() throws {
    #expect(List.Nil.setHead(1) == List.Nil)
    #expect(List<Int>.apply(1, 2, 3).setHead(5) == List<Int>.apply(5, 2, 3))
}

@Test func testDrop() throws {
    #expect(List<Int>.Nil.drop(3) == List.Nil)
    #expect(List<Int>.apply(1, 2, 3, 4, 5).drop(3) == List<Int>.apply(4, 5))
    #expect(List<Int>.apply(1, 2, 3, 4, 5).drop(5) == List.Nil)
    #expect(List<Int>.apply(1, 2, 3, 4, 5).drop(6) == List.Nil)
}

@Test func testDropWhile() throws {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    #expect(List<Int>.Nil.dropWhile(isEven) == .Nil)
    #expect(
        List<Int>.apply(2, 4, 6, 1, 3, 5).dropWhile(isEven) ==
            List<Int>.apply(1, 3, 5)
    )
    #expect(
        List<Int>.apply(1, 3, 5, 2, 4, 6).dropWhile(isEven) ==
            List<Int>.apply(1, 3, 5, 2, 4, 6)
    )
    #expect(List<Int>.apply(2, 4, 6).dropWhile(isEven) == .Nil)
}

@Test func testAppend() throws {
    #expect(
        List<Int>.apply(1, 2).append(List<Int>.apply(3, 4)) ==
            List<Int>.apply(1, 2, 3, 4)
    )
}

@Test func testDropLast() throws {
    #expect(List<Int>.apply(1, 2, 3, 4).dropLast() == List<Int>.apply(1, 2, 3))
    #expect(List<Int>.apply(1).dropLast() == List<Int>.Nil)
    #expect(List<Int>.Nil.dropLast() == List<Int>.Nil)
}

@Test func testFoldRight() {
    let list = List<Int>.apply(1, 2, 3)
    // Exercise 3.8
    #expect(list.foldRight(List<Int>.Nil) { List<Int>.Cons(head: $0, tail: $1) } == list)
}

@Test func testLength() {
    #expect(List<Int>.Nil.lengthFoldRight == 0)
    #expect(List<Int>.apply(1, 2, 3).lengthFoldRight == 3)
    #expect(List<Int>.apply(1, 2, 3, 4, 5, 6).lengthFoldRight == 6)
    #expect(List<Int>.Nil.lengthFoldLeft == 0)
    #expect(List<Int>.apply(1, 2, 3).lengthFoldLeft == 3)
    #expect(List<Int>.apply(1, 2, 3, 4, 5, 6).lengthFoldLeft == 6)
}

@Test func testReversed() async throws {
    #expect(List<Int>.apply(1, 2, 3).reversed() == List<Int>.apply(3, 2, 1))
}

@Test func testAppendFold() {
    #expect(
        List<Int>.apply(1, 2).appendFold(List<Int>.apply(3, 4, 5)) ==
            List<Int>.apply(1, 2, 3, 4, 5)
    )
}

@Test func testConcatenate() {
    let lists = List<List<Int>>.apply(
        List<Int>.apply(1, 2, 3, 4, 5),
        List<Int>.apply(6, 7, 8),
        List<Int>.apply(9, 10, 11, 12),
        List<Int>.apply(13),
        List<Int>.apply(14, 15)
    )
    #expect(
        List.concatenate(lists) ==
            List<Int>.apply(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    )
}

@Test func testMap() {
    #expect(List<Int>.apply(1, 2, 3).map { $0 + 1 } == List<Int>.apply(2, 3, 4))
    #expect(
        List<Double>.apply(1.5, 2.0, 3.5).map { String($0) } ==
            List<String>.apply("1.5", "2.0", "3.5")
    )
}

@Test func testFilter() {
    #expect(List<Int>.apply(1, 2, 3, 4, 5, 6).filter { $0 % 2 == 0 } == List<Int>.apply(2, 4, 6))
    #expect(List<Int>.apply(1, 2, 3, 4, 5, 6).filterWithFlatMap { $0 % 2 == 0 } ==
        List<Int>.apply(2, 4, 6))
}

@Test func testFlatMap() {
    #expect(List<Int>.apply(1, 2, 3).flatMap { i in List<Int>.apply(i, i) } ==
        List<Int>.apply(1, 1, 2, 2, 3, 3))
}

@Test func testMerge() {
    #expect(
        List<Int>.apply(1, 2, 3).merge(List<Int>.apply(4, 5, 6)) { $0 + $1 } ==
            List<Int>.apply(5, 7, 9)
    )
}

@Test func testHasSubsequence() {
    let list = List<Int>.apply(1, 2, 3, 4, 5)
    #expect(list.hasSubsequence(List<Int>.apply(1, 2, 3, 4, 5)))
    #expect(list.hasSubsequence(List<Int>.apply(1, 2, 3, 4)))
    #expect(list.hasSubsequence(List<Int>.apply(2, 3, 4, 5)))
    #expect(list.hasSubsequence(List<Int>.apply(3)))
    #expect(list.hasSubsequence(List<Int>.Nil))
    #expect(!list.hasSubsequence(List<Int>.apply(0)))
    #expect(!list.hasSubsequence(List<Int>.apply(1, 2, 3, 5)))
    #expect(!list.hasSubsequence(List<Int>.apply(3, 2, 1)))
}
