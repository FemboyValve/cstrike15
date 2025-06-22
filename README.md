# CS\:OO (Counter Strike: Open Offensive)

This project is a modified version of **Counter-Strike: Global Offensive (2017) before Operation Hydra update**.

---

## 🚧 Project Status

* **Active development**
* **Experimental features**
* **Expect bugs and incomplete functionality**
* **Compiles with windows 10 sdk (10.0.22621.0) but currently the game crashes...**

---

## 📋 Requirements

### ✅ [Microsoft Visual Studio 2015 (MSVC 2015)](https://archive.org/details/vs2015.3.com_enu_202102)

This project requires **Visual Studio 2015 Update 3** to build.

> ⚠️ **Note:** Installing the **ATL/MFC components** is required for successful compilation.

#### 🛠️ How to install ATL/MFC:

1. Run the Visual Studio 2015 installer (`vs_community.exe` or similar).
2. Choose **"Modify"** if it's already installed, or **"Custom Install"** if installing for the first time.
3. In the **"Select features"** menu:

   * Expand **"Programming Languages" > "Visual C++"**
   * Check:

     * ✅ **Common Tools for Visual C++ 2015**
     * ✅ **Microsoft Foundation Classes for C++** (this includes MFC and ATL)
4. Complete the installation.

> 💡 *Support for newer compilers and CMake is planned for future updates.*

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

### **🛠️ Setup instructions (CMake Windows)**

> ⚠️ **Note:** CMake isn't complete yet; please use VPC for Windows.

This section outlines the prerequisites and steps for building the project using CMake on Windows.

#### **Prerequisites**

Ensure you have the following installed:

* [**Perl**](https://strawberryperl.com/)
* [**CMake**](https://cmake.org/)
* **Microsoft Visual Studio 2015 (MSVC 2015) Update 3**

    * **How to install ATL/MFC components for Visual Studio 2015:**
        1.  Run the Visual Studio 2015 installer (`vs_community.exe` or similar).
        2.  Choose "**Modify**" if Visual Studio is already installed, or "**Custom Install**" for a new installation.
        3.  In the "**Select features**" menu, expand "**Programming Languages**" > "**Visual C++**".
        4.  Check the following:
            * ✅ **Common Tools for Visual C++ 2015**
            * ✅ **Microsoft Foundation Classes for C++** (this includes MFC and ATL)
        5.  Complete the installation.

#### **Build Instructions**

*(Currently, specific CMake build instructions for Windows are not provided in the source. The project recommends using VPC for Windows setups at this time.)*

> 💡 *Support for newer compilers and CMake is planned for future updates.*

---

## 🛠️ Setup Instructions (Linux)

> ⚠️ **Note:** These instructions are incomplete. For best results, refer to **Kisak’s official setup guide**. This section provides a basic local build guide.

### Prerequisites

Make sure you have the required dependencies installed:

```bash
sudo apt update
sudo apt install git build-essential cmake libsdl2-mixer-dev libsdl2-dev libgoogle-perftools-dev libopenal-dev libcurlpp-dev libssl-dev libfontconfig1-dev libcurl4-openssl-dev net-tools protobuf-compiler
```

### Build Instructions

1. **Create a build directory** (if it doesn’t already exist):

```bash
mkdir -p cmake-build
cd cmake-build
```

2. **Generate build files with CMake**:

```bash
cmake ..
```

3. **Build the project**:

```bash
make
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

## 📚 Resources & Credits

This project makes use of valuable resources and reference code from the following repositories:

* [blackletum/csgo-src](https://github.com/blackletum/csgo-src)
* [SwagSoftware/Kisak-Strike](https://github.com/SwagSoftware/Kisak-Strike)

Many thanks to the authors of these repositories for their contributions to the community.
