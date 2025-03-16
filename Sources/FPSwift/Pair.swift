import Foundation

struct Pair<A: Equatable, B: Equatable>: Equatable {
    let a: A
    let b: B

    init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}
