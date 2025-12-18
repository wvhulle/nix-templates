# C++ Project

C++23 project with CMake build system.

## Creating a New Project

Initialize a new C++ project from this template:

```bash
mkdir my-cpp-project
cd my-cpp-project
nix flake init -t /home/wvhulle/.config/nixos#cpp
```

## Prerequisites

All tools are available globally through NixOS configuration:

## Getting Started

Automatically rebuild and run on file changes:

```bash
nu run.nu
```

Edit your source files - the project rebuilds automatically on save.

## Linting

Run clang-tidy manually to see detailed diagnostics:

```bash
# Single file
clang-tidy -p build main.cpp

# All source files
clang-tidy -p build *.cpp

# With detailed explanations
clang-tidy -p build --explain-config main.cpp

# Fix issues automatically (use with caution)
clang-tidy -p build --fix main.cpp
```

The `-p build` flag uses `compile_commands.json` for accurate analysis.
