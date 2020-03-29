/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-TBHP.aml, Sun Mar 29 02:00:18 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000001B3 (435)
 *     Revision         0x02
 *     Checksum         0x57
 *     OEM ID           "ALASKA"
 *     OEM Table ID     "A M I "
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200110 (538968336)
 */
DefinitionBlock ("", "SSDT", 2, "ALASKA", "A M I ", 0x00000000)
{
    External (_SB_.PC00.RP05.PXSX, DeviceObj)    // (from opcode)
    External (PLD0, UnknownObj)    // (from opcode)
    External (TARS, FieldUnitObj)    // (from opcode)
    External (TBTS, FieldUnitObj)    // (from opcode)

    If (_OSI ("Darwin"))
    {
        TBTS = One
        TARS = One
    }

    Scope (\_SB.PC00.RP05.PXSX)
    {
        Device (RHUB)
        {
            Name (_ADR, 0x00020000)  // _ADR: Address
            Device (SS01)
            {
                Name (_ADR, One)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        One, 
                        0x0A, 
                        Zero, 
                        Zero
                    })
                    Return (UPCP)
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Name (PLDP, Buffer (0x10){})
                    PLDP = \PLD0
                    Return (PLDP)
                }
            }

            Device (SS02)
            {
                Name (_ADR, 0x02)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        One, 
                        0x0A, 
                        Zero, 
                        Zero
                    })
                    Return (UPCP)
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Name (PLDP, Buffer (0x10){})
                    PLDP = \PLD0
                    Return (PLDP)
                }
            }

            Device (HS01)
            {
                Name (_ADR, 0x03)  // _ADR: Address
                Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x04)
                    {
                        One, 
                        0x0A, 
                        Zero, 
                        Zero
                    })
                    Return (UPCP)
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Name (PLDP, Buffer (0x10){})
                    PLDP = \PLD0
                    Return (PLDP)
                }
            }

            Device (HS02)
            {
                Name (_ADR, 0x04)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (Zero)
                }

                Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
                {
                    Name (UPCP, Package (0x01)
                    {
                        Zero
                    })
                    Return (UPCP)
                }

                Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
                {
                    Name (PLDP, Buffer (0x10){})
                    PLDP = Zero
                    Return (PLDP)
                }
            }
        }
    }
}

