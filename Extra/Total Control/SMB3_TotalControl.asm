; Total Control Program for SMB3 ACE TAS
; (XX/XX) on Origin Directive Represents Used/Available RAM in that Block

.const Temp_Var1 = $0000 ; Where Controller Reading Routine Stores Controller State Each Poll
.const PPU_Ctrl_Copy = $00FF ; Must Be Synced With PPU_Ctrl
.const PPU_Ctrl = $2000 ; Bit 7 Enables/Disables NMI
.const Read_Joypad = $FF12 ; Controller Reading Routine in PRG31

.org $7AE4 ; (12/12)

; Disable NMI so Writes Run Uninterupted
DisableNMI:
	LDA #%01111111
	AND <PPU_Ctrl_Copy
	STA PPU_Ctrl
	STA <PPU_Ctrl_Copy
	JMP SetHeader

.org $7D80 ; (28/28)

; Initialize Header by Setting Counter in X Register
SetHeader:
	LDX #3
	JSR ModifyHeader

; Start Writing Code
LoopStart:
	LDX $C3 ; Load X Register with Length of Payload
	LDA #$00
	STA $C5 ; Use $C5 as a Pseudo-Y Register Since it Resets to #$00 for Every Controller Read

; Store Our Writes at the Pointer with Appropriate Offset Until X = 0
DontExit:
	JSR DoController
	LDA <Temp_Var1
	LDY $C5
	STA ($C1),Y
	INC $C5
	DEX
	BNE DontExit
	JMP PostLoop

.org $7E9E ; (23/24)

; Payload Complete, Set New Header if Next Poll is Right Only
PostLoop:
	JSR DoController
	LDA <Temp_Var1
	CMP #%00000001
	BNE CleanUp
	JMP SetHeader
	
CleanUp: ; Otherwise Cleanup, Set Header for Jump, and Exit (No Buttons Were Pressed)
	LDX #$FF
	TXS

	LDX #2 ; Only Need to Write to C1 and C2, No Payload Length, Just Writing a Jump
	JSR ModifyHeader
	JMP EnableNMI

.org $7CA0 ; (33/40)

; Utilize SMB3 Controller Polling Code
DoController:
	LDY #$00
	STX $C4 ; Use $C4 as a Pseudo-X Register Since X Reg is Used for Controller Strobing
	JSR Read_Joypad
	LDX $C4
	RTS

; Set C3 as Payload Length, C2 as High Byte ($XY__) and C1 as Low Byte ($__XY)
ModifyHeader:
	JSR DoController
	LDA <Temp_Var1
	DEX
	STA $C1,X ; Store in Reverse Order (C3, C2, C1)
	BNE ModifyHeader
	RTS

; Re-enable NMI for Gameplay when Exiting Loop and Jump to Address Specified by Header
EnableNMI:
	LDA #%10000000
	ORA <PPU_Ctrl_Copy
	STA PPU_Ctrl
	STA <PPU_Ctrl_Copy
	JMP ($00C1)