cmake_minimum_required(VERSION 3.20)

project(valve_avi)

# Define source directory
set(SRCDIR "${CMAKE_CURRENT_SOURCE_DIR}/..")
set(OUTBINDIR "${SRCDIR}/../game/bin")

# Platform flags
if(WIN32)
    add_definitions(-DQUICKTIME_WINDOWS)
endif()

# Source files
set(SOURCE_FILES)
if(WIN32)
    list(APPEND SOURCE_FILES
        avi.cpp
        bink.cpp
    )
endif()
if(APPLE)
    list(APPEND SOURCE_FILES avi_osx.cpp)
endif()
if(DEFINED QUICKTIME_VIDEO OR DEFINED QUICKTIME_WINDOWS)
    list(APPEND SOURCE_FILES quicktime.cpp)
endif()

# Header files (optional grouping, doesn't affect build)
set(HEADER_FILES
    avi.h
    quicktime.h
    ${SRCDIR}/public/pixelwriter.h
    ${SRCDIR}/public/avi/iavi.h
    ${SRCDIR}/public/avi/ibik.h
    ${SRCDIR}/public/avi/iquicktime.h
)

add_library(valve_avi STATIC ${SOURCE_FILES} ${HEADER_FILES})

# Include directories
if(WIN32)
    if(DEFINED QUICKTIME_WINDOWS)
        target_include_directories(valve_avi PRIVATE "${SRCDIR}/common/quicktime_win32")
    endif()
    target_include_directories(valve_avi PRIVATE "${SRCDIR}/dx9sdk/include")
endif()

if(UNIX AND NOT APPLE)
    target_include_directories(valve_avi PRIVATE
        "${SRCDIR}/thirdparty/sdl/include"
        "${SRCDIR}/thirdparty/sdl_mixer"
    )
endif()

# Link libraries
if(WIN32)
    target_link_libraries(valve_avi PRIVATE vfw32)
    target_link_directories(valve_avi PRIVATE "${SRCDIR}/dx9sdk/lib")
    if(DEFINED QUICKTIME_WINDOWS)
        target_link_libraries(valve_avi PRIVATE
            "${SRCDIR}/lib/common/quicktime/QTMLClient.lib"
            "${SRCDIR}/DX9SDK/lib/dsound.lib"
            "${SRCDIR}/DX9SDK/lib/dxguid.lib"
        )
    endif()
endif()

if(APPLE)
    target_link_libraries(valve_avi PRIVATE iconv)
    target_link_options(valve_avi PRIVATE "-framework Quicktime" "-framework Carbon")
endif()

if(UNIX AND NOT APPLE)
    target_link_libraries(valve_avi PRIVATE SDL2)
    target_link_directories(valve_avi PRIVATE "${SRCDIR}/thirdparty/sdl/build/.libs")
    target_link_options(valve_avi PRIVATE "-z" "muldefs")
endif()

# Link common Valve libraries
target_link_libraries(valve_avi PRIVATE tier2 tier3)