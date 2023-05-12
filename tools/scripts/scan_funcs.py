def main(args):
    try:
        bin_path = args[1]
        beg_off = int(args[2], base=0)
        end_off = int(args[3], base=0)

    except IndexError:
        return f"Usage: {args[0]} BINARY BEGIN END"

    if beg_off >= 0x02010000:
        beg_off = beg_off - 0x02010000

    if end_off >= 0x02010000:
        end_off = end_off - 0x02010000

    with open(bin_path, "rb") as f:
        data = f.read()

    for i in range((end_off - beg_off) // 4):
        off = beg_off + i * 4
        byte = data[off : off + 2]
        word = int.from_bytes(byte, byteorder="little")

        if word & 0xFF00 == 0b1011_0101_0000_0000:
            print(f"thumb_func 0x{off+0x02010000:08X}")
            continue

        byte = data[off : off + 4]
        word = int.from_bytes(byte, byteorder="little")

        if word & 0xFF00FE00 == 0b1011_0101_0000_0000_1011_0100_0000_0000:
            print(f"thumb_func 0x{off+0x02010000:08X}")
            continue


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv[:]))
