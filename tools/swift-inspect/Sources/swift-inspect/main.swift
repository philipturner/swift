//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArgumentParser
import SwiftRemoteMirror


internal struct UniversalOptions: ParsableArguments {
  @Argument(help: "The pid or partial name of the target process")
  var nameOrPid: String
}

internal struct BacktraceOptions: ParsableArguments {
  @Flag(help: "Show the backtrace for each allocation")
  var backtrace: Bool = false

  @Flag(help: "Show a long-form backtrace for each allocation")
  var backtraceLong: Bool = false

  var style: BacktraceStyle? {
    if backtraceLong { return .long }
    if backtrace { return .oneline }
    return nil
  }
}


internal func inspect(process pattern: String,
                      _ body: (any RemoteProcess) throws -> Void) throws {
  guard let processId = process(matching: pattern) else {
    print("No process found matching \(pattern)")
    return
  }

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
  guard let process = DarwinRemoteProcess(processId: processId) else {
    print("Failed to create inspector for process id \(processId)")
    return
  }
#elseif os(Windows)
  guard let process = WindowsRemoteProcess(processId: processId) else {
    print("Failed to create inspector for process id \(processId)")
    return
  }
#else
#error("Unsupported platform")
#endif

  try body(process)
}

@main
internal struct SwiftInspect: ParsableCommand {
  // DumpArrays and DumpConcurrency cannot be reliably be ported outside of
  // Darwin due to the need to iterate the heap.
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
  static let subcommands: [ParsableCommand.Type] = [
    DumpConformanceCache.self,
    DumpRawMetadata.self,
    DumpGenericMetadata.self,
    DumpCacheNodes.self,
    DumpArrays.self,
    DumpConcurrency.self,
  ]
#else
  static let subcommands: [ParsableCommand.Type] = [
    DumpConformanceCache.self,
    DumpRawMetadata.self,
    DumpGenericMetadata.self,
    DumpCacheNodes.self,
  ]
#endif

  static let configuration = CommandConfiguration(
    abstract: "Swift runtime debug tool",
    subcommands: subcommands)
}
