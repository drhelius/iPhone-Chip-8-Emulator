/*
 *  Emulator.h
 *  Chip8
 *
 *  Created by nacho on 14/02/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once

#include "Fader.h"
#include "Texture.h"
#include "Timer.h"
#include "TextFont.h"
#include "Chip8AppDelegate.h"
#include "SoundEngine.h"

#define ROM_COUNT 30

struct ROM_info
{
	int delay;
	bool buttons[16];		
};

class CEmulator
{
private:
	
	int PC, SP, INDEX;
	int Speed;
	
	u8 ROM[4096+80+160];
    u8 m_FrameBuffer[8192];		
	int V[16];
    int HP48[8];
    int STACK[16];    
    int KEYSTATUS[16]; 
	int m_iOpcode1, m_iOpcode2, m_iOpcode3, m_iOpcode4, m_iByte1, m_iByte2;
	int cache1, cache2, cache3;
    int data, data2;
    int pixel;

	bool m_bNeedReset;
    bool m_bSuperChip;
    long m_lLastUpdateTimers;
    bool m_bWaitingForKeyPress;
	int DELAYTIMER;
	int SOUNDTIMER;
	
	static const u8 FONT8[80]; 
	static const u8 FONTS[160]; 
	
	static const char* ROM_NAMES[ROM_COUNT];
	static const ROM_info ROM_INFO[ROM_COUNT];
	
	Chip8AppDelegate* m_pDelegate;
	
	CTimer m_MainTimer;
	CTimer m_BannerTimer;
	//CTimer m_DrawTimer;
	
	bool m_bNeedRender;
	bool m_bRomLoaded;
	
	bool m_bShowingList;
	bool m_bQuittingList;
	float m_fListPosition;
	
	int m_iSelectorNow;
	int m_iSelectorNext;
	float m_fSelector;
	
	CTexture* m_pBgTexture;
	CTexture* m_pSelectorTexture;
	CTexture* m_pBannerTexture;
	
	CTextFont* m_pText;
	
	UInt32	m_Sound;
	
	bool m_bPressedButtons[5];
	
private:
	void ShowError(void) {
		Log("Not implemented: 0x%x 0x%x", m_iByte1, m_iByte2);
    };
	
public:

	CEmulator(Chip8AppDelegate* pDelegate);
	~CEmulator();
	
	void Go(void);
	void Tick(void);
	void ResetEmu(void);
	void LoadRom(void);
	bool NeedRender(void) { return m_bNeedRender; };
	bool RomLoaded(void) { return m_bRomLoaded; };
	void Update(float fDeltaTime);
	void UpdateUI(float fDeltaTime);
	void Render(bool drawStatic);
	void RenderBackground(void);
	void RenderBanner(void);
	void RenderList(void);
	void Init(void);
	void End(void);
	void Tap(int x, int y);
	void Touch(int x, int y);
	void TouchEnd(int x, int y);
};