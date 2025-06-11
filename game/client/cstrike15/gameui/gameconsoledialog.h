#pragma once

#include "vgui_controls/consoledialog.h"
#include <color.h>
#include "utlvector.h"
#include "engineinterface.h"
#include "vgui_controls/Frame.h"


//-----------------------------------------------------------------------------
// Purpose: Game/dev console dialog
//-----------------------------------------------------------------------------
class CGameConsoleDialog : public vgui::CConsoleDialog
{
	DECLARE_CLASS_SIMPLE( CGameConsoleDialog, vgui::CConsoleDialog );

public:
	CGameConsoleDialog();

private:
	MESSAGE_FUNC( OnClosedByHittingTilde, "ClosedByHittingTilde" );
	MESSAGE_FUNC_CHARPTR( OnCommandSubmitted, "CommandSubmitted", command );

	virtual void OnKeyCodeTyped( vgui::KeyCode code );
	virtual void OnCommand( const char *command );
};