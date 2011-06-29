/*
 *  Fader.cpp
 *  PuzzleStar
 *
 *  Created by nacho on 10/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#include "Fader.h"

//--------------------------------------------------------------------
// FunciÛn:    CFade::CFade
// Creador:    Nacho (AMD)
// Fecha:      Wednesday  13/06/2007  14:38:15
//--------------------------------------------------------------------
CFader::CFader(void)
{
	m_fRed = 0.0f;
	m_fGreen = 0.0f;
	m_fBlue = 0.0f;
	m_fFadeState = 0.0f;
	m_bFadeIn = true;
	m_bFadeActive = false;
	m_fFadeTime = 0.0f;
	m_fTarget = 0.0f;
}


//--------------------------------------------------------------------
// FunciÛn:    CFade::~CFade
// Creador:    Nacho (AMD)
// Fecha:      Wednesday  13/06/2007  14:38:17
//--------------------------------------------------------------------
CFader::~CFader(void)
{
}


//--------------------------------------------------------------------
// FunciÛn:    CFade::StartFade
// Creador:    Nacho (AMD)
// Fecha:      Thursday  14/06/2007  11:43:04
//--------------------------------------------------------------------
void CFader::StartFade(float red, float green, float blue, bool fadein, float time, float end, float begin)
{
	m_fBegin = begin;
	m_fTarget = end;
	m_bFadeActive = true;
	m_bFadeIn = fadein;
	m_fFadeState = 0.0f;
	m_fFadeTime = time;
	m_fRed = red;
	m_fGreen = green;
	m_fBlue = blue;
	
}


//--------------------------------------------------------------------
// FunciÛn:    CFade::Update
// Creador:    Nacho (AMD)
// Fecha:      Thursday  14/06/2007  11:56:53
//--------------------------------------------------------------------
void CFader::Update(float dt)
{
	if (m_fFadeTime > 0.0f)
	{
		m_fFadeState += dt;	
		
		if (m_fFadeState >= m_fFadeTime)
		{
			m_bFadeActive = false;
		}
		
		float alpha = 0.0f;
		
		///--- fade in
		if (m_bFadeIn)
		{
			alpha = 255.0f - ((m_fFadeState * 255.0f) / m_fFadeTime);
		}
		///--- fade out
		else
		{
			alpha = ((m_fFadeState * 255.0f) / m_fFadeTime);
		}
		
		alpha = MAT_Clampf(alpha, m_fBegin, m_fTarget);		
		
		if (alpha > 0.0f)
		{	
			const GLfloat fadeVertices[] = {
				0.0f, 0.0f,
				320.0f, 0.0f,
				0.0f,  480.f,
				320.0f,  480.0f
			};
			
			glDisable(GL_TEXTURE_2D);
			glEnable(GL_BLEND);			
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			
			glVertexPointer(2, GL_FLOAT, 0, fadeVertices);
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glLoadIdentity();			
						
			glColor4f(m_fRed, m_fGreen, m_fBlue, alpha / 255.0f);
						
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
						
			glDisable(GL_BLEND);
			glEnable(GL_TEXTURE_2D);	
			
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
	}
}
