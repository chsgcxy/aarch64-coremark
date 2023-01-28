# PORT README

I copied bootcode.s (and retarget-gcc.c stackheap.s vectors.s pagetables.s output.h output_trickbox.c boot_defs.hs link_csrc_aarch64.ld) from a version of dhrystone arm supported.

this barebones target is verified on Gem5

when use on VCS or emulation environment, maybe you should replace those files I have added, for different arm core has different startup files.(but file name are similar)

## run on gem5

```shell
./build/ARM/gem5.debug \
configs/example/fs.py \
--machine-type=VExpress_GEM5_V2 \
-n1 --bare-metal \
--kernel ./coremark.elf
```

### result

```text
init!
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 0
Total time (secs): 0.000000
ERROR! Must execute for at least 10 secs for a valid result!
Iterations       : 1
Compiler version : GCC10.3.1 20210621
Compiler flags   : -O2 -g -DGCC -DPERFORMANCE_RUN=1
Memory location  : STACK
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0xe714
Errors detected
```

## notes

function barebones_clock() always return 0, so there has an ERROR, this is to be solved.
