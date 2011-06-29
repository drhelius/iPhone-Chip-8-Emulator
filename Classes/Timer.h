/*
 *  Timer.h
 *  PuzzleStar
 *
 *  Created by nacho on 19/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "Util.h"

#define FPS_REFRESH_TIME	1.0f

class CTimer
	{
		
	public:
		
		CTimer(void);
		~CTimer(void);
		void Start(void);
		void Stop(void);
		void Continue(void);
		
		float GetActualTime(void);
		float GetFrameTime(void);
		float GetDeltaTime(void);
		
		void Reset(void);
		void Update(void);
		float GetFPS(void);
		
		bool IsRunning(void);
		
		void SetOffset(float offset) { m_fOffset = offset; };
		
	private:
		
		bool   m_bIsRunning;	
		
		float m_fOffset;
		
		u64 m_i64BaseTicks;
		u64 m_i64StopedTicks;
		
		float m_fResolution;
		
		float  m_fFrameTime;
		float  m_fDeltaTime;
		
		u32  m_iFrameCount;
		float  m_fLastUpdate;
		float  m_fFPS;
	};
