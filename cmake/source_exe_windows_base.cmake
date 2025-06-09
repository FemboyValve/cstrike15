include("${CMAKE_MODULE_PATH}/common_functions.cmake")
include("${CMAKE_MODULE_PATH}/source_windows_base.cmake")

MacroRequired(SRCDIR)
MacroRequired(OUTBINNAME)
MacroRequired(OUTBINDIR)

set( IS_LIB_PROJECT "1")

add_definitions( -DEXENAME=${OUTBINNAME} )

add_executable(${OUTBINNAME})

set_target_properties(${OUTBINNAME} PROPERTIES OUTPUT_NAME "${OUTBINNAME}")
set_target_properties(${OUTBINNAME} PROPERTIES SUFFIX ".exe")
set_target_properties(${OUTBINNAME} PROPERTIES PREFIX "")

message("Adding executable target: ${OUTBINNAME}")

set_target_properties( ${OUTBINNAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${OUTBINDIR}"
        LIBRARY_OUTPUT_DIRECTORY "${OUTBINDIR}"
        RUNTIME_OUTPUT_DIRECTORY "${OUTBINDIR}"
        )

# Windows executable specific settings
if(MSVC)
    # Enable parallel compilation
    target_compile_options(${OUTBINNAME} PRIVATE /MP)
    
    # Set subsystem
    set_target_properties(${OUTBINNAME} PROPERTIES
        LINK_FLAGS "/SUBSYSTEM:CONSOLE /DEBUG /INCREMENTAL:NO"
    )
    
    if(WIN64)
        set_target_properties(${OUTBINNAME} PROPERTIES
            LINK_FLAGS "/SUBSYSTEM:CONSOLE /DEBUG /INCREMENTAL:NO /MACHINE:X64 COMPILER_MSVC64"
        )
    else()
        set_target_properties(${OUTBINNAME} PROPERTIES
            LINK_FLAGS "/SUBSYSTEM:CONSOLE /DEBUG /INCREMENTAL:NO /MACHINE:X86 COMPILER_MSVC32"
        )
    endif()
endif()

if( NOSKELETONBASE )
    message(STATUS "Not including Skeleton base.")
else()
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/memoverride.cpp")
endif()