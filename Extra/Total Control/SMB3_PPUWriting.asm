.const PPU_Mask_Copy = $0016
.const Controller_2 = $00F8
.const Sprite_RAM = $0200
.const PatTable_BankSel = $071A
.const PPU_Mask = $2001
.const PPU_Status = $2002
.const PPU_Scroll = $2005
.const PPU_Addr = $2006
.const PPU_Data = $2007
.const UpdSel_Disable = $7955
.const DisableNMI = $7AE4
.const DMC01 = $E000

.org $0147

; Main Loop
CheckController:
	STA DMC01 ; Disable IRQ
	LDA <Controller_2
	CMP #%11000000 ; Is A + B Held?
	BEQ SetupPPU ; If So, New Buffer to Write into the PPU
	CMP #%00110000 ; Is Start + Select Held?
	BNE CheckController ; No, Stay in this Loop Until We Have Something We Want to Update
	JMP DisableNMI ; Start of Total Control Program

; Written once, Skip Setting Palettes and Clearing Nametables/Attribute Tables
SkipBackground:
	STA UpdSel_Disable ; Disable NMI PPU Updates
	JSR WaitForVBlank
	JMP MessagePrep

; Prepare PPU for Writing White Text on Black Background
SetupPPU:
	JSR WaitForVBlank
	LDA #%00000000
	STA PPU_Mask ; Disable Rendering

	; Set PPU Read/Write Address to $3F00 (Palettes)
	BIT PPU_Status ; Reset Latch	
	LDA #$3F
	STA PPU_Addr
	LDA #$00
	STA PPU_Addr
	
	; Set All Palettes to All White and Black Background Using Data at $7DA3 (#$30, #$0F, #$30, #$0F)
	LDX #0
	LDY #16

SetPalette:
	LDA PalTable,X
	STA PPU_Data
	INX
	CPX #4
	BNE NoReset ; Only Reset X to 0 Every 4 Bytes, Writes the Same 4 Bytes to All 4 Palettes
	LDX #0

NoReset:
	DEY
	BNE SetPalette
	
	; Clear Nametable and Attribute Table in One Go
	BIT PPU_Status ; Reset Latch
	LDA #$20
	STA PPU_Addr
	LDA #$00
	STA PPU_Addr ; Set PPU Read/Write Address to $2000 (Upper Left of Nametable)
	
	LDA #$FE ; Blank Tile
	LDX #0
	LDY #4

; Loop 1024 times (once for each tile in nametable/attribute table)
ClearTables:
	STA PPU_Data
	DEX ; 1st DEX Takes X 0 -> 255, Branch Taken
	BNE ClearTables
	DEY
	BNE ClearTables

; Set PPU Read/Write Address to What is Specified in Payload
MessagePrep:
	BIT PPU_Status ; Reset Latch
	LDA LookUp_High
	STA PPU_Addr
	LDA LookUp_Low
	STA PPU_Addr

; Write Each Tile to the PPU
MessageLoop:
	LDA LookUp_Data,X
	STA PPU_Data
	INX
	CPX LookUp_Length
	BNE MessageLoop

	; Select Pattern Table with All Numbers/Letters Available (chr094.pcx)
	LDA #94
	STA PatTable_BankSel
	
	; Wait for VBlank, then Reset the Scroll and Re-enable Rendering
	JSR WaitForVBlank

	BIT PPU_Status ; Reset Latch
	LDA #$00
	STA UpdSel_Disable ; Re-enable NMI PPU Updates
	STA PPU_Scroll ; Set Fine X Scroll to 0
	STA PPU_Scroll ; Set Fine Y Scroll to 0

	; Re-enable Rendering, Unmask Left 8 Pixels
	LDA #%00001010
	STA PPU_Mask
	STA <PPU_Mask_Copy

	JMP CheckController

.org $7DA3

; Palette for Text Screen
PalTable:
	.byte $30,$0F,$30,$0F

; Function to Ensure No Graphical Updates are Pushed Outside VBlank
WaitForVBlank:
	BIT PPU_Status ; Bit 7 of PPU_Status is Set During VBlank and Cleared When Read
	BPL WaitForVBlank
	STA DMC01 ; Disable IRQ, Guaranteed to Happen Directly After NMI
	RTS

; Type 1 Character Every 10 Frames
FrameCounter:
	.byte 10

; Used to Hide All Sprites at End of Level
HideSprites:
	LDA #$F8
	LDX #0
SprLoop:
	STA Sprite_RAM,X
	INX
	BNE SprLoop
	JMP CheckController

.org $7F2E

TypewriterSetup: ; $7F2E
	LDA #%00001010 ; Unmask Left Most 8 Pixels
	STA UpdSel_Disable ; Disable NMI from Making PPU Updates
	STA PPU_Mask
	STA <PPU_Mask_Copy
	JMP Wait

.org $0428

; Wait Until Ready to Type Another Character
Wait:
	JSR WaitForVBlank
	DEC FrameCounter
	BNE Wait

; Finished Waiting, Type Another Character
TypeCharacter:
	LDA #10 ; Reset Frame Counter
	STA FrameCounter
	
	BIT PPU_Status ; Reset Latch
	LDA LookUp_High
	STA PPU_Addr
	LDA LookUp_Low
	STA PPU_Addr

	; Write Character to PPU, Update Address and Wait Again if Not Done
	LDA LookUp_Data,X
	STA PPU_Data
	INX

	; Reset Latch and Restore Scroll
	BIT PPU_Status
	LDA #$00
	STA PPU_Scroll
	STA PPU_Scroll

	INC LookUp_Low ; Only Concerned About Low Byte
	CPX LookUp_Length
	BNE Wait

	JMP ReturnToIdle

.org $7F25

; Reset NMI And Jump Back to Idle Loop
ReturnToIdle:
	LDA #$00
	STA UpdSel_Disable ; Return NMI to Normal
	JMP CheckController

; Queue Discovery Music
.org $04F4

	.byte $04

.org $7BD0

; LookUp Table (3 Byte Header: Length, PPU High Byte, PPU Low Byte)
LookUp_Length:
	.byte $01

LookUp_High:	
	.byte $20

LookUp_Low:
	.byte $00

LookUp_Data:
	.byte $FE