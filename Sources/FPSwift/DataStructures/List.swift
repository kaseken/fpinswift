import Foundation

// NOTE: Equatable for convenience of testing.
indirect enum List<A: Equatable>: Equatable {
    case Nil
    case Cons(head: A, tail: List<A>)

    static func apply<T>(_ args: T...) -> List<T> {
        apply(ArraySlice(args))
    }

    private static func apply<T>(_ args: ArraySlice<T>) -> List<T> {
        if let head = args.first {
            .Cons(head: head, tail: .apply(args.dropFirst()))
        } else {
            .Nil
        }
    }
}

extension List<Int> {
    func sumFoldRight() -> Int {
        foldRight(0) { $0 + $1 }
    }

    // Exercise 3.11
    func sumFoldLeft() -> Int {
        foldLeft(0) { $0 + $1 }
    }
}

extension List<Double> {
    func productFoldRight() -> Double {
        foldRight(1.0) { $0 * $1 }
    }

    // Exercise 3.11
    func productFoldLeft() -> Double {
        foldLeft(1.0) { $0 * $1 }
    }
}

extension List {
    // Exercise 3.2
    func tail() -> List? {
        return switch self {
        case .Nil: nil
        case let .Cons(_, tail): tail
        }
    }

    // Exercise 3.3
    func setHead(_ head: A) -> List<A> {
        switch self {
        case .Nil: .Nil
        case let .Cons(_, tail): .Cons(head: head, tail: tail)
        }
    }

    // Exercise 3.4
    func drop(_ n: Int) -> List<A> {
        if n > 0 {
            tail()?.drop(n - 1) ?? .Nil
        } else {
            self
        }
    }

    // Exercise 3.5
    func dropWhile(_ f: (A) -> Bool) -> List<A> {
        switch self {
        case .Nil: self
        case let .Cons(head, tail):
            if f(head) {
                tail.dropWhile(f)
            } else {
                self
            }
        }
    }

    func append(_ other: List<A>) -> List<A> {
        switch self {
        case .Nil: other
        case let .Cons(head, tail): .Cons(head: head, tail: tail.append(other))
        }
    }

    // Exercise 3.6
    func dropLast() -> List<A> {
        switch self {
        case .Nil: self
        case .Cons(_, .Nil): .Nil
        case let .Cons(head, tail): .Cons(head: head, tail: tail.dropLast())
        }
    }

    // Exercise 3.10
    func foldLeft<B>(_ acc: B, _ f: (B, A) -> B) -> B {
        switch self {
        case .Nil: acc
        case let .Cons(x, xs): xs.foldLeft(f(acc, x), f)
        }
    }

    // Exercise 3.13
    func foldRight<B>(_ acc: B, _ f: (A, B) -> B) -> B {
        reversed().foldLeft(acc) { b, a in f(a, b) }
    }

    var length: Int { lengthFoldLeft }

    // Exercise 3.9
    var lengthFoldRight: Int { foldRight(0) { $1 + 1 } }

    // Exercise 3.11
    var lengthFoldLeft: Int { foldLeft(0) { acc, _ in acc + 1 } }

    // Exercise 3.12
    func reversed() -> List<A> {
        foldLeft(List<A>.Nil) { List<A>.Cons(head: $1, tail: $0) }
    }

    // Exercise 3.14
    func appendFold(_ other: List<A>) -> List<A> {
        reversed().foldLeft(other) { List<A>.Cons(head: $1, tail: $0) }
    }

    // Exercise 3.16, 3.17, 3.18
    func map<B>(_ f: (A) -> B) -> List<B> {
        foldRight(List<B>.Nil) { List<B>.Cons(head: f($0), tail: $1) }
    }

    // Exercise 3.19
    func filter(_ f: (A) -> Bool) -> List<A> {
        foldRight(List<A>.Nil) { f($0) ? .Cons(head: $0, tail: $1) : $1 }
    }

    // Exercise 3.20
    func flatMap<B>(_ f: (A) -> List<B>) -> List<B> {
        foldRight(List<B>.Nil) { f($0).append($1) }
    }

    // Exercise 3.21
    func filterWithFlatMap(_ f: (A) -> Bool) -> List<A> {
        flatMap { (x: A) -> List<A> in f(x) ? .Cons(head: x, tail: .Nil) : .Nil }
    }

    // Exercise 3.22, 3.23
    func merge<B, C>(_ other: List<B>, _ f: (A, B) -> C) -> List<C> {
        switch (self, other) {
        case let (.Cons(h, t), .Cons(oh, ot)):
            List<C>.Cons(head: f(h, oh), tail: t.merge(ot, f))
        default:
            List<C>.Nil
        }
    }

    // Exercise 3.24
    func hasSubsequence(_ target: List<A>) -> Bool {
        func f(_ list: List<A>, _ subTarget: List<A>) -> Bool {
            switch (list, subTarget) {
            case let (.Cons(h, t), .Cons(sh, st)): h == sh ? f(t, st) : f(t, target)
            case (_, .Nil): true
            case (.Nil, .Cons): false
            }
        }
        return f(self, target)
    }
}

extension List {
    // Exercise 3.15
    static func concatenate(_ lists: List<List<A>>) -> List<A> {
        lists.foldLeft(List<A>.Nil) { $0.append($1) }
    }
}
