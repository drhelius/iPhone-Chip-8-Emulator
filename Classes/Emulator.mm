/*
 *  Emulator.cpp
 *  Chip8
 *
 *  Created by nacho on 14/02/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Emulator.h"

const ROM_info CEmulator::ROM_INFO[ROM_COUNT] = {
/*15PUZZLE*/{50000, {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}},
/*ALIEN*/	{50000, {true, true, true, false, true, true, true, true, true, true, false, true, false, true, true, true}},
/*BLINKY*/	{50000, {true, true, true, false, true, true, false, false, false, true, true, true, true, true, true, true}},
/*BLITZ*/	{500000, {true, true, true, true, true, false, true, true, true, true, true, true, true, true, true, true}},
/*BRIX*/	{170000, {true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true}},
/*CAR*/		{50000, {true, true, true, true, true, true, true, false, false, true, true, true, true, true, true, true}}, 
/*CONNECT4*/{1000000, {true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, true}},
/*FIELD	{50000, {true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}},*/
/*GUESS*/	{50000, {true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}},
/*HIDDEN*/	{1000000, {true, true, false, true, false, false, false, true, false, true, true, true, true, true, true, true}},
/*INVADERS*/{100000, {true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, true}},
/*JOUST*/	{19000, {true, true, true, false, true, true, true, true, true, true, false, true, false, true, true, true}},
/*KALEID*/	{50000, {true, true, false, true, false, true, false, true, false, true, true, true, true, true, true, true}}, 
/*MERLIN*/	{50000, {true, true, true, true, false, false, true, false, false, true, true, true, true, true, true, true}}, 
/*MISSILE*/	{100000, {true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true}}, 
/*PIPER*/	{100000, {true, false, true, false, false, true, false, false, false, true, true, true, true, true, true, true}},
/*PONG*/	{170000, {true, false, true, true, false, true, true, true, true, true, true, true, false, false, true, true}},
/*PONG2*/	{170000, {true, false, true, true, false, true, true, true, true, true, true, true, false, false, true, true}},
/*PUZZLE*/	{500000, {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true}},
/*RACE*/	{100000, {true, true, true, true, true, true, true, false, false, true, true, true, true, true, true, true}},
/*SPACEFIG*/{0, {true, true, true, false, true, true, true, true, true, true, false, true, false, true, true, true}},
/*SYZYGY*/	{80000, {true, true, true, false, true, true, false, false, false, true, true, true, true, true, false, false}},
/*TANK*/	{50000, {true, true, false, true, false, false, false, true, false, true, true, true, true, true, true, true}},
/*RETRIX*/	{70000, {true, true, true, true, false, false, false, false, true, true, true, true, true, true, true, true}},
/*TICTAC*/	{50000, {true, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true}}, 
/*UBOAT*/	{40000, {true, true, true, true, true, true, true, false, false, true, true, true, true, true, false, true}},
/*UFO*/		{200000, {true, true, true, true, false, false, false, true, true, true, true, true, true, true, true, true}}, 
/*VBRIX*/	{100000, {true, false, true, true, false, true, true, false, true, true, true, true, true, true, true, true}}, 
/*VERS*/	{120000, {true, true, false, true, true, true, true, false, true, true, false, false, false, false, true, false}},
/*WIPEOFF*/	{130000, {true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true}},
/*WORM3*/	{50000, {true, true, true, true, true, true, true, true, false, false, true, true, true, true, true, true}}
};

const char* CEmulator::ROM_NAMES[ROM_COUNT] = {
"15PUZZLE", "ALIEN", "BLINKY", "BLITZ", "BRIX", "CAR", "CONNECT4", /*"FIELD",*/ "GUESS",
"HIDDEN", "INVADERS", "JOUST", "KALEID", "MERLIN", "MISSILE", "PIPER", "PONG", "PONG2", "PUZZLE",
"RACE", "SPACEFIG", "SYZYGY", "TANK", "RETRIX", "TICTAC", "UBOAT", "UFO", "VBRIX", "VERS",
"WIPEOFF", "WORM3"
};

const u8 CEmulator::FONTS[160] = {
0x7c, 0xc6, 0xce, 0xde, 0xd6, 0xf6, 0xe6, 0xc6, 0x7c, 0x0,
0x10, 0x30, 0xf0, 0x30, 0x30, 0x30, 0x30, 0x30, 0xfc, 0x0,
0x78, 0xcc, 0xcc, 0xc,  0x18, 0x30, 0x60, 0xcc, 0xfc, 0x0,
0x78, 0xcc, 0xc,  0xc,  0x38, 0xc,  0xc,  0xcc, 0x78, 0x0,
0xc,  0x1c, 0x3c, 0x6c, 0xcc, 0xfe, 0xc,  0xc,  0x1e, 0x0,
0xfc, 0xc0, 0xc0, 0xc0, 0xf8, 0xc,  0xc,  0xcc, 0x78, 0x0,
0x38, 0x60, 0xc0, 0xc0, 0xf8, 0xcc, 0xcc, 0xcc, 0x78, 0x0,
0xfe, 0xc6, 0xc6, 0x6,  0xc,  0x18, 0x30, 0x30, 0x30, 0x0,
0x78, 0xcc, 0xcc, 0xec, 0x78, 0xdc, 0xcc, 0xcc, 0x78, 0x0,
0x7c, 0xc6, 0xc6, 0xc6, 0x7c, 0x18, 0x18, 0x30, 0x70, 0x0,
0x30, 0x78, 0xcc, 0xcc, 0xcc, 0xfc, 0xcc, 0xcc, 0xcc, 0x0,
0xfc, 0x66, 0x66, 0x66, 0x7c, 0x66, 0x66, 0x66, 0xfc, 0x0,
0x3c, 0x66, 0xc6, 0xc0, 0xc0, 0xc0, 0xc6, 0x66, 0x3c, 0x0,
0xf8, 0x6c, 0x66, 0x66, 0x66, 0x66, 0x66, 0x6c, 0xf8, 0x0,
0xfe, 0x62, 0x60, 0x64, 0x7c, 0x64, 0x60, 0x62, 0xfe, 0x0,
0xfe, 0x66, 0x62, 0x64, 0x7c, 0x64, 0x60, 0x60, 0xf0, 0x0
};

const u8 CEmulator::FONT8[80] = {
0x60, 0xa0, 0xa0, 0xa0, 0xc0,
0x40, 0xc0, 0x40, 0x40, 0xe0,
0xc0, 0x20, 0x40, 0x80, 0xe0,
0xc0, 0x20, 0x40, 0x20, 0xc0,
0x20, 0xa0, 0xe0, 0x20, 0x20,
0xe0, 0x80, 0xc0, 0x20, 0xc0,
0x40, 0x80, 0xc0, 0xa0, 0x40,
0xe0, 0x20, 0x60, 0x40, 0x40,
0x40, 0xa0, 0x40, 0xa0, 0x40,
0x40, 0xa0, 0x60, 0x20, 0x40,
0x40, 0xa0, 0xe0, 0xa0, 0xa0,
0xc0, 0xa0, 0xc0, 0xa0, 0xc0,
0x60, 0x80, 0x80, 0x80, 0x60,
0xc0, 0xa0, 0xa0, 0xa0, 0xc0,
0xe0, 0x80, 0xc0, 0x80, 0xe0,
0xe0, 0x80, 0xc0, 0x80, 0x80
};



CEmulator::CEmulator(Chip8AppDelegate* pDelegate)
{
	Log("+++ CEmulator::CEmulator ...\n");
	
	m_pDelegate = pDelegate;
	
	InitPointer(m_pBgTexture);
	InitPointer(m_pSelectorTexture);
	InitPointer(m_pBannerTexture);	
	InitPointer(m_pText);
	
	Log("+++ CEmulator::CEmulator correcto\n");
}

////////////////////////////////////
////////////////////////////////////

CEmulator::~CEmulator()
{
	Log("+++ CEmulator::~CEmulator ...\n");
	
	End();
	
	Log("+++ CEmulator::~CEmulator DESTRUIDO\n");
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::End(void)
{
	Log("+++ CEmulator::End ...\n");
	
	SafeDelete(m_pBgTexture);
	SafeDelete(m_pSelectorTexture);
	SafeDelete(m_pBannerTexture);	
	SafeDelete(m_pText);

	Log("+++ CEmulator::End correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Init(void)
{
	Log("+++ CEmulator::Init ...\n");
	
	m_bRomLoaded = false;
	
	m_bShowingList = true;
	m_bQuittingList = false;
	m_fListPosition = 219.0f;
	m_iSelectorNow = 0;
	m_iSelectorNext = 0;
	
	for (int i=0; i<5; i++)
		m_bPressedButtons[i] = false;
	
	m_pBgTexture = new CTexture();
	m_pBgTexture->LoadFromFile("bg.png");
	
	m_pSelectorTexture = new CTexture();
	m_pSelectorTexture->LoadFromFile("selector.png");
	
	m_pBannerTexture = new CTexture();
	m_pBannerTexture->LoadFromFile("advert.png");
	
	m_pText = new CTextFont();
	m_pText->Init("font.png", "font");
	
	SoundEngine_LoadEffect([[[NSBundle mainBundle] pathForResource: @"emu" ofType:@"wav" inDirectory:@"/"] cStringUsingEncoding:1], &m_Sound);
	SoundEngine_SetEffectLevel(m_Sound, 0.1f);
	
	m_BannerTimer.Start();
	
	ResetEmu();
	
	Log("+++ CEmulator::Init correcto\n");
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Go(void)
{
	while (true)
	{
		Tick();
	}
}


////////////////////////////////////
////////////////////////////////////

void CEmulator::UpdateUI(float fDeltaTime)
{
	if (m_bShowingList)
	{
		if (m_fListPosition < 219.0f)
		{
			m_fListPosition += 6.0f * fDeltaTime * (219.0f - m_fListPosition);
			
			if (m_fListPosition > 219.0f)
				m_fListPosition = 219.0f;
		}
	}
	else if (m_bQuittingList)
	{
		if (m_fListPosition > 0.0f)
		{
			m_fListPosition -= 6.0f * fDeltaTime  * (m_fListPosition);
			
			if (m_fListPosition < 0.0f)
				m_fListPosition = 0.0f;
		}
	}
	
	if (m_iSelectorNow != m_iSelectorNext)
	{
		if (m_iSelectorNow < m_iSelectorNext)
		{
			m_fSelector+=200.0f * fDeltaTime;
			
			if (m_fSelector > (m_iSelectorNext * 30.0f))
			{
				m_fSelector = (m_iSelectorNext * 30.0f);
				m_iSelectorNow = m_iSelectorNext;
			}
		}
		else
		{
			m_fSelector-=200.0f * fDeltaTime;
			
			if (m_fSelector < (m_iSelectorNext * 30.0f))
			{
				m_fSelector = (m_iSelectorNext * 30.0f);
				m_iSelectorNow = m_iSelectorNext;
			}
		}
	}
	else
	{
		m_fSelector = m_iSelectorNow * 30.0f;
	}
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Update(float fDeltaTime)
{
	UpdateUI(fDeltaTime);	
}
	 
////////////////////////////////////
////////////////////////////////////

void CEmulator::Tick(void)
{
	if (!m_bRomLoaded)
	{
		return;
	}
	
	for (int i=0; i<ROM_INFO[m_iSelectorNow].delay;)
		i++;
	
	if (m_bNeedReset)
	{
		ResetEmu();
		LoadRom();
	}
	
	m_bNeedRender = false;
	
		
	m_MainTimer.Update();
	
	float fActualTime = m_MainTimer.GetActualTime();
	
	/// timers: they count down in threes using the PC's 18.2Hz 
	if (fActualTime >= 0.054945f)
	{
		m_MainTimer.Start();
		
		if (DELAYTIMER >= 0)
			DELAYTIMER-=3;
	    else
			DELAYTIMER=0;
		
		if (SOUNDTIMER >= 0)
			SOUNDTIMER-=3;
	    else
		{
			SoundEngine_StopEffect(m_Sound,false);
			SOUNDTIMER=0;
		}
	}
	
	/// miramos si se esta esperando una tecla	
	if (m_bWaitingForKeyPress)
	{
	    int key = -1;	    
	    
		for (int i=0; i<16; i++)
		{
			if (KEYSTATUS[i] != 0)
				key = i;
		}
	   		
	    if (key > 0)
	    {
			V[m_iOpcode2] = key;
			m_bWaitingForKeyPress = false;
	    }
	    else
		{
			m_bNeedRender = true;
			return;
		}
	}
	
	m_iByte1 = ROM[PC]; 
	m_iByte2 = ROM[PC+1]; 
	m_iOpcode1 = (m_iByte1 & 0xF0) >> 4;
	m_iOpcode2 = m_iByte1 & 0x0F;
	m_iOpcode3 = (m_iByte2 & 0xF0) >> 4;
	m_iOpcode4 = m_iByte2 & 0x0F;
	
	PC += 2;
	
	switch (m_iOpcode1)
	{
	    case 0x0:
	    {	
			switch(m_iByte2)
			{		    
				case 0xE0:
				{
					// Clear the screen
					
					for (int i=0; i<8192; i++)
					{
						m_FrameBuffer[i] = 0;
					}
					
					m_bNeedRender = true;
					
					break;
				}
					
				case 0xEE:
				{
					// Return from subroutine
					
					SP++;
					PC = STACK[SP];
					
					break;
				}
					
				case 0xFB:
				{
					// Scroll 4 pixels right  
					
					for (cache1 = 63; cache1 >=0; --cache1)
					{
						for (cache2 = 127; cache2>=4 ; --cache2)
						{
							m_FrameBuffer[(cache1<<7) + cache2] = m_FrameBuffer[(cache1<<7) + cache2 - 4];			    
						}
						
						for (cache2 = 3; cache2>=0 ; --cache2)
						{
							m_FrameBuffer[(cache1<<7) + cache2] = 0;			
						}
					}	
					
					m_bNeedRender = true;
									
					break;
				}
					
				case 0xFC:
				{
					// Scroll 4 pixels left 
					
					for (cache1 = 63; cache1 >=0; --cache1)
					{
						for (cache2 = 0; cache2<124 ; ++cache2)
						{
							m_FrameBuffer[(cache1<<7) + cache2] = m_FrameBuffer[(cache1<<7) + cache2 + 4];			    
						}
						
						for (cache2 = 124; cache2<128 ; ++cache2)
						{
							m_FrameBuffer[(cache1<<7) + cache2] = 0;			
						}
					}	
					
					m_bNeedRender = true;
					
					break;
				}
					
				case 0xFD:
				{
				
					//m_theCanvas.m_iState = 1;
					
					m_bShowingList = true;
					m_bQuittingList = false;
					m_bRomLoaded = false;
					break;
				}
					
				case 0xFE:
				{
					// Enable CHIP-8 Graphic mode 
					
					m_bSuperChip=false;
					break;
				}
					
				case 0xFF:
				{
					// Enable SCHIP Graphic mode
					
					m_bSuperChip=true;
					break;
				}
					
				default:
				{
					if (m_iOpcode3 == 0xC)
					{ 
						// Scroll down N lines 
						
						while (m_iOpcode4 !=0)
						{
							m_iOpcode4--;
							
							cache1=8063;
							cache2=8191;							
										    
							while (cache1 >= 0)
							{					
								m_FrameBuffer[cache2] = m_FrameBuffer[cache1];
								--cache1; --cache2;
							}							
							
							cache1=127;						
							
							while (cache1 >= 0)
							{
								m_FrameBuffer[cache1]=0;	
								--cache1;
							}							
						}	
						
						m_bNeedRender = true;
					}
					else
					{
						ShowError();
					}
					break;	    
				}	    
			}
			break;
	    }
	    case 0x1:
	    {	
			// Jump to address
			PC = (m_iOpcode2 << 8) + m_iByte2;
			break;
	    }
	    case 0x2:
	    {	 
			// Jump to sub
			STACK[SP] = PC;
			SP--;
			
			PC = (m_iOpcode2 << 8) + m_iByte2;
			break;
	    }
	    case 0x3:
	    {	 
			// Skip if reg equal
			if (V[m_iOpcode2] == m_iByte2)
				PC += 2;
			break;
	    }
	    case 0x4:
	    {	 
			// Skip if reg not equal
			if (V[m_iOpcode2] != m_iByte2)
				PC += 2;
			break;
	    }
	    case 0x5:
	    {		
			// Skip if reg equal reg
			if (V[m_iOpcode2] == V[m_iOpcode3])
				PC += 2;
			break;
	    }
	    case 0x6:
	    {			
			// Move constant to reg
			V[m_iOpcode2] = m_iByte2;
			break;
	    }
	    case 0x7:
	    {	
			// Add constant to reg
			V[m_iOpcode2] += m_iByte2;
			V[m_iOpcode2] &= 0xFF;
			break;
	    }
	    case 0x8:
	    {	 
			switch(m_iOpcode4)
			{
				case 0x0:
				{
					// Move register to register
					V[m_iOpcode2] = V[m_iOpcode3];
					break;
				}
					
				case 0x1:
				{
					// OR register with register
					V[m_iOpcode2] |= V[m_iOpcode3];
					break;
				}
					
				case 0x2:
				{
					// AND register with register
					V[m_iOpcode2] &= V[m_iOpcode3];
					break;
				}
					
				case 0x3:
				{
					// XOR register with register
					V[m_iOpcode2] ^= V[m_iOpcode3];
					break;
				}
					
				case 0x4:
				{
					// Add register to register
					V[m_iOpcode2] += V[m_iOpcode3];
					
					if (V[m_iOpcode2] > 0xFF)
					{
						V[0xF] = 1;
						V[m_iOpcode2] &= 0xFF;
					}
					else
						V[0xF] = 0;
					
					break;
				}
					
				case 0x5:
				{
					// Sub reg from reg
					if (V[m_iOpcode2] >= V[m_iOpcode3])
						V[0xF] = 1;
					else
						V[0xF] = 0;
					
					V[m_iOpcode2] -= V[m_iOpcode3];
					
					V[m_iOpcode2] &= 0xFF;
					break;
				}
					
				case 0x6:
				{
					// Shift register right
					V[0xF] = V[m_iOpcode2] & 0x1;			
					V[m_iOpcode2] >>= 1;
					break;
				}
					
				case 0x7:
				{
					// Sub reg from reg
					if (V[m_iOpcode3] >= V[m_iOpcode2])
						V[0xF] = 1;
					else
						V[0xF] = 0;
					
					V[m_iOpcode2] = V[m_iOpcode3] - V[m_iOpcode2];
					
					V[m_iOpcode2] &= 0xFF;
					break;
				}
					
				case 0xE:
				{
					// Shift register left
					V[0xF] = (V[m_iOpcode2] & 0x80) >> 7;			 
					V[m_iOpcode2] <<= 1;
					V[m_iOpcode2] &= 0xFF;
					break;
				}	
					
				default:
				{
					ShowError();
					break;	    
				}
			}
			break;
	    }
	    case 0x9:
	    {	
			// Skip if reg not equal reg
			if (V[m_iOpcode2] != V[m_iOpcode3])
				PC += 2;
			break;
	    }
	    case 0xA:
	    {	 
			// move constant to index
			INDEX = 0xfff & ((m_iOpcode2 << 8) + m_iByte2);
			break;
	    }
	    case 0xB:
	    {	 
			// jump to address plus reg0
			PC = 0xfff & (V[0x0] + (m_iOpcode2 << 8) + m_iByte2);
			break;
	    }
	    case 0xC:
	    {	 
			// random number
			V[m_iOpcode2] = MAT_RandomInt(0, 256) & m_iByte2;
			break;
	    }
	    case 0xD:
	    {	 
			// draw sprite
			
			m_bNeedRender = true;
			
			V[0xF] = 0;	
			
			if (m_bSuperChip)
			{
				cache1 = V[m_iOpcode2];
				cache2 = V[m_iOpcode3];
				
				if (m_iOpcode4 == 0)
				{
					// 16x16			
					
					for (int j=15; j>=0; --j)
					{
						data = ROM[INDEX + (j<<1)];
						data2 = ROM[INDEX + (j<<1) + 1];
						
						for (int i=7; i>=0; --i)
						{			    
							if ((data & (0x80 >> i)) != 0)
							{
								pixel = (((cache2+j) & 0x3F)<<7) + ((cache1+i) & 0x7F);
								
								if (m_FrameBuffer[pixel] == 1)
								{
									V[0xF] = 1;
									m_FrameBuffer[pixel] = 0;				
								}
								else
								{
									m_FrameBuffer[pixel] = 1;			
								}    
							}
							
							if ((data2 & (0x80 >> i)) != 0)
							{
								pixel = (((cache2+j) & 0x3F)<<7) + ((cache1+i+8) & 0x7F);
								
								if (m_FrameBuffer[pixel] == 1)
								{
									V[0xF] = 1;
									m_FrameBuffer[pixel] = 0;				
								}
								else
								{
									m_FrameBuffer[pixel] = 1;			
								}    		    
							}
						}		    
					}				
				}
				else
				{		    
					for (int j=m_iOpcode4-1; j>=0; --j)
					{
						data = ROM[INDEX + j];
						
						for (int i=7; i>=0; --i)
						{			    
							if ((data & (0x80 >> i)) != 0)
							{
								pixel = (((cache2+j) & 0x3F)<<7) + ((cache1+i) & 0x7F);
								
								if (m_FrameBuffer[pixel] == 1)
								{
									V[0xF] = 1;
									m_FrameBuffer[pixel] = 0;				
								}
								else
								{
									m_FrameBuffer[pixel] = 1;			
								}    
							}		
						}		    
					}						
				}
			}
			else
			{
				cache1 = V[m_iOpcode2] << 1;
				cache2 = V[m_iOpcode3] << 1;
				
				if (m_iOpcode4 == 0)
					m_iOpcode4=16;
				
				for (int j=m_iOpcode4-1; j>=0; --j)
				{
					data = ROM[INDEX + j];
					
					for (int i=7; i>=0; --i)
					{			    
						if ((data & (0x80 >> i)) != 0)
						{			
							pixel = (((cache2+ (j<<1)) & 0x3F)<<7) + ((cache1+ (i<<1)) & 0x7F);	
							
							if (m_FrameBuffer[pixel] == 1)
							{
								V[0xF] = 1;
								m_FrameBuffer[pixel] = 0;
								m_FrameBuffer[pixel+1] = 0;
								m_FrameBuffer[pixel+128] = 0;
								m_FrameBuffer[pixel+129] = 0;
							}
							else
							{
								m_FrameBuffer[pixel] = 1;
								m_FrameBuffer[pixel+1] = 1;
								m_FrameBuffer[pixel+128] = 1;
								m_FrameBuffer[pixel+129] = 1;
							}    
						}		
					}		    
				}				
			}		
			
			break;
	    }
	    case 0xE:
	    {
			switch(m_iOpcode3)
			{
				case 0x9:
				{
					// skip if key pressed
					if (KEYSTATUS[V[m_iOpcode2]] != 0)
						PC += 2;
					break;
				}
					
				case 0xA:
				{
					// skip if not key pressed
					if (KEYSTATUS[V[m_iOpcode2]] == 0)
						PC += 2;
					break;
				}
					
				default:
				{
					ShowError();
					break;	    
				}		
			}
			break;
	    }
	    case 0xF:
	    {	 
			switch (m_iOpcode3)
			{
				case 0x0:
				{
					switch(m_iOpcode4)
					{
						case 0x7:
						{
							// Get dealy timer into reg
							V[m_iOpcode2] = DELAYTIMER;
							break;
						}
							
						case 0xA:
						{
							// Wait for key press
							m_bWaitingForKeyPress = true;
							break;				
						}
							
						default:
						{
							ShowError();
							break;	    
						}
					}
					break;
				}
					
				case 0x1:
				{
					switch(m_iOpcode4)
					{
						case 0x5:
						{
							// Set delay timer
							DELAYTIMER = V[m_iOpcode2];
							break;
						}
							
						case 0x8:
						{
							// TODO: Set sound timer	
							SOUNDTIMER = V[m_iOpcode2];
							SoundEngine_StartEffect(m_Sound);
								//m_BeepPlayer.stop();
								//m_BeepPlayer.setMediaTime(0L);
								//m_BeepPlayer.start();
								//Display.getDisplay(Main.m_TheMidlet).vibrate(100);
							
							
							break;
						}
							
						case 0xE:
						{
							// Add reg to index
							INDEX += V[m_iOpcode2];
							INDEX &= 0xFFF;
							break;
						}	
							
						default:
						{
							ShowError();
							break;	    
						}
					}
					break;
				}
					
				case 0x2:
				{			
					// Point index to font character CHIP-8
					INDEX = 0x1000 + (V[m_iOpcode2] * 0x5);
					break;
				}
					
				case 0x3:
				{
					switch(m_iOpcode4)
					{
						case 0x0:
						{
							// Point index to font character SCHIP
							INDEX = 0x1050 + (V[m_iOpcode2] * 0xa);
							break;			    
						}
							
						case 0x3:
						{
							// Store BCD
							cache1 = V[m_iOpcode2];
							cache2 = cache1 / 100;
							cache3 = (cache1 - (100*cache2))/10;	
							ROM[INDEX] = (u8)cache2;
							ROM[INDEX + 1] = (u8)cache3;
							ROM[INDEX + 2] = (u8)(cache1 - ((10*cache3) + (100*cache2)));
						}
							
						default:
						{
							ShowError();			
							break;	    
						}
					}		
					
					break;
				}
					
				case 0x5:
				{
					// Store regs at index			
					for (cache1 = m_iOpcode2; cache1 >= 0; --cache1)
					{
						ROM[INDEX+cache1] = (u8)(V[cache1]);
					}
					break;
				}
					
				case 0x6:
				{
					// Load regs from index
					for (int cache1 = m_iOpcode2; cache1 >= 0; --cache1)
					{
						V[cache1] = ROM[INDEX+cache1] & 0xff;
					}
					break;
				}
					
				case 0x7:
				{
					// Save V0...VX (X<8) in the HP48 flags 
					for (cache1 = m_iOpcode2; cache1 >= 0; --cache1)
					{
						HP48[cache1] = V[cache1];
					}
					
					break;	
				}
					
				case 0x8:
				{			
					// Load V0...VX (X<8) from the HP48 flags  
					for (cache1 = m_iOpcode2; cache1 >= 0; --cache1)
					{
						V[cache1] = HP48[cache1];
					}
					
					break;
				}
					
				default:
				{
					ShowError();			
					break;	    
				}
			}
			break;
	    }
			
	    default:
	    {
			ShowError();		
			break;	    
	    }			
	}	
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::LoadRom(void)
{
	ResetEmu();
	
	const char* szRom = ROM_NAMES[m_iSelectorNow];
	
	m_bRomLoaded = true;	
	
	FILE *pFile;
	long len;
	char buf[4096];
	
	NSString * path = [[NSBundle mainBundle] pathForResource: [NSString stringWithCString: szRom encoding: [NSString defaultCStringEncoding]] ofType: nil];
	
	pFile = fopen([path cStringUsingEncoding:1],"r");
	
	if(pFile == NULL)
	{ 
		Log("--- CTextFont::Init Imposible abrir el rom: %s\n", szRom);
		return;
	} 
	
	fseek(pFile, 0, SEEK_END); 
	len = ftell(pFile); 
	fseek(pFile, 0, SEEK_SET); 
	
	if (len > (4096-512))
	{ 
		fclose(pFile);
		Log("--- CTextFont::Init El rom %s es demasiado grande\n", szRom);
		return;
	} 
			
	fread(buf, len, 1, pFile); 
	fclose(pFile);
	
	for (int i=0; i<len; i++)
	{
		ROM[i + 512] = buf[i];		    
	}	
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::ResetEmu(void)
{
	m_bNeedReset = false;
	
	srand((unsigned)time(NULL));
	
	PC = 0x200;
	SP = 0xF;
	INDEX = 0;
	m_bSuperChip = m_bWaitingForKeyPress = false;	
	DELAYTIMER = 0;
	SOUNDTIMER = 0;
	
	for (int i=0; i<16; i++)
	{
		V[i] = 0;
		STACK[i] = 0;
		KEYSTATUS[i] = 0;
	}
	
	for (int i=0; i<8; i++)
	{
		HP48[i] = 0;
	}
	
	for (int i=0; i<4336; i++)
	{
		ROM[i] = 0;
	}
	
	for (int i=0; i<8192; i++)
	{
		m_FrameBuffer[i] = 0;
	}
	
	for (int i=4096, j=0; j<80; i++, j++)
	{
		ROM[i] = FONT8[j];	    
	}
	
	for (int i=4176, j=0; j<160; i++, j++)
	{
		ROM[i] = FONTS[j];	    
	}
	
	//m_DrawTimer.Start();
	m_MainTimer.Start();
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::RenderBackground(void)
{
	const GLfloat vertices[] = {
		0.0f, 0.0f,
		1.0f, 0.0f,
		0.0f,  1.0f,
		1.0f,  1.0f
	};
	const GLfloat bgTexcoords[] = {
		0, 0,
		0.625f, 0,
		0, 0.9375f,
		0.625f, 0.9375f
	};
	
	const GLfloat overleftTexcoords[] = {
		0.6308594f, 0.00390625f,
		0.8652344f, 0.00390625f,
		0.6308594f, 0.0703125f,
		0.8652344f, 0.0703125f
	};
	
	const GLfloat overrightTexcoords[] = {
		0.6308594f, 0.0800781f,
		0.8652344f, 0.0800781f,
		0.6308594f, 0.1464843f,
		0.8652344f, 0.1464843f
	};
	
	const GLfloat buttonTexcoords[] = {
		0.6308594f, 0.1542969f,
		0.7402343f, 0.1542969f,
		0.6308594f, 0.234375f,
		0.7402343f, 0.234375f
	};
	
	const GLfloat highlightTexcoords[] = {
		0.74414062f, 0.1542969f,
		0.83789062f, 0.1542969f,
		0.74414062f, 0.2226562f,
		0.83789062f, 0.2226562f
	};
	
	
	
	glEnable(GL_TEXTURE_2D);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, bgTexcoords);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glBindTexture(GL_TEXTURE_2D, m_pBgTexture->GetTexture());
	
	glTranslatef(0.0f, 0.0f, 0.0f);
	glScalef(320.0f, 480.0f, 0.0f);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	if (m_bPressedButtons[0])
	{
		glTexCoordPointer(2, GL_FLOAT, 0, overleftTexcoords);
		glLoadIdentity();
		glTranslatef(5.0f, 226.0f, 0.0f);
		glScalef(120.0f, 34.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	if (m_bPressedButtons[1])
	{
		glTexCoordPointer(2, GL_FLOAT, 0, overrightTexcoords);
		glLoadIdentity();
		glTranslatef(194.0f, 226.0f, 0.0f);
		glScalef(120.0f, 34.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	
	
	for (int i=0; i<16; i++)
	{
		if (KEYSTATUS[i]>0)
		{
			glTexCoordPointer(2, GL_FLOAT, 0, buttonTexcoords);
			glLoadIdentity();		
			
			switch (i) 
			{
				case 0:
				{
					glTranslatef(28.0f + (1*70), 274.0f + (51 * 3), 0.0f);
					break;
				}
				case 0xb:
				{
					glTranslatef(28.0f + (2*70), 274.0f + (51 * 3), 0.0f);
					break;
				}
				case 0xc:
				{
					glTranslatef(28.0f + (3*70), 274.0f, 0.0f);
					break;
				}
				case 0xd:
				{
					glTranslatef(28.0f + (3*70), 274.0f + (51 * 1), 0.0f);
					break;
				}
				case 0xe:
				{
					glTranslatef(28.0f + (3*70), 274.0f + (51 * 2), 0.0f);
					break;
				}
				case 0xf:
				{
					glTranslatef(28.0f + (3*70), 274.0f + (51 * 3), 0.0f);
					break;
				}
				default:
				{
					int offsetx = ((i-1) % 3) * 70;
					int offsety = ((i-1) / 3) * 51;
					
					glTranslatef(28.0f + offsetx, 274.0f + offsety, 0.0f);
					break;
				}
			}
			
			glScalef(56.0f, 41.0f, 0.0f);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		}
		
		if (!ROM_INFO[m_iSelectorNow].buttons[i])
		{
			glTexCoordPointer(2, GL_FLOAT, 0, highlightTexcoords);
			glLoadIdentity();			
			switch (i) 
			{
				case 0:
				{
					glTranslatef(28.0f + (1*70) + 3, 274.0f + (51 * 3) + 4, 0.0f);
					break;
				}
				case 0xb:
				{
					glTranslatef(28.0f + (2*70) + 3, 274.0f + (51 * 3) + 4, 0.0f);
					break;
				}
				case 0xc:
				{
					glTranslatef(28.0f + (3*70) + 3, 274.0f + 4, 0.0f);
					break;
				}
				case 0xd:
				{
					glTranslatef(28.0f + (3*70) + 3, 274.0f + (51 * 1) + 4, 0.0f);
					break;
				}
				case 0xe:
				{
					glTranslatef(28.0f + (3*70) + 3, 274.0f + (51 * 2) + 4, 0.0f);
					break;
				}
				case 0xf:
				{
					glTranslatef(28.0f + (3*70) + 3, 274.0f + (51 * 3) + 4, 0.0f);
					break;
				}
				default:
				{
					int offsetx = ((i-1) % 3) * 70;
					int offsety = ((i-1) / 3) * 51;
					
					glTranslatef(28.0f + offsetx + 3, 274.0f + offsety + 4, 0.0f);
					break;
				}
			}
			
			glScalef(48.0f, 35.0f, 0.0f);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		}
	}
	
	RenderBanner();
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::RenderBanner(void)
{
	const GLfloat bannerTexcoords[] = {
		0.00390625f, 0.4375f,
		0.6289062f, 0.4375f,
		0.00390625f, 0.875f,
		0.6289062f, 0.875f
	};
	
	const GLfloat bannerLeftTexcoords[] = {
		0.6464843f, 0.0703125f,
		0.6855468f, 0.0703125f,
		0.6464843f, 0.421875f,
		0.6855468f, 0.421875f
	};
	
	const GLfloat bannerRightTexcoords[] = {
		0.7089843f, 0.0703125f,
		0.7480468f, 0.0703125f,
		0.7089843f, 0.421875f,
		0.7480468f, 0.421875f
	};
	
	const GLfloat vertices[] = {
		0.0f, 0.0f,
		1.0f, 0.0f,
		0.0f,  1.0f,
		1.0f,  1.0f
	};
	
	float actualTime = m_BannerTimer.GetActualTime();
	
	if (actualTime > 8.0f)
	{
		glVertexPointer(2, GL_FLOAT, 0, vertices);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		glBindTexture(GL_TEXTURE_2D, m_pBannerTexture->GetTexture());
				
		glColor4f(1.0f, 1.0f, 1.0f, (actualTime < 9.0f) ? (1.0f - (9.0f - actualTime)) : 1.0f);
				
		glTexCoordPointer(2, GL_FLOAT, 0, bannerTexcoords);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);		
		
		glLoadIdentity();	
		
		//glTranslatef(0.0f, 0.0f, 0.0f);
		glScalef(320.0f, 56.0f, 0.0f);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		
		if (actualTime > 11.0f)
		{
			if (((int)(actualTime) % 2) != 0)
			{
				glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
				
				glTexCoordPointer(2, GL_FLOAT, 0, bannerLeftTexcoords);
				glEnableClientState(GL_TEXTURE_COORD_ARRAY);
				
				glLoadIdentity();			
				glTranslatef(20.0f, 10.0f, 0.0f);
				glScalef(20.0f, 45.0f, 0.0f);
				glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
				
				glTexCoordPointer(2, GL_FLOAT, 0, bannerRightTexcoords);
				glEnableClientState(GL_TEXTURE_COORD_ARRAY);
				
				glLoadIdentity();			
				glTranslatef(282.0f, 10.0f, 0.0f);
				glScalef(20.0f, 45.0f, 0.0f);
				glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);				
			}
		}
	}
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::RenderList(void)
{
	const GLfloat vertices[] = {
		0.0f, 0.0f,
		1.0f, 0.0f,
		0.0f,  1.0f,
		1.0f,  1.0f
	};
	const GLfloat frontTexcoords[] = {
		0, 0,
		0.625f, 0,
		0, 0.4296875f,
		0.625f, 0.4296875f
	};
	const GLfloat backTexcoords[] = {
		0.00585937f, 0.6347656f,
		0.5761718f, 0.6347656f,
		0.00585937f, 0.830078f,
		0.5761718f, 0.830078f
	};
	
	const GLfloat upTexcoords[] = {
		0.625f, 0.01171875f,
		0.75390625f, 0.01171875f,
		0.625f, 0.072265625f,
		0.75390625f, 0.072265625f
	};
	
	const GLfloat downTexcoords[] = {
		0.625f, 0.2421875f,
		0.75390625f, 0.2421875f,
		0.625f, 0.3027344f,
		0.75390625f, 0.3027344f
	};
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glMatrixMode(GL_MODELVIEW);
	
	glBindTexture(GL_TEXTURE_2D, m_pSelectorTexture->GetTexture());	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	glTexCoordPointer(2, GL_FLOAT, 0, backTexcoords);
	glLoadIdentity();
	glTranslatef(0.0f + 14.0f, 480.0f - m_fListPosition + 75.0f, 0.0f);
	glScalef(292.0f, 100.0f, 0.0f);		
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
	
	int min = MAT_MaxInt(0, m_iSelectorNow-2);
	int max = MAT_MinInt(m_iSelectorNow+3, ROM_COUNT);
		
	for (int i= min; i<max; i++)
	{
		char level[5];
		sprintf(level,"%i", i+1);
		m_pText->Draw(level, 46.0f, -m_fSelector + 480.0f - m_fListPosition + 113.0f + (i * 30.0f), 1.0f, 1.0f, 1.0f, 1.0f);
		m_pText->Draw(ROM_NAMES[i], 85.0f, -m_fSelector + 480.0f - m_fListPosition + 113.0f + (i * 30.0f), 1.0f, 1.0f, 1.0f, 1.0f);
	}
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glBindTexture(GL_TEXTURE_2D, m_pSelectorTexture->GetTexture());	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	glTexCoordPointer(2, GL_FLOAT, 0, frontTexcoords);	
	glLoadIdentity();
	glTranslatef(0.0f, 480.0f - m_fListPosition, 0.0f);
	glScalef(320.0f, 220.0f, 0.0f);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
	
	if (m_bPressedButtons[3])
	{
		glTexCoordPointer(2, GL_FLOAT, 0, upTexcoords);	
		glLoadIdentity();
		glTranslatef(119.0f, 480.0f - 220.0f + 50.0f, 0.0f);
		glScalef(66.0f, 31.0f, 0.0f);	
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	else if (m_bPressedButtons[4])
	{
		glTexCoordPointer(2, GL_FLOAT, 0, downTexcoords);	
		glLoadIdentity();
		glTranslatef(119.0f, 480.0f - 220.0f + 50.0f + 118.0f, 0.0f);
		glScalef(66.0f, 31.0f, 0.0f);	
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Render(bool drawStatic)
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	
	//glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	//glClear(GL_COLOR_BUFFER_BIT);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0.0f, IPHONE_RES_X, IPHONE_RES_Y, 0.0f, -1.0f, 1.0f);	
	
	RenderBackground();
	RenderList();
	
	glDisable(GL_TEXTURE_2D);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
	glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
	
	glPointSize(2.0f);
	
	if (drawStatic)
	{
		GLubyte colorArray[8192*4];
		GLfloat vertexArray[8192*2];
		
		for (int x=0; x<128; x++)
		{
			for (int y=0; y<64; y++)
			{
				GLubyte color = MAT_RandomInt(0, 256);
				colorArray[(y*512)+(x*4)] = color;
				colorArray[(y*512)+(x*4)+1] = color;
				colorArray[(y*512)+(x*4)+2] = color;
				colorArray[(y*512)+(x*4)+3] = color;
				
				
				vertexArray[(y*256)+(x*2)] = (x*2.0f) +EMU_OFFSET_X +1;
				vertexArray[(y*256)+(x*2)+1] = (y*2.0f) +EMU_OFFSET_Y+1;			
			}
		}
		
		glLoadIdentity();
		glVertexPointer(2, GL_FLOAT, 0, vertexArray);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, colorArray);
		glEnableClientState(GL_COLOR_ARRAY);
		
		glDrawArrays(GL_POINTS, 0, 8192);
		
		glDisableClientState(GL_COLOR_ARRAY);
	}
	else
	{		
		GLubyte colorArray[8192*4];
		GLfloat vertexArray[8192*2];
		
		for (int x=0; x<128; x++)
		{
			for (int y=0; y<64; y++)
			{			
				if (m_FrameBuffer[(y*128)+x] != 0)
				{
					colorArray[(y*512)+(x*4)] = 0;
					colorArray[(y*512)+(x*4)+1] = 255;
					colorArray[(y*512)+(x*4)+2] = 0;
					colorArray[(y*512)+(x*4)+3] = 255;
				}	
				else
				{
					colorArray[(y*512)+(x*4)] = 0;
					colorArray[(y*512)+(x*4)+1] = 0;
					colorArray[(y*512)+(x*4)+2] = 0;
					colorArray[(y*512)+(x*4)+3] = 0;
				}
				
				vertexArray[(y*256)+(x*2)] = (x*2.0f) +EMU_OFFSET_X +1;
				vertexArray[(y*256)+(x*2)+1] = (y*2.0f) +EMU_OFFSET_Y+1;			
			}
		}
		
		glLoadIdentity();
		glVertexPointer(2, GL_FLOAT, 0, vertexArray);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, colorArray);
		glEnableClientState(GL_COLOR_ARRAY);	
		
		glDrawArrays(GL_POINTS, 0, 8192);
		
		glDisableClientState(GL_COLOR_ARRAY);		
	}
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Tap(int x, int y)
{
	
	if (y <= 63)
	{
		if (m_BannerTimer.GetActualTime() > 8.0f)
		{
			BUY_FULL_VERSION();
		}
	}
	
	if (y >=229 && y<256)
	{
		///---list
		if (x >=11 && x<119)
		{
			if (m_bShowingList)
			{
				if (m_fListPosition >= 218.5f)
				{
					m_bShowingList = false;
					m_bQuittingList = true;
				}
			}
			else
			{
				if (m_fListPosition <= 0.5f)
				{
					m_bShowingList = true;
					m_bQuittingList = false;
					m_bRomLoaded = false;
				}
			}
			m_bPressedButtons[0] = true;
		}
		///---reset
		else if (x >=200 && x<308)
		{
			m_bNeedReset = true;
			m_bPressedButtons[1] = true;
		}
	}
	
	if (m_bShowingList)
	{
		if (m_iSelectorNow == m_iSelectorNext)
		{
			if (x >=128 && x<200)
			{
				///---up
				if (y >=303 && y<349)
				{
					if (m_iSelectorNext > 0)
						m_iSelectorNext--;
					
					m_bPressedButtons[3] = true;
				}
				///---down
				else if (y >=420 && y<466)
				{
					if (m_iSelectorNext < (ROM_COUNT-1))
						m_iSelectorNext++;
					
					m_bPressedButtons[4] = true;
				}				
			}
			
			if (x >=10 && x<320)
			{
				if (y >=367 && y<407)
				{
					m_bShowingList = false;
					m_bQuittingList = true;
					
					ResetEmu();
					LoadRom();
				}
			}
		}
	}
	else
	{	
		if (x >=23 && x<87)
		{
			if (y >=270 && y<318)
			{
				KEYSTATUS[1]=1;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[4]=1;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[7]=1;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xA]=1;
			}
		}	
		else if (x >=93 && x<157)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[2]=1;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[5]=1;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[8]=1;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0]=1;
			}
		}
		else if (x >=163 && x<227)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[3]=1;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[6]=1;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[9]=1;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xB]=1;
			}
		}
		else if (x >=233 && x<297)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[0xC]=1;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[0xD]=1;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[0xE]=1;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xF]=1;
			}
		}
	}
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::Touch(int x, int y)
{
	
}

////////////////////////////////////
////////////////////////////////////

void CEmulator::TouchEnd(int x, int y)
{
	
	
	for (int i=0; i<5; i++)
		m_bPressedButtons[i] = false;
	
	for (int i=0; i<16; i++)
		KEYSTATUS[i] = 0;
	/*
	if (!m_bShowingList)
	{	
		if (x >=23 && x<87)
		{
			if (y >=270 && y<318)
			{
				KEYSTATUS[1]=0;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[4]=0;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[7]=0;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xA]=0;
			}
		}	
		else if (x >=93 && x<157)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[2]=0;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[5]=0;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[8]=0;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0]=0;
			}
		}
		else if (x >=163 && x<227)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[3]=0;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[6]=0;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[9]=0;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xB]=0;
			}
		}
		else if (x >=233 && x<297)
		{		
			if (y >=270 && y<318)
			{
				KEYSTATUS[0xC]=0;
			}
			else if (y >=322 && y<370)
			{
				KEYSTATUS[0xD]=0;
			}
			else if (y >=374 && y<422)
			{
				KEYSTATUS[0xE]=0;
			}
			else if (y >=426 && y<474)
			{
				KEYSTATUS[0xF]=0;
			}
		}	
	}*/
}

////////////////////////////////////
////////////////////////////////////