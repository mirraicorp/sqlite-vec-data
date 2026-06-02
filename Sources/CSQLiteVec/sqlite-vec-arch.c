// Disable SQLITE_VEC_ENABLE_NEON for translation units being compiled for a
// non-NEON architecture, even when the package's cSettings enabled it for
// the platform. SwiftPM's cSettings .when() can scope a define by platform
// but not by architecture, so the slice-level gate has to live at the
// C-preprocessor layer where __ARM_NEON / __aarch64__ are defined per
// translation unit. Without this, x86_64 Apple builds (Intel macOS, Intel
// iOS Simulator, Xcode Cloud's x86_64 test hosts) pull in <arm_neon.h> and
// fail with "Module '_Builtin_intrinsics.arm.neon' requires feature 'neon'".
//
// Scoped narrowly: only undefines when NEON is requested AND the arch can't
// support it, leaving every other combination — including future ones —
// untouched.

#if defined(SQLITE_VEC_ENABLE_NEON) && \
    !(defined(__ARM_NEON) || defined(__aarch64__) || defined(__arm__))
#undef SQLITE_VEC_ENABLE_NEON
#endif

#include "sqlite-vec.c"
