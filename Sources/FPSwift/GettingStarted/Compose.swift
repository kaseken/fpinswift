// Exercise 2.5
func compose<A, B, C>(
    f: @escaping (B) -> C,
    g: @escaping (A) -> B
) -> (A) -> C {
    { a in f(g(a)) }
}
