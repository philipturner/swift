
add_swift_host_library(swiftIDE STATIC
  CodeCompletion.cpp
  CodeCompletionCache.cpp
  CodeCompletionContext.cpp
  CodeCompletionConsumer.cpp
  CodeCompletionDiagnostics.cpp
  CodeCompletionResultBuilder.cpp
  CodeCompletionResultPrinter.cpp
  CodeCompletionResult.cpp
  CodeCompletionResultType.cpp
  CodeCompletionString.cpp
  CodeCompletionStringPrinter.cpp
  CommentConversion.cpp
  CompileInstance.cpp
  CompletionInstance.cpp
  CompletionLookup.cpp
  CompletionOverrideLookup.cpp
  ConformingMethodList.cpp
  DependencyChecking.cpp
  DotExprCompletion.cpp
  ExprContextAnalysis.cpp
  Formatting.cpp
  FuzzyStringMatcher.cpp
  Refactoring.cpp
  KeyPathCompletion.cpp
  ModuleInterfacePrinting.cpp
  REPLCodeCompletion.cpp
  SwiftSourceDocInfo.cpp
  SyntaxModel.cpp
  UnresolvedMemberCompletion.cpp
  Utils.cpp
  IDETypeChecking.cpp
  ImportDepth.cpp
  APIDigesterData.cpp
  SourceEntityWalker.cpp
  TypeContextInfo.cpp
  IDERequests.cpp
  )
target_link_libraries(swiftIDE PRIVATE
  swiftAST
  swiftClangImporter
  swiftDriver
  swiftFrontend
  swiftFrontendTool
  swiftIndex
  swiftParse
  swiftSema)

set_swift_llvm_is_available(swiftIDE)
