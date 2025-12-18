# C++ Clang with Nix project template

C++ project with:

- [C++ 2023](https://en.cppreference.com/w/cpp/23) language features.
- [CMake](https://cmake.org/) build system.
- [Helix](https://helix-editor.com/) editor configuration.
- [Direnv](https://direnv.net/) configuration (auto-activate environment)
- Useful CLI tools pre-installed via [Nix](https://nixos.org/)
- Long path substitution in build output using a symlink for readable compiler output.

Initialize a new C++ project from this template:

```bash
mkdir my-cpp-project
cd my-cpp-project
nix flake init -t github:wvhulle/nix-templates#cpp
```

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
