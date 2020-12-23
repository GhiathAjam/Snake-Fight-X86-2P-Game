        .MODEL LARGE
        .STACK 64
       ; #include mymacros.inc

;-------------------------------------------------------------------------------------------------
;----------------------DATA SEGMENT----------------------------------
;-------------------------------------------------------------------------------------------------
        .DATA

ScreenWidth     DW  320d
ScrX            DW  320d
ScreenHighet    DW  200d
ScrY            DW  200d

; expand points by SnakeWidth in all 8 directions
SnakeWidth      DW  3                                                          
SquareWidth     DW  ?

; num of points for Snake 1
Sz1             DW  15h
; 0 for left / 1 for up / 2 for right / 3 for down
DirS1           DW  0
; points  of snake (snakewidth*2 away from each other)
S1X             DW  6400d dup(?)            
S1Y             DW  6400d dup(?)

; Snake 2
Sz2             DW  5
DirS2           DW  2
S2X             DW  6400d dup(?)
S2Y             Dw  6400d dup(?)

clrs1           equ      1100b
clrs2           equ      1001b

;-------------------------------------------------------------------------------------------------
;----------------------CODE SEGMENT----------------------------------
;-------------------------------------------------------------------------------------------------
    .code
;-------------------------------------------------
;----------------------DRAW SQUARE--------------
;-------------------------------------------------
drawSqr              PROC    FAR                             

        ;-------------------------------------------------
                        push si
                        push di
                        xor si,si
                        
        draw_outer:
                        cmp si,SquareWidth
                        jg draw_eee
                        XOR DI,DI

        draw_inner:  
                        cmp di,SquareWidth
                        jg draw_outerr

                        add cx,si
                        add dx,di
                        int 10h

                        sub dx,di
                        sub dx,di
                        int 10h

                        sub cx,si
                        sub cx,si
                        int 10h

                        add dx,di
                        add dx,di
                        int 10h

                        add cx,si
                        sub dx,di

                        inc di
                        jmp draw_inner

        draw_outerr:   
                        inc si
                        cmp si,SquareWidth
                        jnz draw_outer

        draw_eee:     
                        pop di
                        pop si
        ;-------------------------------------------------
;
;INT 10h / AH = 0Ch - change color for a single pixel.
;input:
;AL = pixel color
;CX = column.
;DX = row.                
                        RET
drawSqr              ENDP

;-------------------------------------------------
;----------------------INIT FUNC--------------
;-------------------------------------------------
INIT                    PROC FAR
        ; Y of all points
        mov dx,ScrY
        sub dx,SnakeWidth               
        sub dx,15

        ; common X factor of all points in snake1
        mov ax,ScrX
        sub ax,10
        mov cx,Sz1
initlpp:        sub ax,SnakeWidth
                LOOP initlpp
        mov cx,Sz1
initlpp2:       sub ax,SnakeWidth
                LOOP initlpp2

        ; parameters for loop
        mov cx,Sz1
        lea si,S1X
        lea di,S1Y

init_L1:     
        mov [si],ax
        mov [di],dx

        add ax,SnakeWidth
        add ax,SnakeWidth
        add si,2
        add di,2
        LOOP init_L1

        ; drawing snake1        //al = color ,          SquareWidth ,   CX=X    DX=Y
        mov ah,0ch
        mov al,clrs1
        mov cx,SnakeWidth
        mov SquareWidth,cx
        lea SI,S1X
        lea Di,S1Y
        mov Bx,Sz1

init_draws1:
                mov cx,[si]
                mov dx,[di]
                CALL drawSqr
                add si,2
                add di,2
                dec BX
                jnz init_draws1

;---------------------------------------
; snake 2

        ; common X factor of all points in snake2
        mov ax,SnakeWidth
        add ax,10

        ; parameters for loop
        mov cx,Sz2
        lea si,S2X
        lea di,S2Y

init_ll2:
        add ax,SnakeWidth
        add ax,SnakeWidth
        LOOP init_ll2

        mov cx,Sz2
init_L2:
        mov [si],ax
        mov [di],dx

        sub ax,SnakeWidth
        sub ax,SnakeWidth
        add si,2
        add di,2
        LOOP init_L2

        ; drawing snake2        //al = color ,          SquareWidth ,   CX=X    DX=Y
        mov ah,0ch
        mov al,clrs2
        mov cx,SnakeWidth
        mov SquareWidth,cx
        lea SI,S2X
        lea Di,S2Y
        mov Bx,Sz2

init_draws2:
                mov cx,[si]
                mov dx,[di]
                CALL drawSqr
                add si,2
                add di,2
                dec BX
                jnz init_draws2

INIT                   ENDP

;-------------------------------------------------
;----------------------ADVANCE SNAKE FUNC--------------
;-------------------------------------------------
advancesnakes           PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
          
                mov ax,SnakeWidth
                mov SquareWidth,ax

;---------------ERASING TAIL SNAKE1
                mov ax,Sz1
                mov bl,2
                mul bl
                sub ax,2
                mov bx,ax
                add bx,offset S1X
                mov cx,[bx]
                sub bx,offset S1X
                add bx,offset S1Y
                mov dx,[bx]

                mov ah,0ch
                mov al,0                ;black
                CALL drawSqr

;---------------ERASING TAIL SNAKE2
                mov ax,Sz2
                mov bl,2
                mul bl
                sub ax,2
                mov bx,ax
                add bx,offset S2X
                mov cx,[bx]
                sub bx,offset S2X
                add bx,offset S2Y
                mov dx,[bx]

                mov ah,0ch
                mov al,0                ;black
                CALL drawSqr

;       SHIFTING ALL S1X VALUES RIGHT FOR NEW HEAD POINT
                mov ax,Sz1
                mov bl,2
                mul bl
                sub ax,2

                mov si,offset S1X
                mov di,offset S1Y
                add si,ax
                add di,ax
                mov cx,Sz1
                dec cx
advance_shift1:
                mov ax,[si-2]
                mov [si],ax
                mov ax,[di-2]
                mov [di],ax

                sub si,2
                sub di,2
                LOOP advance_shift1
;-------------------------------------------------
;       SNAKE 2
                mov ax,Sz2
                mov bl,2
                mul bl
                sub ax,2

                mov si,offset S2X
                mov di,offset S2Y
                add si,ax
                add di,ax
                mov cx,Sz2
                dec cx
advance_shift2:
                mov ax,[si-2]
                mov [si],ax
                mov ax,[di-2]
                mov [di],ax

                sub si,2
                sub di,2
                LOOP advance_shift2
;-------------------------------------------------
;-------------------------------------------------

;       SETTING NEW HEAD

                ; original head in (si,di)
                mov si,S1X+2
                mov di,S1Y+2

                mov bx,DirS1
                and bx,bx
                jz advance_left
                cmp bx,1
                jz advance_up
                cmp bx,2
                jz advance_right

advance_down:                                   ; move y down
                add di,SnakeWidth
                add di,SnakeWidth
                jmp advance_eee
advance_left:                                   ; move x left
                sub si,SnakeWidth       
                sub si,SnakeWidth
                jmp advance_eee
advance_up:                                     ; move y up
                sub di,SnakeWidth
                sub di,SnakeWidth
                jmp advance_eee
advance_right:                                  ; move x right
                add si,SnakeWidth
                add si,SnakeWidth

advance_eee:
                mov S1X,si
                mov S1Y,Di

                ;DRAWING NEW HEAD
                mov cx,S1X
                mov dx,S1Y
                mov ah,0ch
                mov al,clrs1
                CALL drawSqr

;-------------------------------------------------
;-------SNAKE 2

;       SETTING NEW HEAD

                ; original head in (si,di)
                mov si,S2X+2
                mov di,S2Y+2

                mov bx,DirS2
                and bx,bx
                jz advance_left2
                cmp bx,1
                jz advance_up2
                cmp bx,2
                jz advance_right2

advance_down2:                                   ; move y down
                add di,SnakeWidth
                add di,SnakeWidth
                jmp advance_eee2
advance_left2:                                   ; move x left
                sub si,SnakeWidth       
                sub si,SnakeWidth
                jmp advance_eee2
advance_up2:                                     ; move y up
                sub di,SnakeWidth
                sub di,SnakeWidth
                jmp advance_eee2
advance_right2:                                  ; move x right
                add si,SnakeWidth
                add si,SnakeWidth

advance_eee2:
                mov S2X,si
                mov S2Y,Di

                ;DRAWING NEW HEAD
                mov cx,S2X
                mov dx,S2Y
                mov ah,0ch
                mov al,clrs2
                CALL drawSqr



                        RET
advancesnakes           ENDP
;-------------------------------------------------
;----------------------DRAW ENVIRONMENT--------------
;-------------------------------------------------
drawEnv PROC     FAR

        

        RET
drawEnv ENDP
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||||||||||      MAIN FUNC       ||||||||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

MAIN    PROC FAR               
        MOV AX,@DATA
        MOV DS,AX  
        mov ES,AX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         ; Chg Vid Mode To Grphcs
        mov ah,0                       
        mov al,13h
        int 10h 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        initialize snakes
        CALL init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NEED TO ADD RESTRICTION TO RIGHT AND LEFT (w.r.t SNAKE) ONLY
L1:
        mov ah,0                                ;INT 16h / AH = 01h - check for keystroke in the keyboard buffer.
        int 16h                                 ;return:
        jnz FF                                  ;ZF = 1 if keystroke is not available.
        cmp ah,48h                              ;ZF = 0 if keystroke available.
        jnz AA
        mov DirS1 , 1      
        jmp FF                                  ;AH = BIOS scan code.


AA:     cmp ah,4Bh                              ;AL = ASCII character. 
        jnz BB
        mov DirS1 , 0
        jmp FF

BB:     cmp ah,4Dh                              ;And the scan codes for the arrow keys are:
        jnz CC                                  ;Up: 0x48
        mov DirS1 , 2                           ;Left: 0x4B
        jmp FF                                  ;Right: 0x4D
                                                ;Down: 0x50
CC:     cmp ah,50h
        jnz FF
        mov DirS1 , 3

FF:
        mov cx,0FFFFh                             ;For Frame Wait
WER:    LOOP WER

    ;    mov ah,06h
   ;     mov al,0
  ;      xor cx,cx
 ;       mov dx,0184FH
;        int 10h


        CALL  drawEnv
        ;add clrs1,1
        ;add clrs2,1
        CALL  advancesnakes
        ;CALL  drawsnakes

        jmp L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ah,4ch
        int 21h

MAIN    ENDP

                    END MAIN        ; End of the program  
					