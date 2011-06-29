/*
 *  Game.cpp
 *  PuzzleStar
 *
 *  Created by nacho on 11/6/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#include "Game.h"


CGame::CGame(Chip8AppDelegate* pDelegate, GLint width, GLint height, GLuint render, GLuint frame, EAGLContext *con)
{
	context = con;
	backingWidth = width;
    backingHeight = height;  
    
    viewRenderbuffer = render;
	viewFramebuffer = frame;
	
	m_pDelegate = pDelegate;
	m_bLoaded = false;
	
	InitPointer(m_pGeardome);
	InitPointer(m_pEmulator);
}

////////////////////////////////////
////////////////////////////////////

CGame::~CGame()
{
	Log("+++ CGame::~CGame ...\n");
	
	End();
	
	Log("+++ CGame::~CGame DESTRUIDO\n");
}

////////////////////////////////////
////////////////////////////////////

CEmulator* CGame::Init(void)
{
	Log("+++ CGame::Init ...\n");	
	
	SetState(STATE_GEARDOME);
	
	m_bLoaded = true;	
	
	m_pGeardome = new CGeardome();
	m_pGeardome->Init();
		
	m_pEmulator = new CEmulator(m_pDelegate);
	m_pEmulator->Init();
	
	m_Fade.StartFade(0.0f, 0.0f, 0.0f, true, 1.0f);
	
	m_SelectionTimer.Start();
	m_MainTimer.Start();
	
	Log("+++ CGame::Init correcto\n");
	
	return m_pEmulator;
}

////////////////////////////////////
////////////////////////////////////

void CGame::End(void)
{
	Log("+++ CGame::End ...\n");
	
	if (m_bLoaded)
	{
		m_bLoaded = false;
	}
	
	SafeDelete(m_pGeardome);
	SafeDelete(m_pEmulator);
	
	Log("+++ CGame::End correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CGame::Pause(void)
{
	Log("+++ CGame::Pause ...\n");
		
	Log("+++ CGame::Pause correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CGame::Resume(void)
{
	Log("+++ CGame::Resume ...\n");
	
	Log("+++ CGame::Resume correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CGame::Tick(void)
{
	m_MainTimer.Update();
	
	(*this.*CurrentStateFunction)();
}

////////////////////////////////////
////////////////////////////////////

void CGame::DoStateGeardome(void)
{
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

	if (m_Fade.IsFinished() && m_SelectionTimer.GetActualTime() > 4.0f)
	{
		SafeDelete(m_pGeardome);		
		SetState(STATE_EMU);	
		m_Fade.StartFade(0.0f, 0.0f, 0.0f, true, 1.0f);
		m_DrawTimer.Start();
	}
	else
	{	
		if (m_Fade.IsFinished() && m_SelectionTimer.GetActualTime() > 3.0f)
		{
			m_Fade.StartFade(0.0f, 0.0f, 0.0f, false, 1.0f);
		}
		
		m_pGeardome->Update(m_MainTimer.GetDeltaTime());
		m_pGeardome->Render();
		m_Fade.Update(m_MainTimer.GetDeltaTime());
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];

}

////////////////////////////////////
////////////////////////////////////

void CGame::DoStateEmu(void)
{
	//m_DrawTimer.Update();
	
	
	m_pEmulator->Update(m_MainTimer.GetDeltaTime());
	if (m_pEmulator->RomLoaded())
	{		
		//if (m_pEmulator->NeedRender() && (m_DrawTimer.GetActualTime()>0.005f))
		{		
			[EAGLContext setCurrentContext:context];
			glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
			glViewport(0, 0, backingWidth, backingHeight);
			
			m_pEmulator->Render(false);
			
			m_Fade.Update(m_MainTimer.GetDeltaTime());
			
			glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
			[context presentRenderbuffer:GL_RENDERBUFFER_OES];
			
			m_DrawTimer.Start();
		}
	}
	else
	{
		[EAGLContext setCurrentContext:context];
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
		glViewport(0, 0, backingWidth, backingHeight);
		
		m_pEmulator->Render(true);
		
		m_Fade.Update(m_MainTimer.GetDeltaTime());
		
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
		
		m_DrawTimer.Start();
	}
	
}

////////////////////////////////////
////////////////////////////////////

void CGame::SetState(eSTATES theNewState)
{
	m_iCurrentState = theNewState;
	
	switch(theNewState)
	{
		case STATE_GEARDOME:
		{
			Log("+++ CGame::SetState Seleccionado estado STATE_GEARDOME\n");
			CurrentStateFunction=&CGame::DoStateGeardome;			 
			break;
		}
		case STATE_EMU:
		{
			Log("+++ CGame::SetState Seleccionado estado STATE_EMU\n");
			CurrentStateFunction=&CGame::DoStateEmu;
			break;
		}		
	}
}

////////////////////////////////////
////////////////////////////////////

void CGame::Tap(int x, int y)
{
	Log("TAP %d %d\n", x, y);
	
	switch(m_iCurrentState)
	{
		case STATE_GEARDOME:
		{
			
						 
			break;
		}
		case STATE_EMU:
		{
			m_pEmulator->Tap(x, y);
			break;
		}			
	}	
}

////////////////////////////////////
////////////////////////////////////

void CGame::Touch(int x, int y)
{
	switch(m_iCurrentState)
	{
		case STATE_GEARDOME:
		{
			
			
			break;
		}
		case STATE_EMU:
		{
			m_pEmulator->Touch(x, y);
			break;
		}			
	}
}

////////////////////////////////////
////////////////////////////////////

void CGame::TouchEnd(int x, int y)
{
	switch(m_iCurrentState)
	{
		case STATE_GEARDOME:
		{
			
			
			break;
		}
		case STATE_EMU:
		{
			m_pEmulator->TouchEnd(x, y);
			break;
		}			
	}
}

