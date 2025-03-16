import Foundation

private final class LazyFunction<T> {
    private lazy var cachedResult: T = body()
    private let body: () -> T

    init(_ body: @escaping () -> T) {
        self.body = body
    }

    func callAsFunction() -> T { cachedResult }
}

indirect enum LazyList<A> {
    case Empty
    case Cons(h: () -> A, t: () -> LazyList<A>)
}

extension LazyList {
    private static func cons(
        _ hd: @escaping @autoclosure () -> A,
        _ tl: @escaping @autoclosure () -> LazyList<A>
    ) -> LazyList<A> {
        let lazyHd = LazyFunction(hd)
        let lazyTl = LazyFunction(tl)
        return .Cons(h: { lazyHd() }, t: { lazyTl() })
    }

    private static func empty() -> LazyList<A> {
        .Empty
    }

    static func apply(_ args: A...) -> LazyList<A> {
        apply(ArraySlice(args))
    }

    private static func apply(_ args: ArraySlice<A>) -> LazyList<A> {
        if args.isEmpty {
            empty()
        } else {
            cons(args.first!, apply(args.dropFirst()))
        }
    }

    // Exercise 5.2
    func take(_ n: Int) -> LazyList<A> {
        switch self {
        case .Empty: Self.empty()
        case let .Cons(h, t):
            if n <= 0 {
                Self.empty()
            } else {
                Self.cons(h(), t().take(n - 1))
            }
        }
    }

    // Exercise 5.2
    func drop(_ n: Int) -> LazyList<A> {
        switch self {
        case .Empty: Self.empty()
        case let .Cons(_, t):
            if n <= 0 {
                self
            } else {
                t().drop(n - 1)
            }
        }
    }

    // Exercise 5.3, Exersise 5.6
    func takeWhile(_ p: @escaping (A) -> Bool) -> LazyList<A> {
        foldRight(
            { Self.empty() },
            f: { a, b in p(a) ? Self.cons(a, b()) : Self.empty() }
        )
    }

    func exists(_ p: @escaping (A) -> Bool) -> Bool {
        foldRight({ false }, f: { a, b in p(a) || b() })
    }

    func foldRight<B>(
        _ acc: @escaping () -> B,
        f: @escaping (A, @escaping () -> B) -> B
    ) -> B {
        switch self {
        case .Empty: acc()
        case let .Cons(h, t): f(h()) { t().foldRight(acc, f: f) }
        }
    }

    // Exercise 5.4
    func forAll(_ p: @escaping (A) -> Bool) -> Bool {
        foldRight({ true }, f: { a, b in p(a) && b() })
    }

    // Exercise 5.7
    func headOption() -> A? {
        foldRight({ nil }, f: { a, _ in .some(a) })
    }

    func map<B>(_ f: @escaping (A) -> B) -> LazyList<B> {
        foldRight(
            { LazyList<B>.empty() },
            f: { a, b in LazyList<B>.cons(f(a), b()) }
        )
    }

    func filter(_ p: @escaping (A) -> Bool) -> LazyList<A> {
        foldRight(
            { LazyList<A>.empty() },
            f: { a, b in if p(a) { LazyList<A>.cons(a, b()) } else { b() } }
        )
    }

    func append(_ other: LazyList<A>) -> LazyList<A> {
        foldRight({ other }, f: { a, b in Self.cons(a, b()) })
    }

    func flatMap<B>(_ f: @escaping (A) -> LazyList<B>) -> LazyList<B> {
        foldRight({ LazyList<B>.empty() }, f: { a, b in f(a).append(b()) })
    }

    func find(_ p: @escaping (A) -> Bool) -> A? {
        filter(p).headOption()
    }

    // Exercise 5.8, 5.12
    static func continually(_ a: A) -> LazyList<A> {
        unfold(a) { a in .some((a, a)) }
    }

    static func unfold<S>(
        _ state: S,
        _ f: @escaping (S) -> (A, S)?
    ) -> LazyList<A> {
        if let (a, s) = f(state) {
            LazyList<A>.cons(a, unfold(s, f))
        } else {
            LazyList<A>.empty()
        }
    }

    func mapUnfold<B>(_ f: @escaping (A) -> (B)) -> LazyList<B> {
        LazyList<B>.unfold(self) { s in
            switch s {
            case let .Cons(h, t): .some((f(h()), t()))
            case .Empty: nil
            }
        }
    }

    func takeUnfold(_ n: Int) -> LazyList<A> {
        LazyList<A>.unfold((self, n)) { s in
            switch s {
            case let (.Cons(h, t), n):
                if n > 0 { .some((h(), (t(), n - 1))) } else { nil }
            case (.Empty, _): nil
            }
        }
    }

    func takeWhileUnfold(_ f: @escaping (A) -> Bool) -> LazyList<A> {
        LazyList<A>.unfold(self) { s in
            switch s {
            case let .Cons(h, t):
                if f(h()) { .some((h(), t())) } else { nil }
            case .Empty: nil
            }
        }
    }

    func zipWith<B>(_ that: LazyList<B>) -> LazyList<Pair<A, B>> {
        LazyList<Pair<A, B>>.unfold((self, that)) { s in
            switch s {
            case let (.Cons(h1, t1), .Cons(h2, t2)):
                .some((Pair(h1(), h2()), (t1(), t2())))
            default: nil
            }
        }
    }

    func zipAll<B>(_ that: LazyList<B>) -> LazyList<Pair<A?, B?>> {
        LazyList<Pair<A?, B?>>.unfold((self, that)) { s in
            switch s {
            case let (.Cons(h1, t1), .Cons(h2, t2)):
                .some((Pair(h1(), h2()), (t1(), t2())))
            case let (.Cons(h1, t1), _):
                .some((Pair(h1(), nil), (t1(), LazyList<B>.empty())))
            case let (_, .Cons(h2, t2)):
                .some((Pair(nil, h2()), (LazyList<A>.empty(), t2())))
            default: nil
            }
        }
    }

    // Exercises 5.15
    func tails() -> LazyList<LazyList<A>> {
        LazyList<LazyList<A>>.unfold(self) { (s: LazyList<A>?) in
            if let s {
                switch s {
                case .Empty: .some((s, nil))
                case let .Cons(_, t): .some((s, t()))
                }
            } else {
                nil
            }
        }
    }
}

extension LazyList<Int> {
    // Exercise 5.9, 5.12
    static func from(_ n: Int) -> LazyList<Int> {
        unfold(n) { s in .some((s, s + 1)) }
    }

    // Exercise 5.10, 5.12
    static func fibs() -> LazyList<Int> {
        unfold((0, 1)) { a, b in .some((a, (b, a + b))) }
    }
}

extension LazyList where A: Equatable {
    // Exercise 5.1
    func toList() -> List<A> {
        switch self {
        case .Empty: List<A>.Nil
        case let .Cons(h, t): List<A>.Cons(head: h(), tail: t().toList())
        }
    }

    // Exercises 5.14
    func startsWith(_ prefix: LazyList<A>) -> Bool {
        switch prefix {
        case .Empty: true
        case let .Cons(ph, pt):
            switch self {
            case .Empty: false
            case let .Cons(h, t): h() == ph() && t().startsWith(pt())
            }
        }
    }
}
