func fib(_ n: Int) -> Int {
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
