MAIN:
  ldi   r0, 0
  ldi   r1, 1
  ldi   r3, 2
LOOP:
  subi  r4, r3, 6
  brz   DONE
  add   r4, r0, r1
  mov   r0, r1
  mov   r1, r4
  addi  r3, r3, 1
  jmp   LOOP
DONE:
  jmp   DONE
