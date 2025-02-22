// RUN: %target-typecheck-verify-swift
// RUN: not %target-swift-frontend -typecheck -debug-generic-signatures -requirement-machine-inferred-signatures=verify %s 2>&1 | %FileCheck %s

public protocol P {
  associatedtype A : Q where A.B == Self
}

public protocol Q {
  associatedtype B
}

// This is rejected, because 'A.B == Self' means that 'Self' must
// exactly equal C; since C is not final, this means the conformance
// is not covariant.
public class C : P {
// expected-warning@-1 {{non-final class 'C' cannot safely conform to protocol 'P', which requires that 'Self' is exactly equal to 'Self.A.B'; this is an error in Swift 6}}
  public typealias A = D
}

public class D : Q {
  public typealias B = C
}

// Both <T : P & C> and <T : C & P> minimize to <T where T == C>:
// - T : P and T : C imply that T.A == C.A == D;
// - T : P also implies that T.A.B == T, via A.B == Self in P;
// - Since T.A == D, T.A.B == D.B, therefore Self == D.B.
// - D.B is a typealias for C, so really Self == C.

// CHECK-LABEL: Generic signature: <T where T == C>
public func takesBoth1<T : P & C>(_: T) {}
// expected-warning@-1 {{redundant conformance constraint 'T' : 'P'}}
// expected-note@-2 {{conformance constraint 'T' : 'P' implied here}}
// expected-error@-3 {{same-type requirement makes generic parameter 'T' non-generic}}

// CHECK-LABEL: Generic signature: <U where U == C>
public func takesBoth2<U : C & P>(_: U) {}
// expected-warning@-1 {{redundant conformance constraint 'U' : 'P'}}
// expected-note@-2 {{conformance constraint 'U' : 'P' implied here}}
// expected-error@-3 {{same-type requirement makes generic parameter 'U' non-generic}}
