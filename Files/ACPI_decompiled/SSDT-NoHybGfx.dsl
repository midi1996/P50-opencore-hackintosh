/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20201113 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of /Users/midi/Gits/P50-opencore-hackintosh/Files/ACPI_compiled/SSDT-NoHybGfx.aml, Sun Mar 28 11:49:12 2021
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000F7 (247)
 *     Revision         0x02
 *     Checksum         0x33
 *     OEM ID           "MAEMO"
 *     OEM Table ID     "NoHybGfx"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200214 (538968596)
 */
DefinitionBlock ("", "SSDT", 2, "MAEMO", "NoHybGfx", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP._DSM, MethodObj)    // 4 Arguments
    External (_SB_.PCI0.PEG0.PEGP._PS3, MethodObj)    // 0 Arguments

    Device (NHG1)
    {
        Name (_HID, "NHG10000")  // _HID: Hardware ID
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
        }

        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (_OSI ("Darwin"))
            {
                Local0 = ToUUID ("a486d8f8-0bda-471b-a72b-6042a6b5bee0") /* Unknown UUID */
                \_SB.PCI0.PEG0.PEGP._DSM (Local0, 0x0100, 0x1A, Buffer (0x04)
                    {
                         0x01, 0x00, 0x00, 0x03                           // ....
                    })
                \_SB.PCI0.PEG0.PEGP._PS3 ()
            }
        }
    }
}

