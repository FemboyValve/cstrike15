cmake_minimum_required(VERSION 3.20)

project(bonesetup)

# Define source directory
set(SRCDIR "${CMAKE_CURRENT_SOURCE_DIR}/..")

# Include directories
include_directories("${SRCDIR}/public")

# Source files
set(SOURCE_FILES)

vpc_file(SOURCE_FILES
    "bone_setup_PS3.cpp" PS3
    "bone_ik_PS3.cpp" PS3
    "bone_utils_PS3.cpp" PS3
    "bone_decode_PS3.cpp" PS3
    "bone_setup.cpp"
    "bone_ik.cpp"
    "bone_utils.cpp"
    "bone_decode.cpp"
    "bone_constraints.cpp"
)

# Header files (optional grouping)
set(HEADER_FILES
    bone_utils.h
)
if(PS3)
    list(APPEND HEADER_FILES bone_utils_PS3.h)
endif()

# Public headers (optional grouping)
set(PUBLIC_HEADERS)
if(WIN32 OR UNIX)
    list(APPEND PUBLIC_HEADERS "${SRCDIR}/public/bone_setup.h")
endif()
if(PS3)
    list(APPEND PUBLIC_HEADERS "${SRCDIR}/public/bone_setup_PS3.h")
endif()

add_library(bonesetup STATIC ${SOURCE_FILES} ${HEADER_FILES} ${PUBLIC_HEADERS})