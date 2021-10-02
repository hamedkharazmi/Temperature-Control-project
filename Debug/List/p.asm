
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

_0x16:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0
_0x0:
	.DB  0x49,0x6E,0x20,0x74,0x68,0x65,0x20,0x6E
	.DB  0x61,0x6D,0x65,0x20,0x6F,0x66,0x20,0x47
	.DB  0x6F,0x64,0x0,0x54,0x65,0x6D,0x70,0x72
	.DB  0x65,0x74,0x75,0x72,0x65,0x3F,0x0,0x28
	.DB  0x63,0x6C,0x69,0x63,0x6B,0x20,0x27,0x3D
	.DB  0x27,0x20,0x74,0x6F,0x20,0x63,0x6F,0x6E
	.DB  0x74,0x69,0x6E,0x75,0x65,0x29,0x0,0x25
	.DB  0x64,0x0,0x54,0x20,0x69,0x73,0x3A,0x25
	.DB  0x30,0x32,0x64,0x20,0x0,0x56,0x31,0x3F
	.DB  0x0,0x56,0x31,0x20,0x69,0x73,0x3A,0x25
	.DB  0x30,0x32,0x64,0x20,0x0,0x56,0x32,0x3F
	.DB  0x0,0x28,0x63,0x6C,0x69,0x63,0x6B,0x20
	.DB  0x27,0x3D,0x27,0x20,0x74,0x6F,0x20,0x63
	.DB  0x6F,0x6E,0x74,0x69,0x6E,0x75,0x65,0x0
	.DB  0x56,0x32,0x20,0x69,0x73,0x3A,0x25,0x30
	.DB  0x32,0x64,0x20,0x0,0x64,0x65,0x6C,0x74
	.DB  0x61,0x5F,0x54,0x3F,0x0,0x64,0x65,0x6C
	.DB  0x74,0x61,0x5F,0x54,0x20,0x69,0x73,0x3A
	.DB  0x25,0x30,0x32,0x64,0x20,0x0,0x73,0x74
	.DB  0x61,0x72,0x74,0x3F,0x0,0x54,0x45,0x4D
	.DB  0x50,0x25,0x64,0x3D,0x25,0x64,0x20,0x43
	.DB  0x0,0x61,0x76,0x67,0x3D,0x25,0x31,0x2E
	.DB  0x32,0x66,0x0,0x76,0x61,0x72,0x3D,0x25
	.DB  0x31,0x2E,0x32,0x66,0x0,0x46,0x61,0x6E
	.DB  0x3A,0x20,0x4F,0x4E,0x0,0x46,0x61,0x6E
	.DB  0x3A,0x20,0x4F,0x46,0x46,0x0,0x63,0x68
	.DB  0x61,0x72,0x74,0x3F,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20E0060:
	.DB  0x1
_0x20E0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x13
	.DW  _0x17
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x17+19
	.DW  _0x0*2+19

	.DW  0x18
	.DW  _0x17+31
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x17+55
	.DW  _0x0*2+69

	.DW  0x18
	.DW  _0x17+59
	.DW  _0x0*2+31

	.DW  0x04
	.DW  _0x17+83
	.DW  _0x0*2+85

	.DW  0x17
	.DW  _0x17+87
	.DW  _0x0*2+89

	.DW  0x09
	.DW  _0x17+110
	.DW  _0x0*2+124

	.DW  0x18
	.DW  _0x17+119
	.DW  _0x0*2+31

	.DW  0x07
	.DW  _0x17+143
	.DW  _0x0*2+150

	.DW  0x08
	.DW  _0x17+150
	.DW  _0x0*2+189

	.DW  0x09
	.DW  _0x17+158
	.DW  _0x0*2+197

	.DW  0x07
	.DW  _0x17+167
	.DW  _0x0*2+206

	.DW  0x01
	.DW  __seed_G107
	.DW  _0x20E0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/30/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;
;
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Voltage Reference: Int., cap. on AREF
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0031 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0032 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 0033 // Delay needed for the stabilization of the ADC input voltage
; 0000 0034 delay_us(10);
	__DELAY_USB 27
; 0000 0035 // Start the AD conversion
; 0000 0036 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0037 // Wait for the AD conversion to complete
; 0000 0038 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0039 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 003A return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 003B }
; .FEND
;
;
;int get_key(void){
; 0000 003E int get_key(void){
_get_key:
; .FSTART _get_key
; 0000 003F     DDRD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0040     PORTD=0b00001111;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0041 
; 0000 0042     DDRD=0b00010000;
	LDI  R30,LOW(16)
	OUT  0x11,R30
; 0000 0043     if(PIND.0==0)return 7;
	SBIC 0x10,0
	RJMP _0x6
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RET
; 0000 0044     if(PIND.1==0)return 4;
_0x6:
	SBIC 0x10,1
	RJMP _0x7
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 0045     if(PIND.2==0)return 1;
_0x7:
	SBIC 0x10,2
	RJMP _0x8
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0046     if(PIND.3==0)return '*';
_0x8:
	SBIC 0x10,3
	RJMP _0x9
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	RET
; 0000 0047 
; 0000 0048     DDRD=0b00100000;
_0x9:
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 0049     if(PIND.0==0)return 8;
	SBIC 0x10,0
	RJMP _0xA
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET
; 0000 004A     if(PIND.1==0)return 5;
_0xA:
	SBIC 0x10,1
	RJMP _0xB
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET
; 0000 004B     if(PIND.2==0)return 2;
_0xB:
	SBIC 0x10,2
	RJMP _0xC
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 004C     if(PIND.3==0)return 0;
_0xC:
	SBIC 0x10,3
	RJMP _0xD
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 004D 
; 0000 004E     DDRD=0b01000000;
_0xD:
	LDI  R30,LOW(64)
	OUT  0x11,R30
; 0000 004F     if(PIND.0==0)return 9;
	SBIC 0x10,0
	RJMP _0xE
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RET
; 0000 0050     if(PIND.1==0)return 6;
_0xE:
	SBIC 0x10,1
	RJMP _0xF
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RET
; 0000 0051     if(PIND.2==0)return 3;
_0xF:
	SBIC 0x10,2
	RJMP _0x10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 0052     if(PIND.3==0)return '=';
_0x10:
	SBIC 0x10,3
	RJMP _0x11
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	RET
; 0000 0053 
; 0000 0054     DDRD=0b10000000;
_0x11:
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 0055     if(PIND.0==0)return 100;
	SBIC 0x10,0
	RJMP _0x12
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET
; 0000 0056     if(PIND.1==0)return 101;
_0x12:
	SBIC 0x10,1
	RJMP _0x13
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	RET
; 0000 0057     if(PIND.2==0)return 102;
_0x13:
	SBIC 0x10,2
	RJMP _0x14
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	RET
; 0000 0058     if(PIND.3==0)return 103;
_0x14:
	SBIC 0x10,3
	RJMP _0x15
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	RET
; 0000 0059 
; 0000 005A     return 255;
_0x15:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RET
; 0000 005B }
; .FEND
;
;eeprom char avg_eeprom[100];
;void main(void)
; 0000 005F {
_main:
; .FSTART _main
; 0000 0060 char str[15];
; 0000 0061 int key;
; 0000 0062 int adc_data[4];
; 0000 0063 char adc_buffer[16];
; 0000 0064 int i;
; 0000 0065 int m=0,n;
; 0000 0066 int x=1;
; 0000 0067 int T=0;
; 0000 0068 int delta_T;
; 0000 0069 int V1;
; 0000 006A int V2;
; 0000 006B int temp=0;
; 0000 006C int keypress=0;
; 0000 006D float var,avg;
; 0000 006E float fan;
; 0000 006F bool print_fan=false;
; 0000 0070 char avgg[100];
; 0000 0071 
; 0000 0072 
; 0000 0073 // Declare your local variables here
; 0000 0074 // Variable used to store graphic display
; 0000 0075 // controller initialization data
; 0000 0076 GLCDINIT_t glcd_init_data;
; 0000 0077 
; 0000 0078 // Input/Output Ports initialization
; 0000 0079 // Port A initialization
; 0000 007A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007B DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,48
	LDI  R24,27
	LDI  R26,LOW(106)
	LDI  R27,HIGH(106)
	LDI  R30,LOW(_0x16*2)
	LDI  R31,HIGH(_0x16*2)
	CALL __INITLOCB
;	str -> Y+159
;	key -> R16,R17
;	adc_data -> Y+151
;	adc_buffer -> Y+135
;	i -> R18,R19
;	m -> R20,R21
;	n -> Y+133
;	x -> Y+131
;	T -> Y+129
;	delta_T -> Y+127
;	V1 -> Y+125
;	V2 -> Y+123
;	temp -> Y+121
;	keypress -> Y+119
;	var -> Y+115
;	avg -> Y+111
;	fan -> Y+107
;	print_fan -> Y+106
;	avgg -> Y+6
;	glcd_init_data -> Y+0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 007C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007D PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 007E 
; 0000 007F // Port B initialization
; 0000 0080 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0081 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0082 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0083 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0084 
; 0000 0085 // Port C initialization
; 0000 0086 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0087 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0088 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0089 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 008A 
; 0000 008B // Port D initialization
; 0000 008C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 008E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008F PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 0 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer 0 Stopped
; 0000 0094 // Mode: Normal top=0xFF
; 0000 0095 // OC0 output: Toggle on compare match
; 0000 0096 TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(16)
	OUT  0x33,R30
; 0000 0097 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0098 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0099 
; 0000 009A // Timer/Counter 1 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: Timer1 Stopped
; 0000 009D // Mode: Normal top=0xFFFF
; 0000 009E // OC1A output: Disconnected
; 0000 009F // OC1B output: Disconnected
; 0000 00A0 // Noise Canceler: Off
; 0000 00A1 // Input Capture on Falling Edge
; 0000 00A2 // Timer1 Overflow Interrupt: Off
; 0000 00A3 // Input Capture Interrupt: Off
; 0000 00A4 // Compare A Match Interrupt: Off
; 0000 00A5 // Compare B Match Interrupt: Off
; 0000 00A6 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00A7 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00A8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00AA ICR1H=0x00;
	OUT  0x27,R30
; 0000 00AB ICR1L=0x00;
	OUT  0x26,R30
; 0000 00AC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00AD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00AE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00AF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00B0 
; 0000 00B1 // Timer/Counter 2 initialization
; 0000 00B2 // Clock source: System Clock
; 0000 00B3 // Clock value: Timer2 Stopped
; 0000 00B4 // Mode: Normal top=0xFF
; 0000 00B5 // OC2 output: Disconnected
; 0000 00B6 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00B7 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00B8 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B9 OCR2=0x00;
	OUT  0x23,R30
; 0000 00BA 
; 0000 00BB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00BC TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00BD 
; 0000 00BE // External Interrupt(s) initialization
; 0000 00BF // INT0: On
; 0000 00C0 // INT0 Mode: Low level
; 0000 00C1 // INT1: Off
; 0000 00C2 // INT2: Off
; 0000 00C3 GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00C4 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00C5 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00C6 GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00C7 
; 0000 00C8 // USART initialization
; 0000 00C9 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00CA // USART Receiver: On
; 0000 00CB // USART Transmitter: Off
; 0000 00CC // USART Mode: Asynchronous
; 0000 00CD // USART Baud Rate: 9600
; 0000 00CE UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00CF UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(16)
	OUT  0xA,R30
; 0000 00D0 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00D1 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00D2 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00D3 
; 0000 00D4 // Analog Comparator initialization
; 0000 00D5 // Analog Comparator: Off
; 0000 00D6 // The Analog Comparator's positive input is
; 0000 00D7 // connected to the AIN0 pin
; 0000 00D8 // The Analog Comparator's negative input is
; 0000 00D9 // connected to the AIN1 pin
; 0000 00DA ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DB 
; 0000 00DC // ADC initialization
; 0000 00DD // ADC Clock frequency: 125.000 kHz
; 0000 00DE // ADC Voltage Reference: Int., cap. on AREF
; 0000 00DF // ADC Auto Trigger Source: ADC Stopped
; 0000 00E0 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 00E1 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(130)
	OUT  0x6,R30
; 0000 00E2 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E3 
; 0000 00E4 // SPI initialization
; 0000 00E5 // SPI disabled
; 0000 00E6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00E7 
; 0000 00E8 // TWI initialization
; 0000 00E9 // TWI disabled
; 0000 00EA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00EB 
; 0000 00EC // Graphic Display Controller initialization
; 0000 00ED // The KS0108 connections are specified in the
; 0000 00EE // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00EF // DB0 - PORTC Bit 0
; 0000 00F0 // DB1 - PORTC Bit 1
; 0000 00F1 // DB2 - PORTC Bit 2
; 0000 00F2 // DB3 - PORTC Bit 3
; 0000 00F3 // DB4 - PORTC Bit 4
; 0000 00F4 // DB5 - PORTC Bit 5
; 0000 00F5 // DB6 - PORTC Bit 6
; 0000 00F6 // DB7 - PORTC Bit 7
; 0000 00F7 // E - PORTB Bit 0
; 0000 00F8 // RD /WR - PORTB Bit 1
; 0000 00F9 // RS - PORTB Bit 2
; 0000 00FA // /RST - PORTB Bit 6
; 0000 00FB // CS1 - PORTB Bit 4
; 0000 00FC // CS2 - PORTB Bit 5
; 0000 00FD 
; 0000 00FE // Specify the current font for displaying text
; 0000 00FF glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0100 // No function is used for reading
; 0000 0101 // image data from external memory
; 0000 0102 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0103 // No function is used for writing
; 0000 0104 // image data to external memory
; 0000 0105 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0106 
; 0000 0107 glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0108 
; 0000 0109 
; 0000 010A 
; 0000 010B       glcd_clear();
	CALL SUBOPT_0x0
; 0000 010C       glcd_line(5,5,5,55);
; 0000 010D       glcd_line(120,5,120,55);
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R30,LOW(5)
	CALL SUBOPT_0x1
; 0000 010E       glcd_line(5,55,120,55);
	LDI  R30,LOW(55)
	CALL SUBOPT_0x1
; 0000 010F       glcd_line(5,5,120,5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R26,LOW(5)
	CALL _glcd_line
; 0000 0110       glcd_outtextxy(9,25,"In the name of God");
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x17,0
	CALL _glcd_outtextxy
; 0000 0111       delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL SUBOPT_0x2
; 0000 0112 
; 0000 0113       glcd_clear();
; 0000 0114       glcd_outtextxy(10,15,"Tempreture?");
	CALL SUBOPT_0x3
	__POINTW2MN _0x17,19
	CALL SUBOPT_0x4
; 0000 0115       glcd_outtextxy(10,35,"(click '=' to continue)");
	__POINTW2MN _0x17,31
	CALL _glcd_outtextxy
; 0000 0116       z:
_0x18:
; 0000 0117       while(keypress==0){
_0x19:
	CALL SUBOPT_0x5
	BRNE _0x1B
; 0000 0118         key=get_key();
	CALL SUBOPT_0x6
; 0000 0119         if(key<255){
	BRGE _0x1C
; 0000 011A           if(key!=102){
	CALL SUBOPT_0x7
	BREQ _0x1D
; 0000 011B             if(key=='='){
	CALL SUBOPT_0x8
	BRNE _0x1E
; 0000 011C               keypress=1;
	CALL SUBOPT_0x9
; 0000 011D             }
; 0000 011E             if(key!=255 && key!='='){
_0x1E:
	CALL SUBOPT_0xA
	BREQ _0x20
	CALL SUBOPT_0x8
	BRNE _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 011F               glcd_clear();
	CALL _glcd_clear
; 0000 0120               T=key+T*10;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	__PUTW1SX 129
; 0000 0121               sprintf(str,"%d",T);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 0122               glcd_outtextxy(10,10,str);
	CALL SUBOPT_0x10
; 0000 0123               delay_ms(20);
; 0000 0124               key=255;
; 0000 0125             }
; 0000 0126           }
_0x1F:
; 0000 0127           if(key==102){
_0x1D:
	CALL SUBOPT_0x7
	BRNE _0x22
; 0000 0128             glcd_clear();
	CALL _glcd_clear
; 0000 0129             T=0;
	LDI  R30,LOW(0)
	__CLRW1SX 129
; 0000 012A             goto z;
	RJMP _0x18
; 0000 012B           }
; 0000 012C         }
_0x22:
; 0000 012D       }
_0x1C:
	RJMP _0x19
_0x1B:
; 0000 012E       glcd_clear();
	CALL SUBOPT_0x11
; 0000 012F       sprintf(str,"T is:%02d ",T);
	__POINTW1FN _0x0,58
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 0130       glcd_outtextxy(16,0,str);
	CALL SUBOPT_0x12
; 0000 0131 
; 0000 0132       delay_ms(200);
; 0000 0133       x=1;
; 0000 0134       temp=0;
; 0000 0135       keypress=0;
; 0000 0136       glcd_clear();
; 0000 0137       glcd_outtextxy(10,15,"V1?");
	__POINTW2MN _0x17,55
	CALL SUBOPT_0x4
; 0000 0138       glcd_outtextxy(10,35,"(click '=' to continue)");
	__POINTW2MN _0x17,59
	CALL _glcd_outtextxy
; 0000 0139       z2:
_0x23:
; 0000 013A       while(keypress==0){
_0x24:
	CALL SUBOPT_0x5
	BRNE _0x26
; 0000 013B         key=get_key();
	CALL SUBOPT_0x6
; 0000 013C         if(key<255){
	BRGE _0x27
; 0000 013D           if(key!=102){
	CALL SUBOPT_0x7
	BREQ _0x28
; 0000 013E             if(key=='='){
	CALL SUBOPT_0x8
	BRNE _0x29
; 0000 013F               keypress=1;
	CALL SUBOPT_0x9
; 0000 0140             }
; 0000 0141             if(key!=255 && key!='='){
_0x29:
	CALL SUBOPT_0xA
	BREQ _0x2B
	CALL SUBOPT_0x8
	BRNE _0x2C
_0x2B:
	RJMP _0x2A
_0x2C:
; 0000 0142               glcd_clear();
	CALL _glcd_clear
; 0000 0143               V1=key+V1*10;
	CALL SUBOPT_0x13
	CALL SUBOPT_0xC
	__PUTW1SX 125
; 0000 0144               sprintf(str,"%d",V1);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0x14
; 0000 0145               glcd_outtextxy(10,10,str);
	CALL SUBOPT_0x10
; 0000 0146               delay_ms(20);
; 0000 0147               key=255;
; 0000 0148             }
; 0000 0149           }
_0x2A:
; 0000 014A           if(key==102){
_0x28:
	CALL SUBOPT_0x7
	BRNE _0x2D
; 0000 014B             glcd_clear();
	CALL _glcd_clear
; 0000 014C             V1=0;
	LDI  R30,LOW(0)
	__CLRW1SX 125
; 0000 014D             goto z2;
	RJMP _0x23
; 0000 014E           }
; 0000 014F         }
_0x2D:
; 0000 0150       }
_0x27:
	RJMP _0x24
_0x26:
; 0000 0151       glcd_clear();
	CALL SUBOPT_0x11
; 0000 0152       sprintf(str,"V1 is:%02d ",V1);
	__POINTW1FN _0x0,73
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
; 0000 0153       glcd_outtextxy(16,0,str);
	CALL SUBOPT_0x12
; 0000 0154 
; 0000 0155 
; 0000 0156       delay_ms(200);
; 0000 0157       x=1;
; 0000 0158       temp=0;
; 0000 0159       keypress=0;
; 0000 015A       glcd_clear();
; 0000 015B       glcd_outtextxy(10,15,"V2?");
	__POINTW2MN _0x17,83
	CALL SUBOPT_0x4
; 0000 015C       glcd_outtextxy(10,35,"(click '=' to continue");
	__POINTW2MN _0x17,87
	CALL _glcd_outtextxy
; 0000 015D       z3:
_0x2E:
; 0000 015E       while(keypress==0){
_0x2F:
	CALL SUBOPT_0x5
	BRNE _0x31
; 0000 015F         key=get_key();
	CALL SUBOPT_0x6
; 0000 0160         if(key<255){
	BRGE _0x32
; 0000 0161           if(key!=102){
	CALL SUBOPT_0x7
	BREQ _0x33
; 0000 0162             if(key=='='){
	CALL SUBOPT_0x8
	BRNE _0x34
; 0000 0163               keypress=1;
	CALL SUBOPT_0x9
; 0000 0164             }
; 0000 0165             if(key!=255 && key!='='){
_0x34:
	CALL SUBOPT_0xA
	BREQ _0x36
	CALL SUBOPT_0x8
	BRNE _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 0166               glcd_clear();
	CALL _glcd_clear
; 0000 0167               V2=key+V2*10;
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC
	__PUTW1SX 123
; 0000 0168               sprintf(str,"%d",V2);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0x16
; 0000 0169               glcd_outtextxy(10,10,str);
	CALL SUBOPT_0x10
; 0000 016A               delay_ms(20);
; 0000 016B               key=255;
; 0000 016C             }
; 0000 016D           }
_0x35:
; 0000 016E           if(key==102){
_0x33:
	CALL SUBOPT_0x7
	BRNE _0x38
; 0000 016F             glcd_clear();
	CALL _glcd_clear
; 0000 0170             V2=0;
	LDI  R30,LOW(0)
	__CLRW1SX 123
; 0000 0171             goto z3;
	RJMP _0x2E
; 0000 0172           }
; 0000 0173         }
_0x38:
; 0000 0174       }
_0x32:
	RJMP _0x2F
_0x31:
; 0000 0175       glcd_clear();
	CALL SUBOPT_0x11
; 0000 0176       sprintf(str,"V2 is:%02d ",V2);
	__POINTW1FN _0x0,112
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
; 0000 0177       glcd_outtextxy(16,0,str);
	CALL SUBOPT_0x12
; 0000 0178 
; 0000 0179 
; 0000 017A       delay_ms(200);
; 0000 017B       x=1;
; 0000 017C       temp=0;
; 0000 017D       keypress=0;
; 0000 017E       glcd_clear();
; 0000 017F       glcd_outtextxy(10,15,"delta_T?");
	__POINTW2MN _0x17,110
	CALL SUBOPT_0x4
; 0000 0180       glcd_outtextxy(10,35,"(click '=' to continue)");
	__POINTW2MN _0x17,119
	CALL _glcd_outtextxy
; 0000 0181       z4:
; 0000 0182       while(keypress==0){
_0x3A:
	CALL SUBOPT_0x5
	BRNE _0x3C
; 0000 0183         key=get_key();
	CALL SUBOPT_0x6
; 0000 0184         if(key<255){
	BRGE _0x3D
; 0000 0185           if(key!=102){
	CALL SUBOPT_0x7
	BREQ _0x3E
; 0000 0186             if(key=='='){
	CALL SUBOPT_0x8
	BRNE _0x3F
; 0000 0187               keypress=1;
	CALL SUBOPT_0x9
; 0000 0188             }
; 0000 0189             if(key!=255 && key!='='){
_0x3F:
	CALL SUBOPT_0xA
	BREQ _0x41
	CALL SUBOPT_0x8
	BRNE _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 018A               glcd_clear();
	CALL _glcd_clear
; 0000 018B               delta_T=key+delta_T*10;
	__GETW1SX 127
	CALL SUBOPT_0xC
	__PUTW1SX 127
; 0000 018C               sprintf(str,"%d",delta_T);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0x17
; 0000 018D               glcd_outtextxy(10,10,str);
	CALL SUBOPT_0x10
; 0000 018E               delay_ms(20);
; 0000 018F               key=255;
; 0000 0190             }
; 0000 0191           }
_0x40:
; 0000 0192           if(key==102){
_0x3E:
	CALL SUBOPT_0x7
	BRNE _0x43
; 0000 0193             glcd_clear();
	CALL _glcd_clear
; 0000 0194             delta_T=0;
	LDI  R30,LOW(0)
	__CLRW1SX 127
; 0000 0195             goto z3;
	RJMP _0x2E
; 0000 0196           }
; 0000 0197         }
_0x43:
; 0000 0198       }
_0x3D:
	RJMP _0x3A
_0x3C:
; 0000 0199       glcd_clear();
	CALL SUBOPT_0x11
; 0000 019A       sprintf(str,"delta_T is:%02d ",delta_T);
	__POINTW1FN _0x0,133
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x17
; 0000 019B       glcd_outtextxy(16,0,str);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(161))
	SBCI R27,HIGH(-(161))
	CALL _glcd_outtextxy
; 0000 019C       delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL SUBOPT_0x2
; 0000 019D 
; 0000 019E 
; 0000 019F 
; 0000 01A0     glcd_clear();
; 0000 01A1     glcd_outtextxy(25,25,"start?");
	LDI  R30,LOW(25)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x17,143
	CALL _glcd_outtextxy
; 0000 01A2     while(1){
_0x44:
; 0000 01A3       temp=get_key();
	RCALL _get_key
	__PUTW1SX 121
; 0000 01A4       if(temp=='=' || temp=='*') break;
	CALL SUBOPT_0x18
	SBIW R26,61
	BREQ _0x48
	CALL SUBOPT_0x18
	SBIW R26,42
	BRNE _0x47
_0x48:
	RJMP _0x46
; 0000 01A5     }
_0x47:
	RJMP _0x44
_0x46:
; 0000 01A6 
; 0000 01A7     DDRB.3=1;
	SBI  0x17,3
; 0000 01A8     OCR0=128;
	LDI  R30,LOW(128)
	OUT  0x3C,R30
; 0000 01A9     TCCR0=0x69;
	LDI  R30,LOW(105)
	OUT  0x33,R30
; 0000 01AA 
; 0000 01AB while (1)
_0x4C:
; 0000 01AC     {
; 0000 01AD 
; 0000 01AE       avg=0;
	LDI  R30,LOW(0)
	__CLRD1SX 111
; 0000 01AF       var=0;
	__CLRD1SX 115
; 0000 01B0       glcd_clear();
	CALL _glcd_clear
; 0000 01B1       for(i=0;i<4;i++){
	__GETWRN 18,19,0
_0x50:
	__CPWRN 18,19,4
	BRGE _0x51
; 0000 01B2         adc_data[i]=read_adc(i)/4;
	CALL SUBOPT_0x19
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R26,R18
	RCALL _read_adc
	CALL __LSRW2
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 01B3         sprintf(adc_buffer,"TEMP%d=%d C",i+1,adc_data[i]);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,157
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R18
	MOVW R26,R28
	SUBI R26,LOW(-(159))
	SBCI R27,HIGH(-(159))
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x1B
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 01B4         glcd_outtextxy(16,10*i,adc_buffer);
	CALL SUBOPT_0x1C
; 0000 01B5         //delay_ms(10);
; 0000 01B6       }
	__ADDWRN 18,19,1
	RJMP _0x50
_0x51:
; 0000 01B7 
; 0000 01B8 
; 0000 01B9       for(i=0;i<4;i++)
	__GETWRN 18,19,0
_0x53:
	__CPWRN 18,19,4
	BRGE _0x54
; 0000 01BA         avg+=adc_data[i];
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL __ADDF12
	CALL SUBOPT_0x1F
	__ADDWRN 18,19,1
	RJMP _0x53
_0x54:
; 0000 01BB avg/=4;
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1F
; 0000 01BC       sprintf(adc_buffer,"avg=%1.2f",avg);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,169
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
; 0000 01BD       glcd_outtextxy(16,10*i,adc_buffer);
	CALL SUBOPT_0x1C
; 0000 01BE       //delay_ms(10);
; 0000 01BF 
; 0000 01C0 
; 0000 01C1       for(i=0;i<4;i++)
	__GETWRN 18,19,0
_0x56:
	__CPWRN 18,19,4
	BRGE _0x57
; 0000 01C2         var+=(adc_data[i]-avg)*(adc_data[i]-avg);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
	MOVW R26,R30
	__GETD1SX 111
	CALL __CWD2
	CALL __CDF2
	CALL SUBOPT_0x23
	MOVW R26,R30
	MOVW R24,R22
	CALL __MULF12
	CALL SUBOPT_0x24
	CALL __ADDF12
	CALL SUBOPT_0x25
	__ADDWRN 18,19,1
	RJMP _0x56
_0x57:
; 0000 01C3 var/=4;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x20
	CALL SUBOPT_0x25
; 0000 01C4       sprintf(adc_buffer,"var=%1.2f",var);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,179
	ST   -Y,R31
	ST   -Y,R30
	__GETD1SX 119
	CALL SUBOPT_0x22
; 0000 01C5       glcd_outtextxy(16,50,adc_buffer);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(137))
	SBCI R27,HIGH(-(137))
	CALL _glcd_outtextxy
; 0000 01C6 
; 0000 01C7 
; 0000 01C8       avg_eeprom[m]=(adc_data[0]+adc_data[1]+adc_data[2]+adc_data[3])/4;
	MOVW R30,R20
	SUBI R30,LOW(-_avg_eeprom)
	SBCI R31,HIGH(-_avg_eeprom)
	CALL SUBOPT_0x26
	CALL __EEPROMWRB
; 0000 01C9       m++;
	__ADDWRN 20,21,1
; 0000 01CA 
; 0000 01CB 
; 0000 01CC 
; 0000 01CD 
; 0000 01CE       delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 01CF       fan=var;
	CALL SUBOPT_0x21
	__PUTD1SX 107
; 0000 01D0       if(fan>V2){
	CALL SUBOPT_0x15
	CALL SUBOPT_0x27
	BREQ PC+2
	BRCC PC+2
	RJMP _0x58
; 0000 01D1          PORTB.7=1;
	SBI  0x18,7
; 0000 01D2          if(print_fan==false){
	__GETB1SX 106
	CPI  R30,0
	BRNE _0x5B
; 0000 01D3             glcd_clear();
	CALL SUBOPT_0x28
; 0000 01D4             glcd_outtextxy(15,25,"Fan: ON");
	__POINTW2MN _0x17,150
	CALL _glcd_outtextxy
; 0000 01D5             print_fan=true;
	LDI  R30,LOW(1)
	__PUTB1SX 106
; 0000 01D6          }
; 0000 01D7       }
_0x5B:
; 0000 01D8 
; 0000 01D9       else if(fan<V1) {
	RJMP _0x5C
_0x58:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x27
	BRSH _0x5D
; 0000 01DA         PORTB.7=0;
	CBI  0x18,7
; 0000 01DB         if(print_fan==true){
	__GETB2SX 106
	CPI  R26,LOW(0x1)
	BRNE _0x60
; 0000 01DC           glcd_clear();
	CALL SUBOPT_0x28
; 0000 01DD           glcd_outtextxy(15,25,"Fan: OFF");
	__POINTW2MN _0x17,158
	CALL _glcd_outtextxy
; 0000 01DE           print_fan=false;
	LDI  R30,LOW(0)
	__PUTB1SX 106
; 0000 01DF         }
; 0000 01E0       }
_0x60:
; 0000 01E1 
; 0000 01E2       delay_ms(100);
_0x5D:
_0x5C:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL SUBOPT_0x2
; 0000 01E3 
; 0000 01E4       glcd_clear();
; 0000 01E5       glcd_outtextxy(15,25,"chart?");
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x17,167
	CALL _glcd_outtextxy
; 0000 01E6       key=get_key();
	RCALL _get_key
	MOVW R16,R30
; 0000 01E7       delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 01E8 
; 0000 01E9       //for(i=0;i<delta_T*100;i++){
; 0000 01EA         avgg[m]=(adc_data[0]+adc_data[1]+adc_data[2]+adc_data[3])/4;
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x26
	ST   X,R30
; 0000 01EB         if(avgg[m]>T) PORTB.3=0;
	CALL SUBOPT_0x29
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x61
	CBI  0x18,3
; 0000 01EC         if(avgg[m]<T) PORTB.3=1;
_0x61:
	CALL SUBOPT_0x29
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x64
	SBI  0x18,3
; 0000 01ED         OCR0=(T-avgg[m])*10;
_0x64:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R20
	ADC  R27,R21
	LD   R26,X
	__GETB1SX 129
	SUB  R30,R26
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	OUT  0x3C,R30
; 0000 01EE         if(OCR0>255){
	IN   R30,0x3C
	MOV  R26,R30
	LDI  R30,LOW(255)
	CP   R30,R26
	BRSH _0x67
; 0000 01EF           OCR0=255;
	OUT  0x3C,R30
; 0000 01F0         }
; 0000 01F1        //}
; 0000 01F2 
; 0000 01F3       if(key=='*'){
_0x67:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+2
	RJMP _0x68
; 0000 01F4 
; 0000 01F5         glcd_clear();
	CALL SUBOPT_0x0
; 0000 01F6         glcd_line(5,5,5,55);
; 0000 01F7         glcd_line(5,55,155,55);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(155)
	ST   -Y,R30
	LDI  R26,LOW(55)
	CALL _glcd_line
; 0000 01F8         glcd_line(6,T,155,T);
	LDI  R30,LOW(6)
	ST   -Y,R30
	__GETB1SX 130
	ST   -Y,R30
	LDI  R30,LOW(155)
	ST   -Y,R30
	__GETB2SX 132
	CALL _glcd_line
; 0000 01F9 
; 0000 01FA         for(n=0;n<m;n++){
	LDI  R30,LOW(0)
	__CLRW1SX 133
_0x6A:
	__GETW2SX 133
	CP   R26,R20
	CPC  R27,R21
	BRGE _0x6B
; 0000 01FB           glcd_setpixel(6+delta_T*n,55-avgg[n]);
	__GETB1SX 133
	__GETB2SX 127
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(6)
	ST   -Y,R30
	__GETW1SX 134
	MOVW R26,R28
	ADIW R26,7
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	LDI  R30,LOW(55)
	SUB  R30,R26
	MOV  R26,R30
	CALL _glcd_setpixel
; 0000 01FC         }
	MOVW R26,R28
	SUBI R26,LOW(-(133))
	SBCI R27,HIGH(-(133))
	CALL SUBOPT_0x2A
	RJMP _0x6A
_0x6B:
; 0000 01FD 
; 0000 01FE         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 01FF       }
; 0000 0200     }
_0x68:
	RJMP _0x4C
; 0000 0201 }
_0x6C:
	RJMP _0x6C
; .FEND

	.DSEG
_0x17:
	.BYTE 0xAE
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x2A
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x2B
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x212000D
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x212000D
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x2C
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x2C
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x2D
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x2C
_0x2000022:
	CALL SUBOPT_0x2D
	BRLO _0x2000024
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x2D
	BRSH _0x2000028
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x2C
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2D
	BRLO _0x2000029
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x2E
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x34
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x36
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	CALL SUBOPT_0x36
	CALL SUBOPT_0x36
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x36
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x212000D:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x2A
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x37
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x37
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3A
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3B
	CALL __GETD1P
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	CALL SUBOPT_0x3E
	CALL __ANEGF1
	CALL SUBOPT_0x3C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x3A
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	CALL SUBOPT_0x3E
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000065
_0x2000064:
	CALL SUBOPT_0x3E
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x3F
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x41
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	CALL SUBOPT_0x41
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x41
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x41
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3B
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CALL __CWD1
	RJMP _0x2000115
_0x2000081:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	CALL SUBOPT_0x3E
	CALL __ANEGD1
	CALL SUBOPT_0x3C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	CALL SUBOPT_0x37
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	CALL SUBOPT_0x42
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	CALL SUBOPT_0x37
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	CALL SUBOPT_0x43
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	CALL SUBOPT_0x42
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	CALL SUBOPT_0x37
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x43
	CALL __MODD21U
	CALL SUBOPT_0x3C
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x41
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3A
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x44
	SBIW R30,0
	BRNE _0x20000B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x212000C
_0x20000B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x44
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x212000C:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x212000A
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	RJMP _0x212000A
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G102:
; .FSTART _ks0108_enable_G102
	nop
	SBI  0x18,0
	nop
	RET
; .FEND
_ks0108_disable_G102:
; .FSTART _ks0108_disable_G102
	CBI  0x18,0
	CBI  0x18,4
	CBI  0x18,5
	RET
; .FEND
_ks0108_rdbus_G102:
; .FSTART _ks0108_rdbus_G102
	ST   -Y,R17
	RCALL _ks0108_enable_G102
	IN   R17,19
	CBI  0x18,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G102:
; .FSTART _ks0108_busy_G102
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,1
	CBI  0x18,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2040003
	SBI  0x18,4
	RJMP _0x2040004
_0x2040003:
	CBI  0x18,4
_0x2040004:
	SBRS R17,1
	RJMP _0x2040005
	SBI  0x18,5
	RJMP _0x2040006
_0x2040005:
	CBI  0x18,5
_0x2040006:
_0x2040007:
	RCALL _ks0108_rdbus_G102
	ANDI R30,LOW(0x80)
	BRNE _0x2040007
	LDD  R17,Y+0
	RJMP _0x212000B
; .FEND
_ks0108_wrcmd_G102:
; .FSTART _ks0108_wrcmd_G102
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G102
	CALL SUBOPT_0x45
	RJMP _0x212000B
; .FEND
_ks0108_setloc_G102:
; .FSTART _ks0108_setloc_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G102,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	RET
; .FEND
_ks0108_gotoxp_G102:
; .FSTART _ks0108_gotoxp_G102
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G102,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G102,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G102,2
	RCALL _ks0108_setloc_G102
	RJMP _0x212000B
; .FEND
_ks0108_nextx_G102:
; .FSTART _ks0108_nextx_G102
	LDS  R26,_ks0108_coord_G102
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G102,R26
	CPI  R26,LOW(0x80)
	BRLO _0x204000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G102,R30
_0x204000A:
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	BRNE _0x204000B
	LDS  R30,_ks0108_coord_G102
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G102,2
	RCALL _ks0108_gotoxp_G102
_0x204000B:
	RET
; .FEND
_ks0108_wrdata_G102:
; .FSTART _ks0108_wrdata_G102
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	SBI  0x18,2
	CALL SUBOPT_0x45
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G102:
; .FSTART _ks0108_rddata_G102
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	LDI  R30,LOW(0)
	OUT  0x14,R30
	SBI  0x18,1
	SBI  0x18,2
	RCALL _ks0108_rdbus_G102
	RET
; .FEND
_ks0108_rdbyte_G102:
; .FSTART _ks0108_rdbyte_G102
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x46
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	RCALL _ks0108_rddata_G102
_0x212000B:
	ADIW R28,2
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,6
	SBI  0x18,6
	SBI  0x17,4
	SBI  0x17,5
	RCALL _ks0108_disable_G102
	CBI  0x18,6
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,6
	LDI  R17,LOW(0)
_0x204000C:
	CPI  R17,2
	BRSH _0x204000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G102
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G102
	RJMP _0x204000C
_0x204000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x204000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20400AC
_0x204000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20400AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2040015
	LDI  R16,LOW(255)
_0x2040015:
_0x2040016:
	CPI  R19,8
	BRSH _0x2040018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G102
	LDI  R17,LOW(0)
_0x2040019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x204001B
	MOV  R26,R16
	CALL SUBOPT_0x47
	RJMP _0x2040019
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G102
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
_0x212000A:
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x204001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x204001C
_0x204001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120005
_0x204001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G102
	MOV  R17,R30
	RCALL _ks0108_setloc_G102
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x204001F
	OR   R17,R16
	RJMP _0x2040020
_0x204001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2040020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120005
; .FEND
_ks0108_wrmasked_G102:
; .FSTART _ks0108_wrmasked_G102
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G102
	MOV  R17,R30
	RCALL _ks0108_setloc_G102
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x204002B
	CPI  R30,LOW(0x8)
	BRNE _0x204002C
_0x204002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x204002D
_0x204002C:
	CPI  R30,LOW(0x3)
	BRNE _0x204002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2040030
_0x204002F:
	CPI  R30,0
	BRNE _0x2040031
_0x2040030:
_0x204002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040032
_0x2040031:
	CPI  R30,LOW(0x2)
	BRNE _0x2040033
_0x2040032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2040029
_0x2040033:
	CPI  R30,LOW(0x1)
	BRNE _0x2040034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2040029
_0x2040034:
	CPI  R30,LOW(0x4)
	BRNE _0x2040029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2040029:
	MOV  R26,R17
	CALL SUBOPT_0x47
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2040037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2040037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2040037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2040036
_0x2040037:
	RJMP _0x2120009
_0x2040036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2040039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2040039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x204003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x204003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x204003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x204003F
	RJMP _0x2120009
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040041
	RJMP _0x2120009
_0x2040041:
_0x2040042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2040044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2040043
_0x2040044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x48
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2040046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2040048
	MOV  R17,R16
_0x2040049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204004B
	CALL SUBOPT_0x49
	RJMP _0x2040049
_0x204004B:
	RJMP _0x2040046
_0x2040048:
_0x2040043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x204004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x48
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x204004D
	SUBI R19,-LOW(1)
_0x204004D:
	LDI  R18,LOW(0)
_0x204004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2040050
	LDD  R17,Y+14
_0x2040051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2040053
	CALL SUBOPT_0x49
	RJMP _0x2040051
_0x2040053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x48
	RJMP _0x204004E
_0x2040050:
_0x204004C:
_0x204003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2040054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2040057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2040058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x204005D
	CPI  R30,LOW(0x3)
	BRNE _0x204005E
_0x204005D:
	RJMP _0x204005F
_0x204005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2040060
_0x204005F:
	RJMP _0x2040061
_0x2040060:
	CPI  R30,LOW(0x8)
	BRNE _0x2040062
_0x2040061:
	RJMP _0x2040063
_0x2040062:
	CPI  R30,LOW(0x6)
	BRNE _0x2040064
_0x2040063:
	RJMP _0x2040065
_0x2040064:
	CPI  R30,LOW(0x9)
	BRNE _0x2040066
_0x2040065:
	RJMP _0x2040067
_0x2040066:
	CPI  R30,LOW(0xA)
	BRNE _0x204005B
_0x2040067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x46
_0x204005B:
_0x2040069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x204006C
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	CALL SUBOPT_0x4A
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G102
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G102
	RJMP _0x204006D
_0x204006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2040071
	LDI  R21,LOW(0)
	RJMP _0x2040072
_0x2040071:
	CPI  R30,LOW(0xA)
	BRNE _0x2040070
	LDI  R21,LOW(255)
	RJMP _0x2040072
_0x2040070:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2040079
	CPI  R30,LOW(0x8)
	BRNE _0x204007A
_0x2040079:
_0x2040072:
	CALL SUBOPT_0x4C
	MOV  R21,R30
	RJMP _0x204007B
_0x204007A:
	CPI  R30,LOW(0x3)
	BRNE _0x204007D
	COM  R21
	RJMP _0x204007E
_0x204007D:
	CPI  R30,0
	BRNE _0x2040080
_0x204007E:
_0x204007B:
	MOV  R26,R21
	CALL SUBOPT_0x47
	RJMP _0x2040077
_0x2040080:
	CALL SUBOPT_0x4D
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
_0x2040077:
_0x204006D:
	RJMP _0x2040069
_0x204006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2040081
_0x2040058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040082
_0x2040057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2040083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040084
_0x2040083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2040084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040088
_0x2040089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204008B
	CALL SUBOPT_0x4E
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x4F
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x4A
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2040089
_0x204008B:
	RJMP _0x2040087
_0x2040088:
	CPI  R30,LOW(0x9)
	BRNE _0x204008C
	LDI  R21,LOW(0)
	RJMP _0x204008D
_0x204008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2040093
	LDI  R21,LOW(255)
_0x204008D:
	CALL SUBOPT_0x4C
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2040090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040092
	CALL SUBOPT_0x4D
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040090
_0x2040092:
	RJMP _0x2040087
_0x2040093:
_0x2040094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040096
	CALL SUBOPT_0x50
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040094
_0x2040096:
_0x2040087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2040097
	RJMP _0x2040056
_0x2040097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2040098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20400AD
_0x2040098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20400AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204009D
_0x204009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A0
	CALL SUBOPT_0x4E
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x4F
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x4A
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x204009E
_0x20400A0:
	RJMP _0x204009C
_0x204009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20400A1
	LDI  R21,LOW(0)
	RJMP _0x20400A2
_0x20400A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20400A8
	LDI  R21,LOW(255)
_0x20400A2:
	CALL SUBOPT_0x4C
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20400A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A7
	CALL SUBOPT_0x4D
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A5
_0x20400A7:
	RJMP _0x204009C
_0x20400A8:
_0x20400A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400AB
	CALL SUBOPT_0x50
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A9
_0x20400AB:
_0x204009C:
_0x2040081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040054
_0x2040056:
_0x2120009:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x51
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120002
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2120002
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x51
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120002
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2060006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2120002
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120002
; .FEND
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2120002
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x52
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120008
_0x206000B:
	CALL SUBOPT_0x53
	STD  Y+7,R0
	CALL SUBOPT_0x53
	STD  Y+6,R0
	CALL SUBOPT_0x53
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120008
_0x206000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x206000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120008
_0x206000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120008
_0x206000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120008:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x54
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x52
	SBIW R30,0
	BRNE PC+2
	RJMP _0x206001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060020
	RJMP _0x2060021
_0x2060020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060022
	RJMP _0x2120007
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x54
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x54
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x55
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x2120007
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2060025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2060025
_0x2060027:
	LDD  R17,Y+0
	RJMP _0x2120005
; .FEND
_glcd_putpixelm_G103:
; .FSTART _glcd_putpixelm_G103
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x206003E
	LDS  R30,_glcd_state
	RJMP _0x206003F
_0x206003E:
	__GETB1MN _glcd_state,1
_0x206003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2060041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2060041:
	LD   R30,Y
	JMP  _0x2120001
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120002
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2060042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2060043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	RJMP _0x2120006
_0x2060043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2060044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2060045
_0x2060044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2060045:
_0x2060047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060049:
	CALL SUBOPT_0x56
	BRSH _0x206004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G103
	STD  Y+7,R30
	RJMP _0x2060049
_0x206004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2060047
	RJMP _0x206004C
_0x2060042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x206004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x206004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x206011B
_0x206004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x206011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2060051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060053:
	CALL SUBOPT_0x56
	BRSH _0x2060055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x57
	STD  Y+7,R30
	RJMP _0x2060053
_0x2060055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2060051
	RJMP _0x2060056
_0x206004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2060057:
	CALL SUBOPT_0x56
	BRLO PC+2
	RJMP _0x2060059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x206005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x206005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x206005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x206005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G103
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x206005C
_0x206005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x58
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2060060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x59
_0x2060060:
	ST   -Y,R17
	CALL SUBOPT_0x57
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x206005E
	RJMP _0x2060061
_0x206005C:
_0x2060063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x58
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2060065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x59
_0x2060065:
	ST   -Y,R17
	CALL SUBOPT_0x57
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2060063
_0x2060061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2060057
_0x2060059:
_0x2060056:
_0x206004C:
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120005:
	ADIW R28,5
	RET
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x2B
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20E000D
	CALL SUBOPT_0x5A
	__POINTW2FN _0x20E0000,0
	CALL _strcpyf
	RJMP _0x2120004
_0x20E000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20E000C
	CALL SUBOPT_0x5A
	__POINTW2FN _0x20E0000,1
	CALL _strcpyf
	RJMP _0x2120004
_0x20E000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20E000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	LDI  R30,LOW(45)
	ST   X,R30
_0x20E000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20E0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20E0010:
	LDD  R17,Y+8
_0x20E0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E0013
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x33
	CALL SUBOPT_0x5E
	RJMP _0x20E0011
_0x20E0013:
	CALL SUBOPT_0x5F
	CALL __ADDF12
	CALL SUBOPT_0x5B
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x5E
_0x20E0014:
	CALL SUBOPT_0x5F
	CALL __CMPF12
	BRLO _0x20E0016
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x30
	CALL SUBOPT_0x5E
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20E0017
	CALL SUBOPT_0x5A
	__POINTW2FN _0x20E0000,5
	CALL _strcpyf
	RJMP _0x2120004
_0x20E0017:
	RJMP _0x20E0014
_0x20E0016:
	CPI  R17,0
	BRNE _0x20E0018
	CALL SUBOPT_0x5C
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20E0019
_0x20E0018:
_0x20E001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20E001C
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x35
	LDI  R31,0
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x1E
	CALL __MULF12
	CALL SUBOPT_0x60
	CALL SUBOPT_0x23
	CALL SUBOPT_0x5B
	RJMP _0x20E001A
_0x20E001C:
_0x20E0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2120003
	CALL SUBOPT_0x5C
	LDI  R30,LOW(46)
	ST   X,R30
_0x20E001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20E0020
	CALL SUBOPT_0x60
	CALL SUBOPT_0x30
	CALL SUBOPT_0x5B
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x35
	LDI  R31,0
	CALL SUBOPT_0x60
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x23
	CALL SUBOPT_0x5B
	RJMP _0x20E001E
_0x20E0020:
_0x2120003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120002:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120001
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120001
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120001
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120001
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120001
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120001
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120001:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D

	.ESEG
_avg_eeprom:
	.BYTE 0x64

	.DSEG
_ks0108_coord_G102:
	.BYTE 0x3
__seed_G107:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	CALL _glcd_clear
	LDI  R30,LOW(5)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(55)
	JMP  _glcd_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R26,LOW(55)
	CALL _glcd_line
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL _delay_ms
	JMP  _glcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	CALL _glcd_outtextxy
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	__GETW1SX 119
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	CALL _get_key
	MOVW R16,R30
	__CPWRN 16,17,255
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 119
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	__GETW1SX 129
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	MOVW R30,R28
	SUBI R30,LOW(-(159))
	SBCI R31,HIGH(-(159))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	__POINTW1FN _0x0,55
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	__GETW1SX 133
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(10)
	ST   -Y,R30
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(161))
	SBCI R27,HIGH(-(161))
	CALL _glcd_outtextxy
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	__GETWRN 16,17,255
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	CALL _glcd_clear
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(161))
	SBCI R27,HIGH(-(161))
	CALL _glcd_outtextxy
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 131
	LDI  R30,LOW(0)
	__CLRW1SX 121
	__CLRW1SX 119
	CALL _glcd_clear
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__GETW1SX 125
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0xB
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETW1SX 123
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	__GETW1SX 127
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	__GETW1SX 131
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETW2SX 121
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	MOVW R30,R18
	MOVW R26,R28
	SUBI R26,LOW(-(151))
	SBCI R27,HIGH(-(151))
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	MOVW R30,R28
	SUBI R30,LOW(-(135))
	SBCI R31,HIGH(-(135))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R26,LOW(10)
	MULS R18,R26
	ST   -Y,R0
	MOVW R26,R28
	SUBI R26,LOW(-(137))
	SBCI R27,HIGH(-(137))
	JMP  _glcd_outtextxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	__GETD2SX 111
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	__PUTD1SX 111
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETD1N 0x40800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__GETD1SX 115
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__GETD2SX 115
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	__PUTD1SX 115
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x26:
	MOVW R22,R30
	__GETW1SX 153
	__GETW2SX 151
	ADD  R30,R26
	ADC  R31,R27
	__GETW2SX 155
	ADD  R30,R26
	ADC  R31,R27
	__GETW2SX 157
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	__GETD2SX 107
	RCALL SUBOPT_0x1E
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	CALL _glcd_clear
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R20
	ADC  R27,R21
	LD   R26,X
	RCALL SUBOPT_0xB
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2C:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2D:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x37:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x38:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x39:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3B:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x38
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3B
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x42:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x45:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LD   R30,Y
	OUT  0x15,R30
	CALL _ks0108_enable_G102
	JMP  _ks0108_disable_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	CALL _ks0108_wrdata_G102
	JMP  _ks0108_nextx_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x49:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4A:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G102
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x50:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x4B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x54:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x56:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5F:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
