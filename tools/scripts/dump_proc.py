import sys
import symbols


def read_int(f, count, signed=False):
    return int.from_bytes(f.read(count), byteorder="little", signed=signed)


LOAD_ADDR = 0x02010000


def main(args):
    try:
        elf_name = args[0]
        rom_name = args[1]
        offset = int(args[2], base=0)

    except IndexError:
        sys.exit(f"Usage: {sys.argv[0]} ELF ROM OFFSET")

    if offset > LOAD_ADDR:
        # this is to allow both offsets and addresses as input
        # (this only works if the LOAD_ADDR is larger than the binary size, but that is usually the case)
        offset = offset - LOAD_ADDR

    with open(elf_name, "rb") as f:
        syms = {addr: name for addr, name in symbols.from_elf(f)}

    addr = offset + LOAD_ADDR
    name = syms[addr] if addr in syms else f"ProcScr_Unk_{offset + LOAD_ADDR:08X}"

    print(f"struct ProcScr SHOULD_BE_CONST {name}[] =")
    print("{")

    with open(rom_name, "rb") as f:
        f.seek(offset)

        while True:
            offset = offset + 8

            opc = read_int(f, 2)
            arg = read_int(f, 2)
            ptr = read_int(f, 4)

            sym = syms[ptr] if ptr in syms else f"0x{ptr:08X}"

            if opc == 0x00:
                print("    PROC_END,")
                break

            if opc == 0x01:
                print(f"    PROC_NAME({sym}),")
                continue

            if opc == 0x02:
                print(f"    PROC_CALL({sym}),")
                continue

            if opc == 0x03:
                print(f"    PROC_REPEAT({sym}),")
                continue

            if opc == 0x04:
                print(f"    PROC_ONEND({sym}),")
                continue

            if opc == 0x05:
                print(f"    PROC_START_CHILD({sym}),")
                continue

            if opc == 0x06:
                print(f"    PROC_START_CHILD_LOCKING({sym}),")
                continue

            if opc == 0x07:
                print(f"    PROC_START_BUGGED({sym}),")
                continue

            if opc == 0x08:
                print(f"    PROC_WHILE_EXISTS({sym}),")
                continue

            if opc == 0x09:
                print(f"    PROC_END_EACH({sym}),")
                continue

            if opc == 0x0A:
                print(f"    PROC_BREAK_EACH({sym}),")
                continue

            if opc == 0x0B:
                print(f"PROC_LABEL({arg}),")
                continue

            if opc == 0x0C:
                print(f"    PROC_GOTO({arg}),")
                continue

            if opc == 0x0D:
                print(f"    PROC_GOTO_SCR({sym}),")
                break

            if opc == 0x0E:
                print(f"    PROC_SLEEP({arg}),")
                continue

            if opc == 0x0F:
                print(f"    PROC_MARK({arg}),")
                continue

            if opc == 0x10:
                print("    PROC_BLOCK,")
                break

            if opc == 0x11:
                print("    PROC_END_IF_DUP,")
                continue

            if opc == 0x12:
                print("    PROC_SET_FLAG2,")
                continue

            if opc == 0x13:
                print("    PROC_13,")
                continue

            if opc == 0x14:
                print(f"    PROC_WHILE({sym}),")
                continue

            if opc == 0x15:
                print("    PROC_15,")
                continue

            if opc == 0x16:
                print(f"    PROC_CALL_2({sym}),")
                continue

            if opc == 0x17:
                print("    PROC_END_DUPS,")
                continue

            if opc == 0x18:
                print(f"PROC_CALL_ARG({sym}, {arg}),")
                continue

            if opc == 0x19:
                print("    PROC_19,")
                continue

            break

    print("};")
    print(f"// end at {offset+LOAD_ADDR:08X}")


if __name__ == "__main__":
    main(sys.argv[1:])
