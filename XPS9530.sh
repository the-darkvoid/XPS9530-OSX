#!/bin/sh

# Bold / Non-bold
BOLD="\033[1m"
RED="\033[0;31m"
#echo -e "\033[0;32mCOLOR_GREEN\t\033[1;32mCOLOR_LIGHT_GREEN"
OFF="\033[m"

# Repository location
REPO=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_DIR="${REPO}"

git_update()
{
	echo "Initializing Laptop-DSDT-Patch & ssdtPRgen"
	git submodule update --init --recursive
	
	echo "Updating Laptop-DSDT-Patch & ssdtPRgen"
	git submodule foreach git pull origin master
}

decompile_dsdt() 
{
	echo "Decompiling DSDT / SSDT in ./DSDT/raw"
	cd "${REPO}"

	./tools/iasl -w1 -da ./DSDT/raw/DSDT.aml ./DSDT/raw/SSDT-*.aml &> ./logs/dsdt_decompile.log
	echo "Log created in ./logs/dsdt_decompile.log"
	rm ./DSDT/decompiled/*
	cp ./DSDT/raw/DSDT.dsl ./DSDT/decompiled/
	cp ./DSDT/raw/SSDT-1[0235].dsl ./DSDT/decompiled/
}

patch_dsdt()
{
	echo "${RED}Patching DSDT in ./DSDT/decompiled${OFF}"
	
	echo "${BOLD}[syn] Fix PARSEOP_ZERO Error${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_PARSEOP_ZERO.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[syn] Fix ADBG Error${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_ADBG.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[usb] 7-series/8-series USB${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/usb/usb_7-series.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[bat] Acer Aspire E1-571${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/battery/battery_Acer-Aspire-E1-571.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] IRQ Fix${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IRQ.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] SMBus Fix${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_SMBUS.txt ./DSDT/decompiled/DSDT.dsl

	#echo "${BOLD}[sys] HPET Fix${OFF}" # (No HPETs available..), Check if boot / wakeup works
	#./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_HPET.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] OS Check Fix${OFF}"
	#./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_OSYS.txt ./DSDT/decompiled/DSDT.dsl
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/system_OSYS.txt ./DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}[sys] AC Adapter Fix${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_ADP1.txt ./DSDT/decompiled/DSDT.dsl
	#./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/system_AC.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Add MCHC${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_MCHC.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix _WAK Arg0 v2${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_WAK2.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Add IMEI${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IMEI.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix PNOT/PPNT${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_PNOT.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix Non-zero Mutex${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_Mutex.txt ./DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}[sys] Add Haswell LPC${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./externals/Laptop-DSDT-Patch/misc/misc_Haswell-LPC.txt ./DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}Audio Layout${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/audio_HDEF-layout1.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}Rename B0D3 to HDAU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/audio_B0D3_HDAU.txt ./DSDT/decompiled/DSDT.dsl

	echo "${BOLD}Remove GLAN device${OFF}"
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/remove_glan.txt ./DSDT/decompiled/DSDT.dsl

	########################
	# SSDT-10 Patches
	########################
	
	echo "${RED}Patching SSDT-10 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}_BST package size${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-10.dsl ./DSDT/patches/_BST-package-size.txt ./DSDT/decompiled/SSDT-10.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-10.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-10.dsl

	########################
	# SSDT-12 Patches
	########################

	echo "${RED}Patching SSDT-12 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Haswell HD4400/HD4600/HD5000 (Yosemite - Modified)${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./DSDT/patches/graphics_Intel_HD4600.txt ./DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}[gfx] Brightness fix (Haswell)${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_PNLF_haswell.txt ./DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Rename B0D3 to HDAU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./DSDT/patches/audio_B0D3_HDAU.txt ./DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Insert HDAU device${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-12.dsl ./DSDT/patches/audio_Intel_HD4600.txt ./DSDT/decompiled/SSDT-12.dsl

	########################
	# SSDT-13 Patches
	########################

	echo "${RED}Patching SSDT-13 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-13.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-13.dsl

	########################
	# SSDT-15 Patches
	########################

	echo "${RED}Patching SSDT-15 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}Remove invalid operands${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-15.dsl ./DSDT/patches/WMMX-invalid-operands.txt ./DSDT/decompiled/SSDT-15.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-15.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ./DSDT/decompiled/SSDT-15.dsl

	echo "${BOLD}Disable Nvidia card (Non-operational in OS X)${OFF}"
	./tools/patchmatic ./DSDT/decompiled/SSDT-15.dsl ./DSDT/patches/graphics_Disable_Nvidia.txt ./DSDT/decompiled/SSDT-15.dsl
}

patch_wifi()
{
    echo "Adding BCM94352Z Combo WiFi support in ./DSDT/compiled"
    cd "${REPO}"
		
	# BCM4352 Wifi
	./tools/patchmatic ./DSDT/decompiled/DSDT.dsl ./DSDT/patches/BCM4352_wifi.txt ./DSDT/decompiled/DSDT.dsl
}

compile_dsdt()
{
	echo "Compiling DSDT / SSDT in ./DSDT/compiled"
	cd "${REPO}"

	rm ./DSDT/compiled/*

	echo "${RED}Compiling DSDT to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/DSDT.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/DSDT.dsl

	echo "${RED}Compiling SSDT-10 to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-10.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-10.dsl

	echo "${RED}Compiling SSDT-12 to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-12.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-12.dsl

	echo "${RED}Compiling SSDT-13 to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-13.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-13.dsl

	echo "${RED}Compiling SSDT-15 to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-15.aml -I ./DSDT/decompiled/ ./DSDT/decompiled/SSDT-15.dsl

	# Additional custom SSDT
	# Rehabman NullEthernet.kext
	echo "${RED}Compiling SSDT-rmne to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-16.aml ./DSDT/custom/SSDT-rmne.dsl

	# ssdtPRgen (P-states / C-states)
	echo "${RED}Compiling ssdtPRgen to ./DSDT/compiled${OFF}"
	./tools/iasl -vr -w1 -ve -p ./DSDT/compiled/SSDT-17.aml ./DSDT/custom/SSDT-pr.dsl
}

patch_iokit()
{
	iokit_md5=$(md5 -q "/System/Library/Frameworks/IOKit.framework/Versions/Current/IOKit")
	
	echo "${RED}Current IOKit md5 is${OFF} ${BOLD}${iokit_md5}${OFF}"
	
	case $iokit_md5 in
		"2a8cbc2f6616d3f7a5e499bd2d5593ab")
		echo "\t--> ${BOLD}Yosemite 10.10.1 IOKit (unpatched)${OFF}"
		sudo perl -i.bak -pe 's|\xB8\x01\x00\x00\x00\xF6\xC1\x01\x0F\x85|\x33\xC0\x90\x90\x90\x90\x90\x90\x90\xE9|sg' /System/Library/Frameworks/IOKit.framework/Versions/Current/IOKit
		echo "\tPatched"
		;;
		"8756e20f979c9e74c80f07b452ebfadd")
		echo "\t--> ${BOLD}Yosemite 10.10.1 IOKit (patched, not signed)${OFF}"
		;;
		"f834136d72126cc9479604879270d24f")
		echo " --> ${BOLD}Yosemite 10.10.1 IOKit (patched)${OFF}"
		echo "IOKit is already patched, no action taken."
		;;
	esac
}

patch_opencl()
{
	opencl_md5=$(md5 -q "/System/Library/Frameworks/OpenCL.framework/Libraries/libCLVMIGILPlugin.dylib")
	
	echo "${RED}Current libCLVMIGILPlugin md5 is${OFF} ${BOLD}${opencl_md5}${OFF}"
	
	case $opencl_md5 in
		"a77fe21fa2cbf3958e7d43a9b9453535")
		echo "${BOLD}Yosemite 10.10.1 libCLVMIGILPlugin (patched)${OFF}"
		echo "libCLVMIGILPlugin is already patched, no action taken."
	esac
}

RETVAL=0

case "$1" in
	"")
		echo "${BOLD}Dell XPS 9530${OFF} - Yosemite 10.10.1 (14B25)"
		echo "\t${BOLD}--update${OFF}: Update to latest git version (including externals)"
		echo "\t${BOLD}--decompile-dsdt${OFF}: Decompile DSDT files in ./DSDT/raw"
		echo "\t${BOLD}--patch-dsdt${OFF}: Patch DSDT files in ./DSDT/decompiled\e[0"
		echo "\t${BOLD}--patch-wifi${OFF}: Add BCM94352Z Combo WiFi support in ./DSDT/decompiled\e[0"
		echo "\t${BOLD}--compile-dsdt${OFF}: Compile DSDT files to ./DSDT/compiled\e[0"
		echo "\t${BOLD}--patch-iokit${OFF}: Patch maximum pixel clock in IOKit"
		echo "\t${BOLD}--patch-opencl${OFF}: Patch OpenCL/OpenGL in libCLVMIGILPlugin"
		RETVAL=1
    ;;
	--update)
		git_update
		RETVAL=1
		;;
	--decompile-dsdt)
		decompile_dsdt
		RETVAL=1
		;;
	--compile-dsdt)
		compile_dsdt
		RETVAL=1
		;;
	--patch-dsdt)
		patch_dsdt
		RETVAL=1
		;;
	--patch-wifi)
		patch_wifi
		RETVAL=1
		;;
	--patch-iokit)
		patch_iokit
		RETVAL=1
		;;
	--patch-opencl)
		patch_opencl
		RETVAL=1
		;;
esac

exit $RETVAL
