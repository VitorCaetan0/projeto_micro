.text /* executable code follows */
.global _start
_start:
/* set up stack pointer */
movia sp, 0x007FFFFC /* stack starts from highest memory address in SDRAM */
movia r6, 0x10001000 /* JTAG UART base address */
/* print a text string */
movia r8, TEXT_STRING

/*registradores */
movia r9, 0x0030
movia r10, 0x0031    
movia r11, 0x0032

LOOP:
ldb r5, 0(r8)
beq r5, zero, GET_JTAG /* string is null-terminated */
call PUT_JTAG
addi r8, r8, 1
br LOOP

/* read and echo characters */
GET_JTAG:
ldwio r4, 0(r6) /* read the JTAG UART Data register */
andi r8, r4, 0x8000 /* check if there is new data */
beq r8, r0, GET_JTAG /* if no data, wait */
andi r5, r4, 0x00ff /* the data is in the least significant byte */
call PUT_JTAG /* echo character */
br GET_JTAG

PUT_JTAG:
/* save any modified registers */
subi sp, sp, 4 /* reserve space on the stack */
stw r4, 0(sp) /* save register */
ldwio r4, 4(r6) /* read the JTAG UART Control register */
andhi r4, r4, 0xffff /* check for write space */
beq r4, r0, END_PUT /* if no space, ignore the character */
stwio r5, 0(r6) /* send the character */
END_PUT:

SWITCH:
beq r5, r9, LEDS
beq r5,r10, TRIANG
beq r5,r11, CRONO

/* restore registers */
ldw r4, 0(sp)
addi sp, sp, 4
ret

.data /* data follows */
TEXT_STRING:
.asciz "\nEntre com o comando:\n> "
.end