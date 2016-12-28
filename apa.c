
#include <avr/io.h>
#include <util/delay.h>
//#include "apa102-driver-2.c"
#include "palette_7__.c"
#include <avr/eeprom.h>
#define LED_PORT PORTC_OUT
#define GND_PIN 	2	// 2 //key to connect led's ground
#define DATA_PIN	5	// 0
#define CLK_PIN		7	// 1
#define DATA0	0
#define DATA1	1<<DATA_PIN
#define CLOCK0	0
#define CLOCK1	1<<CLK_PIN

#define PACK_SIZE	68
#define LED_PORT PORTC_OUT
#define DATA0	0
#define DATA1	1<<DATA_PIN
#define CLOCK0	0
#define CLOCK1	1<<CLK_PIN
#define BUTTON_PIN	PORTE_IN
#define BUTTON_1	5
#define PORT_MASK	((1<<BUTTON_1)+(1<<GND_PIN))
#define PRESSED			1
#define NOT_PRESSED		0

static char mode;

unsigned char ar[PACK_SIZE];
unsigned char ag[PACK_SIZE];
unsigned char ab[PACK_SIZE];

unsigned char START = 0;
unsigned char END = MAX;

EEMEM unsigned char	e_mode;
EEMEM unsigned char	e_serie;
EEMEM unsigned char	e_s_serie;
EEMEM unsigned char	e_power;

unsigned char INC_DELAY = 2;
unsigned char S_DELAY = 20;

void sendByte(unsigned char a){
	unsigned char i, data, b, mask;
	//unsigned char mask;
	mask=LED_PORT & !(1<<DATA_PIN | 1<<CLK_PIN);
	b=a;
	for (i=0; i<8; i++){
		data=DATA0;
		if (  (b&(1<<(7-i)))>0 ) data=DATA1;
	
		LED_PORT=data | CLOCK0 | mask;
		LED_PORT=data | CLOCK1 | mask;
		LED_PORT=data | CLOCK0 | mask;
	}
}

void delay(int i) //delay proxy function for arduino functions
{_delay_ms(i*10);}



void right() //Sets on only USB side of the stick
{
	START = MAX/2;
	END = MAX;
}

void left() //Sets on only non-USB side of the stick
{
	START = 0;
	END = MAX/2;
}
 
void both() //Sets on both sides of the stick
{
	START = 0;
	END = MAX;
}

void setpixel(int r, int g, int b, int n) //sets pixel n with color (r,g,b). Do not forget to showstrip() after setting all pixels.
{
	n = n>MAX?MAX:(n<1?1:n);
	ar[n-1] = r;
	ag[n-1] = g;
	ab[n-1] = b;
}

void startFrame(){
	sendByte(0);
	sendByte(0);
	sendByte(0);
	sendByte(0);
}

void endFrame(){
	sendByte(255);
	sendByte(255);
	sendByte(255);
	sendByte(255);
}

void write_w(unsigned char a)
{
	sendByte(a);
}

unsigned char process_button( unsigned int hold){
	
	unsigned char mode = eeprom_read_byte(&e_mode), s = eeprom_read_byte(&e_serie), ss = eeprom_read_byte(&e_s_serie);
	if ( hold > S_DELAY ){	// next serie
			if ( ++mode > MODE_NUM ) { 
				mode=1; 
			}
			eeprom_write_byte(&e_mode,   mode);//Запись
			return 1;
			}
	else if ( hold > INC_DELAY ){	// next mode
			if (ss==1){
				ss=0;
				s=1;
			} else 	
				if ( ++s > S_NUM ){
				s=1;
				ss=1;
			} 	
			
			eeprom_write_byte(&e_mode,   mode);//Запись
			eeprom_write_byte(&e_serie,   s);//Запись
			eeprom_write_byte(&e_s_serie,   ss);//Запись	
			
			return 1;
	}
	return 0;
}

unsigned char check_button(){
	static unsigned char last_button_state=NOT_PRESSED;
	static unsigned int hold=0;
	unsigned char res=0, button_state;
	
	button_state=NOT_PRESSED;
	
	if ( (PORTE_IN & (1<<5)) != (1<<5) ) {
			button_state = PRESSED;
	}
	
	if ( button_state == PRESSED ){
		hold++;
	}
	
	if ( (last_button_state == button_state) && (button_state == NOT_PRESSED) ){
		res = process_button( hold );
	}
	
	if ( button_state == NOT_PRESSED && last_button_state == NOT_PRESSED ){
		hold=0;
	}
	last_button_state=button_state;
	return res;
}

void	cl(){ 		//system setup function
	
	OSC_CTRL  = 15; //Setup 32Mhz crystal
    while(!(OSC_RC32KRDY_bm));
    CLK.PSCTRL=0;//'No PreScaler in use
    
    //OSC.XOSCCTRL = 195; //'12-16MHz, 255 Clks
    OSC.PLLCTRL = 24 + 128*0;

//	OSC.DFLLCTRL |= OSC_RC2MCREF_RC32K_gc;
//	OSC.DFLLCTRL = 1;

    OSC_CTRL |= OSC_PLLEN_bm;
	while(!(OSC_STATUS & OSC_PLLRDY_bm));
	
	CCP=CCP_IOREG_gc;      //'Config Change Protection
	CLK.CTRL = 4;       //'Use PLL as Clock Source
} 

void setpixel_c(char i, char j)
{
	switch (i)
			{
				case 0:	setpixel(0,0,0,j);	break;
				case 1:	setpixel(255,0,0,j);	break;
				case 2:	setpixel(0,255,0,j);	break;
				case 3:	setpixel(0,0,255,j);	break;
				case 4:	setpixel(255,255,0,j);	break;
				case 5:	setpixel(0,255,255,j);	break;
				case 6:	setpixel(255,0,255,j);	break;
				case 7:	setpixel(255,255,255,j);	break;
				case 8:	setpixel(128,0,0,j);	break;
				case 9:	setpixel(0,128,0,j);	break;
				case 10:setpixel(0,0,128,j);	break;
				case 11:setpixel(128,128,128,j);	break;
				case 12:setpixel(255,128,0,j);	break;
				case 13:setpixel(128,255,0,j);	break;
				case 14:setpixel(255,0,128,j);	break;
				case 15:setpixel(128,0,255,j);	break;
				case 16:setpixel(0,128,255,j);	break;
				case 17:setpixel(0,255,128,j);	break;
				case 18:setpixel(255,64,64,j);	break;
				case 19:setpixel(64,255,64,j);	break;
				case 20:setpixel(64,64,255,j);	break;
			}
			switch (i)
			{
				case 0:	setpixel(0,0,0,MAX-j);	break;
				case 1:	setpixel(255,0,0,MAX-j);	break;
				case 2:	setpixel(0,255,0,MAX-j);	break;
				case 3:	setpixel(0,0,255,MAX-j);	break;
				case 4:	setpixel(255,255,0,MAX-j);	break;
				case 5:	setpixel(0,255,255,MAX-j);	break;
				case 6:	setpixel(255,0,255,MAX-j);	break;
				case 7:	setpixel(255,255,255,MAX-j);	break;
				case 8:	setpixel(128,0,0,MAX-j);	break;
				case 9:	setpixel(0,128,0,MAX-j);	break;
				case 10:setpixel(0,0,128,MAX-j);	break;
				case 11:setpixel(128,128,128,MAX-j);	break;
				case 12:setpixel(255,128,0,MAX-j);	break;
				case 13:setpixel(128,255,0,MAX-j);	break;
				case 14:setpixel(255,0,128,MAX-j);	break;
				case 15:setpixel(128,0,255,MAX-j);	break;
				case 16:setpixel(0,128,255,MAX-j);	break;
				case 17:setpixel(0,255,128,MAX-j);	break;
				case 18:setpixel(255,64,64,MAX-j);	break;
				case 19:setpixel(64,255,64,MAX-j);	break;
				case 20:setpixel(64,64,255,MAX-j);	break;
			}
}

void setpixel_cv(unsigned char i, unsigned char j)
{
switch (i)
{
case 0: setpixel(0,0,0, j); break;
case 1: setpixel(0,0,64, j); break;
case 2: setpixel(0,0,128, j); break;
case 3: setpixel(0,0,192, j); break;
case 4: setpixel(0,0,255, j); break;
case 5: setpixel(0,64,0, j); break;
case 6: setpixel(0,64,64, j); break;
case 7: setpixel(0,64,128, j); break;
case 8: setpixel(0,64,192, j); break;
case 9: setpixel(0,64,255, j); break;
case 10: setpixel(0,128,0, j); break;
case 11: setpixel(0,128,64, j); break;
case 12: setpixel(0,128,128, j); break;
case 13: setpixel(0,128,192, j); break;
case 14: setpixel(0,128,255, j); break;
case 15: setpixel(0,192,0, j); break;
case 16: setpixel(0,192,64, j); break;
case 17: setpixel(0,192,128, j); break;
case 18: setpixel(0,192,192, j); break;
case 19: setpixel(0,192,255, j); break;
case 20: setpixel(0,255,0, j); break;
case 21: setpixel(0,255,64, j); break;
case 22: setpixel(0,255,128, j); break;
case 23: setpixel(0,255,192, j); break;
case 24: setpixel(0,255,255, j); break;
case 25: setpixel(64,0,0, j); break;
case 26: setpixel(64,0,64, j); break;
case 27: setpixel(64,0,128, j); break;
case 28: setpixel(64,0,192, j); break;
case 29: setpixel(64,0,255, j); break;
case 30: setpixel(64,64,0, j); break;
case 31: setpixel(64,64,64, j); break;
case 32: setpixel(64,64,128, j); break;
case 33: setpixel(64,64,192, j); break;
case 34: setpixel(64,64,255, j); break;
case 35: setpixel(64,128,0, j); break;
case 36: setpixel(64,128,64, j); break;
case 37: setpixel(64,128,128, j); break;
case 38: setpixel(64,128,192, j); break;
case 39: setpixel(64,128,255, j); break;
case 40: setpixel(64,192,0, j); break;
case 41: setpixel(64,192,64, j); break;
case 42: setpixel(64,192,128, j); break;
case 43: setpixel(64,192,192, j); break;
case 44: setpixel(64,192,255, j); break;
case 45: setpixel(64,255,0, j); break;
case 46: setpixel(64,255,64, j); break;
case 47: setpixel(64,255,128, j); break;
case 48: setpixel(64,255,192, j); break;
case 49: setpixel(64,255,255, j); break;
case 50: setpixel(128,0,0, j); break;
case 51: setpixel(128,0,64, j); break;
case 52: setpixel(128,0,128, j); break;
case 53: setpixel(128,0,192, j); break;
case 54: setpixel(128,0,255, j); break;
case 55: setpixel(128,64,0, j); break;
case 56: setpixel(128,64,64, j); break;
case 57: setpixel(128,64,128, j); break;
case 58: setpixel(128,64,192, j); break;
case 59: setpixel(128,64,255, j); break;
case 60: setpixel(128,128,0, j); break;
case 61: setpixel(128,128,64, j); break;
case 62: setpixel(128,128,128, j); break;
case 63: setpixel(128,128,192, j); break;
case 64: setpixel(128,128,255, j); break;
case 65: setpixel(128,192,0, j); break;
case 66: setpixel(128,192,64, j); break;
case 67: setpixel(128,192,128, j); break;
case 68: setpixel(128,192,192, j); break;
case 69: setpixel(128,192,255, j); break;
case 70: setpixel(128,255,0, j); break;
case 71: setpixel(128,255,64, j); break;
case 72: setpixel(128,255,128, j); break;
case 73: setpixel(128,255,192, j); break;
case 74: setpixel(128,255,255, j); break;
case 75: setpixel(192,0,0, j); break;
case 76: setpixel(192,0,64, j); break;
case 77: setpixel(192,0,128, j); break;
case 78: setpixel(192,0,192, j); break;
case 79: setpixel(192,0,255, j); break;
case 80: setpixel(192,64,0, j); break;
case 81: setpixel(192,64,64, j); break;
case 82: setpixel(192,64,128, j); break;
case 83: setpixel(192,64,192, j); break;
case 84: setpixel(192,64,255, j); break;
case 85: setpixel(192,128,0, j); break;
case 86: setpixel(192,128,64, j); break;
case 87: setpixel(192,128,128, j); break;
case 88: setpixel(192,128,192, j); break;
case 89: setpixel(192,128,255, j); break;
case 90: setpixel(192,192,0, j); break;
case 91: setpixel(192,192,64, j); break;
case 92: setpixel(192,192,128, j); break;
case 93: setpixel(192,192,192, j); break;
case 94: setpixel(192,192,255, j); break;
case 95: setpixel(192,255,0, j); break;
case 96: setpixel(192,255,64, j); break;
case 97: setpixel(192,255,128, j); break;
case 98: setpixel(192,255,192, j); break;
case 99: setpixel(192,255,255, j); break;
case 100: setpixel(255,0,0, j); break;
case 101: setpixel(255,0,64, j); break;
case 102: setpixel(255,0,128, j); break;
case 103: setpixel(255,0,192, j); break;
case 104: setpixel(255,0,255, j); break;
case 105: setpixel(255,64,0, j); break;
case 106: setpixel(255,64,64, j); break;
case 107: setpixel(255,64,128, j); break;
case 108: setpixel(255,64,192, j); break;
case 109: setpixel(255,64,255, j); break;
case 110: setpixel(255,128,0, j); break;
case 111: setpixel(255,128,64, j); break;
case 112: setpixel(255,128,128, j); break;
case 113: setpixel(255,128,192, j); break;
case 114: setpixel(255,128,255, j); break;
case 115: setpixel(255,192,0, j); break;
case 116: setpixel(255,192,64, j); break;
case 117: setpixel(255,192,128, j); break;
case 118: setpixel(255,192,192, j); break;
case 119: setpixel(255,192,255, j); break;
case 120: setpixel(255,255,0, j); break;
case 121: setpixel(255,255,64, j); break;
case 122: setpixel(255,255,128, j); break;
case 123: setpixel(255,255,192, j); break;
case 124: setpixel(255,255,255, j); break;
}
}


void init()
{
	PORTC_DIR=255;
	PORTE_DIR=0;
	mode=eeprom_read_byte(&e_mode);
	if (mode>MODE_NUM || mode<1) mode=1;
	//setUp32MhzInternalOsc();
	cl();
	//PORTE.PIN5CTRL = PORT_ISC_BOTHEDGES_gc;
	//PORTE.INT0MASK = PIN5_bm;
	//PORTE.INTCTRL = PORT_INT0LVL_LO_gc;
	//PMIC.CTRL |= PMIC_LOLVLEN_bm;
	/*TCC0.CNT = 0;// Zeroise count
	TCC0.PER = 150; //Period      
	TCC0.CTRLA = TC_CLKSEL_DIV1024_gc; //Divider 
	TCC0.INTCTRLA = TC_OVFINTLVL_LO_gc; //Liow level interrupt
	TCC0.INTFLAGS = 0x01; // clear any initial interrupt flags 
	TCC0.CTRLB = TC_WGMODE_NORMAL_gc; // Normal operation
    sei();*/
	return;
}

//					GREEN			RED				BLUE

void write_c_def(int r, int g, int b) // immediately prints a single pixel with color (r,g,b)
{
	write_w(255); //Brightness to be implemented
	write_w(b);
	write_w(g);
	write_w(r);
}


void drop() //clears LED color array
{
	for (int i = 0; i < MAX; i++)
	{
		ar[i] = 0;
		ag[i] = 0;
		ab[i] = 0;
	}
}

void showstrip() //Shows defined LED colors, set by setpixel();
{
	startFrame();
	for (int i = 0; i < MAX; i++)
	{
		write_c_def(ar[i], ag[i], ab[i]);
	}
	endFrame();
}