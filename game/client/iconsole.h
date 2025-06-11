#pragma once

#include <vgui/vgui.h>

namespace vgui
{
	class Panel;
}

abstract_class IConsole
{
public:
	virtual void		Create( vgui::VPANEL parent ) = 0;
	virtual void		Destroy( void ) = 0;
};

extern IConsole *console;