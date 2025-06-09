include("${CMAKE_MODULE_PATH}/common_functions.cmake")

########source_lowest_base########
if(STATIC_LINK)
    add_definitions(-DBASE -DSTATIC_LINK)
endif()
##################################

MacroRequired(SRCDIR)
MacroRequired(_DLL_EXT)

set(LIBPUBLIC "${SRCDIR}/lib/public${PLATSUBDIR}") #this is where static libs are
link_directories(${LIBPUBLIC}) #add to search path for linker
set(LIBCOMMON "${SRCDIR}/lib/common${PLATSUBDIR}")
set(DEVTOOLS "${SRCDIR}/devtools")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
    message(STATUS "Build type not specified")
endif(NOT CMAKE_BUILD_TYPE)

#$Configuration "Debug"
if (CMAKE_BUILD_TYPE EQUAL "DEBUG")
    message(STATUS "Building in Debug mode")
    add_definitions(-DBASE -DDEBUG -D_DEBUG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Od /Zi /MDd")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Od /Zi /MDd")
#$Configuration "Release"
else()
    message(STATUS "Building in Release mode")
    add_definitions(-DBASE -DNDEBUG)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O2 /Zi /MD")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O2 /Zi /MD")
endif()

#$Compiler
include_directories("${SRCDIR}/common")
include_directories("${SRCDIR}/public")
include_directories("${SRCDIR}/public/tier0")
include_directories("${SRCDIR}/public/tier1")
add_definitions(-DCOMPILER_MSVC -DMEMOVERRIDE_MODULE=${PROJECT_NAME} -D_DLL_EXT=${_DLL_EXT})

if(DEDICATED)
    add_definitions(-DDEDICATED)
endif()

# Windows specific definitions
add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS)
add_definitions(-DWIN32_LEAN_AND_MEAN)

if(WIN64)
    add_definitions(-DPLATFORM_64BITS)
endif()

# Set up MSVC specific flags
if(MSVC)
    # Enable multi-processor compilation
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP")
    
    # Disable specific warnings
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4100 /wd4127 /wd4201 /wd4244 /wd4505 /wd4611")
    
    # Set warning level
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3")
    
    # Enable function-level linking
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Gy")
    
    # Set runtime library
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDebugDLL")
    else()
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
    endif()
endif()

if(NOT IS_LIB_PROJECT)
    #set(ConfigurationType "Application (.exe)") #not used

    #$Linker
    if(WIN64)
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MACHINE:X64")
    else()
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MACHINE:X86")
    endif()
    
    # Common linker flags
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG /INCREMENTAL:NO")
    
    #$Folder	"Link Libraries"
    if( NOSTINKYLINKIES )
        message(STATUS "skipping stinky linkie")
    else()
        link_libraries("libtier0_client")
        link_libraries("tier1_client")
        link_libraries("interfaces_client")
        # Windows system libraries
        link_libraries("kernel32" "user32" "gdi32" "winspool" "comdlg32" "advapi32" "shell32" 
                      "ole32" "oleaut32" "uuid" "odbc32" "odbccp32" "ws2_32")
    endif()
endif()
