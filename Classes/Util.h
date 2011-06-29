/*
 *  Util.h
 *  PuzzleStar
 *
 *  Created by nacho on 09/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "includes.h"

//#define DEBUG_EMULATOR 1

#define SafeDelete(pointer) if(pointer != NULL) {delete pointer; pointer = NULL;}
#define SafeDeleteArray(pointer) if(pointer != NULL) {delete [] pointer; pointer = NULL;}

#define InitPointer(pointer) ((pointer) = NULL)
#define IsValidPointer(pointer) ((pointer) != NULL)

#define IPHONE_RES_X 320
#define IPHONE_RES_Y 480

#define EMU_OFFSET_X 32
#define EMU_OFFSET_Y 81

#define M_PI_ENTRE_180 (0.017453293f)
#define M_180_ENTRE_PI (57.29577951f)

#define COLOR_ARGB(a,r,g,b) \
((unsigned int)((((a)&0xff)<<24)|(((r)&0xff)<<16)|(((g)&0xff)<<8)|((b)&0xff)))

#define REDRAW_INTERVAL (1.0/60.0)

typedef unsigned int DWORD;
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef uint64_t u64;

struct MATRIX					
{
	float Data[16];
};

enum {
	kSound_P = 0,
	kSound_U,
	kSound_Z1,
	kSound_Z2,
	kSound_L,
	kSound_E,
	kSound_Boton,
	kSound_ClickCube,
	kSound_LevelComplete,
	kSound_LevelStart,
	kSound_LevelFailed,
	kSound_GameOver,
	kSound_Menu,
	kSound_PopCube,
	kNumSounds,
};

enum {	
	kMusicGame = 0,
	kMusicMenu,
	kNumMusics,
};

inline void BUY_FULL_VERSION(void)
{
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.geardome.com/iphone/pstar/lite.php"]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=mnmyyig3deA"]];
}

inline void Log(const char* const msg, ...)
{
#ifdef DEBUG_EMULATOR
	va_list args;
	
	va_start(args, msg);
	
	char szBuf[256];
	
	vsprintf(szBuf, msg, args);
	
	printf(szBuf);
	
	va_end(args);
#endif
}
/*
inline char *replace_str(char *str, char *orig, char *rep)
{
	static char buffer[4096];
	char *p;
	
	if(!(p = strstr(str, orig)))  // Is 'orig' even in 'str'?
		return str;
	
	strncpy(buffer, str, p-str); // Copy characters from 'str' start to 'orig' st$
	buffer[p-str] = '\0';
	
	sprintf(buffer+(p-str), "%s%s", rep, p+strlen(orig));
	
	return buffer;
}
*/
inline char *str_replace(char *search, char *replace, char *subject)
{
	if (search == NULL || replace == NULL || subject == NULL) return NULL;
	if (strlen(search) == 0 || strlen(replace) == 0 || strlen(subject) == 0) return NULL;
	
	char *replaced = (char*)calloc(1, 1), *temp = NULL;
	char *p = subject, *p3 = subject, *p2;
	int  found = 0;
	
	while ( (p = strstr(p, search)) != NULL) {
		found = 1;
		temp = (char*)realloc(replaced, strlen(replaced) + (p - p3) + strlen(replace));
		if (temp == NULL) {
			free(replaced);
			return NULL;
		}
		replaced = temp;
		strncat(replaced, p - (p - p3), p - p3);
		strcat(replaced, replace);
		p3 = p + strlen(search);
		p += strlen(search);
		p2 = p;
	}
	
	if (found == 1) {
		if (strlen(p2) > 0) {
			temp = (char*)realloc(replaced, strlen(replaced) + strlen(p2) + 1);
			if (temp == NULL) {
				free(replaced);
				return NULL;
			}
			replaced = temp;
			strcat(replaced, p2);
		}
	} else {
		temp = (char*)realloc(replaced, strlen(subject) + 1);
		if (temp != NULL) {
			replaced = temp;
			strcpy(replaced, subject);
		}
	}
	return replaced;
}
//--------------------------------------------------------------------
// FunciÛn:    MAT_ToRadians
// PropÛsito:  Pasa de Grados a Radianes
// Fecha:      martes, 28 de noviembre de 2006, 22:46:51
//--------------------------------------------------------------------
inline float MAT_ToRadians(float angle)
{
	return (angle * M_PI_ENTRE_180);
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_ToDegrees
// PropÛsito:  Pasa de Radianes a Grados
// Fecha:      martes, 28 de noviembre de 2006, 22:46:41
//--------------------------------------------------------------------
inline float MAT_ToDegrees(float angle)
{
	return (angle * M_180_ENTRE_PI);
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_abs
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  22:05:57
//--------------------------------------------------------------------
inline float MAT_abs(float num)
{
	return (num < 0) ? -num : num;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Clamp
// Creador:    Nacho (AMD)
// Fecha:      miÈrcoles, 31 de enero de 2007, 19:50:17
//--------------------------------------------------------------------
inline int MAT_Clamp(int num, int min, int max)
{
	if (num > max)
	{
		return max; 
	}
	if (num < min)
	{
		return min; 
	}
	return num;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Clampf
// Creador:    Nacho (AMD)
// Fecha:      miÈrcoles, 31 de enero de 2007, 19:50:17
//--------------------------------------------------------------------
inline float MAT_Clampf(float num, float min, float max)
{
	if (num > max)
	{
		return max; 
	}
	if (num < min)
	{
		return min; 
	}
	return num;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Max
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:57:55
//--------------------------------------------------------------------
inline float MAT_Max(float num1, float num2)
{
	return (num1 > num2) ? num1 : num2;	
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Min
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:58:00
//--------------------------------------------------------------------
inline float MAT_Min(float num1, float num2)
{
	return (num1 < num2) ? num1 : num2;	
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Max
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:57:55
//--------------------------------------------------------------------
inline int MAT_MaxInt(int num1, int num2)
{
	return (num1 > num2) ? num1 : num2;	
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Min
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:58:00
//--------------------------------------------------------------------
inline int MAT_MinInt(int num1, int num2)
{
	return (num1 < num2) ? num1 : num2;	
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_RandomInt
// Creador:    Nacho (AMD)
// PropÛsito:  Devuelve un n˙mero entero aleatorio entre dos introducidos, el alto
//			   excluido y el bajo incluido.	
// Fecha:      martes, 06 de febrero de 2007, 19:29:34
//--------------------------------------------------------------------
inline int MAT_RandomInt(int low, int high)
{
	int range = high - low;
	int num = rand() % range;
	return (num + low);
}

//------------------------------------------------------------------------------
// FunciÛn: MAT_NormalizarAngulo360
// PropÛsito: Devuelve un ·ngulo normalizado entre [0 <= angle < 360]
//------------------------------------------------------------------------------
inline float MAT_NormalizarAngulo360(float angulo)
{
	while (angulo>360.0f)
	{
		angulo-=360.0f;
	}
	
	while (angulo<0.0f)
	{
		angulo+=360.0f;
	}
	
	return angulo;
}

//------------------------------------------------------------------------------
// FunciÛn: MAT_NormalizarAngulo180
// PropÛsito: Devuelve un ·ngulo normalizado entre [-180 < angulo <= 180]
//------------------------------------------------------------------------------
inline float MAT_NormalizarAngulo180(float angulo)
{
	angulo = MAT_NormalizarAngulo360(angulo);
	if (angulo > 180.0f)
	{
		angulo-=360.0f;
	}
	return angulo;
}

