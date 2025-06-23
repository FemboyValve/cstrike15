#//-----------------------------------------------------------------------------
#//	MATERIALSYSTEM.VPC
#//
#//	Project Script
#//-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)
project(materialsystem_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "materialsystem_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)

set(SHADERAPIDX9DIR "shaderapidx9")
set(SHADERLIBDIR "shaderlib")
set(STDSHADERSDIR "stdshaders")

add_definitions(-DDEFINE_MATERIALSYSTEM_INTERFACE -DMATERIALSYSTEM_EXPORTS -DPROTECTED_THINGS_ENABLE -DINCLUDE_SCALEFORM)
add_definitions(-DVERSION_SAFE_STEAM_API_INTERFACES)

if( GL )
    add_definitions(-DGL_GLEXT_PROTOTYPES -DDX_TO_GL_ABSTRACTION)
endif()
if( NOT POSIX )
    #"$BASE;strncpy=use_Q_strncpy_instead;_snprintf=use_Q_snprintf_instead" [!$POSIX]
endif()
add_definitions(-DALLOW_TEXT_MODE=1)

vpc_file(materialsystem_src
    "CColorCorrection.cpp"
    "cmaterial.cpp"
    "cmaterial_queuefriendly.cpp"
    "CMaterialSubRect.cpp"
    "cmaterialvar.cpp"
    "cmatnullrendercontext.cpp"
    "colorspace.cpp"
    "ctexture.cpp"
    "${SRCDIR}/public/filesystem_helpers.cpp"
    "imagepacker.cpp"
)

target_sources(${OUTBINNAME} PRIVATE ${materialsystem_src})

target_sources(${OUTBINNAME} PRIVATE "mat_stub.cpp")
target_sources(${OUTBINNAME} PRIVATE "materialsystem_global.cpp")
target_sources(${OUTBINNAME} PRIVATE "morph.cpp")
target_sources(${OUTBINNAME} PRIVATE "SubdMgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "occlusionquerymgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "shadersystem.cpp")
target_sources(${OUTBINNAME} PRIVATE "texturemanager.cpp")
target_sources(${OUTBINNAME} PRIVATE "composite_texture.cpp")
target_sources(${OUTBINNAME} PRIVATE "custom_material.cpp")
target_sources(${OUTBINNAME} PRIVATE "base_visuals_data_processor.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmaterialdict.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmaterialsystem.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmatlightmaps.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmatpaintmaps.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmatrendercontext.cpp")
target_sources(${OUTBINNAME} PRIVATE "cmatqueuedrendercontext.cpp")

target_link_libraries(${OUTBINNAME} vtf_client bitmap_client mathlib_client shaderlib_client tier2_client tier3_client  libvstdlib_client)

#if building as dll..
#$Implib togl [!$IS_LIB_PROJECT && $GL && !$DEDICATED]