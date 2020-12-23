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
SnakeWidth      DW  5                                                          

; num of points for Snake 1
Sz1             EQU  5
; 0 for left / 1 for up / 2 for right / 3 for down
DirS1           DW  0
; points  of snake (snakewidth*2 away from each other)
S1X             DW  6400d dup(?)            
S1Y             DW  6400d dup(?)

; Snake 2
Sz2             EQU  5
DirS2           DW  2
S2X             DW  6400d dup(?)
S2Y             Dw  6400d dup(?)

;-------------------------------------------------------------------------------------------------
;----------------------CODE SEGMENT----------------------------------
;-------------------------------------------------------------------------------------------------
    .code

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

;-------------------
; snake 2

        ; common X factor of all points in snake2
        mov ax,SnakeWidth
        add ax,10

        ; parameters for loop
        mov cx,Sz2
        lea si,S2X
        lea di,S2Y

init_L2:
        mov [si],ax
        mov [di],dx

        add ax,SnakeWidth
        add ax,SnakeWidth
        add si,2
        add di,2
        LOOP init_L2


INIT                   ENDP

;-------------------------------------------------
;----------------------ADVANCE SNAKE FUNC--------------
;-------------------------------------------------

advancesnakes1xright          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S1X
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        sub ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes1xright           ENDP

advancesnakes1xleft          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S1X
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        add ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes1xleft           ENDP

advancesnakes2xleft          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S2X
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        add ax,sz2*2
        mov [bx],ax
                        RET
advancesnakes2xleft           ENDP

advancesnakes2xright          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S2X
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        sub ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes2xright           ENDP
;-------------------------------------------------
;----------------------ADVANCE SNAKE FUNC(y-axis)--------------
;-------------------------------------------------

advancesnakes1yright          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S1y
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        sub ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes1yright           ENDP

advancesnakes1yleft          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S1y
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        add ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes1yleft           ENDP

advancesnakes2yleft          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S2y
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        add ax,sz2*2
        mov [bx],ax
                        RET
advancesnakes2yleft           ENDP

advancesnakes2yright          PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
        mov bx,offset S2y
        add bx,1900*2 -2
        mov cx,1899
Shift1:
        mov ax,[bx-2]                       ; Shifts and moves
        mov [bx],ax
        sub bx,2
        loop Shift1                
       mov ax,[bx+2]
        sub ax,sz1*2
        mov [bx],ax
                        RET
advancesnakes2yright           ENDP

;-------------------------------------------------
;----------------------DRAW SANKE FUNC--------------
;-------------------------------------------------
drawsnakes              PROC    FAR                               ;S1X,S1Y = head       ;Sz1 = size "num of points"
                        
                        mov ah,0ch
                        ;color of s1
                        mov al,1100b
                        lea si,S1X
                        lea di,S1Y
                        mov bx,Sz1
 draw_LL1:                                           
                        mov cx , [si]
                        mov dx , [di]

;-------------------------------------------------
                        push si
                        push di
                        xor si,si
                        
 draw_outer:             cmp si,SnakeWidth
                        jg draw_eee
                        XOR DI,DI

 draw_inner:             cmp di,SnakeWidth
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

 draw_outerr:            inc si
                        cmp si,SnakeWidth
                        jnz draw_outer

 draw_eee:               pop di
                        pop si
;-------------------------------------------------
                        add si,2
                        add di,2
                        dec bx
jnz draw_LL1

;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

                        mov al,1001b
                        lea si,S2X
                        lea di,S2Y
                        mov bx,Sz2
draw_LL2:                                           
                        mov cx , [si]
                        mov dx , [di]
                        push si
                        push di
;-------------------------------------------------
                        xor si,si
                        
draw_outer2:            cmp si,SnakeWidth
                        jg draw_eee2
                        XOR DI,DI

draw_inner2:            cmp di,SnakeWidth
                        jg draw_outerr2

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
                        jmp draw_inner2

draw_outerr2:                 inc si
                        cmp si,SnakeWidth
                        jnz draw_outer2

;-------------------------------------------------
draw_eee2:                   pop di
                        pop si
                        add si,2
                        add di,2
                        dec bx
jnz draw_LL2

;INT 10h / AH = 0Ch - change color for a single pixel.
;input:
;AL = pixel color
;CX = column.
;DX = row. 
                        
                        RET
drawsnakes              ENDP
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
        CALL  drawsnakes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NEED TO ADD RESTRICTION TO RIGHT AND LEFT (w.r.t SNAKE) ONLY
L1:
        mov ah,00h                                ;INT 16h / AH = 01h - check for keystroke in the keyboard buffer.
        int 16h                                 ;return:
        ;jnz FF                                  ;ZF = 1 if keystroke is not available.
        cmp ah,48h                              ;ZF = 0 if keystroke available.
        jnz Snake1left
        mov DirS1 , 1      
        jmp WER                                  ;AH = BIOS scan code.

Snake1left:     cmp ah,4Bh                              ;AL = ASCII character. 
        jnz Snake1right
        mov DirS1 , 0
        jmp WER

Snake1right:     cmp ah,4Dh                              ;And the scan codes for the arrow keys are:
        jnz Snake1Down                          ;Up: 0x48
        mov DirS1 , 2                           ;Left: 0x4B
        jmp WER                                  ;Right: 0x4D
                                                ;Down: 0x50
CC:     cmp ah,50h
        jnz FF
        mov DirS1 , 3
        mov cx,0FFh                             ;For Frame Wait
WER:    
        CALL  advancesnakes
FF:     mov ah,06h
        mov al,0
        xor cx,cx
        mov dx,0184FH
        int 10h   
        CALL  drawsnakes

        jmp L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ah,4ch
        int 21h

MAIN    ENDP

                    END MAIN        ; End of the program  
					