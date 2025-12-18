cmake_minimum_required(VERSION 3.20)

project(project-name CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

add_compile_options(-fdiagnostics-color=always)

# Use symlinked include paths for shorter diagnostic messages
# The symlink directory is created by flake.nix shellHook and exported as NIX_SYMLINK_DIR
if(DEFINED ENV{NIX_SYMLINK_DIR})
  set(NIX_SYMLINK_DIR "$ENV{NIX_SYMLINK_DIR}" CACHE PATH "Directory with symlinks to Nix store includes")
else()
  set(NIX_SYMLINK_DIR "" CACHE PATH "Directory with symlinks to Nix store includes")
endif()
if(NIX_SYMLINK_DIR AND EXISTS "${NIX_SYMLINK_DIR}")
  message(STATUS "Using symlinked C++ stdlib from ${NIX_SYMLINK_DIR}")
  # Platform-specific dir must come first for bits/c++config.h
  add_compile_options(
    -nostdinc++
    -isystem${NIX_SYMLINK_DIR}/x86_64-unknown-linux-gnu
    -isystem${NIX_SYMLINK_DIR}
  )
endif()

add_executable(main main.cpp)
