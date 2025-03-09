import Foundation

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
    func sum() -> Int {
        switch self {
        case .Nil: 0
        case let .Cons(head, tail): head + tail.sum()
        }
    }
}

extension List<Double> {
    func product() -> Double {
        switch self {
        case .Nil: 1.0
        case .Cons(0, _): 0.0
        case let .Cons(head, tail): head * tail.product()
        }
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
}
