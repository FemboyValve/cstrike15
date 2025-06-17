cmake_minimum_required(VERSION 3.16)
project(libtier0_client)
set(SRCDIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "libtier0_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)

set(NOSTINKYLINKIES "1")
set(NOSKELETONBASE "1")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(vpc)

if( WINDOWS OR X360 )
    add_definitions(-DTIER0_DLL_EXPORT -DCROSS_PLATFORM_VERSION=1 -DTHREAD_MUTEX_TRACING_ENABLED)
elseif( POSIX OR PS3 )
    add_definitions(-DTIER0_DLL_EXPORT -DCROSS_PLATFORM_VERSION=1 -DPOSIX)
endif()
if( NOFPO )
    add_definitions(-DTIER0_FPO_DISABLED)
endif()

if( LINUXALL )
    target_compile_options(${OUTBINNAME} PRIVATE -shared -fPIC)
endif()

# stupid i know win32 version is called platform.cpp maybe rename?
vpc_file(tier0_src
    "platform.cpp" WIN32 
    "../unitlib/unitlib.cpp"
    "platform_posix.cpp" POSIX
    "cpu_posix.cpp" POSIX
    "assert_dialog.cpp"
    "commandline.cpp"
    "cpu.cpp"
    "cpumonitoring.cpp"
    "cputopology.cpp"
    "dbg.cpp"
    "fasttimer.cpp"
    "logging.cpp"
    "mem.cpp"
    "pme_posix.cpp" POSIX OR PS3
    "mem_helpers.cpp"
    "memdbg.cpp"
    "memvirt.cpp"
    "memstd.cpp"
    "memvalidate.cpp"
    "dynfunction.cpp"
    "minidump.cpp"
    "tier0_strtools.cpp"
    "miniprofiler.cpp"
    "perfstats.cpp"
    "platform_independent.cpp"
    "platwindow.cpp"
    "progressbar.cpp"
    "security.cpp"
    "stackstats.cpp"
    "stacktools.cpp"
    "systeminformation.cpp"
    "threadtools.cpp"
    "tslist.cpp"
    "vatoms.cpp"
    "vprof.cpp"
    "vtuneinterface.cpp"
    "win32consoleio.cpp"
	"../public/tier0/l2cache.h"
)

target_sources(${OUTBINNAME} PRIVATE ${tier0_src})

if( LINUXALL )
    #target_sources(${OUTBINNAME} PRIVATE "../tier1/pathmatch.cpp" )
endif()


#Linker
#-$ImpLib "$LIBPUBLIC\tier0"
#-$Lib	 "$LIBPUBLIC\tier1"
#-$implib "$LIBPUBLIC\vstdlib"
#-$Lib	 "$LIBPUBLIC\interfaces"
#
#$LibExternal	 "$SRCDIR\thirdparty\telemetry\lib\telemetry32.link" [$WIN32 && !$RAD_TELEMETRY_DISABLED]
#$LibExternal	 "$SRCDIR\thirdparty\telemetry\lib\telemetry64.link" [$WIN64 && !$RAD_TELEMETRY_DISABLED]
#$LibExternal	 "$SRCDIR/thirdparty/telemetry/lib/libtelemetryx86.link" [$LINUX32 && !$RAD_TELEMETRY_DISABLED]
#$LibExternal	 "$SRCDIR/thirdparty/telemetry/lib/libtelemetryx64.link" [$LINUX64 && !$RAD_TELEMETRY_DISABLED]

if( POSIX )
    target_link_libraries(${OUTBINNAME} dl pthread)
endif()