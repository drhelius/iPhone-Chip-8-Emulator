/*
 *  Geardome.cpp
 *  PuzzleStar
 *
 *  Created by nacho on 14/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#include "Geardome.h"

CGeardome::CGeardome(void)
{
	Log("+++ CGeardome::CGeardome ...\n");
	
	InitPointer(m_pGearTexture);

	Log("+++ CGeardome::CGeardome correcto\n");
}

////////////////////////////////////
////////////////////////////////////

CGeardome::~CGeardome()
{
	Log("+++ CGeardome::~CGeardome ...\n");
	
	End();
	
	Log("+++ CGeardome::~CGeardome DESTRUIDO\n");
}

////////////////////////////////////
////////////////////////////////////

void CGeardome::Update(float fDeltaTime)
{
}

////////////////////////////////////
////////////////////////////////////

void CGeardome::Render(void)
{
	const GLfloat gearVertices[] = {
		0.0f, 0.0f,
		320.0f, 0.0f,
		0.0f,  480.f,
		320.0f,  480.0f
	};
	const GLfloat gearTexcoords[] = {
		0, 0,
		0.625f, 0,
		0, 0.9375f,
		0.625f, 0.9375f
	};
	
	glEnable(GL_TEXTURE_2D);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0.0f, IPHONE_RES_X, IPHONE_RES_Y, 0.0f, -1.0f, 1.0f);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glVertexPointer(2, GL_FLOAT, 0, gearVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, gearTexcoords);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glBindTexture(GL_TEXTURE_2D, m_pGearTexture->GetTexture());
	

	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

////////////////////////////////////
////////////////////////////////////

void CGeardome::Init(void)
{
	Log("+++ CGeardome::Init ...\n");
	
	m_pGearTexture = new CTexture();
	m_pGearTexture->LoadFromFile("geardome_logo.png");
	
	Log("+++ CGeardome::Init correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CGeardome::End(void)
{
	Log("+++ CGeardome::End ...\n");
	
	SafeDelete(m_pGearTexture);
	
	Log("+++ CGeardome::End correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CGeardome::Tap(int x, int y)
{
}