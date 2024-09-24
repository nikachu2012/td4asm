      out 0b0111
      add a, 1 
      jnc 0b1
      add a, 1
      jnc 0b11
      out 0b110
      add a, 1
      jnc 0b110
      add a, 1
      jnc 0x8
      out 0
      out 0b100
      add a, 1
      jnc 0b1010
      out 0x8
loop: jmp loop
