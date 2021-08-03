Reset:
    SEI
    CLD

    LDX #$40
    STX $4017

    LDX #$FF
    TXS
    INX

    STX PPUCTRL
    STX PPUMASK
    STX APUIRQ

:   BIT PPUSTATUS
    BPL :-

    TXA

:   STA $0000, X ; $0000 => $00FF
    STA $0100, X ; $0100 => $01FF
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    LDA #$FE
    STA $0200, X ; $0200 => $02FF
    LDA #$00
    INX
    BNE :-

:   BIT PPUSTATUS
    BPL :-

    LDA #$02
    STA $4014
    NOP

    ; $3F00
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
LoadPalettes:
    LDA PaletteData, X
    STA $2007 ; $3F00, $3F01, $3F02 => $3F1F
    INX
    CPX #$20
    BNE LoadPalettes

    LDX #$00
LoadPaddle1:
    LDA Paddle1Data, X
    STA paddle1, X
    STA $0204, X
    INX
    CPX #$10
    BNE LoadPaddle1

    LDX #$00
LoadPaddle2:
    LDA Paddle2Data, X
    STA paddle2, X
    STA $0214, X
    INX
    CPX #$10
    BNE LoadPaddle2  

    LDA ball_dir ;sets
    ORA #DOWN     ;intial direction 
    ORA #RIGHT    ;of the ball
    STA ball_dir ;to down right
    
    LDA #$02
    STA speed

    LDA #$50
    STA s_ball_pos + point_t::x_pos
    LDA #$80
    STA s_ball_pos + point_t::y_pos

      

    CLI

    LDA #%10010000
    STA PPUCTRL

    LDA #%00011110
    STA PPUMASK

Forever:
    JMP Forever