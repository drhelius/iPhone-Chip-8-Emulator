/*
 *  Texture.cpp
 *  PuzzleStar
 *
 *  Created by nacho on 11/8/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#include "Texture.h"

CTexture::CTexture(void)
{
	m_iWidth = 0;
	m_iHeight = 0;
	m_theTexture = 0;
	m_bLoaded = false;
}

////////////////////////////////////
////////////////////////////////////

CTexture::~CTexture()
{
	Log("+++ CTexture::~CTexture ...\n");
	
	Unload();
	
	Log("+++ CTexture::~CTexture DESTRUIDO\n");
}

////////////////////////////////////
////////////////////////////////////

GLuint CTexture::LoadFromFile(char* path)
{
	Log("+++ CTexture::LoadFromFile %s\n", path);
	
	if (m_theTexture != 0)
	{
		return m_theTexture;
	}
	
	CGImageRef spriteImage;
	CGContextRef spriteContext;
	GLubyte *spriteData;
	size_t	width, height;
	
	// Creates a Core Graphics image from an image file
	spriteImage = [UIImage imageNamed:[NSString stringWithCString: path encoding: [NSString defaultCStringEncoding]]].CGImage;
	// Get the width and height of the image
	m_iWidth = width = CGImageGetWidth(spriteImage);
	m_iHeight = height = CGImageGetHeight(spriteImage);
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
	
	if(spriteImage)
	{
		// Allocated memory needed for the bitmap context
		spriteData = (GLubyte *) malloc(width * height * 4);
		// Uses the bitmatp creation function provided by the Core Graphics framework. 
		spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), spriteImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(spriteContext);
		
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &m_theTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, m_theTexture);
		// Speidfy a 2D texture image, provideing the a pointer to the image data in memory
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
		// Release the image data
		free(spriteData);
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		
		m_bLoaded = true;
		
		Log("+++ CTexture::LoadFromFile Textura cargada correctamente %s\n", path);
		
		return m_theTexture;
	}
	else
	{
		Log("--- CTexture::LoadFromFile Imposible cargar textura %s\n", path);
		return 0;
	}	
}

////////////////////////////////////
////////////////////////////////////

void CTexture::Unload(void)
{
	if (m_bLoaded)
	{
		glDeleteTextures(1, &m_theTexture);
	
		m_iWidth = 0;
		m_iHeight = 0;
		m_theTexture = 0;
		m_bLoaded =false;
	}
}

////////////////////////////////////
////////////////////////////////////

GLuint CTexture::GetTexture(void)
{
	return m_theTexture;
}

////////////////////////////////////
////////////////////////////////////

int CTexture::GetWidth(void)
{
	return m_iWidth;
}

////////////////////////////////////
////////////////////////////////////

int CTexture::GetHeight(void)
{
	return m_iHeight;
}
