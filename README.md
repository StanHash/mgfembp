# FE6 Report MultiBoot payload

This is decompilation of a compressed binary that is found in most release ROMs of FE7 and FE8. That binary, when loaded into EWRAM, reports information about save data from an inserted FE6 cartridge via serial communication, presumably enabling some bonus features in japanese FE7.

This builds the following binaries:

- **mgfembp.bin** `sha1: 8a81a47d88f6b0a3f91c49784b9f7b317382abac`
- **mgfembp_20030206.bin** `sha1: 6674fc5b5ee26433665c44b842cdb26bcf785051`
- **mgfembp_20030219.bin** `sha1: ad3ffdb4fc50206f944972a0a7ad26bfa8b5ef74`

**mgfembp.bin** is the final binary that is found in releases of FE7 (JP, US) and FE8 (JP, US, EU). **mgfembp_20030206.bin** and **mgfembp_20030219.bin** are the binaries that are found in the 2003-02-06 and 2003-02-19 beta builds of FE7, respectively.

Big thanks to pfero from the pret Discord for figuring out my compiler issues.

## Quick setup

```bash
# on Debian/Ubuntu variants (such as default WSL2)
sudo apt install build-essential gcc-arm-none-eabi libpng-dev
tools/install-agbcc.sh
make tools
make
```

This requires a very specific variant of the compiler (010110-ThumbPatch) (the install-agbcc script should handle that).

## See also

- **[StanHash/fe1]**: A disassembly of _Fire Emblem: Ankoku Ryu to Hikari no Tsurugi_ for the Famicom (dormant).
- **[ZaneAvernathy/FireEmblem5]**: A disassembly of _Fire Emblem: Thracia 776_ for the Super Famicom.
- **[StanHash/fe6]**: A decompilation of _Fire Emblem - Fūin no Tsurugi_ for the GameBoy Advance.
- **[MokhaLeee/FireEmblem7J]**, a decompilation of _Fire Emblem: Rekka no Ken_ (JP) for the GameBoy Advance.
- **[FireEmblemUniverse/fireemblem8u]**: A decompilation of _Fire Emblem: The Sacred Stones_ (US) for the GameBoy Advance.

[StanHash/fe1]: https://github.com/StanHash/fe1
[ZaneAvernathy/FireEmblem5]: https://github.com/ZaneAvernathy/FireEmblem5
[StanHash/fe6]: https://github.com/StanHash/fe6
[MokhaLeee/FireEmblem7J]: https://github.com/MokhaLeee/FireEmblem7J
[FireEmblemUniverse/fireemblem8u]: https://github.com/FireEmblemUniverse/fireemblem8u

## Contact

You can find me over at the [Fire Emblem Universe Discord](https://feuniverse.us/t/feu-discord-server/1480?u=stanh) under the handle `nat_776`. I also lurk some other places like the pret discord.
