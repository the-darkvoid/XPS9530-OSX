/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20140724-64 [Jul 24 2014]
 * Copyright (c) 2000 - 2014 Intel Corporation
 * 
 * Disassembly of ./DSDT/raw/SSDT-1.aml, Mon Aug  4 20:44:58 2014
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000228 (552)
 *     Revision         0x01
 *     Checksum         0xAF
 *     OEM ID           "INTEL"
 *     OEM Table ID     "sensrhub"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120711 (538052369)
 */
DefinitionBlock ("./DSDT/raw/SSDT-1.aml", "SSDT", 1, "INTEL", "sensrhub", 0x00000000)
{

    External (_SB_.PCI0.I2C0.DFUD, UnknownObj)
    External (_SB_.PCI0.I2C0.SHUB, UnknownObj)
    External (_SB_.RDGP, MethodObj)    // 1 Arguments
    External (_SB_.WTGP, MethodObj)    // 2 Arguments
    External (SDS0, FieldUnitObj)
    External (USBH, FieldUnitObj)

    Scope (\)
    {
        Device (SHAD)
        {
            Name (_HID, EisaId ("INT33D0"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _CID: Compatible ID
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                If (LOr (And (SDS0, One), And (USBH, One)))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                Name (PGCE, Zero)
                Name (PGCD, Zero)
                Name (DFUE, Zero)
                Name (DFUD, Zero)
                Name (OLDV, Zero)
                Name (PGCV, Zero)
                Name (DFUV, Zero)
                If (LEqual (Arg0, ToUUID ("03c868d5-563f-42a8-9f57-9a18d949b7cb")))
                {
                    If (LEqual (One, ToInteger (Arg1)))
                    {
                        While (One)
                        {
                            Store (ToInteger (Arg2), _T_0) /* \SHAD._DSM._T_0 */
                            If (LEqual (_T_0, Zero))
                            {
                                Return (Buffer (One)
                                {
                                     0x0F                                             /* . */
                                })
                            }
                            Else
                            {
                                If (LEqual (_T_0, One))
                                {
                                    Store (DerefOf (Index (Arg3, Zero)), PGCE) /* \SHAD._DSM.PGCE */
                                    Store (DerefOf (Index (Arg3, One)), PGCD) /* \SHAD._DSM.PGCD */
                                    Store (\_SB.RDGP (0x2E), OLDV) /* \SHAD._DSM.OLDV */
                                    \_SB.WTGP (0x2E, PGCE)
                                    If (LGreater (PGCD, Zero))
                                    {
                                        Sleep (PGCD)
                                        \_SB.WTGP (0x2E, OLDV)
                                    }

                                    If (LEqual (\_SB.RDGP (0x2E), One))
                                    {
                                        Sleep (0x96)
                                        If (LEqual (\_SB.RDGP (0x2C), One))
                                        {
                                            Notify (\_SB.PCI0.I2C0.SHUB, One) // Device Check
                                        }
                                        Else
                                        {
                                            Notify (\_SB.PCI0.I2C0.DFUD, One) // Device Check
                                        }
                                    }

                                    Return (Zero)
                                }
                                Else
                                {
                                    If (LEqual (_T_0, 0x02))
                                    {
                                        Store (DerefOf (Index (Arg3, Zero)), DFUE) /* \SHAD._DSM.DFUE */
                                        Store (DerefOf (Index (Arg3, One)), DFUD) /* \SHAD._DSM.DFUD */
                                        Store (\_SB.RDGP (0x2C), OLDV) /* \SHAD._DSM.OLDV */
                                        \_SB.WTGP (0x2C, DFUE)
                                        If (LGreater (DFUD, Zero))
                                        {
                                            Sleep (DFUD)
                                            \_SB.WTGP (0x2C, OLDV)
                                        }

                                        Return (Zero)
                                    }
                                    Else
                                    {
                                        If (LEqual (_T_0, 0x03))
                                        {
                                            Store (\_SB.RDGP (0x2C), DFUV) /* \SHAD._DSM.DFUV */
                                            Store (\_SB.RDGP (0x2E), PGCV) /* \SHAD._DSM.PGCV */
                                            Return (Package (0x02)
                                            {
                                                PGCV, 
                                                DFUV
                                            })
                                        }
                                    }
                                }
                            }

                            Break
                        }

                        Return (Zero)
                    }

                    Return (Zero)
                }

                Return (Zero)
            }
        }
    }
}

