import _Differentiation

extension Double {
  func addingThree(_ lhs: Self, _ mhs: Self, _ rhs: Self) -> Self {
    self + lhs + rhs
  }
  
  @derivative(of: addingThree)
  func _vjpAddingThree(
    _ lhs: Self,
    _ mhs: Self,
    _ rhs: Self
  ) -> (value: Self, pullback: (Self) -> (Self, Self, Self, Self)) {
    return (addingThree(lhs, mhs, rhs), { v in (v, lhs, mhs, rhs) })
  }
  
  mutating func addThree(_ lhs: Self, _ mhs: Self, _ rhs: Self) {
    self += lhs + mhs + rhs
  }
  
  @derivative(of: addThree)
  mutating func _vjpAddThree(
    _ lhs: Self,
    _ mhs: Self,
    _ rhs: Self
  ) -> (value: Void, pullback: (inout Self) -> (Self, Self, Self)) {
    addThree(lhs, mhs, rhs)
    return ((), { v in (lhs, mhs, rhs) })
  }
}

@differentiable(reverse)
func altAddingThree(_ x: Double, _ y: Double, _ z: Double, _ w: Double) -> Double {
  var output = x
  output.addThree(y, z, w)
  return output
}

assert((2, 3, 4) == gradient(at: 2, 3, 4, of: { 10.addingThree($0, $1, $2) }))

// fails
assert((2, 3, 4) == gradient(at: 2, 3, 4, of: { altAddingThree(10, $0, $1, $2) }))
