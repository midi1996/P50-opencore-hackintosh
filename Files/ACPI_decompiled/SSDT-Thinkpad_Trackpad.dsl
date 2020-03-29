/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-Thinkpad_Trackpad.aml, Sun Mar 29 02:00:18 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000002E1 (737)
 *     Revision         0x02
 *     Checksum         0xC3
 *     OEM ID           "hack"
 *     OEM Table ID     "ps2"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20190509 (538510601)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "ps2", 0x00000000)
{
    External (_SB_.PCI0.LPC_.KBD_, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.LPC.KBD)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (_OSI ("Darwin"))
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Return (Package (0x04)
                {
                    "RM,oem-id", 
                    "LENOVO", 
                    "RM,oem-table-id", 
                    "Thinkpad_TrackPad"
                })
            }
            Else
            {
            }
        }

        Name (RMCF, Package (0x04)
        {
            "Synaptics TouchPad", 
            Package (0x34)
            {
                "BogusDeltaThreshX", 
                0x64, 
                "BogusDeltaThreshY", 
                0x64, 
                "Clicking", 
                ">y", 
                "DragLockTempMask", 
                0x00040004, 
                "DynamicEWMode", 
                ">n", 
                "FakeMiddleButton", 
                ">n", 
                "HWResetOnStart", 
                ">y", 
                "PalmNoAction When Typing", 
                ">y", 
                "ScrollResolution", 
                0x0320, 
                "SmoothInput", 
                ">y", 
                "UnsmoothInput", 
                ">y", 
                "Thinkpad", 
                ">y", 
                "DivisorX", 
                One, 
                "DivisorY", 
                One, 
                "FingerZ", 
                0x2F, 
                "MaxTapTime", 
                0x05F5E100, 
                "MomentumScrollThreshY", 
                0x10, 
                "MouseMultiplierX", 
                0x08, 
                "MouseMultiplierY", 
                0x08, 
                "MouseScrollMultiplierX", 
                0x02, 
                "MouseScrollMultiplierY", 
                0x02, 
                "MultiFingerHorizontalDivisor", 
                0x04, 
                "MultiFingerVerticalDivisor", 
                0x04, 
                "Resolution", 
                0x0C80, 
                "ScrollDeltaThreshX", 
                0x0A, 
                "ScrollDeltaThreshY", 
                0x0A
            }
        })
    }
}

