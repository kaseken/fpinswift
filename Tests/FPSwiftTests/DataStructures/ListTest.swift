@testable import FPSwift
import Testing

@Test func testSum() throws {
    #expect(List<Int>.apply(1, 2, 3, 4).sum() == 10)
}

@Test func testProduct() throws {
    #expect(List<Double>.apply(1, 2, 3, 4).product() == 24)
    #expect(List<Double>.apply(1, 2, 3, 0).product() == 0)
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
