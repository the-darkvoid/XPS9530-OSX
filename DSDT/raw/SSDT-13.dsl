/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20140724-64 [Jul 24 2014]
 * Copyright (c) 2000 - 2014 Intel Corporation
 * 
 * Disassembly of ./DSDT/raw/SSDT-13.aml, Mon Aug  4 20:44:58 2014
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000058D (1421)
 *     Revision         0x01
 *     Checksum         0xE1
 *     OEM ID           "AMITCG"
 *     OEM Table ID     "PROC"
 *     OEM Revision     0x00000001 (1)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120711 (538052369)
 */
DefinitionBlock ("./DSDT/raw/SSDT-13.aml", "SSDT", 1, "AMITCG", "PROC", 0x00000001)
{
    Device (\TPM)
    {
        Name (TMF1, Zero)
        Name (TMF2, Zero)
        Name (TRST, 0x02)
        Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
        {
            Return (0x310CD041)
        }

        Name (_STR, Unicode ("TPM 1.2 Device"))  // _STR: Description String
        Name (_UID, One)  // _UID: Unique ID
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                0x00000000,         // Granularity
                0xFED40000,         // Range Minimum
                0xFED44FFF,         // Range Maximum
                0x00000000,         // Translation Offset
                0x00005000,         // Length
                ,, , AddressRangeMemory, TypeStatic)
        })
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }

        OperationRegion (TSMI, SystemIO, 0xB2, 0x02)
        Field (TSMI, ByteAcc, NoLock, Preserve)
        {
            INQ,    8, 
            DAT,    8
        }

        Method (SVAL, 1, NotSerialized)
        {
            Store (ToInteger (Arg0), DAT) /* \TPM_.DAT_ */
            Store (0xBC, INQ) /* \TPM_.INQ_ */
        }
    }

    Scope (\TPM)
    {
        OperationRegion (PVAR, SystemMemory, 0xC5EC7998, 0x0030)
        Field (PVAR, AnyAcc, NoLock, Preserve)
        {
            P_WR,   8, 
            P_PD,   8, 
            P_NR,   8, 
            PMOR,   8, 
            P_RC,   32, 
            P_AP,   8, 
            P_SR,   8, 
            Offset (0x10), 
            RP00,   8, 
            RP01,   8, 
            RP02,   8, 
            RP03,   8, 
            RP04,   8, 
            RP05,   8, 
            RP06,   8, 
            RP07,   8, 
            RP08,   8, 
            RP09,   8, 
            RP10,   8, 
            RP11,   8, 
            RP12,   8, 
            RP13,   8, 
            RP14,   8, 
            RP15,   8, 
            RP16,   8, 
            RP17,   8, 
            RP18,   8, 
            RP19,   8, 
            RP20,   8, 
            RP21,   8, 
            RP22,   8
        }

        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            Name (_T_2, Zero)  // _T_x: Emitted by ASL Compiler
            Name (_T_1, Zero)  // _T_x: Emitted by ASL Compiler
            Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
            If (LEqual (Arg0, ToUUID ("3dddfaa6-361b-4eb4-a424-8d10089d1653") /* Physical Presence Interface */))
            {
                While (One)
                {
                    Store (ToInteger (Arg2), _T_0) /* \TPM_._DSM._T_0 */
                    If (LEqual (_T_0, Zero))
                    {
                        Return (Buffer (0x02)
                        {
                             0xFF, 0x01                                       /* .. */
                        })
                    }
                    Else
                    {
                        If (LEqual (_T_0, One))
                        {
                            Return ("1.2")
                        }
                        Else
                        {
                            If (LEqual (_T_0, 0x02))
                            {
                                If (LEqual (P_AP, One))
                                {
                                    Return (0x02)
                                }

                                ToInteger (DerefOf (Index (Arg3, Zero)), TMF2) /* \TPM_.TMF2 */
                                If (LGreater (TMF2, 0x16))
                                {
                                    Return (One)
                                }

                                Store (TMF2, P_PD) /* \TPM_.P_PD */
                                Store (TMF2, P_WR) /* \TPM_.P_WR */
                                SVAL (0xFF)
                                Return (P_SR) /* \TPM_.P_SR */
                            }
                            Else
                            {
                                If (LEqual (_T_0, 0x03))
                                {
                                    Name (PPI1, Package (0x02)
                                    {
                                        Zero, 
                                        Zero
                                    })
                                    If (LEqual (P_AP, One))
                                    {
                                        Store (One, Index (PPI1, Zero))
                                        Return (PPI1) /* \TPM_._DSM.PPI1 */
                                    }

                                    If (LGreater (P_PD, 0x16))
                                    {
                                        Store (One, Index (PPI1, Zero))
                                        Return (PPI1) /* \TPM_._DSM.PPI1 */
                                    }

                                    Store (P_PD, Index (PPI1, One))
                                    Return (PPI1) /* \TPM_._DSM.PPI1 */
                                }
                                Else
                                {
                                    If (LEqual (_T_0, 0x04))
                                    {
                                        If (LEqual (P_AP, One))
                                        {
                                            Return (Zero)
                                        }

                                        If (LEqual (P_WR, 0x0F))
                                        {
                                            Return (Zero)
                                        }

                                        Return (TRST) /* \TPM_.TRST */
                                    }
                                    Else
                                    {
                                        If (LEqual (_T_0, 0x05))
                                        {
                                            Name (PPI2, Package (0x03)
                                            {
                                                Zero, 
                                                Zero, 
                                                Zero
                                            })
                                            If (LEqual (P_AP, One))
                                            {
                                                Store (One, Index (PPI2, Zero))
                                                Return (PPI2) /* \TPM_._DSM.PPI2 */
                                            }

                                            If (LEqual (P_NR, 0xFF))
                                            {
                                                Store (One, Index (PPI2, Zero))
                                                Return (PPI2) /* \TPM_._DSM.PPI2 */
                                            }

                                            Store (P_NR, Index (PPI2, One))
                                            Store (P_RC, Index (PPI2, 0x02))
                                            Return (PPI2) /* \TPM_._DSM.PPI2 */
                                        }
                                        Else
                                        {
                                            If (LEqual (_T_0, 0x06))
                                            {
                                                Return (0x03)
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_0, 0x07))
                                                {
                                                    If (LEqual (P_AP, One))
                                                    {
                                                        Return (0x03)
                                                    }

                                                    ToInteger (DerefOf (Index (Arg3, Zero)), TMF2) /* \TPM_.TMF2 */
                                                    If (LGreater (TMF2, 0x16))
                                                    {
                                                        Return (One)
                                                    }

                                                    Store (TMF2, P_PD) /* \TPM_.P_PD */
                                                    Store (TMF2, P_WR) /* \TPM_.P_WR */
                                                    SVAL (0xFF)
                                                    Return (P_SR) /* \TPM_.P_SR */
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_0, 0x08))
                                                    {
                                                        If (LEqual (P_AP, One))
                                                        {
                                                            Return (0x02)
                                                        }

                                                        ToInteger (DerefOf (Index (Arg3, Zero)), TMF2) /* \TPM_.TMF2 */
                                                        While (One)
                                                        {
                                                            Store (TMF2, _T_1) /* \TPM_._DSM._T_1 */
                                                            If (LEqual (_T_1, Zero))
                                                            {
                                                                Return (RP00) /* \TPM_.RP00 */
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_1, One))
                                                                {
                                                                    Return (RP01) /* \TPM_.RP01 */
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (_T_1, 0x02))
                                                                    {
                                                                        Return (RP02) /* \TPM_.RP02 */
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_1, 0x03))
                                                                        {
                                                                            Return (RP03) /* \TPM_.RP03 */
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_1, 0x04))
                                                                            {
                                                                                Return (RP04) /* \TPM_.RP04 */
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_1, 0x05))
                                                                                {
                                                                                    Return (RP05) /* \TPM_.RP05 */
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_1, 0x06))
                                                                                    {
                                                                                        Return (RP06) /* \TPM_.RP06 */
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (_T_1, 0x07))
                                                                                        {
                                                                                            Return (RP07) /* \TPM_.RP07 */
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (_T_1, 0x08))
                                                                                            {
                                                                                                Return (RP08) /* \TPM_.RP08 */
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (_T_1, 0x09))
                                                                                                {
                                                                                                    Return (RP09) /* \TPM_.RP09 */
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (_T_1, 0x0A))
                                                                                                    {
                                                                                                        Return (RP10) /* \TPM_.RP10 */
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (_T_1, 0x0B))
                                                                                                        {
                                                                                                            Return (RP11) /* \TPM_.RP11 */
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LEqual (_T_1, 0x0C))
                                                                                                            {
                                                                                                                Return (RP12) /* \TPM_.RP12 */
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (_T_1, 0x0D))
                                                                                                                {
                                                                                                                    Return (RP13) /* \TPM_.RP13 */
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    If (LEqual (_T_1, 0x0E))
                                                                                                                    {
                                                                                                                        Return (RP14) /* \TPM_.RP14 */
                                                                                                                    }
                                                                                                                    Else
                                                                                                                    {
                                                                                                                        If (LEqual (_T_1, 0x0F))
                                                                                                                        {
                                                                                                                            Return (RP15) /* \TPM_.RP15 */
                                                                                                                        }
                                                                                                                        Else
                                                                                                                        {
                                                                                                                            If (LEqual (_T_1, 0x10))
                                                                                                                            {
                                                                                                                                Return (RP16) /* \TPM_.RP16 */
                                                                                                                            }
                                                                                                                            Else
                                                                                                                            {
                                                                                                                                If (LEqual (_T_1, 0x11))
                                                                                                                                {
                                                                                                                                    Return (RP17) /* \TPM_.RP17 */
                                                                                                                                }
                                                                                                                                Else
                                                                                                                                {
                                                                                                                                    If (LEqual (_T_1, 0x12))
                                                                                                                                    {
                                                                                                                                        Return (RP18) /* \TPM_.RP18 */
                                                                                                                                    }
                                                                                                                                    Else
                                                                                                                                    {
                                                                                                                                        If (LEqual (_T_1, 0x13))
                                                                                                                                        {
                                                                                                                                            Return (RP19) /* \TPM_.RP19 */
                                                                                                                                        }
                                                                                                                                        Else
                                                                                                                                        {
                                                                                                                                            If (LEqual (_T_1, 0x14))
                                                                                                                                            {
                                                                                                                                                Return (RP20) /* \TPM_.RP20 */
                                                                                                                                            }
                                                                                                                                            Else
                                                                                                                                            {
                                                                                                                                                If (LEqual (_T_1, 0x15))
                                                                                                                                                {
                                                                                                                                                    Return (RP21) /* \TPM_.RP21 */
                                                                                                                                                }
                                                                                                                                                Else
                                                                                                                                                {
                                                                                                                                                    If (LEqual (_T_1, 0x16))
                                                                                                                                                    {
                                                                                                                                                        Return (RP22) /* \TPM_.RP22 */
                                                                                                                                                    }
                                                                                                                                                    Else
                                                                                                                                                    {
                                                                                                                                                        Return (Zero)
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            Break
                                                        }

                                                        Return (Zero)
                                                    }
                                                    Else
                                                    {
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Break
                }
            }
            Else
            {
                If (LEqual (Arg0, ToUUID ("376054ed-cc13-4675-901c-4756d7f2d45d")))
                {
                    While (One)
                    {
                        Store (ToInteger (Arg2), _T_2) /* \TPM_._DSM._T_2 */
                        If (LEqual (_T_2, Zero))
                        {
                            Return (Buffer (One)
                            {
                                 0x03                                             /* . */
                            })
                        }
                        Else
                        {
                            If (LEqual (_T_2, One))
                            {
                                ToInteger (DerefOf (Index (Arg3, Zero)), TMF1) /* \TPM_.TMF1 */
                                Store (TMF1, PMOR) /* \TPM_.PMOR */
                                SVAL (0xFF)
                                Return (Zero)
                            }
                            Else
                            {
                            }
                        }

                        Break
                    }
                }
            }

            Return (Buffer (One)
            {
                 0x00                                             /* . */
            })
        }
    }
}

