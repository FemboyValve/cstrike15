# CS\:GO 2017 (Pre-Hydra Update)

This is a modified version of CS\:GO from before the Hydra update (2017). The project is currently in an early state and under active development.

## Requirements

* **Microsoft Visual Studio 2015 (MSVC 2015)** – Required for building the project.
  *Note: Support for newer toolchains and CMake is in progress.*

## Setup Instructions (Windows)

1. **Fix VPC paths**
   Run `vpc_fix.reg` to configure required registry keys.

2. **Generate Visual Studio solution**
   Run `CreateSolution.bat` to generate the solution files for Visual Studio 2015.

3. **Open and Build**
   Open the generated `csgo_partner.sln` file with Visual Studio and build the project.

## TODO

* [ ] Migrate build system from VPC to CMake
* [ ] Replace Scaleform/HTML UI with **RML UI (Rocket)**
* [ ] Improve project structure and modularization
* [ ] Clean up legacy code and remove unused components