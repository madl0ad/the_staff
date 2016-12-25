// include somwhere after "apa102-driver.c"
// disigned foe micropixel series

//#include "apa102-driver.c"

#ifndef PALETTE_7

#define PALETTE_7

#ifndef MAX_LEVEL
	#define MAX_LEVEL	255
#endif

#ifndef HALF_LEVEL
	#define HALF_LEVEL	100
#endif

#define black 	0
#define red 	1
#define yellow 	2
#define green 	3
#define aqua 	4
#define blue 	5
#define violet	6
#define white	7
#define combo 	8

unsigned char fr[8]={0, 255, 255, 0, 0, 0, 255, 255 };
unsigned char fg[8]={0, 0, 255, 255, 255, 0, 0, 255 };
unsigned char fb[8]={0, 0, 0, 0, 255, 255, 255, 255 };

unsigned char hr[8]={0, 100, 100, 0, 0, 0, 100, 100 };
unsigned char hg[8]={0, 0, 100, 100, 100, 0, 0, 100 };
unsigned char hb[8]={0, 0, 0, 0, 100, 100, 100, 100 };

unsigned char *mr;
unsigned char *mg;
unsigned char *mb;
#endif
