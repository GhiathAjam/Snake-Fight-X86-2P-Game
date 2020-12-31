        .MODEL LARGE
        .STACK 64
       ; #include mymacros.inc

;-------------------------------------------------------------------------------------------------
;----------------------DATA SEGMENT----------------------------------
;-------------------------------------------------------------------------------------------------
        .DATA

;-------------------------------------------------------------------------------------------------
;----------------------FOOD STUFF----------------------------------
;-------------------------------------------------------------------------------------------------

        food_phases dw 7 dup(?)
        food_phase_num dw ?
        food_phase_size db 7
        food_stop_x dw ?
        food_stop_y dw ?
        food_temp_cx dw ?
        food_temp_dx dw ?
        food_imgW equ 9
        food_imgH equ 9
        ; pixels colors of the images
        food_img DB 29, 4, 4, 4, 4, 4, 4, 4, 112, 29, 31, 4, 4, 4, 4, 4, 112, 112, 29, 31, 31, 4, 4, 4, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 44
        DB 44, 44, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 40, 40, 40, 112, 112, 112, 29, 31, 40, 40, 40, 40, 40, 112, 112, 29, 4, 4, 4, 4, 4, 4, 4
        DB 112

        ;image phases for animation
        ;phase 2
        food_img2 DB 29, 4, 4, 4, 4, 4, 4, 4, 31, 29, 31, 4, 4, 4, 4, 4, 31, 31, 29, 31, 31, 4, 4, 4, 112, 31, 31, 29, 31, 31, 44, 44, 44, 112, 31, 31, 29, 31, 31, 44
        DB 44, 44, 112, 31, 31, 29, 31, 31, 44, 44, 44, 112, 31, 31, 29, 31, 31, 40, 40, 40, 112, 31, 31, 29, 31, 40, 40, 40, 40, 40, 31, 31, 29, 4, 4, 4, 4, 4, 4, 4
        DB 31

        ;phase 3
        food_img3 DB 29, 4, 4, 4, 4, 4, 4, 31, 31, 29, 31, 4, 4, 4, 4, 4, 31, 112, 29, 31, 31, 4, 4, 4, 31, 31, 112, 29, 31, 31, 44, 44, 44, 31, 31, 112, 29, 31, 31, 44
        DB 44, 44, 31, 31, 112, 29, 31, 31, 44, 44, 44, 31, 31, 112, 29, 31, 31, 40, 40, 40, 31, 31, 112, 29, 31, 40, 40, 40, 40, 40, 31, 112, 29, 4, 4, 4, 4, 4, 4, 31
        DB 31

        ;phase 4
        food_img4 DB 29, 4, 4, 4, 4, 4, 4, 31, 112, 29, 31, 4, 4, 4, 4, 31, 112, 112, 29, 31, 31, 4, 4, 31, 31, 112, 112, 29, 31, 31, 44, 44, 31, 31, 112, 112, 29, 31, 31, 44
        DB 44, 31, 31, 112, 112, 29, 31, 31, 44, 44, 31, 31, 112, 112, 29, 31, 31, 40, 40, 31, 31, 112, 112, 29, 31, 40, 40, 40, 40, 31, 112, 112, 29, 4, 4, 4, 4, 4, 4, 31
        DB 112

        ;phase 5
        food_img5 DB 29, 4, 31, 31, 31, 31, 31, 4, 112, 29, 31, 4, 31, 31, 31, 4, 112, 112, 29, 31, 31, 4, 31, 4, 112, 112, 112, 29, 31, 31, 44, 31, 44, 112, 112, 112, 29, 31, 31, 44
        DB 31, 44, 112, 112, 112, 29, 31, 31, 44, 31, 44, 112, 112, 112, 29, 31, 31, 40, 31, 40, 112, 112, 112, 29, 31, 40, 31, 31, 31, 40, 112, 112, 29, 4, 31, 31, 31, 31, 31, 4
        DB 112

        ;phase 6
        food_img6 DB 29, 31, 31, 4, 4, 4, 4, 4, 112, 29, 31, 31, 31, 4, 4, 4, 112, 112, 29, 31, 31, 31, 4, 4, 112, 112, 112, 29, 31, 31, 31, 44, 44, 112, 112, 112, 29, 31, 31, 31
        DB 44, 44, 112, 112, 112, 29, 31, 31, 31, 44, 44, 112, 112, 112, 29, 31, 31, 31, 40, 40, 112, 112, 112, 29, 31, 31, 31, 40, 40, 40, 112, 112, 29, 31, 31, 4, 4, 4, 4, 4
        DB 112
        ;phase 7
        food_img7 DB 29, 4, 4, 4, 4, 4, 4, 4, 112, 29, 31, 4, 4, 4, 4, 4, 112, 112, 29, 31, 31, 4, 4, 4, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 44
        DB 44, 44, 112, 112, 112, 29, 31, 31, 44, 44, 44, 112, 112, 112, 29, 31, 31, 40, 40, 40, 112, 112, 112, 29, 31, 40, 40, 40, 40, 40, 112, 112, 29, 4, 4, 4, 4, 4, 4, 4
        DB 112

;-------------------------------------------------------------------------------------------------
;----------------------PowerUPs STUFF----------------------------------
;-------------------------------------------------------------------------------------------------

        Num_Of_Times db 0
        Freeze_S1 dw 0
        Freeze_S2 dw 0
        Poison_S1 dw 0
        Poison_S2 dw 0
        poison_active dw 0        


;
;-------------------------------------------------------------------------------------------------
;----------------------SNAKE STUFF----------------------------------
;-------------------------------------------------------------------------------------------------
        ScreenWidth     EQU  320d
        ScrX            EQU  320d
        ScreenHighet    EQU  200d
        ScrY            EQU  200d

        ; (inner grid w/o borders)     39*21 squares fit inside grid each square is 9*9 pixels
        GridX           DW  39d
        GridY           DW  21d

        sqrX            DW  9
        sqrY            DW  9

        ; expand points by SnakeWidth in all 8 directions      
        SnakeWidth      DW  4                                                         
        SquareWidth     DW  ?

        ; num of points for Snake 1
        Sz1             DW  3d
        ; 0 for left / 1 for up / 2 for right / 3 for down
        DirS1           DW  0
        ; points  of snake (snakewidth*2 away from each other)
        S1X             DW  6400d dup(?)            
        S1Y             DW  6400d dup(?)
        ; for growing
        IsSnake1Fed     DB  0
        ; new head for moving
        S1HX            DW ?
        S1HY            DW ?

        ; Snake 2
        Sz2             DW  3d
        DirS2           DW  2
        S2X             DW  6400d dup(?)
        S2Y             Dw  6400d dup(?)
        IsSnake2Fed     DB  0
        S2HX            DW ?
        S2HY            DW ?

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

                        mov ah,0Ch
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
                        jmp draw_sqr_outer

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

                        mov ah,0Ch
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
;----------------------RANDOM X Y IN CX DX--------------
;-------------------------------------------------
random_x_y      proc FAR
        ;   MAKE AX ALL RANDOM
        xor ax, ax
        int 1ah			;get random value from the ticks of the clock cx:dx
        mov bl, dl		;put the most changable byte of dx in bl
        int 1ah			;call the same interrupt to get another value in dx
        mov bh, dl		;put the most changable byte of dx in bl again
        mov ax, bx		;mov the random value to reg ax from bx

        ;   scaling the random value by number of squares (39 x 21) --  ([0-38] , [0-20])

        ;   generating X from 0 to 38 and storing in SI
        mov dx, 00h
        mov bx, 37d 	        ;the width of the screen
        mov cx,ax               ;storing random number
        div bx			;mod the random value with the width to get a random number from 0 to 38
        mov si, dx		;initialize reg si with the value

        ;   get the random value for the y axis
        mov ax, cx      ;getting random value back

        ;   generating Y from 0 to 32 and storing in DI
        mov dx, 00h
        mov bx, 18d		;the height of the screen
        div bx			;dx now has the value form 0 to 20
        mov di,dx

        ;       scaling SI and DI from sqrs number to actual X and Y locations in the grid
        ;       x starts from 5+9 and ends in 313 (5+34*9)     0-5+9   1-5+2*9     
    dummy_label_to_hide_func:
        ;       y from 29+9 ---> 196(29+18*9)
        mov cx,13d
        inc si
        rnd_x:
        add cx,8d
        dec si
        jnz rnd_x

        mov dx,44d
        rnd_y:
        add dx,8d
        dec di
        jnz rnd_y

        dec cx

                ret
random_x_y      ENDP

;-------------------------------------------------
;----------------------DRAW FOOD--------------
;-------------------------------------------------

draw_food PROC FAR

        mov food_phases, offset food_img
        mov food_phases + 2, offset food_img2
        mov food_phases + 4, offset food_img3
        mov food_phases + 6, offset food_img4
        mov food_phases + 8, offset food_img5
        mov food_phases + 10, offset food_img6
        mov food_phases + 12, offset food_img7

	draw_food_init:
                mov food_phase_size, 7
                mov food_phase_num, offset food_phases
                mov DI, food_phases             ; to iterate over the pixels
                call random_x_y	                ;call function that return random numbers in cx and dx
                mov food_stop_x, cx	        ;copy the values of cx & dx into external variables
                mov food_stop_y, dx
                mov food_temp_cx, cx    	;store cx into a variable to reinitialize cx with it
                mov food_temp_dx, dx	        ;store dx value to use it in animation
                sub food_stop_x, food_imgW	;subtract the width of the image from cx so as to know where i will stop
                sub food_stop_y, food_imgH
        jmp draw_food_Start    	                        ;Avoid drawing before the calculations

	draw_food_Drawit:
                MOV AH,0Ch   	;set the configuration to writing a pixel
                mov al, [DI]    ; color of the current coordinates
                xor bx,bx   	;set the page number
                INT 10h      	;execute the configuration
        jmp draw_food_Start  

	draw_food_Start: 
                inc DI
                DEC Cx       	        ;  loop iteration in x direction
                cmp cx, food_stop_x
        JNZ draw_food_Drawit      	        ;  check if we can draw current x and y and excape the y iteration
                mov Cx, food_temp_cx 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
                DEC DX       	        ;  loop iteration in y direction
                cmp dx, food_stop_y
        JZ  draw_food_animate   	                ;  both x and y reached 00 so end program
        Jmp draw_food_Drawit



	draw_food_animate:
                MOV CX, 00H		;cx:dx is used as a register of the time in microsec.
                MOV DX, 02d40H
                MOV AH, 86H	
                INT 15H
                
                dec food_phase_size
        jz draw_food_ENDING
                mov bx, food_phase_num
                add bx, 2
                mov food_phase_num, bx
                mov di, [bx]
                mov cx, food_temp_cx
                mov dx, food_temp_dx
        jmp draw_food_Drawit

	draw_food_ENDING:
                        RET
	draw_food       ENDP


;-------------------------------------------------
;----------------------DRAW ENVIRONMENT--------------
;-------------------------------------------------
drawEnv PROC     FAR

        ; mov ah,0ch
        ; mov al,clr_BackGround

        ; Scroll to color BG Faster , still needs work and am lazy hh
        mov ah,06h
        xor al,al
        mov bh,0F5h             ; combination of two colors refer to help.txt
        xor cx,cx
        mov dx,184fh
        ; int 10h
        

        ;draw horizontal line at top of screen
        mov SquareWidth,2

        mov cx,1
        mov dx,26d
       
        mov al,clr_top_border
drawEnv_top_line:               
        CALL drawSqr
        inc cx
        cmp cx,319d
        jl drawEnv_top_line


        ;draw horizontal line at bottom of screen
        mov ax,2
        mov SquareWidth,ax

        mov cx,1
        mov dx,ScrY
        sub dx,2                ; 198d
       
        mov al,clr_top_border
drawEnv_btm_line:               
        CALL drawSqr
        inc cx
        cmp cx,320d
        jl drawEnv_btm_line



        ;draw left side line of screen
        mov ax,2
        mov SquareWidth,ax

        xor dx,dx
        mov cx,2
       
        mov al,clr_side_border
drawEnv_lft_line:               
        CALL drawSqr
        inc dx
        inc dx
        inc dx
        cmp dx,200d
        jl drawEnv_lft_line

        ;draw right side line of screen
        mov ax,2
        mov SquareWidth,ax

        xor dx,dx
        mov cx,ScrX
        sub cx,3                        ; 197d
       
        mov al,clr_side_border
drawEnv_rght_line:               
        CALL drawSqr
        inc dx
        inc dx
        inc dx
        cmp dx,200d
        jl drawEnv_rght_line


        CALL  draw_food
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

        ; common X factor of all points in snake1
        mov ax,ScrX
        sub ax,SnakeWidth
        sub ax,SnakeWidth
        ; sub ax,SnakeWidth
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
        ; add ax,SnakeWidth

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
                ret
INIT                   ENDP
;-------------------------------------------------
;----------------------FEED SNAKE FUNC--------------            ; this works by telling advance snake function not to delete tail next time snake moves
;-------------------------------------------------
feedsnake               PROC    FAR                             ; Snake num  as parameter in AX

       ; mov poison_active,1
       ; mov Poison_S1,1

        cmp ax,1
        jnz feed_s2
        mov cx,S1HX
        mov dx,S1HY
        mov IsSnake1Fed,1
        jmp feed_eee

feed_s2:
        mov IsSnake2Fed,1        
        mov cx,S2HX
        mov dx,S2HY
feed_eee:


        ; Erasing old food
        mov SquareWidth,4
        xor al,al
        call drawSqr

        ; Draw new food
        CALL  draw_food

                        RET
feedsnake               ENDP

;-------------------------------------------------
;----------------------ADVANCE SNAKE FUNC--------------
;-------------------------------------------------
advancesnakes           PROC    FAR                              ;DirS1: [0 for left / 1 for up / 2 for right / 3 for down]
          
;       Getting NEW Sanke 1 HEAD

        ; original head in (si,di)
        mov si,S1X
        mov di,S1Y
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
                mov S1HX,si
                mov S1HY,Di

;---------------CHECK FOR COLLISION S1-------------
                ;       get color of pixel 
                mov cx,si
                mov dx,di
                mov ah,0Dh
                int 10h                 ;AL = pixel color
                and al,al
                jz advance_safe

                cmp al,02Ch
                jnz advance_not_food

                mov ax,1
                CALL feedsnake
                jmp advance_safe

        advance_not_food:        
                cmp al,0Fh
                jnz advance_not_border
                jmp advance_snake2

        advance_not_border:
                cmp al,clrs1
                jnz advance_not_self
                jmp advance_snake2
        advance_not_self:
                cmp al,clrs2
                jnz advance_not_other
                jmp advance_snake2
                NOP
        advance_not_other:       
        advance_safe:


;       SHIFTING ALL Snake 1 VALUES RIGHT FOR NEW HEAD POINT
       
                mov ax,Sz1
                mov bx,2
                mul bx

                mov si,offset S1X
                mov di,offset S1Y
                add si,ax
                add di,ax
                mov cx,Sz1
advance_shift1:
                mov ax,[si-2]
                mov [si],ax
                mov ax,[di-2]
                mov [di],ax

                sub si,2
                sub di,2
                LOOP advance_shift1
                
;-------------------------------------------------
;---------------ERASING TAIL SNAKE1
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
                mov bx,ax
                add bx,offset S1X
                mov cx,[bx]
                sub bx,offset S1X
                add bx,offset S1Y
                mov dx,[bx]

               
                mov al,0                ;black
                CALL drawRect

        advance_end_del_tail1:
               
                

;       SETTING NEW SNAKE 1 HEAD
                mov ax,S1HX
                mov S1X,ax
                mov ax,S1HY
                mov S1Y,ax


;DRAWING NEW Sanke 1 HEAD
        mov ax,SnakeWidth
        mov SquareWidth,ax
        mov cx,S1X
        mov dx,S1Y
        mov al,clrs1

        CALL drawRect
                


;-------------------------------------------------
;-------SNAKE 2
advance_snake2:
;       Getting NEW Sanke 2 HEAD
                ; original head in (si,di)
                mov si,S2X
                mov di,S2Y

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
                mov S2HX,si
                mov S2HY,Di

;--------------------------------------------------
;---------------CHECK FOR COLLISION S2-------------
;--------------------------------------------------

        ;       get color of pixel 
        mov cx,si
        mov dx,di
        mov ah,0Dh
        int 10h                 ;AL = pixel color       
        and al,al
        jz advance2_safe
        
        cmp al,02Ch
        jnz advance2_not_food

        mov ax,2
        CALL feedsnake
        jmp advance2_safe

        advance2_not_food:
        cmp al,0Fh
        jnz advance2_not_border
        jmp advance_end
        
        advance2_not_border:
        cmp al,clrs2
        jnz advance2_not_self
        jmp advance_end
        
        advance2_not_self:
        cmp al,clrs1
        jnz advance2_not_other
        jmp advance_end

        advance2_not_other:       
        advance2_safe:
;       Shifting SNAKE 2
 
                mov ax,Sz2
                mov bx,2
                mul bx

                mov si,offset S2X
                mov di,offset S2Y
                add si,ax
                add di,ax
                mov cx,Sz2
advance_shift2:
                mov ax,[si-2]
                mov [si],ax
                mov ax,[di-2]
                mov [di],ax

                sub si,2
                sub di,2
                LOOP advance_shift2
              



;---------------ERASING TAIL SNAKE2
                cmp IsSnake2Fed,1
                jnz advance_del_tail2
                inc Sz2
                mov IsSnake2Fed,0
                jmp advance_end_del_tail2
 
        advance_del_tail2: 
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov ax,Sz2
                mov bx,2
                mul bx
                mov bx,ax
                add bx,offset S2X
                mov cx,[bx]
                sub bx,offset S2X
                add bx,offset S2Y
                mov dx,[bx]

               
                mov al,0                ;black
                CALL drawRect

        advance_end_del_tail2:

;       SETTING NEW SNAKE 2 HEAD
                mov ax,S2HX
                mov S2X,ax
                mov ax,S2HY
                mov S2Y,ax

;DRAWING NEW Sanke 2 HEAD
                mov ax,SnakeWidth
                mov SquareWidth,ax
                mov cx,S2X
                mov dx,S2Y
               
                mov al,clrs2
                CALL drawRect
advance_end:              
                RET
advancesnakes           ENDP

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

        ; delay function
        MOV CX, 01H		;cx:dx is used as a register of the time in microsec.
        MOV DX, 8480H
        MOV AH, 86H	
        INT 15H			;delay interrupt int 15h / ah = 86h


        mov ah,01
        int 16h
        JZ FFFFFF1
        
        mov ah,0                                ;INT 16h / AH = 01h - check for keystroke in the keyboard buffer.
        int 16h                                 ;return:
        instantKill:
        instantDeath:
        Poison:
        cmp poison_active,0
        Je Freeze
        mov Num_Of_Times,3
        mov poison_active,0
        
        Freeze:
        
   
        UP:    
        cmp ah,48h                              ;ZF = 0 if keystroke available.
        jnz Left
        cmp DirS1,3
        je FFFF1
        cmp Poison_S1,1
        je UP_Poison
        mov DirS1 , 1      
        jmp FF1   
        UP_Poison:
        cmp DirS1 , 1      
        je FFFF1   
        mov DirS1,3
        dec [Num_Of_Times]
        cmp Num_Of_Times,0
        je STOP_Poison
        jmp FF1
  
         FFFFFF1:jmp FF1
      
        Left:
        cmp ah,4Bh                              ;AL = ASCII character. 
        jnz Right
        cmp DirS1,2
        je FFFF1
        cmp Poison_S1,1
        je Left_Poison
        mov DirS1 , 0
        jmp FF1
        Left_Poison:
        cmp DirS1 , 0      
        je FFFF1   
        mov DirS1,2
        dec [Num_Of_Times]
        cmp Num_Of_Times,0
        je STOP_Poison
        jmp FF1
        
        FFFF1:jmp FF1
        STOP_Poison:                                 ;stoping poison
        mov poison_active,0
        mov Poison_S1,0
        jmp FF1
       
       
        Right:    
        cmp ah,4Dh                              ;And the scan codes for the arrow keys are:
        jnz Down
        cmp DirS1,0
        je FFFF1                                  ;Up: 0x48
        cmp Poison_S1,1
        je Right_Poison
        mov DirS1 , 2                          ;Left: 0x4B
        jmp FF1                                  ;Right: 0x4D
        Right_Poison:
        cmp DirS1 , 2      
        je FFFF1   
        mov DirS1,0
        dec [Num_Of_Times]
        cmp Num_Of_Times,0
        je STOP_Poison
        jmp FF1
                                                ;Down: 0x50
        Down:   
        cmp ah,50h
        jnz UP2
        cmp DirS1,1
        je FFF1  
        cmp Poison_S1,1
        je Down_Poison
        mov DirS1 , 3   
        jmp FF1
        Down_Poison:
        cmp DirS1 , 3      
        je FFFF1   
        mov DirS1,1
        dec [Num_Of_Times]
        cmp Num_Of_Times,0
        je STOP_Poison
        jmp FF1
        
        
        
        UP2:   
        cmp al,77h                              ;AL = ASCII character. 
        jnz Left2
        cmp DirS2,3
        je FFF1  
        cmp Poison_S2,1
        je UP2_Poison
        mov DirS2 , 1
        jmp FF1
        UP2_Poison:
        cmp DirS2 , 1      
        je FFF1   
        mov DirS2,3
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP2_Poison
        jmp FFF1

        FFF1:jmp FF1


        Left2:  
        cmp al,61h                              ;And the scan codes for the arrow keys are:
        jnz Right2                                  ;Up: 0x48
        cmp DirS2,2
        je FFF1 
        cmp Poison_S2,1
        je Left2_Poison
        mov DirS2 , 0                           ;Left: 0x4B
        jmp FF1                                  ;Right: 0x4D
        Left2_Poison:
        cmp DirS2 , 0      
        je FFF1   
        mov DirS2,2
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP2_Poison
        jmp FFF1

        STOP2_Poison:                                 ;stoping poison
        mov poison_active,0
        mov Poison_S2,0
        jmp FF1
       
        LL1: jmp L1
                                                        ;Down: 0x50
        Right2:
        cmp al,64h
        jnz Down2 
        cmp DirS2,0
        je FFF1  
        cmp Poison_S2,1
        je Right2_Poison
        mov DirS2 , 2   
        jmp FF1
        Right2_Poison:
        cmp DirS2 , 2      
        je FFF1   
        mov DirS2,0
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP2_Poison
        jmp FF1

        Down2:  
        cmp al,73h
        jnz UpC2
        cmp DirS2,1
        je FFFFF1  
        cmp Poison_S2,1
        je Down2_Poison
        mov DirS2 , 3   
        jmp FF1
        Down2_Poison:
        cmp DirS2 , 3      
        je FFFFF1   
        mov DirS2,1
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP2_Poison
        jmp FF1
        ;FOR CAPITAL LETTERS
                FFFFF1:jmp FF1

        UPC2:    
        cmp al,57h                              ;AL = ASCII character. 
        jnz LeftC2
        cmp DirS2,3
        je FFFFF1  
        cmp Poison_S2,1
        je UPC2_Poison
        mov DirS2 , 1
        jmp FF1
        UPC2_Poison:
        cmp DirS2 , 1      
        je FFFFF1   
        mov DirS2,3
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP3_Poison
        jmp FF1

        LeftC2:   
        cmp al,41h                              ;And the scan codes for the arrow keys are:
        jnz RightC2                                  ;Up: 0x48
        cmp DirS2,2
        je FFFFF1  
        cmp Poison_S2,1
        je LeftC2_Poison
        mov DirS2 , 0                           ;Left: 0x4B
        jmp FF1                                 ;Right: 0x4D
        LeftC2_Poison:
        cmp DirS2 , 0      
        je FFFFF1   
        mov DirS2,2
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP3_Poison
        jmp FF1
                                              ;Down: 0x50
        STOP3_Poison:                                 ;stoping poison
        mov poison_active,0
        mov Poison_S2,0
        jmp FF1
       
        
        RightC2:     
        cmp al,44h
        jnz DownC2 
        cmp DirS2,0
        je FF1  
        cmp Poison_S2,1
        je RightC2_Poison
        mov DirS2 , 2   
        jmp FF1
        RightC2_Poison:
        cmp DirS2 , 2      
        je FF1   
        mov DirS1,0
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP3_Poison
        jmp FF1

        DownC2:     
        cmp al,53h
        jnz FF1  
        cmp DirS2,1
        je FF1  
        cmp Poison_S2,1
        je DownC2_Poison
        mov DirS2 , 3   
        jmp FF1
        DownC2_Poison:
        cmp DirS2 , 3      
        je FF1   
        mov DirS1,1
        dec Num_Of_Times
        cmp Num_Of_Times,0
        je STOP3_Poison
        jmp FF1


jmp L1  

FF1:
        ; delay function
        MOV CX, 1eH		;cx:dx is used as a register of the time in microsec.
        MOV DX, 8480H
        MOV AH, 86H	
        ; INT 15H			;delay interrupt int 15h / ah = 86h
      

        CALL  advancesnakes
jmp L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	click:
        ; delay function
        MOV CX, 00H		;cx:dx is used as a register of the time in microsec.
        MOV DX, 1880H
        MOV AH, 86H	
        INT 15H			;delay interrupt int 15h / ah = 86h


        ;       DELETING FOOD
        mov SquareWidth,4
        xor al,al
        mov cx,food_temp_cx
        mov dx,food_temp_dx
        sub cx,4
        sub dx,4
        ; call drawSqr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ah,4ch
        int 21h

MAIN    ENDP

                    END MAIN        ; End of the program  
				