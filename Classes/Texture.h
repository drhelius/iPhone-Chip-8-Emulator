/*
 *  Texture.h
 *  PuzzleStar
 *
 *  Created by nacho on 11/8/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "Util.h"

class CTexture 
{
private:
	GLuint m_theTexture;
	int m_iWidth;
	int m_iHeight;
	bool m_bLoaded;
	
public:
	
	CTexture(void);
	~CTexture();
	
	GLuint LoadFromFile(char* path);
	void Unload(void);
	GLuint GetTexture(void);
	int GetWidth(void);
	int GetHeight(void);	
};