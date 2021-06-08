/*

This file is just for archiving sake, do not use as ECEnabler handles EC registery reading.

*/
DefinitionBlock ("", "SSDT", 2, "hack", "batt", 0x00000000)
{
    External (_SB_.LID_, DeviceObj)
    External (_SB_.PCI0.D0VI, UnknownObj)
    External (_SB_.PCI0.EXP1, DeviceObj)
    External (_SB_.PCI0.EXP1.PDSF, FieldUnitObj)
    External (_SB_.PCI0.EXP1.PDSX, FieldUnitObj)
    External (_SB_.PCI0.EXP5, DeviceObj)
    External (_SB_.PCI0.EXP5.PDSF, FieldUnitObj)
    External (_SB_.PCI0.EXP5.PDSX, FieldUnitObj)
    External (_SB_.PCI0.EXP5.VDID, FieldUnitObj)
    External (_SB_.PCI0.GFX0.CLID, UnknownObj)
    External (_SB_.PCI0.LPC_, DeviceObj)
    External (_SB_.PCI0.LPC_.EC__, DeviceObj)
    External (_SB_.PCI0.LPC_.EC__.AC__, DeviceObj)
    External (_SB_.PCI0.LPC_.EC__.AC__._PSR, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPC_.EC__.B0I0, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B0I1, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B0I2, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B0I3, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B1I0, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B1I1, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B1I2, IntObj)
    External (_SB_.PCI0.LPC_.EC__.B1I3, IntObj)
    External (_SB_.PCI0.LPC_.EC__.BATM, MutexObj)
    External (_SB_.PCI0.LPC_.EC__.BSWA, IntObj)
    External (_SB_.PCI0.LPC_.EC__.BSWR, IntObj)
    External (_SB_.PCI0.LPC_.EC__.HCMU, FieldUnitObj)
    External (_SB_.PCI0.LPC_.EC__.HFNI, FieldUnitObj)
    External (_SB_.PCI0.LPC_.EC__.HFSP, FieldUnitObj)
    External (_SB_.PCI0.LPC_.EC__.HIID, FieldUnitObj)
    External (_SB_.PCI0.LPC_.EC__.HKEY, DeviceObj)
    External (_SB_.PCI0.LPC_.EC__.HKEY.ANDN, IntObj)
    External (_SB_.PCI0.LPC_.EC__.HKEY.ANGN, IntObj)
    External (_SB_.PCI0.LPC_.EC__.HKEY.DHKC, IntObj)
    External (_SB_.PCI0.LPC_.EC__.HKEY.MHKQ, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPC_.EC__.HSPA, FieldUnitObj)
    External (_SB_.PCI0.MLTR, UnknownObj)
    External (_SB_.PCI0.ONOF, UnknownObj)
    External (_SB_.PCI0.PEG0.PEGP.HDEF, IntObj)
    External (_SB_.SLPB, DeviceObj)
    External (_SI_._SST, MethodObj)    // 1 Arguments
    External (_TZ_.THM0, ThermalZoneObj)
    External (ACST, IntObj)
    External (B0I0, IntObj)
    External (B0I1, IntObj)
    External (B0I2, IntObj)
    External (B0I3, IntObj)
    External (B1I0, IntObj)
    External (B1I1, IntObj)
    External (B1I2, IntObj)
    External (B1I3, IntObj)
    External (BRLV, FieldUnitObj)
    External (CHKC, FieldUnitObj)
    External (CHKE, FieldUnitObj)
    External (CMPR, FieldUnitObj)
    External (FNID, IntObj)
    External (IOEN, FieldUnitObj)
    External (IOST, FieldUnitObj)
    External (ISWK, FieldUnitObj)
    External (LIDB, FieldUnitObj)
    External (NBCF, IntObj)
    External (OSC4, FieldUnitObj)
    External (OSUM, MutexObj)
    External (PWRS, FieldUnitObj)
    External (RRBF, IntObj)
    External (SCRM, FieldUnitObj)
    External (SPS_, IntObj)
    External (TBTS, FieldUnitObj)
    External (VIGD, FieldUnitObj)
    External (WAKI, IntObj)
    External (WFEV, EventObj)
    External (WVIS, IntObj)
    External (XXAK, MethodObj)    // 1 Arguments

    Scope (_SB.PCI0.LPC)
    {
        Scope (EC)
        {
            Method (WE1B, 2, NotSerialized)
            {
                OperationRegion (ERAM, EmbeddedControl, Arg0, One)
                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                    BYTE,   8
                }

                BYTE = Arg1
            }

            Method (WECB, 3, Serialized)
            {
                Arg1 = ((Arg1 + 0x07) >> 0x03)
                Name (TEMP, Buffer (Arg1){})
                TEMP = Arg2
                Arg1 += Arg0
                Local0 = Zero
                While ((Arg0 < Arg1))
                {
                    WE1B (Arg0, DerefOf (TEMP [Local0]))
                    Arg0++
                    Local0++
                }
            }

            OperationRegion (REEE, EmbeddedControl, Zero, 0x0100)
            Field (REEE, ByteAcc, NoLock, Preserve)
            {
                Offset (0x36), 
                AC10,   8, 
                AC11,   8
            }

            Field (REEE, ByteAcc, NoLock, Preserve)
            {
                Offset (0xA0), 
                RC00,   8, 
                RC01,   8, 
                FC00,   8, 
                FC01,   8, 
                Offset (0xA8), 
                AC00,   8, 
                AC01,   8, 
                BV00,   8, 
                BV01,   8
            }

            Field (REEE, ByteAcc, NoLock, Preserve)
            {
                Offset (0xA0), 
                SB00,   8, 
                SB01,   8
            }

            Field (REEE, ByteAcc, NoLock, Preserve)
            {
                Offset (0xA0), 
                DC00,   8, 
                DC01,   8, 
                DV00,   8, 
                DV01,   8, 
                Offset (0xA6), 
                Offset (0xA8), 
                Offset (0xAA), 
                SN00,   8, 
                SN01,   8
            }

            Field (REEE, ByteAcc, NoLock, Preserve)
            {
                Offset (0xA0), 
                CH00,   8, 
                CH01,   8, 
                CH02,   8, 
                CH03,   8
            }

            Method (GBIF, 3, NotSerialized)
            {
                Acquire (BATM, 0xFFFF)
                If (Arg2)
                {
                    HIID = (Arg0 | One)
                    Local7 = B1B2 (SB00, SB01)
                    Local7 >>= 0x0F
                    Arg1 [Zero] = (Local7 ^ One)
                    HIID = Arg0
                    If (Local7)
                    {
                        Local1 = (B1B2 (FC00, FC01) * 0x0A)
                    }
                    Else
                    {
                        Local1 = B1B2 (FC00, FC01)
                    }

                    Arg1 [0x02] = Local1
                    HIID = (Arg0 | 0x02)
                    If (Local7)
                    {
                        Local0 = (B1B2 (DC00, DC01) * 0x0A)
                    }
                    Else
                    {
                        Local0 = B1B2 (DC00, DC01)
                    }

                    Arg1 [One] = Local0
                    Divide (Local1, 0x14, Local2, Arg1 [0x05])
                    If (Local7)
                    {
                        Arg1 [0x06] = 0xC8
                    }
                    ElseIf (B1B2 (DV00, DV01))
                    {
                        Divide (0x00030D40, B1B2 (DV00, DV01), Local2, Arg1 [0x06])
                    }
                    Else
                    {
                        Arg1 [0x06] = Zero
                    }

                    Arg1 [0x04] = B1B2 (DV00, DV01)
                    Local0 = B1B2 (SN00, SN01)
                    Name (SERN, Buffer (0x06)
                    {
                        "     "
                    })
                    Local2 = 0x04
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        SERN [Local2] = (Local1 + 0x30)
                        Local2--
                    }

                    Arg1 [0x0A] = SERN /* \_SB_.PCI0.LPC_.EC__.GBIF.SERN */
                    HIID = (Arg0 | 0x06)
                    Arg1 [0x09] = RECB (0xA0, 0x80)
                    HIID = (Arg0 | 0x04)
                    Name (BTYP, Buffer (0x05)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00                     // .....
                    })
                    BTYP = B1B4 (CH00, CH01, CH02, CH03)
                    Arg1 [0x0B] = BTYP /* \_SB_.PCI0.LPC_.EC__.GBIF.BTYP */
                    HIID = (Arg0 | 0x05)
                    Arg1 [0x0C] = RECB (0xA0, 0x80)
                }
                Else
                {
                    Arg1 [One] = 0xFFFFFFFF
                    Arg1 [0x05] = Zero
                    Arg1 [0x06] = Zero
                    Arg1 [0x02] = 0xFFFFFFFF
                }

                Release (BATM)
                Return (Arg1)
            }

            Method (GBST, 4, NotSerialized)
            {
                Acquire (BATM, 0xFFFF)
                If ((Arg1 & 0x20))
                {
                    Local0 = 0x02
                }
                ElseIf ((Arg1 & 0x40))
                {
                    Local0 = One
                }
                Else
                {
                    Local0 = Zero
                }

                If ((Arg1 & 0x07)){}
                Else
                {
                    Local0 |= 0x04
                }

                If (((Arg1 & 0x07) == 0x07))
                {
                    Local0 = 0x04
                    Local1 = Zero
                    Local2 = Zero
                    Local3 = Zero
                }
                Else
                {
                    HIID = Arg0
                    Local3 = B1B2 (BV00, BV01)
                    If (Arg2)
                    {
                        Local2 = (B1B2 (RC00, RC01) * 0x0A)
                    }
                    Else
                    {
                        Local2 = B1B2 (RC00, RC01)
                    }

                    Local1 = B1B2 (AC00, AC01)
                    If ((Local1 >= 0x8000))
                    {
                        If ((Local0 & One))
                        {
                            Local1 = (0x00010000 - Local1)
                        }
                        Else
                        {
                            Local1 = Zero
                        }
                    }
                    ElseIf (!(Local0 & 0x02))
                    {
                        Local1 = Zero
                    }

                    If (Arg2)
                    {
                        Local1 *= Local3
                        Divide (Local1, 0x03E8, Local7, Local1)
                    }
                }

                Local5 = (One << (Arg0 >> 0x04))
                BSWA |= BSWR /* External reference */
                If (((\_SB.PCI0.LPC.EC.BSWA & Local5) == Zero))
                {
                    Arg3 [Zero] = Local0
                    Arg3 [One] = Local1
                    Arg3 [0x02] = Local2
                    Arg3 [0x03] = Local3
                    If ((Arg0 == Zero))
                    {
                        B0I0 = Local0
                        B0I1 = Local1
                        B0I2 = Local2
                        B0I3 = Local3
                    }
                    Else
                    {
                        B1I0 = Local0
                        B1I1 = Local1
                        B1I2 = Local2
                        B1I3 = Local3
                    }
                }
                Else
                {
                    If (\_SB.PCI0.LPC.EC.AC._PSR ())
                    {
                        If ((Arg0 == Zero))
                        {
                            Arg3 [Zero] = B0I0 /* External reference */
                            Arg3 [One] = B0I1 /* External reference */
                            Arg3 [0x02] = B0I2 /* External reference */
                            Arg3 [0x03] = B0I3 /* External reference */
                        }
                        Else
                        {
                            Arg3 [Zero] = B1I0 /* External reference */
                            Arg3 [One] = B1I1 /* External reference */
                            Arg3 [0x02] = B1I2 /* External reference */
                            Arg3 [0x03] = B1I3 /* External reference */
                        }
                    }
                    Else
                    {
                        Arg3 [Zero] = Local0
                        Arg3 [One] = Local1
                        Arg3 [0x02] = Local2
                        Arg3 [0x03] = Local3
                    }

                    If ((((Local0 & 0x04) == Zero) && ((Local2 > Zero) && 
                        (Local3 > Zero))))
                    {
                        BSWA &= ~Local5
                        Arg3 [Zero] = Local0
                        Arg3 [One] = Local1
                        Arg3 [0x02] = Local2
                        Arg3 [0x03] = Local3
                    }
                }

                Release (BATM)
                Return (Arg3)
            }

            Method (RE1B, 1, NotSerialized)
            {
                OperationRegion (ECOR, EmbeddedControl, Arg0, One)
                Field (ECOR, ByteAcc, NoLock, Preserve)
                {
                    BYTE,   8
                }

                Return (BYTE) /* \_SB_.PCI0.LPC_.EC__.RE1B.BYTE */
            }

            Method (RECB, 2, Serialized)
            {
                Arg1 >>= 0x03
                Name (TEMP, Buffer (Arg1){})
                Arg1 += Arg0
                Local0 = Zero
                While ((Arg0 < Arg1))
                {
                    TEMP [Local0] = RE1B (Arg0)
                    Arg0++
                    Local0++
                }

                Return (TEMP) /* \_SB_.PCI0.LPC_.EC__.RECB.TEMP */
            }
        }
    }

    Scope (\_GPE)
    {
        Method (_L17, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            Local0 = B1B2 (\_SB.PCI0.LPC.EC.AC10, \_SB.PCI0.LPC.EC.AC11)
            \RRBF = Local0
            Sleep (0x0A)
            If ((Local0 & 0x02)){}
            If ((Local0 & 0x04))
            {
                Notify (\_SB.LID, 0x02) // Device Wake
            }

            If ((Local0 & 0x08))
            {
                Notify (\_SB.SLPB, 0x02) // Device Wake
            }

            If ((Local0 & 0x10))
            {
                Notify (\_SB.SLPB, 0x02) // Device Wake
            }

            If ((Local0 & 0x40)){}
            If ((Local0 & 0x80))
            {
                Notify (\_SB.SLPB, 0x02) // Device Wake
            }
        }
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        If (_OSI ("Darwin"))
        {
            If ((0x03 == Arg0))
            {
                \_SI._SST (One)
            }

            If ((Arg0 < 0x04))
            {
                If (((\RRBF & 0x02) || (B1B2 (\_SB.PCI0.LPC.EC.AC10, \_SB.PCI0.LPC.EC.AC11) & 0x02)))
                {
                    Local0 = (Arg0 << 0x08)
                    Local0 |= 0x2013
                    \_SB.PCI0.LPC.EC.HKEY.MHKQ (Local0)
                }
            }
        }

        Local0 = \XXAK (Arg0)
        Return (Local0)
    }

    Scope (\)
    {
        Method (B1B2, 2, NotSerialized)
        {
            Return ((Arg0 | (Arg1 << 0x08)))
        }

        Method (B1B4, 4, NotSerialized)
        {
            Local0 = Arg3
            Local0 = (Arg2 | (Local0 << 0x08))
            Local0 = (Arg1 | (Local0 << 0x08))
            Local0 = (Arg0 | (Local0 << 0x08))
            Return (Local0)
        }
    }
}

