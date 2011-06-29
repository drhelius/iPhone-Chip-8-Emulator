/*
 *  Fader.h
 *  PuzzleStar
 *
 *  Created by nacho on 10/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "Util.h"

class CFader
{
	public:
	
		CFader(void);
		~CFader(void);
		
		void StartFade(float red, float green, float blue, bool fadein, float time, float target = 255.0f, float begin = 0.0f);
		
		void Update(float dt);
		
		bool IsFinished(void) { return !m_bFadeActive; };
		
	private:
		
				
		float m_fRed;
		float m_fGreen;
		float m_fBlue;
		float m_fFadeState;
		float m_fFadeTime;
		bool m_bFadeIn;
		bool m_bFadeActive;
		float m_fTarget;
		float m_fBegin;
		
};
