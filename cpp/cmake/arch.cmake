# 🛡️ ARCHITECTURE DETECTION: Rely on CMake's built-in variables for robustness.
# 'EMSCRIPTEN' is automatically set by the emscripten toolchain file.
if(EMSCRIPTEN OR CMAKE_SYSTEM_NAME MATCHES "Emscripten")
    # 🚀 WASM OPTIMIZATION
    # Disable SLP vectorization on WASM as it causes massive compile-time regressions.
    # (As noted: scalar_multiplication.cpp compile time explodes without this).
    # -fno-exceptions: Standard for high-perf WASM/Crypto to reduce code size and overhead.
    add_compile_options(-fno-exceptions -fno-slp-vectorize)

else()
    # 🖥️ NATIVE OPTIMIZATION (Linux/macOS/Windows)
    
    # Check if we are specifically on x86_64 architecture.
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|amd64|AMD64")
        
        # 🍎 APPLE SILICON / INTEL MAC HANDLING
        # Apple's Clang usually handles architecture selection well via CMAKE_OSX_ARCHITECTURES.
        # We explicitly avoid overriding flags on Apple unless necessary to prevent conflicts.
        if(NOT APPLE)
            # 🛡️ PORTABILITY FIX: Changed '-march=skylake' to '-march=native'.
            # '-march=native': Tells the compiler to use all instructions available on THIS machine 
            # (AVX2, BMI2, ADX, etc.). It works on both Intel and AMD.
            #
            # NOTE: If building Docker images for distribution, consider using '-march=x86-64-v3' 
            # instead of 'native' to ensure binaries work on diverse servers.
            add_compile_options(-march=native)
        endif()
        
    endif()
    
    # Note: No explicit 'else' needed for ARM (M1/M2/M3 etc.) as '-march=native' 
    # is implied or handled by the compiler defaults on those platforms usually, 
    # or CMAKE_OSX_ARCHITECTURES handles it for macOS.
endif()
