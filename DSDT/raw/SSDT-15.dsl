/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20130823-64 [Aug 30 2013]
 * Copyright (c) 2000 - 2013 Intel Corporation
 * 
 * Disassembly of ./DSDT/raw/SSDT-15.aml, Sun Aug  3 21:25:59 2014
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000035A (858)
 *     Revision         0x01
 *     Checksum         0xE6
 *     OEM ID           "Intel_"
 *     OEM Table ID     "IsctTabl"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20091112 (537465106)
 */
DefinitionBlock ("./DSDT/raw/SSDT-15.aml", "SSDT", 1, "Intel_", "IsctTabl", 0x00001000)
{

    External (_SB_.PCI0.GFX0.ASLC, FieldUnitObj)
    External (_SB_.PCI0.GFX0.ASLE, FieldUnitObj)
    External (_SB_.PCI0.GFX0.STAT, FieldUnitObj)
    External (ICNF, FieldUnitObj)

    Scope (\_SB)
    {
        Device (IAOE)
        {
            OperationRegion (ISCT, SystemMemory, 0xC4B45E18, 0x0011)
            Field (ISCT, AnyAcc, Lock, Preserve)
            {
                WKRS,   8, 
                AOCE,   8, 
                FFSE,   8, 
                ITMR,   8, 
                ECTM,   32, 
                RCTM,   32, 
                GNPT,   32, 
                ATOW,   8
            }

            OperationRegion (ECMM, SystemMemory, 0xFF000000, 0x1000)
            Field (ECMM, AnyAcc, Lock, Preserve)
            {
                Offset (0x800), 
                Offset (0x808), 
                LIDW,   1, 
                Offset (0x85A), 
                IEWT,   8, 
                IEW2,   8, 
                Offset (0x8A0), 
                AATL,   1, 
                AACL,   1, 
                AAST,   1, 
                AARW,   1, 
                AAEN,   1, 
                AAEW,   1, 
                AAWW,   1, 
                Offset (0x8A1), 
                AAWM,   1, 
                Offset (0x8A3), 
                    ,   7, 
                ADPT,   1, 
                    ,   2, 
                LWAK,   1, 
                    ,   2, 
                UWAK,   1, 
                Offset (0x8B7), 
                LSTA,   1
            }

            Name (_HID, "INT33A0")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (AOS1, Zero)
            Name (ANS1, Zero)
            Name (WLS1, One)
            Name (WWS1, One)
            Name (ASDS, Zero)
            Method (GABS, 0, NotSerialized)
            {
                Or (ICNF, 0x77, ICNF)
                Return (ICNF)
            }

            Method (GAOS, 0, NotSerialized)
            {
                Return (AOS1)
            }

            Method (SAOS, 1, NotSerialized)
            {
                Store (Arg0, Local0)
                If (LEqual (And (Arg0, One), One))
                {
                    Store (Or (And (\_SB.PCI0.GFX0.STAT, 0xFFFFFFFC), One), \_SB.PCI0.GFX0.STAT)
                    Store (And (\_SB.PCI0.GFX0.ASLC, 0xFFFFFEFF), \_SB.PCI0.GFX0.ASLC)
                    Store (One, \_SB.PCI0.GFX0.ASLE)
                    Store (One, AOS1)
                    Store (One, AAST)
                    Store (One, AAEN)
                    If (LEqual (And (Local0, 0x02), 0x02))
                    {
                        Store (0x03, AOS1)
                        Store (One, AAWM)
                    }
                    Else
                    {
                        Store (Zero, AAWM)
                    }
                }
                Else
                {
                    Store (And (\_SB.PCI0.GFX0.STAT, 0xFFFFFFFC), \_SB.PCI0.GFX0.STAT)
                    Store (Or (And (\_SB.PCI0.GFX0.ASLC, 0xFFFFFEFF), 0x0100), \_SB.PCI0.GFX0.ASLC)
                    Store (One, \_SB.PCI0.GFX0.ASLE)
                    Store (Zero, AOS1)
                    Store (Zero, AAST)
                    Store (Zero, AAEN)
                    Store (Zero, AAWM)
                }
            }

            Method (GANS, 0, NotSerialized)
            {
                Return (ANS1)
            }

            Method (SANS, 1, NotSerialized)
            {
                If (LEqual (And (Arg0, One), One))
                {
                    Store (One, ANS1)
                }
                Else
                {
                    Store (Zero, ANS1)
                }
            }

            Method (GWLS, 0, NotSerialized)
            {
                And (WLS1, 0x0E, WLS1)
                Return (WLS1)
            }

            Method (SWLS, 1, NotSerialized)
            {
                Store (Arg0, WLS1)
            }

            Method (GWWS, 0, NotSerialized)
            {
                And (WWS1, 0x0E, WWS1)
                Return (WWS1)
            }

            Method (SWWS, 1, NotSerialized)
            {
                Store (Arg0, WWS1)
            }

            Method (SASD, 1, NotSerialized)
            {
                Divide (Arg0, 0x3C, Local1, Arg0)
                Store (Arg0, IEWT)
                Store (ShiftRight (And (Arg0, 0xFF00), 0x08), IEW2)
            }

            Method (GPWR, 0, NotSerialized)
            {
                If (LEqual (AAEW, One))
                {
                    Return (0x02)
                }
                Else
                {
                    If (LEqual (AAWW, One))
                    {
                        Return (0x08)
                    }
                    Else
                    {
                        Return (One)
                    }
                }
            }

            Method (GPCS, 0, NotSerialized)
            {
                Return (LSTA)
            }

            Method (SAWD, 1, NotSerialized)
            {
                Return (Zero)
            }
        }
    }
}

