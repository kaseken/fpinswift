import Foundation

// NOTE: Equatable for convenience of testing.
enum Option<A: Equatable>: Equatable {
    case Some(A)
    case None

    // Exercise 4.1
    func map<B>(_ f: (A) -> B) -> Option<B> {
        switch self {
        case let .Some(x): .Some(f(x))
        case .None: .None
        }
    }

    // Exercise 4.1
    func getOrElse(_ default: @autoclosure () -> A) -> A {
        switch self {
        case let .Some(x): x
        case .None: `default`()
        }
    }

    // Exercise 4.1
    func flatMap<B>(_ f: (A) -> Option<B>) -> Option<B> {
        map(f).getOrElse(.None)
    }

    // Exercise 4.1
    func orElse(_ ob: @autoclosure () -> Option<A>) -> Option<A> {
        map { Option<A>.Some($0) }.getOrElse(ob())
    }

    // Exercise 4.1
    func filter(_ f: (A) -> Bool) -> Option<A> {
        flatMap { (a: A) in f(a) ? .Some(a) : .None }
    }
}

// Exercise 4.3
func map2<A, B, C>(
    _ a: Option<A>,
    _ b: Option<B>,
    _ f: (A, B) -> C
) -> Option<C> {
    a.flatMap { (a: A) in b.map { (b: B) in f(a, b) } }
}

extension [Double] {
    private func mean() -> Option<Double> {
        isEmpty ? .None : .Some(reduce(0, +) / Double(count))
    }

    // Exercise 4.2
    func variance() -> Option<Double> {
        mean().map { mean in
            map { x in (x - mean) * (x - mean) }.reduce(0, +) / Double(count)
        }
    }
}

// Exercise 4.4
func sequence<A>(as: List<Option<A>>) -> Option<List<A>> {
    `as`.foldRight(Option.Some(List<A>.Nil)) { (a: Option<A>, acc: Option<List<A>>) in
        acc.flatMap { (acc: List<A>) in
            a.map { (a: A) in List<A>.Cons(head: a, tail: acc) }
        }
    }
}

// Exercise 4.5
func traverse<A, B>(
    _ as: List<A>,
    _ f: @escaping (A) -> Option<B>
) -> Option<List<B>> {
    `as`.foldRight(Option.Some(List<B>.Nil)) { (a: A, acc: Option<List<B>>) in
        acc.flatMap { (acc: List<B>) in
            f(a).map { (b: B) in List<B>.Cons(head: b, tail: acc) }
        }
    }
}
