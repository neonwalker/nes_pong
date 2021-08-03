.include "header.asm"

.segment "STARTUP"
.include "reset.asm"
.include "controller.asm"

.segment "CODE"
NMI:
    LDA #$00
    STA OAMADDR
    LDA #$02
    STA OAMDMA

    JSR ReadController1
    JSR ReadController2

    JSR GameLoop
    JSR UpdateSprites

    RTI

GameLoop:

MoveBallUp:
    LDA ball_dir
    AND #UP
    CMP #UP
    BNE MoveBallUpDone

    LDA s_ball_pos + point_t::y_pos
    SEC
    SBC speed
    STA s_ball_pos + point_t::y_pos

    LDA s_ball_pos + point_t::y_pos
    CMP #TOPWALL
    BCS MoveBallUpDone
    
    LDA ball_dir
    EOR #UP
    ORA #DOWN
    STA ball_dir
MoveBallUpDone:    

MoveBallDown:
    LDA ball_dir
    AND #DOWN
    CMP #DOWN
    BNE MoveBallDownDone

    LDA s_ball_pos + point_t::y_pos
    CLC
    ADC speed
    STA s_ball_pos + point_t::y_pos

    LDA s_ball_pos + point_t::y_pos
    CMP #BOTTOMWALL
    BCC MoveBallDownDone
    
    LDA ball_dir
    EOR #DOWN
    ORA #UP
    STA ball_dir
MoveBallDownDone:

MoveBallRight:
    LDA ball_dir
    AND #RIGHT
    CMP #RIGHT
    BNE MoveBallRightDone

    LDA s_ball_pos + point_t::x_pos
    CLC
    ADC speed
    STA s_ball_pos + point_t::x_pos

    LDA s_ball_pos + point_t::x_pos
    CMP #RIGHTWALL
    BCC MoveBallRightDone 

    ; LDA ball_dir
    ; EOR #RIGHT
    ; ORA #LEFT
    ; STA ball_dir
    JSR ResetBall
MoveBallRightDone:


MoveBallLeft:
    LDA ball_dir
    AND #LEFT
    CMP #LEFT
    BNE MoveBallLeftDone

    LDA s_ball_pos + point_t::x_pos
    SEC
    SBC speed
    STA s_ball_pos + point_t::x_pos

    LDA s_ball_pos + point_t::x_pos
    CMP #LEFTWALL
    BCS MoveBallLeftDone 
    ; LDA ball_dir
    ; EOR #LEFT
    ; ORA #RIGHT
    ; STA ball_dir
    JSR ResetBall
MoveBallLeftDone:

.MACRO  paddle_up_macro paddle, part
    LDA paddle + part + paddle_part::y_pos
    SEC
    SBC #$03
    STA paddle + part + paddle_part::y_pos
.ENDMACRO

MovePaddleUp:
    LDA buttons1
    AND #PADDLE_UP
    CMP #PADDLE_UP
    BNE MovePaddleUpDone

    LDA paddle1 + paddle_full::top + paddle_part::y_pos
    SEC
    SBC #$03
    CMP #TOPWALL
    BCC MovePaddleUpDone

    paddle_up_macro paddle1, paddle_full::top
    paddle_up_macro paddle1, paddle_full::mid1
    paddle_up_macro paddle1, paddle_full::mid2
    paddle_up_macro paddle1, paddle_full::bottom
MovePaddleUpDone:

.MACRO paddle_down_macro paddle, part
    LDA paddle + part + paddle_part::y_pos
    CLC
    ADC #$03
    STA paddle + part + paddle_part::y_pos
.ENDMACRO

MovePaddlleDown:
    LDA buttons1    
    AND #PADDLE_DOWN
    CMP #PADDLE_DOWN
    BNE MovePaddleDownDone

    LDA paddle1 + paddle_full::bottom + paddle_part::y_pos
    CLC
    ADC #$03
    CMP #BOTTOMWALL
    BCS MovePaddleDownDone

    paddle_down_macro paddle1, paddle_full::top
    paddle_down_macro paddle1, paddle_full::mid1
    paddle_down_macro paddle1, paddle_full::mid2
    paddle_down_macro paddle1, paddle_full::bottom
MovePaddleDownDone:

MovePaddle2Up:
    LDA buttons2
    AND #PADDLE_UP
    CMP #PADDLE_UP
    BNE MovePaddleUpDone2

    LDA paddle2 + paddle_full::top + paddle_part::y_pos
    SEC
    SBC #$03
    CMP #TOPWALL
    BCC MovePaddleUpDone2

    paddle_up_macro paddle2, paddle_full::top
    paddle_up_macro paddle2, paddle_full::mid1
    paddle_up_macro paddle2, paddle_full::mid2
    paddle_up_macro paddle2, paddle_full::bottom
MovePaddleUpDone2:

MovePaddlle2Down:
    LDA buttons2    
    AND #PADDLE_DOWN
    CMP #PADDLE_DOWN
    BNE MovePaddleDownDone2

    LDA paddle2 + paddle_full::bottom + paddle_part::y_pos
    CLC
    ADC #$03
    CMP #BOTTOMWALL
    BCS MovePaddleDownDone2

    paddle_down_macro paddle2, paddle_full::top
    paddle_down_macro paddle2, paddle_full::mid1
    paddle_down_macro paddle2, paddle_full::mid2
    paddle_down_macro paddle2, paddle_full::bottom
MovePaddleDownDone2:

CheckPaddleCollision:
    LDA paddle1 + paddle_full::top + paddle_part::x_pos
    CMP s_ball_pos + point_t::x_pos
    BCC CheckPaddleCollisionDone

    LDA s_ball_pos + point_t::y_pos
    CMP paddle1 + paddle_full::top + paddle_part::y_pos
    BCC CheckPaddleCollisionDone

    LDA paddle1 + paddle_full::bottom + paddle_part::y_pos
    CMP s_ball_pos + point_t::y_pos
    BCC CheckPaddleCollisionDone

    LDA ball_dir
    EOR #LEFT
    ORA #RIGHT
    STA ball_dir
CheckPaddleCollisionDone:

CheckPaddle2Collision:
    LDA s_ball_pos + point_t::x_pos
    CMP paddle2 + paddle_full::top + paddle_part::x_pos
    BCC CheckPaddle2CollisionDone

    LDA s_ball_pos + point_t::y_pos
    CMP paddle2 + paddle_full::top + paddle_part::y_pos
    BCC CheckPaddle2CollisionDone

    LDA paddle2 + paddle_full::bottom + paddle_part::y_pos
    CMP s_ball_pos + point_t::y_pos
    BCC CheckPaddle2CollisionDone

    LDA ball_dir
    EOR #RIGHT
    ORA #LEFT
    STA ball_dir
CheckPaddle2CollisionDone:

    RTS

ResetBall:
    LDA #$50
    STA s_ball_pos + point_t::x_pos
    LDA #$80
    STA s_ball_pos + point_t::y_pos

    LDA #$00
    STA ball_dir

    ORA #DOWN     ;intial direction 
    ORA #RIGHT    ;of the ball
    STA ball_dir ;to down right
    RTS

UpdateSprites:
    LDA s_ball_pos + point_t::y_pos  ;;update all ball sprite info
    STA $0200
  
    LDA #$00
    STA $0201
  
    LDA #$00
    STA $0202
  
    LDA s_ball_pos + point_t::x_pos
    STA $0203

    LDX #$00
:   LDA paddle1, X
    STA $0204, X
    INX
    CPX #$10
    BNE :-

    LDX #$00
:   LDA paddle2, X
    STA $0214, X
    INX
    CPX #$10
    BNE :-

    RTS

PaletteData:
    .byte $0F,$30,$30,$30,  $22,$36,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
    .byte $00,$30,$30,$30,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

Paddle1Data:
    .byte $50, $01, $00, $08 ;left paddle
    .byte $58, $01, $00, $08
    .byte $60, $01, $00, $08
    .byte $68, $01, $00, $08

Paddle2Data:
    .byte $50, $01, $00, $F0 ;right paddle
    .byte $58, $01, $00, $F0
    .byte $60, $01, $00, $F0
    .byte $68, $01, $00, $F0
    
.segment "VECTORS"
    .word NMI
    .word Reset

.segment "CHARS"
    .incbin "pong_wide.chr"