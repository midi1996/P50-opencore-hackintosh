/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-KBD.aml, Sun Mar 29 02:00:18 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000003DB (987)
 *     Revision         0x02
 *     Checksum         0x4A
 *     OEM ID           "T440"
 *     OEM Table ID     "_KBD"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "T440", "_KBD", 0x00000000)
{
    External (_SB_.PCI0.LPC_.EC__, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ14, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ15, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ16, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ64, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ66, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ67, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ68, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ69, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.EC__.XQ6A, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPC_.KBD_, DeviceObj)    // (from opcode)
    External (SB__.PCI0.LPC_, UnknownObj)    // (from opcode)

    Scope (_SB.PCI0.LPC.EC)
    {
        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0406)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ14 ()
            }
        }

        Method (_Q15, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0405)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ15 ()
            }
        }

        Method (_Q6A, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x036B)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ6A ()
            }
        }

        Method (_Q16, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x046E)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ16 ()
            }
        }

        Method (_Q64, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0342)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ64 ()
            }
        }

        Method (_Q66, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0367)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ66 ()
            }
        }

        Method (_Q67, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0368)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ67 ()
            }
        }

        Method (_Q68, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x0369)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ68 ()
            }
        }

        Method (_Q69, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPC.KBD, 0x036A)
            }
            Else
            {
                \_SB.PCI0.LPC.EC.XQ69 ()
            }
        }
    }
}

