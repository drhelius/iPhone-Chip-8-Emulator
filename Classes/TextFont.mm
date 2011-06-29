/********************************************************************/
/********************************************************************/
/*						    TextFont.cpp							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////

#include "TextFont.h"


//--------------------------------------------------------------------
// FunciÛn:    CTextFont::CTextFont
// PropÛsito:  
// Fecha:      lunes, 27 de noviembre de 2006, 19:37:23
//--------------------------------------------------------------------
CTextFont::CTextFont(void)
{
	Log("+++ CTextFont::CTextFont ...\n");
	
	InitPointer(m_pTexture);
	
	Log("+++ CTextFont::CTextFont correcto\n");	
}


//--------------------------------------------------------------------
// FunciÛn:    CTextFont::~CTextFont
// PropÛsito:  
// Fecha:      lunes, 27 de noviembre de 2006, 19:37:21
//--------------------------------------------------------------------
CTextFont::~CTextFont(void)
{
	Log("+++ CTextFont::~CTextFont ...\n");
	
	SafeDelete(m_pTexture);
	
	Log("+++ CTextFont::~CTextFont correcto\n");	
}


//--------------------------------------------------------------------
// FunciÛn:    CTextFont::Draw
// PropÛsito:  
// Fecha:      s·bado, 11 de noviembre de 2006, 14:54:38
//--------------------------------------------------------------------
void CTextFont::Draw(const char* const szString, int x, int y, float red, float green, float blue, float alpha)
{	
	const GLfloat verts[] = {
		0.0f, 0.0f,
		1.0f, 0.0f,
		0.0f,  1.f,
		1.0f,  1.0f
	};	
	
	glEnable(GL_TEXTURE_2D);
	
	glBindTexture(GL_TEXTURE_2D, m_pTexture->GetTexture());
	
	int len = (int)strlen(szString);
	
	if(!len) {
		return;
	}
	
	glColor4f(red, green, blue, alpha);
	
	
	glVertexPointer(2, GL_FLOAT, 0, verts);
	glEnableClientState(GL_VERTEX_ARRAY);
			
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	int offset = 0;
	
	for(int i = 0; i < len; i++)
	{
		unsigned char c = (unsigned char)szString[i];
		if(c < 32)
		{
			c = 0;
		}
		
		int tx = c % 16;
		int ty = c / 16;
		
		float txf1 = (tx * 32.0f) / 512.0f; 
		float tyf1 = (ty * 32.0f) / 512.0f; 
		float txf2 = ((tx * 32.0f) + 32.0f) / 512.0f; 
		float tyf2 = ((ty * 32.0f) + 32.0f) / 512.0f;
		
		GLfloat texcoords[8];
		texcoords[0] = txf1;
		texcoords[1] = tyf1;
		texcoords[2] = txf2;
		texcoords[3] = tyf1;
		texcoords[4] = txf1;
		texcoords[5] = tyf2;
		texcoords[6] = txf2;
		texcoords[7] = tyf2;	
		
		glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		glLoadIdentity();
		glTranslatef(x + offset, y, 0.0f);
		glScalef(32.0f,32.0f,0.0f);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		offset += m_SizeArray[c] + 1;
	}	
	
	glDisable(GL_BLEND);
}


//--------------------------------------------------------------------
// FunciÛn:    CTextFont::Init
// PropÛsito:  
// Fecha:      s·bado, 11 de noviembre de 2006, 14:49:59
//--------------------------------------------------------------------
void CTextFont::Init(char* szTexture, char* szSizeFile)
{
	Log("+++ CTextFont::Init Cargando TextFont: %s %s\n", szTexture, szSizeFile);
	
	m_pTexture = new CTexture();
	m_pTexture->LoadFromFile(szTexture);
	
	NSString * path = [[NSBundle mainBundle] pathForResource:  [NSString stringWithCString: szSizeFile encoding: [NSString defaultCStringEncoding]] ofType: @"dat"];
		
	FILE* pFile = fopen([path cStringUsingEncoding:1],"r");

	if(pFile == NULL)
	{ 
		Log("--- CTextFont::Init Imposible abrir font size file: %s\n", szSizeFile);
		return;
	} 

	fread(m_SizeArray, sizeof(u8), 256, pFile); 

	m_SizeArray[0] = 10;
	
	fclose(pFile);

	Log("+++ CTextFont::Init correcto\n");
}

/********************************************************************/
/********************************************************************/
/*						End TextFont.cpp							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////


