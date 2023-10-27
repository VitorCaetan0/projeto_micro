.global LEDS

movia r12,0x10000010
movia r13,0x1

LEDS:

stwio 0x1, 0(r12)

ret