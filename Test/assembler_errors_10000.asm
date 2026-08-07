; NES ACE Assembler - 10,000 Line Error And Normalization Stress Test
; Contains Focused Intentional Errors Plus Thousands Of Valid Ugly Lines
; No Undocumented Instructions Are Used In This File

; ======================================================================================
; Intentional Error Matrix
; Every Public Error Type And Important Boundary Case Appears Below
; ======================================================================================

BeforeOriginLabel:
	LDA #$01
.byte $01
.word $1234

.org $8000

; Syntax Errors
BROKEN
.unknown $1234
THIS IS NOT VALID
.org
.byte

; Invalid Labels
:
1START:
A:
BAD-NAME:
$BAD:

; Invalid Instructions
	XYZ
	QZZ $10
	ABC #$01

; Invalid Operands
	LDA #
	LDA #$1234
	LDA ($1234,X)
	LDA ($10)
	LDA $10,Z
	LDA [$10]
	BNE #$1234
	BNE $10
	CLC $10

; Invalid Addressing Modes
	BIT #$10
	STX $10,X
	STY $10,Y
	JMP $10
	JSR ($1234)
	LDX $10,X

; Invalid .org Directives
.org MISSING_ORIGIN
.org $80
.org #$8000
.org $10000
.org <$8000

; Invalid Constants
.const NO_EQUALS
.const TOO=MANY=EQUALS
.const 1BAD=$1234
.const BYTE_CONST=$12
.const SYMBOL_CONST=UNKNOWN_CONST
.const WRAPPED_CONST=#$1234
.const LARGE_CONST=$10000
.const COMMA_CONST=$1234,

; Invalid Data Directives
.byte $1234
.word $12
.byte #$10
.word <$1234
.byte $10,,$11
.byte $GG
.word $10000

; Duplicate Symbols
.const DUP_CONST=$1234
.const DUP_CONST=$5678
DUP_LABEL:
DUP_LABEL:
.const CROSS_SYMBOL=$2222
CROSS_SYMBOL:
LABEL_THEN_CONST:
.const LABEL_THEN_CONST=$3333

; Branch Range Boundary Controls
.org $9000
ForwardValidStart:
	BNE ForwardValidTarget
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
ForwardValidTarget:
	NOP

.org $9100
ForwardInvalidStart:
	BNE ForwardInvalidTarget
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
ForwardInvalidTarget:
	NOP

.org $9200
BackwardValidTarget:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	BNE BackwardValidTarget

.org $9300
BackwardInvalidTarget:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	BNE BackwardInvalidTarget

; Undefined Symbols
.org $9400
	LDA MISSING_ABSOLUTE
	JMP MISSING_JUMP
.word MISSING_WORD
.byte <MISSING_BYTE

   ; Weird Formatting Module 0000 - All Of This Should Normalize Cleanly   

     .OrG       $9000       
 .CoNsT      pPuCtRl_0000     =      $2000    
.cOnSt    ZeRoPaGe_0000=     $00f0

  WeirdStart_0000:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0000      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0000:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0000
	JsR       WeirdSub_0000
	JmP         WeirdDone_0000

WeirdSub_0000:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0000:
	NoP
	RtS

 WeirdTable_0000:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0000   ,   WeirdSub_0000
.aDdR  WeirdDone_0000
.bYtE   <WeirdStart_0000 , >WeirdStart_0000

   ; Weird Formatting Module 0001 - All Of This Should Normalize Cleanly   

     .OrG       $9100       
 .CoNsT      pPuCtRl_0001     =      $2000    
.cOnSt    ZeRoPaGe_0001=     $00f0

  WeirdStart_0001:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0001      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0001:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0001
	JsR       WeirdSub_0001
	JmP         WeirdDone_0001

WeirdSub_0001:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0001:
	NoP
	RtS

 WeirdTable_0001:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0001   ,   WeirdSub_0001
.aDdR  WeirdDone_0001
.bYtE   <WeirdStart_0001 , >WeirdStart_0001

   ; Weird Formatting Module 0002 - All Of This Should Normalize Cleanly   

     .OrG       $9200       
 .CoNsT      pPuCtRl_0002     =      $2000    
.cOnSt    ZeRoPaGe_0002=     $00f0

  WeirdStart_0002:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0002      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0002:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0002
	JsR       WeirdSub_0002
	JmP         WeirdDone_0002

WeirdSub_0002:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0002:
	NoP
	RtS

 WeirdTable_0002:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0002   ,   WeirdSub_0002
.aDdR  WeirdDone_0002
.bYtE   <WeirdStart_0002 , >WeirdStart_0002

   ; Weird Formatting Module 0003 - All Of This Should Normalize Cleanly   

     .OrG       $9300       
 .CoNsT      pPuCtRl_0003     =      $2000    
.cOnSt    ZeRoPaGe_0003=     $00f0

  WeirdStart_0003:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0003      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0003:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0003
	JsR       WeirdSub_0003
	JmP         WeirdDone_0003

WeirdSub_0003:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0003:
	NoP
	RtS

 WeirdTable_0003:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0003   ,   WeirdSub_0003
.aDdR  WeirdDone_0003
.bYtE   <WeirdStart_0003 , >WeirdStart_0003

   ; Weird Formatting Module 0004 - All Of This Should Normalize Cleanly   

     .OrG       $9400       
 .CoNsT      pPuCtRl_0004     =      $2000    
.cOnSt    ZeRoPaGe_0004=     $00f0

  WeirdStart_0004:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0004      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0004:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0004
	JsR       WeirdSub_0004
	JmP         WeirdDone_0004

WeirdSub_0004:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0004:
	NoP
	RtS

 WeirdTable_0004:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0004   ,   WeirdSub_0004
.aDdR  WeirdDone_0004
.bYtE   <WeirdStart_0004 , >WeirdStart_0004

   ; Weird Formatting Module 0005 - All Of This Should Normalize Cleanly   

     .OrG       $9500       
 .CoNsT      pPuCtRl_0005     =      $2000    
.cOnSt    ZeRoPaGe_0005=     $00f0

  WeirdStart_0005:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0005      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0005:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0005
	JsR       WeirdSub_0005
	JmP         WeirdDone_0005

WeirdSub_0005:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0005:
	NoP
	RtS

 WeirdTable_0005:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0005   ,   WeirdSub_0005
.aDdR  WeirdDone_0005
.bYtE   <WeirdStart_0005 , >WeirdStart_0005

   ; Weird Formatting Module 0006 - All Of This Should Normalize Cleanly   

     .OrG       $9600       
 .CoNsT      pPuCtRl_0006     =      $2000    
.cOnSt    ZeRoPaGe_0006=     $00f0

  WeirdStart_0006:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0006      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0006:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0006
	JsR       WeirdSub_0006
	JmP         WeirdDone_0006

WeirdSub_0006:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0006:
	NoP
	RtS

 WeirdTable_0006:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0006   ,   WeirdSub_0006
.aDdR  WeirdDone_0006
.bYtE   <WeirdStart_0006 , >WeirdStart_0006

   ; Weird Formatting Module 0007 - All Of This Should Normalize Cleanly   

     .OrG       $9700       
 .CoNsT      pPuCtRl_0007     =      $2000    
.cOnSt    ZeRoPaGe_0007=     $00f0

  WeirdStart_0007:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0007      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0007:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0007
	JsR       WeirdSub_0007
	JmP         WeirdDone_0007

WeirdSub_0007:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0007:
	NoP
	RtS

 WeirdTable_0007:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0007   ,   WeirdSub_0007
.aDdR  WeirdDone_0007
.bYtE   <WeirdStart_0007 , >WeirdStart_0007

   ; Weird Formatting Module 0008 - All Of This Should Normalize Cleanly   

     .OrG       $9800       
 .CoNsT      pPuCtRl_0008     =      $2000    
.cOnSt    ZeRoPaGe_0008=     $00f0

  WeirdStart_0008:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0008      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0008:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0008
	JsR       WeirdSub_0008
	JmP         WeirdDone_0008

WeirdSub_0008:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0008:
	NoP
	RtS

 WeirdTable_0008:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0008   ,   WeirdSub_0008
.aDdR  WeirdDone_0008
.bYtE   <WeirdStart_0008 , >WeirdStart_0008

   ; Weird Formatting Module 0009 - All Of This Should Normalize Cleanly   

     .OrG       $9900       
 .CoNsT      pPuCtRl_0009     =      $2000    
.cOnSt    ZeRoPaGe_0009=     $00f0

  WeirdStart_0009:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0009      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0009:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0009
	JsR       WeirdSub_0009
	JmP         WeirdDone_0009

WeirdSub_0009:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0009:
	NoP
	RtS

 WeirdTable_0009:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0009   ,   WeirdSub_0009
.aDdR  WeirdDone_0009
.bYtE   <WeirdStart_0009 , >WeirdStart_0009

   ; Weird Formatting Module 0010 - All Of This Should Normalize Cleanly   

     .OrG       $9a00       
 .CoNsT      pPuCtRl_0010     =      $2000    
.cOnSt    ZeRoPaGe_0010=     $00f0

  WeirdStart_0010:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0010      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0010:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0010
	JsR       WeirdSub_0010
	JmP         WeirdDone_0010

WeirdSub_0010:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0010:
	NoP
	RtS

 WeirdTable_0010:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0010   ,   WeirdSub_0010
.aDdR  WeirdDone_0010
.bYtE   <WeirdStart_0010 , >WeirdStart_0010

   ; Weird Formatting Module 0011 - All Of This Should Normalize Cleanly   

     .OrG       $9b00       
 .CoNsT      pPuCtRl_0011     =      $2000    
.cOnSt    ZeRoPaGe_0011=     $00f0

  WeirdStart_0011:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0011      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0011:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0011
	JsR       WeirdSub_0011
	JmP         WeirdDone_0011

WeirdSub_0011:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0011:
	NoP
	RtS

 WeirdTable_0011:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0011   ,   WeirdSub_0011
.aDdR  WeirdDone_0011
.bYtE   <WeirdStart_0011 , >WeirdStart_0011

   ; Weird Formatting Module 0012 - All Of This Should Normalize Cleanly   

     .OrG       $9c00       
 .CoNsT      pPuCtRl_0012     =      $2000    
.cOnSt    ZeRoPaGe_0012=     $00f0

  WeirdStart_0012:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0012      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0012:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0012
	JsR       WeirdSub_0012
	JmP         WeirdDone_0012

WeirdSub_0012:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0012:
	NoP
	RtS

 WeirdTable_0012:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0012   ,   WeirdSub_0012
.aDdR  WeirdDone_0012
.bYtE   <WeirdStart_0012 , >WeirdStart_0012

   ; Weird Formatting Module 0013 - All Of This Should Normalize Cleanly   

     .OrG       $9d00       
 .CoNsT      pPuCtRl_0013     =      $2000    
.cOnSt    ZeRoPaGe_0013=     $00f0

  WeirdStart_0013:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0013      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0013:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0013
	JsR       WeirdSub_0013
	JmP         WeirdDone_0013

WeirdSub_0013:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0013:
	NoP
	RtS

 WeirdTable_0013:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0013   ,   WeirdSub_0013
.aDdR  WeirdDone_0013
.bYtE   <WeirdStart_0013 , >WeirdStart_0013

   ; Weird Formatting Module 0014 - All Of This Should Normalize Cleanly   

     .OrG       $9e00       
 .CoNsT      pPuCtRl_0014     =      $2000    
.cOnSt    ZeRoPaGe_0014=     $00f0

  WeirdStart_0014:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0014      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0014:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0014
	JsR       WeirdSub_0014
	JmP         WeirdDone_0014

WeirdSub_0014:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0014:
	NoP
	RtS

 WeirdTable_0014:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0014   ,   WeirdSub_0014
.aDdR  WeirdDone_0014
.bYtE   <WeirdStart_0014 , >WeirdStart_0014

   ; Weird Formatting Module 0015 - All Of This Should Normalize Cleanly   

     .OrG       $9f00       
 .CoNsT      pPuCtRl_0015     =      $2000    
.cOnSt    ZeRoPaGe_0015=     $00f0

  WeirdStart_0015:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0015      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0015:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0015
	JsR       WeirdSub_0015
	JmP         WeirdDone_0015

WeirdSub_0015:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0015:
	NoP
	RtS

 WeirdTable_0015:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0015   ,   WeirdSub_0015
.aDdR  WeirdDone_0015
.bYtE   <WeirdStart_0015 , >WeirdStart_0015

   ; Weird Formatting Module 0016 - All Of This Should Normalize Cleanly   

     .OrG       $a000       
 .CoNsT      pPuCtRl_0016     =      $2000    
.cOnSt    ZeRoPaGe_0016=     $00f0

  WeirdStart_0016:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0016      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0016:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0016
	JsR       WeirdSub_0016
	JmP         WeirdDone_0016

WeirdSub_0016:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0016:
	NoP
	RtS

 WeirdTable_0016:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0016   ,   WeirdSub_0016
.aDdR  WeirdDone_0016
.bYtE   <WeirdStart_0016 , >WeirdStart_0016

   ; Weird Formatting Module 0017 - All Of This Should Normalize Cleanly   

     .OrG       $a100       
 .CoNsT      pPuCtRl_0017     =      $2000    
.cOnSt    ZeRoPaGe_0017=     $00f0

  WeirdStart_0017:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0017      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0017:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0017
	JsR       WeirdSub_0017
	JmP         WeirdDone_0017

WeirdSub_0017:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0017:
	NoP
	RtS

 WeirdTable_0017:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0017   ,   WeirdSub_0017
.aDdR  WeirdDone_0017
.bYtE   <WeirdStart_0017 , >WeirdStart_0017

   ; Weird Formatting Module 0018 - All Of This Should Normalize Cleanly   

     .OrG       $a200       
 .CoNsT      pPuCtRl_0018     =      $2000    
.cOnSt    ZeRoPaGe_0018=     $00f0

  WeirdStart_0018:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0018      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0018:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0018
	JsR       WeirdSub_0018
	JmP         WeirdDone_0018

WeirdSub_0018:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0018:
	NoP
	RtS

 WeirdTable_0018:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0018   ,   WeirdSub_0018
.aDdR  WeirdDone_0018
.bYtE   <WeirdStart_0018 , >WeirdStart_0018

   ; Weird Formatting Module 0019 - All Of This Should Normalize Cleanly   

     .OrG       $a300       
 .CoNsT      pPuCtRl_0019     =      $2000    
.cOnSt    ZeRoPaGe_0019=     $00f0

  WeirdStart_0019:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0019      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0019:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0019
	JsR       WeirdSub_0019
	JmP         WeirdDone_0019

WeirdSub_0019:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0019:
	NoP
	RtS

 WeirdTable_0019:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0019   ,   WeirdSub_0019
.aDdR  WeirdDone_0019
.bYtE   <WeirdStart_0019 , >WeirdStart_0019

   ; Weird Formatting Module 0020 - All Of This Should Normalize Cleanly   

     .OrG       $a400       
 .CoNsT      pPuCtRl_0020     =      $2000    
.cOnSt    ZeRoPaGe_0020=     $00f0

  WeirdStart_0020:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0020      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0020:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0020
	JsR       WeirdSub_0020
	JmP         WeirdDone_0020

WeirdSub_0020:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0020:
	NoP
	RtS

 WeirdTable_0020:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0020   ,   WeirdSub_0020
.aDdR  WeirdDone_0020
.bYtE   <WeirdStart_0020 , >WeirdStart_0020

   ; Weird Formatting Module 0021 - All Of This Should Normalize Cleanly   

     .OrG       $a500       
 .CoNsT      pPuCtRl_0021     =      $2000    
.cOnSt    ZeRoPaGe_0021=     $00f0

  WeirdStart_0021:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0021      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0021:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0021
	JsR       WeirdSub_0021
	JmP         WeirdDone_0021

WeirdSub_0021:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0021:
	NoP
	RtS

 WeirdTable_0021:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0021   ,   WeirdSub_0021
.aDdR  WeirdDone_0021
.bYtE   <WeirdStart_0021 , >WeirdStart_0021

   ; Weird Formatting Module 0022 - All Of This Should Normalize Cleanly   

     .OrG       $a600       
 .CoNsT      pPuCtRl_0022     =      $2000    
.cOnSt    ZeRoPaGe_0022=     $00f0

  WeirdStart_0022:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0022      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0022:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0022
	JsR       WeirdSub_0022
	JmP         WeirdDone_0022

WeirdSub_0022:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0022:
	NoP
	RtS

 WeirdTable_0022:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0022   ,   WeirdSub_0022
.aDdR  WeirdDone_0022
.bYtE   <WeirdStart_0022 , >WeirdStart_0022

   ; Weird Formatting Module 0023 - All Of This Should Normalize Cleanly   

     .OrG       $a700       
 .CoNsT      pPuCtRl_0023     =      $2000    
.cOnSt    ZeRoPaGe_0023=     $00f0

  WeirdStart_0023:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0023      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0023:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0023
	JsR       WeirdSub_0023
	JmP         WeirdDone_0023

WeirdSub_0023:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0023:
	NoP
	RtS

 WeirdTable_0023:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0023   ,   WeirdSub_0023
.aDdR  WeirdDone_0023
.bYtE   <WeirdStart_0023 , >WeirdStart_0023

   ; Weird Formatting Module 0024 - All Of This Should Normalize Cleanly   

     .OrG       $a800       
 .CoNsT      pPuCtRl_0024     =      $2000    
.cOnSt    ZeRoPaGe_0024=     $00f0

  WeirdStart_0024:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0024      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0024:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0024
	JsR       WeirdSub_0024
	JmP         WeirdDone_0024

WeirdSub_0024:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0024:
	NoP
	RtS

 WeirdTable_0024:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0024   ,   WeirdSub_0024
.aDdR  WeirdDone_0024
.bYtE   <WeirdStart_0024 , >WeirdStart_0024

   ; Weird Formatting Module 0025 - All Of This Should Normalize Cleanly   

     .OrG       $a900       
 .CoNsT      pPuCtRl_0025     =      $2000    
.cOnSt    ZeRoPaGe_0025=     $00f0

  WeirdStart_0025:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0025      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0025:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0025
	JsR       WeirdSub_0025
	JmP         WeirdDone_0025

WeirdSub_0025:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0025:
	NoP
	RtS

 WeirdTable_0025:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0025   ,   WeirdSub_0025
.aDdR  WeirdDone_0025
.bYtE   <WeirdStart_0025 , >WeirdStart_0025

   ; Weird Formatting Module 0026 - All Of This Should Normalize Cleanly   

     .OrG       $aa00       
 .CoNsT      pPuCtRl_0026     =      $2000    
.cOnSt    ZeRoPaGe_0026=     $00f0

  WeirdStart_0026:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0026      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0026:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0026
	JsR       WeirdSub_0026
	JmP         WeirdDone_0026

WeirdSub_0026:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0026:
	NoP
	RtS

 WeirdTable_0026:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0026   ,   WeirdSub_0026
.aDdR  WeirdDone_0026
.bYtE   <WeirdStart_0026 , >WeirdStart_0026

   ; Weird Formatting Module 0027 - All Of This Should Normalize Cleanly   

     .OrG       $ab00       
 .CoNsT      pPuCtRl_0027     =      $2000    
.cOnSt    ZeRoPaGe_0027=     $00f0

  WeirdStart_0027:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0027      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0027:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0027
	JsR       WeirdSub_0027
	JmP         WeirdDone_0027

WeirdSub_0027:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0027:
	NoP
	RtS

 WeirdTable_0027:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0027   ,   WeirdSub_0027
.aDdR  WeirdDone_0027
.bYtE   <WeirdStart_0027 , >WeirdStart_0027

   ; Weird Formatting Module 0028 - All Of This Should Normalize Cleanly   

     .OrG       $ac00       
 .CoNsT      pPuCtRl_0028     =      $2000    
.cOnSt    ZeRoPaGe_0028=     $00f0

  WeirdStart_0028:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0028      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0028:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0028
	JsR       WeirdSub_0028
	JmP         WeirdDone_0028

WeirdSub_0028:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0028:
	NoP
	RtS

 WeirdTable_0028:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0028   ,   WeirdSub_0028
.aDdR  WeirdDone_0028
.bYtE   <WeirdStart_0028 , >WeirdStart_0028

   ; Weird Formatting Module 0029 - All Of This Should Normalize Cleanly   

     .OrG       $ad00       
 .CoNsT      pPuCtRl_0029     =      $2000    
.cOnSt    ZeRoPaGe_0029=     $00f0

  WeirdStart_0029:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0029      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0029:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0029
	JsR       WeirdSub_0029
	JmP         WeirdDone_0029

WeirdSub_0029:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0029:
	NoP
	RtS

 WeirdTable_0029:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0029   ,   WeirdSub_0029
.aDdR  WeirdDone_0029
.bYtE   <WeirdStart_0029 , >WeirdStart_0029

   ; Weird Formatting Module 0030 - All Of This Should Normalize Cleanly   

     .OrG       $ae00       
 .CoNsT      pPuCtRl_0030     =      $2000    
.cOnSt    ZeRoPaGe_0030=     $00f0

  WeirdStart_0030:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0030      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0030:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0030
	JsR       WeirdSub_0030
	JmP         WeirdDone_0030

WeirdSub_0030:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0030:
	NoP
	RtS

 WeirdTable_0030:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0030   ,   WeirdSub_0030
.aDdR  WeirdDone_0030
.bYtE   <WeirdStart_0030 , >WeirdStart_0030

   ; Weird Formatting Module 0031 - All Of This Should Normalize Cleanly   

     .OrG       $af00       
 .CoNsT      pPuCtRl_0031     =      $2000    
.cOnSt    ZeRoPaGe_0031=     $00f0

  WeirdStart_0031:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0031      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0031:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0031
	JsR       WeirdSub_0031
	JmP         WeirdDone_0031

WeirdSub_0031:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0031:
	NoP
	RtS

 WeirdTable_0031:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0031   ,   WeirdSub_0031
.aDdR  WeirdDone_0031
.bYtE   <WeirdStart_0031 , >WeirdStart_0031

   ; Weird Formatting Module 0032 - All Of This Should Normalize Cleanly   

     .OrG       $b000       
 .CoNsT      pPuCtRl_0032     =      $2000    
.cOnSt    ZeRoPaGe_0032=     $00f0

  WeirdStart_0032:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0032      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0032:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0032
	JsR       WeirdSub_0032
	JmP         WeirdDone_0032

WeirdSub_0032:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0032:
	NoP
	RtS

 WeirdTable_0032:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0032   ,   WeirdSub_0032
.aDdR  WeirdDone_0032
.bYtE   <WeirdStart_0032 , >WeirdStart_0032

   ; Weird Formatting Module 0033 - All Of This Should Normalize Cleanly   

     .OrG       $b100       
 .CoNsT      pPuCtRl_0033     =      $2000    
.cOnSt    ZeRoPaGe_0033=     $00f0

  WeirdStart_0033:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0033      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0033:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0033
	JsR       WeirdSub_0033
	JmP         WeirdDone_0033

WeirdSub_0033:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0033:
	NoP
	RtS

 WeirdTable_0033:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0033   ,   WeirdSub_0033
.aDdR  WeirdDone_0033
.bYtE   <WeirdStart_0033 , >WeirdStart_0033

   ; Weird Formatting Module 0034 - All Of This Should Normalize Cleanly   

     .OrG       $b200       
 .CoNsT      pPuCtRl_0034     =      $2000    
.cOnSt    ZeRoPaGe_0034=     $00f0

  WeirdStart_0034:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0034      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0034:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0034
	JsR       WeirdSub_0034
	JmP         WeirdDone_0034

WeirdSub_0034:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0034:
	NoP
	RtS

 WeirdTable_0034:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0034   ,   WeirdSub_0034
.aDdR  WeirdDone_0034
.bYtE   <WeirdStart_0034 , >WeirdStart_0034

   ; Weird Formatting Module 0035 - All Of This Should Normalize Cleanly   

     .OrG       $b300       
 .CoNsT      pPuCtRl_0035     =      $2000    
.cOnSt    ZeRoPaGe_0035=     $00f0

  WeirdStart_0035:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0035      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0035:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0035
	JsR       WeirdSub_0035
	JmP         WeirdDone_0035

WeirdSub_0035:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0035:
	NoP
	RtS

 WeirdTable_0035:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0035   ,   WeirdSub_0035
.aDdR  WeirdDone_0035
.bYtE   <WeirdStart_0035 , >WeirdStart_0035

   ; Weird Formatting Module 0036 - All Of This Should Normalize Cleanly   

     .OrG       $b400       
 .CoNsT      pPuCtRl_0036     =      $2000    
.cOnSt    ZeRoPaGe_0036=     $00f0

  WeirdStart_0036:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0036      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0036:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0036
	JsR       WeirdSub_0036
	JmP         WeirdDone_0036

WeirdSub_0036:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0036:
	NoP
	RtS

 WeirdTable_0036:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0036   ,   WeirdSub_0036
.aDdR  WeirdDone_0036
.bYtE   <WeirdStart_0036 , >WeirdStart_0036

   ; Weird Formatting Module 0037 - All Of This Should Normalize Cleanly   

     .OrG       $b500       
 .CoNsT      pPuCtRl_0037     =      $2000    
.cOnSt    ZeRoPaGe_0037=     $00f0

  WeirdStart_0037:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0037      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0037:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0037
	JsR       WeirdSub_0037
	JmP         WeirdDone_0037

WeirdSub_0037:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0037:
	NoP
	RtS

 WeirdTable_0037:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0037   ,   WeirdSub_0037
.aDdR  WeirdDone_0037
.bYtE   <WeirdStart_0037 , >WeirdStart_0037

   ; Weird Formatting Module 0038 - All Of This Should Normalize Cleanly   

     .OrG       $b600       
 .CoNsT      pPuCtRl_0038     =      $2000    
.cOnSt    ZeRoPaGe_0038=     $00f0

  WeirdStart_0038:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0038      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0038:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0038
	JsR       WeirdSub_0038
	JmP         WeirdDone_0038

WeirdSub_0038:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0038:
	NoP
	RtS

 WeirdTable_0038:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0038   ,   WeirdSub_0038
.aDdR  WeirdDone_0038
.bYtE   <WeirdStart_0038 , >WeirdStart_0038

   ; Weird Formatting Module 0039 - All Of This Should Normalize Cleanly   

     .OrG       $b700       
 .CoNsT      pPuCtRl_0039     =      $2000    
.cOnSt    ZeRoPaGe_0039=     $00f0

  WeirdStart_0039:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0039      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0039:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0039
	JsR       WeirdSub_0039
	JmP         WeirdDone_0039

WeirdSub_0039:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0039:
	NoP
	RtS

 WeirdTable_0039:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0039   ,   WeirdSub_0039
.aDdR  WeirdDone_0039
.bYtE   <WeirdStart_0039 , >WeirdStart_0039

   ; Weird Formatting Module 0040 - All Of This Should Normalize Cleanly   

     .OrG       $b800       
 .CoNsT      pPuCtRl_0040     =      $2000    
.cOnSt    ZeRoPaGe_0040=     $00f0

  WeirdStart_0040:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0040      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0040:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0040
	JsR       WeirdSub_0040
	JmP         WeirdDone_0040

WeirdSub_0040:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0040:
	NoP
	RtS

 WeirdTable_0040:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0040   ,   WeirdSub_0040
.aDdR  WeirdDone_0040
.bYtE   <WeirdStart_0040 , >WeirdStart_0040

   ; Weird Formatting Module 0041 - All Of This Should Normalize Cleanly   

     .OrG       $b900       
 .CoNsT      pPuCtRl_0041     =      $2000    
.cOnSt    ZeRoPaGe_0041=     $00f0

  WeirdStart_0041:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0041      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0041:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0041
	JsR       WeirdSub_0041
	JmP         WeirdDone_0041

WeirdSub_0041:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0041:
	NoP
	RtS

 WeirdTable_0041:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0041   ,   WeirdSub_0041
.aDdR  WeirdDone_0041
.bYtE   <WeirdStart_0041 , >WeirdStart_0041

   ; Weird Formatting Module 0042 - All Of This Should Normalize Cleanly   

     .OrG       $ba00       
 .CoNsT      pPuCtRl_0042     =      $2000    
.cOnSt    ZeRoPaGe_0042=     $00f0

  WeirdStart_0042:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0042      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0042:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0042
	JsR       WeirdSub_0042
	JmP         WeirdDone_0042

WeirdSub_0042:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0042:
	NoP
	RtS

 WeirdTable_0042:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0042   ,   WeirdSub_0042
.aDdR  WeirdDone_0042
.bYtE   <WeirdStart_0042 , >WeirdStart_0042

   ; Weird Formatting Module 0043 - All Of This Should Normalize Cleanly   

     .OrG       $bb00       
 .CoNsT      pPuCtRl_0043     =      $2000    
.cOnSt    ZeRoPaGe_0043=     $00f0

  WeirdStart_0043:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0043      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0043:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0043
	JsR       WeirdSub_0043
	JmP         WeirdDone_0043

WeirdSub_0043:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0043:
	NoP
	RtS

 WeirdTable_0043:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0043   ,   WeirdSub_0043
.aDdR  WeirdDone_0043
.bYtE   <WeirdStart_0043 , >WeirdStart_0043

   ; Weird Formatting Module 0044 - All Of This Should Normalize Cleanly   

     .OrG       $bc00       
 .CoNsT      pPuCtRl_0044     =      $2000    
.cOnSt    ZeRoPaGe_0044=     $00f0

  WeirdStart_0044:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0044      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0044:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0044
	JsR       WeirdSub_0044
	JmP         WeirdDone_0044

WeirdSub_0044:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0044:
	NoP
	RtS

 WeirdTable_0044:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0044   ,   WeirdSub_0044
.aDdR  WeirdDone_0044
.bYtE   <WeirdStart_0044 , >WeirdStart_0044

   ; Weird Formatting Module 0045 - All Of This Should Normalize Cleanly   

     .OrG       $bd00       
 .CoNsT      pPuCtRl_0045     =      $2000    
.cOnSt    ZeRoPaGe_0045=     $00f0

  WeirdStart_0045:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0045      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0045:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0045
	JsR       WeirdSub_0045
	JmP         WeirdDone_0045

WeirdSub_0045:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0045:
	NoP
	RtS

 WeirdTable_0045:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0045   ,   WeirdSub_0045
.aDdR  WeirdDone_0045
.bYtE   <WeirdStart_0045 , >WeirdStart_0045

   ; Weird Formatting Module 0046 - All Of This Should Normalize Cleanly   

     .OrG       $be00       
 .CoNsT      pPuCtRl_0046     =      $2000    
.cOnSt    ZeRoPaGe_0046=     $00f0

  WeirdStart_0046:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0046      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0046:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0046
	JsR       WeirdSub_0046
	JmP         WeirdDone_0046

WeirdSub_0046:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0046:
	NoP
	RtS

 WeirdTable_0046:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0046   ,   WeirdSub_0046
.aDdR  WeirdDone_0046
.bYtE   <WeirdStart_0046 , >WeirdStart_0046

   ; Weird Formatting Module 0047 - All Of This Should Normalize Cleanly   

     .OrG       $bf00       
 .CoNsT      pPuCtRl_0047     =      $2000    
.cOnSt    ZeRoPaGe_0047=     $00f0

  WeirdStart_0047:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0047      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0047:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0047
	JsR       WeirdSub_0047
	JmP         WeirdDone_0047

WeirdSub_0047:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0047:
	NoP
	RtS

 WeirdTable_0047:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0047   ,   WeirdSub_0047
.aDdR  WeirdDone_0047
.bYtE   <WeirdStart_0047 , >WeirdStart_0047

   ; Weird Formatting Module 0048 - All Of This Should Normalize Cleanly   

     .OrG       $c000       
 .CoNsT      pPuCtRl_0048     =      $2000    
.cOnSt    ZeRoPaGe_0048=     $00f0

  WeirdStart_0048:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0048      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0048:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0048
	JsR       WeirdSub_0048
	JmP         WeirdDone_0048

WeirdSub_0048:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0048:
	NoP
	RtS

 WeirdTable_0048:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0048   ,   WeirdSub_0048
.aDdR  WeirdDone_0048
.bYtE   <WeirdStart_0048 , >WeirdStart_0048

   ; Weird Formatting Module 0049 - All Of This Should Normalize Cleanly   

     .OrG       $c100       
 .CoNsT      pPuCtRl_0049     =      $2000    
.cOnSt    ZeRoPaGe_0049=     $00f0

  WeirdStart_0049:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0049      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0049:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0049
	JsR       WeirdSub_0049
	JmP         WeirdDone_0049

WeirdSub_0049:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0049:
	NoP
	RtS

 WeirdTable_0049:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0049   ,   WeirdSub_0049
.aDdR  WeirdDone_0049
.bYtE   <WeirdStart_0049 , >WeirdStart_0049

   ; Weird Formatting Module 0050 - All Of This Should Normalize Cleanly   

     .OrG       $c200       
 .CoNsT      pPuCtRl_0050     =      $2000    
.cOnSt    ZeRoPaGe_0050=     $00f0

  WeirdStart_0050:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0050      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0050:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0050
	JsR       WeirdSub_0050
	JmP         WeirdDone_0050

WeirdSub_0050:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0050:
	NoP
	RtS

 WeirdTable_0050:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0050   ,   WeirdSub_0050
.aDdR  WeirdDone_0050
.bYtE   <WeirdStart_0050 , >WeirdStart_0050

   ; Weird Formatting Module 0051 - All Of This Should Normalize Cleanly   

     .OrG       $c300       
 .CoNsT      pPuCtRl_0051     =      $2000    
.cOnSt    ZeRoPaGe_0051=     $00f0

  WeirdStart_0051:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0051      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0051:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0051
	JsR       WeirdSub_0051
	JmP         WeirdDone_0051

WeirdSub_0051:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0051:
	NoP
	RtS

 WeirdTable_0051:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0051   ,   WeirdSub_0051
.aDdR  WeirdDone_0051
.bYtE   <WeirdStart_0051 , >WeirdStart_0051

   ; Weird Formatting Module 0052 - All Of This Should Normalize Cleanly   

     .OrG       $c400       
 .CoNsT      pPuCtRl_0052     =      $2000    
.cOnSt    ZeRoPaGe_0052=     $00f0

  WeirdStart_0052:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0052      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0052:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0052
	JsR       WeirdSub_0052
	JmP         WeirdDone_0052

WeirdSub_0052:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0052:
	NoP
	RtS

 WeirdTable_0052:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0052   ,   WeirdSub_0052
.aDdR  WeirdDone_0052
.bYtE   <WeirdStart_0052 , >WeirdStart_0052

   ; Weird Formatting Module 0053 - All Of This Should Normalize Cleanly   

     .OrG       $c500       
 .CoNsT      pPuCtRl_0053     =      $2000    
.cOnSt    ZeRoPaGe_0053=     $00f0

  WeirdStart_0053:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0053      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0053:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0053
	JsR       WeirdSub_0053
	JmP         WeirdDone_0053

WeirdSub_0053:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0053:
	NoP
	RtS

 WeirdTable_0053:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0053   ,   WeirdSub_0053
.aDdR  WeirdDone_0053
.bYtE   <WeirdStart_0053 , >WeirdStart_0053

   ; Weird Formatting Module 0054 - All Of This Should Normalize Cleanly   

     .OrG       $c600       
 .CoNsT      pPuCtRl_0054     =      $2000    
.cOnSt    ZeRoPaGe_0054=     $00f0

  WeirdStart_0054:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0054      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0054:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0054
	JsR       WeirdSub_0054
	JmP         WeirdDone_0054

WeirdSub_0054:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0054:
	NoP
	RtS

 WeirdTable_0054:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0054   ,   WeirdSub_0054
.aDdR  WeirdDone_0054
.bYtE   <WeirdStart_0054 , >WeirdStart_0054

   ; Weird Formatting Module 0055 - All Of This Should Normalize Cleanly   

     .OrG       $c700       
 .CoNsT      pPuCtRl_0055     =      $2000    
.cOnSt    ZeRoPaGe_0055=     $00f0

  WeirdStart_0055:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0055      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0055:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0055
	JsR       WeirdSub_0055
	JmP         WeirdDone_0055

WeirdSub_0055:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0055:
	NoP
	RtS

 WeirdTable_0055:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0055   ,   WeirdSub_0055
.aDdR  WeirdDone_0055
.bYtE   <WeirdStart_0055 , >WeirdStart_0055

   ; Weird Formatting Module 0056 - All Of This Should Normalize Cleanly   

     .OrG       $c800       
 .CoNsT      pPuCtRl_0056     =      $2000    
.cOnSt    ZeRoPaGe_0056=     $00f0

  WeirdStart_0056:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0056      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0056:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0056
	JsR       WeirdSub_0056
	JmP         WeirdDone_0056

WeirdSub_0056:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0056:
	NoP
	RtS

 WeirdTable_0056:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0056   ,   WeirdSub_0056
.aDdR  WeirdDone_0056
.bYtE   <WeirdStart_0056 , >WeirdStart_0056

   ; Weird Formatting Module 0057 - All Of This Should Normalize Cleanly   

     .OrG       $c900       
 .CoNsT      pPuCtRl_0057     =      $2000    
.cOnSt    ZeRoPaGe_0057=     $00f0

  WeirdStart_0057:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0057      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0057:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0057
	JsR       WeirdSub_0057
	JmP         WeirdDone_0057

WeirdSub_0057:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0057:
	NoP
	RtS

 WeirdTable_0057:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0057   ,   WeirdSub_0057
.aDdR  WeirdDone_0057
.bYtE   <WeirdStart_0057 , >WeirdStart_0057

   ; Weird Formatting Module 0058 - All Of This Should Normalize Cleanly   

     .OrG       $ca00       
 .CoNsT      pPuCtRl_0058     =      $2000    
.cOnSt    ZeRoPaGe_0058=     $00f0

  WeirdStart_0058:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0058      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0058:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0058
	JsR       WeirdSub_0058
	JmP         WeirdDone_0058

WeirdSub_0058:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0058:
	NoP
	RtS

 WeirdTable_0058:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0058   ,   WeirdSub_0058
.aDdR  WeirdDone_0058
.bYtE   <WeirdStart_0058 , >WeirdStart_0058

   ; Weird Formatting Module 0059 - All Of This Should Normalize Cleanly   

     .OrG       $cb00       
 .CoNsT      pPuCtRl_0059     =      $2000    
.cOnSt    ZeRoPaGe_0059=     $00f0

  WeirdStart_0059:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0059      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0059:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0059
	JsR       WeirdSub_0059
	JmP         WeirdDone_0059

WeirdSub_0059:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0059:
	NoP
	RtS

 WeirdTable_0059:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0059   ,   WeirdSub_0059
.aDdR  WeirdDone_0059
.bYtE   <WeirdStart_0059 , >WeirdStart_0059

   ; Weird Formatting Module 0060 - All Of This Should Normalize Cleanly   

     .OrG       $cc00       
 .CoNsT      pPuCtRl_0060     =      $2000    
.cOnSt    ZeRoPaGe_0060=     $00f0

  WeirdStart_0060:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0060      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0060:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0060
	JsR       WeirdSub_0060
	JmP         WeirdDone_0060

WeirdSub_0060:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0060:
	NoP
	RtS

 WeirdTable_0060:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0060   ,   WeirdSub_0060
.aDdR  WeirdDone_0060
.bYtE   <WeirdStart_0060 , >WeirdStart_0060

   ; Weird Formatting Module 0061 - All Of This Should Normalize Cleanly   

     .OrG       $cd00       
 .CoNsT      pPuCtRl_0061     =      $2000    
.cOnSt    ZeRoPaGe_0061=     $00f0

  WeirdStart_0061:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0061      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0061:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0061
	JsR       WeirdSub_0061
	JmP         WeirdDone_0061

WeirdSub_0061:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0061:
	NoP
	RtS

 WeirdTable_0061:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0061   ,   WeirdSub_0061
.aDdR  WeirdDone_0061
.bYtE   <WeirdStart_0061 , >WeirdStart_0061

   ; Weird Formatting Module 0062 - All Of This Should Normalize Cleanly   

     .OrG       $ce00       
 .CoNsT      pPuCtRl_0062     =      $2000    
.cOnSt    ZeRoPaGe_0062=     $00f0

  WeirdStart_0062:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0062      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0062:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0062
	JsR       WeirdSub_0062
	JmP         WeirdDone_0062

WeirdSub_0062:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0062:
	NoP
	RtS

 WeirdTable_0062:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0062   ,   WeirdSub_0062
.aDdR  WeirdDone_0062
.bYtE   <WeirdStart_0062 , >WeirdStart_0062

   ; Weird Formatting Module 0063 - All Of This Should Normalize Cleanly   

     .OrG       $cf00       
 .CoNsT      pPuCtRl_0063     =      $2000    
.cOnSt    ZeRoPaGe_0063=     $00f0

  WeirdStart_0063:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0063      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0063:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0063
	JsR       WeirdSub_0063
	JmP         WeirdDone_0063

WeirdSub_0063:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0063:
	NoP
	RtS

 WeirdTable_0063:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0063   ,   WeirdSub_0063
.aDdR  WeirdDone_0063
.bYtE   <WeirdStart_0063 , >WeirdStart_0063

   ; Weird Formatting Module 0064 - All Of This Should Normalize Cleanly   

     .OrG       $d000       
 .CoNsT      pPuCtRl_0064     =      $2000    
.cOnSt    ZeRoPaGe_0064=     $00f0

  WeirdStart_0064:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0064      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0064:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0064
	JsR       WeirdSub_0064
	JmP         WeirdDone_0064

WeirdSub_0064:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0064:
	NoP
	RtS

 WeirdTable_0064:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0064   ,   WeirdSub_0064
.aDdR  WeirdDone_0064
.bYtE   <WeirdStart_0064 , >WeirdStart_0064

   ; Weird Formatting Module 0065 - All Of This Should Normalize Cleanly   

     .OrG       $d100       
 .CoNsT      pPuCtRl_0065     =      $2000    
.cOnSt    ZeRoPaGe_0065=     $00f0

  WeirdStart_0065:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0065      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0065:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0065
	JsR       WeirdSub_0065
	JmP         WeirdDone_0065

WeirdSub_0065:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0065:
	NoP
	RtS

 WeirdTable_0065:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0065   ,   WeirdSub_0065
.aDdR  WeirdDone_0065
.bYtE   <WeirdStart_0065 , >WeirdStart_0065

   ; Weird Formatting Module 0066 - All Of This Should Normalize Cleanly   

     .OrG       $d200       
 .CoNsT      pPuCtRl_0066     =      $2000    
.cOnSt    ZeRoPaGe_0066=     $00f0

  WeirdStart_0066:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0066      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0066:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0066
	JsR       WeirdSub_0066
	JmP         WeirdDone_0066

WeirdSub_0066:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0066:
	NoP
	RtS

 WeirdTable_0066:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0066   ,   WeirdSub_0066
.aDdR  WeirdDone_0066
.bYtE   <WeirdStart_0066 , >WeirdStart_0066

   ; Weird Formatting Module 0067 - All Of This Should Normalize Cleanly   

     .OrG       $d300       
 .CoNsT      pPuCtRl_0067     =      $2000    
.cOnSt    ZeRoPaGe_0067=     $00f0

  WeirdStart_0067:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0067      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0067:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0067
	JsR       WeirdSub_0067
	JmP         WeirdDone_0067

WeirdSub_0067:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0067:
	NoP
	RtS

 WeirdTable_0067:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0067   ,   WeirdSub_0067
.aDdR  WeirdDone_0067
.bYtE   <WeirdStart_0067 , >WeirdStart_0067

   ; Weird Formatting Module 0068 - All Of This Should Normalize Cleanly   

     .OrG       $d400       
 .CoNsT      pPuCtRl_0068     =      $2000    
.cOnSt    ZeRoPaGe_0068=     $00f0

  WeirdStart_0068:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0068      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0068:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0068
	JsR       WeirdSub_0068
	JmP         WeirdDone_0068

WeirdSub_0068:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0068:
	NoP
	RtS

 WeirdTable_0068:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0068   ,   WeirdSub_0068
.aDdR  WeirdDone_0068
.bYtE   <WeirdStart_0068 , >WeirdStart_0068

   ; Weird Formatting Module 0069 - All Of This Should Normalize Cleanly   

     .OrG       $d500       
 .CoNsT      pPuCtRl_0069     =      $2000    
.cOnSt    ZeRoPaGe_0069=     $00f0

  WeirdStart_0069:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0069      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0069:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0069
	JsR       WeirdSub_0069
	JmP         WeirdDone_0069

WeirdSub_0069:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0069:
	NoP
	RtS

 WeirdTable_0069:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0069   ,   WeirdSub_0069
.aDdR  WeirdDone_0069
.bYtE   <WeirdStart_0069 , >WeirdStart_0069

   ; Weird Formatting Module 0070 - All Of This Should Normalize Cleanly   

     .OrG       $d600       
 .CoNsT      pPuCtRl_0070     =      $2000    
.cOnSt    ZeRoPaGe_0070=     $00f0

  WeirdStart_0070:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0070      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0070:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0070
	JsR       WeirdSub_0070
	JmP         WeirdDone_0070

WeirdSub_0070:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0070:
	NoP
	RtS

 WeirdTable_0070:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0070   ,   WeirdSub_0070
.aDdR  WeirdDone_0070
.bYtE   <WeirdStart_0070 , >WeirdStart_0070

   ; Weird Formatting Module 0071 - All Of This Should Normalize Cleanly   

     .OrG       $d700       
 .CoNsT      pPuCtRl_0071     =      $2000    
.cOnSt    ZeRoPaGe_0071=     $00f0

  WeirdStart_0071:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0071      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0071:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0071
	JsR       WeirdSub_0071
	JmP         WeirdDone_0071

WeirdSub_0071:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0071:
	NoP
	RtS

 WeirdTable_0071:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0071   ,   WeirdSub_0071
.aDdR  WeirdDone_0071
.bYtE   <WeirdStart_0071 , >WeirdStart_0071

   ; Weird Formatting Module 0072 - All Of This Should Normalize Cleanly   

     .OrG       $d800       
 .CoNsT      pPuCtRl_0072     =      $2000    
.cOnSt    ZeRoPaGe_0072=     $00f0

  WeirdStart_0072:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0072      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0072:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0072
	JsR       WeirdSub_0072
	JmP         WeirdDone_0072

WeirdSub_0072:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0072:
	NoP
	RtS

 WeirdTable_0072:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0072   ,   WeirdSub_0072
.aDdR  WeirdDone_0072
.bYtE   <WeirdStart_0072 , >WeirdStart_0072

   ; Weird Formatting Module 0073 - All Of This Should Normalize Cleanly   

     .OrG       $d900       
 .CoNsT      pPuCtRl_0073     =      $2000    
.cOnSt    ZeRoPaGe_0073=     $00f0

  WeirdStart_0073:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0073      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0073:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0073
	JsR       WeirdSub_0073
	JmP         WeirdDone_0073

WeirdSub_0073:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0073:
	NoP
	RtS

 WeirdTable_0073:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0073   ,   WeirdSub_0073
.aDdR  WeirdDone_0073
.bYtE   <WeirdStart_0073 , >WeirdStart_0073

   ; Weird Formatting Module 0074 - All Of This Should Normalize Cleanly   

     .OrG       $da00       
 .CoNsT      pPuCtRl_0074     =      $2000    
.cOnSt    ZeRoPaGe_0074=     $00f0

  WeirdStart_0074:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0074      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0074:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0074
	JsR       WeirdSub_0074
	JmP         WeirdDone_0074

WeirdSub_0074:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0074:
	NoP
	RtS

 WeirdTable_0074:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0074   ,   WeirdSub_0074
.aDdR  WeirdDone_0074
.bYtE   <WeirdStart_0074 , >WeirdStart_0074

   ; Weird Formatting Module 0075 - All Of This Should Normalize Cleanly   

     .OrG       $db00       
 .CoNsT      pPuCtRl_0075     =      $2000    
.cOnSt    ZeRoPaGe_0075=     $00f0

  WeirdStart_0075:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0075      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0075:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0075
	JsR       WeirdSub_0075
	JmP         WeirdDone_0075

WeirdSub_0075:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0075:
	NoP
	RtS

 WeirdTable_0075:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0075   ,   WeirdSub_0075
.aDdR  WeirdDone_0075
.bYtE   <WeirdStart_0075 , >WeirdStart_0075

   ; Weird Formatting Module 0076 - All Of This Should Normalize Cleanly   

     .OrG       $dc00       
 .CoNsT      pPuCtRl_0076     =      $2000    
.cOnSt    ZeRoPaGe_0076=     $00f0

  WeirdStart_0076:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0076      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0076:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0076
	JsR       WeirdSub_0076
	JmP         WeirdDone_0076

WeirdSub_0076:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0076:
	NoP
	RtS

 WeirdTable_0076:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0076   ,   WeirdSub_0076
.aDdR  WeirdDone_0076
.bYtE   <WeirdStart_0076 , >WeirdStart_0076

   ; Weird Formatting Module 0077 - All Of This Should Normalize Cleanly   

     .OrG       $dd00       
 .CoNsT      pPuCtRl_0077     =      $2000    
.cOnSt    ZeRoPaGe_0077=     $00f0

  WeirdStart_0077:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0077      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0077:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0077
	JsR       WeirdSub_0077
	JmP         WeirdDone_0077

WeirdSub_0077:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0077:
	NoP
	RtS

 WeirdTable_0077:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0077   ,   WeirdSub_0077
.aDdR  WeirdDone_0077
.bYtE   <WeirdStart_0077 , >WeirdStart_0077

   ; Weird Formatting Module 0078 - All Of This Should Normalize Cleanly   

     .OrG       $de00       
 .CoNsT      pPuCtRl_0078     =      $2000    
.cOnSt    ZeRoPaGe_0078=     $00f0

  WeirdStart_0078:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0078      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0078:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0078
	JsR       WeirdSub_0078
	JmP         WeirdDone_0078

WeirdSub_0078:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0078:
	NoP
	RtS

 WeirdTable_0078:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0078   ,   WeirdSub_0078
.aDdR  WeirdDone_0078
.bYtE   <WeirdStart_0078 , >WeirdStart_0078

   ; Weird Formatting Module 0079 - All Of This Should Normalize Cleanly   

     .OrG       $df00       
 .CoNsT      pPuCtRl_0079     =      $2000    
.cOnSt    ZeRoPaGe_0079=     $00f0

  WeirdStart_0079:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0079      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0079:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0079
	JsR       WeirdSub_0079
	JmP         WeirdDone_0079

WeirdSub_0079:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0079:
	NoP
	RtS

 WeirdTable_0079:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0079   ,   WeirdSub_0079
.aDdR  WeirdDone_0079
.bYtE   <WeirdStart_0079 , >WeirdStart_0079

   ; Weird Formatting Module 0080 - All Of This Should Normalize Cleanly   

     .OrG       $9000       
 .CoNsT      pPuCtRl_0080     =      $2000    
.cOnSt    ZeRoPaGe_0080=     $00f0

  WeirdStart_0080:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0080      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0080:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0080
	JsR       WeirdSub_0080
	JmP         WeirdDone_0080

WeirdSub_0080:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0080:
	NoP
	RtS

 WeirdTable_0080:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0080   ,   WeirdSub_0080
.aDdR  WeirdDone_0080
.bYtE   <WeirdStart_0080 , >WeirdStart_0080

   ; Weird Formatting Module 0081 - All Of This Should Normalize Cleanly   

     .OrG       $9100       
 .CoNsT      pPuCtRl_0081     =      $2000    
.cOnSt    ZeRoPaGe_0081=     $00f0

  WeirdStart_0081:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0081      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0081:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0081
	JsR       WeirdSub_0081
	JmP         WeirdDone_0081

WeirdSub_0081:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0081:
	NoP
	RtS

 WeirdTable_0081:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0081   ,   WeirdSub_0081
.aDdR  WeirdDone_0081
.bYtE   <WeirdStart_0081 , >WeirdStart_0081

   ; Weird Formatting Module 0082 - All Of This Should Normalize Cleanly   

     .OrG       $9200       
 .CoNsT      pPuCtRl_0082     =      $2000    
.cOnSt    ZeRoPaGe_0082=     $00f0

  WeirdStart_0082:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0082      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0082:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0082
	JsR       WeirdSub_0082
	JmP         WeirdDone_0082

WeirdSub_0082:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0082:
	NoP
	RtS

 WeirdTable_0082:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0082   ,   WeirdSub_0082
.aDdR  WeirdDone_0082
.bYtE   <WeirdStart_0082 , >WeirdStart_0082

   ; Weird Formatting Module 0083 - All Of This Should Normalize Cleanly   

     .OrG       $9300       
 .CoNsT      pPuCtRl_0083     =      $2000    
.cOnSt    ZeRoPaGe_0083=     $00f0

  WeirdStart_0083:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0083      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0083:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0083
	JsR       WeirdSub_0083
	JmP         WeirdDone_0083

WeirdSub_0083:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0083:
	NoP
	RtS

 WeirdTable_0083:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0083   ,   WeirdSub_0083
.aDdR  WeirdDone_0083
.bYtE   <WeirdStart_0083 , >WeirdStart_0083

   ; Weird Formatting Module 0084 - All Of This Should Normalize Cleanly   

     .OrG       $9400       
 .CoNsT      pPuCtRl_0084     =      $2000    
.cOnSt    ZeRoPaGe_0084=     $00f0

  WeirdStart_0084:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0084      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0084:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0084
	JsR       WeirdSub_0084
	JmP         WeirdDone_0084

WeirdSub_0084:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0084:
	NoP
	RtS

 WeirdTable_0084:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0084   ,   WeirdSub_0084
.aDdR  WeirdDone_0084
.bYtE   <WeirdStart_0084 , >WeirdStart_0084

   ; Weird Formatting Module 0085 - All Of This Should Normalize Cleanly   

     .OrG       $9500       
 .CoNsT      pPuCtRl_0085     =      $2000    
.cOnSt    ZeRoPaGe_0085=     $00f0

  WeirdStart_0085:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0085      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0085:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0085
	JsR       WeirdSub_0085
	JmP         WeirdDone_0085

WeirdSub_0085:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0085:
	NoP
	RtS

 WeirdTable_0085:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0085   ,   WeirdSub_0085
.aDdR  WeirdDone_0085
.bYtE   <WeirdStart_0085 , >WeirdStart_0085

   ; Weird Formatting Module 0086 - All Of This Should Normalize Cleanly   

     .OrG       $9600       
 .CoNsT      pPuCtRl_0086     =      $2000    
.cOnSt    ZeRoPaGe_0086=     $00f0

  WeirdStart_0086:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0086      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0086:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0086
	JsR       WeirdSub_0086
	JmP         WeirdDone_0086

WeirdSub_0086:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0086:
	NoP
	RtS

 WeirdTable_0086:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0086   ,   WeirdSub_0086
.aDdR  WeirdDone_0086
.bYtE   <WeirdStart_0086 , >WeirdStart_0086

   ; Weird Formatting Module 0087 - All Of This Should Normalize Cleanly   

     .OrG       $9700       
 .CoNsT      pPuCtRl_0087     =      $2000    
.cOnSt    ZeRoPaGe_0087=     $00f0

  WeirdStart_0087:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0087      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0087:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0087
	JsR       WeirdSub_0087
	JmP         WeirdDone_0087

WeirdSub_0087:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0087:
	NoP
	RtS

 WeirdTable_0087:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0087   ,   WeirdSub_0087
.aDdR  WeirdDone_0087
.bYtE   <WeirdStart_0087 , >WeirdStart_0087

   ; Weird Formatting Module 0088 - All Of This Should Normalize Cleanly   

     .OrG       $9800       
 .CoNsT      pPuCtRl_0088     =      $2000    
.cOnSt    ZeRoPaGe_0088=     $00f0

  WeirdStart_0088:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0088      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0088:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0088
	JsR       WeirdSub_0088
	JmP         WeirdDone_0088

WeirdSub_0088:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0088:
	NoP
	RtS

 WeirdTable_0088:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0088   ,   WeirdSub_0088
.aDdR  WeirdDone_0088
.bYtE   <WeirdStart_0088 , >WeirdStart_0088

   ; Weird Formatting Module 0089 - All Of This Should Normalize Cleanly   

     .OrG       $9900       
 .CoNsT      pPuCtRl_0089     =      $2000    
.cOnSt    ZeRoPaGe_0089=     $00f0

  WeirdStart_0089:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0089      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0089:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0089
	JsR       WeirdSub_0089
	JmP         WeirdDone_0089

WeirdSub_0089:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0089:
	NoP
	RtS

 WeirdTable_0089:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0089   ,   WeirdSub_0089
.aDdR  WeirdDone_0089
.bYtE   <WeirdStart_0089 , >WeirdStart_0089

   ; Weird Formatting Module 0090 - All Of This Should Normalize Cleanly   

     .OrG       $9a00       
 .CoNsT      pPuCtRl_0090     =      $2000    
.cOnSt    ZeRoPaGe_0090=     $00f0

  WeirdStart_0090:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0090      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0090:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0090
	JsR       WeirdSub_0090
	JmP         WeirdDone_0090

WeirdSub_0090:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0090:
	NoP
	RtS

 WeirdTable_0090:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0090   ,   WeirdSub_0090
.aDdR  WeirdDone_0090
.bYtE   <WeirdStart_0090 , >WeirdStart_0090

   ; Weird Formatting Module 0091 - All Of This Should Normalize Cleanly   

     .OrG       $9b00       
 .CoNsT      pPuCtRl_0091     =      $2000    
.cOnSt    ZeRoPaGe_0091=     $00f0

  WeirdStart_0091:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0091      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0091:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0091
	JsR       WeirdSub_0091
	JmP         WeirdDone_0091

WeirdSub_0091:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0091:
	NoP
	RtS

 WeirdTable_0091:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0091   ,   WeirdSub_0091
.aDdR  WeirdDone_0091
.bYtE   <WeirdStart_0091 , >WeirdStart_0091

   ; Weird Formatting Module 0092 - All Of This Should Normalize Cleanly   

     .OrG       $9c00       
 .CoNsT      pPuCtRl_0092     =      $2000    
.cOnSt    ZeRoPaGe_0092=     $00f0

  WeirdStart_0092:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0092      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0092:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0092
	JsR       WeirdSub_0092
	JmP         WeirdDone_0092

WeirdSub_0092:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0092:
	NoP
	RtS

 WeirdTable_0092:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0092   ,   WeirdSub_0092
.aDdR  WeirdDone_0092
.bYtE   <WeirdStart_0092 , >WeirdStart_0092

   ; Weird Formatting Module 0093 - All Of This Should Normalize Cleanly   

     .OrG       $9d00       
 .CoNsT      pPuCtRl_0093     =      $2000    
.cOnSt    ZeRoPaGe_0093=     $00f0

  WeirdStart_0093:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0093      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0093:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0093
	JsR       WeirdSub_0093
	JmP         WeirdDone_0093

WeirdSub_0093:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0093:
	NoP
	RtS

 WeirdTable_0093:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0093   ,   WeirdSub_0093
.aDdR  WeirdDone_0093
.bYtE   <WeirdStart_0093 , >WeirdStart_0093

   ; Weird Formatting Module 0094 - All Of This Should Normalize Cleanly   

     .OrG       $9e00       
 .CoNsT      pPuCtRl_0094     =      $2000    
.cOnSt    ZeRoPaGe_0094=     $00f0

  WeirdStart_0094:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0094      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0094:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0094
	JsR       WeirdSub_0094
	JmP         WeirdDone_0094

WeirdSub_0094:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0094:
	NoP
	RtS

 WeirdTable_0094:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0094   ,   WeirdSub_0094
.aDdR  WeirdDone_0094
.bYtE   <WeirdStart_0094 , >WeirdStart_0094

   ; Weird Formatting Module 0095 - All Of This Should Normalize Cleanly   

     .OrG       $9f00       
 .CoNsT      pPuCtRl_0095     =      $2000    
.cOnSt    ZeRoPaGe_0095=     $00f0

  WeirdStart_0095:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0095      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0095:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0095
	JsR       WeirdSub_0095
	JmP         WeirdDone_0095

WeirdSub_0095:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0095:
	NoP
	RtS

 WeirdTable_0095:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0095   ,   WeirdSub_0095
.aDdR  WeirdDone_0095
.bYtE   <WeirdStart_0095 , >WeirdStart_0095

   ; Weird Formatting Module 0096 - All Of This Should Normalize Cleanly   

     .OrG       $a000       
 .CoNsT      pPuCtRl_0096     =      $2000    
.cOnSt    ZeRoPaGe_0096=     $00f0

  WeirdStart_0096:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0096      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0096:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0096
	JsR       WeirdSub_0096
	JmP         WeirdDone_0096

WeirdSub_0096:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0096:
	NoP
	RtS

 WeirdTable_0096:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0096   ,   WeirdSub_0096
.aDdR  WeirdDone_0096
.bYtE   <WeirdStart_0096 , >WeirdStart_0096

   ; Weird Formatting Module 0097 - All Of This Should Normalize Cleanly   

     .OrG       $a100       
 .CoNsT      pPuCtRl_0097     =      $2000    
.cOnSt    ZeRoPaGe_0097=     $00f0

  WeirdStart_0097:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0097      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0097:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0097
	JsR       WeirdSub_0097
	JmP         WeirdDone_0097

WeirdSub_0097:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0097:
	NoP
	RtS

 WeirdTable_0097:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0097   ,   WeirdSub_0097
.aDdR  WeirdDone_0097
.bYtE   <WeirdStart_0097 , >WeirdStart_0097

   ; Weird Formatting Module 0098 - All Of This Should Normalize Cleanly   

     .OrG       $a200       
 .CoNsT      pPuCtRl_0098     =      $2000    
.cOnSt    ZeRoPaGe_0098=     $00f0

  WeirdStart_0098:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0098      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0098:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0098
	JsR       WeirdSub_0098
	JmP         WeirdDone_0098

WeirdSub_0098:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0098:
	NoP
	RtS

 WeirdTable_0098:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0098   ,   WeirdSub_0098
.aDdR  WeirdDone_0098
.bYtE   <WeirdStart_0098 , >WeirdStart_0098

   ; Weird Formatting Module 0099 - All Of This Should Normalize Cleanly   

     .OrG       $a300       
 .CoNsT      pPuCtRl_0099     =      $2000    
.cOnSt    ZeRoPaGe_0099=     $00f0

  WeirdStart_0099:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0099      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0099:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0099
	JsR       WeirdSub_0099
	JmP         WeirdDone_0099

WeirdSub_0099:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0099:
	NoP
	RtS

 WeirdTable_0099:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0099   ,   WeirdSub_0099
.aDdR  WeirdDone_0099
.bYtE   <WeirdStart_0099 , >WeirdStart_0099

   ; Weird Formatting Module 0100 - All Of This Should Normalize Cleanly   

     .OrG       $a400       
 .CoNsT      pPuCtRl_0100     =      $2000    
.cOnSt    ZeRoPaGe_0100=     $00f0

  WeirdStart_0100:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0100      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0100:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0100
	JsR       WeirdSub_0100
	JmP         WeirdDone_0100

WeirdSub_0100:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0100:
	NoP
	RtS

 WeirdTable_0100:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0100   ,   WeirdSub_0100
.aDdR  WeirdDone_0100
.bYtE   <WeirdStart_0100 , >WeirdStart_0100

   ; Weird Formatting Module 0101 - All Of This Should Normalize Cleanly   

     .OrG       $a500       
 .CoNsT      pPuCtRl_0101     =      $2000    
.cOnSt    ZeRoPaGe_0101=     $00f0

  WeirdStart_0101:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0101      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0101:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0101
	JsR       WeirdSub_0101
	JmP         WeirdDone_0101

WeirdSub_0101:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0101:
	NoP
	RtS

 WeirdTable_0101:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0101   ,   WeirdSub_0101
.aDdR  WeirdDone_0101
.bYtE   <WeirdStart_0101 , >WeirdStart_0101

   ; Weird Formatting Module 0102 - All Of This Should Normalize Cleanly   

     .OrG       $a600       
 .CoNsT      pPuCtRl_0102     =      $2000    
.cOnSt    ZeRoPaGe_0102=     $00f0

  WeirdStart_0102:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0102      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0102:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0102
	JsR       WeirdSub_0102
	JmP         WeirdDone_0102

WeirdSub_0102:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0102:
	NoP
	RtS

 WeirdTable_0102:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0102   ,   WeirdSub_0102
.aDdR  WeirdDone_0102
.bYtE   <WeirdStart_0102 , >WeirdStart_0102

   ; Weird Formatting Module 0103 - All Of This Should Normalize Cleanly   

     .OrG       $a700       
 .CoNsT      pPuCtRl_0103     =      $2000    
.cOnSt    ZeRoPaGe_0103=     $00f0

  WeirdStart_0103:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0103      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0103:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0103
	JsR       WeirdSub_0103
	JmP         WeirdDone_0103

WeirdSub_0103:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0103:
	NoP
	RtS

 WeirdTable_0103:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0103   ,   WeirdSub_0103
.aDdR  WeirdDone_0103
.bYtE   <WeirdStart_0103 , >WeirdStart_0103

   ; Weird Formatting Module 0104 - All Of This Should Normalize Cleanly   

     .OrG       $a800       
 .CoNsT      pPuCtRl_0104     =      $2000    
.cOnSt    ZeRoPaGe_0104=     $00f0

  WeirdStart_0104:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0104      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0104:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0104
	JsR       WeirdSub_0104
	JmP         WeirdDone_0104

WeirdSub_0104:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0104:
	NoP
	RtS

 WeirdTable_0104:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0104   ,   WeirdSub_0104
.aDdR  WeirdDone_0104
.bYtE   <WeirdStart_0104 , >WeirdStart_0104

   ; Weird Formatting Module 0105 - All Of This Should Normalize Cleanly   

     .OrG       $a900       
 .CoNsT      pPuCtRl_0105     =      $2000    
.cOnSt    ZeRoPaGe_0105=     $00f0

  WeirdStart_0105:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0105      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0105:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0105
	JsR       WeirdSub_0105
	JmP         WeirdDone_0105

WeirdSub_0105:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0105:
	NoP
	RtS

 WeirdTable_0105:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0105   ,   WeirdSub_0105
.aDdR  WeirdDone_0105
.bYtE   <WeirdStart_0105 , >WeirdStart_0105

   ; Weird Formatting Module 0106 - All Of This Should Normalize Cleanly   

     .OrG       $aa00       
 .CoNsT      pPuCtRl_0106     =      $2000    
.cOnSt    ZeRoPaGe_0106=     $00f0

  WeirdStart_0106:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0106      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0106:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0106
	JsR       WeirdSub_0106
	JmP         WeirdDone_0106

WeirdSub_0106:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0106:
	NoP
	RtS

 WeirdTable_0106:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0106   ,   WeirdSub_0106
.aDdR  WeirdDone_0106
.bYtE   <WeirdStart_0106 , >WeirdStart_0106

   ; Weird Formatting Module 0107 - All Of This Should Normalize Cleanly   

     .OrG       $ab00       
 .CoNsT      pPuCtRl_0107     =      $2000    
.cOnSt    ZeRoPaGe_0107=     $00f0

  WeirdStart_0107:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0107      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0107:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0107
	JsR       WeirdSub_0107
	JmP         WeirdDone_0107

WeirdSub_0107:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0107:
	NoP
	RtS

 WeirdTable_0107:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0107   ,   WeirdSub_0107
.aDdR  WeirdDone_0107
.bYtE   <WeirdStart_0107 , >WeirdStart_0107

   ; Weird Formatting Module 0108 - All Of This Should Normalize Cleanly   

     .OrG       $ac00       
 .CoNsT      pPuCtRl_0108     =      $2000    
.cOnSt    ZeRoPaGe_0108=     $00f0

  WeirdStart_0108:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0108      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0108:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0108
	JsR       WeirdSub_0108
	JmP         WeirdDone_0108

WeirdSub_0108:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0108:
	NoP
	RtS

 WeirdTable_0108:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0108   ,   WeirdSub_0108
.aDdR  WeirdDone_0108
.bYtE   <WeirdStart_0108 , >WeirdStart_0108

   ; Weird Formatting Module 0109 - All Of This Should Normalize Cleanly   

     .OrG       $ad00       
 .CoNsT      pPuCtRl_0109     =      $2000    
.cOnSt    ZeRoPaGe_0109=     $00f0

  WeirdStart_0109:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0109      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0109:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0109
	JsR       WeirdSub_0109
	JmP         WeirdDone_0109

WeirdSub_0109:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0109:
	NoP
	RtS

 WeirdTable_0109:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0109   ,   WeirdSub_0109
.aDdR  WeirdDone_0109
.bYtE   <WeirdStart_0109 , >WeirdStart_0109

   ; Weird Formatting Module 0110 - All Of This Should Normalize Cleanly   

     .OrG       $ae00       
 .CoNsT      pPuCtRl_0110     =      $2000    
.cOnSt    ZeRoPaGe_0110=     $00f0

  WeirdStart_0110:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0110      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0110:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0110
	JsR       WeirdSub_0110
	JmP         WeirdDone_0110

WeirdSub_0110:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0110:
	NoP
	RtS

 WeirdTable_0110:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0110   ,   WeirdSub_0110
.aDdR  WeirdDone_0110
.bYtE   <WeirdStart_0110 , >WeirdStart_0110

   ; Weird Formatting Module 0111 - All Of This Should Normalize Cleanly   

     .OrG       $af00       
 .CoNsT      pPuCtRl_0111     =      $2000    
.cOnSt    ZeRoPaGe_0111=     $00f0

  WeirdStart_0111:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0111      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0111:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0111
	JsR       WeirdSub_0111
	JmP         WeirdDone_0111

WeirdSub_0111:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0111:
	NoP
	RtS

 WeirdTable_0111:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0111   ,   WeirdSub_0111
.aDdR  WeirdDone_0111
.bYtE   <WeirdStart_0111 , >WeirdStart_0111

   ; Weird Formatting Module 0112 - All Of This Should Normalize Cleanly   

     .OrG       $b000       
 .CoNsT      pPuCtRl_0112     =      $2000    
.cOnSt    ZeRoPaGe_0112=     $00f0

  WeirdStart_0112:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0112      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0112:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0112
	JsR       WeirdSub_0112
	JmP         WeirdDone_0112

WeirdSub_0112:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0112:
	NoP
	RtS

 WeirdTable_0112:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0112   ,   WeirdSub_0112
.aDdR  WeirdDone_0112
.bYtE   <WeirdStart_0112 , >WeirdStart_0112

   ; Weird Formatting Module 0113 - All Of This Should Normalize Cleanly   

     .OrG       $b100       
 .CoNsT      pPuCtRl_0113     =      $2000    
.cOnSt    ZeRoPaGe_0113=     $00f0

  WeirdStart_0113:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0113      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0113:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0113
	JsR       WeirdSub_0113
	JmP         WeirdDone_0113

WeirdSub_0113:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0113:
	NoP
	RtS

 WeirdTable_0113:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0113   ,   WeirdSub_0113
.aDdR  WeirdDone_0113
.bYtE   <WeirdStart_0113 , >WeirdStart_0113

   ; Weird Formatting Module 0114 - All Of This Should Normalize Cleanly   

     .OrG       $b200       
 .CoNsT      pPuCtRl_0114     =      $2000    
.cOnSt    ZeRoPaGe_0114=     $00f0

  WeirdStart_0114:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0114      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0114:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0114
	JsR       WeirdSub_0114
	JmP         WeirdDone_0114

WeirdSub_0114:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0114:
	NoP
	RtS

 WeirdTable_0114:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0114   ,   WeirdSub_0114
.aDdR  WeirdDone_0114
.bYtE   <WeirdStart_0114 , >WeirdStart_0114

   ; Weird Formatting Module 0115 - All Of This Should Normalize Cleanly   

     .OrG       $b300       
 .CoNsT      pPuCtRl_0115     =      $2000    
.cOnSt    ZeRoPaGe_0115=     $00f0

  WeirdStart_0115:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0115      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0115:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0115
	JsR       WeirdSub_0115
	JmP         WeirdDone_0115

WeirdSub_0115:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0115:
	NoP
	RtS

 WeirdTable_0115:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0115   ,   WeirdSub_0115
.aDdR  WeirdDone_0115
.bYtE   <WeirdStart_0115 , >WeirdStart_0115

   ; Weird Formatting Module 0116 - All Of This Should Normalize Cleanly   

     .OrG       $b400       
 .CoNsT      pPuCtRl_0116     =      $2000    
.cOnSt    ZeRoPaGe_0116=     $00f0

  WeirdStart_0116:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0116      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0116:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0116
	JsR       WeirdSub_0116
	JmP         WeirdDone_0116

WeirdSub_0116:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0116:
	NoP
	RtS

 WeirdTable_0116:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0116   ,   WeirdSub_0116
.aDdR  WeirdDone_0116
.bYtE   <WeirdStart_0116 , >WeirdStart_0116

   ; Weird Formatting Module 0117 - All Of This Should Normalize Cleanly   

     .OrG       $b500       
 .CoNsT      pPuCtRl_0117     =      $2000    
.cOnSt    ZeRoPaGe_0117=     $00f0

  WeirdStart_0117:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0117      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0117:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0117
	JsR       WeirdSub_0117
	JmP         WeirdDone_0117

WeirdSub_0117:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0117:
	NoP
	RtS

 WeirdTable_0117:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0117   ,   WeirdSub_0117
.aDdR  WeirdDone_0117
.bYtE   <WeirdStart_0117 , >WeirdStart_0117

   ; Weird Formatting Module 0118 - All Of This Should Normalize Cleanly   

     .OrG       $b600       
 .CoNsT      pPuCtRl_0118     =      $2000    
.cOnSt    ZeRoPaGe_0118=     $00f0

  WeirdStart_0118:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0118      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0118:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0118
	JsR       WeirdSub_0118
	JmP         WeirdDone_0118

WeirdSub_0118:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0118:
	NoP
	RtS

 WeirdTable_0118:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0118   ,   WeirdSub_0118
.aDdR  WeirdDone_0118
.bYtE   <WeirdStart_0118 , >WeirdStart_0118

   ; Weird Formatting Module 0119 - All Of This Should Normalize Cleanly   

     .OrG       $b700       
 .CoNsT      pPuCtRl_0119     =      $2000    
.cOnSt    ZeRoPaGe_0119=     $00f0

  WeirdStart_0119:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0119      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0119:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0119
	JsR       WeirdSub_0119
	JmP         WeirdDone_0119

WeirdSub_0119:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0119:
	NoP
	RtS

 WeirdTable_0119:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0119   ,   WeirdSub_0119
.aDdR  WeirdDone_0119
.bYtE   <WeirdStart_0119 , >WeirdStart_0119

   ; Weird Formatting Module 0120 - All Of This Should Normalize Cleanly   

     .OrG       $b800       
 .CoNsT      pPuCtRl_0120     =      $2000    
.cOnSt    ZeRoPaGe_0120=     $00f0

  WeirdStart_0120:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0120      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0120:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0120
	JsR       WeirdSub_0120
	JmP         WeirdDone_0120

WeirdSub_0120:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0120:
	NoP
	RtS

 WeirdTable_0120:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0120   ,   WeirdSub_0120
.aDdR  WeirdDone_0120
.bYtE   <WeirdStart_0120 , >WeirdStart_0120

   ; Weird Formatting Module 0121 - All Of This Should Normalize Cleanly   

     .OrG       $b900       
 .CoNsT      pPuCtRl_0121     =      $2000    
.cOnSt    ZeRoPaGe_0121=     $00f0

  WeirdStart_0121:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0121      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0121:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0121
	JsR       WeirdSub_0121
	JmP         WeirdDone_0121

WeirdSub_0121:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0121:
	NoP
	RtS

 WeirdTable_0121:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0121   ,   WeirdSub_0121
.aDdR  WeirdDone_0121
.bYtE   <WeirdStart_0121 , >WeirdStart_0121

   ; Weird Formatting Module 0122 - All Of This Should Normalize Cleanly   

     .OrG       $ba00       
 .CoNsT      pPuCtRl_0122     =      $2000    
.cOnSt    ZeRoPaGe_0122=     $00f0

  WeirdStart_0122:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0122      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0122:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0122
	JsR       WeirdSub_0122
	JmP         WeirdDone_0122

WeirdSub_0122:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0122:
	NoP
	RtS

 WeirdTable_0122:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0122   ,   WeirdSub_0122
.aDdR  WeirdDone_0122
.bYtE   <WeirdStart_0122 , >WeirdStart_0122

   ; Weird Formatting Module 0123 - All Of This Should Normalize Cleanly   

     .OrG       $bb00       
 .CoNsT      pPuCtRl_0123     =      $2000    
.cOnSt    ZeRoPaGe_0123=     $00f0

  WeirdStart_0123:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0123      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0123:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0123
	JsR       WeirdSub_0123
	JmP         WeirdDone_0123

WeirdSub_0123:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0123:
	NoP
	RtS

 WeirdTable_0123:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0123   ,   WeirdSub_0123
.aDdR  WeirdDone_0123
.bYtE   <WeirdStart_0123 , >WeirdStart_0123

   ; Weird Formatting Module 0124 - All Of This Should Normalize Cleanly   

     .OrG       $bc00       
 .CoNsT      pPuCtRl_0124     =      $2000    
.cOnSt    ZeRoPaGe_0124=     $00f0

  WeirdStart_0124:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0124      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0124:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0124
	JsR       WeirdSub_0124
	JmP         WeirdDone_0124

WeirdSub_0124:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0124:
	NoP
	RtS

 WeirdTable_0124:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0124   ,   WeirdSub_0124
.aDdR  WeirdDone_0124
.bYtE   <WeirdStart_0124 , >WeirdStart_0124

   ; Weird Formatting Module 0125 - All Of This Should Normalize Cleanly   

     .OrG       $bd00       
 .CoNsT      pPuCtRl_0125     =      $2000    
.cOnSt    ZeRoPaGe_0125=     $00f0

  WeirdStart_0125:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0125      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0125:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0125
	JsR       WeirdSub_0125
	JmP         WeirdDone_0125

WeirdSub_0125:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0125:
	NoP
	RtS

 WeirdTable_0125:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0125   ,   WeirdSub_0125
.aDdR  WeirdDone_0125
.bYtE   <WeirdStart_0125 , >WeirdStart_0125

   ; Weird Formatting Module 0126 - All Of This Should Normalize Cleanly   

     .OrG       $be00       
 .CoNsT      pPuCtRl_0126     =      $2000    
.cOnSt    ZeRoPaGe_0126=     $00f0

  WeirdStart_0126:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0126      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0126:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0126
	JsR       WeirdSub_0126
	JmP         WeirdDone_0126

WeirdSub_0126:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0126:
	NoP
	RtS

 WeirdTable_0126:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0126   ,   WeirdSub_0126
.aDdR  WeirdDone_0126
.bYtE   <WeirdStart_0126 , >WeirdStart_0126

   ; Weird Formatting Module 0127 - All Of This Should Normalize Cleanly   

     .OrG       $bf00       
 .CoNsT      pPuCtRl_0127     =      $2000    
.cOnSt    ZeRoPaGe_0127=     $00f0

  WeirdStart_0127:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0127      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0127:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0127
	JsR       WeirdSub_0127
	JmP         WeirdDone_0127

WeirdSub_0127:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0127:
	NoP
	RtS

 WeirdTable_0127:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0127   ,   WeirdSub_0127
.aDdR  WeirdDone_0127
.bYtE   <WeirdStart_0127 , >WeirdStart_0127

   ; Weird Formatting Module 0128 - All Of This Should Normalize Cleanly   

     .OrG       $c000       
 .CoNsT      pPuCtRl_0128     =      $2000    
.cOnSt    ZeRoPaGe_0128=     $00f0

  WeirdStart_0128:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0128      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0128:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0128
	JsR       WeirdSub_0128
	JmP         WeirdDone_0128

WeirdSub_0128:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0128:
	NoP
	RtS

 WeirdTable_0128:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0128   ,   WeirdSub_0128
.aDdR  WeirdDone_0128
.bYtE   <WeirdStart_0128 , >WeirdStart_0128

   ; Weird Formatting Module 0129 - All Of This Should Normalize Cleanly   

     .OrG       $c100       
 .CoNsT      pPuCtRl_0129     =      $2000    
.cOnSt    ZeRoPaGe_0129=     $00f0

  WeirdStart_0129:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0129      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0129:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0129
	JsR       WeirdSub_0129
	JmP         WeirdDone_0129

WeirdSub_0129:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0129:
	NoP
	RtS

 WeirdTable_0129:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0129   ,   WeirdSub_0129
.aDdR  WeirdDone_0129
.bYtE   <WeirdStart_0129 , >WeirdStart_0129

   ; Weird Formatting Module 0130 - All Of This Should Normalize Cleanly   

     .OrG       $c200       
 .CoNsT      pPuCtRl_0130     =      $2000    
.cOnSt    ZeRoPaGe_0130=     $00f0

  WeirdStart_0130:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0130      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0130:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0130
	JsR       WeirdSub_0130
	JmP         WeirdDone_0130

WeirdSub_0130:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0130:
	NoP
	RtS

 WeirdTable_0130:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0130   ,   WeirdSub_0130
.aDdR  WeirdDone_0130
.bYtE   <WeirdStart_0130 , >WeirdStart_0130

   ; Weird Formatting Module 0131 - All Of This Should Normalize Cleanly   

     .OrG       $c300       
 .CoNsT      pPuCtRl_0131     =      $2000    
.cOnSt    ZeRoPaGe_0131=     $00f0

  WeirdStart_0131:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0131      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0131:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0131
	JsR       WeirdSub_0131
	JmP         WeirdDone_0131

WeirdSub_0131:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0131:
	NoP
	RtS

 WeirdTable_0131:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0131   ,   WeirdSub_0131
.aDdR  WeirdDone_0131
.bYtE   <WeirdStart_0131 , >WeirdStart_0131

   ; Weird Formatting Module 0132 - All Of This Should Normalize Cleanly   

     .OrG       $c400       
 .CoNsT      pPuCtRl_0132     =      $2000    
.cOnSt    ZeRoPaGe_0132=     $00f0

  WeirdStart_0132:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0132      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0132:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0132
	JsR       WeirdSub_0132
	JmP         WeirdDone_0132

WeirdSub_0132:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0132:
	NoP
	RtS

 WeirdTable_0132:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0132   ,   WeirdSub_0132
.aDdR  WeirdDone_0132
.bYtE   <WeirdStart_0132 , >WeirdStart_0132

   ; Weird Formatting Module 0133 - All Of This Should Normalize Cleanly   

     .OrG       $c500       
 .CoNsT      pPuCtRl_0133     =      $2000    
.cOnSt    ZeRoPaGe_0133=     $00f0

  WeirdStart_0133:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0133      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0133:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0133
	JsR       WeirdSub_0133
	JmP         WeirdDone_0133

WeirdSub_0133:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0133:
	NoP
	RtS

 WeirdTable_0133:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0133   ,   WeirdSub_0133
.aDdR  WeirdDone_0133
.bYtE   <WeirdStart_0133 , >WeirdStart_0133

   ; Weird Formatting Module 0134 - All Of This Should Normalize Cleanly   

     .OrG       $c600       
 .CoNsT      pPuCtRl_0134     =      $2000    
.cOnSt    ZeRoPaGe_0134=     $00f0

  WeirdStart_0134:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0134      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0134:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0134
	JsR       WeirdSub_0134
	JmP         WeirdDone_0134

WeirdSub_0134:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0134:
	NoP
	RtS

 WeirdTable_0134:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0134   ,   WeirdSub_0134
.aDdR  WeirdDone_0134
.bYtE   <WeirdStart_0134 , >WeirdStart_0134

   ; Weird Formatting Module 0135 - All Of This Should Normalize Cleanly   

     .OrG       $c700       
 .CoNsT      pPuCtRl_0135     =      $2000    
.cOnSt    ZeRoPaGe_0135=     $00f0

  WeirdStart_0135:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0135      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0135:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0135
	JsR       WeirdSub_0135
	JmP         WeirdDone_0135

WeirdSub_0135:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0135:
	NoP
	RtS

 WeirdTable_0135:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0135   ,   WeirdSub_0135
.aDdR  WeirdDone_0135
.bYtE   <WeirdStart_0135 , >WeirdStart_0135

   ; Weird Formatting Module 0136 - All Of This Should Normalize Cleanly   

     .OrG       $c800       
 .CoNsT      pPuCtRl_0136     =      $2000    
.cOnSt    ZeRoPaGe_0136=     $00f0

  WeirdStart_0136:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0136      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0136:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0136
	JsR       WeirdSub_0136
	JmP         WeirdDone_0136

WeirdSub_0136:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0136:
	NoP
	RtS

 WeirdTable_0136:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0136   ,   WeirdSub_0136
.aDdR  WeirdDone_0136
.bYtE   <WeirdStart_0136 , >WeirdStart_0136

   ; Weird Formatting Module 0137 - All Of This Should Normalize Cleanly   

     .OrG       $c900       
 .CoNsT      pPuCtRl_0137     =      $2000    
.cOnSt    ZeRoPaGe_0137=     $00f0

  WeirdStart_0137:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0137      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0137:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0137
	JsR       WeirdSub_0137
	JmP         WeirdDone_0137

WeirdSub_0137:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0137:
	NoP
	RtS

 WeirdTable_0137:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0137   ,   WeirdSub_0137
.aDdR  WeirdDone_0137
.bYtE   <WeirdStart_0137 , >WeirdStart_0137

   ; Weird Formatting Module 0138 - All Of This Should Normalize Cleanly   

     .OrG       $ca00       
 .CoNsT      pPuCtRl_0138     =      $2000    
.cOnSt    ZeRoPaGe_0138=     $00f0

  WeirdStart_0138:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0138      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0138:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0138
	JsR       WeirdSub_0138
	JmP         WeirdDone_0138

WeirdSub_0138:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0138:
	NoP
	RtS

 WeirdTable_0138:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0138   ,   WeirdSub_0138
.aDdR  WeirdDone_0138
.bYtE   <WeirdStart_0138 , >WeirdStart_0138

   ; Weird Formatting Module 0139 - All Of This Should Normalize Cleanly   

     .OrG       $cb00       
 .CoNsT      pPuCtRl_0139     =      $2000    
.cOnSt    ZeRoPaGe_0139=     $00f0

  WeirdStart_0139:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0139      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0139:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0139
	JsR       WeirdSub_0139
	JmP         WeirdDone_0139

WeirdSub_0139:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0139:
	NoP
	RtS

 WeirdTable_0139:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0139   ,   WeirdSub_0139
.aDdR  WeirdDone_0139
.bYtE   <WeirdStart_0139 , >WeirdStart_0139

   ; Weird Formatting Module 0140 - All Of This Should Normalize Cleanly   

     .OrG       $cc00       
 .CoNsT      pPuCtRl_0140     =      $2000    
.cOnSt    ZeRoPaGe_0140=     $00f0

  WeirdStart_0140:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0140      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0140:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0140
	JsR       WeirdSub_0140
	JmP         WeirdDone_0140

WeirdSub_0140:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0140:
	NoP
	RtS

 WeirdTable_0140:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0140   ,   WeirdSub_0140
.aDdR  WeirdDone_0140
.bYtE   <WeirdStart_0140 , >WeirdStart_0140

   ; Weird Formatting Module 0141 - All Of This Should Normalize Cleanly   

     .OrG       $cd00       
 .CoNsT      pPuCtRl_0141     =      $2000    
.cOnSt    ZeRoPaGe_0141=     $00f0

  WeirdStart_0141:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0141      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0141:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0141
	JsR       WeirdSub_0141
	JmP         WeirdDone_0141

WeirdSub_0141:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0141:
	NoP
	RtS

 WeirdTable_0141:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0141   ,   WeirdSub_0141
.aDdR  WeirdDone_0141
.bYtE   <WeirdStart_0141 , >WeirdStart_0141

   ; Weird Formatting Module 0142 - All Of This Should Normalize Cleanly   

     .OrG       $ce00       
 .CoNsT      pPuCtRl_0142     =      $2000    
.cOnSt    ZeRoPaGe_0142=     $00f0

  WeirdStart_0142:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0142      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0142:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0142
	JsR       WeirdSub_0142
	JmP         WeirdDone_0142

WeirdSub_0142:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0142:
	NoP
	RtS

 WeirdTable_0142:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0142   ,   WeirdSub_0142
.aDdR  WeirdDone_0142
.bYtE   <WeirdStart_0142 , >WeirdStart_0142

   ; Weird Formatting Module 0143 - All Of This Should Normalize Cleanly   

     .OrG       $cf00       
 .CoNsT      pPuCtRl_0143     =      $2000    
.cOnSt    ZeRoPaGe_0143=     $00f0

  WeirdStart_0143:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0143      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0143:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0143
	JsR       WeirdSub_0143
	JmP         WeirdDone_0143

WeirdSub_0143:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0143:
	NoP
	RtS

 WeirdTable_0143:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0143   ,   WeirdSub_0143
.aDdR  WeirdDone_0143
.bYtE   <WeirdStart_0143 , >WeirdStart_0143

   ; Weird Formatting Module 0144 - All Of This Should Normalize Cleanly   

     .OrG       $d000       
 .CoNsT      pPuCtRl_0144     =      $2000    
.cOnSt    ZeRoPaGe_0144=     $00f0

  WeirdStart_0144:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0144      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0144:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0144
	JsR       WeirdSub_0144
	JmP         WeirdDone_0144

WeirdSub_0144:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0144:
	NoP
	RtS

 WeirdTable_0144:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0144   ,   WeirdSub_0144
.aDdR  WeirdDone_0144
.bYtE   <WeirdStart_0144 , >WeirdStart_0144

   ; Weird Formatting Module 0145 - All Of This Should Normalize Cleanly   

     .OrG       $d100       
 .CoNsT      pPuCtRl_0145     =      $2000    
.cOnSt    ZeRoPaGe_0145=     $00f0

  WeirdStart_0145:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0145      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0145:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0145
	JsR       WeirdSub_0145
	JmP         WeirdDone_0145

WeirdSub_0145:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0145:
	NoP
	RtS

 WeirdTable_0145:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0145   ,   WeirdSub_0145
.aDdR  WeirdDone_0145
.bYtE   <WeirdStart_0145 , >WeirdStart_0145

   ; Weird Formatting Module 0146 - All Of This Should Normalize Cleanly   

     .OrG       $d200       
 .CoNsT      pPuCtRl_0146     =      $2000    
.cOnSt    ZeRoPaGe_0146=     $00f0

  WeirdStart_0146:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0146      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0146:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0146
	JsR       WeirdSub_0146
	JmP         WeirdDone_0146

WeirdSub_0146:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0146:
	NoP
	RtS

 WeirdTable_0146:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0146   ,   WeirdSub_0146
.aDdR  WeirdDone_0146
.bYtE   <WeirdStart_0146 , >WeirdStart_0146

   ; Weird Formatting Module 0147 - All Of This Should Normalize Cleanly   

     .OrG       $d300       
 .CoNsT      pPuCtRl_0147     =      $2000    
.cOnSt    ZeRoPaGe_0147=     $00f0

  WeirdStart_0147:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0147      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0147:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0147
	JsR       WeirdSub_0147
	JmP         WeirdDone_0147

WeirdSub_0147:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0147:
	NoP
	RtS

 WeirdTable_0147:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0147   ,   WeirdSub_0147
.aDdR  WeirdDone_0147
.bYtE   <WeirdStart_0147 , >WeirdStart_0147

   ; Weird Formatting Module 0148 - All Of This Should Normalize Cleanly   

     .OrG       $d400       
 .CoNsT      pPuCtRl_0148     =      $2000    
.cOnSt    ZeRoPaGe_0148=     $00f0

  WeirdStart_0148:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0148      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0148:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0148
	JsR       WeirdSub_0148
	JmP         WeirdDone_0148

WeirdSub_0148:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0148:
	NoP
	RtS

 WeirdTable_0148:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0148   ,   WeirdSub_0148
.aDdR  WeirdDone_0148
.bYtE   <WeirdStart_0148 , >WeirdStart_0148

   ; Weird Formatting Module 0149 - All Of This Should Normalize Cleanly   

     .OrG       $d500       
 .CoNsT      pPuCtRl_0149     =      $2000    
.cOnSt    ZeRoPaGe_0149=     $00f0

  WeirdStart_0149:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0149      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0149:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0149
	JsR       WeirdSub_0149
	JmP         WeirdDone_0149

WeirdSub_0149:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0149:
	NoP
	RtS

 WeirdTable_0149:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0149   ,   WeirdSub_0149
.aDdR  WeirdDone_0149
.bYtE   <WeirdStart_0149 , >WeirdStart_0149

   ; Weird Formatting Module 0150 - All Of This Should Normalize Cleanly   

     .OrG       $d600       
 .CoNsT      pPuCtRl_0150     =      $2000    
.cOnSt    ZeRoPaGe_0150=     $00f0

  WeirdStart_0150:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0150      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0150:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0150
	JsR       WeirdSub_0150
	JmP         WeirdDone_0150

WeirdSub_0150:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0150:
	NoP
	RtS

 WeirdTable_0150:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0150   ,   WeirdSub_0150
.aDdR  WeirdDone_0150
.bYtE   <WeirdStart_0150 , >WeirdStart_0150

   ; Weird Formatting Module 0151 - All Of This Should Normalize Cleanly   

     .OrG       $d700       
 .CoNsT      pPuCtRl_0151     =      $2000    
.cOnSt    ZeRoPaGe_0151=     $00f0

  WeirdStart_0151:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0151      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0151:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0151
	JsR       WeirdSub_0151
	JmP         WeirdDone_0151

WeirdSub_0151:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0151:
	NoP
	RtS

 WeirdTable_0151:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0151   ,   WeirdSub_0151
.aDdR  WeirdDone_0151
.bYtE   <WeirdStart_0151 , >WeirdStart_0151

   ; Weird Formatting Module 0152 - All Of This Should Normalize Cleanly   

     .OrG       $d800       
 .CoNsT      pPuCtRl_0152     =      $2000    
.cOnSt    ZeRoPaGe_0152=     $00f0

  WeirdStart_0152:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0152      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0152:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0152
	JsR       WeirdSub_0152
	JmP         WeirdDone_0152

WeirdSub_0152:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0152:
	NoP
	RtS

 WeirdTable_0152:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0152   ,   WeirdSub_0152
.aDdR  WeirdDone_0152
.bYtE   <WeirdStart_0152 , >WeirdStart_0152

   ; Weird Formatting Module 0153 - All Of This Should Normalize Cleanly   

     .OrG       $d900       
 .CoNsT      pPuCtRl_0153     =      $2000    
.cOnSt    ZeRoPaGe_0153=     $00f0

  WeirdStart_0153:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0153      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0153:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0153
	JsR       WeirdSub_0153
	JmP         WeirdDone_0153

WeirdSub_0153:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0153:
	NoP
	RtS

 WeirdTable_0153:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0153   ,   WeirdSub_0153
.aDdR  WeirdDone_0153
.bYtE   <WeirdStart_0153 , >WeirdStart_0153

   ; Weird Formatting Module 0154 - All Of This Should Normalize Cleanly   

     .OrG       $da00       
 .CoNsT      pPuCtRl_0154     =      $2000    
.cOnSt    ZeRoPaGe_0154=     $00f0

  WeirdStart_0154:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0154      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0154:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0154
	JsR       WeirdSub_0154
	JmP         WeirdDone_0154

WeirdSub_0154:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0154:
	NoP
	RtS

 WeirdTable_0154:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0154   ,   WeirdSub_0154
.aDdR  WeirdDone_0154
.bYtE   <WeirdStart_0154 , >WeirdStart_0154

   ; Weird Formatting Module 0155 - All Of This Should Normalize Cleanly   

     .OrG       $db00       
 .CoNsT      pPuCtRl_0155     =      $2000    
.cOnSt    ZeRoPaGe_0155=     $00f0

  WeirdStart_0155:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0155      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0155:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0155
	JsR       WeirdSub_0155
	JmP         WeirdDone_0155

WeirdSub_0155:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0155:
	NoP
	RtS

 WeirdTable_0155:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0155   ,   WeirdSub_0155
.aDdR  WeirdDone_0155
.bYtE   <WeirdStart_0155 , >WeirdStart_0155

   ; Weird Formatting Module 0156 - All Of This Should Normalize Cleanly   

     .OrG       $dc00       
 .CoNsT      pPuCtRl_0156     =      $2000    
.cOnSt    ZeRoPaGe_0156=     $00f0

  WeirdStart_0156:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0156      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0156:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0156
	JsR       WeirdSub_0156
	JmP         WeirdDone_0156

WeirdSub_0156:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0156:
	NoP
	RtS

 WeirdTable_0156:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0156   ,   WeirdSub_0156
.aDdR  WeirdDone_0156
.bYtE   <WeirdStart_0156 , >WeirdStart_0156

   ; Weird Formatting Module 0157 - All Of This Should Normalize Cleanly   

     .OrG       $dd00       
 .CoNsT      pPuCtRl_0157     =      $2000    
.cOnSt    ZeRoPaGe_0157=     $00f0

  WeirdStart_0157:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0157      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0157:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0157
	JsR       WeirdSub_0157
	JmP         WeirdDone_0157

WeirdSub_0157:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0157:
	NoP
	RtS

 WeirdTable_0157:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0157   ,   WeirdSub_0157
.aDdR  WeirdDone_0157
.bYtE   <WeirdStart_0157 , >WeirdStart_0157

   ; Weird Formatting Module 0158 - All Of This Should Normalize Cleanly   

     .OrG       $de00       
 .CoNsT      pPuCtRl_0158     =      $2000    
.cOnSt    ZeRoPaGe_0158=     $00f0

  WeirdStart_0158:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0158      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0158:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0158
	JsR       WeirdSub_0158
	JmP         WeirdDone_0158

WeirdSub_0158:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0158:
	NoP
	RtS

 WeirdTable_0158:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0158   ,   WeirdSub_0158
.aDdR  WeirdDone_0158
.bYtE   <WeirdStart_0158 , >WeirdStart_0158

   ; Weird Formatting Module 0159 - All Of This Should Normalize Cleanly   

     .OrG       $df00       
 .CoNsT      pPuCtRl_0159     =      $2000    
.cOnSt    ZeRoPaGe_0159=     $00f0

  WeirdStart_0159:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0159      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0159:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0159
	JsR       WeirdSub_0159
	JmP         WeirdDone_0159

WeirdSub_0159:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0159:
	NoP
	RtS

 WeirdTable_0159:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0159   ,   WeirdSub_0159
.aDdR  WeirdDone_0159
.bYtE   <WeirdStart_0159 , >WeirdStart_0159

   ; Weird Formatting Module 0160 - All Of This Should Normalize Cleanly   

     .OrG       $9000       
 .CoNsT      pPuCtRl_0160     =      $2000    
.cOnSt    ZeRoPaGe_0160=     $00f0

  WeirdStart_0160:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0160      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0160:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0160
	JsR       WeirdSub_0160
	JmP         WeirdDone_0160

WeirdSub_0160:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0160:
	NoP
	RtS

 WeirdTable_0160:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0160   ,   WeirdSub_0160
.aDdR  WeirdDone_0160
.bYtE   <WeirdStart_0160 , >WeirdStart_0160

   ; Weird Formatting Module 0161 - All Of This Should Normalize Cleanly   

     .OrG       $9100       
 .CoNsT      pPuCtRl_0161     =      $2000    
.cOnSt    ZeRoPaGe_0161=     $00f0

  WeirdStart_0161:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0161      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0161:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0161
	JsR       WeirdSub_0161
	JmP         WeirdDone_0161

WeirdSub_0161:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0161:
	NoP
	RtS

 WeirdTable_0161:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0161   ,   WeirdSub_0161
.aDdR  WeirdDone_0161
.bYtE   <WeirdStart_0161 , >WeirdStart_0161

   ; Weird Formatting Module 0162 - All Of This Should Normalize Cleanly   

     .OrG       $9200       
 .CoNsT      pPuCtRl_0162     =      $2000    
.cOnSt    ZeRoPaGe_0162=     $00f0

  WeirdStart_0162:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0162      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0162:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0162
	JsR       WeirdSub_0162
	JmP         WeirdDone_0162

WeirdSub_0162:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0162:
	NoP
	RtS

 WeirdTable_0162:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0162   ,   WeirdSub_0162
.aDdR  WeirdDone_0162
.bYtE   <WeirdStart_0162 , >WeirdStart_0162

   ; Weird Formatting Module 0163 - All Of This Should Normalize Cleanly   

     .OrG       $9300       
 .CoNsT      pPuCtRl_0163     =      $2000    
.cOnSt    ZeRoPaGe_0163=     $00f0

  WeirdStart_0163:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0163      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0163:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0163
	JsR       WeirdSub_0163
	JmP         WeirdDone_0163

WeirdSub_0163:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0163:
	NoP
	RtS

 WeirdTable_0163:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0163   ,   WeirdSub_0163
.aDdR  WeirdDone_0163
.bYtE   <WeirdStart_0163 , >WeirdStart_0163

   ; Weird Formatting Module 0164 - All Of This Should Normalize Cleanly   

     .OrG       $9400       
 .CoNsT      pPuCtRl_0164     =      $2000    
.cOnSt    ZeRoPaGe_0164=     $00f0

  WeirdStart_0164:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0164      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0164:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0164
	JsR       WeirdSub_0164
	JmP         WeirdDone_0164

WeirdSub_0164:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0164:
	NoP
	RtS

 WeirdTable_0164:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0164   ,   WeirdSub_0164
.aDdR  WeirdDone_0164
.bYtE   <WeirdStart_0164 , >WeirdStart_0164

   ; Weird Formatting Module 0165 - All Of This Should Normalize Cleanly   

     .OrG       $9500       
 .CoNsT      pPuCtRl_0165     =      $2000    
.cOnSt    ZeRoPaGe_0165=     $00f0

  WeirdStart_0165:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0165      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0165:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0165
	JsR       WeirdSub_0165
	JmP         WeirdDone_0165

WeirdSub_0165:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0165:
	NoP
	RtS

 WeirdTable_0165:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0165   ,   WeirdSub_0165
.aDdR  WeirdDone_0165
.bYtE   <WeirdStart_0165 , >WeirdStart_0165

   ; Weird Formatting Module 0166 - All Of This Should Normalize Cleanly   

     .OrG       $9600       
 .CoNsT      pPuCtRl_0166     =      $2000    
.cOnSt    ZeRoPaGe_0166=     $00f0

  WeirdStart_0166:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0166      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0166:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0166
	JsR       WeirdSub_0166
	JmP         WeirdDone_0166

WeirdSub_0166:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0166:
	NoP
	RtS

 WeirdTable_0166:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0166   ,   WeirdSub_0166
.aDdR  WeirdDone_0166
.bYtE   <WeirdStart_0166 , >WeirdStart_0166

   ; Weird Formatting Module 0167 - All Of This Should Normalize Cleanly   

     .OrG       $9700       
 .CoNsT      pPuCtRl_0167     =      $2000    
.cOnSt    ZeRoPaGe_0167=     $00f0

  WeirdStart_0167:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0167      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0167:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0167
	JsR       WeirdSub_0167
	JmP         WeirdDone_0167

WeirdSub_0167:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0167:
	NoP
	RtS

 WeirdTable_0167:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0167   ,   WeirdSub_0167
.aDdR  WeirdDone_0167
.bYtE   <WeirdStart_0167 , >WeirdStart_0167

   ; Weird Formatting Module 0168 - All Of This Should Normalize Cleanly   

     .OrG       $9800       
 .CoNsT      pPuCtRl_0168     =      $2000    
.cOnSt    ZeRoPaGe_0168=     $00f0

  WeirdStart_0168:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0168      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0168:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0168
	JsR       WeirdSub_0168
	JmP         WeirdDone_0168

WeirdSub_0168:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0168:
	NoP
	RtS

 WeirdTable_0168:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0168   ,   WeirdSub_0168
.aDdR  WeirdDone_0168
.bYtE   <WeirdStart_0168 , >WeirdStart_0168

   ; Weird Formatting Module 0169 - All Of This Should Normalize Cleanly   

     .OrG       $9900       
 .CoNsT      pPuCtRl_0169     =      $2000    
.cOnSt    ZeRoPaGe_0169=     $00f0

  WeirdStart_0169:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0169      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0169:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0169
	JsR       WeirdSub_0169
	JmP         WeirdDone_0169

WeirdSub_0169:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0169:
	NoP
	RtS

 WeirdTable_0169:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0169   ,   WeirdSub_0169
.aDdR  WeirdDone_0169
.bYtE   <WeirdStart_0169 , >WeirdStart_0169

   ; Weird Formatting Module 0170 - All Of This Should Normalize Cleanly   

     .OrG       $9a00       
 .CoNsT      pPuCtRl_0170     =      $2000    
.cOnSt    ZeRoPaGe_0170=     $00f0

  WeirdStart_0170:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0170      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0170:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0170
	JsR       WeirdSub_0170
	JmP         WeirdDone_0170

WeirdSub_0170:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0170:
	NoP
	RtS

 WeirdTable_0170:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0170   ,   WeirdSub_0170
.aDdR  WeirdDone_0170
.bYtE   <WeirdStart_0170 , >WeirdStart_0170

   ; Weird Formatting Module 0171 - All Of This Should Normalize Cleanly   

     .OrG       $9b00       
 .CoNsT      pPuCtRl_0171     =      $2000    
.cOnSt    ZeRoPaGe_0171=     $00f0

  WeirdStart_0171:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0171      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0171:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0171
	JsR       WeirdSub_0171
	JmP         WeirdDone_0171

WeirdSub_0171:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0171:
	NoP
	RtS

 WeirdTable_0171:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0171   ,   WeirdSub_0171
.aDdR  WeirdDone_0171
.bYtE   <WeirdStart_0171 , >WeirdStart_0171

   ; Weird Formatting Module 0172 - All Of This Should Normalize Cleanly   

     .OrG       $9c00       
 .CoNsT      pPuCtRl_0172     =      $2000    
.cOnSt    ZeRoPaGe_0172=     $00f0

  WeirdStart_0172:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0172      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0172:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0172
	JsR       WeirdSub_0172
	JmP         WeirdDone_0172

WeirdSub_0172:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0172:
	NoP
	RtS

 WeirdTable_0172:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0172   ,   WeirdSub_0172
.aDdR  WeirdDone_0172
.bYtE   <WeirdStart_0172 , >WeirdStart_0172

   ; Weird Formatting Module 0173 - All Of This Should Normalize Cleanly   

     .OrG       $9d00       
 .CoNsT      pPuCtRl_0173     =      $2000    
.cOnSt    ZeRoPaGe_0173=     $00f0

  WeirdStart_0173:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0173      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0173:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0173
	JsR       WeirdSub_0173
	JmP         WeirdDone_0173

WeirdSub_0173:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0173:
	NoP
	RtS

 WeirdTable_0173:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0173   ,   WeirdSub_0173
.aDdR  WeirdDone_0173
.bYtE   <WeirdStart_0173 , >WeirdStart_0173

   ; Weird Formatting Module 0174 - All Of This Should Normalize Cleanly   

     .OrG       $9e00       
 .CoNsT      pPuCtRl_0174     =      $2000    
.cOnSt    ZeRoPaGe_0174=     $00f0

  WeirdStart_0174:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0174      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0174:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0174
	JsR       WeirdSub_0174
	JmP         WeirdDone_0174

WeirdSub_0174:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0174:
	NoP
	RtS

 WeirdTable_0174:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0174   ,   WeirdSub_0174
.aDdR  WeirdDone_0174
.bYtE   <WeirdStart_0174 , >WeirdStart_0174

   ; Weird Formatting Module 0175 - All Of This Should Normalize Cleanly   

     .OrG       $9f00       
 .CoNsT      pPuCtRl_0175     =      $2000    
.cOnSt    ZeRoPaGe_0175=     $00f0

  WeirdStart_0175:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0175      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0175:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0175
	JsR       WeirdSub_0175
	JmP         WeirdDone_0175

WeirdSub_0175:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0175:
	NoP
	RtS

 WeirdTable_0175:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0175   ,   WeirdSub_0175
.aDdR  WeirdDone_0175
.bYtE   <WeirdStart_0175 , >WeirdStart_0175

   ; Weird Formatting Module 0176 - All Of This Should Normalize Cleanly   

     .OrG       $a000       
 .CoNsT      pPuCtRl_0176     =      $2000    
.cOnSt    ZeRoPaGe_0176=     $00f0

  WeirdStart_0176:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0176      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0176:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0176
	JsR       WeirdSub_0176
	JmP         WeirdDone_0176

WeirdSub_0176:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0176:
	NoP
	RtS

 WeirdTable_0176:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0176   ,   WeirdSub_0176
.aDdR  WeirdDone_0176
.bYtE   <WeirdStart_0176 , >WeirdStart_0176

   ; Weird Formatting Module 0177 - All Of This Should Normalize Cleanly   

     .OrG       $a100       
 .CoNsT      pPuCtRl_0177     =      $2000    
.cOnSt    ZeRoPaGe_0177=     $00f0

  WeirdStart_0177:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0177      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0177:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0177
	JsR       WeirdSub_0177
	JmP         WeirdDone_0177

WeirdSub_0177:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0177:
	NoP
	RtS

 WeirdTable_0177:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0177   ,   WeirdSub_0177
.aDdR  WeirdDone_0177
.bYtE   <WeirdStart_0177 , >WeirdStart_0177

   ; Weird Formatting Module 0178 - All Of This Should Normalize Cleanly   

     .OrG       $a200       
 .CoNsT      pPuCtRl_0178     =      $2000    
.cOnSt    ZeRoPaGe_0178=     $00f0

  WeirdStart_0178:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0178      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0178:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0178
	JsR       WeirdSub_0178
	JmP         WeirdDone_0178

WeirdSub_0178:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0178:
	NoP
	RtS

 WeirdTable_0178:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0178   ,   WeirdSub_0178
.aDdR  WeirdDone_0178
.bYtE   <WeirdStart_0178 , >WeirdStart_0178

   ; Weird Formatting Module 0179 - All Of This Should Normalize Cleanly   

     .OrG       $a300       
 .CoNsT      pPuCtRl_0179     =      $2000    
.cOnSt    ZeRoPaGe_0179=     $00f0

  WeirdStart_0179:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0179      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0179:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0179
	JsR       WeirdSub_0179
	JmP         WeirdDone_0179

WeirdSub_0179:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0179:
	NoP
	RtS

 WeirdTable_0179:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0179   ,   WeirdSub_0179
.aDdR  WeirdDone_0179
.bYtE   <WeirdStart_0179 , >WeirdStart_0179

   ; Weird Formatting Module 0180 - All Of This Should Normalize Cleanly   

     .OrG       $a400       
 .CoNsT      pPuCtRl_0180     =      $2000    
.cOnSt    ZeRoPaGe_0180=     $00f0

  WeirdStart_0180:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0180      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0180:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0180
	JsR       WeirdSub_0180
	JmP         WeirdDone_0180

WeirdSub_0180:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0180:
	NoP
	RtS

 WeirdTable_0180:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0180   ,   WeirdSub_0180
.aDdR  WeirdDone_0180
.bYtE   <WeirdStart_0180 , >WeirdStart_0180

   ; Weird Formatting Module 0181 - All Of This Should Normalize Cleanly   

     .OrG       $a500       
 .CoNsT      pPuCtRl_0181     =      $2000    
.cOnSt    ZeRoPaGe_0181=     $00f0

  WeirdStart_0181:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0181      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0181:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0181
	JsR       WeirdSub_0181
	JmP         WeirdDone_0181

WeirdSub_0181:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0181:
	NoP
	RtS

 WeirdTable_0181:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0181   ,   WeirdSub_0181
.aDdR  WeirdDone_0181
.bYtE   <WeirdStart_0181 , >WeirdStart_0181

   ; Weird Formatting Module 0182 - All Of This Should Normalize Cleanly   

     .OrG       $a600       
 .CoNsT      pPuCtRl_0182     =      $2000    
.cOnSt    ZeRoPaGe_0182=     $00f0

  WeirdStart_0182:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0182      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0182:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0182
	JsR       WeirdSub_0182
	JmP         WeirdDone_0182

WeirdSub_0182:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0182:
	NoP
	RtS

 WeirdTable_0182:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0182   ,   WeirdSub_0182
.aDdR  WeirdDone_0182
.bYtE   <WeirdStart_0182 , >WeirdStart_0182

   ; Weird Formatting Module 0183 - All Of This Should Normalize Cleanly   

     .OrG       $a700       
 .CoNsT      pPuCtRl_0183     =      $2000    
.cOnSt    ZeRoPaGe_0183=     $00f0

  WeirdStart_0183:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0183      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0183:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0183
	JsR       WeirdSub_0183
	JmP         WeirdDone_0183

WeirdSub_0183:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0183:
	NoP
	RtS

 WeirdTable_0183:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0183   ,   WeirdSub_0183
.aDdR  WeirdDone_0183
.bYtE   <WeirdStart_0183 , >WeirdStart_0183

   ; Weird Formatting Module 0184 - All Of This Should Normalize Cleanly   

     .OrG       $a800       
 .CoNsT      pPuCtRl_0184     =      $2000    
.cOnSt    ZeRoPaGe_0184=     $00f0

  WeirdStart_0184:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0184      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0184:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0184
	JsR       WeirdSub_0184
	JmP         WeirdDone_0184

WeirdSub_0184:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0184:
	NoP
	RtS

 WeirdTable_0184:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0184   ,   WeirdSub_0184
.aDdR  WeirdDone_0184
.bYtE   <WeirdStart_0184 , >WeirdStart_0184

   ; Weird Formatting Module 0185 - All Of This Should Normalize Cleanly   

     .OrG       $a900       
 .CoNsT      pPuCtRl_0185     =      $2000    
.cOnSt    ZeRoPaGe_0185=     $00f0

  WeirdStart_0185:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0185      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0185:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0185
	JsR       WeirdSub_0185
	JmP         WeirdDone_0185

WeirdSub_0185:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0185:
	NoP
	RtS

 WeirdTable_0185:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0185   ,   WeirdSub_0185
.aDdR  WeirdDone_0185
.bYtE   <WeirdStart_0185 , >WeirdStart_0185

   ; Weird Formatting Module 0186 - All Of This Should Normalize Cleanly   

     .OrG       $aa00       
 .CoNsT      pPuCtRl_0186     =      $2000    
.cOnSt    ZeRoPaGe_0186=     $00f0

  WeirdStart_0186:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0186      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0186:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0186
	JsR       WeirdSub_0186
	JmP         WeirdDone_0186

WeirdSub_0186:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0186:
	NoP
	RtS

 WeirdTable_0186:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0186   ,   WeirdSub_0186
.aDdR  WeirdDone_0186
.bYtE   <WeirdStart_0186 , >WeirdStart_0186

   ; Weird Formatting Module 0187 - All Of This Should Normalize Cleanly   

     .OrG       $ab00       
 .CoNsT      pPuCtRl_0187     =      $2000    
.cOnSt    ZeRoPaGe_0187=     $00f0

  WeirdStart_0187:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0187      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0187:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0187
	JsR       WeirdSub_0187
	JmP         WeirdDone_0187

WeirdSub_0187:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0187:
	NoP
	RtS

 WeirdTable_0187:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0187   ,   WeirdSub_0187
.aDdR  WeirdDone_0187
.bYtE   <WeirdStart_0187 , >WeirdStart_0187

   ; Weird Formatting Module 0188 - All Of This Should Normalize Cleanly   

     .OrG       $ac00       
 .CoNsT      pPuCtRl_0188     =      $2000    
.cOnSt    ZeRoPaGe_0188=     $00f0

  WeirdStart_0188:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0188      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0188:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0188
	JsR       WeirdSub_0188
	JmP         WeirdDone_0188

WeirdSub_0188:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0188:
	NoP
	RtS

 WeirdTable_0188:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0188   ,   WeirdSub_0188
.aDdR  WeirdDone_0188
.bYtE   <WeirdStart_0188 , >WeirdStart_0188

   ; Weird Formatting Module 0189 - All Of This Should Normalize Cleanly   

     .OrG       $ad00       
 .CoNsT      pPuCtRl_0189     =      $2000    
.cOnSt    ZeRoPaGe_0189=     $00f0

  WeirdStart_0189:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0189      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0189:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0189
	JsR       WeirdSub_0189
	JmP         WeirdDone_0189

WeirdSub_0189:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0189:
	NoP
	RtS

 WeirdTable_0189:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0189   ,   WeirdSub_0189
.aDdR  WeirdDone_0189
.bYtE   <WeirdStart_0189 , >WeirdStart_0189

   ; Weird Formatting Module 0190 - All Of This Should Normalize Cleanly   

     .OrG       $ae00       
 .CoNsT      pPuCtRl_0190     =      $2000    
.cOnSt    ZeRoPaGe_0190=     $00f0

  WeirdStart_0190:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0190      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0190:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0190
	JsR       WeirdSub_0190
	JmP         WeirdDone_0190

WeirdSub_0190:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0190:
	NoP
	RtS

 WeirdTable_0190:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0190   ,   WeirdSub_0190
.aDdR  WeirdDone_0190
.bYtE   <WeirdStart_0190 , >WeirdStart_0190

   ; Weird Formatting Module 0191 - All Of This Should Normalize Cleanly   

     .OrG       $af00       
 .CoNsT      pPuCtRl_0191     =      $2000    
.cOnSt    ZeRoPaGe_0191=     $00f0

  WeirdStart_0191:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0191      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0191:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0191
	JsR       WeirdSub_0191
	JmP         WeirdDone_0191

WeirdSub_0191:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0191:
	NoP
	RtS

 WeirdTable_0191:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0191   ,   WeirdSub_0191
.aDdR  WeirdDone_0191
.bYtE   <WeirdStart_0191 , >WeirdStart_0191

   ; Weird Formatting Module 0192 - All Of This Should Normalize Cleanly   

     .OrG       $b000       
 .CoNsT      pPuCtRl_0192     =      $2000    
.cOnSt    ZeRoPaGe_0192=     $00f0

  WeirdStart_0192:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0192      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0192:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0192
	JsR       WeirdSub_0192
	JmP         WeirdDone_0192

WeirdSub_0192:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0192:
	NoP
	RtS

 WeirdTable_0192:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0192   ,   WeirdSub_0192
.aDdR  WeirdDone_0192
.bYtE   <WeirdStart_0192 , >WeirdStart_0192

   ; Weird Formatting Module 0193 - All Of This Should Normalize Cleanly   

     .OrG       $b100       
 .CoNsT      pPuCtRl_0193     =      $2000    
.cOnSt    ZeRoPaGe_0193=     $00f0

  WeirdStart_0193:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0193      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0193:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0193
	JsR       WeirdSub_0193
	JmP         WeirdDone_0193

WeirdSub_0193:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0193:
	NoP
	RtS

 WeirdTable_0193:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0193   ,   WeirdSub_0193
.aDdR  WeirdDone_0193
.bYtE   <WeirdStart_0193 , >WeirdStart_0193

   ; Weird Formatting Module 0194 - All Of This Should Normalize Cleanly   

     .OrG       $b200       
 .CoNsT      pPuCtRl_0194     =      $2000    
.cOnSt    ZeRoPaGe_0194=     $00f0

  WeirdStart_0194:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0194      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0194:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0194
	JsR       WeirdSub_0194
	JmP         WeirdDone_0194

WeirdSub_0194:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0194:
	NoP
	RtS

 WeirdTable_0194:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0194   ,   WeirdSub_0194
.aDdR  WeirdDone_0194
.bYtE   <WeirdStart_0194 , >WeirdStart_0194

   ; Weird Formatting Module 0195 - All Of This Should Normalize Cleanly   

     .OrG       $b300       
 .CoNsT      pPuCtRl_0195     =      $2000    
.cOnSt    ZeRoPaGe_0195=     $00f0

  WeirdStart_0195:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0195      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0195:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0195
	JsR       WeirdSub_0195
	JmP         WeirdDone_0195

WeirdSub_0195:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0195:
	NoP
	RtS

 WeirdTable_0195:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0195   ,   WeirdSub_0195
.aDdR  WeirdDone_0195
.bYtE   <WeirdStart_0195 , >WeirdStart_0195

   ; Weird Formatting Module 0196 - All Of This Should Normalize Cleanly   

     .OrG       $b400       
 .CoNsT      pPuCtRl_0196     =      $2000    
.cOnSt    ZeRoPaGe_0196=     $00f0

  WeirdStart_0196:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0196      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0196:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0196
	JsR       WeirdSub_0196
	JmP         WeirdDone_0196

WeirdSub_0196:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0196:
	NoP
	RtS

 WeirdTable_0196:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0196   ,   WeirdSub_0196
.aDdR  WeirdDone_0196
.bYtE   <WeirdStart_0196 , >WeirdStart_0196

   ; Weird Formatting Module 0197 - All Of This Should Normalize Cleanly   

     .OrG       $b500       
 .CoNsT      pPuCtRl_0197     =      $2000    
.cOnSt    ZeRoPaGe_0197=     $00f0

  WeirdStart_0197:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0197      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0197:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0197
	JsR       WeirdSub_0197
	JmP         WeirdDone_0197

WeirdSub_0197:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0197:
	NoP
	RtS

 WeirdTable_0197:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0197   ,   WeirdSub_0197
.aDdR  WeirdDone_0197
.bYtE   <WeirdStart_0197 , >WeirdStart_0197

   ; Weird Formatting Module 0198 - All Of This Should Normalize Cleanly   

     .OrG       $b600       
 .CoNsT      pPuCtRl_0198     =      $2000    
.cOnSt    ZeRoPaGe_0198=     $00f0

  WeirdStart_0198:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0198      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0198:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0198
	JsR       WeirdSub_0198
	JmP         WeirdDone_0198

WeirdSub_0198:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0198:
	NoP
	RtS

 WeirdTable_0198:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0198   ,   WeirdSub_0198
.aDdR  WeirdDone_0198
.bYtE   <WeirdStart_0198 , >WeirdStart_0198

   ; Weird Formatting Module 0199 - All Of This Should Normalize Cleanly   

     .OrG       $b700       
 .CoNsT      pPuCtRl_0199     =      $2000    
.cOnSt    ZeRoPaGe_0199=     $00f0

  WeirdStart_0199:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0199      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0199:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0199
	JsR       WeirdSub_0199
	JmP         WeirdDone_0199

WeirdSub_0199:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0199:
	NoP
	RtS

 WeirdTable_0199:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0199   ,   WeirdSub_0199
.aDdR  WeirdDone_0199
.bYtE   <WeirdStart_0199 , >WeirdStart_0199

   ; Weird Formatting Module 0200 - All Of This Should Normalize Cleanly   

     .OrG       $b800       
 .CoNsT      pPuCtRl_0200     =      $2000    
.cOnSt    ZeRoPaGe_0200=     $00f0

  WeirdStart_0200:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0200      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0200:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0200
	JsR       WeirdSub_0200
	JmP         WeirdDone_0200

WeirdSub_0200:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0200:
	NoP
	RtS

 WeirdTable_0200:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0200   ,   WeirdSub_0200
.aDdR  WeirdDone_0200
.bYtE   <WeirdStart_0200 , >WeirdStart_0200

   ; Weird Formatting Module 0201 - All Of This Should Normalize Cleanly   

     .OrG       $b900       
 .CoNsT      pPuCtRl_0201     =      $2000    
.cOnSt    ZeRoPaGe_0201=     $00f0

  WeirdStart_0201:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0201      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0201:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0201
	JsR       WeirdSub_0201
	JmP         WeirdDone_0201

WeirdSub_0201:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0201:
	NoP
	RtS

 WeirdTable_0201:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0201   ,   WeirdSub_0201
.aDdR  WeirdDone_0201
.bYtE   <WeirdStart_0201 , >WeirdStart_0201

   ; Weird Formatting Module 0202 - All Of This Should Normalize Cleanly   

     .OrG       $ba00       
 .CoNsT      pPuCtRl_0202     =      $2000    
.cOnSt    ZeRoPaGe_0202=     $00f0

  WeirdStart_0202:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0202      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0202:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0202
	JsR       WeirdSub_0202
	JmP         WeirdDone_0202

WeirdSub_0202:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0202:
	NoP
	RtS

 WeirdTable_0202:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0202   ,   WeirdSub_0202
.aDdR  WeirdDone_0202
.bYtE   <WeirdStart_0202 , >WeirdStart_0202

   ; Weird Formatting Module 0203 - All Of This Should Normalize Cleanly   

     .OrG       $bb00       
 .CoNsT      pPuCtRl_0203     =      $2000    
.cOnSt    ZeRoPaGe_0203=     $00f0

  WeirdStart_0203:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0203      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0203:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0203
	JsR       WeirdSub_0203
	JmP         WeirdDone_0203

WeirdSub_0203:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0203:
	NoP
	RtS

 WeirdTable_0203:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0203   ,   WeirdSub_0203
.aDdR  WeirdDone_0203
.bYtE   <WeirdStart_0203 , >WeirdStart_0203

   ; Weird Formatting Module 0204 - All Of This Should Normalize Cleanly   

     .OrG       $bc00       
 .CoNsT      pPuCtRl_0204     =      $2000    
.cOnSt    ZeRoPaGe_0204=     $00f0

  WeirdStart_0204:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0204      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0204:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0204
	JsR       WeirdSub_0204
	JmP         WeirdDone_0204

WeirdSub_0204:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0204:
	NoP
	RtS

 WeirdTable_0204:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0204   ,   WeirdSub_0204
.aDdR  WeirdDone_0204
.bYtE   <WeirdStart_0204 , >WeirdStart_0204

   ; Weird Formatting Module 0205 - All Of This Should Normalize Cleanly   

     .OrG       $bd00       
 .CoNsT      pPuCtRl_0205     =      $2000    
.cOnSt    ZeRoPaGe_0205=     $00f0

  WeirdStart_0205:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0205      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0205:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0205
	JsR       WeirdSub_0205
	JmP         WeirdDone_0205

WeirdSub_0205:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0205:
	NoP
	RtS

 WeirdTable_0205:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0205   ,   WeirdSub_0205
.aDdR  WeirdDone_0205
.bYtE   <WeirdStart_0205 , >WeirdStart_0205

   ; Weird Formatting Module 0206 - All Of This Should Normalize Cleanly   

     .OrG       $be00       
 .CoNsT      pPuCtRl_0206     =      $2000    
.cOnSt    ZeRoPaGe_0206=     $00f0

  WeirdStart_0206:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0206      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0206:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0206
	JsR       WeirdSub_0206
	JmP         WeirdDone_0206

WeirdSub_0206:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0206:
	NoP
	RtS

 WeirdTable_0206:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0206   ,   WeirdSub_0206
.aDdR  WeirdDone_0206
.bYtE   <WeirdStart_0206 , >WeirdStart_0206

   ; Weird Formatting Module 0207 - All Of This Should Normalize Cleanly   

     .OrG       $bf00       
 .CoNsT      pPuCtRl_0207     =      $2000    
.cOnSt    ZeRoPaGe_0207=     $00f0

  WeirdStart_0207:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0207      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0207:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0207
	JsR       WeirdSub_0207
	JmP         WeirdDone_0207

WeirdSub_0207:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0207:
	NoP
	RtS

 WeirdTable_0207:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0207   ,   WeirdSub_0207
.aDdR  WeirdDone_0207
.bYtE   <WeirdStart_0207 , >WeirdStart_0207

   ; Weird Formatting Module 0208 - All Of This Should Normalize Cleanly   

     .OrG       $c000       
 .CoNsT      pPuCtRl_0208     =      $2000    
.cOnSt    ZeRoPaGe_0208=     $00f0

  WeirdStart_0208:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0208      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0208:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0208
	JsR       WeirdSub_0208
	JmP         WeirdDone_0208

WeirdSub_0208:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0208:
	NoP
	RtS

 WeirdTable_0208:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0208   ,   WeirdSub_0208
.aDdR  WeirdDone_0208
.bYtE   <WeirdStart_0208 , >WeirdStart_0208

   ; Weird Formatting Module 0209 - All Of This Should Normalize Cleanly   

     .OrG       $c100       
 .CoNsT      pPuCtRl_0209     =      $2000    
.cOnSt    ZeRoPaGe_0209=     $00f0

  WeirdStart_0209:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0209      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0209:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0209
	JsR       WeirdSub_0209
	JmP         WeirdDone_0209

WeirdSub_0209:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0209:
	NoP
	RtS

 WeirdTable_0209:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0209   ,   WeirdSub_0209
.aDdR  WeirdDone_0209
.bYtE   <WeirdStart_0209 , >WeirdStart_0209

   ; Weird Formatting Module 0210 - All Of This Should Normalize Cleanly   

     .OrG       $c200       
 .CoNsT      pPuCtRl_0210     =      $2000    
.cOnSt    ZeRoPaGe_0210=     $00f0

  WeirdStart_0210:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0210      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0210:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0210
	JsR       WeirdSub_0210
	JmP         WeirdDone_0210

WeirdSub_0210:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0210:
	NoP
	RtS

 WeirdTable_0210:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0210   ,   WeirdSub_0210
.aDdR  WeirdDone_0210
.bYtE   <WeirdStart_0210 , >WeirdStart_0210

   ; Weird Formatting Module 0211 - All Of This Should Normalize Cleanly   

     .OrG       $c300       
 .CoNsT      pPuCtRl_0211     =      $2000    
.cOnSt    ZeRoPaGe_0211=     $00f0

  WeirdStart_0211:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0211      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0211:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0211
	JsR       WeirdSub_0211
	JmP         WeirdDone_0211

WeirdSub_0211:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0211:
	NoP
	RtS

 WeirdTable_0211:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0211   ,   WeirdSub_0211
.aDdR  WeirdDone_0211
.bYtE   <WeirdStart_0211 , >WeirdStart_0211

   ; Weird Formatting Module 0212 - All Of This Should Normalize Cleanly   

     .OrG       $c400       
 .CoNsT      pPuCtRl_0212     =      $2000    
.cOnSt    ZeRoPaGe_0212=     $00f0

  WeirdStart_0212:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0212      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0212:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0212
	JsR       WeirdSub_0212
	JmP         WeirdDone_0212

WeirdSub_0212:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0212:
	NoP
	RtS

 WeirdTable_0212:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0212   ,   WeirdSub_0212
.aDdR  WeirdDone_0212
.bYtE   <WeirdStart_0212 , >WeirdStart_0212

   ; Weird Formatting Module 0213 - All Of This Should Normalize Cleanly   

     .OrG       $c500       
 .CoNsT      pPuCtRl_0213     =      $2000    
.cOnSt    ZeRoPaGe_0213=     $00f0

  WeirdStart_0213:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0213      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0213:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0213
	JsR       WeirdSub_0213
	JmP         WeirdDone_0213

WeirdSub_0213:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0213:
	NoP
	RtS

 WeirdTable_0213:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0213   ,   WeirdSub_0213
.aDdR  WeirdDone_0213
.bYtE   <WeirdStart_0213 , >WeirdStart_0213

   ; Weird Formatting Module 0214 - All Of This Should Normalize Cleanly   

     .OrG       $c600       
 .CoNsT      pPuCtRl_0214     =      $2000    
.cOnSt    ZeRoPaGe_0214=     $00f0

  WeirdStart_0214:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0214      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0214:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0214
	JsR       WeirdSub_0214
	JmP         WeirdDone_0214

WeirdSub_0214:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0214:
	NoP
	RtS

 WeirdTable_0214:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0214   ,   WeirdSub_0214
.aDdR  WeirdDone_0214
.bYtE   <WeirdStart_0214 , >WeirdStart_0214

   ; Weird Formatting Module 0215 - All Of This Should Normalize Cleanly   

     .OrG       $c700       
 .CoNsT      pPuCtRl_0215     =      $2000    
.cOnSt    ZeRoPaGe_0215=     $00f0

  WeirdStart_0215:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0215      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0215:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0215
	JsR       WeirdSub_0215
	JmP         WeirdDone_0215

WeirdSub_0215:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0215:
	NoP
	RtS

 WeirdTable_0215:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0215   ,   WeirdSub_0215
.aDdR  WeirdDone_0215
.bYtE   <WeirdStart_0215 , >WeirdStart_0215

   ; Weird Formatting Module 0216 - All Of This Should Normalize Cleanly   

     .OrG       $c800       
 .CoNsT      pPuCtRl_0216     =      $2000    
.cOnSt    ZeRoPaGe_0216=     $00f0

  WeirdStart_0216:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0216      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0216:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0216
	JsR       WeirdSub_0216
	JmP         WeirdDone_0216

WeirdSub_0216:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0216:
	NoP
	RtS

 WeirdTable_0216:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0216   ,   WeirdSub_0216
.aDdR  WeirdDone_0216
.bYtE   <WeirdStart_0216 , >WeirdStart_0216

   ; Weird Formatting Module 0217 - All Of This Should Normalize Cleanly   

     .OrG       $c900       
 .CoNsT      pPuCtRl_0217     =      $2000    
.cOnSt    ZeRoPaGe_0217=     $00f0

  WeirdStart_0217:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0217      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0217:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0217
	JsR       WeirdSub_0217
	JmP         WeirdDone_0217

WeirdSub_0217:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0217:
	NoP
	RtS

 WeirdTable_0217:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0217   ,   WeirdSub_0217
.aDdR  WeirdDone_0217
.bYtE   <WeirdStart_0217 , >WeirdStart_0217

   ; Weird Formatting Module 0218 - All Of This Should Normalize Cleanly   

     .OrG       $ca00       
 .CoNsT      pPuCtRl_0218     =      $2000    
.cOnSt    ZeRoPaGe_0218=     $00f0

  WeirdStart_0218:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0218      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0218:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0218
	JsR       WeirdSub_0218
	JmP         WeirdDone_0218

WeirdSub_0218:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0218:
	NoP
	RtS

 WeirdTable_0218:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0218   ,   WeirdSub_0218
.aDdR  WeirdDone_0218
.bYtE   <WeirdStart_0218 , >WeirdStart_0218

   ; Weird Formatting Module 0219 - All Of This Should Normalize Cleanly   

     .OrG       $cb00       
 .CoNsT      pPuCtRl_0219     =      $2000    
.cOnSt    ZeRoPaGe_0219=     $00f0

  WeirdStart_0219:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0219      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0219:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0219
	JsR       WeirdSub_0219
	JmP         WeirdDone_0219

WeirdSub_0219:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0219:
	NoP
	RtS

 WeirdTable_0219:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0219   ,   WeirdSub_0219
.aDdR  WeirdDone_0219
.bYtE   <WeirdStart_0219 , >WeirdStart_0219

   ; Weird Formatting Module 0220 - All Of This Should Normalize Cleanly   

     .OrG       $cc00       
 .CoNsT      pPuCtRl_0220     =      $2000    
.cOnSt    ZeRoPaGe_0220=     $00f0

  WeirdStart_0220:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0220      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0220:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0220
	JsR       WeirdSub_0220
	JmP         WeirdDone_0220

WeirdSub_0220:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0220:
	NoP
	RtS

 WeirdTable_0220:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0220   ,   WeirdSub_0220
.aDdR  WeirdDone_0220
.bYtE   <WeirdStart_0220 , >WeirdStart_0220

   ; Weird Formatting Module 0221 - All Of This Should Normalize Cleanly   

     .OrG       $cd00       
 .CoNsT      pPuCtRl_0221     =      $2000    
.cOnSt    ZeRoPaGe_0221=     $00f0

  WeirdStart_0221:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0221      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0221:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0221
	JsR       WeirdSub_0221
	JmP         WeirdDone_0221

WeirdSub_0221:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0221:
	NoP
	RtS

 WeirdTable_0221:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0221   ,   WeirdSub_0221
.aDdR  WeirdDone_0221
.bYtE   <WeirdStart_0221 , >WeirdStart_0221

   ; Weird Formatting Module 0222 - All Of This Should Normalize Cleanly   

     .OrG       $ce00       
 .CoNsT      pPuCtRl_0222     =      $2000    
.cOnSt    ZeRoPaGe_0222=     $00f0

  WeirdStart_0222:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0222      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0222:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0222
	JsR       WeirdSub_0222
	JmP         WeirdDone_0222

WeirdSub_0222:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0222:
	NoP
	RtS

 WeirdTable_0222:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0222   ,   WeirdSub_0222
.aDdR  WeirdDone_0222
.bYtE   <WeirdStart_0222 , >WeirdStart_0222

   ; Weird Formatting Module 0223 - All Of This Should Normalize Cleanly   

     .OrG       $cf00       
 .CoNsT      pPuCtRl_0223     =      $2000    
.cOnSt    ZeRoPaGe_0223=     $00f0

  WeirdStart_0223:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0223      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0223:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0223
	JsR       WeirdSub_0223
	JmP         WeirdDone_0223

WeirdSub_0223:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0223:
	NoP
	RtS

 WeirdTable_0223:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0223   ,   WeirdSub_0223
.aDdR  WeirdDone_0223
.bYtE   <WeirdStart_0223 , >WeirdStart_0223

   ; Weird Formatting Module 0224 - All Of This Should Normalize Cleanly   

     .OrG       $d000       
 .CoNsT      pPuCtRl_0224     =      $2000    
.cOnSt    ZeRoPaGe_0224=     $00f0

  WeirdStart_0224:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0224      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0224:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0224
	JsR       WeirdSub_0224
	JmP         WeirdDone_0224

WeirdSub_0224:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0224:
	NoP
	RtS

 WeirdTable_0224:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0224   ,   WeirdSub_0224
.aDdR  WeirdDone_0224
.bYtE   <WeirdStart_0224 , >WeirdStart_0224

   ; Weird Formatting Module 0225 - All Of This Should Normalize Cleanly   

     .OrG       $d100       
 .CoNsT      pPuCtRl_0225     =      $2000    
.cOnSt    ZeRoPaGe_0225=     $00f0

  WeirdStart_0225:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0225      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0225:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0225
	JsR       WeirdSub_0225
	JmP         WeirdDone_0225

WeirdSub_0225:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0225:
	NoP
	RtS

 WeirdTable_0225:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0225   ,   WeirdSub_0225
.aDdR  WeirdDone_0225
.bYtE   <WeirdStart_0225 , >WeirdStart_0225

   ; Weird Formatting Module 0226 - All Of This Should Normalize Cleanly   

     .OrG       $d200       
 .CoNsT      pPuCtRl_0226     =      $2000    
.cOnSt    ZeRoPaGe_0226=     $00f0

  WeirdStart_0226:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0226      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0226:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0226
	JsR       WeirdSub_0226
	JmP         WeirdDone_0226

WeirdSub_0226:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0226:
	NoP
	RtS

 WeirdTable_0226:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0226   ,   WeirdSub_0226
.aDdR  WeirdDone_0226
.bYtE   <WeirdStart_0226 , >WeirdStart_0226

   ; Weird Formatting Module 0227 - All Of This Should Normalize Cleanly   

     .OrG       $d300       
 .CoNsT      pPuCtRl_0227     =      $2000    
.cOnSt    ZeRoPaGe_0227=     $00f0

  WeirdStart_0227:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0227      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0227:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0227
	JsR       WeirdSub_0227
	JmP         WeirdDone_0227

WeirdSub_0227:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0227:
	NoP
	RtS

 WeirdTable_0227:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0227   ,   WeirdSub_0227
.aDdR  WeirdDone_0227
.bYtE   <WeirdStart_0227 , >WeirdStart_0227

   ; Weird Formatting Module 0228 - All Of This Should Normalize Cleanly   

     .OrG       $d400       
 .CoNsT      pPuCtRl_0228     =      $2000    
.cOnSt    ZeRoPaGe_0228=     $00f0

  WeirdStart_0228:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0228      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0228:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0228
	JsR       WeirdSub_0228
	JmP         WeirdDone_0228

WeirdSub_0228:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0228:
	NoP
	RtS

 WeirdTable_0228:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0228   ,   WeirdSub_0228
.aDdR  WeirdDone_0228
.bYtE   <WeirdStart_0228 , >WeirdStart_0228

   ; Weird Formatting Module 0229 - All Of This Should Normalize Cleanly   

     .OrG       $d500       
 .CoNsT      pPuCtRl_0229     =      $2000    
.cOnSt    ZeRoPaGe_0229=     $00f0

  WeirdStart_0229:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0229      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0229:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0229
	JsR       WeirdSub_0229
	JmP         WeirdDone_0229

WeirdSub_0229:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0229:
	NoP
	RtS

 WeirdTable_0229:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0229   ,   WeirdSub_0229
.aDdR  WeirdDone_0229
.bYtE   <WeirdStart_0229 , >WeirdStart_0229

   ; Weird Formatting Module 0230 - All Of This Should Normalize Cleanly   

     .OrG       $d600       
 .CoNsT      pPuCtRl_0230     =      $2000    
.cOnSt    ZeRoPaGe_0230=     $00f0

  WeirdStart_0230:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0230      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0230:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0230
	JsR       WeirdSub_0230
	JmP         WeirdDone_0230

WeirdSub_0230:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0230:
	NoP
	RtS

 WeirdTable_0230:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0230   ,   WeirdSub_0230
.aDdR  WeirdDone_0230
.bYtE   <WeirdStart_0230 , >WeirdStart_0230

   ; Weird Formatting Module 0231 - All Of This Should Normalize Cleanly   

     .OrG       $d700       
 .CoNsT      pPuCtRl_0231     =      $2000    
.cOnSt    ZeRoPaGe_0231=     $00f0

  WeirdStart_0231:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0231      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0231:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0231
	JsR       WeirdSub_0231
	JmP         WeirdDone_0231

WeirdSub_0231:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0231:
	NoP
	RtS

 WeirdTable_0231:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0231   ,   WeirdSub_0231
.aDdR  WeirdDone_0231
.bYtE   <WeirdStart_0231 , >WeirdStart_0231

   ; Weird Formatting Module 0232 - All Of This Should Normalize Cleanly   

     .OrG       $d800       
 .CoNsT      pPuCtRl_0232     =      $2000    
.cOnSt    ZeRoPaGe_0232=     $00f0

  WeirdStart_0232:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0232      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0232:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0232
	JsR       WeirdSub_0232
	JmP         WeirdDone_0232

WeirdSub_0232:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0232:
	NoP
	RtS

 WeirdTable_0232:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0232   ,   WeirdSub_0232
.aDdR  WeirdDone_0232
.bYtE   <WeirdStart_0232 , >WeirdStart_0232

   ; Weird Formatting Module 0233 - All Of This Should Normalize Cleanly   

     .OrG       $d900       
 .CoNsT      pPuCtRl_0233     =      $2000    
.cOnSt    ZeRoPaGe_0233=     $00f0

  WeirdStart_0233:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0233      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0233:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0233
	JsR       WeirdSub_0233
	JmP         WeirdDone_0233

WeirdSub_0233:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0233:
	NoP
	RtS

 WeirdTable_0233:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0233   ,   WeirdSub_0233
.aDdR  WeirdDone_0233
.bYtE   <WeirdStart_0233 , >WeirdStart_0233

   ; Weird Formatting Module 0234 - All Of This Should Normalize Cleanly   

     .OrG       $da00       
 .CoNsT      pPuCtRl_0234     =      $2000    
.cOnSt    ZeRoPaGe_0234=     $00f0

  WeirdStart_0234:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0234      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0234:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0234
	JsR       WeirdSub_0234
	JmP         WeirdDone_0234

WeirdSub_0234:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0234:
	NoP
	RtS

 WeirdTable_0234:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0234   ,   WeirdSub_0234
.aDdR  WeirdDone_0234
.bYtE   <WeirdStart_0234 , >WeirdStart_0234

   ; Weird Formatting Module 0235 - All Of This Should Normalize Cleanly   

     .OrG       $db00       
 .CoNsT      pPuCtRl_0235     =      $2000    
.cOnSt    ZeRoPaGe_0235=     $00f0

  WeirdStart_0235:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0235      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0235:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0235
	JsR       WeirdSub_0235
	JmP         WeirdDone_0235

WeirdSub_0235:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0235:
	NoP
	RtS

 WeirdTable_0235:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0235   ,   WeirdSub_0235
.aDdR  WeirdDone_0235
.bYtE   <WeirdStart_0235 , >WeirdStart_0235

   ; Weird Formatting Module 0236 - All Of This Should Normalize Cleanly   

     .OrG       $dc00       
 .CoNsT      pPuCtRl_0236     =      $2000    
.cOnSt    ZeRoPaGe_0236=     $00f0

  WeirdStart_0236:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0236      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0236:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0236
	JsR       WeirdSub_0236
	JmP         WeirdDone_0236

WeirdSub_0236:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0236:
	NoP
	RtS

 WeirdTable_0236:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0236   ,   WeirdSub_0236
.aDdR  WeirdDone_0236
.bYtE   <WeirdStart_0236 , >WeirdStart_0236

   ; Weird Formatting Module 0237 - All Of This Should Normalize Cleanly   

     .OrG       $dd00       
 .CoNsT      pPuCtRl_0237     =      $2000    
.cOnSt    ZeRoPaGe_0237=     $00f0

  WeirdStart_0237:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0237      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0237:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0237
	JsR       WeirdSub_0237
	JmP         WeirdDone_0237

WeirdSub_0237:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0237:
	NoP
	RtS

 WeirdTable_0237:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0237   ,   WeirdSub_0237
.aDdR  WeirdDone_0237
.bYtE   <WeirdStart_0237 , >WeirdStart_0237

   ; Weird Formatting Module 0238 - All Of This Should Normalize Cleanly   

     .OrG       $de00       
 .CoNsT      pPuCtRl_0238     =      $2000    
.cOnSt    ZeRoPaGe_0238=     $00f0

  WeirdStart_0238:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0238      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0238:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0238
	JsR       WeirdSub_0238
	JmP         WeirdDone_0238

WeirdSub_0238:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0238:
	NoP
	RtS

 WeirdTable_0238:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0238   ,   WeirdSub_0238
.aDdR  WeirdDone_0238
.bYtE   <WeirdStart_0238 , >WeirdStart_0238

   ; Weird Formatting Module 0239 - All Of This Should Normalize Cleanly   

     .OrG       $df00       
 .CoNsT      pPuCtRl_0239     =      $2000    
.cOnSt    ZeRoPaGe_0239=     $00f0

  WeirdStart_0239:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0239      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0239:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0239
	JsR       WeirdSub_0239
	JmP         WeirdDone_0239

WeirdSub_0239:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0239:
	NoP
	RtS

 WeirdTable_0239:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0239   ,   WeirdSub_0239
.aDdR  WeirdDone_0239
.bYtE   <WeirdStart_0239 , >WeirdStart_0239

   ; Weird Formatting Module 0240 - All Of This Should Normalize Cleanly   

     .OrG       $9000       
 .CoNsT      pPuCtRl_0240     =      $2000    
.cOnSt    ZeRoPaGe_0240=     $00f0

  WeirdStart_0240:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0240      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0240:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0240
	JsR       WeirdSub_0240
	JmP         WeirdDone_0240

WeirdSub_0240:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0240:
	NoP
	RtS

 WeirdTable_0240:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0240   ,   WeirdSub_0240
.aDdR  WeirdDone_0240
.bYtE   <WeirdStart_0240 , >WeirdStart_0240

   ; Weird Formatting Module 0241 - All Of This Should Normalize Cleanly   

     .OrG       $9100       
 .CoNsT      pPuCtRl_0241     =      $2000    
.cOnSt    ZeRoPaGe_0241=     $00f0

  WeirdStart_0241:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0241      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0241:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0241
	JsR       WeirdSub_0241
	JmP         WeirdDone_0241

WeirdSub_0241:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0241:
	NoP
	RtS

 WeirdTable_0241:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0241   ,   WeirdSub_0241
.aDdR  WeirdDone_0241
.bYtE   <WeirdStart_0241 , >WeirdStart_0241

   ; Weird Formatting Module 0242 - All Of This Should Normalize Cleanly   

     .OrG       $9200       
 .CoNsT      pPuCtRl_0242     =      $2000    
.cOnSt    ZeRoPaGe_0242=     $00f0

  WeirdStart_0242:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0242      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0242:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0242
	JsR       WeirdSub_0242
	JmP         WeirdDone_0242

WeirdSub_0242:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0242:
	NoP
	RtS

 WeirdTable_0242:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0242   ,   WeirdSub_0242
.aDdR  WeirdDone_0242
.bYtE   <WeirdStart_0242 , >WeirdStart_0242

   ; Weird Formatting Module 0243 - All Of This Should Normalize Cleanly   

     .OrG       $9300       
 .CoNsT      pPuCtRl_0243     =      $2000    
.cOnSt    ZeRoPaGe_0243=     $00f0

  WeirdStart_0243:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0243      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0243:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0243
	JsR       WeirdSub_0243
	JmP         WeirdDone_0243

WeirdSub_0243:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0243:
	NoP
	RtS

 WeirdTable_0243:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0243   ,   WeirdSub_0243
.aDdR  WeirdDone_0243
.bYtE   <WeirdStart_0243 , >WeirdStart_0243

   ; Weird Formatting Module 0244 - All Of This Should Normalize Cleanly   

     .OrG       $9400       
 .CoNsT      pPuCtRl_0244     =      $2000    
.cOnSt    ZeRoPaGe_0244=     $00f0

  WeirdStart_0244:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0244      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0244:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0244
	JsR       WeirdSub_0244
	JmP         WeirdDone_0244

WeirdSub_0244:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0244:
	NoP
	RtS

 WeirdTable_0244:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0244   ,   WeirdSub_0244
.aDdR  WeirdDone_0244
.bYtE   <WeirdStart_0244 , >WeirdStart_0244

   ; Weird Formatting Module 0245 - All Of This Should Normalize Cleanly   

     .OrG       $9500       
 .CoNsT      pPuCtRl_0245     =      $2000    
.cOnSt    ZeRoPaGe_0245=     $00f0

  WeirdStart_0245:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0245      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0245:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0245
	JsR       WeirdSub_0245
	JmP         WeirdDone_0245

WeirdSub_0245:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0245:
	NoP
	RtS

 WeirdTable_0245:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0245   ,   WeirdSub_0245
.aDdR  WeirdDone_0245
.bYtE   <WeirdStart_0245 , >WeirdStart_0245

   ; Weird Formatting Module 0246 - All Of This Should Normalize Cleanly   

     .OrG       $9600       
 .CoNsT      pPuCtRl_0246     =      $2000    
.cOnSt    ZeRoPaGe_0246=     $00f0

  WeirdStart_0246:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0246      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0246:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0246
	JsR       WeirdSub_0246
	JmP         WeirdDone_0246

WeirdSub_0246:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0246:
	NoP
	RtS

 WeirdTable_0246:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0246   ,   WeirdSub_0246
.aDdR  WeirdDone_0246
.bYtE   <WeirdStart_0246 , >WeirdStart_0246

   ; Weird Formatting Module 0247 - All Of This Should Normalize Cleanly   

     .OrG       $9700       
 .CoNsT      pPuCtRl_0247     =      $2000    
.cOnSt    ZeRoPaGe_0247=     $00f0

  WeirdStart_0247:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0247      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0247:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0247
	JsR       WeirdSub_0247
	JmP         WeirdDone_0247

WeirdSub_0247:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0247:
	NoP
	RtS

 WeirdTable_0247:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0247   ,   WeirdSub_0247
.aDdR  WeirdDone_0247
.bYtE   <WeirdStart_0247 , >WeirdStart_0247

   ; Weird Formatting Module 0248 - All Of This Should Normalize Cleanly   

     .OrG       $9800       
 .CoNsT      pPuCtRl_0248     =      $2000    
.cOnSt    ZeRoPaGe_0248=     $00f0

  WeirdStart_0248:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0248      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0248:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0248
	JsR       WeirdSub_0248
	JmP         WeirdDone_0248

WeirdSub_0248:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0248:
	NoP
	RtS

 WeirdTable_0248:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0248   ,   WeirdSub_0248
.aDdR  WeirdDone_0248
.bYtE   <WeirdStart_0248 , >WeirdStart_0248

   ; Weird Formatting Module 0249 - All Of This Should Normalize Cleanly   

     .OrG       $9900       
 .CoNsT      pPuCtRl_0249     =      $2000    
.cOnSt    ZeRoPaGe_0249=     $00f0

  WeirdStart_0249:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0249      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0249:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0249
	JsR       WeirdSub_0249
	JmP         WeirdDone_0249

WeirdSub_0249:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0249:
	NoP
	RtS

 WeirdTable_0249:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0249   ,   WeirdSub_0249
.aDdR  WeirdDone_0249
.bYtE   <WeirdStart_0249 , >WeirdStart_0249

   ; Weird Formatting Module 0250 - All Of This Should Normalize Cleanly   

     .OrG       $9a00       
 .CoNsT      pPuCtRl_0250     =      $2000    
.cOnSt    ZeRoPaGe_0250=     $00f0

  WeirdStart_0250:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0250      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0250:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0250
	JsR       WeirdSub_0250
	JmP         WeirdDone_0250

WeirdSub_0250:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0250:
	NoP
	RtS

 WeirdTable_0250:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0250   ,   WeirdSub_0250
.aDdR  WeirdDone_0250
.bYtE   <WeirdStart_0250 , >WeirdStart_0250

   ; Weird Formatting Module 0251 - All Of This Should Normalize Cleanly   

     .OrG       $9b00       
 .CoNsT      pPuCtRl_0251     =      $2000    
.cOnSt    ZeRoPaGe_0251=     $00f0

  WeirdStart_0251:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0251      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0251:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0251
	JsR       WeirdSub_0251
	JmP         WeirdDone_0251

WeirdSub_0251:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0251:
	NoP
	RtS

 WeirdTable_0251:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0251   ,   WeirdSub_0251
.aDdR  WeirdDone_0251
.bYtE   <WeirdStart_0251 , >WeirdStart_0251

   ; Weird Formatting Module 0252 - All Of This Should Normalize Cleanly   

     .OrG       $9c00       
 .CoNsT      pPuCtRl_0252     =      $2000    
.cOnSt    ZeRoPaGe_0252=     $00f0

  WeirdStart_0252:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0252      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0252:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0252
	JsR       WeirdSub_0252
	JmP         WeirdDone_0252

WeirdSub_0252:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0252:
	NoP
	RtS

 WeirdTable_0252:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0252   ,   WeirdSub_0252
.aDdR  WeirdDone_0252
.bYtE   <WeirdStart_0252 , >WeirdStart_0252

   ; Weird Formatting Module 0253 - All Of This Should Normalize Cleanly   

     .OrG       $9d00       
 .CoNsT      pPuCtRl_0253     =      $2000    
.cOnSt    ZeRoPaGe_0253=     $00f0

  WeirdStart_0253:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0253      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0253:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0253
	JsR       WeirdSub_0253
	JmP         WeirdDone_0253

WeirdSub_0253:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0253:
	NoP
	RtS

 WeirdTable_0253:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0253   ,   WeirdSub_0253
.aDdR  WeirdDone_0253
.bYtE   <WeirdStart_0253 , >WeirdStart_0253

   ; Weird Formatting Module 0254 - All Of This Should Normalize Cleanly   

     .OrG       $9e00       
 .CoNsT      pPuCtRl_0254     =      $2000    
.cOnSt    ZeRoPaGe_0254=     $00f0

  WeirdStart_0254:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0254      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0254:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0254
	JsR       WeirdSub_0254
	JmP         WeirdDone_0254

WeirdSub_0254:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0254:
	NoP
	RtS

 WeirdTable_0254:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0254   ,   WeirdSub_0254
.aDdR  WeirdDone_0254
.bYtE   <WeirdStart_0254 , >WeirdStart_0254

   ; Weird Formatting Module 0255 - All Of This Should Normalize Cleanly   

     .OrG       $9f00       
 .CoNsT      pPuCtRl_0255     =      $2000    
.cOnSt    ZeRoPaGe_0255=     $00f0

  WeirdStart_0255:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0255      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0255:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0255
	JsR       WeirdSub_0255
	JmP         WeirdDone_0255

WeirdSub_0255:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0255:
	NoP
	RtS

 WeirdTable_0255:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0255   ,   WeirdSub_0255
.aDdR  WeirdDone_0255
.bYtE   <WeirdStart_0255 , >WeirdStart_0255

   ; Weird Formatting Module 0256 - All Of This Should Normalize Cleanly   

     .OrG       $a000       
 .CoNsT      pPuCtRl_0256     =      $2000    
.cOnSt    ZeRoPaGe_0256=     $00f0

  WeirdStart_0256:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0256      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0256:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0256
	JsR       WeirdSub_0256
	JmP         WeirdDone_0256

WeirdSub_0256:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0256:
	NoP
	RtS

 WeirdTable_0256:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0256   ,   WeirdSub_0256
.aDdR  WeirdDone_0256
.bYtE   <WeirdStart_0256 , >WeirdStart_0256

   ; Weird Formatting Module 0257 - All Of This Should Normalize Cleanly   

     .OrG       $a100       
 .CoNsT      pPuCtRl_0257     =      $2000    
.cOnSt    ZeRoPaGe_0257=     $00f0

  WeirdStart_0257:     ; External Whitespace Around Label
	  lDa             #$00        
	StA        pPuCtRl_0257      ; Mixed Case Mnemonic
	  lDx       #$08
WeirdLoop_0257:
	AsL          A
	  aDc        $10   ,    X
	AnD       ($10,X)
	OrA          ($11)   ,    y
	StA      $0200   ,x
	DeX
	BnE            WeirdLoop_0257
	JsR       WeirdSub_0257
	JmP         WeirdDone_0257

WeirdSub_0257:
	  pHa
	LdA      %00001111
	StA        $20
	PlA
	rTs

WeirdDone_0257:
	NoP
	RtS

 WeirdTable_0257:
 .ByTe    $01   ,   $02,$03  ,    $04    
.WoRd      WeirdStart_0257   ,   WeirdSub_0257
.aDdR  WeirdDone_0257
.bYtE   <WeirdStart_0257 , >WeirdStart_0257

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      

      ; Valid Comment-Only Line With External Whitespace      
   ; Trailing Whitespace And Comments Are Silently Removed   
