# Assembly info

## Data bus
```
|     4 bit     |     4 bit     |
+---+---+---+---+---+---+---+---+
|    Op code    |    Im data    |
+---+---+---+---+---+---+---+---+
```

## instruction list
[reg] = `A`, `B`  
[Im] = `8`, `0b1000`, `0x8`, `1000b`, `8h`

- `MOV A, [Im]`
- `MOV B, [Im]`
- `MOV A, B`
- `MOV B, A`
- `ADD A, [Im]`
- `ADD B, [Im]`
- `IN A` (`MOV A, C`)
- `IN B` (`MOV B, C`)
- `OUT [Im]` (`MOV C, [Im]`)
- `OUT B` (`MOV C, B`)
- `JMP [Im]` 
- `JNC [Im]` (if (C != 1) then `JMP [Im]`)
