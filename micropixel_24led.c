// t13	atxmega128a3u	38400 prog
// board	MMCU		programm_after_make

//
#define F_CPU 8000000

#define FRAME_DELAY 1.5
#define MAX_LEVEL	255
#define HALF_LEVEL	60
#define PACK_SIZE	68

#define GND_PIN 	2	// 2 //key to connect led's ground
#define DATA_PIN	5	// 0
#define CLK_PIN		7	// 1

//buttons
#define BUTTON_PIN	PORTE_IN
#define BUTTON_1	5

#define DRRB PORTB_DIR
#define PORTB PORTB_OUT
#define PINB PORTB_IN

#define PORT_MASK	((1<<BUTTON_1)+(1<<GND_PIN))

#include "apa102-driver-2.c"

#include <avr/io.h>

#include <util/delay.h>

#include "palette_7__.c"

#include <avr/eeprom.h>

void formColorPack( unsigned char n, struct RGB* color, rgb_pointer pack[], unsigned char mask  );
void formColorPack_scheme( unsigned char n, rgb_pointer color[], rgb_pointer pack[], unsigned char mask  );

//modes
#define MODE_NUM	12
#define S_NUM	11*

unsigned char mode;
unsigned char s, ss;
unsigned char power;

EEMEM unsigned char	e_mode;
EEMEM unsigned char	e_serie;
EEMEM unsigned char	e_s_serie;
EEMEM unsigned char	e_power;

#define INC_DELAY	10
#define S_DELAY		100
#define P_DELAY		500

#define PRESSED			1
#define NOT_PRESSED		0

unsigned char process_button( unsigned int hold, unsigned int state);
unsigned char check_button();

#define LED_NUM	PACK_SIZE

// somy service vars
//rgb_pointer pack[PACK_SIZE];
//rgb_pointer scheme[PACK_SIZE];
unsigned char r[PACK_SIZE];
unsigned char g[PACK_SIZE];
unsigned char b[PACK_SIZE];
unsigned char mask[PACK_SIZE+1];

	rgb_pointer *pal;
	
unsigned char bbb=0;


void mode_1();
void mode_2();				
void mode_3();
void mode_4();
void mode_5();
void mode_6();
void mode_7();			
void mode_8();
void mode_9();			
void mode_10();					
void demo();	
void heart();
void binary();

unsigned char const_light( unsigned char sch,  unsigned char delay );

void flush_mask(){
	unsigned char i;
	for ( i=0; i<=LED_NUM; i++ )	mask[i]=0;
}

void fill_mask(){
	unsigned char i;
	for ( i=0; i<=(LED_NUM); i++ )	mask[i]=1;
}

void make_serie(unsigned char sss){
	switch (sss){
			case 1:
				mode_1();
				break;;
			case 2:
				mode_2();
				break;;
			case 3:
				mode_3();
				break;;
		}
		
		switch (sss){
			case 4:
				mode_4();
				break;;
			case 5:
				mode_5();
				break;;
			case 6:
				mode_6();
				break;;
		}
		switch (sss){
			case 7:
				mode_7();
				break;;		
			case 8:
				mode_8();
				break;;	
			case 9:
				mode_9();
				break;;							
			case 10:
				mode_10();
				break;;
		}
		switch (sss){
			case 11:
				binary();
				break;;
			case 12:
				demo();
				break;;
		}
	
}

int main(){
	
	mode = eeprom_read_byte(&e_mode);//Чтение
	s = eeprom_read_byte(&e_serie);//Чтение
	ss = eeprom_read_byte(&e_s_serie);//Чтение
	power = eeprom_read_byte(&e_power);//Чтение
	
	if (mode>MODE_NUM){
		mode=1;
	}
	
	if (s>=S_NUM+1){
		s=1;
	}
	
	if (ss>1){
		ss=0;
	}
	
	if (power>1) {
		power=1;
	}
	
	PORTB_DIR=255;
	PORTB_OUT=0;
	
	PORTC_DIR=255;
	LED_PORT=0;
	
	for(;;){
		if(bbb>0) mode = ++mode > MODE_NUM ? 1 : mode;
		
		bbb=0;
		
		goinglight(100);
		
		
		
		if (ss==1){
			if ( ++s >= S_NUM+1 ){
				s=1;
			} 	
		}
		
		 if (power==1){
			 //pal=palette;
			 mr=fr;
			 mg=fg;
			 mb=fb;
		 } else {
			 //pal=h_palette;
			 mr=hr;
			 mg=hg;
			 mb=hb;			 
		 }
	}
	
	return 0;
}

void formColorPack_scheme( unsigned char n, rgb_pointer color[], rgb_pointer pack[], unsigned char mask  ){
	unsigned char i;
	for (i=0; i<n; i++){
		pack[i]= pal[0];
		if ( (i<8) && ( (mask&(1<<i))==(1<<i) ) ) pack[i]=color[i];
	}	
}

void mode_1(){	// const
	//unsigned char i;
	fill_mask();
	const_light(s, 10 );
}

void mode_2(){	// strob
	//unsigned char i;
	fill_mask();
	const_light(s, 10 );

	flush_mask();
	const_light(s, 10 );
}

void mode_3(){	// gears
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i<=12 ) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i<=12 ) mask[i]=0; else mask[i]=1;
	}
	const_light(s, 10 );
}

void mode_4(){	// not really flower
	unsigned static a;
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i==1 || i==LED_NUM-a || i==1 || i==LED_NUM) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>LED_NUM) a=0;
}

void mode_5(){	// flower
	unsigned static a;
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i<=a || i==0 || i==LED_NUM) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>LED_NUM) a=0;
}

void mode_6(){	// chess
	unsigned static a;
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( (i & 2)>0 ) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>LED_NUM) a=0;
}

void mode_7(){	// romb
	unsigned static a;
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i>a && i<(LED_NUM-a) ) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>12) a=0;
}

void mode_8(){	// anti romb
	unsigned static a;
	unsigned char i;
	for ( i=1; i<=LED_NUM; i++ ) {
		if ( i<a || i>(LED_NUM-a) ) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>12) a=0;
}

void goinglight(int del, int pause)
{
	for (int i = 0; i<PACK_SIZE; i++)
	{
		if(i!=0) mask[i-1] = 0;
		mask[i] = 1;
		const_light(s,del);
	}
}

void mode_9(){
	switch (s){
		case 1:
		
		case 2:
		
		case 3:
		
		case 4:
		
		case 5:
		
		case 6:
		
		case 7:
		
		case 8:
		
		case 9:
		
		case 10:
		
		case 11:
		break;
	}
}

void mode_10(){}

void binary(){
	unsigned static a;
	unsigned char i;
	for ( i=0; i<LED_NUM; i++ ) {
		if ( (i & a)>0 ) mask[i]=1; else mask[i]=0;
	}
	const_light(s, 10 );
	if (++a>LED_NUM) a=0;
}

unsigned char check_button(){
	
	static unsigned int hold=0;
	static unsigned char button_state=NOT_PRESSED;
	static unsigned char last_button_state=NOT_PRESSED;
	
	unsigned char	st=BUTTON_PIN;
	unsigned char res=0;
	
	button_state=NOT_PRESSED;
	
	if ( ( (st &  (1<<BUTTON_1))  == (0<<BUTTON_1) ) ) {
		button_state = PRESSED;
	}
	
	if ( button_state == PRESSED ){
		hold++;
	}
	
	if ( last_button_state == button_state ){
		res = process_button( hold, button_state );
	}
	
	if ( button_state == NOT_PRESSED &&  last_button_state == NOT_PRESSED ){
		hold=0;
	}
	
	last_button_state=button_state;

	//res=button_state;
	return res;
}

unsigned char  const_light( unsigned char sch,  unsigned char delay){
	
	unsigned char i, j;
			 
	if (bbb==1) return 1;
	
	for (i=0; i<delay; i++){
		if (sch<8){
			for (j=0; j<LED_NUM; j++){
				r[j]=mr[sch];
				g[j]=mg[sch];
				b[j]=mb[sch];
				mask[j]=2;
			}
			//if ( check_button()==1 ) return 1;
		} else {
			// тут нужно забить цветовые схемы
			// и как-то вообще придумать, как их реализовать

			//formColorPack_scheme(LED_NUM, scheme, pack, mask);
			switch (sch){
				case 8:
					for (j=0; j<6; j++){
						if (power==1){
							r[j]=150; r[j+6]=0; r[j+12]=255;
							g[j]=150; g[j+6]=0; g[j+12]=0;
							b[j]=150; b[j+6]=255; b[j+12]=0;
						} else {
							r[j]=50; r[j+6]=0; r[j+12]=100;
							g[j]=50; g[j+6]=0; g[j+12]=0;
							b[j]=50; b[j+6]=100; b[j+12]=0;
						}
					}
					break;
				case 9:
					for (j=0; j<18; j+=3){
						if (power==1){
							r[j]=255; r[j+1]=0; r[j+2]=0;
							g[j]=0; g[j+1]=0; g[j+2]=255;
							b[j]=0; b[j+1]=255; b[j+2]=0;
						} else {
							r[j]=100; r[j+1]=0; r[j+2]=0;
							g[j]=0; g[j+1]=0; g[j+2]=100;
							b[j]=0; b[j+1]=100; b[j+2]=0;
						}
					}
					break;
				case 10:
					for (j=0; j<18; j++){
						if (power==1){
							r[j]=255; 
							g[j]=255-i*14; 
							b[j]=255; 
						} else {
							r[j]=100; 
							g[j]=100-i*7; 
							b[j]=100; 
						}
					}
					break;
				case 11:
					for (j=0; j<18; j++){
						if (power==1){
							r[j]=0; 
							g[j]=i*14; 
							b[j]=255-i*14; 
						} else {
							r[j]=0; 
							g[j]=i*7; 
							b[j]=100-i*7; 
						}
					}
					break;
			}
		}		
			
		if ( check_button()==1 ) {
			bbb=1;
			return 1;	
		}
		sendRawRGBpack(LED_NUM, r, g, b, mask);	
	}
	
	return 0;
}

unsigned char process_button( unsigned int hold, unsigned int state){
	if ( hold > P_DELAY ){
		if ( state == NOT_PRESSED ){
			if (++power>1) power=0;
			eeprom_write_byte(&e_power, power);	// processed in main
			return 1;
		}
	} else if ( hold > S_DELAY ){	// next serie
		if ( state == NOT_PRESSED ){
			if ( ++mode > MODE_NUM ) { 
				mode=1; 
			}
			
			eeprom_write_byte(&e_mode,   mode);//Запись

			return 1;
		}		
	}  else if ( hold > INC_DELAY ){	// next mode
		if ( state == NOT_PRESSED ){
			if (ss==1){
				ss=0;
				s=1;
			} else 	
				if ( ++s >= S_NUM+1 ){
				s=1;
				ss=1;
			} 	
			
			eeprom_write_byte(&e_mode,   mode);//Запись
			eeprom_write_byte(&e_serie,   s);//Запись
			eeprom_write_byte(&e_s_serie,   ss);//Запись	
			
			return 1;
		}
		
	}
	
	return 0;
}


#define SP_L	2
#define	SB_L	1










void demo(){
	static unsigned char mmm=1;
	static unsigned char nnn=1;
	//s=1;
	
	make_serie(mmm);
	nnn++;
	
	if (nnn>10){
		s++;
		nnn=1;
	}
	
	if (s>=S_NUM+1){
		mmm++;
		s=1;
	}
	
	if (mmm>=MODE_NUM){
		mmm=0;
	}
	
}
