@testable import FPSwift
import Testing

@Test func testSum() throws {
    #expect(List<Int>.apply(1, 2, 3, 4).sum() == 10)
}

@Test func testProduct() throws {
    #expect(List<Double>.apply(1, 2, 3, 4).product() == 24)
    #expect(List<Double>.apply(1, 2, 3, 0).product() == 0)
}
