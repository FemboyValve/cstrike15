# CS\:GO 2017 (Pre-Hydra Update)

This project is a modified version of **Counter-Strike: Global Offensive**, based on a build from before the Hydra update (2017).

---

## 🚧 Project Status

* **Active development**
* **Experimental features**
* **Expect bugs and incomplete functionality**

---

## 📋 Requirements

* **Microsoft Visual Studio 2015 (MSVC 2015)**
  Required to build the project.

  > *Support for newer toolchains and CMake is in progress.*

---

## 🛠 Setup Instructions (Windows)

1. **Fix VPC paths**
   Run `vpc_fix.reg` to add the necessary registry keys.

2. **Generate Visual Studio solution**
   Run `CreateSolution.bat` to generate the `.sln` file.

3. **Build the project**
   Open `csgo_partner.sln` in Visual Studio 2015 and build the solution.

4. **Download game assets** *(Windows only)*
   Use the following Steam CLI commands to download the required depots:

   ```bash
   download_depot 730 731 7043469183016184477
   download_depot 730 732 4047004309608881181
   ```

---

## ✅ TODO

* [ ] **Migrate** from VPC to **CMake**
* [ ] Replace Scaleform/HTML UI with **RML UI (Rocket)**
* [ ] Improve **project structure** and modularity
* [ ] Clean up **legacy code** and remove unused components

---

## 📌 Notes

* This version is not intended for public online play.
* The goal is to preserve and improve on a specific pre-Hydra snapshot of CS\:GO.
