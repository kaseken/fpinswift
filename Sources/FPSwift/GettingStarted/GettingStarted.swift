import Foundation

enum GettingStarted {
    // Exercise 2.1
    static func fib(_ n: Int) -> Int {
        func f(x: Int, a: Int, b: Int) -> Int {
            if x == n {
                a + b
            } else {
                f(x: x + 1, a: b, b: a + b)
            }
        }
        return if n <= 1 {
            0
        } else {
            f(x: 2, a: 0, b: 1)
        }
    }

    // Exercise 2.2
    static func isSorted<A>(arr: [A], gt: (A, A) -> Bool) -> Bool {
        func f(i: Int) -> Bool {
            if i + 1 >= arr.count {
                true
            } else if gt(arr[i], arr[i + 1]) {
                false
            } else {
                f(i: i + 1)
            }
        }
        return f(i: 0)
    }

    // Exercise 2.3
    static func curry<A, B, C>(f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
        { (a: A) in { (b: B) in f(a, b) } }
    }

    // Exercise 2.4
    static func uncurry<A, B, C>(f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
        { (a: A, b: B) in f(a)(b) }
    }

    // Exercise 2.5
    static func compose<A, B, C>(
        f: @escaping (B) -> C,
        g: @escaping (A) -> B
    ) -> (A) -> C {
        { a in f(g(a)) }
    }
}
