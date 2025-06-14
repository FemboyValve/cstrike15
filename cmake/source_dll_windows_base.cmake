include("${CMAKE_MODULE_PATH}/common_functions.cmake")
include("${CMAKE_MODULE_PATH}/source_windows_base.cmake")

MacroRequired(OUTBINNAME)
MacroRequired(OUTBINDIR)

if(WIN64)
    set(OUTBINDIR "${OUTBINDIR}${PLATSUBDIR}")
endif()

#set(ConfigurationType "Dynamic Library (.dll)") #not used

#Target
add_library(${OUTBINNAME} SHARED)

#		$GameOutputFile					"$OUTBINDIR/$OUTBINNAME$OUTDLLEXT"
#		$OutputFile					"$(OBJ_DIR)/$OUTBINNAME$OUTDLLEXT"
set_target_properties(${OUTBINNAME} PROPERTIES OUTPUT_NAME "${OUTBINNAME}")
set_target_properties(${OUTBINNAME} PROPERTIES SUFFIX "${OUTDLLEXT}")
set_target_properties(${OUTBINNAME} PROPERTIES PREFIX "")

target_compile_definitions(${OUTBINNAME} PRIVATE -DDLLNAME=${OUTBINNAME})

message("Adding dll target: ${OUTBINNAME}${OUTDLLEXT}")

set_target_properties( ${OUTBINNAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${OUTBINDIR}"
        LIBRARY_OUTPUT_DIRECTORY "${OUTBINDIR}"
        RUNTIME_OUTPUT_DIRECTORY "${OUTBINDIR}"
        )

# Windows DLL specific settings
if(MSVC)
    # Generate import library
    set_target_properties(${OUTBINNAME} PROPERTIES 
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
    )
    
    # Set linker flags for DLL
    set_target_properties(${OUTBINNAME} PROPERTIES
        LINK_FLAGS "/DEBUG /INCREMENTAL:NO"
    )
endif()

if( NOSKELETONBASE )
    message(STATUS "Not including Skeleton base.")
else()
    # Skeleton Project - All derived projects get this as a starting base
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/tier0/memoverride.cpp")
endif()