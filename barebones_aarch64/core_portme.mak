# Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Original Author: Shay Gal-on

#File : core_portme.mak
AARCH64_TOOLS = aarch64-none-elf-
# Flag : OUTFLAG
#	Use this flag to define how to to get an executable (e.g -o)
OUTFLAG= -o
# Flag : CC
#	Use this flag to define compiler to use
CC 		= $(AARCH64_TOOLS)gcc
# Flag : LD
#	Use this flag to define compiler to use
LD		= $(AARCH64_TOOLS)gcc
# Flag : AS
#	Use this flag to define compiler to use
AS		= $(AARCH64_TOOLS)as
# Flag : OBJDUMP
#	Use this flag to define compiler to use
OBJDUMP		= $(AARCH64_TOOLS)objdump
# Flag : CFLAGS
#	Use this flag to define compiler options. Note, you can add compiler options from the command line using XCFLAGS="other flags"
PORT_CFLAGS = -O2 -g -DGCC
FLAGS_STR = "$(PORT_CFLAGS) $(XCFLAGS) $(XLFLAGS) $(LFLAGS_END)"
CFLAGS = $(PORT_CFLAGS) -I$(PORT_DIR) -I. -DFLAGS_STR=\"$(FLAGS_STR)\" 
#Flag : LFLAGS_END
#	Define any libraries needed for linking or other flags that should come at the end of the link line (e.g. linker scripts). 
#	Note : On certain platforms, the default clock_gettime implementation is supported but requires linking of librt.
SEPARATE_COMPILE=1
# Flag : SEPARATE_COMPILE
# You must also define below how to create an object file, and how to link.
OBJOUT 	= -o
LFLAGS 	= -T $(PORT_DIR)/link_csrc_aarch64.ld -static
ARCH = armv8.5-a
ASFLAGS = -march=$(ARCH) -I$(PORT_DIR)
OFLAG 	= -o
COUT 	= -c

# avoid auto-turning iterations
ifndef ITERATIONS
ITERATIONS=1
endif

LFLAGS_END =
# Flag : PORT_SRCS
# 	Port specific source files can be added here
#	You may also need cvt.c if the fcvt functions are not provided as intrinsics by your compiler!
PORT_SRCS_C = $(addprefix $(PORT_DIR)/, core_portme ee_printf cvt output_trickbox retarget-gcc)
PORT_SRCS_S = $(addprefix $(PORT_DIR)/, bootcode pagetables stackheap vectors)

PORT_SRCS = $(addsuffix .c, $(PORT_SRCS_C)) $(addsuffix .s, $(PORT_SRCS_S))

PORT_OBJS = $(addsuffix $(OEXT), $(PORT_SRCS_C) $(PORT_SRCS_S))

PORT_INCLUDE = $(wildcard $(PORT_DIR)/*.h)

EXTRA_DEPENDS = $(PORT_INCLUDE) $(PORT_DIR)/core_portme.mak $(PORT_DIR)/link_csrc_aarch64.ld

vpath %.c $(PORT_DIR)
vpath %.s $(PORT_DIR)

# Flag : LOAD
#	For a simple port, we assume self hosted compile and run, no load needed.

# Flag : RUN
#	For a simple port, we assume self hosted compile and run, simple invocation of the executable

LOAD = echo "Please set LOAD to the process of loading the executable to the flash"
RUN = echo "Please set LOAD to the process of running the executable (e.g. via jtag, or board reset)"

OEXT = .o
EXE = .elf

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.c $(EXTRA_DEPENDS)
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.c $(EXTRA_DEPENDS)
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.s $(EXTRA_DEPENDS)
	$(AS) $(ASFLAGS) $< $(OBJOUT) $@

# Target : port_pre% and port_post%
# For the purpose of this simple port, no pre or post steps needed.


.PHONY: port_prebuild
port_prebuild:
	
# Target: port_postbuild
# Generate any files that are needed after actual build end.
# E.g. change format to srec, bin, zip in order to be able to load into flash
.PHONY: port_postbuild
port_postbuild:
	@echo "=============================================="
	@echo "barebones_aarch64 build succeed!"
	@echo "you can run coremark.elf in your environment!"
	@echo "=============================================="
# Target: port_postrun
# 	Do platform specific after run stuff. 
#	E.g. reset the board, backup the logfiles etc.
.PHONY: port_postrun
port_postrun:
# Target: port_prerun
# 	Do platform specific after run stuff. 
#	E.g. reset the board, backup the logfiles etc.
.PHONY: port_prerun
port_prerun:

# Target: port_postload
# 	Do platform specific after load stuff. 
#	E.g. reset the reset power to the flash eraser
.PHONY: port_postload
port_postload:

# Target: port_preload
# 	Do platform specific before load stuff. 
#	E.g. reset the reset power to the flash eraser
.PHONY: port_preload
port_preload:

# FLAG : OPATH
# Path to the output folder. Default - current folder.
OPATH = ./
MKDIR = mkdir -p

