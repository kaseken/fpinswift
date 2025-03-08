func curry<A, B, C>(f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { (a: A) in { (b: B) in f(a, b) } }
}
