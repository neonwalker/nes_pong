ReadController1:
  LDA #$01
  STA JOYPAD1
  LDA #$00
  STA JOYPAD1
  LDX #$08
ReadController1Loop:
  LDA JOYPAD1
  LSR A
  ROL buttons1
  DEX
  BNE ReadController1Loop
  RTS

ReadController2:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadController2Loop:
  LDA $4017
  LSR A            ; bit0 -> Carry
  ROL buttons2     ; bit0 <- Carry
  DEX
  BNE ReadController2Loop
  RTS