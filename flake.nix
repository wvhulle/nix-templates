{
  description = "Nix project templates";

  outputs = _: {
    templates.cpp = {
      path = ./cpp;
      description = "C++ project with CMake and C++23";
    };

    templates.default = {
      path = ./cpp;
      description = "C++ project with CMake and C++23";
    };
  };
}
