# The Mysterious Gba Fire Emblem something something binary

This might not be a MultiBoot payload, I'm not sure, but it does get loaded into EWRAM. I wonder if this isn't related to the FE6 to FE7 save linking thingy that I once heard to be a thing?

This builds the following binaries:

- **mgfembp.bin** `sha1: 8a81a47d88f6b0a3f91c49784b9f7b317382abac`
- **mgfembp_20030206.bin** `sha1: 6674fc5b5ee26433665c44b842cdb26bcf785051`
- **mgfembp_20030219.bin** `sha1: ad3ffdb4fc50206f944972a0a7ad26bfa8b5ef74`

**mgfembp.bin** is the final binary that is found in releases of FE7 (JP, US) and FE8 (JP, US, EU). **mgfembp_20030206.bin** and **mgfembp_20030219.bin** are the binaries that are found in the 2003-02-06 and 2003-02-19 beta builds of FE7, respectively.

## Quick setup

```bash
# on Debian/Ubuntu variants (such as default WSL2)
sudo apt install build-essential gcc-arm-none-eabi
tools/install-agbcc.sh
make
```

## The problem

Most functions match when using old_agbcc (the compiler fe6 uses); Some only match with "new" agbcc; and then I found one whose body matches with agbcc but requires old_agbcc prologue/epilogue emission behavior (see: https://decomp.me/scratch/8D6rH).

This makes me think this uses some GCC version (or patch version) that is between old_agbcc and "new" agbcc. Which sucks because I didn't plan on having the time to look into something like that. So this will be probably be dormant for a bit.

If someone wants to look into this it would be nice.

## See also

- **[StanHash/fe1]**: A disassembly of the first _Fire Emblem_ game for the Famicom (the project is dormant as of writing).
- **[ZaneAvernathy/FireEmblem5]**: A disassembly of _Fire Emblem: Thracia 776_ for the Super Famicom.
- **[StanHash/fe6]**: A decompilation of _Fire Emblem - Fuuin no Tsurugi_ (a.k.a. _Fire Embem - The Binding Blade_) for the GameBoy Advance.
- **[FireEmblemUniverse/fireemblem8u]**: A decompilation of _Fire Emblem: The Sacred Stones_ (US) for the GameBoy Advance.

[StanHash/fe1]: https://github.com/StanHash/fe1
[ZaneAvernathy/FireEmblem5]: https://github.com/ZaneAvernathy/FireEmblem5
[StanHash/fe6]: https://github.com/StanHash/fe6
[FireEmblemUniverse/fireemblem8u]: https://github.com/FireEmblemUniverse/fireemblem8u

## Contact

You can find me over at the [Fire Emblem Universe Discord](https://feuniverse.us/t/feu-discord-server/1480?u=stanh) under the handle `nat5#4387`. I also lurk some other places like the pret discord.
