cmake_minimum_required(VERSION 3.20)

project(cstrike15)

#telling cmake that we want 32bit
set(CMAKE_C_FLAGS "-m32")
set(CMAKE_CXX_FLAGS "-m32")
set(CMAKE_EXE_LINKER_FLAGS "-m32")

if(WIN32)
add_subdirectory(dx9sdk)
endif()

