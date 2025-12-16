#!/usr/bin/env nu

# Build and run the C++ project

def main [
  --watch (-w) # Watch for changes and rebuild
] {
  if $watch {
    print "Watching for changes..."
    watchexec --clear --restart --exts cpp,hpp -- nu run.nu
  } else {
    print "Building..."
    cmake --build build

    if ($env.LAST_EXIT_CODE == 0) {
      print "\nRunning:"
      ./build/main
    } else {
      print "Build failed!"
      exit 1
    }
  }
}
