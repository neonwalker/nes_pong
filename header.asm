.segment "HEADER"

.byte "NES"
.byte $1a
.byte $02
.byte $01
.byte %00000001
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00, $00, $00, $00, $00

.struct point_t
    x_pos  .byte
    y_pos  .byte
.endstruct

.struct paddle_part
    y_pos .byte
    tile .byte
    attr .byte
    x_pos .byte
.endstruct

.struct paddle_full
    top .tag paddle_part
    mid1 .tag paddle_part
    mid2 .tag paddle_part
    bottom .tag paddle_part
.endstruct

PPUCTRL     = $2000
PPUMASK     = $2001
PPUSTATUS   = $2002
OAMADDR     = $2003
OAMDATA     = $2004
PPUADDR     = $2006
PPUDATA     = $2007

APUIRQ      = $4010
OAMDMA      = $4014
JOYPAD1     = $4016

UP = %00001000
DOWN = %00000100
LEFT = %00000010
RIGHT = %00000001

PADDLE_UP = %00001000
PADDLE_DOWN = %00000100

RIGHTWALL      = $F4
TOPWALL        = $04
BOTTOMWALL     = $E0
LEFTWALL       = $04

.segment "ZEROPAGE"

s_ball_pos: .tag point_t ;ball position
ball_dir:   .res 1 ;ball direction
speed:      .res 1 ;ball speed
buttons1:   .res 1 ;joypad1 pressed buttons
buttons2:   .res 1 ;joypad2 pressed buttons

paddle1: .tag paddle_full ;paddle1 sprite
paddle2: .tag paddle_full ;paddle2 sprite