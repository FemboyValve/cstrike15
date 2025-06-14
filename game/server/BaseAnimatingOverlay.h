#pragma once

#include "networkvar.h"
#include "datamap.h"
#include "shared_classnames.h"

class CBaseAnimatingOverlay;
class IBoneSetup;

class CAnimationLayer : public CMemZeroOnNew
{
public:	
	DECLARE_CLASS_NOBASE( CAnimationLayer );
	
	CAnimationLayer( void );
	void	Init( CBaseAnimatingOverlay *pOverlay );

	// float	SetBlending( int iBlender, float flValue, CBaseAnimating *pOwner );
	void	StudioFrameAdvance( float flInterval, CBaseAnimating *pOwner );
	void	DispatchAnimEvents( CBaseAnimating *eventHandler, CBaseAnimating *pOwner );
	void	SetOrder( int nOrder );

	float GetFadeout( float flCurTime );

	// For CNetworkVars.
	void NetworkStateChanged();
	void NetworkStateChanged( void *pVar );

public:	

#define ANIM_LAYER_ACTIVE		0x0001
#define ANIM_LAYER_AUTOKILL		0x0002
#define ANIM_LAYER_KILLME		0x0004
#define ANIM_LAYER_DONTRESTORE	0x0008
#define ANIM_LAYER_CHECKACCESS	0x0010
#define ANIM_LAYER_DYING		0x0020
#define ANIM_LAYER_NOEVENTS		0x0040

	int		m_fFlags;

	bool	m_bSequenceFinished;
	bool	m_bLooping;
	
	CNetworkVar( int, m_nSequence );
	CNetworkVar( float, m_flCycle );
	CNetworkVar( float, m_flPlaybackRate );
	CNetworkVar( float, m_flPrevCycle );
	CNetworkVar( float, m_flWeight );
	CNetworkVar( float, m_flWeightDeltaRate );

	float	m_flBlendIn; // start and end blend frac (0.0 for now blend)
	float	m_flBlendOut; 

	float	m_flKillRate;
	float	m_flKillDelay;

	float	m_flLayerAnimtime;
	float	m_flLayerFadeOuttime;

	// dispatch flags
	CStudioHdr *m_pDispatchedStudioHdr;
	int		m_nDispatchedSrc;
	int		m_nDispatchedDst;

	// For checking for duplicates
	Activity	m_nActivity;

	// order of layering on client
	int		m_nPriority;
	CNetworkVar( int, m_nOrder );
	int		GetOrder( void ) { return m_nOrder; }

	bool	IsActive( void ) { return ((m_fFlags & ANIM_LAYER_ACTIVE) != 0); }
	bool	IsAutokill( void ) { return ((m_fFlags & ANIM_LAYER_AUTOKILL) != 0); }
	bool	IsKillMe( void ) { return ((m_fFlags & ANIM_LAYER_KILLME) != 0); }
	bool	IsAutoramp( void ) { return (m_flBlendIn != 0.0 || m_flBlendOut != 0.0); }
	void	KillMe( void ) { m_fFlags |= ANIM_LAYER_KILLME; }
	void	Dying( void ) { m_fFlags |= ANIM_LAYER_DYING; }
	bool	IsDying( void ) { return ((m_fFlags & ANIM_LAYER_DYING) != 0); }
	void	Dead( void ) { m_fFlags &= ~ANIM_LAYER_DYING; }
	bool	NoEvents( void ) { return ((m_fFlags & ANIM_LAYER_NOEVENTS) != 0); }

	void	SetSequence( int nSequence );
	void	SetCycle( float flCycle );
	void	SetPrevCycle( float flCycle );
	void	SetPlaybackRate( float flPlaybackRate );
	void	SetWeight( float flWeight );
	void	SetWeightDeltaRate( float flDelta );

	int		GetSequence( ) const;
	float	GetCycle( ) const;
	float	GetPrevCycle( ) const;
	float	GetPlaybackRate( ) const;
	float	GetWeight( ) const;
	float	GetWeightDeltaRate( ) const;

	bool	IsAbandoned( void );
	void	MarkActive( void );

	float	m_flLastEventCheck;

	float	m_flLastAccess;

	// Network state changes get forwarded here.
	CBaseAnimatingOverlay *m_pOwnerEntity;
	
	DECLARE_SIMPLE_DATADESC();
};

inline float CAnimationLayer::GetFadeout( float flCurTime )
{
	float s;

	if (m_flLayerFadeOuttime <= 0.0f)
	{
		s = 0;
	}
	else
	{
		// blend in over 0.2 seconds
		s = 1.0 - (flCurTime - m_flLayerAnimtime) / m_flLayerFadeOuttime;
		if (s > 0 && s <= 1.0)
		{
			// do a nice spline curve
			s = 3 * s * s - 2 * s * s * s;
		}
		else if ( s > 1.0f )
		{
			// Shouldn't happen, but maybe curtime is behind animtime?
			s = 1.0f;
		}
	}
	return s;
}

FORCEINLINE void CAnimationLayer::SetSequence( int nSequence )
{
	m_nSequence = nSequence;
}

FORCEINLINE void CAnimationLayer::SetCycle( float flCycle )
{
	m_flCycle = flCycle;
}

FORCEINLINE void CAnimationLayer::SetWeight( float flWeight )
{
	m_flWeight = flWeight;
}

FORCEINLINE void CAnimationLayer::SetWeightDeltaRate( float flDelta )
{
	m_flWeightDeltaRate = flDelta;
}

FORCEINLINE void CAnimationLayer::SetPrevCycle( float flPrevCycle )
{
	m_flPrevCycle = flPrevCycle;
}

FORCEINLINE void CAnimationLayer::SetPlaybackRate( float flPlaybackRate )
{
	m_flPlaybackRate = flPlaybackRate;
}

FORCEINLINE int	CAnimationLayer::GetSequence( ) const
{
	return m_nSequence;
}

FORCEINLINE float CAnimationLayer::GetCycle( ) const
{
	return m_flCycle;
}

FORCEINLINE float CAnimationLayer::GetPrevCycle( ) const
{
	return m_flPrevCycle;
}

FORCEINLINE float CAnimationLayer::GetPlaybackRate( ) const
{
	return m_flPlaybackRate;
}

FORCEINLINE float CAnimationLayer::GetWeight( ) const
{
	return m_flWeight;
}

FORCEINLINE float CAnimationLayer::GetWeightDeltaRate( ) const
{
	return m_flWeightDeltaRate;
}

class CBaseAnimatingOverlay : public CBaseAnimating
{
	DECLARE_CLASS( CBaseAnimatingOverlay, CBaseAnimating );

public:
	enum 
	{
		MAX_OVERLAYS = 15,
	};

private:
	CUtlVector< CAnimationLayer	> m_AnimOverlay;
	//int				m_nActiveLayers;
	//int				m_nActiveBaseLayers;

public:
	
	virtual CBaseAnimatingOverlay *	GetBaseAnimatingOverlay() { return this; }
	
	virtual void	OnRestore();
	virtual void	SetModel( const char *szModelName );

	virtual void	StudioFrameAdvance();
	virtual	void	DispatchAnimEvents ( CBaseAnimating *eventHandler );
	virtual void	GetSkeleton( CStudioHdr *pStudioHdr, BoneVector pos[], BoneQuaternionAligned q[], int boneMask );

	int		AddGestureSequence( int sequence, bool autokill = true );
	int		AddGestureSequence( int sequence, float flDuration, bool autokill = true );
	int		AddGesture( Activity activity, bool autokill = true );
	int		AddGesture( Activity activity, float flDuration, bool autokill = true );
	bool	IsPlayingGesture( Activity activity );
	void	RestartGesture( Activity activity, bool addifmissing = true, bool autokill = true );
	void	RemoveGesture( Activity activity );
	void	RemoveAllGestures( void );

	int		AddLayeredSequence( int sequence, int iPriority );

	void	SetLayerPriority( int iLayer, int iPriority );

	bool	IsValidLayer( int iLayer );

	void	SetLayerDuration( int iLayer, float flDuration );
	float	GetLayerDuration( int iLayer );

	void	SetLayerCycle( int iLayer, float flCycle );
	void	SetLayerCycle( int iLayer, float flCycle, float flPrevCycle );
	float	GetLayerCycle( int iLayer );

	void	SetLayerPlaybackRate( int iLayer, float flPlaybackRate );
	void	SetLayerWeight( int iLayer, float flWeight );
	float	GetLayerWeight( int iLayer );
	void	SetLayerBlendIn( int iLayer, float flBlendIn );
	void	SetLayerBlendOut( int iLayer, float flBlendOut );
	void	SetLayerAutokill( int iLayer, bool bAutokill );
	void	SetLayerLooping( int iLayer, bool bLooping );
	void	SetLayerNoRestore( int iLayer, bool bNoRestore );
	void	SetLayerNoEvents( int iLayer, bool bNoEvents );

	Activity	GetLayerActivity( int iLayer );
	int			GetLayerSequence( int iLayer );

	int		FindGestureLayer( Activity activity );

	void	RemoveLayer( int iLayer, float flKillRate = 0.2, float flKillDelay = 0.0 );
	void	FastRemoveLayer( int iLayer );

	CAnimationLayer *GetAnimOverlay( int iIndex, bool bUseOrder = true );
	int GetNumAnimOverlays() const;
	void SetNumAnimOverlays( int num );

	void VerifyOrder( void );

	bool	HasActiveLayer( void );

	virtual bool UpdateDispatchLayer( CAnimationLayer *pLayer, CStudioHdr *pWeaponStudioHdr, int iSequence );
	void AccumulateDispatchedLayers( CBaseAnimatingOverlay *pWeapon, CStudioHdr *pWeaponStudioHdr, IBoneSetup &boneSetup, BoneVector pos[], BoneQuaternion q[], float currentTime );
	void RegenerateDispatchedLayers( IBoneSetup &boneSetup, BoneVector pos[], BoneQuaternion q[], float currentTime );

private:
	int		AllocateLayer( int iPriority = 0 ); // lower priorities are processed first

	DECLARE_SERVERCLASS();
	DECLARE_DATADESC();
	DECLARE_PREDICTABLE();
};

EXTERN_SEND_TABLE(DT_BaseAnimatingOverlay);

inline int CBaseAnimatingOverlay::GetNumAnimOverlays() const
{
	return m_AnimOverlay.Count();
}

// ------------------------------------------------------------------------------------------ //
// CAnimationLayer inlines.
// ------------------------------------------------------------------------------------------ //

inline void CAnimationLayer::SetOrder( int nOrder )
{
	m_nOrder = nOrder;
}

inline void CAnimationLayer::NetworkStateChanged()
{
	if ( m_pOwnerEntity )
		m_pOwnerEntity->NetworkStateChanged();
}

inline void CAnimationLayer::NetworkStateChanged( void *pVar )
{
	if ( m_pOwnerEntity )
		m_pOwnerEntity->NetworkStateChanged();
}