#!/usr/bin/env nu

# Build and run the C++ project

def check-dependencies []: nothing -> nothing {
  let missing = [cmake watchexec]
    | where (which $it | is-empty)

  if ($missing | is-not-empty) {
    let deps = $missing | str join ", "
    error make {
      msg: $"Missing dependencies: ($deps)"
      help: "Run 'nix develop' or 'direnv allow' to load the development environment"
    }
  }
}

def ensure-build-dir []: nothing -> nothing {
  if not ("build" | path exists) {
    print -e "Build directory not found. Running initial CMake configuration..."
    cmake -B build
    if $env.LAST_EXIT_CODE != 0 {
      error make {
        msg: "CMake configuration failed"
        help: "Check CMakeLists.txt or compiler configuration"
      }
    }
  }
}

def main [
  --once (-o) # Build and run once, then exit (default: watch mode)
]: nothing -> nothing {
  check-dependencies

  if $once {
    ensure-build-dir

    print -e "Building..."
    cmake --build build

    if $env.LAST_EXIT_CODE == 0 {
      print -e "\nRunning:"
      ./build/main
    } else {
      error make {
        msg: "Build failed"
        help: "Check compiler errors above"
      }
    }
  } else {
    print -e "Watching for changes (Ctrl+C to stop)..."
    watchexec --clear --restart --exts cpp,hpp,txt -- nu run.nu --once
  }
}
