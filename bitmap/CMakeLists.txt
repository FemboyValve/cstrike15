cmake_minimum_required(VERSION 3.20)
project(bitmap) # TODO: bitmap_byteswap isnt included in this project yet!

# Add the vpc module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
include(vpc)

set(SRCDIR "${CMAKE_CURRENT_SOURCE_DIR}/..")

# Source files with platform conditions
vpc_file(SOURCE_FILES
    "bitmap.cpp"
    "ImageByteSwap.cpp" X360 OR PS3
    "colorconversion.cpp"
    "floatbitmap.cpp"
    "floatbitmap2.cpp"
    "floatbitmap3.cpp"
    "floatbitmap4.cpp" WIN32
    "floatbitmap_bilateralfilter.cpp"
    "floatcubemap.cpp"
    "imageformat.cpp"
    "psd.cpp"
    "psheet.cpp"
    "resample.cpp"
    "tgaloader.cpp"
    "texturepacker.cpp"
    "tgawriter.cpp"
)

# Header files
set(HEADER_FILES
    "${SRCDIR}/public/bitmap/bitmap.h"
    "${SRCDIR}/public/bitmap/floatbitmap.h"
    "${SRCDIR}/public/bitmap/imageformat.h"
    "${SRCDIR}/public/bitmap/imageformat_declarations.h"
    "${SRCDIR}/public/bitmap/psd.h"
    "${SRCDIR}/public/bitmap/psheet.h"
    "${SRCDIR}/public/bitmap/texturepacker.h"
    "${SRCDIR}/public/bitmap/tgaloader.h"
    "${SRCDIR}/public/bitmap/tgawriter.h"
    "${SRCDIR}/public/bitmap/stb_dxt.h"
)

add_library(bitmap STATIC ${SOURCE_FILES} ${HEADER_FILES})

# Include directories
if(WIN32)
    target_include_directories(bitmap PRIVATE "${SRCDIR}/dx9sdk/include")
endif()

if(WIN32 AND DEFINED XDKINSTALLED)
    target_include_directories(bitmap PRIVATE "$ENV{XEDK}/include/win32")
endif()

if(X360)
    target_include_directories(bitmap PRIVATE "$ENV{XEDK}/include/xbox")
endif()

# Link libraries
if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        target_link_libraries(bitmap PRIVATE "${SRCDIR}/lib/public/nvtc")
    else()
        target_link_libraries(bitmap PRIVATE "${SRCDIR}/lib/public/nvtc64")
    endif()
    target_link_libraries(bitmap PRIVATE bitmap_byteswap)
endif()
