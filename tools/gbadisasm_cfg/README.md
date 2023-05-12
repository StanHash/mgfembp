Those were used to generate base asm code, using a variant of gbadisasm (jiang fork, modified to output ".L" prefixed labels):

- common.cfg is common for all mgfembp variants.
- mgfembp.cfg is for the final mgfembp variant present in FE7 (JP, US) and FE8 (JP, US, EU).
- mgfembp_20030206.cfg is for the variant present in the 2003-02-06 beta build of FE7 (JP).
- mgfembp_20030219.cfg is for the variant present in the 2003-02-19 beta build of FE7 (JP).

The script used to disassemble looked like this:

```bash
#!/bin/bash

for name in mgfembp mgfembp_20030206 mgfembp_20030219
do
    tmp=$(mktemp)
    cat bins/common.cfg bins/$name.cfg > $tmp
    echo "    .include \"asm/head.inc\"" > bins/$name.s
    tools/gbadisasm/gbadisasm bins/$name.dmp -s -l 0x02010000 -c $tmp >> bins/$name.s
    rm -f $tmp
done
```
