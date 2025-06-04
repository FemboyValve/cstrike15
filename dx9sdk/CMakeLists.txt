# dx9sdk/CMakeLists.txt
cmake_minimum_required(VERSION 3.15)

# Create an interface library for header + library exposure
add_library(dx9sdk INTERFACE)

# Public include directories
target_include_directories(dx9sdk INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Link directories (for static linking)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/lib)

# Link all the static libraries available in lib/
target_link_libraries(dx9sdk INTERFACE
    amstrmid
    d3d8
    d3d9
    d3dx
    d3dx8
    d3dx8d
    d3dx8dt
    d3dx9
    d3dx9d
    d3dx9dt
    d3dxd
    d3dxof
    ddraw
    dinput
    dinput8
    dmoguids
    dplayx
    dsetup
    dsound
    DxErr8
    DxErr9
    dxguid
    dxtrans
    encapi
    ksproxy
    ksuser
    msdmo
    quartz
    strmiids
    XInput
)
