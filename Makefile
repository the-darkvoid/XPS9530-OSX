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

DSDT_RAW=./DSDT/raw
DSDT_DECOMPILED=./DSDT/decompiled

# Tools
IASL=./tools/MaciASL.app/Contents/MacOS/iasl5

GFXSSDT=ssdt5
EFIDIR=/Volumes/EFI
EFIVOL=/dev/disk0s1
LAPTOPGIT=../Laptop-DSDT-Patch
DEBUGGIT=../debug.git
EXTRADIR=/Extra
BUILDDIR=./build
PATCHED=./patched
UNPATCHED=./unpatched
PRODUCTS=$(BUILDDIR)/dsdt.aml $(BUILDDIR)/$(GFXSSDT).aml
DISASSEMBLE_SCRIPT=./disassemble.sh

PATCH_HDA_SCRIPT=./patch_hda.sh
HDACODEC=ALC668

NULLETHDIR=./null_eth
PATCH_RMNE_SCRIPT=./patch_null_eth_mac.sh

IASLFLAGS=-vr -w1
PATCHMATIC=/usr/local/bin/patchmatic

all: $(PRODUCTS)

# Decompile DSDT and patch with 'patchmatic'
dsdt:
	$(IASL) -w1 -da $(DSDT_RAW)/DSDT.aml $(DSDT_RAW)/SSDT-*.aml &> ./logs/iasl_decompile.log
	cp $(DSDT_RAW)/DSDT.dsl $(DSDT_DECOMPILED)/
	cp $(DSDT_RAW)/SSDT-9.dsl $(DSDT_DECOMPILED)/
	cp $(DSDT_RAW)/SSDT-1[1245].dsl $(DSDT_DECOMPILED)/

	########################
	# DSDT Patches
	########################

	# [1.8] Fix PARSEOP_ZERO Error
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_PARSEOP_ZERO.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [1.5] Fix ADBG Error
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/syntax/fix_ADBG.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [3.2] 7-series/8-series USB
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/usb/usb_7-series.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [4.01] Acer Aspire E1-571
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/battery/battery_Acer-Aspire-E1-571.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.01] IRQ Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IRQ.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.02] SMBus Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_SMBUS.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.03] RTC Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_RTC.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.05] Shutdown Fix v2
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_Shutdown2.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.06] HPET Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_HPET.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.07] OS Check Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_OSYS.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.08] AC Adapter Fix
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_ADP1.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.09] Add MCHC
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_MCHC.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.11] Fix _WAK Arg0 v2
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_WAK2.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# [7.14] Add IMEI
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./externals/Laptop-DSDT-Patch/system/system_IMEI.txt $(DSDT_DECOMPILED)/DSDT.dsl

	# Audio Layout
	./tools/patchmatic $(DSDT_DECOMPILED)/DSDT.dsl ./DSDT/patches/audio_HDEF-layout1.txt $(DSDT_DECOMPILED)/DSDT.dsl

	########################
	# SSDT-9 Patches
	########################

	# _BST package size
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-9.dsl ./DSDT/patches/_BST-package-size.txt $(DSDT_DECOMPILED)/SSDT-9.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-9.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt $(DSDT_DECOMPILED)/SSDT-9.dsl

	########################
	# SSDT-11 Patches
	########################

	# [2.05] Haswell HD4400/HD4600/HD5000 (Modified)
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-11.dsl ./DSDT/patches/graphics_Intel_HD4600.txt $(DSDT_DECOMPILED)/SSDT-11.dsl

	# [2.11] Brightness fix (Haswell)
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-11.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_PNLF_haswell.txt $(DSDT_DECOMPILED)/SSDT-11.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-11.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt $(DSDT_DECOMPILED)/SSDT-11.dsl

	########################
	# SSDT-12 Patches
	########################

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-12.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt $(DSDT_DECOMPILED)/SSDT-12.dsl

	########################
	# SSDT-14 Patches
	########################

	# Remove invalid operands
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-14.dsl ./DSDT/patches/WMMX-invalid-operands.txt $(DSDT_DECOMPILED)/SSDT-14.dsl

	# [2.12] Rename GFX0 to IGPU
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-14.dsl ./externals/Laptop-DSDT-Patch/graphics/graphics_Rename-GFX0.txt $(DSDT_DECOMPILED)/SSDT-14.dsl

	# Disable Nvidia card (Non-operational in OS X)
	./tools/patchmatic $(DSDT_DECOMPILED)/SSDT-14.dsl ./DSDT/patches/graphics_Disable_Nvidia.txt $(DSDT_DECOMPILED)/SSDT-14.dsl


$(BUILDDIR)/dsdt.aml: $(PATCHED)/dsdt.dsl
	$(IASL) $(IASLFLAGS) -p $@ $<

$(BUILDDIR)/$(GFXSSDT).aml: $(PATCHED)/$(GFXSSDT).dsl
	$(IASL) $(IASLFLAGS) -p $@ $<

clean:
	rm -rf $(DSDT_DECOMPILED)/*.aml

distclean: clean

# Chameleon Install - NOT TESTED
install_extra: $(PRODUCTS)
	-rm $(EXTRADIR)/ssdt-*.aml
	cp $(BUILDDIR)/dsdt.aml $(EXTRADIR)/dsdt.aml
	cp $(BUILDDIR)/$(GFXSSDT).aml $(EXTRADIR)/ssdt-1.aml

# Clover Install
install: $(PRODUCTS)
	if [ ! -d $(EFIDIR) ]; then mkdir $(EFIDIR) && diskutil mount -mountPoint $(EFIDIR) $(EFIVOL); fi
	cp $(BUILDDIR)/dsdt.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched
	cp $(BUILDDIR)/$(GFXSSDT).aml $(EFIDIR)/EFI/CLOVER/ACPI/patched/ssdt-1.aml
	diskutil unmount $(EFIDIR)
	if [ -d $(EFIDIR) ]; then rmdir $(EFIDIR); fi

patch_debug:
	make patch
	$(PATCHMATIC) $(PATCHED)/dsdt.dsl $(DEBUGGIT)/debug.txt $(PATCHED)/dsdt.dsl
	$(PATCHMATIC) $(PATCHED)/dsdt.dsl patches/debug.txt $(PATCHED)/dsdt.dsl


disassemble:
	$(DISASSEMBLE_SCRIPT)


patch_hda: 
	$(PATCH_HDA_SCRIPT)

install_hda:
	if [ -d /System/Library/Extensions/AppleHDA_$(HDACODEC).kext ]; \
	then rm -rf /System/Library/Extensions/AppleHDA_$(HDACODEC).kext && cp -r $(BUILDDIR)/AppleHDA_$(HDACODEC).kext /System/Library/Extensions/; \
	else cp -r $(BUILDDIR)/AppleHDA_$(HDACODEC).kext /System/Library/Extensions/; fi
	touch /System/Library/Extensions


# Install Clover config.plist
# Appends smbios info if ./config.plist.smbios exists
install_config: 
	if [ ! -d $(EFIDIR) ]; then mkdir $(EFIDIR) && diskutil mount -mountPoint $(EFIDIR) $(EFIVOL); fi
	if [ -f ./config.plist.smbios ]; then \
		./config_append_smbios.sh && cp ./config.plist.local $(EFIDIR)/EFI/CLOVER/config.plist; \
		diff ./config.plist $(EFIDIR)/EFI/CLOVER/config.plist || exit 0; \
	else cp ./config.plist $(EFIDIR)/EFI/CLOVER/; \
	fi
	diskutil unmount $(EFIDIR)
	if [ -d $(EFIDIR) ]; then rmdir $(EFIDIR); fi

# Install CodecCommander custom Info.plist
install_plist_cc: 
	if [ ! -d $(EFIDIR) ]; then mkdir $(EFIDIR) && diskutil mount -mountPoint $(EFIDIR) $(EFIVOL); fi
	cp ./plists/CodecCommander_Info.plist $(EFIDIR)/EFI/CLOVER/kexts/10.9/CodecCommander.kext/Contents/Info.plist
	touch $(EFIDIR)/EFI/CLOVER/kexts/10.9/CodecCommander.kext
	diskutil unmount $(EFIDIR)
	if [ -d $(EFIDIR) ]; then rmdir $(EFIDIR); fi

# Install FakeSMC custom Info.plist
install_plist_smc: 
	if [ ! -d $(EFIDIR) ]; then mkdir $(EFIDIR) && diskutil mount -mountPoint $(EFIDIR) $(EFIVOL); fi
	cp ./plists/FakeSMC_Info.plist $(EFIDIR)/EFI/CLOVER/kexts/10.9/FakeSMC.kext/Contents/Info.plist
	touch $(EFIDIR)/EFI/CLOVER/kexts/10.9/FakeSMC.kext
	diskutil unmount $(EFIDIR)
	if [ -d $(EFIDIR) ]; then rmdir $(EFIDIR); fi

# Compile ssdt for null ethernet
null_eth:
	$(PATCH_RMNE_SCRIPT)
	$(IASL) $(IASLFLAGS) -p $(BUILDDIR)/ssdt-rmne_rand_mac.aml $(NULLETHDIR)/ssdt-rmne_rand_mac.dsl

# Install null ethernet ssdt
install_null_eth: null_eth
	if [ ! -d $(EFIDIR) ]; then mkdir $(EFIDIR) && diskutil mount -mountPoint $(EFIDIR) $(EFIVOL); fi
	cp $(BUILDDIR)/ssdt-rmne_rand_mac.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched/ssdt-2.aml
	diskutil unmount $(EFIDIR)
	if [ -d $(EFIDIR) ]; then rmdir $(EFIDIR); fi

.PHONY: all clean distclean dsdt patch_debug install install_extra \
		disassemble patch_hda install_hda install_config \
		install_plist_cc install_plist_smc \
		null_eth install_null_eth
