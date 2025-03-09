import Foundation

indirect enum Tree<A: Equatable>: Equatable {
    case Leaf(A)
    case Branch(left: Tree<A>, right: Tree<A>)

    var size: Int {
        switch self {
        case .Leaf: 1
        case let .Branch(l, r): 1 + l.size + r.size
        }
    }

    func fold<B>(_ f: (A) -> B, _ g: (B, B) -> B) -> B {
        switch self {
        case let .Leaf(x): f(x)
        case let .Branch(l, r): g(l.fold(f, g), r.fold(f, g))
        }
    }

    func map<B>(_ f: (A) -> B) -> Tree<B> {
        fold({ Tree<B>.Leaf(f($0)) }) { Tree<B>.Branch(left: $0, right: $1) }
    }
}

extension Tree<Int> {
    func firstPositive() -> Int? {
        fold({ (x: Int) in x > 0 ? x : nil }) { $0 ?? $1 }
    }

    // Exercise 3.25
    func maximum() -> Int {
        fold({ $0 }) { max($0, $1) }
    }

    // Exercise 3.26
    func depth() -> Int {
        fold({ _ in 0 }) { max($0, $1) + 1 }
    }
}
