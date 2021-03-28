/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20201113 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of /Users/midi/Gits/P50-opencore-hackintosh/Files/ACPI_compiled/SSDT-XOSI.aml, Sun Mar 28 11:49:12 2021
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000052 (82)
 *     Revision         0x02
 *     Checksum         0xA0
 *     OEM ID           "hack"
 *     OEM Table ID     "XOSI"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200214 (538968596)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "XOSI", 0x00000000)
{
    Method (XOSI, 1, NotSerialized)
    {
        If (((Arg0 == "Windows 2015") && _OSI ("Darwin")))
        {
            Return (One)
        }

        Return (_OSI (Arg0))
    }
}

