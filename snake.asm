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

; max grid x and y (inner grid w/o borders)     38*23 squares fit inside grid eaxh square is 9*9 pixels
GridX           DW  38d
GridY           DW  23d

sqrX            DW  9
sqrY            DW  9

; expand points by SnakeWidth in all 8 directions        320d % (2*sankewidth+1) == 0 
SnakeWidth      DW  4                                                         
SquareWidth     DW  ?

; num of points for Snake 1
Sz1             DW  5d
; 0 for left / 1 for up / 2 for right / 3 for down
DirS1           DW  4
; points  of snake (snakewidth*2 away from each other)
S1X             DW  6400d dup(?)            
S1Y             DW  6400d dup(?)
; for growing
IsSnake1Fed     DB  0


; Snake 2
Sz2             DW  5
DirS2           DW  4
S2X             DW  6400d dup(?)
S2Y             Dw  6400d dup(?)
IsSnake2Fed     DB  0

clrs1           equ     1100b
clrs2           equ     1001b

clr_BackGround  equ     1111b

clr_top_border  equ     1111b

clr_side_border  equ     1111b

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
        draw_sqr_outer:
                        cmp si,SquareWidth
                        jg draw_sqr_eee
                        XOR DI,DI
        draw_sqr_inner:  
                        cmp di,SquareWidth
                        jg draw_sqr_outerr
                   
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
                        jmp draw_sqr_inner
        draw_sqr_outerr:   
                        inc si
                        cmp si,SquareWidth
                        jnz draw_sqr_outer

        draw_sqr_eee:     
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
;----------------------DRAW RECT--------------
;-------------------------------------------------
drawRect              PROC    FAR                             

        ;-------------------------------------------------
                        push si
                        push di
                        xor si,si
                        dec SquareWidth
                      
        draw_rec_outer:
                        cmp si,SquareWidth
                        jg draw_rec_eee
                        XOR DI,DI
        draw_rec_inner:  
                        cmp di,SquareWidth
                        jg draw_rec_outerr
                   
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
                        jmp draw_rec_inner
        draw_rec_outerr:   
                        inc si
                        cmp si,SquareWidth
                        jnz draw_rec_outer

        draw_rec_eee:     
                        pop di
                        pop si
                     
                     inc SquareWidth
        ;-------------------------------------------------
;
;INT 10h / AH = 0Ch - change color for a single pixel.
;input:
;AL = pixel color
;CX = column.
;DX = row.                
                        RET
drawRect              ENDP

;-------------------------------------------------
;----------------------DRAW ENVIRONMENT--------------
;-------------------------------------------------
drawEnv PROC     FAR

        ; mov ah,0ch
        ; mov al,clr_BackGround

        ; Scroll to color BG Faster , still needs work and am lazy hh
        mov ah,06h
        xor al,al
        mov bh,0EFh             ; combination of two colors refer to help.txt
        xor cx,cx
        mov dx,184fh
       ; int 10h
        

        ;draw horizontal line at top of screen
        mov ax,4
        mov SquareWidth,ax

        xor cx,cx
        mov dx,4
        mov ah,0Ch
        mov al,clr_top_border
drawEnv_top_line:               
       CALL drawSqr
        inc cx
        inc cx
        cmp cx,319d
        jl drawEnv_top_line


        ;draw horizontal line at bottom of screen
        mov ax,4
        mov SquareWidth,ax

        mov cx,1
        mov dx,ScrY
        sub dx,4
        mov ah,0Ch
        mov al,clr_top_border
drawEnv_btm_line:               
        CALL drawSqr
        inc cx
        inc cx
        cmp cx,320d
        jl drawEnv_btm_line



        ;draw left side line of screen
        mov ax,6
        mov SquareWidth,ax

        xor dx,dx
        mov cx,4
        mov ah,0Ch
        mov al,clr_side_border
drawEnv_lft_line:               
        CALL drawSqr
        inc dx
        inc dx
        cmp dx,201d
        jl drawEnv_lft_line

        ;draw right side line of screen
        mov ax,5
        mov SquareWidth,ax

        xor dx,dx
        mov cx,ScrX
        sub cx,5
        mov ah,0Ch
        mov al,clr_side_border
drawEnv_rght_line:               
        CALL drawSqr
        inc dx
        inc dx
        cmp dx,201d
        jl drawEnv_rght_line



;
;INT 10h / AH = 0Ch - change color for a single pixel.
;input:
;AL = pixel color
;CX = column.
;DX = row.                

        RET
drawEnv ENDP

;-------------------------------------------------
;----------------------INIT FUNC--------------
;-------------------------------------------------
INIT                    PROC FAR
        CALL drawEnv
        ; Y of all points
        mov dx,ScrY
        sub dx,SnakeWidth               
        sub dx,SnakeWidth               
        sub dx,SnakeWidth               

        ; common X factor of all points in snake1
        mov ax,ScrX
        sub ax,SnakeWidth
        sub ax,SnakeWidth
        sub ax,SnakeWidth
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
                CALL drawRect
                add si,2
                add di,2
                dec BX
                jnz init_draws1



;---------------------------------------
; snake 2

        ; common X factor of all points in snake2
        mov ax,SnakeWidth
        add ax,SnakeWidth
        add ax,SnakeWidth

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
                CALL drawRect
                add si,2
                add di,2
                dec BX
                jnz init_draws2

INIT                   ENDP

;-------------------------------------------------
;----------------------ADVANCE SNAKE FUNC--------------
;-------------------------------------------------
advancesnakes           PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
          
              
;---------------ERASING TAIL SNAKE1
  Snake1Tail:
                cmp IsSnake1Fed,1
                jnz advance_del_tail1
                inc Sz1
                mov IsSnake1Fed,0
                jmp advance_end_del_tail1

advance_del_tail1:            
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov ax,Sz1
                mov bx,2
                mul bx
                sub ax,2
                mov bx,ax
                add bx,offset S1X
                mov cx,[bx]
                sub bx,offset S1X
                add bx,offset S1Y
                mov dx,[bx]

                mov ah,0ch
                mov al,0                ;black
                CALL drawRect

advance_end_del_tail1:
                jmp snake1
;---------------ERASING TAIL SNAKE2
 Snake2Tail:  
                cmp IsSnake2Fed,1
                jnz advance_del_tail2
                inc Sz2
                mov IsSnake1Fed,0
                jmp advance_end_del_tail2
 
advance_del_tail2: 
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov ax,Sz2
                mov bx,2
                mul bx
                sub ax,2
                mov bx,ax
                add bx,offset S2X
                mov cx,[bx]
                sub bx,offset S2X
                add bx,offset S2Y
                mov dx,[bx]

                mov ah,0ch
                mov al,0                ;black
                CALL drawRect

advance_end_del_tail2:
                jmp snake2
;       SHIFTING ALL S1X VALUES RIGHT FOR NEW HEAD POINT
 snake1:        
                mov ax,Sz1
                mov bx,2
                mul bx
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
                jmp Snake1Head
;-------------------------------------------------
;       SNAKE 2
  Snake2:  
                mov ax,Sz2
                mov bx,2
                mul bx
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
                jmp Snake2Head
;-------------------------------------------------
;-------------------------------------------------
Snake1Head:
;       SETTING NEW HEAD

                ; original head in (si,di)
                mov si,S1X+2
                mov di,S1Y+2
                mov bx,DirS1
                cmp bx,4
                jz advance_left
                and bx,bx
                cmp bx,0
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
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov cx,S1X
                mov dx,S1Y
                mov ah,0ch
                mov al,clrs1

                CALL drawRect
                jmp L1
;-------------------------------------------------
;-------SNAKE 2

;       SETTING NEW HEAD
Snake2Head:
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
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov cx,S2X
                mov dx,S2Y
                mov ah,0ch
                mov al,clrs2
                CALL drawRect
jmp L1
advancesnakes           ENDP

;-------------------------------------------------
;----------------------FEED SNAKE FUNC--------------            ; this works by telling advance snake function not to delete tail next time snake moves
;-------------------------------------------------
feedsnake               PROC    FAR                             ; Snake num  as parameter in AX

        cmp ax,1
        jnz feed_s2
        mov IsSnake1Fed,0
        jmp feed_eee

feed_s2:
        mov IsSnake2Fed,0        

feed_eee:
                        RET
feedsnake               ENDP
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
; mov bp,1
; NEED TO ADD RESTRICTION TO RIGHT AND LEFT (w.r.t SNAKE) ONLY
L1:
        ; CALL feedsnake
        mov ah,0                                ;INT 16h / AH = 01h - check for keystroke in the keyboard buffer.
        int 16h                                 ;return:
   
 UP:    cmp ah,48h                              ;ZF = 0 if keystroke available.
        jnz Left
        cmp DirS1,3
        je L1
        mov DirS1 , 1      
        jmp FF1                                  ;AH = BIOS scan code.
Left:     cmp ah,4Bh                              ;AL = ASCII character. 
        jnz Right
        cmp DirS1,2
        je L1
        mov DirS1 , 0
        jmp FF1

Right:     cmp ah,4Dh                              ;And the scan codes for the arrow keys are:
        jnz Down
        cmp DirS1,0
        je L1                                  ;Up: 0x48
        mov DirS1 , 2                          ;Left: 0x4B
        jmp FF1                                  ;Right: 0x4D
                                                ;Down: 0x50
Down:   
        cmp ah,50h
        jnz UP2
        cmp DirS1,1
        je L1  
        mov DirS1 , 3   
        jmp FF1
UP2:   
        cmp al,77h                              ;AL = ASCII character. 
        jnz Left2
        cmp DirS2,3
        je L1  
        mov DirS2 , 1
        jmp FF2

Left2:  
        cmp al,61h                              ;And the scan codes for the arrow keys are:
        jnz Right2                                  ;Up: 0x48
        cmp DirS2,2
        je LL1 
        mov DirS2 , 0                           ;Left: 0x4B
        jmp FF2                                  ;Right: 0x4D

LL1: jmp L1

                                                ;Down: 0x50
Right2:
        cmp al,64h
        jnz Down2 
        cmp DirS2,0
        je LL1  
        mov DirS2 , 2   
        jmp FF2

Down2:  
        cmp al,73h
        jnz UpC2
        cmp DirS2,1
        je LL1  
        mov DirS2 , 3   
        jmp FF2
;FOR CAPITAL LETTERS
UPC2:    
        cmp al,57h                              ;AL = ASCII character. 
        jnz LeftC2
        cmp DirS2,3
        je LL1  
        mov DirS2 , 1
        jmp FF2

LeftC2:   
        cmp al,41h                              ;And the scan codes for the arrow keys are:
        jnz RightC2                                  ;Up: 0x48
        cmp DirS2,2
        je LL1  
        mov DirS2 , 0                           ;Left: 0x4B
        jmp FF2                                  ;Right: 0x4D
                                                ;Down: 0x50
RightC2:     
        cmp al,44h
        jnz DownC2 
        cmp DirS2,0
        je LL1  
        mov DirS2 , 2   
        jmp FF2

DownC2:     
        cmp al,53h
        jnz LL1  
        cmp DirS2,1
        je LL1  
        mov DirS2 , 3   
        jmp FF2


jmp L1        
FF1:
        mov cx,0FFFFh                             ;For Frame Wait
WER:    LOOP WER
        ; CALL  drawEnv
        CALL  Snake1Tail
jmp L1

FF2:
        mov cx,0FFFFh                             ;For Frame Wait
WER2:    LOOP WER2
        ;  CALL  drawEnv
         CALL  Snake2Tail
jmp L1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ah,4ch
        int 21h

MAIN    ENDP

                    END MAIN        ; End of the program  
				