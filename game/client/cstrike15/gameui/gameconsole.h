#pragma once

#include "GameUI/IGameConsole.h"

class CGameConsoleDialog;

//-----------------------------------------------------------------------------
// Purpose: VGui implementation of the game/dev console
//-----------------------------------------------------------------------------
class CGameConsole : public IGameConsole
{
public:
	CGameConsole();
	~CGameConsole();

	// sets up the console for use
	void Initialize();

	// activates the console, makes it visible and brings it to the foreground
	virtual void Activate();
	// hides the console
	virtual void Hide();
	// clears the console
	virtual void Clear();

	void HideImmediately( void );

	// returns true if the console is currently in focus
	virtual bool IsConsoleVisible();

	// activates the console after a delay
	void ActivateDelayed(float time);

	void SetParent( int parent );

	// hides and deletes panel
	void Shutdown( void );

	static void OnCmdCondump();
private:

	bool m_bInitialized;
	CGameConsoleDialog *m_pConsole;
};

extern CGameConsole &GameConsole();
