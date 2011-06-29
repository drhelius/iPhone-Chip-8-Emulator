/*
 *  Game.h
 *  PuzzleStar
 *
 *  Created by nacho on 11/6/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "Util.h"
#include "Geardome.h"
#include "Fader.h"
#include "Timer.h";
#include "Chip8AppDelegate.h"
#include "Emulator.h"

class CGame// : public CSingleton<CGame>
{
	//friend class CSingleton<CGame>;
	
private:
	
	enum eSTATES
	{
		STATE_GEARDOME,
		STATE_EMU	
	};
	
private:
	
	void (CGame::*CurrentStateFunction)(void);
	
	eSTATES m_iCurrentState;
	bool m_bLoaded;
	
	CGeardome* m_pGeardome;
	CTimer m_SelectionTimer;
	CTimer m_MainTimer;
	CFader m_Fade;
	UIWindow* m_pWindow;
	Chip8AppDelegate* m_pDelegate;
	CEmulator* m_pEmulator;
	
	/* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;  
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
	
	EAGLContext *context;
	
	CTimer m_DrawTimer;
	
	
private:			
	
	void DoStateGeardome(void);
	void DoStateEmu(void);
	void SetState(eSTATES theNewState);	
	
public:
	
	CGame(Chip8AppDelegate* pDelegate, GLint width, GLint height, GLuint render, GLuint frame, EAGLContext *con);
	
	~CGame();
		
	CEmulator* Init(void);
	void End(void);
	void Pause(void);
	void Resume(void);
	void Tick(void);
	void Tap(int x, int y);
	void Touch(int x, int y);
	void TouchEnd(int x, int y);
	void SetWindow(UIWindow* window) { m_pWindow = window; };
};

