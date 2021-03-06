// RUN: %target-build-swift -parse-as-library -sanitize=fuzzer %s -o %t
// RUN: not %t -only_ascii=1 -max_len=3 | %FileCheck %s
// CHECK: Crash!
// REQUIRES: CPU=x86_64
// REQUIRES: executable_test
// REQUIRES: fuzzer_runtime
// XFAIL: OS=ios
// XFAIL: OS=tvos
// XFAIL: OS=watchos

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  import Darwin
#elseif os(Linux) || os(FreeBSD) || os(OpenBSD) || os(PS4) || os(Android) || os(Cygwin) || os(Haiku)
  import Glibc
#elseif os(Windows)
  import MSVCRT
#else
#error("Unsupported platform")
#endif

@_cdecl("LLVMFuzzerTestOneInput") public func fuzzOneInput(Data: UnsafePointer<CChar>, Size: CLong) -> CInt {
  if (Size >= 3) {
    if (Data[0] == 65) {
      if (Data[1] == 66) {
        if (Data[2] == 67) {
          fputs("Crash!", stdout);
          fflush(stdout);
          exit(1);
        }
      }
    }
  }
  return 0;
}
