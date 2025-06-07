if( GL AND NOT OSX32 )
    set(SDL "1")
elseif( WINDOWS )
    # Windows uses DirectX by default, but can also use 
    # Doesnt source engine always use SDL?
    if( GL )
        set(SDL "1")
    endif()
endif()

if( OSXALL )

elseif( (WINDOWS AND NOT QUICKTIME_WINDOWS ) OR X360 OR PS3 )

elseif( WINDOWS AND QUICKTIME_WINDOWS )

endif()

if( GL )
    add_definitions(-DGL_GLEXT_PROTOTYPES -DDX_TO_GL_ABSTRACTION)
elseif( WINDOWS )
    # DirectX definitions for Windows
    #add_definitions(-DDIRECTX) # we dont know what windows needs yet...
endif()

if( SDL )
    add_definitions(-DUSE_SDL)
    include_directories("${SRCDIR}/thirdparty/SDL2")
endif()