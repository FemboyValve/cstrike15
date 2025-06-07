# LATSUBDIR is used to locate where it should look in the lib folder

if(WIN32 AND NOT WIN64)
    set(PLATSUBDIR "/win32")
endif()
if(WIN64)
    set(PLATSUBDIR "/win64") # Currently doesnt exist
endif()
if(X360)
    set(PLATSUBDIR ".")
endif()
if(LINUX32)
    set(PLATSUBDIR "/linux32") # Linux 32-bit will never be supported i think.
endif()
if(LINUX64)
    set(PLATSUBDIR "/linux64")
endif()
if(OSX32)
    set(PLATSUBDIR "/osx32")
endif()
if(OSX64)
    set(PLATSUBDIR "/osx64")
endif()

if( NOT DEFINED PLATSUBDIR )
    message(FATAL_ERROR "platform not found!")
endif()