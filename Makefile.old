# makefile

#
# Patches/Installs/Builds DSDT patches for Dell XPS 13 9333
#
# Created by RehabMan 
# Adapted by vbourachot for XPS 13 9333
#

# DSDT patch: from compiled acpi tables to installed patched dsdt/ssdt-1
# make distclean disassemble patch && make && make install
#
# AppleHDA patch: Create injector kext and install in SLE
# make patch_hda && sudo make install_hda
#
# Install Clover config
# make install_config

PRODUCTS=$(BUILDDIR)/dsdt.aml $(BUILDDIR)/SSDT-9.aml $(BUILDDIR)/SSDT-11.aml $(BUILDDIR)/SSDT-12.aml $(BUILDDIR)/SSDT-14.aml $(BUILDDIR)/SSDT-15.aml

IASLFLAGS=-vr -w1 -ve

all: $(PRODUCTS)

dsdt: decompile_dsdt patch_dsdt

# Decompile DSDT from raw folder
decompile_dsdt:
	./tools/iasl -w1 -da ./DSDT/raw/DSDT.aml ./DSDT/raw/SSDT-*.aml &> ./logs/iasl_decompile.log
	cp ./DSDT/raw/DSDT.dsl ./DSDT/decompiled/
	cp ./DSDT/raw/SSDT-9.dsl ./DSDT/decompiled/
	cp ./DSDT/raw/SSDT-1[1245].dsl ./DSDT/decompiled/

# Patch decompiled DSDT with patchmatic
patch_dsdt:
	########################
	# DSDT Patches
	########################

	# [1.8] Fix PARSEOP_ZERO Error
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_PARSEOP_ZERO.txt ./DSDT/decompiled/DSDT.dsl

	# [1.5] Fix ADBG Error
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_ADBG.txt ./DSDT/decompiled/DSDT.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/DSDT.dsl

	# [3.2] 7-series/8-series USB
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/usb/usb_7-series.txt ./DSDT/decompiled/DSDT.dsl

	# [4.01] Acer Aspire E1-571
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/battery/battery_Acer-Aspire-E1-571.txt ./DSDT/decompiled/DSDT.dsl

	# [7.01] IRQ Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IRQ.txt ./DSDT/decompiled/DSDT.dsl

	# [7.02] SMBus Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_SMBUS.txt ./DSDT/decompiled/DSDT.dsl

	# [7.03] RTC Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_RTC.txt ./DSDT/decompiled/DSDT.dsl

	# [7.05] Shutdown Fix v2
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_Shutdown2.txt ./DSDT/decompiled/DSDT.dsl

	# [7.06] HPET Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_HPET.txt ./DSDT/decompiled/DSDT.dsl

	# [7.07] OS Check Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_OSYS.txt ./DSDT/decompiled/DSDT.dsl

	# [7.08] AC Adapter Fix
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_ADP1.txt ./DSDT/decompiled/DSDT.dsl

	# [7.09] Add MCHC
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_MCHC.txt ./DSDT/decompiled/DSDT.dsl

	# [7.11] Fix _WAK Arg0 v2
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_WAK2.txt ./DSDT/decompiled/DSDT.dsl

	# [7.14] Add IMEI
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IMEI.txt ./DSDT/decompiled/DSDT.dsl

	# Audio Layout
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/audio_HDEF-layout1.txt ./DSDT/decompiled/DSDT.dsl

	# Rename B0D3 to HDAU
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/audio_B0D3_HDAU.txt ./DSDT/decompiled/DSDT.dsl

	########################
	# SSDT-9 Patches
	########################

	# _BST package size
	./tools/patchmatic ./DSDT/decompiled/SSDT-9.dsl ./DSDT/patches/_BST-package-size.txt ./DSDT/decompiled/SSDT-9.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic ./DSDT/decompiled/SSDT-9.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-9.dsl

	########################
	# SSDT-11 Patches
	########################

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic ./DSDT/decompiled/SSDT-11.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-11.dsl

	# [2.05] Haswell HD4400/HD4600/HD5000 (Modified)
	./tools/patchmatic ./DSDT/decompiled/SSDT-11.dsl ./DSDT/patches/graphics_Intel_HD4600.txt ./DSDT/decompiled/SSDT-11.dsl

	# [2.11] Brightness fix (Haswell)
	./tools/patchmatic ./DSDT/decompiled/SSDT-11.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_PNLF_haswell.txt ./DSDT/decompiled/SSDT-11.dsl

	# Rename B0D3 to HDAU
	./tools/patchmatic ./DSDT/decompiled/SSDT-11.dsl ./DSDT/patches/audio_B0D3_HDAU.txt ./DSDT/decompiled/SSDT-11.dsl

	# Insert HDAU device
	./tools/patchmatic ./DSDT/decompiled/SSDT-11.dsl ./DSDT/patches/audio_Intel_HD4600.txt ./DSDT/decompiled/SSDT-11.dsl

	########################
	# SSDT-12 Patches
	########################

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-12.dsl

	########################
	# SSDT-14 Patches
	########################

	# Remove invalid operands
	./tools/patchmatic ./DSDT/decompiled/SSDT-14.dsl ./DSDT/patches/WMMX-invalid-operands.txt ./DSDT/decompiled/SSDT-14.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic ./DSDT/decompiled/SSDT-14.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-14.dsl

	# Disable Nvidia card (Non-operational in OS X)
	./tools/patchmatic ./DSDT/decompiled/SSDT-14.dsl ./DSDT/patches/graphics_Disable_Nvidia.txt ./DSDT/decompiled/SSDT-14.dsl

patch_wifi:
	# BCM4352 Wifi
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/BCM4352_wifi.txt ./DSDT/decompiled/DSDT.dsl

compile_dsdt:
	# Patched BIOS DSDT
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/DSDT.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/DSDT.dsl
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-9.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-9.dsl
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-11.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-11.dsl
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-12.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-12.dsl
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-14.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-14.dsl
#	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-15.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-15.dsl

	# Additional custom SSDT
	# Rehabman NullEthernet.kext
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-16.aml ./DSDT/custom/SSDT-rmne.dsl

	# ssdtPRgen (P-states / C-states)
	./tools/iasl $(IASLFLAGS) -p ./DSDT/compiled/SSDT-17.aml ./DSDT/custom/SSDT-pr.dsl

clean:
	rm -rf ./DSDT/decompiled/*
	rm -rf ./DSDT/compiled/*

distclean: clean

