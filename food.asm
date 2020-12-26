;This code is for drawing the food in random location for a specific time
.model small
.Stack 64
.data 
phases dw 7 dup(?)
phase_num dw ?
phase_size db 7
stop_x dw ?
stop_y dw ?
temp_cx dw ?
temp_dx dw ?
imgW equ 9
imgH equ 9
; pixels colors of the images
img DB 29, 4, 4, 4, 4, 4, 4, 4, 112, 29, 31, 4, 4, 4, 4, 4, 112, 112, 29, 31, 31, 4, 4, 4, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 44
 DB 44, 44, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 40, 40, 40, 112, 112, 112, 29, 31, 40, 40, 40, 40, 40, 112, 112, 29, 4, 4, 4, 4, 4, 4, 4
 DB 112

;image phases for animation
;phase 2
img2 DB 29, 4, 4, 4, 4, 4, 4, 4, 31, 29, 31, 4, 4, 4, 4, 4, 31, 31, 29, 31, 31, 4, 4, 4, 112, 31, 31, 29, 31, 31, 44, 44, 44, 112, 31, 31, 29, 31, 31, 44
 DB 44, 44, 112, 31, 31, 29, 31, 31, 44, 44, 44, 112, 31, 31, 29, 31, 31, 40, 40, 40, 112, 31, 31, 29, 31, 40, 40, 40, 40, 40, 31, 31, 29, 4, 4, 4, 4, 4, 4, 4
 DB 31

;phase 3
img3 DB 29, 4, 4, 4, 4, 4, 4, 31, 31, 29, 31, 4, 4, 4, 4, 4, 31, 112, 29, 31, 31, 4, 4, 4, 31, 31, 112, 29, 31, 31, 44, 44, 44, 31, 31, 112, 29, 31, 31, 44
 DB 44, 44, 31, 31, 112, 29, 31, 31, 44, 44, 44, 31, 31, 112, 29, 31, 31, 40, 40, 40, 31, 31, 112, 29, 31, 40, 40, 40, 40, 40, 31, 112, 29, 4, 4, 4, 4, 4, 4, 31
 DB 31

;phase 4
img4 DB 29, 4, 4, 4, 4, 4, 4, 31, 112, 29, 31, 4, 4, 4, 4, 31, 112, 112, 29, 31, 31, 4, 4, 31, 31, 112, 112, 29, 31, 31, 44, 44, 31, 31, 112, 112, 29, 31, 31, 44
 DB 44, 31, 31, 112, 112, 29, 31, 31, 44, 44, 31, 31, 112, 112, 29, 31, 31, 40, 40, 31, 31, 112, 112, 29, 31, 40, 40, 40, 40, 31, 112, 112, 29, 4, 4, 4, 4, 4, 4, 31
 DB 112

;phase 5
img5 DB 29, 4, 31, 31, 31, 31, 31, 4, 112, 29, 31, 4, 31, 31, 31, 4, 112, 112, 29, 31, 31, 4, 31, 4, 112, 112, 112, 29, 31, 31, 44, 31, 44, 112, 112, 112, 29, 31, 31, 44
 DB 31, 44, 112, 112, 112, 29, 31, 31, 44, 31, 44, 112, 112, 112, 29, 31, 31, 40, 31, 40, 112, 112, 112, 29, 31, 40, 31, 31, 31, 40, 112, 112, 29, 4, 31, 31, 31, 31, 31, 4
 DB 112

;phase 6
img6 DB 29, 31, 31, 4, 4, 4, 4, 4, 112, 29, 31, 31, 31, 4, 4, 4, 112, 112, 29, 31, 31, 31, 4, 4, 112, 112, 112, 29, 31, 31, 31, 44, 44, 112, 112, 112, 29, 31, 31, 31
 DB 44, 44, 112, 112, 112, 29, 31, 31, 31, 44, 44, 112, 112, 112, 29, 31, 31, 31, 40, 40, 112, 112, 112, 29, 31, 31, 31, 40, 40, 40, 112, 112, 29, 31, 31, 4, 4, 4, 4, 4
 DB 112
;phase 7
img7 DB 29, 4, 4, 4, 4, 4, 4, 4, 112, 29, 31, 4, 4, 4, 4, 4, 112, 112, 29, 31, 31, 4, 4, 4, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 44
 DB 44, 44, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 40, 40, 40, 112, 112, 112, 29, 31, 40, 40, 40, 40, 40, 112, 112, 29, 4, 4, 4, 4, 4, 4, 4
 DB 112

.CODE
change_x_y proc
xor ax, ax
int 1ah			;get random value from the ticks of the clock cx:dx
mov bl, dl		;put the most changable byte of dx in bl
int 1ah			;call the same interrupt to get another value in dx
mov bh, dl		;put the most changable byte of dx in bl again
mov ax, bx		;mov the random value to reg ax from bx

mov dx, 00h
mov bx, 641		;the width of the screen
div bx			;mod the random value with the width to get a random number from 0 to 640
mov si, dx		;initialize reg si with the value

;get the random value for the y axis
xor dx, dx
xor ax, ax
int 1ah
mov bl, dl
int 1ah
mov bh, dl
mov ax, bx

mov dx, 00h
mov bx, 401		;the height of the screen
div bx			;dx now has the value form 0 to 400
mov cx, si		;mov the value of si to cx as cx changes throught the program

ret
MAIN PROC FAR
		   mov ax, @data
		   mov DS, ax
	       mov ax, 4F02h    ;
	       mov bx, 0100h    ; 640x400 screen graphics mode
	       INT 10h      	;execute the configuration
	       MOV AH,0Bh   	;set the configuration
	       ;MOV CX, imgW  	;set the width (X) up to 64 (based on image resolution)
	       ;MOV DX, imgH 	;set the hieght (Y) up to 64 (based on image resolution)
		   mov phases, offset img
		   mov phases + 2, offset img2
		   mov phases + 4, offset img3
		   mov phases + 6, offset img4
		   mov phases + 8, offset img5
		   mov phases + 10, offset img6
		   mov phases + 12, offset img7
	again:
			mov phase_size, 7
			mov phase_num, offset phases
			mov DI, phases  ; to iterate over the pixels
		   call change_x_y	;call function that return random numbers in cx and dx
		   mov stop_x, cx	;copy the values of cx & dx into external variables
		   mov stop_y, dx
		   mov temp_cx, cx	;store cx into a variable to reinitialize cx with it
		   mov temp_dx, dx	;store dx value to use it in aniamtion
		   pushf			;push the flag register in case of errors from the following sub. operation
		   sub stop_x, imgW	;subtract the width of the image from cx so as to know where i will stop
		   sub stop_y, imgH
		   popf
	       jmp Start    	;Avoid drawing before the calculations
	Drawit:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
           mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
			cmp cx, stop_x
	       JNZ Drawit      	;  check if we can draw c urrent x and y and excape the y iteration
	       mov Cx, temp_cx 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   cmp dx, stop_y
	       JZ  animate   	;  both x and y reached 00 so end program
		   Jmp Drawit
	click:
			; delay function
			MOV CX, 1eH		;cx:dx is used as a register of the time in microsec.
			MOV DX, 8480H
			MOV AH, 86H	
			INT 15H			;delay interrupt int 15h / ah = 86h
			; clear the screen
			mov ax, 4F02h    
			mov bx, 0100h    
			INT 10h
			jmp again
	animate:
			MOV CX, 3H		;cx:dx is used as a register of the time in microsec.
			MOV DX, 00d40H
			MOV AH, 86H	
			INT 15H
			
			dec phase_size
			cmp phase_size, 0
			jz click
			mov bx, phase_num
			add bx, 2
			mov phase_num, bx
			mov di, [bx]
			mov cx, temp_cx
			mov dx, temp_dx
			jmp Drawit

	ENDING:
	MAIN ENDP
	END MAIN

