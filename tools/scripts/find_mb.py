from typing import List


def find_extra_logos_in_rom(rom: bytes):
    # don't need to hardcode the logo as we can just read it from the ROM
    ninty_logo = rom[0x04:0xA0]

    # start searching just after the header
    offset = 0xC0

    while True:
        offset = rom.find(ninty_logo, offset)

        if offset == -1:
            break

        yield offset
        offset = offset + len(ninty_logo)


def largest_match(data_a: bytes, data_b: bytes) -> int:
    min_len = min(len(data_a), len(data_b))

    for i in range(min_len):
        if data_a[i] != data_b[i]:
            return i

    return min_len


def pretty_path(path: str) -> str:
    return f'"{path[path.rfind("/") + 1:]}"'


def main(args: List[str]):
    if len(args) == 1:
        return f"Usage: {args[0]} ROM..."

    rom_path_list = args[1:]
    rom_dict = dict()

    match_list = []

    for rom_path in rom_path_list:
        rom_path_pretty = rom_path[rom_path.rfind("/") + 1 :]

        with open(rom_path, "rb") as f:
            rom = f.read()

            rom_dict[rom_path] = rom

            for offset in find_extra_logos_in_rom(rom):
                match_list.append((rom_path, offset - 4))

    if len(match_list) == 0:
        return 0

    print("matches:")

    for i, (rom_path, offset) in enumerate(match_list):
        print(f"{0x08000000 + offset:08X} {pretty_path(rom_path)}")

    print()

    ref_off = None
    ref_rom = None

    for rom_path, off in match_list:
        if ref_off == None:
            ref_off = off
            ref_rom = rom_dict[rom_path]

            big = len(ref_rom) - ref_off
            continue

        share = largest_match(
            ref_rom[ref_off : ref_off + big], rom_dict[rom_path][off:]
        )

        big = min(big, share)

    print("shared sizes:")

    for i, (rom_path_a, off_a) in enumerate(match_list):
        for rom_path_b, off_b in match_list[i + 1 :]:
            rom_a = rom_dict[rom_path_a]
            rom_b = rom_dict[rom_path_b]

            length = largest_match(rom_a[off_a:], rom_b[off_b:])

            print(
                f"{length:08X} {off_a + 0x08000000:08X}({pretty_path(rom_path_a)}) {off_b + 0x08000000:08X}({pretty_path(rom_path_b)})"
            )

    print()

    print("decompress script:")

    shared_head: bytes = rom_dict[match_list[0][0]][
        match_list[0][1] : match_list[0][1] + big
    ]

    if (big >= 0x2B1) & (shared_head[0x2B0] == 0x10):
        for i, (rom_path, offset) in enumerate(match_list):
            payload_offset = offset + 0x2B0
            print(
                f'tools/decompress/decompress "{rom_path}" 0x{payload_offset:08X} > {i}.dmp'
            )

    with open("mb_base.gba", "wb") as f:
        rom = rom_dict[match_list[0][0]]
        off = match_list[0][1]
        f.write(rom[off : off + big])

    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv[:]))
