func isSorted<A>(arr: [A], gt: (A, A) -> Bool) -> Bool {
    func f(i: Int) -> Bool {
        if i + 1 >= arr.count {
            true
        } else {
            gt(arr[i + 1], arr[i]) && f(i: i + 1)
        }
    }
    return f(i: 0)
}
