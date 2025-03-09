import Foundation

// NOTE: Equatable for convenience of testing.
enum Either<E: Equatable, A: Equatable>: Equatable {
    case Left(E)
    case Right(A)

    // Exercise 4.6
    func map<B>(_ f: (A) -> B) -> Either<E, B> {
        switch self {
        case let .Left(e): .Left(e)
        case let .Right(a): .Right(f(a))
        }
    }

    // Exercise 4.6
    func flatMap<B>(_ f: (A) -> Either<E, B>) -> Either<E, B> {
        switch self {
        case let .Left(e): .Left(e)
        case let .Right(a): f(a)
        }
    }

    // Exercise 4.6
    func orElse(_ b: @autoclosure () -> Either<E, A>) -> Either<E, A> {
        switch self {
        case .Left: b()
        case .Right: self
        }
    }

    // Exercise 4.6
    func map2<B, C>(_ that: Either<E, B>, _ f: (A, B) -> C) -> Either<E, C> {
        switch (self, that) {
        case let (.Right(a), .Right(b)): .Right(f(a, b))
        case let (.Left(e), _): .Left(e)
        case let (_, .Left(e)): .Left(e)
        }
    }
}

// Exercise 4.7
func sequence<E, A>(_ as: List<Either<E, A>>) -> Either<E, List<A>> {
    `as`.foldRight(Either<E, List<A>>.Right(.Nil)) { a, acc in
        acc.map2(a) { acc, a in List<A>.Cons(head: a, tail: acc) }
    }
}

// Exercise 4.7
func traverse<E, A, B>(
    _ as: List<A>,
    _ f: (A) -> Either<E, B>
) -> Either<E, List<B>> {
    `as`.foldRight(Either<E, List<B>>.Right(.Nil)) { a, acc in
        acc.map2(f(a)) { acc, b in List<B>.Cons(head: b, tail: acc) }
    }
}
