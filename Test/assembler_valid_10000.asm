; NES ACE Assembler - 10,000 Line Error-Free Stress Test
; Formatted Like A Large NES PRG ROM Disassembly
; Instructions Are Uppercase And Tab-Indented
; Labels And Directives Are Flush-Left
; Enable Use Undocumented For Successful Assembly

; ======================================================================================
; PRG Bank 000 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8000
.const PPUCTRL_000=$2000
.const PPUMASK_000=$2001
.const PPUSTATUS_000=$2002
.const EVENT_VECTOR_000=$00F0

Reset_000:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_000
	STA PPUMASK_000
	STA $00
	STA $01
	JSR ClearRam_000
	JSR LoadPalette_000
	JMP MainLoop_000

Nmi_000:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_000
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_000:
	RTI

MainLoop_000:
	JSR ReadController_000
	JSR UpdatePlayer_000
	JSR UpdateObjects_000
	JMP MainLoop_000

ClearRam_000:
	LDA #$00
	TAX
ClearRamLoop_000:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_000
	RTS

LoadPalette_000:
	LDX #$00
LoadPaletteLoop_000:
	LDA PaletteData_000,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_000
	RTS

ReadController_000:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_000:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_000
	RTS

UpdatePlayer_000:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_000
	INC $20
PlayerNotRight_000:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_000
	DEC $20
PlayerNotLeft_000:
	RTS

UpdateObjects_000:
	LDY #$00
ObjectLoop_000:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_000
	RTS

DispatchEvent_000:
	ASL A
	TAX
	LDA EventJumpTable_000,X
	STA $F0
	LDA #>EventJumpTable_000
	STA $F1
	JMP (EVENT_VECTOR_000)

EventIdle_000:
	NOP
	RTS

EventStart_000:
	LDA #<MessageData_000
	STA $30
	LDA #>MessageData_000
	STA $31
	RTS

EventStop_000:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_000:
.word EventIdle_000,EventStart_000,EventStop_000

MessagePointers_000:
.addr MessageData_000,StatusMessage_000

PaletteData_000:
.byte $0F,$30,$10,$20

MessageData_000:
.byte $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_000:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_000:
.word Nmi_000,Reset_000,Irq_000
.byte <Reset_000,>Reset_000

; ======================================================================================
; PRG Bank 001 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8200
.const PPUCTRL_001=$2000
.const PPUMASK_001=$2001
.const PPUSTATUS_001=$2002
.const EVENT_VECTOR_001=$00F0

Reset_001:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_001
	STA PPUMASK_001
	STA $00
	STA $01
	JSR ClearRam_001
	JSR LoadPalette_001
	JMP MainLoop_001

Nmi_001:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_001
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_001:
	RTI

MainLoop_001:
	JSR ReadController_001
	JSR UpdatePlayer_001
	JSR UpdateObjects_001
	JMP MainLoop_001

ClearRam_001:
	LDA #$00
	TAX
ClearRamLoop_001:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_001
	RTS

LoadPalette_001:
	LDX #$00
LoadPaletteLoop_001:
	LDA PaletteData_001,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_001
	RTS

ReadController_001:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_001:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_001
	RTS

UpdatePlayer_001:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_001
	INC $20
PlayerNotRight_001:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_001
	DEC $20
PlayerNotLeft_001:
	RTS

UpdateObjects_001:
	LDY #$00
ObjectLoop_001:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_001
	RTS

DispatchEvent_001:
	ASL A
	TAX
	LDA EventJumpTable_001,X
	STA $F0
	LDA #>EventJumpTable_001
	STA $F1
	JMP (EVENT_VECTOR_001)

EventIdle_001:
	NOP
	RTS

EventStart_001:
	LDA #<MessageData_001
	STA $30
	LDA #>MessageData_001
	STA $31
	RTS

EventStop_001:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_001:
.word EventIdle_001,EventStart_001,EventStop_001

MessagePointers_001:
.addr MessageData_001,StatusMessage_001

PaletteData_001:
.byte $0F,$30,$11,$21

MessageData_001:
.byte $B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_001:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_001:
.word Nmi_001,Reset_001,Irq_001
.byte <Reset_001,>Reset_001

; ======================================================================================
; PRG Bank 002 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8400
.const PPUCTRL_002=$2000
.const PPUMASK_002=$2001
.const PPUSTATUS_002=$2002
.const EVENT_VECTOR_002=$00F0

Reset_002:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_002
	STA PPUMASK_002
	STA $00
	STA $01
	JSR ClearRam_002
	JSR LoadPalette_002
	JMP MainLoop_002

Nmi_002:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_002
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_002:
	RTI

MainLoop_002:
	JSR ReadController_002
	JSR UpdatePlayer_002
	JSR UpdateObjects_002
	JMP MainLoop_002

ClearRam_002:
	LDA #$00
	TAX
ClearRamLoop_002:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_002
	RTS

LoadPalette_002:
	LDX #$00
LoadPaletteLoop_002:
	LDA PaletteData_002,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_002
	RTS

ReadController_002:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_002:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_002
	RTS

UpdatePlayer_002:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_002
	INC $20
PlayerNotRight_002:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_002
	DEC $20
PlayerNotLeft_002:
	RTS

UpdateObjects_002:
	LDY #$00
ObjectLoop_002:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_002
	RTS

DispatchEvent_002:
	ASL A
	TAX
	LDA EventJumpTable_002,X
	STA $F0
	LDA #>EventJumpTable_002
	STA $F1
	JMP (EVENT_VECTOR_002)

EventIdle_002:
	NOP
	RTS

EventStart_002:
	LDA #<MessageData_002
	STA $30
	LDA #>MessageData_002
	STA $31
	RTS

EventStop_002:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_002:
.word EventIdle_002,EventStart_002,EventStop_002

MessagePointers_002:
.addr MessageData_002,StatusMessage_002

PaletteData_002:
.byte $0F,$30,$12,$22

MessageData_002:
.byte $B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_002:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_002:
.word Nmi_002,Reset_002,Irq_002
.byte <Reset_002,>Reset_002

; ======================================================================================
; PRG Bank 003 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8600
.const PPUCTRL_003=$2000
.const PPUMASK_003=$2001
.const PPUSTATUS_003=$2002
.const EVENT_VECTOR_003=$00F0

Reset_003:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_003
	STA PPUMASK_003
	STA $00
	STA $01
	JSR ClearRam_003
	JSR LoadPalette_003
	JMP MainLoop_003

Nmi_003:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_003
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_003:
	RTI

MainLoop_003:
	JSR ReadController_003
	JSR UpdatePlayer_003
	JSR UpdateObjects_003
	JMP MainLoop_003

ClearRam_003:
	LDA #$00
	TAX
ClearRamLoop_003:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_003
	RTS

LoadPalette_003:
	LDX #$00
LoadPaletteLoop_003:
	LDA PaletteData_003,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_003
	RTS

ReadController_003:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_003:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_003
	RTS

UpdatePlayer_003:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_003
	INC $20
PlayerNotRight_003:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_003
	DEC $20
PlayerNotLeft_003:
	RTS

UpdateObjects_003:
	LDY #$00
ObjectLoop_003:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_003
	RTS

DispatchEvent_003:
	ASL A
	TAX
	LDA EventJumpTable_003,X
	STA $F0
	LDA #>EventJumpTable_003
	STA $F1
	JMP (EVENT_VECTOR_003)

EventIdle_003:
	NOP
	RTS

EventStart_003:
	LDA #<MessageData_003
	STA $30
	LDA #>MessageData_003
	STA $31
	RTS

EventStop_003:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_003:
.word EventIdle_003,EventStart_003,EventStop_003

MessagePointers_003:
.addr MessageData_003,StatusMessage_003

PaletteData_003:
.byte $0F,$30,$13,$23

MessageData_003:
.byte $B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_003:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_003:
.word Nmi_003,Reset_003,Irq_003
.byte <Reset_003,>Reset_003

; ======================================================================================
; PRG Bank 004 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8800
.const PPUCTRL_004=$2000
.const PPUMASK_004=$2001
.const PPUSTATUS_004=$2002
.const EVENT_VECTOR_004=$00F0

Reset_004:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_004
	STA PPUMASK_004
	STA $00
	STA $01
	JSR ClearRam_004
	JSR LoadPalette_004
	JMP MainLoop_004

Nmi_004:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_004
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_004:
	RTI

MainLoop_004:
	JSR ReadController_004
	JSR UpdatePlayer_004
	JSR UpdateObjects_004
	JMP MainLoop_004

ClearRam_004:
	LDA #$00
	TAX
ClearRamLoop_004:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_004
	RTS

LoadPalette_004:
	LDX #$00
LoadPaletteLoop_004:
	LDA PaletteData_004,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_004
	RTS

ReadController_004:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_004:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_004
	RTS

UpdatePlayer_004:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_004
	INC $20
PlayerNotRight_004:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_004
	DEC $20
PlayerNotLeft_004:
	RTS

UpdateObjects_004:
	LDY #$00
ObjectLoop_004:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_004
	RTS

DispatchEvent_004:
	ASL A
	TAX
	LDA EventJumpTable_004,X
	STA $F0
	LDA #>EventJumpTable_004
	STA $F1
	JMP (EVENT_VECTOR_004)

EventIdle_004:
	NOP
	RTS

EventStart_004:
	LDA #<MessageData_004
	STA $30
	LDA #>MessageData_004
	STA $31
	RTS

EventStop_004:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_004:
.word EventIdle_004,EventStart_004,EventStop_004

MessagePointers_004:
.addr MessageData_004,StatusMessage_004

PaletteData_004:
.byte $0F,$30,$14,$24

MessageData_004:
.byte $B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_004:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_004:
.word Nmi_004,Reset_004,Irq_004
.byte <Reset_004,>Reset_004

; ======================================================================================
; PRG Bank 005 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8A00
.const PPUCTRL_005=$2000
.const PPUMASK_005=$2001
.const PPUSTATUS_005=$2002
.const EVENT_VECTOR_005=$00F0

Reset_005:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_005
	STA PPUMASK_005
	STA $00
	STA $01
	JSR ClearRam_005
	JSR LoadPalette_005
	JMP MainLoop_005

Nmi_005:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_005
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_005:
	RTI

MainLoop_005:
	JSR ReadController_005
	JSR UpdatePlayer_005
	JSR UpdateObjects_005
	JMP MainLoop_005

ClearRam_005:
	LDA #$00
	TAX
ClearRamLoop_005:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_005
	RTS

LoadPalette_005:
	LDX #$00
LoadPaletteLoop_005:
	LDA PaletteData_005,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_005
	RTS

ReadController_005:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_005:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_005
	RTS

UpdatePlayer_005:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_005
	INC $20
PlayerNotRight_005:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_005
	DEC $20
PlayerNotLeft_005:
	RTS

UpdateObjects_005:
	LDY #$00
ObjectLoop_005:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_005
	RTS

DispatchEvent_005:
	ASL A
	TAX
	LDA EventJumpTable_005,X
	STA $F0
	LDA #>EventJumpTable_005
	STA $F1
	JMP (EVENT_VECTOR_005)

EventIdle_005:
	NOP
	RTS

EventStart_005:
	LDA #<MessageData_005
	STA $30
	LDA #>MessageData_005
	STA $31
	RTS

EventStop_005:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_005:
.word EventIdle_005,EventStart_005,EventStop_005

MessagePointers_005:
.addr MessageData_005,StatusMessage_005

PaletteData_005:
.byte $0F,$30,$15,$25

MessageData_005:
.byte $B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_005:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_005:
.word Nmi_005,Reset_005,Irq_005
.byte <Reset_005,>Reset_005

; ======================================================================================
; PRG Bank 006 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8C00
.const PPUCTRL_006=$2000
.const PPUMASK_006=$2001
.const PPUSTATUS_006=$2002
.const EVENT_VECTOR_006=$00F0

Reset_006:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_006
	STA PPUMASK_006
	STA $00
	STA $01
	JSR ClearRam_006
	JSR LoadPalette_006
	JMP MainLoop_006

Nmi_006:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_006
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_006:
	RTI

MainLoop_006:
	JSR ReadController_006
	JSR UpdatePlayer_006
	JSR UpdateObjects_006
	JMP MainLoop_006

ClearRam_006:
	LDA #$00
	TAX
ClearRamLoop_006:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_006
	RTS

LoadPalette_006:
	LDX #$00
LoadPaletteLoop_006:
	LDA PaletteData_006,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_006
	RTS

ReadController_006:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_006:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_006
	RTS

UpdatePlayer_006:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_006
	INC $20
PlayerNotRight_006:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_006
	DEC $20
PlayerNotLeft_006:
	RTS

UpdateObjects_006:
	LDY #$00
ObjectLoop_006:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_006
	RTS

DispatchEvent_006:
	ASL A
	TAX
	LDA EventJumpTable_006,X
	STA $F0
	LDA #>EventJumpTable_006
	STA $F1
	JMP (EVENT_VECTOR_006)

EventIdle_006:
	NOP
	RTS

EventStart_006:
	LDA #<MessageData_006
	STA $30
	LDA #>MessageData_006
	STA $31
	RTS

EventStop_006:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_006:
.word EventIdle_006,EventStart_006,EventStop_006

MessagePointers_006:
.addr MessageData_006,StatusMessage_006

PaletteData_006:
.byte $0F,$30,$16,$26

MessageData_006:
.byte $B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_006:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_006:
.word Nmi_006,Reset_006,Irq_006
.byte <Reset_006,>Reset_006

; ======================================================================================
; PRG Bank 007 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8E00
.const PPUCTRL_007=$2000
.const PPUMASK_007=$2001
.const PPUSTATUS_007=$2002
.const EVENT_VECTOR_007=$00F0

Reset_007:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_007
	STA PPUMASK_007
	STA $00
	STA $01
	JSR ClearRam_007
	JSR LoadPalette_007
	JMP MainLoop_007

Nmi_007:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_007
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_007:
	RTI

MainLoop_007:
	JSR ReadController_007
	JSR UpdatePlayer_007
	JSR UpdateObjects_007
	JMP MainLoop_007

ClearRam_007:
	LDA #$00
	TAX
ClearRamLoop_007:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_007
	RTS

LoadPalette_007:
	LDX #$00
LoadPaletteLoop_007:
	LDA PaletteData_007,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_007
	RTS

ReadController_007:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_007:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_007
	RTS

UpdatePlayer_007:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_007
	INC $20
PlayerNotRight_007:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_007
	DEC $20
PlayerNotLeft_007:
	RTS

UpdateObjects_007:
	LDY #$00
ObjectLoop_007:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_007
	RTS

DispatchEvent_007:
	ASL A
	TAX
	LDA EventJumpTable_007,X
	STA $F0
	LDA #>EventJumpTable_007
	STA $F1
	JMP (EVENT_VECTOR_007)

EventIdle_007:
	NOP
	RTS

EventStart_007:
	LDA #<MessageData_007
	STA $30
	LDA #>MessageData_007
	STA $31
	RTS

EventStop_007:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_007:
.word EventIdle_007,EventStart_007,EventStop_007

MessagePointers_007:
.addr MessageData_007,StatusMessage_007

PaletteData_007:
.byte $0F,$30,$17,$27

MessageData_007:
.byte $B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_007:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_007:
.word Nmi_007,Reset_007,Irq_007
.byte <Reset_007,>Reset_007

; ======================================================================================
; PRG Bank 008 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9000
.const PPUCTRL_008=$2000
.const PPUMASK_008=$2001
.const PPUSTATUS_008=$2002
.const EVENT_VECTOR_008=$00F0

Reset_008:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_008
	STA PPUMASK_008
	STA $00
	STA $01
	JSR ClearRam_008
	JSR LoadPalette_008
	JMP MainLoop_008

Nmi_008:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_008
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_008:
	RTI

MainLoop_008:
	JSR ReadController_008
	JSR UpdatePlayer_008
	JSR UpdateObjects_008
	JMP MainLoop_008

ClearRam_008:
	LDA #$00
	TAX
ClearRamLoop_008:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_008
	RTS

LoadPalette_008:
	LDX #$00
LoadPaletteLoop_008:
	LDA PaletteData_008,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_008
	RTS

ReadController_008:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_008:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_008
	RTS

UpdatePlayer_008:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_008
	INC $20
PlayerNotRight_008:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_008
	DEC $20
PlayerNotLeft_008:
	RTS

UpdateObjects_008:
	LDY #$00
ObjectLoop_008:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_008
	RTS

DispatchEvent_008:
	ASL A
	TAX
	LDA EventJumpTable_008,X
	STA $F0
	LDA #>EventJumpTable_008
	STA $F1
	JMP (EVENT_VECTOR_008)

EventIdle_008:
	NOP
	RTS

EventStart_008:
	LDA #<MessageData_008
	STA $30
	LDA #>MessageData_008
	STA $31
	RTS

EventStop_008:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_008:
.word EventIdle_008,EventStart_008,EventStop_008

MessagePointers_008:
.addr MessageData_008,StatusMessage_008

PaletteData_008:
.byte $0F,$30,$18,$28

MessageData_008:
.byte $B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_008:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_008:
.word Nmi_008,Reset_008,Irq_008
.byte <Reset_008,>Reset_008

; ======================================================================================
; PRG Bank 009 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9200
.const PPUCTRL_009=$2000
.const PPUMASK_009=$2001
.const PPUSTATUS_009=$2002
.const EVENT_VECTOR_009=$00F0

Reset_009:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_009
	STA PPUMASK_009
	STA $00
	STA $01
	JSR ClearRam_009
	JSR LoadPalette_009
	JMP MainLoop_009

Nmi_009:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_009
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_009:
	RTI

MainLoop_009:
	JSR ReadController_009
	JSR UpdatePlayer_009
	JSR UpdateObjects_009
	JMP MainLoop_009

ClearRam_009:
	LDA #$00
	TAX
ClearRamLoop_009:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_009
	RTS

LoadPalette_009:
	LDX #$00
LoadPaletteLoop_009:
	LDA PaletteData_009,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_009
	RTS

ReadController_009:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_009:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_009
	RTS

UpdatePlayer_009:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_009
	INC $20
PlayerNotRight_009:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_009
	DEC $20
PlayerNotLeft_009:
	RTS

UpdateObjects_009:
	LDY #$00
ObjectLoop_009:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_009
	RTS

DispatchEvent_009:
	ASL A
	TAX
	LDA EventJumpTable_009,X
	STA $F0
	LDA #>EventJumpTable_009
	STA $F1
	JMP (EVENT_VECTOR_009)

EventIdle_009:
	NOP
	RTS

EventStart_009:
	LDA #<MessageData_009
	STA $30
	LDA #>MessageData_009
	STA $31
	RTS

EventStop_009:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_009:
.word EventIdle_009,EventStart_009,EventStop_009

MessagePointers_009:
.addr MessageData_009,StatusMessage_009

PaletteData_009:
.byte $0F,$30,$19,$29

MessageData_009:
.byte $B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_009:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_009:
.word Nmi_009,Reset_009,Irq_009
.byte <Reset_009,>Reset_009

; ======================================================================================
; PRG Bank 010 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9400
.const PPUCTRL_010=$2000
.const PPUMASK_010=$2001
.const PPUSTATUS_010=$2002
.const EVENT_VECTOR_010=$00F0

Reset_010:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_010
	STA PPUMASK_010
	STA $00
	STA $01
	JSR ClearRam_010
	JSR LoadPalette_010
	JMP MainLoop_010

Nmi_010:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_010
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_010:
	RTI

MainLoop_010:
	JSR ReadController_010
	JSR UpdatePlayer_010
	JSR UpdateObjects_010
	JMP MainLoop_010

ClearRam_010:
	LDA #$00
	TAX
ClearRamLoop_010:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_010
	RTS

LoadPalette_010:
	LDX #$00
LoadPaletteLoop_010:
	LDA PaletteData_010,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_010
	RTS

ReadController_010:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_010:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_010
	RTS

UpdatePlayer_010:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_010
	INC $20
PlayerNotRight_010:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_010
	DEC $20
PlayerNotLeft_010:
	RTS

UpdateObjects_010:
	LDY #$00
ObjectLoop_010:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_010
	RTS

DispatchEvent_010:
	ASL A
	TAX
	LDA EventJumpTable_010,X
	STA $F0
	LDA #>EventJumpTable_010
	STA $F1
	JMP (EVENT_VECTOR_010)

EventIdle_010:
	NOP
	RTS

EventStart_010:
	LDA #<MessageData_010
	STA $30
	LDA #>MessageData_010
	STA $31
	RTS

EventStop_010:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_010:
.word EventIdle_010,EventStart_010,EventStop_010

MessagePointers_010:
.addr MessageData_010,StatusMessage_010

PaletteData_010:
.byte $0F,$30,$1A,$2A

MessageData_010:
.byte $BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_010:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_010:
.word Nmi_010,Reset_010,Irq_010
.byte <Reset_010,>Reset_010

; ======================================================================================
; PRG Bank 011 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9600
.const PPUCTRL_011=$2000
.const PPUMASK_011=$2001
.const PPUSTATUS_011=$2002
.const EVENT_VECTOR_011=$00F0

Reset_011:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_011
	STA PPUMASK_011
	STA $00
	STA $01
	JSR ClearRam_011
	JSR LoadPalette_011
	JMP MainLoop_011

Nmi_011:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_011
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_011:
	RTI

MainLoop_011:
	JSR ReadController_011
	JSR UpdatePlayer_011
	JSR UpdateObjects_011
	JMP MainLoop_011

ClearRam_011:
	LDA #$00
	TAX
ClearRamLoop_011:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_011
	RTS

LoadPalette_011:
	LDX #$00
LoadPaletteLoop_011:
	LDA PaletteData_011,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_011
	RTS

ReadController_011:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_011:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_011
	RTS

UpdatePlayer_011:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_011
	INC $20
PlayerNotRight_011:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_011
	DEC $20
PlayerNotLeft_011:
	RTS

UpdateObjects_011:
	LDY #$00
ObjectLoop_011:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_011
	RTS

DispatchEvent_011:
	ASL A
	TAX
	LDA EventJumpTable_011,X
	STA $F0
	LDA #>EventJumpTable_011
	STA $F1
	JMP (EVENT_VECTOR_011)

EventIdle_011:
	NOP
	RTS

EventStart_011:
	LDA #<MessageData_011
	STA $30
	LDA #>MessageData_011
	STA $31
	RTS

EventStop_011:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_011:
.word EventIdle_011,EventStart_011,EventStop_011

MessagePointers_011:
.addr MessageData_011,StatusMessage_011

PaletteData_011:
.byte $0F,$30,$1B,$2B

MessageData_011:
.byte $BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_011:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_011:
.word Nmi_011,Reset_011,Irq_011
.byte <Reset_011,>Reset_011

; ======================================================================================
; PRG Bank 012 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9800
.const PPUCTRL_012=$2000
.const PPUMASK_012=$2001
.const PPUSTATUS_012=$2002
.const EVENT_VECTOR_012=$00F0

Reset_012:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_012
	STA PPUMASK_012
	STA $00
	STA $01
	JSR ClearRam_012
	JSR LoadPalette_012
	JMP MainLoop_012

Nmi_012:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_012
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_012:
	RTI

MainLoop_012:
	JSR ReadController_012
	JSR UpdatePlayer_012
	JSR UpdateObjects_012
	JMP MainLoop_012

ClearRam_012:
	LDA #$00
	TAX
ClearRamLoop_012:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_012
	RTS

LoadPalette_012:
	LDX #$00
LoadPaletteLoop_012:
	LDA PaletteData_012,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_012
	RTS

ReadController_012:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_012:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_012
	RTS

UpdatePlayer_012:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_012
	INC $20
PlayerNotRight_012:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_012
	DEC $20
PlayerNotLeft_012:
	RTS

UpdateObjects_012:
	LDY #$00
ObjectLoop_012:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_012
	RTS

DispatchEvent_012:
	ASL A
	TAX
	LDA EventJumpTable_012,X
	STA $F0
	LDA #>EventJumpTable_012
	STA $F1
	JMP (EVENT_VECTOR_012)

EventIdle_012:
	NOP
	RTS

EventStart_012:
	LDA #<MessageData_012
	STA $30
	LDA #>MessageData_012
	STA $31
	RTS

EventStop_012:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_012:
.word EventIdle_012,EventStart_012,EventStop_012

MessagePointers_012:
.addr MessageData_012,StatusMessage_012

PaletteData_012:
.byte $0F,$30,$1C,$2C

MessageData_012:
.byte $BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_012:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_012:
.word Nmi_012,Reset_012,Irq_012
.byte <Reset_012,>Reset_012

; ======================================================================================
; PRG Bank 013 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9A00
.const PPUCTRL_013=$2000
.const PPUMASK_013=$2001
.const PPUSTATUS_013=$2002
.const EVENT_VECTOR_013=$00F0

Reset_013:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_013
	STA PPUMASK_013
	STA $00
	STA $01
	JSR ClearRam_013
	JSR LoadPalette_013
	JMP MainLoop_013

Nmi_013:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_013
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_013:
	RTI

MainLoop_013:
	JSR ReadController_013
	JSR UpdatePlayer_013
	JSR UpdateObjects_013
	JMP MainLoop_013

ClearRam_013:
	LDA #$00
	TAX
ClearRamLoop_013:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_013
	RTS

LoadPalette_013:
	LDX #$00
LoadPaletteLoop_013:
	LDA PaletteData_013,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_013
	RTS

ReadController_013:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_013:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_013
	RTS

UpdatePlayer_013:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_013
	INC $20
PlayerNotRight_013:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_013
	DEC $20
PlayerNotLeft_013:
	RTS

UpdateObjects_013:
	LDY #$00
ObjectLoop_013:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_013
	RTS

DispatchEvent_013:
	ASL A
	TAX
	LDA EventJumpTable_013,X
	STA $F0
	LDA #>EventJumpTable_013
	STA $F1
	JMP (EVENT_VECTOR_013)

EventIdle_013:
	NOP
	RTS

EventStart_013:
	LDA #<MessageData_013
	STA $30
	LDA #>MessageData_013
	STA $31
	RTS

EventStop_013:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_013:
.word EventIdle_013,EventStart_013,EventStop_013

MessagePointers_013:
.addr MessageData_013,StatusMessage_013

PaletteData_013:
.byte $0F,$30,$1D,$2D

MessageData_013:
.byte $BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_013:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_013:
.word Nmi_013,Reset_013,Irq_013
.byte <Reset_013,>Reset_013

; ======================================================================================
; PRG Bank 014 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9C00
.const PPUCTRL_014=$2000
.const PPUMASK_014=$2001
.const PPUSTATUS_014=$2002
.const EVENT_VECTOR_014=$00F0

Reset_014:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_014
	STA PPUMASK_014
	STA $00
	STA $01
	JSR ClearRam_014
	JSR LoadPalette_014
	JMP MainLoop_014

Nmi_014:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_014
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_014:
	RTI

MainLoop_014:
	JSR ReadController_014
	JSR UpdatePlayer_014
	JSR UpdateObjects_014
	JMP MainLoop_014

ClearRam_014:
	LDA #$00
	TAX
ClearRamLoop_014:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_014
	RTS

LoadPalette_014:
	LDX #$00
LoadPaletteLoop_014:
	LDA PaletteData_014,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_014
	RTS

ReadController_014:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_014:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_014
	RTS

UpdatePlayer_014:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_014
	INC $20
PlayerNotRight_014:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_014
	DEC $20
PlayerNotLeft_014:
	RTS

UpdateObjects_014:
	LDY #$00
ObjectLoop_014:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_014
	RTS

DispatchEvent_014:
	ASL A
	TAX
	LDA EventJumpTable_014,X
	STA $F0
	LDA #>EventJumpTable_014
	STA $F1
	JMP (EVENT_VECTOR_014)

EventIdle_014:
	NOP
	RTS

EventStart_014:
	LDA #<MessageData_014
	STA $30
	LDA #>MessageData_014
	STA $31
	RTS

EventStop_014:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_014:
.word EventIdle_014,EventStart_014,EventStop_014

MessagePointers_014:
.addr MessageData_014,StatusMessage_014

PaletteData_014:
.byte $0F,$30,$1E,$2E

MessageData_014:
.byte $BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_014:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_014:
.word Nmi_014,Reset_014,Irq_014
.byte <Reset_014,>Reset_014

; ======================================================================================
; PRG Bank 015 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $9E00
.const PPUCTRL_015=$2000
.const PPUMASK_015=$2001
.const PPUSTATUS_015=$2002
.const EVENT_VECTOR_015=$00F0

Reset_015:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_015
	STA PPUMASK_015
	STA $00
	STA $01
	JSR ClearRam_015
	JSR LoadPalette_015
	JMP MainLoop_015

Nmi_015:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_015
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_015:
	RTI

MainLoop_015:
	JSR ReadController_015
	JSR UpdatePlayer_015
	JSR UpdateObjects_015
	JMP MainLoop_015

ClearRam_015:
	LDA #$00
	TAX
ClearRamLoop_015:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_015
	RTS

LoadPalette_015:
	LDX #$00
LoadPaletteLoop_015:
	LDA PaletteData_015,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_015
	RTS

ReadController_015:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_015:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_015
	RTS

UpdatePlayer_015:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_015
	INC $20
PlayerNotRight_015:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_015
	DEC $20
PlayerNotLeft_015:
	RTS

UpdateObjects_015:
	LDY #$00
ObjectLoop_015:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_015
	RTS

DispatchEvent_015:
	ASL A
	TAX
	LDA EventJumpTable_015,X
	STA $F0
	LDA #>EventJumpTable_015
	STA $F1
	JMP (EVENT_VECTOR_015)

EventIdle_015:
	NOP
	RTS

EventStart_015:
	LDA #<MessageData_015
	STA $30
	LDA #>MessageData_015
	STA $31
	RTS

EventStop_015:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_015:
.word EventIdle_015,EventStart_015,EventStop_015

MessagePointers_015:
.addr MessageData_015,StatusMessage_015

PaletteData_015:
.byte $0F,$30,$1F,$2F

MessageData_015:
.byte $BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_015:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_015:
.word Nmi_015,Reset_015,Irq_015
.byte <Reset_015,>Reset_015

; ======================================================================================
; PRG Bank 016 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $A000
.const PPUCTRL_016=$2000
.const PPUMASK_016=$2001
.const PPUSTATUS_016=$2002
.const EVENT_VECTOR_016=$00F0

Reset_016:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_016
	STA PPUMASK_016
	STA $00
	STA $01
	JSR ClearRam_016
	JSR LoadPalette_016
	JMP MainLoop_016

Nmi_016:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_016
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_016:
	RTI

MainLoop_016:
	JSR ReadController_016
	JSR UpdatePlayer_016
	JSR UpdateObjects_016
	JMP MainLoop_016

ClearRam_016:
	LDA #$00
	TAX
ClearRamLoop_016:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_016
	RTS

LoadPalette_016:
	LDX #$00
LoadPaletteLoop_016:
	LDA PaletteData_016,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_016
	RTS

ReadController_016:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_016:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_016
	RTS

UpdatePlayer_016:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_016
	INC $20
PlayerNotRight_016:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_016
	DEC $20
PlayerNotLeft_016:
	RTS

UpdateObjects_016:
	LDY #$00
ObjectLoop_016:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_016
	RTS

DispatchEvent_016:
	ASL A
	TAX
	LDA EventJumpTable_016,X
	STA $F0
	LDA #>EventJumpTable_016
	STA $F1
	JMP (EVENT_VECTOR_016)

EventIdle_016:
	NOP
	RTS

EventStart_016:
	LDA #<MessageData_016
	STA $30
	LDA #>MessageData_016
	STA $31
	RTS

EventStop_016:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_016:
.word EventIdle_016,EventStart_016,EventStop_016

MessagePointers_016:
.addr MessageData_016,StatusMessage_016

PaletteData_016:
.byte $0F,$30,$20,$30

MessageData_016:
.byte $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_016:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_016:
.word Nmi_016,Reset_016,Irq_016
.byte <Reset_016,>Reset_016

; ======================================================================================
; PRG Bank 017 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $A200
.const PPUCTRL_017=$2000
.const PPUMASK_017=$2001
.const PPUSTATUS_017=$2002
.const EVENT_VECTOR_017=$00F0

Reset_017:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_017
	STA PPUMASK_017
	STA $00
	STA $01
	JSR ClearRam_017
	JSR LoadPalette_017
	JMP MainLoop_017

Nmi_017:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_017
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_017:
	RTI

MainLoop_017:
	JSR ReadController_017
	JSR UpdatePlayer_017
	JSR UpdateObjects_017
	JMP MainLoop_017

ClearRam_017:
	LDA #$00
	TAX
ClearRamLoop_017:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_017
	RTS

LoadPalette_017:
	LDX #$00
LoadPaletteLoop_017:
	LDA PaletteData_017,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_017
	RTS

ReadController_017:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_017:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_017
	RTS

UpdatePlayer_017:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_017
	INC $20
PlayerNotRight_017:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_017
	DEC $20
PlayerNotLeft_017:
	RTS

UpdateObjects_017:
	LDY #$00
ObjectLoop_017:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_017
	RTS

DispatchEvent_017:
	ASL A
	TAX
	LDA EventJumpTable_017,X
	STA $F0
	LDA #>EventJumpTable_017
	STA $F1
	JMP (EVENT_VECTOR_017)

EventIdle_017:
	NOP
	RTS

EventStart_017:
	LDA #<MessageData_017
	STA $30
	LDA #>MessageData_017
	STA $31
	RTS

EventStop_017:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_017:
.word EventIdle_017,EventStart_017,EventStop_017

MessagePointers_017:
.addr MessageData_017,StatusMessage_017

PaletteData_017:
.byte $0F,$30,$21,$31

MessageData_017:
.byte $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_017:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_017:
.word Nmi_017,Reset_017,Irq_017
.byte <Reset_017,>Reset_017

; ======================================================================================
; PRG Bank 018 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $A400
.const PPUCTRL_018=$2000
.const PPUMASK_018=$2001
.const PPUSTATUS_018=$2002
.const EVENT_VECTOR_018=$00F0

Reset_018:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_018
	STA PPUMASK_018
	STA $00
	STA $01
	JSR ClearRam_018
	JSR LoadPalette_018
	JMP MainLoop_018

Nmi_018:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_018
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_018:
	RTI

MainLoop_018:
	JSR ReadController_018
	JSR UpdatePlayer_018
	JSR UpdateObjects_018
	JMP MainLoop_018

ClearRam_018:
	LDA #$00
	TAX
ClearRamLoop_018:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_018
	RTS

LoadPalette_018:
	LDX #$00
LoadPaletteLoop_018:
	LDA PaletteData_018,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_018
	RTS

ReadController_018:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_018:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_018
	RTS

UpdatePlayer_018:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_018
	INC $20
PlayerNotRight_018:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_018
	DEC $20
PlayerNotLeft_018:
	RTS

UpdateObjects_018:
	LDY #$00
ObjectLoop_018:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_018
	RTS

DispatchEvent_018:
	ASL A
	TAX
	LDA EventJumpTable_018,X
	STA $F0
	LDA #>EventJumpTable_018
	STA $F1
	JMP (EVENT_VECTOR_018)

EventIdle_018:
	NOP
	RTS

EventStart_018:
	LDA #<MessageData_018
	STA $30
	LDA #>MessageData_018
	STA $31
	RTS

EventStop_018:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_018:
.word EventIdle_018,EventStart_018,EventStop_018

MessagePointers_018:
.addr MessageData_018,StatusMessage_018

PaletteData_018:
.byte $0F,$30,$22,$32

MessageData_018:
.byte $C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_018:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_018:
.word Nmi_018,Reset_018,Irq_018
.byte <Reset_018,>Reset_018

; ======================================================================================
; PRG Bank 019 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $A600
.const PPUCTRL_019=$2000
.const PPUMASK_019=$2001
.const PPUSTATUS_019=$2002
.const EVENT_VECTOR_019=$00F0

Reset_019:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_019
	STA PPUMASK_019
	STA $00
	STA $01
	JSR ClearRam_019
	JSR LoadPalette_019
	JMP MainLoop_019

Nmi_019:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_019
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_019:
	RTI

MainLoop_019:
	JSR ReadController_019
	JSR UpdatePlayer_019
	JSR UpdateObjects_019
	JMP MainLoop_019

ClearRam_019:
	LDA #$00
	TAX
ClearRamLoop_019:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_019
	RTS

LoadPalette_019:
	LDX #$00
LoadPaletteLoop_019:
	LDA PaletteData_019,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_019
	RTS

ReadController_019:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_019:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_019
	RTS

UpdatePlayer_019:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_019
	INC $20
PlayerNotRight_019:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_019
	DEC $20
PlayerNotLeft_019:
	RTS

UpdateObjects_019:
	LDY #$00
ObjectLoop_019:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_019
	RTS

DispatchEvent_019:
	ASL A
	TAX
	LDA EventJumpTable_019,X
	STA $F0
	LDA #>EventJumpTable_019
	STA $F1
	JMP (EVENT_VECTOR_019)

EventIdle_019:
	NOP
	RTS

EventStart_019:
	LDA #<MessageData_019
	STA $30
	LDA #>MessageData_019
	STA $31
	RTS

EventStop_019:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_019:
.word EventIdle_019,EventStart_019,EventStop_019

MessagePointers_019:
.addr MessageData_019,StatusMessage_019

PaletteData_019:
.byte $0F,$30,$23,$33

MessageData_019:
.byte $C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_019:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_019:
.word Nmi_019,Reset_019,Irq_019
.byte <Reset_019,>Reset_019

; ======================================================================================
; PRG Bank 020 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $A800
.const PPUCTRL_020=$2000
.const PPUMASK_020=$2001
.const PPUSTATUS_020=$2002
.const EVENT_VECTOR_020=$00F0

Reset_020:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_020
	STA PPUMASK_020
	STA $00
	STA $01
	JSR ClearRam_020
	JSR LoadPalette_020
	JMP MainLoop_020

Nmi_020:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_020
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_020:
	RTI

MainLoop_020:
	JSR ReadController_020
	JSR UpdatePlayer_020
	JSR UpdateObjects_020
	JMP MainLoop_020

ClearRam_020:
	LDA #$00
	TAX
ClearRamLoop_020:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_020
	RTS

LoadPalette_020:
	LDX #$00
LoadPaletteLoop_020:
	LDA PaletteData_020,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_020
	RTS

ReadController_020:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_020:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_020
	RTS

UpdatePlayer_020:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_020
	INC $20
PlayerNotRight_020:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_020
	DEC $20
PlayerNotLeft_020:
	RTS

UpdateObjects_020:
	LDY #$00
ObjectLoop_020:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_020
	RTS

DispatchEvent_020:
	ASL A
	TAX
	LDA EventJumpTable_020,X
	STA $F0
	LDA #>EventJumpTable_020
	STA $F1
	JMP (EVENT_VECTOR_020)

EventIdle_020:
	NOP
	RTS

EventStart_020:
	LDA #<MessageData_020
	STA $30
	LDA #>MessageData_020
	STA $31
	RTS

EventStop_020:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_020:
.word EventIdle_020,EventStart_020,EventStop_020

MessagePointers_020:
.addr MessageData_020,StatusMessage_020

PaletteData_020:
.byte $0F,$30,$24,$34

MessageData_020:
.byte $C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_020:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_020:
.word Nmi_020,Reset_020,Irq_020
.byte <Reset_020,>Reset_020

; ======================================================================================
; PRG Bank 021 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $AA00
.const PPUCTRL_021=$2000
.const PPUMASK_021=$2001
.const PPUSTATUS_021=$2002
.const EVENT_VECTOR_021=$00F0

Reset_021:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_021
	STA PPUMASK_021
	STA $00
	STA $01
	JSR ClearRam_021
	JSR LoadPalette_021
	JMP MainLoop_021

Nmi_021:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_021
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_021:
	RTI

MainLoop_021:
	JSR ReadController_021
	JSR UpdatePlayer_021
	JSR UpdateObjects_021
	JMP MainLoop_021

ClearRam_021:
	LDA #$00
	TAX
ClearRamLoop_021:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_021
	RTS

LoadPalette_021:
	LDX #$00
LoadPaletteLoop_021:
	LDA PaletteData_021,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_021
	RTS

ReadController_021:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_021:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_021
	RTS

UpdatePlayer_021:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_021
	INC $20
PlayerNotRight_021:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_021
	DEC $20
PlayerNotLeft_021:
	RTS

UpdateObjects_021:
	LDY #$00
ObjectLoop_021:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_021
	RTS

DispatchEvent_021:
	ASL A
	TAX
	LDA EventJumpTable_021,X
	STA $F0
	LDA #>EventJumpTable_021
	STA $F1
	JMP (EVENT_VECTOR_021)

EventIdle_021:
	NOP
	RTS

EventStart_021:
	LDA #<MessageData_021
	STA $30
	LDA #>MessageData_021
	STA $31
	RTS

EventStop_021:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_021:
.word EventIdle_021,EventStart_021,EventStop_021

MessagePointers_021:
.addr MessageData_021,StatusMessage_021

PaletteData_021:
.byte $0F,$30,$25,$35

MessageData_021:
.byte $C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_021:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_021:
.word Nmi_021,Reset_021,Irq_021
.byte <Reset_021,>Reset_021

; ======================================================================================
; PRG Bank 022 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $AC00
.const PPUCTRL_022=$2000
.const PPUMASK_022=$2001
.const PPUSTATUS_022=$2002
.const EVENT_VECTOR_022=$00F0

Reset_022:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_022
	STA PPUMASK_022
	STA $00
	STA $01
	JSR ClearRam_022
	JSR LoadPalette_022
	JMP MainLoop_022

Nmi_022:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_022
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_022:
	RTI

MainLoop_022:
	JSR ReadController_022
	JSR UpdatePlayer_022
	JSR UpdateObjects_022
	JMP MainLoop_022

ClearRam_022:
	LDA #$00
	TAX
ClearRamLoop_022:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_022
	RTS

LoadPalette_022:
	LDX #$00
LoadPaletteLoop_022:
	LDA PaletteData_022,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_022
	RTS

ReadController_022:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_022:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_022
	RTS

UpdatePlayer_022:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_022
	INC $20
PlayerNotRight_022:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_022
	DEC $20
PlayerNotLeft_022:
	RTS

UpdateObjects_022:
	LDY #$00
ObjectLoop_022:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_022
	RTS

DispatchEvent_022:
	ASL A
	TAX
	LDA EventJumpTable_022,X
	STA $F0
	LDA #>EventJumpTable_022
	STA $F1
	JMP (EVENT_VECTOR_022)

EventIdle_022:
	NOP
	RTS

EventStart_022:
	LDA #<MessageData_022
	STA $30
	LDA #>MessageData_022
	STA $31
	RTS

EventStop_022:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_022:
.word EventIdle_022,EventStart_022,EventStop_022

MessagePointers_022:
.addr MessageData_022,StatusMessage_022

PaletteData_022:
.byte $0F,$30,$26,$36

MessageData_022:
.byte $C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_022:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_022:
.word Nmi_022,Reset_022,Irq_022
.byte <Reset_022,>Reset_022

; ======================================================================================
; PRG Bank 023 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $AE00
.const PPUCTRL_023=$2000
.const PPUMASK_023=$2001
.const PPUSTATUS_023=$2002
.const EVENT_VECTOR_023=$00F0

Reset_023:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_023
	STA PPUMASK_023
	STA $00
	STA $01
	JSR ClearRam_023
	JSR LoadPalette_023
	JMP MainLoop_023

Nmi_023:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_023
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_023:
	RTI

MainLoop_023:
	JSR ReadController_023
	JSR UpdatePlayer_023
	JSR UpdateObjects_023
	JMP MainLoop_023

ClearRam_023:
	LDA #$00
	TAX
ClearRamLoop_023:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_023
	RTS

LoadPalette_023:
	LDX #$00
LoadPaletteLoop_023:
	LDA PaletteData_023,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_023
	RTS

ReadController_023:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_023:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_023
	RTS

UpdatePlayer_023:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_023
	INC $20
PlayerNotRight_023:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_023
	DEC $20
PlayerNotLeft_023:
	RTS

UpdateObjects_023:
	LDY #$00
ObjectLoop_023:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_023
	RTS

DispatchEvent_023:
	ASL A
	TAX
	LDA EventJumpTable_023,X
	STA $F0
	LDA #>EventJumpTable_023
	STA $F1
	JMP (EVENT_VECTOR_023)

EventIdle_023:
	NOP
	RTS

EventStart_023:
	LDA #<MessageData_023
	STA $30
	LDA #>MessageData_023
	STA $31
	RTS

EventStop_023:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_023:
.word EventIdle_023,EventStart_023,EventStop_023

MessagePointers_023:
.addr MessageData_023,StatusMessage_023

PaletteData_023:
.byte $0F,$30,$27,$37

MessageData_023:
.byte $C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_023:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_023:
.word Nmi_023,Reset_023,Irq_023
.byte <Reset_023,>Reset_023

; ======================================================================================
; PRG Bank 024 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $B000
.const PPUCTRL_024=$2000
.const PPUMASK_024=$2001
.const PPUSTATUS_024=$2002
.const EVENT_VECTOR_024=$00F0

Reset_024:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_024
	STA PPUMASK_024
	STA $00
	STA $01
	JSR ClearRam_024
	JSR LoadPalette_024
	JMP MainLoop_024

Nmi_024:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_024
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_024:
	RTI

MainLoop_024:
	JSR ReadController_024
	JSR UpdatePlayer_024
	JSR UpdateObjects_024
	JMP MainLoop_024

ClearRam_024:
	LDA #$00
	TAX
ClearRamLoop_024:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_024
	RTS

LoadPalette_024:
	LDX #$00
LoadPaletteLoop_024:
	LDA PaletteData_024,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_024
	RTS

ReadController_024:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_024:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_024
	RTS

UpdatePlayer_024:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_024
	INC $20
PlayerNotRight_024:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_024
	DEC $20
PlayerNotLeft_024:
	RTS

UpdateObjects_024:
	LDY #$00
ObjectLoop_024:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_024
	RTS

DispatchEvent_024:
	ASL A
	TAX
	LDA EventJumpTable_024,X
	STA $F0
	LDA #>EventJumpTable_024
	STA $F1
	JMP (EVENT_VECTOR_024)

EventIdle_024:
	NOP
	RTS

EventStart_024:
	LDA #<MessageData_024
	STA $30
	LDA #>MessageData_024
	STA $31
	RTS

EventStop_024:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_024:
.word EventIdle_024,EventStart_024,EventStop_024

MessagePointers_024:
.addr MessageData_024,StatusMessage_024

PaletteData_024:
.byte $0F,$30,$28,$38

MessageData_024:
.byte $C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_024:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_024:
.word Nmi_024,Reset_024,Irq_024
.byte <Reset_024,>Reset_024

; ======================================================================================
; PRG Bank 025 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $B200
.const PPUCTRL_025=$2000
.const PPUMASK_025=$2001
.const PPUSTATUS_025=$2002
.const EVENT_VECTOR_025=$00F0

Reset_025:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_025
	STA PPUMASK_025
	STA $00
	STA $01
	JSR ClearRam_025
	JSR LoadPalette_025
	JMP MainLoop_025

Nmi_025:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_025
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_025:
	RTI

MainLoop_025:
	JSR ReadController_025
	JSR UpdatePlayer_025
	JSR UpdateObjects_025
	JMP MainLoop_025

ClearRam_025:
	LDA #$00
	TAX
ClearRamLoop_025:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_025
	RTS

LoadPalette_025:
	LDX #$00
LoadPaletteLoop_025:
	LDA PaletteData_025,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_025
	RTS

ReadController_025:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_025:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_025
	RTS

UpdatePlayer_025:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_025
	INC $20
PlayerNotRight_025:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_025
	DEC $20
PlayerNotLeft_025:
	RTS

UpdateObjects_025:
	LDY #$00
ObjectLoop_025:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_025
	RTS

DispatchEvent_025:
	ASL A
	TAX
	LDA EventJumpTable_025,X
	STA $F0
	LDA #>EventJumpTable_025
	STA $F1
	JMP (EVENT_VECTOR_025)

EventIdle_025:
	NOP
	RTS

EventStart_025:
	LDA #<MessageData_025
	STA $30
	LDA #>MessageData_025
	STA $31
	RTS

EventStop_025:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_025:
.word EventIdle_025,EventStart_025,EventStop_025

MessagePointers_025:
.addr MessageData_025,StatusMessage_025

PaletteData_025:
.byte $0F,$30,$29,$39

MessageData_025:
.byte $C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_025:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_025:
.word Nmi_025,Reset_025,Irq_025
.byte <Reset_025,>Reset_025

; ======================================================================================
; PRG Bank 026 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $B400
.const PPUCTRL_026=$2000
.const PPUMASK_026=$2001
.const PPUSTATUS_026=$2002
.const EVENT_VECTOR_026=$00F0

Reset_026:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_026
	STA PPUMASK_026
	STA $00
	STA $01
	JSR ClearRam_026
	JSR LoadPalette_026
	JMP MainLoop_026

Nmi_026:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_026
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_026:
	RTI

MainLoop_026:
	JSR ReadController_026
	JSR UpdatePlayer_026
	JSR UpdateObjects_026
	JMP MainLoop_026

ClearRam_026:
	LDA #$00
	TAX
ClearRamLoop_026:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_026
	RTS

LoadPalette_026:
	LDX #$00
LoadPaletteLoop_026:
	LDA PaletteData_026,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_026
	RTS

ReadController_026:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_026:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_026
	RTS

UpdatePlayer_026:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_026
	INC $20
PlayerNotRight_026:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_026
	DEC $20
PlayerNotLeft_026:
	RTS

UpdateObjects_026:
	LDY #$00
ObjectLoop_026:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_026
	RTS

DispatchEvent_026:
	ASL A
	TAX
	LDA EventJumpTable_026,X
	STA $F0
	LDA #>EventJumpTable_026
	STA $F1
	JMP (EVENT_VECTOR_026)

EventIdle_026:
	NOP
	RTS

EventStart_026:
	LDA #<MessageData_026
	STA $30
	LDA #>MessageData_026
	STA $31
	RTS

EventStop_026:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_026:
.word EventIdle_026,EventStart_026,EventStop_026

MessagePointers_026:
.addr MessageData_026,StatusMessage_026

PaletteData_026:
.byte $0F,$30,$2A,$3A

MessageData_026:
.byte $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_026:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_026:
.word Nmi_026,Reset_026,Irq_026
.byte <Reset_026,>Reset_026

; ======================================================================================
; PRG Bank 027 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $B600
.const PPUCTRL_027=$2000
.const PPUMASK_027=$2001
.const PPUSTATUS_027=$2002
.const EVENT_VECTOR_027=$00F0

Reset_027:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_027
	STA PPUMASK_027
	STA $00
	STA $01
	JSR ClearRam_027
	JSR LoadPalette_027
	JMP MainLoop_027

Nmi_027:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_027
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_027:
	RTI

MainLoop_027:
	JSR ReadController_027
	JSR UpdatePlayer_027
	JSR UpdateObjects_027
	JMP MainLoop_027

ClearRam_027:
	LDA #$00
	TAX
ClearRamLoop_027:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_027
	RTS

LoadPalette_027:
	LDX #$00
LoadPaletteLoop_027:
	LDA PaletteData_027,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_027
	RTS

ReadController_027:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_027:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_027
	RTS

UpdatePlayer_027:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_027
	INC $20
PlayerNotRight_027:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_027
	DEC $20
PlayerNotLeft_027:
	RTS

UpdateObjects_027:
	LDY #$00
ObjectLoop_027:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_027
	RTS

DispatchEvent_027:
	ASL A
	TAX
	LDA EventJumpTable_027,X
	STA $F0
	LDA #>EventJumpTable_027
	STA $F1
	JMP (EVENT_VECTOR_027)

EventIdle_027:
	NOP
	RTS

EventStart_027:
	LDA #<MessageData_027
	STA $30
	LDA #>MessageData_027
	STA $31
	RTS

EventStop_027:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_027:
.word EventIdle_027,EventStart_027,EventStop_027

MessagePointers_027:
.addr MessageData_027,StatusMessage_027

PaletteData_027:
.byte $0F,$30,$2B,$3B

MessageData_027:
.byte $B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_027:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_027:
.word Nmi_027,Reset_027,Irq_027
.byte <Reset_027,>Reset_027

; ======================================================================================
; PRG Bank 028 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $B800
.const PPUCTRL_028=$2000
.const PPUMASK_028=$2001
.const PPUSTATUS_028=$2002
.const EVENT_VECTOR_028=$00F0

Reset_028:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_028
	STA PPUMASK_028
	STA $00
	STA $01
	JSR ClearRam_028
	JSR LoadPalette_028
	JMP MainLoop_028

Nmi_028:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_028
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_028:
	RTI

MainLoop_028:
	JSR ReadController_028
	JSR UpdatePlayer_028
	JSR UpdateObjects_028
	JMP MainLoop_028

ClearRam_028:
	LDA #$00
	TAX
ClearRamLoop_028:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_028
	RTS

LoadPalette_028:
	LDX #$00
LoadPaletteLoop_028:
	LDA PaletteData_028,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_028
	RTS

ReadController_028:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_028:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_028
	RTS

UpdatePlayer_028:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_028
	INC $20
PlayerNotRight_028:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_028
	DEC $20
PlayerNotLeft_028:
	RTS

UpdateObjects_028:
	LDY #$00
ObjectLoop_028:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_028
	RTS

DispatchEvent_028:
	ASL A
	TAX
	LDA EventJumpTable_028,X
	STA $F0
	LDA #>EventJumpTable_028
	STA $F1
	JMP (EVENT_VECTOR_028)

EventIdle_028:
	NOP
	RTS

EventStart_028:
	LDA #<MessageData_028
	STA $30
	LDA #>MessageData_028
	STA $31
	RTS

EventStop_028:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_028:
.word EventIdle_028,EventStart_028,EventStop_028

MessagePointers_028:
.addr MessageData_028,StatusMessage_028

PaletteData_028:
.byte $0F,$30,$2C,$3C

MessageData_028:
.byte $B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_028:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_028:
.word Nmi_028,Reset_028,Irq_028
.byte <Reset_028,>Reset_028

; ======================================================================================
; PRG Bank 029 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $BA00
.const PPUCTRL_029=$2000
.const PPUMASK_029=$2001
.const PPUSTATUS_029=$2002
.const EVENT_VECTOR_029=$00F0

Reset_029:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_029
	STA PPUMASK_029
	STA $00
	STA $01
	JSR ClearRam_029
	JSR LoadPalette_029
	JMP MainLoop_029

Nmi_029:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_029
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_029:
	RTI

MainLoop_029:
	JSR ReadController_029
	JSR UpdatePlayer_029
	JSR UpdateObjects_029
	JMP MainLoop_029

ClearRam_029:
	LDA #$00
	TAX
ClearRamLoop_029:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_029
	RTS

LoadPalette_029:
	LDX #$00
LoadPaletteLoop_029:
	LDA PaletteData_029,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_029
	RTS

ReadController_029:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_029:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_029
	RTS

UpdatePlayer_029:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_029
	INC $20
PlayerNotRight_029:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_029
	DEC $20
PlayerNotLeft_029:
	RTS

UpdateObjects_029:
	LDY #$00
ObjectLoop_029:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_029
	RTS

DispatchEvent_029:
	ASL A
	TAX
	LDA EventJumpTable_029,X
	STA $F0
	LDA #>EventJumpTable_029
	STA $F1
	JMP (EVENT_VECTOR_029)

EventIdle_029:
	NOP
	RTS

EventStart_029:
	LDA #<MessageData_029
	STA $30
	LDA #>MessageData_029
	STA $31
	RTS

EventStop_029:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_029:
.word EventIdle_029,EventStart_029,EventStop_029

MessagePointers_029:
.addr MessageData_029,StatusMessage_029

PaletteData_029:
.byte $0F,$30,$2D,$3D

MessageData_029:
.byte $B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_029:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_029:
.word Nmi_029,Reset_029,Irq_029
.byte <Reset_029,>Reset_029

; ======================================================================================
; PRG Bank 030 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $BC00
.const PPUCTRL_030=$2000
.const PPUMASK_030=$2001
.const PPUSTATUS_030=$2002
.const EVENT_VECTOR_030=$00F0

Reset_030:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_030
	STA PPUMASK_030
	STA $00
	STA $01
	JSR ClearRam_030
	JSR LoadPalette_030
	JMP MainLoop_030

Nmi_030:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_030
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_030:
	RTI

MainLoop_030:
	JSR ReadController_030
	JSR UpdatePlayer_030
	JSR UpdateObjects_030
	JMP MainLoop_030

ClearRam_030:
	LDA #$00
	TAX
ClearRamLoop_030:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_030
	RTS

LoadPalette_030:
	LDX #$00
LoadPaletteLoop_030:
	LDA PaletteData_030,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_030
	RTS

ReadController_030:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_030:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_030
	RTS

UpdatePlayer_030:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_030
	INC $20
PlayerNotRight_030:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_030
	DEC $20
PlayerNotLeft_030:
	RTS

UpdateObjects_030:
	LDY #$00
ObjectLoop_030:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_030
	RTS

DispatchEvent_030:
	ASL A
	TAX
	LDA EventJumpTable_030,X
	STA $F0
	LDA #>EventJumpTable_030
	STA $F1
	JMP (EVENT_VECTOR_030)

EventIdle_030:
	NOP
	RTS

EventStart_030:
	LDA #<MessageData_030
	STA $30
	LDA #>MessageData_030
	STA $31
	RTS

EventStop_030:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_030:
.word EventIdle_030,EventStart_030,EventStop_030

MessagePointers_030:
.addr MessageData_030,StatusMessage_030

PaletteData_030:
.byte $0F,$30,$2E,$3E

MessageData_030:
.byte $B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_030:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_030:
.word Nmi_030,Reset_030,Irq_030
.byte <Reset_030,>Reset_030

; ======================================================================================
; PRG Bank 031 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $BE00
.const PPUCTRL_031=$2000
.const PPUMASK_031=$2001
.const PPUSTATUS_031=$2002
.const EVENT_VECTOR_031=$00F0

Reset_031:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_031
	STA PPUMASK_031
	STA $00
	STA $01
	JSR ClearRam_031
	JSR LoadPalette_031
	JMP MainLoop_031

Nmi_031:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_031
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_031:
	RTI

MainLoop_031:
	JSR ReadController_031
	JSR UpdatePlayer_031
	JSR UpdateObjects_031
	JMP MainLoop_031

ClearRam_031:
	LDA #$00
	TAX
ClearRamLoop_031:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_031
	RTS

LoadPalette_031:
	LDX #$00
LoadPaletteLoop_031:
	LDA PaletteData_031,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_031
	RTS

ReadController_031:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_031:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_031
	RTS

UpdatePlayer_031:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_031
	INC $20
PlayerNotRight_031:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_031
	DEC $20
PlayerNotLeft_031:
	RTS

UpdateObjects_031:
	LDY #$00
ObjectLoop_031:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_031
	RTS

DispatchEvent_031:
	ASL A
	TAX
	LDA EventJumpTable_031,X
	STA $F0
	LDA #>EventJumpTable_031
	STA $F1
	JMP (EVENT_VECTOR_031)

EventIdle_031:
	NOP
	RTS

EventStart_031:
	LDA #<MessageData_031
	STA $30
	LDA #>MessageData_031
	STA $31
	RTS

EventStop_031:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_031:
.word EventIdle_031,EventStart_031,EventStop_031

MessagePointers_031:
.addr MessageData_031,StatusMessage_031

PaletteData_031:
.byte $0F,$30,$2F,$3F

MessageData_031:
.byte $B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_031:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_031:
.word Nmi_031,Reset_031,Irq_031
.byte <Reset_031,>Reset_031

; ======================================================================================
; PRG Bank 032 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $C000
.const PPUCTRL_032=$2000
.const PPUMASK_032=$2001
.const PPUSTATUS_032=$2002
.const EVENT_VECTOR_032=$00F0

Reset_032:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_032
	STA PPUMASK_032
	STA $00
	STA $01
	JSR ClearRam_032
	JSR LoadPalette_032
	JMP MainLoop_032

Nmi_032:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_032
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_032:
	RTI

MainLoop_032:
	JSR ReadController_032
	JSR UpdatePlayer_032
	JSR UpdateObjects_032
	JMP MainLoop_032

ClearRam_032:
	LDA #$00
	TAX
ClearRamLoop_032:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_032
	RTS

LoadPalette_032:
	LDX #$00
LoadPaletteLoop_032:
	LDA PaletteData_032,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_032
	RTS

ReadController_032:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_032:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_032
	RTS

UpdatePlayer_032:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_032
	INC $20
PlayerNotRight_032:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_032
	DEC $20
PlayerNotLeft_032:
	RTS

UpdateObjects_032:
	LDY #$00
ObjectLoop_032:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_032
	RTS

DispatchEvent_032:
	ASL A
	TAX
	LDA EventJumpTable_032,X
	STA $F0
	LDA #>EventJumpTable_032
	STA $F1
	JMP (EVENT_VECTOR_032)

EventIdle_032:
	NOP
	RTS

EventStart_032:
	LDA #<MessageData_032
	STA $30
	LDA #>MessageData_032
	STA $31
	RTS

EventStop_032:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_032:
.word EventIdle_032,EventStart_032,EventStop_032

MessagePointers_032:
.addr MessageData_032,StatusMessage_032

PaletteData_032:
.byte $0F,$30,$30,$00

MessageData_032:
.byte $B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_032:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_032:
.word Nmi_032,Reset_032,Irq_032
.byte <Reset_032,>Reset_032

; ======================================================================================
; PRG Bank 033 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $C200
.const PPUCTRL_033=$2000
.const PPUMASK_033=$2001
.const PPUSTATUS_033=$2002
.const EVENT_VECTOR_033=$00F0

Reset_033:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_033
	STA PPUMASK_033
	STA $00
	STA $01
	JSR ClearRam_033
	JSR LoadPalette_033
	JMP MainLoop_033

Nmi_033:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_033
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_033:
	RTI

MainLoop_033:
	JSR ReadController_033
	JSR UpdatePlayer_033
	JSR UpdateObjects_033
	JMP MainLoop_033

ClearRam_033:
	LDA #$00
	TAX
ClearRamLoop_033:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_033
	RTS

LoadPalette_033:
	LDX #$00
LoadPaletteLoop_033:
	LDA PaletteData_033,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_033
	RTS

ReadController_033:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_033:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_033
	RTS

UpdatePlayer_033:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_033
	INC $20
PlayerNotRight_033:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_033
	DEC $20
PlayerNotLeft_033:
	RTS

UpdateObjects_033:
	LDY #$00
ObjectLoop_033:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_033
	RTS

DispatchEvent_033:
	ASL A
	TAX
	LDA EventJumpTable_033,X
	STA $F0
	LDA #>EventJumpTable_033
	STA $F1
	JMP (EVENT_VECTOR_033)

EventIdle_033:
	NOP
	RTS

EventStart_033:
	LDA #<MessageData_033
	STA $30
	LDA #>MessageData_033
	STA $31
	RTS

EventStop_033:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_033:
.word EventIdle_033,EventStart_033,EventStop_033

MessagePointers_033:
.addr MessageData_033,StatusMessage_033

PaletteData_033:
.byte $0F,$30,$31,$01

MessageData_033:
.byte $B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_033:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_033:
.word Nmi_033,Reset_033,Irq_033
.byte <Reset_033,>Reset_033

; ======================================================================================
; PRG Bank 034 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $C400
.const PPUCTRL_034=$2000
.const PPUMASK_034=$2001
.const PPUSTATUS_034=$2002
.const EVENT_VECTOR_034=$00F0

Reset_034:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_034
	STA PPUMASK_034
	STA $00
	STA $01
	JSR ClearRam_034
	JSR LoadPalette_034
	JMP MainLoop_034

Nmi_034:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_034
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_034:
	RTI

MainLoop_034:
	JSR ReadController_034
	JSR UpdatePlayer_034
	JSR UpdateObjects_034
	JMP MainLoop_034

ClearRam_034:
	LDA #$00
	TAX
ClearRamLoop_034:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_034
	RTS

LoadPalette_034:
	LDX #$00
LoadPaletteLoop_034:
	LDA PaletteData_034,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_034
	RTS

ReadController_034:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_034:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_034
	RTS

UpdatePlayer_034:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_034
	INC $20
PlayerNotRight_034:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_034
	DEC $20
PlayerNotLeft_034:
	RTS

UpdateObjects_034:
	LDY #$00
ObjectLoop_034:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_034
	RTS

DispatchEvent_034:
	ASL A
	TAX
	LDA EventJumpTable_034,X
	STA $F0
	LDA #>EventJumpTable_034
	STA $F1
	JMP (EVENT_VECTOR_034)

EventIdle_034:
	NOP
	RTS

EventStart_034:
	LDA #<MessageData_034
	STA $30
	LDA #>MessageData_034
	STA $31
	RTS

EventStop_034:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_034:
.word EventIdle_034,EventStart_034,EventStop_034

MessagePointers_034:
.addr MessageData_034,StatusMessage_034

PaletteData_034:
.byte $0F,$30,$32,$02

MessageData_034:
.byte $B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_034:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_034:
.word Nmi_034,Reset_034,Irq_034
.byte <Reset_034,>Reset_034

; ======================================================================================
; PRG Bank 035 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $C600
.const PPUCTRL_035=$2000
.const PPUMASK_035=$2001
.const PPUSTATUS_035=$2002
.const EVENT_VECTOR_035=$00F0

Reset_035:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_035
	STA PPUMASK_035
	STA $00
	STA $01
	JSR ClearRam_035
	JSR LoadPalette_035
	JMP MainLoop_035

Nmi_035:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_035
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_035:
	RTI

MainLoop_035:
	JSR ReadController_035
	JSR UpdatePlayer_035
	JSR UpdateObjects_035
	JMP MainLoop_035

ClearRam_035:
	LDA #$00
	TAX
ClearRamLoop_035:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_035
	RTS

LoadPalette_035:
	LDX #$00
LoadPaletteLoop_035:
	LDA PaletteData_035,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_035
	RTS

ReadController_035:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_035:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_035
	RTS

UpdatePlayer_035:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_035
	INC $20
PlayerNotRight_035:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_035
	DEC $20
PlayerNotLeft_035:
	RTS

UpdateObjects_035:
	LDY #$00
ObjectLoop_035:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_035
	RTS

DispatchEvent_035:
	ASL A
	TAX
	LDA EventJumpTable_035,X
	STA $F0
	LDA #>EventJumpTable_035
	STA $F1
	JMP (EVENT_VECTOR_035)

EventIdle_035:
	NOP
	RTS

EventStart_035:
	LDA #<MessageData_035
	STA $30
	LDA #>MessageData_035
	STA $31
	RTS

EventStop_035:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_035:
.word EventIdle_035,EventStart_035,EventStop_035

MessagePointers_035:
.addr MessageData_035,StatusMessage_035

PaletteData_035:
.byte $0F,$30,$33,$03

MessageData_035:
.byte $B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_035:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_035:
.word Nmi_035,Reset_035,Irq_035
.byte <Reset_035,>Reset_035

; ======================================================================================
; PRG Bank 036 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $C800
.const PPUCTRL_036=$2000
.const PPUMASK_036=$2001
.const PPUSTATUS_036=$2002
.const EVENT_VECTOR_036=$00F0

Reset_036:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_036
	STA PPUMASK_036
	STA $00
	STA $01
	JSR ClearRam_036
	JSR LoadPalette_036
	JMP MainLoop_036

Nmi_036:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_036
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_036:
	RTI

MainLoop_036:
	JSR ReadController_036
	JSR UpdatePlayer_036
	JSR UpdateObjects_036
	JMP MainLoop_036

ClearRam_036:
	LDA #$00
	TAX
ClearRamLoop_036:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_036
	RTS

LoadPalette_036:
	LDX #$00
LoadPaletteLoop_036:
	LDA PaletteData_036,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_036
	RTS

ReadController_036:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_036:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_036
	RTS

UpdatePlayer_036:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_036
	INC $20
PlayerNotRight_036:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_036
	DEC $20
PlayerNotLeft_036:
	RTS

UpdateObjects_036:
	LDY #$00
ObjectLoop_036:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_036
	RTS

DispatchEvent_036:
	ASL A
	TAX
	LDA EventJumpTable_036,X
	STA $F0
	LDA #>EventJumpTable_036
	STA $F1
	JMP (EVENT_VECTOR_036)

EventIdle_036:
	NOP
	RTS

EventStart_036:
	LDA #<MessageData_036
	STA $30
	LDA #>MessageData_036
	STA $31
	RTS

EventStop_036:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_036:
.word EventIdle_036,EventStart_036,EventStop_036

MessagePointers_036:
.addr MessageData_036,StatusMessage_036

PaletteData_036:
.byte $0F,$30,$34,$04

MessageData_036:
.byte $BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_036:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_036:
.word Nmi_036,Reset_036,Irq_036
.byte <Reset_036,>Reset_036

; ======================================================================================
; PRG Bank 037 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $CA00
.const PPUCTRL_037=$2000
.const PPUMASK_037=$2001
.const PPUSTATUS_037=$2002
.const EVENT_VECTOR_037=$00F0

Reset_037:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_037
	STA PPUMASK_037
	STA $00
	STA $01
	JSR ClearRam_037
	JSR LoadPalette_037
	JMP MainLoop_037

Nmi_037:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_037
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_037:
	RTI

MainLoop_037:
	JSR ReadController_037
	JSR UpdatePlayer_037
	JSR UpdateObjects_037
	JMP MainLoop_037

ClearRam_037:
	LDA #$00
	TAX
ClearRamLoop_037:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_037
	RTS

LoadPalette_037:
	LDX #$00
LoadPaletteLoop_037:
	LDA PaletteData_037,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_037
	RTS

ReadController_037:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_037:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_037
	RTS

UpdatePlayer_037:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_037
	INC $20
PlayerNotRight_037:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_037
	DEC $20
PlayerNotLeft_037:
	RTS

UpdateObjects_037:
	LDY #$00
ObjectLoop_037:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_037
	RTS

DispatchEvent_037:
	ASL A
	TAX
	LDA EventJumpTable_037,X
	STA $F0
	LDA #>EventJumpTable_037
	STA $F1
	JMP (EVENT_VECTOR_037)

EventIdle_037:
	NOP
	RTS

EventStart_037:
	LDA #<MessageData_037
	STA $30
	LDA #>MessageData_037
	STA $31
	RTS

EventStop_037:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_037:
.word EventIdle_037,EventStart_037,EventStop_037

MessagePointers_037:
.addr MessageData_037,StatusMessage_037

PaletteData_037:
.byte $0F,$30,$35,$05

MessageData_037:
.byte $BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_037:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_037:
.word Nmi_037,Reset_037,Irq_037
.byte <Reset_037,>Reset_037

; ======================================================================================
; PRG Bank 038 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $CC00
.const PPUCTRL_038=$2000
.const PPUMASK_038=$2001
.const PPUSTATUS_038=$2002
.const EVENT_VECTOR_038=$00F0

Reset_038:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_038
	STA PPUMASK_038
	STA $00
	STA $01
	JSR ClearRam_038
	JSR LoadPalette_038
	JMP MainLoop_038

Nmi_038:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_038
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_038:
	RTI

MainLoop_038:
	JSR ReadController_038
	JSR UpdatePlayer_038
	JSR UpdateObjects_038
	JMP MainLoop_038

ClearRam_038:
	LDA #$00
	TAX
ClearRamLoop_038:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_038
	RTS

LoadPalette_038:
	LDX #$00
LoadPaletteLoop_038:
	LDA PaletteData_038,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_038
	RTS

ReadController_038:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_038:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_038
	RTS

UpdatePlayer_038:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_038
	INC $20
PlayerNotRight_038:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_038
	DEC $20
PlayerNotLeft_038:
	RTS

UpdateObjects_038:
	LDY #$00
ObjectLoop_038:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_038
	RTS

DispatchEvent_038:
	ASL A
	TAX
	LDA EventJumpTable_038,X
	STA $F0
	LDA #>EventJumpTable_038
	STA $F1
	JMP (EVENT_VECTOR_038)

EventIdle_038:
	NOP
	RTS

EventStart_038:
	LDA #<MessageData_038
	STA $30
	LDA #>MessageData_038
	STA $31
	RTS

EventStop_038:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_038:
.word EventIdle_038,EventStart_038,EventStop_038

MessagePointers_038:
.addr MessageData_038,StatusMessage_038

PaletteData_038:
.byte $0F,$30,$36,$06

MessageData_038:
.byte $BC,$BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_038:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_038:
.word Nmi_038,Reset_038,Irq_038
.byte <Reset_038,>Reset_038

; ======================================================================================
; PRG Bank 039 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $CE00
.const PPUCTRL_039=$2000
.const PPUMASK_039=$2001
.const PPUSTATUS_039=$2002
.const EVENT_VECTOR_039=$00F0

Reset_039:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_039
	STA PPUMASK_039
	STA $00
	STA $01
	JSR ClearRam_039
	JSR LoadPalette_039
	JMP MainLoop_039

Nmi_039:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_039
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_039:
	RTI

MainLoop_039:
	JSR ReadController_039
	JSR UpdatePlayer_039
	JSR UpdateObjects_039
	JMP MainLoop_039

ClearRam_039:
	LDA #$00
	TAX
ClearRamLoop_039:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_039
	RTS

LoadPalette_039:
	LDX #$00
LoadPaletteLoop_039:
	LDA PaletteData_039,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_039
	RTS

ReadController_039:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_039:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_039
	RTS

UpdatePlayer_039:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_039
	INC $20
PlayerNotRight_039:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_039
	DEC $20
PlayerNotLeft_039:
	RTS

UpdateObjects_039:
	LDY #$00
ObjectLoop_039:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_039
	RTS

DispatchEvent_039:
	ASL A
	TAX
	LDA EventJumpTable_039,X
	STA $F0
	LDA #>EventJumpTable_039
	STA $F1
	JMP (EVENT_VECTOR_039)

EventIdle_039:
	NOP
	RTS

EventStart_039:
	LDA #<MessageData_039
	STA $30
	LDA #>MessageData_039
	STA $31
	RTS

EventStop_039:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_039:
.word EventIdle_039,EventStart_039,EventStop_039

MessagePointers_039:
.addr MessageData_039,StatusMessage_039

PaletteData_039:
.byte $0F,$30,$37,$07

MessageData_039:
.byte $BD,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_039:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_039:
.word Nmi_039,Reset_039,Irq_039
.byte <Reset_039,>Reset_039

; ======================================================================================
; PRG Bank 040 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $D000
.const PPUCTRL_040=$2000
.const PPUMASK_040=$2001
.const PPUSTATUS_040=$2002
.const EVENT_VECTOR_040=$00F0

Reset_040:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_040
	STA PPUMASK_040
	STA $00
	STA $01
	JSR ClearRam_040
	JSR LoadPalette_040
	JMP MainLoop_040

Nmi_040:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_040
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_040:
	RTI

MainLoop_040:
	JSR ReadController_040
	JSR UpdatePlayer_040
	JSR UpdateObjects_040
	JMP MainLoop_040

ClearRam_040:
	LDA #$00
	TAX
ClearRamLoop_040:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_040
	RTS

LoadPalette_040:
	LDX #$00
LoadPaletteLoop_040:
	LDA PaletteData_040,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_040
	RTS

ReadController_040:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_040:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_040
	RTS

UpdatePlayer_040:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_040
	INC $20
PlayerNotRight_040:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_040
	DEC $20
PlayerNotLeft_040:
	RTS

UpdateObjects_040:
	LDY #$00
ObjectLoop_040:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_040
	RTS

DispatchEvent_040:
	ASL A
	TAX
	LDA EventJumpTable_040,X
	STA $F0
	LDA #>EventJumpTable_040
	STA $F1
	JMP (EVENT_VECTOR_040)

EventIdle_040:
	NOP
	RTS

EventStart_040:
	LDA #<MessageData_040
	STA $30
	LDA #>MessageData_040
	STA $31
	RTS

EventStop_040:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_040:
.word EventIdle_040,EventStart_040,EventStop_040

MessagePointers_040:
.addr MessageData_040,StatusMessage_040

PaletteData_040:
.byte $0F,$30,$38,$08

MessageData_040:
.byte $BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_040:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_040:
.word Nmi_040,Reset_040,Irq_040
.byte <Reset_040,>Reset_040

; ======================================================================================
; PRG Bank 041 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $D200
.const PPUCTRL_041=$2000
.const PPUMASK_041=$2001
.const PPUSTATUS_041=$2002
.const EVENT_VECTOR_041=$00F0

Reset_041:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_041
	STA PPUMASK_041
	STA $00
	STA $01
	JSR ClearRam_041
	JSR LoadPalette_041
	JMP MainLoop_041

Nmi_041:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_041
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_041:
	RTI

MainLoop_041:
	JSR ReadController_041
	JSR UpdatePlayer_041
	JSR UpdateObjects_041
	JMP MainLoop_041

ClearRam_041:
	LDA #$00
	TAX
ClearRamLoop_041:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_041
	RTS

LoadPalette_041:
	LDX #$00
LoadPaletteLoop_041:
	LDA PaletteData_041,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_041
	RTS

ReadController_041:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_041:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_041
	RTS

UpdatePlayer_041:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_041
	INC $20
PlayerNotRight_041:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_041
	DEC $20
PlayerNotLeft_041:
	RTS

UpdateObjects_041:
	LDY #$00
ObjectLoop_041:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_041
	RTS

DispatchEvent_041:
	ASL A
	TAX
	LDA EventJumpTable_041,X
	STA $F0
	LDA #>EventJumpTable_041
	STA $F1
	JMP (EVENT_VECTOR_041)

EventIdle_041:
	NOP
	RTS

EventStart_041:
	LDA #<MessageData_041
	STA $30
	LDA #>MessageData_041
	STA $31
	RTS

EventStop_041:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_041:
.word EventIdle_041,EventStart_041,EventStop_041

MessagePointers_041:
.addr MessageData_041,StatusMessage_041

PaletteData_041:
.byte $0F,$30,$39,$09

MessageData_041:
.byte $BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_041:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_041:
.word Nmi_041,Reset_041,Irq_041
.byte <Reset_041,>Reset_041

; ======================================================================================
; PRG Bank 042 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $D400
.const PPUCTRL_042=$2000
.const PPUMASK_042=$2001
.const PPUSTATUS_042=$2002
.const EVENT_VECTOR_042=$00F0

Reset_042:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_042
	STA PPUMASK_042
	STA $00
	STA $01
	JSR ClearRam_042
	JSR LoadPalette_042
	JMP MainLoop_042

Nmi_042:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_042
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_042:
	RTI

MainLoop_042:
	JSR ReadController_042
	JSR UpdatePlayer_042
	JSR UpdateObjects_042
	JMP MainLoop_042

ClearRam_042:
	LDA #$00
	TAX
ClearRamLoop_042:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_042
	RTS

LoadPalette_042:
	LDX #$00
LoadPaletteLoop_042:
	LDA PaletteData_042,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_042
	RTS

ReadController_042:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_042:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_042
	RTS

UpdatePlayer_042:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_042
	INC $20
PlayerNotRight_042:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_042
	DEC $20
PlayerNotLeft_042:
	RTS

UpdateObjects_042:
	LDY #$00
ObjectLoop_042:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_042
	RTS

DispatchEvent_042:
	ASL A
	TAX
	LDA EventJumpTable_042,X
	STA $F0
	LDA #>EventJumpTable_042
	STA $F1
	JMP (EVENT_VECTOR_042)

EventIdle_042:
	NOP
	RTS

EventStart_042:
	LDA #<MessageData_042
	STA $30
	LDA #>MessageData_042
	STA $31
	RTS

EventStop_042:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_042:
.word EventIdle_042,EventStart_042,EventStop_042

MessagePointers_042:
.addr MessageData_042,StatusMessage_042

PaletteData_042:
.byte $0F,$30,$3A,$0A

MessageData_042:
.byte $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_042:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_042:
.word Nmi_042,Reset_042,Irq_042
.byte <Reset_042,>Reset_042

; ======================================================================================
; PRG Bank 043 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $D600
.const PPUCTRL_043=$2000
.const PPUMASK_043=$2001
.const PPUSTATUS_043=$2002
.const EVENT_VECTOR_043=$00F0

Reset_043:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_043
	STA PPUMASK_043
	STA $00
	STA $01
	JSR ClearRam_043
	JSR LoadPalette_043
	JMP MainLoop_043

Nmi_043:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_043
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_043:
	RTI

MainLoop_043:
	JSR ReadController_043
	JSR UpdatePlayer_043
	JSR UpdateObjects_043
	JMP MainLoop_043

ClearRam_043:
	LDA #$00
	TAX
ClearRamLoop_043:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_043
	RTS

LoadPalette_043:
	LDX #$00
LoadPaletteLoop_043:
	LDA PaletteData_043,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_043
	RTS

ReadController_043:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_043:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_043
	RTS

UpdatePlayer_043:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_043
	INC $20
PlayerNotRight_043:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_043
	DEC $20
PlayerNotLeft_043:
	RTS

UpdateObjects_043:
	LDY #$00
ObjectLoop_043:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_043
	RTS

DispatchEvent_043:
	ASL A
	TAX
	LDA EventJumpTable_043,X
	STA $F0
	LDA #>EventJumpTable_043
	STA $F1
	JMP (EVENT_VECTOR_043)

EventIdle_043:
	NOP
	RTS

EventStart_043:
	LDA #<MessageData_043
	STA $30
	LDA #>MessageData_043
	STA $31
	RTS

EventStop_043:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_043:
.word EventIdle_043,EventStart_043,EventStop_043

MessagePointers_043:
.addr MessageData_043,StatusMessage_043

PaletteData_043:
.byte $0F,$30,$3B,$0B

MessageData_043:
.byte $C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_043:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_043:
.word Nmi_043,Reset_043,Irq_043
.byte <Reset_043,>Reset_043

; ======================================================================================
; PRG Bank 044 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $D800
.const PPUCTRL_044=$2000
.const PPUMASK_044=$2001
.const PPUSTATUS_044=$2002
.const EVENT_VECTOR_044=$00F0

Reset_044:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_044
	STA PPUMASK_044
	STA $00
	STA $01
	JSR ClearRam_044
	JSR LoadPalette_044
	JMP MainLoop_044

Nmi_044:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_044
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_044:
	RTI

MainLoop_044:
	JSR ReadController_044
	JSR UpdatePlayer_044
	JSR UpdateObjects_044
	JMP MainLoop_044

ClearRam_044:
	LDA #$00
	TAX
ClearRamLoop_044:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_044
	RTS

LoadPalette_044:
	LDX #$00
LoadPaletteLoop_044:
	LDA PaletteData_044,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_044
	RTS

ReadController_044:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_044:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_044
	RTS

UpdatePlayer_044:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_044
	INC $20
PlayerNotRight_044:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_044
	DEC $20
PlayerNotLeft_044:
	RTS

UpdateObjects_044:
	LDY #$00
ObjectLoop_044:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_044
	RTS

DispatchEvent_044:
	ASL A
	TAX
	LDA EventJumpTable_044,X
	STA $F0
	LDA #>EventJumpTable_044
	STA $F1
	JMP (EVENT_VECTOR_044)

EventIdle_044:
	NOP
	RTS

EventStart_044:
	LDA #<MessageData_044
	STA $30
	LDA #>MessageData_044
	STA $31
	RTS

EventStop_044:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_044:
.word EventIdle_044,EventStart_044,EventStop_044

MessagePointers_044:
.addr MessageData_044,StatusMessage_044

PaletteData_044:
.byte $0F,$30,$3C,$0C

MessageData_044:
.byte $C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_044:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_044:
.word Nmi_044,Reset_044,Irq_044
.byte <Reset_044,>Reset_044

; ======================================================================================
; PRG Bank 045 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $DA00
.const PPUCTRL_045=$2000
.const PPUMASK_045=$2001
.const PPUSTATUS_045=$2002
.const EVENT_VECTOR_045=$00F0

Reset_045:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_045
	STA PPUMASK_045
	STA $00
	STA $01
	JSR ClearRam_045
	JSR LoadPalette_045
	JMP MainLoop_045

Nmi_045:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_045
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_045:
	RTI

MainLoop_045:
	JSR ReadController_045
	JSR UpdatePlayer_045
	JSR UpdateObjects_045
	JMP MainLoop_045

ClearRam_045:
	LDA #$00
	TAX
ClearRamLoop_045:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_045
	RTS

LoadPalette_045:
	LDX #$00
LoadPaletteLoop_045:
	LDA PaletteData_045,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_045
	RTS

ReadController_045:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_045:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_045
	RTS

UpdatePlayer_045:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_045
	INC $20
PlayerNotRight_045:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_045
	DEC $20
PlayerNotLeft_045:
	RTS

UpdateObjects_045:
	LDY #$00
ObjectLoop_045:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_045
	RTS

DispatchEvent_045:
	ASL A
	TAX
	LDA EventJumpTable_045,X
	STA $F0
	LDA #>EventJumpTable_045
	STA $F1
	JMP (EVENT_VECTOR_045)

EventIdle_045:
	NOP
	RTS

EventStart_045:
	LDA #<MessageData_045
	STA $30
	LDA #>MessageData_045
	STA $31
	RTS

EventStop_045:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_045:
.word EventIdle_045,EventStart_045,EventStop_045

MessagePointers_045:
.addr MessageData_045,StatusMessage_045

PaletteData_045:
.byte $0F,$30,$3D,$0D

MessageData_045:
.byte $C3,$C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_045:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_045:
.word Nmi_045,Reset_045,Irq_045
.byte <Reset_045,>Reset_045

; ======================================================================================
; PRG Bank 046 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $DC00
.const PPUCTRL_046=$2000
.const PPUMASK_046=$2001
.const PPUSTATUS_046=$2002
.const EVENT_VECTOR_046=$00F0

Reset_046:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_046
	STA PPUMASK_046
	STA $00
	STA $01
	JSR ClearRam_046
	JSR LoadPalette_046
	JMP MainLoop_046

Nmi_046:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_046
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_046:
	RTI

MainLoop_046:
	JSR ReadController_046
	JSR UpdatePlayer_046
	JSR UpdateObjects_046
	JMP MainLoop_046

ClearRam_046:
	LDA #$00
	TAX
ClearRamLoop_046:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_046
	RTS

LoadPalette_046:
	LDX #$00
LoadPaletteLoop_046:
	LDA PaletteData_046,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_046
	RTS

ReadController_046:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_046:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_046
	RTS

UpdatePlayer_046:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_046
	INC $20
PlayerNotRight_046:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_046
	DEC $20
PlayerNotLeft_046:
	RTS

UpdateObjects_046:
	LDY #$00
ObjectLoop_046:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_046
	RTS

DispatchEvent_046:
	ASL A
	TAX
	LDA EventJumpTable_046,X
	STA $F0
	LDA #>EventJumpTable_046
	STA $F1
	JMP (EVENT_VECTOR_046)

EventIdle_046:
	NOP
	RTS

EventStart_046:
	LDA #<MessageData_046
	STA $30
	LDA #>MessageData_046
	STA $31
	RTS

EventStop_046:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_046:
.word EventIdle_046,EventStart_046,EventStop_046

MessagePointers_046:
.addr MessageData_046,StatusMessage_046

PaletteData_046:
.byte $0F,$30,$3E,$0E

MessageData_046:
.byte $C4,$C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_046:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_046:
.word Nmi_046,Reset_046,Irq_046
.byte <Reset_046,>Reset_046

; ======================================================================================
; PRG Bank 047 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $DE00
.const PPUCTRL_047=$2000
.const PPUMASK_047=$2001
.const PPUSTATUS_047=$2002
.const EVENT_VECTOR_047=$00F0

Reset_047:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_047
	STA PPUMASK_047
	STA $00
	STA $01
	JSR ClearRam_047
	JSR LoadPalette_047
	JMP MainLoop_047

Nmi_047:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_047
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_047:
	RTI

MainLoop_047:
	JSR ReadController_047
	JSR UpdatePlayer_047
	JSR UpdateObjects_047
	JMP MainLoop_047

ClearRam_047:
	LDA #$00
	TAX
ClearRamLoop_047:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_047
	RTS

LoadPalette_047:
	LDX #$00
LoadPaletteLoop_047:
	LDA PaletteData_047,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_047
	RTS

ReadController_047:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_047:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_047
	RTS

UpdatePlayer_047:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_047
	INC $20
PlayerNotRight_047:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_047
	DEC $20
PlayerNotLeft_047:
	RTS

UpdateObjects_047:
	LDY #$00
ObjectLoop_047:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_047
	RTS

DispatchEvent_047:
	ASL A
	TAX
	LDA EventJumpTable_047,X
	STA $F0
	LDA #>EventJumpTable_047
	STA $F1
	JMP (EVENT_VECTOR_047)

EventIdle_047:
	NOP
	RTS

EventStart_047:
	LDA #<MessageData_047
	STA $30
	LDA #>MessageData_047
	STA $31
	RTS

EventStop_047:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_047:
.word EventIdle_047,EventStart_047,EventStop_047

MessagePointers_047:
.addr MessageData_047,StatusMessage_047

PaletteData_047:
.byte $0F,$30,$3F,$0F

MessageData_047:
.byte $C5,$C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_047:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_047:
.word Nmi_047,Reset_047,Irq_047
.byte <Reset_047,>Reset_047

; ======================================================================================
; PRG Bank 048 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $E000
.const PPUCTRL_048=$2000
.const PPUMASK_048=$2001
.const PPUSTATUS_048=$2002
.const EVENT_VECTOR_048=$00F0

Reset_048:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_048
	STA PPUMASK_048
	STA $00
	STA $01
	JSR ClearRam_048
	JSR LoadPalette_048
	JMP MainLoop_048

Nmi_048:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_048
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_048:
	RTI

MainLoop_048:
	JSR ReadController_048
	JSR UpdatePlayer_048
	JSR UpdateObjects_048
	JMP MainLoop_048

ClearRam_048:
	LDA #$00
	TAX
ClearRamLoop_048:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_048
	RTS

LoadPalette_048:
	LDX #$00
LoadPaletteLoop_048:
	LDA PaletteData_048,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_048
	RTS

ReadController_048:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_048:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_048
	RTS

UpdatePlayer_048:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_048
	INC $20
PlayerNotRight_048:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_048
	DEC $20
PlayerNotLeft_048:
	RTS

UpdateObjects_048:
	LDY #$00
ObjectLoop_048:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_048
	RTS

DispatchEvent_048:
	ASL A
	TAX
	LDA EventJumpTable_048,X
	STA $F0
	LDA #>EventJumpTable_048
	STA $F1
	JMP (EVENT_VECTOR_048)

EventIdle_048:
	NOP
	RTS

EventStart_048:
	LDA #<MessageData_048
	STA $30
	LDA #>MessageData_048
	STA $31
	RTS

EventStop_048:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_048:
.word EventIdle_048,EventStart_048,EventStop_048

MessagePointers_048:
.addr MessageData_048,StatusMessage_048

PaletteData_048:
.byte $0F,$30,$00,$10

MessageData_048:
.byte $C6,$C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_048:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_048:
.word Nmi_048,Reset_048,Irq_048
.byte <Reset_048,>Reset_048

; ======================================================================================
; PRG Bank 049 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $E200
.const PPUCTRL_049=$2000
.const PPUMASK_049=$2001
.const PPUSTATUS_049=$2002
.const EVENT_VECTOR_049=$00F0

Reset_049:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_049
	STA PPUMASK_049
	STA $00
	STA $01
	JSR ClearRam_049
	JSR LoadPalette_049
	JMP MainLoop_049

Nmi_049:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_049
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_049:
	RTI

MainLoop_049:
	JSR ReadController_049
	JSR UpdatePlayer_049
	JSR UpdateObjects_049
	JMP MainLoop_049

ClearRam_049:
	LDA #$00
	TAX
ClearRamLoop_049:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_049
	RTS

LoadPalette_049:
	LDX #$00
LoadPaletteLoop_049:
	LDA PaletteData_049,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_049
	RTS

ReadController_049:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_049:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_049
	RTS

UpdatePlayer_049:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_049
	INC $20
PlayerNotRight_049:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_049
	DEC $20
PlayerNotLeft_049:
	RTS

UpdateObjects_049:
	LDY #$00
ObjectLoop_049:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_049
	RTS

DispatchEvent_049:
	ASL A
	TAX
	LDA EventJumpTable_049,X
	STA $F0
	LDA #>EventJumpTable_049
	STA $F1
	JMP (EVENT_VECTOR_049)

EventIdle_049:
	NOP
	RTS

EventStart_049:
	LDA #<MessageData_049
	STA $30
	LDA #>MessageData_049
	STA $31
	RTS

EventStop_049:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_049:
.word EventIdle_049,EventStart_049,EventStop_049

MessagePointers_049:
.addr MessageData_049,StatusMessage_049

PaletteData_049:
.byte $0F,$30,$01,$11

MessageData_049:
.byte $C7,$C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_049:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_049:
.word Nmi_049,Reset_049,Irq_049
.byte <Reset_049,>Reset_049

; ======================================================================================
; PRG Bank 050 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $E400
.const PPUCTRL_050=$2000
.const PPUMASK_050=$2001
.const PPUSTATUS_050=$2002
.const EVENT_VECTOR_050=$00F0

Reset_050:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_050
	STA PPUMASK_050
	STA $00
	STA $01
	JSR ClearRam_050
	JSR LoadPalette_050
	JMP MainLoop_050

Nmi_050:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_050
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_050:
	RTI

MainLoop_050:
	JSR ReadController_050
	JSR UpdatePlayer_050
	JSR UpdateObjects_050
	JMP MainLoop_050

ClearRam_050:
	LDA #$00
	TAX
ClearRamLoop_050:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_050
	RTS

LoadPalette_050:
	LDX #$00
LoadPaletteLoop_050:
	LDA PaletteData_050,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_050
	RTS

ReadController_050:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_050:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_050
	RTS

UpdatePlayer_050:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_050
	INC $20
PlayerNotRight_050:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_050
	DEC $20
PlayerNotLeft_050:
	RTS

UpdateObjects_050:
	LDY #$00
ObjectLoop_050:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_050
	RTS

DispatchEvent_050:
	ASL A
	TAX
	LDA EventJumpTable_050,X
	STA $F0
	LDA #>EventJumpTable_050
	STA $F1
	JMP (EVENT_VECTOR_050)

EventIdle_050:
	NOP
	RTS

EventStart_050:
	LDA #<MessageData_050
	STA $30
	LDA #>MessageData_050
	STA $31
	RTS

EventStop_050:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_050:
.word EventIdle_050,EventStart_050,EventStop_050

MessagePointers_050:
.addr MessageData_050,StatusMessage_050

PaletteData_050:
.byte $0F,$30,$02,$12

MessageData_050:
.byte $C8,$C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_050:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_050:
.word Nmi_050,Reset_050,Irq_050
.byte <Reset_050,>Reset_050

; ======================================================================================
; PRG Bank 051 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $E600
.const PPUCTRL_051=$2000
.const PPUMASK_051=$2001
.const PPUSTATUS_051=$2002
.const EVENT_VECTOR_051=$00F0

Reset_051:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_051
	STA PPUMASK_051
	STA $00
	STA $01
	JSR ClearRam_051
	JSR LoadPalette_051
	JMP MainLoop_051

Nmi_051:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_051
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_051:
	RTI

MainLoop_051:
	JSR ReadController_051
	JSR UpdatePlayer_051
	JSR UpdateObjects_051
	JMP MainLoop_051

ClearRam_051:
	LDA #$00
	TAX
ClearRamLoop_051:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_051
	RTS

LoadPalette_051:
	LDX #$00
LoadPaletteLoop_051:
	LDA PaletteData_051,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_051
	RTS

ReadController_051:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_051:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_051
	RTS

UpdatePlayer_051:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_051
	INC $20
PlayerNotRight_051:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_051
	DEC $20
PlayerNotLeft_051:
	RTS

UpdateObjects_051:
	LDY #$00
ObjectLoop_051:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_051
	RTS

DispatchEvent_051:
	ASL A
	TAX
	LDA EventJumpTable_051,X
	STA $F0
	LDA #>EventJumpTable_051
	STA $F1
	JMP (EVENT_VECTOR_051)

EventIdle_051:
	NOP
	RTS

EventStart_051:
	LDA #<MessageData_051
	STA $30
	LDA #>MessageData_051
	STA $31
	RTS

EventStop_051:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_051:
.word EventIdle_051,EventStart_051,EventStop_051

MessagePointers_051:
.addr MessageData_051,StatusMessage_051

PaletteData_051:
.byte $0F,$30,$03,$13

MessageData_051:
.byte $C9,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_051:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_051:
.word Nmi_051,Reset_051,Irq_051
.byte <Reset_051,>Reset_051

; ======================================================================================
; PRG Bank 052 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $E800
.const PPUCTRL_052=$2000
.const PPUMASK_052=$2001
.const PPUSTATUS_052=$2002
.const EVENT_VECTOR_052=$00F0

Reset_052:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_052
	STA PPUMASK_052
	STA $00
	STA $01
	JSR ClearRam_052
	JSR LoadPalette_052
	JMP MainLoop_052

Nmi_052:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_052
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_052:
	RTI

MainLoop_052:
	JSR ReadController_052
	JSR UpdatePlayer_052
	JSR UpdateObjects_052
	JMP MainLoop_052

ClearRam_052:
	LDA #$00
	TAX
ClearRamLoop_052:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_052
	RTS

LoadPalette_052:
	LDX #$00
LoadPaletteLoop_052:
	LDA PaletteData_052,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_052
	RTS

ReadController_052:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_052:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_052
	RTS

UpdatePlayer_052:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_052
	INC $20
PlayerNotRight_052:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_052
	DEC $20
PlayerNotLeft_052:
	RTS

UpdateObjects_052:
	LDY #$00
ObjectLoop_052:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_052
	RTS

DispatchEvent_052:
	ASL A
	TAX
	LDA EventJumpTable_052,X
	STA $F0
	LDA #>EventJumpTable_052
	STA $F1
	JMP (EVENT_VECTOR_052)

EventIdle_052:
	NOP
	RTS

EventStart_052:
	LDA #<MessageData_052
	STA $30
	LDA #>MessageData_052
	STA $31
	RTS

EventStop_052:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_052:
.word EventIdle_052,EventStart_052,EventStop_052

MessagePointers_052:
.addr MessageData_052,StatusMessage_052

PaletteData_052:
.byte $0F,$30,$04,$14

MessageData_052:
.byte $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_052:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_052:
.word Nmi_052,Reset_052,Irq_052
.byte <Reset_052,>Reset_052

; ======================================================================================
; PRG Bank 053 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $EA00
.const PPUCTRL_053=$2000
.const PPUMASK_053=$2001
.const PPUSTATUS_053=$2002
.const EVENT_VECTOR_053=$00F0

Reset_053:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_053
	STA PPUMASK_053
	STA $00
	STA $01
	JSR ClearRam_053
	JSR LoadPalette_053
	JMP MainLoop_053

Nmi_053:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_053
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_053:
	RTI

MainLoop_053:
	JSR ReadController_053
	JSR UpdatePlayer_053
	JSR UpdateObjects_053
	JMP MainLoop_053

ClearRam_053:
	LDA #$00
	TAX
ClearRamLoop_053:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_053
	RTS

LoadPalette_053:
	LDX #$00
LoadPaletteLoop_053:
	LDA PaletteData_053,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_053
	RTS

ReadController_053:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_053:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_053
	RTS

UpdatePlayer_053:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_053
	INC $20
PlayerNotRight_053:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_053
	DEC $20
PlayerNotLeft_053:
	RTS

UpdateObjects_053:
	LDY #$00
ObjectLoop_053:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_053
	RTS

DispatchEvent_053:
	ASL A
	TAX
	LDA EventJumpTable_053,X
	STA $F0
	LDA #>EventJumpTable_053
	STA $F1
	JMP (EVENT_VECTOR_053)

EventIdle_053:
	NOP
	RTS

EventStart_053:
	LDA #<MessageData_053
	STA $30
	LDA #>MessageData_053
	STA $31
	RTS

EventStop_053:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_053:
.word EventIdle_053,EventStart_053,EventStop_053

MessagePointers_053:
.addr MessageData_053,StatusMessage_053

PaletteData_053:
.byte $0F,$30,$05,$15

MessageData_053:
.byte $B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_053:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_053:
.word Nmi_053,Reset_053,Irq_053
.byte <Reset_053,>Reset_053

; ======================================================================================
; PRG Bank 054 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $EC00
.const PPUCTRL_054=$2000
.const PPUMASK_054=$2001
.const PPUSTATUS_054=$2002
.const EVENT_VECTOR_054=$00F0

Reset_054:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_054
	STA PPUMASK_054
	STA $00
	STA $01
	JSR ClearRam_054
	JSR LoadPalette_054
	JMP MainLoop_054

Nmi_054:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_054
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_054:
	RTI

MainLoop_054:
	JSR ReadController_054
	JSR UpdatePlayer_054
	JSR UpdateObjects_054
	JMP MainLoop_054

ClearRam_054:
	LDA #$00
	TAX
ClearRamLoop_054:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_054
	RTS

LoadPalette_054:
	LDX #$00
LoadPaletteLoop_054:
	LDA PaletteData_054,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_054
	RTS

ReadController_054:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_054:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_054
	RTS

UpdatePlayer_054:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_054
	INC $20
PlayerNotRight_054:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_054
	DEC $20
PlayerNotLeft_054:
	RTS

UpdateObjects_054:
	LDY #$00
ObjectLoop_054:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_054
	RTS

DispatchEvent_054:
	ASL A
	TAX
	LDA EventJumpTable_054,X
	STA $F0
	LDA #>EventJumpTable_054
	STA $F1
	JMP (EVENT_VECTOR_054)

EventIdle_054:
	NOP
	RTS

EventStart_054:
	LDA #<MessageData_054
	STA $30
	LDA #>MessageData_054
	STA $31
	RTS

EventStop_054:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_054:
.word EventIdle_054,EventStart_054,EventStop_054

MessagePointers_054:
.addr MessageData_054,StatusMessage_054

PaletteData_054:
.byte $0F,$30,$06,$16

MessageData_054:
.byte $B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_054:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_054:
.word Nmi_054,Reset_054,Irq_054
.byte <Reset_054,>Reset_054

; ======================================================================================
; Complete Instruction And Addressing Mode Coverage
; Every Instruction And Every Mode In nes_ace.database.cpp Appears In This Section
; Undocumented Instructions And Modes Appear Exactly Once In This Section
; ======================================================================================

.org $A000

InstructionCoverage:

; BRK Addressing Modes
Coverage_BRK:
	BRK

; CLC Addressing Modes
Coverage_CLC:
	CLC

; CLD Addressing Modes
Coverage_CLD:
	CLD

; CLI Addressing Modes
Coverage_CLI:
	CLI

; CLV Addressing Modes
Coverage_CLV:
	CLV

; DEX Addressing Modes
Coverage_DEX:
	DEX

; DEY Addressing Modes
Coverage_DEY:
	DEY

; INX Addressing Modes
Coverage_INX:
	INX

; INY Addressing Modes
Coverage_INY:
	INY

; PHA Addressing Modes
Coverage_PHA:
	PHA

; PHP Addressing Modes
Coverage_PHP:
	PHP

; PLA Addressing Modes
Coverage_PLA:
	PLA

; PLP Addressing Modes
Coverage_PLP:
	PLP

; RTI Addressing Modes
Coverage_RTI:
	RTI

; RTS Addressing Modes
Coverage_RTS:
	RTS

; SEC Addressing Modes
Coverage_SEC:
	SEC

; SED Addressing Modes
Coverage_SED:
	SED

; SEI Addressing Modes
Coverage_SEI:
	SEI

; STP Addressing Modes - Undocumented Instruction
Coverage_STP:
	STP ; Undocumented

; TAX Addressing Modes
Coverage_TAX:
	TAX

; TAY Addressing Modes
Coverage_TAY:
	TAY

; TSX Addressing Modes
Coverage_TSX:
	TSX

; TXA Addressing Modes
Coverage_TXA:
	TXA

; TXS Addressing Modes
Coverage_TXS:
	TXS

; TYA Addressing Modes
Coverage_TYA:
	TYA

; BCC Addressing Modes
Coverage_BCC:
	BCC Coverage_BCC_REL_0_Target
Coverage_BCC_REL_0_Target:

; BCS Addressing Modes
Coverage_BCS:
	BCS Coverage_BCS_REL_0_Target
Coverage_BCS_REL_0_Target:

; BEQ Addressing Modes
Coverage_BEQ:
	BEQ Coverage_BEQ_REL_0_Target
Coverage_BEQ_REL_0_Target:

; BMI Addressing Modes
Coverage_BMI:
	BMI Coverage_BMI_REL_0_Target
Coverage_BMI_REL_0_Target:

; BNE Addressing Modes
Coverage_BNE:
	BNE Coverage_BNE_REL_0_Target
Coverage_BNE_REL_0_Target:

; BPL Addressing Modes
Coverage_BPL:
	BPL Coverage_BPL_REL_0_Target
Coverage_BPL_REL_0_Target:

; BVC Addressing Modes
Coverage_BVC:
	BVC Coverage_BVC_REL_0_Target
Coverage_BVC_REL_0_Target:

; BVS Addressing Modes
Coverage_BVS:
	BVS Coverage_BVS_REL_0_Target
Coverage_BVS_REL_0_Target:

; ADC Addressing Modes
Coverage_ADC:
	ADC #$44
	ADC $44
	ADC $44,X
	ADC $8444
	ADC $8444,X
	ADC $8444,Y
	ADC ($44,X)
	ADC ($44),Y

; AHX Addressing Modes - Undocumented Instruction
Coverage_AHX:
	AHX $8444,Y ; Undocumented
	AHX ($44),Y ; Undocumented

; ALR Addressing Modes - Undocumented Instruction
Coverage_ALR:
	ALR #$44 ; Undocumented

; ANC Addressing Modes - Undocumented Instruction
Coverage_ANC:
	ANC #$44 ; Undocumented

; AND Addressing Modes
Coverage_AND:
	AND #$44
	AND $44
	AND $44,X
	AND $8444
	AND $8444,X
	AND $8444,Y
	AND ($44,X)
	AND ($44),Y

; ARR Addressing Modes - Undocumented Instruction
Coverage_ARR:
	ARR #$44 ; Undocumented

; ASL Addressing Modes
Coverage_ASL:
	ASL A
	ASL $44
	ASL $44,X
	ASL $8444
	ASL $8444,X

; AXS Addressing Modes - Undocumented Instruction
Coverage_AXS:
	AXS #$44 ; Undocumented

; BIT Addressing Modes
Coverage_BIT:
	BIT $44
	BIT $8444

; CMP Addressing Modes
Coverage_CMP:
	CMP #$44
	CMP $44
	CMP $44,X
	CMP $8444
	CMP $8444,X
	CMP $8444,Y
	CMP ($44,X)
	CMP ($44),Y

; CPX Addressing Modes
Coverage_CPX:
	CPX #$44
	CPX $44
	CPX $8444

; CPY Addressing Modes
Coverage_CPY:
	CPY #$44
	CPY $44
	CPY $8444

; DCP Addressing Modes - Undocumented Instruction
Coverage_DCP:
	DCP $44 ; Undocumented
	DCP $44,X ; Undocumented
	DCP $8444 ; Undocumented
	DCP $8444,X ; Undocumented
	DCP $8444,Y ; Undocumented
	DCP ($44,X) ; Undocumented
	DCP ($44),Y ; Undocumented

; DEC Addressing Modes
Coverage_DEC:
	DEC $44
	DEC $44,X
	DEC $8444
	DEC $8444,X

; EOR Addressing Modes
Coverage_EOR:
	EOR #$44
	EOR $44
	EOR $44,X
	EOR $8444
	EOR $8444,X
	EOR $8444,Y
	EOR ($44,X)
	EOR ($44),Y

; INC Addressing Modes
Coverage_INC:
	INC $44
	INC $44,X
	INC $8444
	INC $8444,X

; ISC Addressing Modes - Undocumented Instruction
Coverage_ISC:
	ISC $44 ; Undocumented
	ISC $44,X ; Undocumented
	ISC $8444 ; Undocumented
	ISC $8444,X ; Undocumented
	ISC $8444,Y ; Undocumented
	ISC ($44,X) ; Undocumented
	ISC ($44),Y ; Undocumented

; JMP Addressing Modes
Coverage_JMP:
	JMP $8444
	JMP ($8444)

; JSR Addressing Modes
Coverage_JSR:
	JSR $8444

; LAS Addressing Modes - Undocumented Instruction
Coverage_LAS:
	LAS $8444,Y ; Undocumented

; LAX Addressing Modes - Undocumented Instruction
Coverage_LAX:
	LAX #$44 ; Undocumented
	LAX $44 ; Undocumented
	LAX $44,Y ; Undocumented
	LAX $8444 ; Undocumented
	LAX $8444,Y ; Undocumented
	LAX ($44,X) ; Undocumented
	LAX ($44),Y ; Undocumented

; LDA Addressing Modes
Coverage_LDA:
	LDA #$44
	LDA $44
	LDA $44,X
	LDA $8444
	LDA $8444,X
	LDA $8444,Y
	LDA ($44,X)
	LDA ($44),Y

; LDX Addressing Modes
Coverage_LDX:
	LDX #$44
	LDX $44
	LDX $44,Y
	LDX $8444
	LDX $8444,Y

; LDY Addressing Modes
Coverage_LDY:
	LDY #$44
	LDY $44
	LDY $44,X
	LDY $8444
	LDY $8444,X

; LSR Addressing Modes
Coverage_LSR:
	LSR A
	LSR $44
	LSR $44,X
	LSR $8444
	LSR $8444,X

; NOP Addressing Modes
Coverage_NOP:
	NOP
	NOP #$44 ; Undocumented
	NOP $44 ; Undocumented
	NOP $44,X ; Undocumented
	NOP $8444 ; Undocumented
	NOP $8444,X ; Undocumented

; ORA Addressing Modes
Coverage_ORA:
	ORA #$44
	ORA $44
	ORA $44,X
	ORA $8444
	ORA $8444,X
	ORA $8444,Y
	ORA ($44,X)
	ORA ($44),Y

; RLA Addressing Modes - Undocumented Instruction
Coverage_RLA:
	RLA $44 ; Undocumented
	RLA $44,X ; Undocumented
	RLA $8444 ; Undocumented
	RLA $8444,X ; Undocumented
	RLA $8444,Y ; Undocumented
	RLA ($44,X) ; Undocumented
	RLA ($44),Y ; Undocumented

; ROL Addressing Modes
Coverage_ROL:
	ROL A
	ROL $44
	ROL $44,X
	ROL $8444
	ROL $8444,X

; ROR Addressing Modes
Coverage_ROR:
	ROR A
	ROR $44
	ROR $44,X
	ROR $8444
	ROR $8444,X

; RRA Addressing Modes - Undocumented Instruction
Coverage_RRA:
	RRA $44 ; Undocumented
	RRA $44,X ; Undocumented
	RRA $8444 ; Undocumented
	RRA $8444,X ; Undocumented
	RRA $8444,Y ; Undocumented
	RRA ($44,X) ; Undocumented
	RRA ($44),Y ; Undocumented

; SAX Addressing Modes - Undocumented Instruction
Coverage_SAX:
	SAX $44 ; Undocumented
	SAX $44,Y ; Undocumented
	SAX $8444 ; Undocumented
	SAX ($44,X) ; Undocumented

; SBC Addressing Modes
Coverage_SBC:
	SBC #$44
	SBC $44
	SBC $44,X
	SBC $8444
	SBC $8444,X
	SBC $8444,Y
	SBC ($44,X)
	SBC ($44),Y

; SHX Addressing Modes - Undocumented Instruction
Coverage_SHX:
	SHX $8444,Y ; Undocumented

; SHY Addressing Modes - Undocumented Instruction
Coverage_SHY:
	SHY $8444,X ; Undocumented

; SLO Addressing Modes - Undocumented Instruction
Coverage_SLO:
	SLO $44 ; Undocumented
	SLO $44,X ; Undocumented
	SLO $8444 ; Undocumented
	SLO $8444,X ; Undocumented
	SLO $8444,Y ; Undocumented
	SLO ($44,X) ; Undocumented
	SLO ($44),Y ; Undocumented

; SRE Addressing Modes - Undocumented Instruction
Coverage_SRE:
	SRE $44 ; Undocumented
	SRE $44,X ; Undocumented
	SRE $8444 ; Undocumented
	SRE $8444,X ; Undocumented
	SRE $8444,Y ; Undocumented
	SRE ($44,X) ; Undocumented
	SRE ($44),Y ; Undocumented

; STA Addressing Modes
Coverage_STA:
	STA $44
	STA $44,X
	STA $8444
	STA $8444,X
	STA $8444,Y
	STA ($44,X)
	STA ($44),Y

; STX Addressing Modes
Coverage_STX:
	STX $44
	STX $44,Y
	STX $8444

; STY Addressing Modes
Coverage_STY:
	STY $44
	STY $44,X
	STY $8444

; TAS Addressing Modes - Undocumented Instruction
Coverage_TAS:
	TAS $8444,Y ; Undocumented

; XAA Addressing Modes - Undocumented Instruction
Coverage_XAA:
	XAA #$44 ; Undocumented

	RTS

; ======================================================================================
; PRG Bank 055 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $EE00
.const PPUCTRL_055=$2000
.const PPUMASK_055=$2001
.const PPUSTATUS_055=$2002
.const EVENT_VECTOR_055=$00F0

Reset_055:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_055
	STA PPUMASK_055
	STA $00
	STA $01
	JSR ClearRam_055
	JSR LoadPalette_055
	JMP MainLoop_055

Nmi_055:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_055
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_055:
	RTI

MainLoop_055:
	JSR ReadController_055
	JSR UpdatePlayer_055
	JSR UpdateObjects_055
	JMP MainLoop_055

ClearRam_055:
	LDA #$00
	TAX
ClearRamLoop_055:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_055
	RTS

LoadPalette_055:
	LDX #$00
LoadPaletteLoop_055:
	LDA PaletteData_055,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_055
	RTS

ReadController_055:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_055:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_055
	RTS

UpdatePlayer_055:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_055
	INC $20
PlayerNotRight_055:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_055
	DEC $20
PlayerNotLeft_055:
	RTS

UpdateObjects_055:
	LDY #$00
ObjectLoop_055:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_055
	RTS

DispatchEvent_055:
	ASL A
	TAX
	LDA EventJumpTable_055,X
	STA $F0
	LDA #>EventJumpTable_055
	STA $F1
	JMP (EVENT_VECTOR_055)

EventIdle_055:
	NOP
	RTS

EventStart_055:
	LDA #<MessageData_055
	STA $30
	LDA #>MessageData_055
	STA $31
	RTS

EventStop_055:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_055:
.word EventIdle_055,EventStart_055,EventStop_055

MessagePointers_055:
.addr MessageData_055,StatusMessage_055

PaletteData_055:
.byte $0F,$30,$07,$17

MessageData_055:
.byte $B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_055:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_055:
.word Nmi_055,Reset_055,Irq_055
.byte <Reset_055,>Reset_055

; ======================================================================================
; PRG Bank 056 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8000
.const PPUCTRL_056=$2000
.const PPUMASK_056=$2001
.const PPUSTATUS_056=$2002
.const EVENT_VECTOR_056=$00F0

Reset_056:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_056
	STA PPUMASK_056
	STA $00
	STA $01
	JSR ClearRam_056
	JSR LoadPalette_056
	JMP MainLoop_056

Nmi_056:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_056
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_056:
	RTI

MainLoop_056:
	JSR ReadController_056
	JSR UpdatePlayer_056
	JSR UpdateObjects_056
	JMP MainLoop_056

ClearRam_056:
	LDA #$00
	TAX
ClearRamLoop_056:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_056
	RTS

LoadPalette_056:
	LDX #$00
LoadPaletteLoop_056:
	LDA PaletteData_056,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_056
	RTS

ReadController_056:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_056:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_056
	RTS

UpdatePlayer_056:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_056
	INC $20
PlayerNotRight_056:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_056
	DEC $20
PlayerNotLeft_056:
	RTS

UpdateObjects_056:
	LDY #$00
ObjectLoop_056:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_056
	RTS

DispatchEvent_056:
	ASL A
	TAX
	LDA EventJumpTable_056,X
	STA $F0
	LDA #>EventJumpTable_056
	STA $F1
	JMP (EVENT_VECTOR_056)

EventIdle_056:
	NOP
	RTS

EventStart_056:
	LDA #<MessageData_056
	STA $30
	LDA #>MessageData_056
	STA $31
	RTS

EventStop_056:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_056:
.word EventIdle_056,EventStart_056,EventStop_056

MessagePointers_056:
.addr MessageData_056,StatusMessage_056

PaletteData_056:
.byte $0F,$30,$08,$18

MessageData_056:
.byte $B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_056:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_056:
.word Nmi_056,Reset_056,Irq_056
.byte <Reset_056,>Reset_056

; ======================================================================================
; PRG Bank 057 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8200
.const PPUCTRL_057=$2000
.const PPUMASK_057=$2001
.const PPUSTATUS_057=$2002
.const EVENT_VECTOR_057=$00F0

Reset_057:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_057
	STA PPUMASK_057
	STA $00
	STA $01
	JSR ClearRam_057
	JSR LoadPalette_057
	JMP MainLoop_057

Nmi_057:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_057
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_057:
	RTI

MainLoop_057:
	JSR ReadController_057
	JSR UpdatePlayer_057
	JSR UpdateObjects_057
	JMP MainLoop_057

ClearRam_057:
	LDA #$00
	TAX
ClearRamLoop_057:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_057
	RTS

LoadPalette_057:
	LDX #$00
LoadPaletteLoop_057:
	LDA PaletteData_057,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_057
	RTS

ReadController_057:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_057:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_057
	RTS

UpdatePlayer_057:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_057
	INC $20
PlayerNotRight_057:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_057
	DEC $20
PlayerNotLeft_057:
	RTS

UpdateObjects_057:
	LDY #$00
ObjectLoop_057:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_057
	RTS

DispatchEvent_057:
	ASL A
	TAX
	LDA EventJumpTable_057,X
	STA $F0
	LDA #>EventJumpTable_057
	STA $F1
	JMP (EVENT_VECTOR_057)

EventIdle_057:
	NOP
	RTS

EventStart_057:
	LDA #<MessageData_057
	STA $30
	LDA #>MessageData_057
	STA $31
	RTS

EventStop_057:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_057:
.word EventIdle_057,EventStart_057,EventStop_057

MessagePointers_057:
.addr MessageData_057,StatusMessage_057

PaletteData_057:
.byte $0F,$30,$09,$19

MessageData_057:
.byte $B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_057:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_057:
.word Nmi_057,Reset_057,Irq_057
.byte <Reset_057,>Reset_057

; ======================================================================================
; PRG Bank 058 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8400
.const PPUCTRL_058=$2000
.const PPUMASK_058=$2001
.const PPUSTATUS_058=$2002
.const EVENT_VECTOR_058=$00F0

Reset_058:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_058
	STA PPUMASK_058
	STA $00
	STA $01
	JSR ClearRam_058
	JSR LoadPalette_058
	JMP MainLoop_058

Nmi_058:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_058
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_058:
	RTI

MainLoop_058:
	JSR ReadController_058
	JSR UpdatePlayer_058
	JSR UpdateObjects_058
	JMP MainLoop_058

ClearRam_058:
	LDA #$00
	TAX
ClearRamLoop_058:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_058
	RTS

LoadPalette_058:
	LDX #$00
LoadPaletteLoop_058:
	LDA PaletteData_058,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_058
	RTS

ReadController_058:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_058:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_058
	RTS

UpdatePlayer_058:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_058
	INC $20
PlayerNotRight_058:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_058
	DEC $20
PlayerNotLeft_058:
	RTS

UpdateObjects_058:
	LDY #$00
ObjectLoop_058:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_058
	RTS

DispatchEvent_058:
	ASL A
	TAX
	LDA EventJumpTable_058,X
	STA $F0
	LDA #>EventJumpTable_058
	STA $F1
	JMP (EVENT_VECTOR_058)

EventIdle_058:
	NOP
	RTS

EventStart_058:
	LDA #<MessageData_058
	STA $30
	LDA #>MessageData_058
	STA $31
	RTS

EventStop_058:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_058:
.word EventIdle_058,EventStart_058,EventStop_058

MessagePointers_058:
.addr MessageData_058,StatusMessage_058

PaletteData_058:
.byte $0F,$30,$0A,$1A

MessageData_058:
.byte $B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_058:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_058:
.word Nmi_058,Reset_058,Irq_058
.byte <Reset_058,>Reset_058

; ======================================================================================
; PRG Bank 059 - Main Game Logic, PPU Updates And Data Tables
; ======================================================================================

.org $8600
.const PPUCTRL_059=$2000
.const PPUMASK_059=$2001
.const PPUSTATUS_059=$2002
.const EVENT_VECTOR_059=$00F0

Reset_059:
	SEI
	CLD
	LDX #$FF
	TXS
	LDA #$00
	STA PPUCTRL_059
	STA PPUMASK_059
	STA $00
	STA $01
	JSR ClearRam_059
	JSR LoadPalette_059
	JMP MainLoop_059

Nmi_059:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA PPUSTATUS_059
	INC $00
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI

Irq_059:
	RTI

MainLoop_059:
	JSR ReadController_059
	JSR UpdatePlayer_059
	JSR UpdateObjects_059
	JMP MainLoop_059

ClearRam_059:
	LDA #$00
	TAX
ClearRamLoop_059:
	STA $0200,X
	STA $0300,X
	STA $0400,X
	STA $0500,X
	INX
	BNE ClearRamLoop_059
	RTS

LoadPalette_059:
	LDX #$00
LoadPaletteLoop_059:
	LDA PaletteData_059,X
	STA $0300,X
	INX
	CPX #$04
	BNE LoadPaletteLoop_059
	RTS

ReadController_059:
	LDA #$01
	STA $4016
	LSR A
	STA $4016
	LDX #$08
ReadControllerLoop_059:
	LDA $4016
	LSR A
	ROL $10
	DEX
	BNE ReadControllerLoop_059
	RTS

UpdatePlayer_059:
	LDA $10
	AND #%00000001
	BEQ PlayerNotRight_059
	INC $20
PlayerNotRight_059:
	LDA $10
	AND #%00000010
	BEQ PlayerNotLeft_059
	DEC $20
PlayerNotLeft_059:
	RTS

UpdateObjects_059:
	LDY #$00
ObjectLoop_059:
	LDA $0400,Y
	CLC
	ADC $0401,Y
	STA $0400,Y
	INY
	INY
	CPY #$20
	BNE ObjectLoop_059
	RTS

DispatchEvent_059:
	ASL A
	TAX
	LDA EventJumpTable_059,X
	STA $F0
	LDA #>EventJumpTable_059
	STA $F1
	JMP (EVENT_VECTOR_059)

EventIdle_059:
	NOP
	RTS

EventStart_059:
	LDA #<MessageData_059
	STA $30
	LDA #>MessageData_059
	STA $31
	RTS

EventStop_059:
	LDA #$00
	STA $30
	STA $31
	RTS

EventJumpTable_059:
.word EventIdle_059,EventStart_059,EventStop_059

MessagePointers_059:
.addr MessageData_059,StatusMessage_059

PaletteData_059:
.byte $0F,$30,$0B,$1B

MessageData_059:
.byte $B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$C0,$C1,$C2 ; Pattern Table Message
.byte $FE,$FE,$FE,$FE

StatusMessage_059:
.byte $C1,$C4,$B0,$B3,$C8 ; READY
.byte $FE,$F0,$F1,$F2,$F3

BankVectors_059:
.word Nmi_059,Reset_059,Irq_059
.byte <Reset_059,>Reset_059


; Reserved PRG Padding Line 0001
; Reserved PRG Padding Line 0002

; Reserved PRG Padding Line 0004
; Reserved PRG Padding Line 0005

; Reserved PRG Padding Line 0007
; Reserved PRG Padding Line 0008

; Reserved PRG Padding Line 0010
; Reserved PRG Padding Line 0011

; Reserved PRG Padding Line 0013
; Reserved PRG Padding Line 0014

; Reserved PRG Padding Line 0016
; Reserved PRG Padding Line 0017

; Reserved PRG Padding Line 0019
; Reserved PRG Padding Line 0020

; Reserved PRG Padding Line 0022
; Reserved PRG Padding Line 0023

; Reserved PRG Padding Line 0025
; Reserved PRG Padding Line 0026

; Reserved PRG Padding Line 0028
; Reserved PRG Padding Line 0029

; Reserved PRG Padding Line 0031
; Reserved PRG Padding Line 0032

; Reserved PRG Padding Line 0034
; Reserved PRG Padding Line 0035

; Reserved PRG Padding Line 0037
; Reserved PRG Padding Line 0038

; Reserved PRG Padding Line 0040
; Reserved PRG Padding Line 0041

; Reserved PRG Padding Line 0043
; Reserved PRG Padding Line 0044

; Reserved PRG Padding Line 0046
; Reserved PRG Padding Line 0047

; Reserved PRG Padding Line 0049
; Reserved PRG Padding Line 0050

; Reserved PRG Padding Line 0052
; Reserved PRG Padding Line 0053

; Reserved PRG Padding Line 0055
; Reserved PRG Padding Line 0056

; Reserved PRG Padding Line 0058
; Reserved PRG Padding Line 0059

; Reserved PRG Padding Line 0061
; Reserved PRG Padding Line 0062

; Reserved PRG Padding Line 0064
; Reserved PRG Padding Line 0065

; Reserved PRG Padding Line 0067
; Reserved PRG Padding Line 0068

; Reserved PRG Padding Line 0070
; Reserved PRG Padding Line 0071

; Reserved PRG Padding Line 0073
; Reserved PRG Padding Line 0074

; Reserved PRG Padding Line 0076
; Reserved PRG Padding Line 0077

; Reserved PRG Padding Line 0079
; Reserved PRG Padding Line 0080

; Reserved PRG Padding Line 0082
; Reserved PRG Padding Line 0083

; Reserved PRG Padding Line 0085
; Reserved PRG Padding Line 0086

; Reserved PRG Padding Line 0088
; Reserved PRG Padding Line 0089

; Reserved PRG Padding Line 0091
; Reserved PRG Padding Line 0092

; Reserved PRG Padding Line 0094
; Reserved PRG Padding Line 0095

; Reserved PRG Padding Line 0097
; Reserved PRG Padding Line 0098

; Reserved PRG Padding Line 0100
; Reserved PRG Padding Line 0101

; Reserved PRG Padding Line 0103
; Reserved PRG Padding Line 0104

; Reserved PRG Padding Line 0106
; Reserved PRG Padding Line 0107
