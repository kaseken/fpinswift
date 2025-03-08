func isSorted<A>(arr: [A], gt: (A, A) -> Bool) -> Bool {
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
