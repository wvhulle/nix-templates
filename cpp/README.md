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

- clang/clang++ (compiler)
- cmake (build system)
- clangd (LSP for editor integration)
- clang-format (auto-formatting)
- clang-tidy (linting)
- gdb (debugger)
- watchexec (file watcher)

## Getting Started

### Initial Setup

```bash
# Generate build files
cmake -B build -DCMAKE_CXX_COMPILER=clang++

# Build the project
cmake --build build
```

### Build and Run

```bash
# Using the convenience script
nu run.nu

# Or manually
cmake --build build && ./build/main
```

### Watch Mode

Automatically rebuild and run on file changes:

```bash
nu run.nu --watch
```

Edit your source files - the project rebuilds automatically on save.

## Project Structure

```
.
├── main.cpp              # Entry point
├── CMakeLists.txt        # Build configuration
├── compile_commands.json # LSP compilation database (generated)
├── build/                # Build artifacts (generated)
├── run.nu               # Convenience build/run script
├── .clang-tidy          # Linter configuration
└── flake.nix            # Project dependencies
```

## Development Workflow

1. **Edit** - Open files in Helix: `hx main.cpp`
   - Auto-formatting on save
   - Inline diagnostics from clangd + clang-tidy
   - Code completion and go-to-definition

2. **Build** - `cmake --build build`

3. **Run** - `./build/main`

4. **Debug** - `gdb ./build/main`

5. **Watch** - `nu run.nu --watch` for rapid iteration

## CMake Commands

```bash
# Configure (only needed once or after CMakeLists.txt changes)
cmake -B build -DCMAKE_CXX_COMPILER=clang++

# Build
cmake --build build

# Build specific target
cmake --build build --target main

# Clean and rebuild
rm -rf build && cmake -B build -DCMAKE_CXX_COMPILER=clang++ && cmake --build build
```

## Customization

### Adding Source Files

Edit `CMakeLists.txt`:

```cmake
add_executable(main
    main.cpp
    other.cpp
)
```

### Adding Dependencies

Edit `flake.nix` to add project-specific packages.

### Linter Configuration

Edit `.clang-tidy` to customize which checks run.

## Tips

- **Rebuild compile_commands.json** after CMakeLists.txt changes: `cmake -B build -DCMAKE_CXX_COMPILER=clang++`
- **Format manually** in Helix: `:format`
- **View diagnostics** in Helix: `:log-open` for detailed clangd output
