indirect enum List<A> {
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
