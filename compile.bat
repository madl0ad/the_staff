avr-gcc -std=c99 -Os -mmcu=atxmega128a3  -Wall -foptimize-sibling-calls -fdata-sections -ffunction-sections -Wl,-gc-sections %~1 -o %~1.elf
avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock %~1.elf %~1.hex
rm %~1.elf