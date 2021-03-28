/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20201113 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of /Users/midi/Gits/P50-opencore-hackintosh/Files/ACPI_compiled/SSDT-USBX.aml, Sun Mar 28 11:49:12 2021
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000107 (263)
 *     Revision         0x02
 *     Checksum         0x07
 *     OEM ID           "hack"
 *     OEM Table ID     "_USBX"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200214 (538968596)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_USBX", 0x00000000)
{
    External (_SB_, DeviceObj)
    External (_SB_.PCI0.XHC_.URTH, DeviceObj)

    Device (USBX)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x08)
            {
                "kUSBSleepPowerSupply", 
                0x13EC, 
                "kUSBSleepPortCurrentLimit", 
                0x0834, 
                "kUSBWakePowerSupply", 
                0x13EC, 
                "kUSBWakePortCurrentLimit", 
                0x0834
            })
        }
    }

    Scope (\_SB.PCI0.XHC.URTH)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
}

