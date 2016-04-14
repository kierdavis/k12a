type
  Opcode* = enum
    mov
    inc
    in_
    ld
    ldd
    dec
    out_
    st
    std
    sk
    ski
    skn
    skni
    rjmp
    rcall
    ljmp
    halt
  
  MovDest* = enum
    regA
    regB
    regC
    regD
  
  MovSource* = enum
    aluAB
    aluAI
    regC
    regD
  
  AluFunction* = enum
    funcA
    funcAnd
    funcOr
    funcXor
    funcAdd
    funcSub
    funcShr
    funcB
  
  Flag* = enum
    flagZero
    flagNegative
    flagBorrow
    flagOverflow
    flagULT
    flagULE
    flagSLT
    flagSLE
  
  Instruction* = object
    case opcode: Opcode
    of mov:
      dest: MovDest
      source: MovSource
      func: AluFunction
      operand: uint8
    of in_, out_:
      port: range[0u8..7u8]
    of ldd, std:
      address: uint8
    of sk, skn:
      flag: Flag
    of ski, skni:
      flag: Flag
      operand: uint8
    of rjmp, rcall:
      offset: range[-1024i16..1023i16]
    of inc, dec, ld, st, ljmp, halt:
      # no operands

proc encode*(dest: MovDest): range[0u16..3u16] =
  case dest
  of regA: 0u16
  of regB: 1u16
  of regC: 2u16
  of regD: 3u16

proc encode*(source: MovSource): range[0u16..3u16] =
  case source
  of aluAB: 0u16
  of aluAI: 1u16
  of regC:  2u16
  of regD:  3u16

proc encode*(func: AluFunction): range[0u16..7u16] =
  case func
  of funcA:   0u16
  of funcAnd: 1u16
  of funcOr:  2u16
  of funcXor: 3u16
  of funcAdd: 4u16
  of funcSub: 5u16
  of funcShr: 6u16
  of funcB:   7u16

proc encode*(flag: Flag): range[0u16..7u16] =
  case flag
  of flagZero:     0u16
  of flagNegative: 1u16
  of flagBorrow:   2u16
  of flagOverflow: 3u16
  of flagULT:      4u16
  of flagULE:      5u16
  of flagSLT:      6u16
  of flagSLE:      7u16

proc encode*(inst: Instruction): uint16 =
  case inst.opcode
  of mov:   0x0800u16 | (inst.dest.encode() << 14) | (inst.source.encode() << 12) | (inst.func.encode() << 8) | inst.operand.uint16()
  of inc:   0x0000u16
  of in_:   0x1000u16 | inst.port.uint16()
  of ld:    0x2000u16
  of ldd:   0x3000u16 | inst.address.uint16()
  of dec:   0x4000u16
  of out_:  0x5000u16 | inst.port.uint16()
  of st:    0x6000u16
  of std:   0x7000u16 | inst.address.uint16()
  of sk:    0x8000u16 | (inst.flag.encode() << 8)
  of ski:   0x9000u16 | (inst.flag.encode() << 8) | inst.operand.uint16()
  of skn:   0xA000u16 | (inst.flag.encode() << 8)
  of skni:  0xB000u16 | (inst.flag.encode() << 8) | inst.operand.uint16()
  of rjmp:  0xC000u16 | (inst.offset.uint16() & 0x07FF)
  of rcall: 0xD000u16 | (inst.offset.uint16() & 0x07FF)
  of ljmp:  0xE000u16
  of halt:  0xF000u16
