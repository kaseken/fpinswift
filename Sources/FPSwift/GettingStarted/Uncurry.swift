// Exercise 2.4
func uncurry<A, B, C>(f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
    { (a: A, b: B) in f(a)(b) }
}
