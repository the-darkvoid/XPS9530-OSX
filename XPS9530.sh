#!/bin/sh

# Bold / Non-bold
BOLD="\033[1m"
RED="\033[0;31m"
#echo -e "\033[0;32mCOLOR_GREEN\t\033[1;32mCOLOR_LIGHT_GREEN"
OFF="\033[m"

# Repository location
REPO=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_DIR=${REPO}

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
	${REPO}/tools/iasl -w1 -da ${REPO}/DSDT/raw/DSDT.aml ${REPO}/DSDT/raw/SSDT-*.aml &> ${REPO}/logs/dsdt_decompile.log
	echo "Log created in ./logs/dsdt_decompile.log"
	rm ${REPO}/DSDT/decompiled/*
	cp ${REPO}/DSDT/raw/DSDT.dsl ${REPO}/DSDT/decompiled/
	cp ${REPO}/DSDT/raw/SSDT-1[0235].dsl ${REPO}/DSDT/decompiled/
}

patch_dsdt()
{
	echo "${RED}Patching DSDT in ./DSDT/decompiled${OFF}"
	
	echo "${BOLD}[syn] Fix PARSEOP_ZERO Error${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/syntax/fix_PARSEOP_ZERO.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[syn] Fix ADBG Error${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/syntax/fix_ADBG.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[usb] 7-series/8-series USB${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/usb/usb_7-series.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[bat] Acer Aspire E1-571${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/battery/battery_Acer-Aspire-E1-571.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] IRQ Fix${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_IRQ.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] SMBus Fix${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_SMBUS.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	#echo "${BOLD}[sys] HPET Fix${OFF}" # (No HPETs available..), Check if boot / wakeup works
	#${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_HPET.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] OS Check Fix${OFF}"
	#${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_OSYS.txt ${REPO}/DSDT/decompiled/DSDT.dsl
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/DSDT/patches/system_OSYS.txt ${REPO}/DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}[sys] AC Adapter Fix${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_ADP1.txt ${REPO}/DSDT/decompiled/DSDT.dsl
	#${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/DSDT/patches/system_AC.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Add MCHC${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_MCHC.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix _WAK Arg0 v2${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_WAK2.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Add IMEI${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_IMEI.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix PNOT/PPNT${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_PNOT.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}[sys] Fix Non-zero Mutex${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/system/system_Mutex.txt ${REPO}/DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}[sys] Add Haswell LPC${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/externals/Laptop-DSDT-Patch/misc/misc_Haswell-LPC.txt ${REPO}/DSDT/decompiled/DSDT.dsl
	
	echo "${BOLD}Audio Layout${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/DSDT/patches/audio_HDEF-layout1.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}Rename B0D3 to HDAU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/DSDT/patches/audio_B0D3_HDAU.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	echo "${BOLD}Remove GLAN device${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/DSDT.dsl ${REPO}/DSDT/patches/remove_glan.txt ${REPO}/DSDT/decompiled/DSDT.dsl

	########################
	# SSDT-10 Patches
	########################
	
	echo "${RED}Patching SSDT-10 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}_BST package size${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-10.dsl ${REPO}/DSDT/patches/_BST-package-size.txt ${REPO}/DSDT/decompiled/SSDT-10.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-10.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ${REPO}/DSDT/decompiled/SSDT-10.dsl

	########################
	# SSDT-12 Patches
	########################

	echo "${RED}Patching SSDT-12 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-12.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ${REPO}/DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Haswell HD4400/HD4600/HD5000 (Yosemite - Modified)${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-12.dsl ${REPO}/DSDT/patches/graphics_Intel_HD4600.txt ${REPO}/DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}[gfx] Brightness fix (Haswell)${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-12.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_PNLF_haswell.txt ${REPO}/DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Rename B0D3 to HDAU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-12.dsl ${REPO}/DSDT/patches/audio_B0D3_HDAU.txt ${REPO}/DSDT/decompiled/SSDT-12.dsl

	echo "${BOLD}Insert HDAU device${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-12.dsl ${REPO}/DSDT/patches/audio_Intel_HD4600.txt ${REPO}/DSDT/decompiled/SSDT-12.dsl

	########################
	# SSDT-13 Patches
	########################

	echo "${RED}Patching SSDT-13 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-13.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ${REPO}/DSDT/decompiled/SSDT-13.dsl

	########################
	# SSDT-15 Patches
	########################

	echo "${RED}Patching SSDT-15 in ./DSDT/decompiled${OFF}"	

	echo "${BOLD}Remove invalid operands${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-15.dsl ${REPO}/DSDT/patches/WMMX-invalid-operands.txt ${REPO}/DSDT/decompiled/SSDT-15.dsl

	echo "${BOLD}[gfx] Rename GFX0 to IGPU${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-15.dsl ${REPO}/externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt ${REPO}/DSDT/decompiled/SSDT-15.dsl

	echo "${BOLD}Disable Nvidia card (Non-operational in OS X)${OFF}"
	${REPO}/tools/patchmatic ${REPO}/DSDT/decompiled/SSDT-15.dsl ${REPO}/DSDT/patches/graphics_Disable_Nvidia.txt ${REPO}/DSDT/decompiled/SSDT-15.dsl
}

patch_iokit()
{
	iokit_md5=$(md5 -q "/System/Library/Frameworks/IOKit.framework/Versions/Current/IOKit")
	
	echo -e "${RED}Current IOKit md5 is${OFF} ${BOLD}${iokit_md5}${OFF}"
	
	case $iokit_md5 in
		"2a8cbc2f6616d3f7a5e499bd2d5593ab")
		echo " --> ${BOLD}Yosemite 10.10.1 IOKit (unpatched)${OFF}"
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
	--patch-dsdt)
		patch_dsdt
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