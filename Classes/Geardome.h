/*
 *  Geardome.h
 *  PuzzleStar
 *
 *  Created by nacho on 14/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "Util.h"
#include "Texture.h"

class CGeardome
{
		
	private:
		CTexture* m_pGearTexture;
		
		
	public:
		
		CGeardome(void);
		~CGeardome();
		
		void Update(float fDeltaTime);
		void Render(void);
		void Init(void);
		void End(void);
		void Tap(int x, int y);
};