//===--- CollectionDifferentiation.swift ---------------------------*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2019 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//



import _Differentiation
import Darwin.C.tgmath
import Swift

var input = SIMD2<Float>(repeating: 7)

@differentiable(reverse)
func myFunc(input: inout SIMD2<Float>) {
  input = input / SIMD2<Float>(repeating: 3)
}

@differentiable(reverse)
func myFunc2(input: SIMD2<Float>) -> SIMD2<Float> {
  var inputCopy = input
  myFunc(input: &inputCopy)
  return inputCopy
}

let pb = pullback(at: input, of: myFunc2(input:))
print(pb(.one))
