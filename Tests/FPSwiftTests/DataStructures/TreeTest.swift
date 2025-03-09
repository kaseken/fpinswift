@testable import FPSwift
import Testing

@Test func testSize() {
    let tree = Tree.Branch(
        left: Tree.Branch(left: .Leaf("A"), right: .Leaf("B")),
        right: Tree.Branch(left: .Leaf("C"), right: .Leaf("D"))
    )
    #expect(tree.size == 7)
}

@Test func testFirstPositive() {
    let tree = Tree.Branch(
        left: Tree.Branch(left: .Leaf(-1), right: .Leaf(-4)),
        right: Tree.Branch(left: .Leaf(1), right: .Leaf(2))
    )
    #expect(tree.firstPositive() == 1)
}

@Test func testMaximum() {
    let tree = Tree.Branch(
        left: Tree.Branch(left: .Leaf(-1), right: .Leaf(-4)),
        right: Tree.Branch(left: .Leaf(1), right: .Leaf(2))
    )
    #expect(tree.maximum() == 2)
}

@Test func testDepth() {
    #expect(Tree.Leaf(1).depth() == 0)
    #expect(Tree.Branch(left: .Leaf(1), right: .Leaf(2)).depth() == 1)
    let tree2 = Tree.Branch(
        left: Tree.Branch(left: .Leaf(-1), right: .Leaf(-4)),
        right: Tree.Branch(left: .Leaf(1), right: .Leaf(2))
    )
    #expect(tree2.depth() == 2)
    let tree3 = Tree.Branch(
        left: Tree.Branch(left: .Leaf(-1), right: .Leaf(-4)),
        right: Tree.Branch(
            left: Tree.Branch(left: .Leaf(1), right: .Leaf(3)),
            right: .Leaf(2)
        )
    )
    #expect(tree3.depth() == 3)
}

@Test func testTreeMap() async throws {
    let tree = Tree.Branch(
        left: Tree.Branch(left: .Leaf(-1), right: .Leaf(-4)),
        right: Tree.Branch(left: .Leaf(1), right: .Leaf(2))
    )
    #expect(tree.map { String($0 * 2) } == Tree.Branch(
        left: Tree.Branch(left: .Leaf("-2"), right: .Leaf("-8")),
        right: Tree.Branch(left: .Leaf("2"), right: .Leaf("4"))
    ))
}
