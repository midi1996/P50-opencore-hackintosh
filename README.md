# Lenovo ThinkPad P50 macOS Install with OpenCore

## Intro

I've been able to install macOS on the Lenovo ThinkPad P50 through OpenCore. This guide will go through the setup on how to get it working but will not include any files other than ACPI and parts of the config, you will have to do the work youself.

---

## Disclaimer

THIS GUIDE IS PROVIDED TO YOU FOR EDUCATIONAL PURPOSES. I AND ANYONE MENTIONED DIRECTLY OR INDIRECTLY IN THIS GUIDE WILL NOT BE HELD RESPONSIBLE FOR ANY HARM OR LOSS. BY FOLLOWING THIS GUIDE YOU AGREE TO TAKE FULL RESPONSIBILITY FOR ANYTHING THAT COMES OUT FROM THIS GUIDE.

---

## My Hardware

* Model: Lenovo ThinkPad P50 (20EN)
* CPU: Intel Xeon E3-1505 v5 2.7Ghz Quad Core - Eight Threads CPU (vPro)
* GPUs:
  * Intel HD P530
  * Nvidia Quadro M2000M (Lenovo branded)
    * Will never work.
* RAM: 16GB+16GB 2133Mhz DDR4 (2 Slots filled from 4)
* Storage:
  * 512GB Samsung SSD 950 Pro NVMe M.2
  * 1TB WD Blue HDD
  * 1 empty slot that I might fill with a 1TB M.2 SSD in the future (~~when I have some money~~)
* WiFi Card: *was* Intel Wireless Dual Band 8360 (for vPro), replaced with **Apple BCM94360CS2**.
  * See the WiFi card options later in this guide
* Display: 1920 by 1080 (will check OEM later)
* Touch Panel: WACOM AES Digitizer (Touch + Pen)
* Audio: ALC298
* Thunderbolt 3 Chipset: DSL6540
  * Will probably not work, and I'm not looking into it, you have plenty of other ports.
* NO LTE modem
* OSes: macOS 10.15.x - Windows 10 - Ubuntu
* BIOS Version: 1.60

## What's working

A lot of things are working fine as expected:

- CPU/GPU Power Management
  - <1W on idle
- GPU Acceleration
  - QE/CI Support
  - HEVC encoding
- USB Type A ports
  - USB Power output up to 10W for iDevices
  - USB Charging port works in sleep in 10W
- WiFi/Bluetooth
  - AirDrop, Continuity, Handoff...
    - Requires proper WiFi card
    - May require extra configuration
- Audio In/Out
  - Microphones 
  - Speakers (a bit low, investigating it)
  - Headphones
    - No mic input from it
- Display:
  - Brightness
  - Touch
    - As a fucking giant 15" trackpad
    - Pen input (no pressure support)
    - I disabled it because it's trash
- Keyboard
  - Hotkeys
- Trackpoint
- Trackpad
  - Only 2 finger scrolls and 3 fingers swipes that are configurable in the kext or keyboard settings
- Sleep/Wake/Shutdown/Reboot
- Startup Disk/Bootcamp reboot
  - From and to Windows/macOS
  - Follow OpenCore's documentation for that
- [Potentially] FileVault 2
- Camera
  - I disabled it in the USBMap, you will have to enable it on your own.
- Apple Services (AppStore, iMessage, FaceTime, iCloud...)
  - Given that you use properly generated SNs
- Battery reading

## What's not working

- Fingerprint Reader (disabled with USBMap)
- ExpressCard (disabled in UEFI Setup)
- SDCard reader (the available driver causes crashes and isnt stable enough)
- Thunderbolt 3
  - There are some efforts to make it work
  - Will only work if you plug the device before booting up
  - I was successful to make it load up in OS but you will lose USB functionalities after wake, so it wasnt worth the effort, the DP-alt mode works
  - I do not own any Thunderbolt 3 device, so I only tested through force_power
  - Still causes KP ocasionally
  - May require to flash a custom firmware in the Ti chip but I am not going to go that far
  - **Not going to fix it**
- Light Sensor (if there are any, I think some models may but mine doesn't have that)
  - If your model happen
- SmartCard (I don't have this feature, cannot test and probably will not work anyway)
- **Any Display Output:**
  - Yes YOU CANNOT output anything from the HDMI/DP/TB3 port
  - The HDMI port is linked to the TB3
  - TB3 and DP are both physically locked to the Nvidia card
  - The Nvidia card **WILL NEVER WORK**
  - The Nvidia card is disabled with ACPI
    - No outputs then
  - Solutions:
    - AirPlay
    - 3rd party screen streaming
    - USB to HDMI adapters (not tested)

## What's working badly/did not test

* USB-C port
  * It works once and never again until you reboot
  * Plugging anything in it may cause KPs after a while, on sleep, on reboot/shutdown
  * Don't
* Power Consumption
  * For now the CPU eats about <1W which is pretty good
  * The battery life is quite bad (~5 hours on a good day)
  * Warms up the bottom of the laptop
  * If anyone has any idea of why that's happening, please open an Issue or make a PR
* DRM support - not tested/fixed
  - I dont use iTunes/TV+
  - Netflix on Safari may not work (didn't test)
    - Works on Chrome/Firefox just fine
* Pen Pressure input, only works on 10.11 (you will have to do more work to get this running on 10.11, not covered here)
* *to be filled when I remember something*

## Things I'm trying to fix atm and need help with

- [ ] Thunderbolt 3
- [ ] Better Power Management
- [ ] Pen Pressure (blame Apple on that)
- [ ] Fix the SDcard Reader
- [ ] ~~Fix various issues that may or may not happen~~

---

## Installing macOS (10.13 and later)

### Preparing your computer

Before installing macOS, you'll have to prepare your computer.

Make sure you're in UEFI mode, I'm not going to help you on legacy installs.

1. ⚠️ **BACKUP EVERYTHING**, I will not take responsibility of anything that happens to your data.

2. If you're dual booting with windows:
   1. [Disable BitLocker](https://www.tenforums.com/tutorials/37060-turn-off-bitlocker-operating-system-drive-windows-10-a.html#option2) if you have it enabled already.
   2. Download a disk partitioning tool (like Minitool Partition Wizard, EaseUS, Aomei...), I DO NOT recommend Gparted as it may break NTFS and can create partition overlapping if you're not careful (if you're ok with it and sure about it, go for it).
   3. Resize your C: partition to leave at least 60GB from the right (because windows will be broken if you resize from the other side)
      - In case there are any partitions after the free space, move them at the end of the Windows partition (usually it's Recovery)
      - In case the EFI partition is less than 100MB, make it larger by shrinking the windows partition from the side of the EFI by the amount you need to grow it and some more.
        - This is crucial as it will help use format it with APFS later on.
   4. Create an empty FAT32 partition in that free space (CRUCIAL, as macOS doesn't see "empty" space.)
   
3. Boot to the Firmware Setup (AKA, BIOS Setup), use one of these methods:
   * Open Start > Settings > Updates and Security > Recovery > Advanced Startup > Troubleshoot > Advanced Options > **UEFI Firmware Settings** 
   * Shutdown the laptop, press the power button once, press **F1** (or keep holding it), you'll get into the UEFI Setup screen
   * Shutdown the laptop, press the power button once, press **F12** (or keep holding it), you'll get into the boot menu, press **Tab** and select Enter Setup
   * Shutdown the laptop, press the power button once, press Enter (or keep holding it), press F1 to access the BIOS Setup.
   * If you're using GRUB2/Systemd-boot, select Boot Firmware Setup
   
4. Configure your BIOS setting:
   1. Config
      1. Network
         1. **Disable all the stacks and Wake On LAN**
            * Will fix issues with Intel Ethernet in the OS
            * If you don't disable Wake On LAN you may have sleep issues later on macOS. Fixable but less desirable solution.
         
      2. USB

         1. Charge in battery mode
            1. Can be ON optionally

      3. Display
         1. Boot Display Device
            1. ThinkPad LCD
         2. **Total Graphics Memory**
            1. 512MB
               * Not sure if that's needed, but it's fine as it is
         3. **Graphics Device**
            1. Hybrid Graphics

      4. RAID
         1. **Disabled**

            * If you set it up before, or had Windows installed on 1 drive with RAID enabled, you'll have to fix that
              1. Backup your files
              2. Disable RAID
              3. Boot Windows
              4. It will crash, boot into safe mode
              5. Reboot to windows normally
              6. You should be good now

            * If you set it up before, or had drives (2 or more) in RAID mode, macOS will not be able to see them (hardware raid is not supported)
              * Either add a 4th drive for macOS or disable raid altogether.

   2. Security

      1. **Security Chip**
         1. Security Chip Selection: Intel PPT
            * The TPM chip existence creates sleep issues on macOS.
            * Use this and keep the presence if you're using security chips on Windows
            * Enabling this will disable Intel TXT
      2. Memory Protection
         1. Enabled (default)
      3. Virtualization
         1. Virtualization Technology
            1. Enabled (optionally, if you're going to use VMs or other apps using virtualization)
         2. VT-d
            1. Enabled (by default disabled, optionally, if you're going to use some encryption software -like bitlocker- or do some hardware passthrough on other OSes)
      4. I/O Port Access
         1. Disable hardware you're not going to use. (In my case, SDCard slot, TB3 and ExpressCard and WWAN)
      5. Anti-Theft
         1. Computrace
            1. Disabled (by default)
               * WARNING: if you choose Permanently Disabled, you will not be able to enable it again
      6. **Secure Boot**
         1. Secure Boot: Disabled
      7. Intel SGX
         1. Enabled (default)
      8. Device Guard
         1. Disabled (default)

   3. Startup

      1. UEFI/Legacy Boot
         1. **UEFI Only**
         2. CSM Support
            *  **NO**
            * You can enable it but there is really no need to
      2. Boot Mode: Quick

   4. Restart

      1. Exit Saving Changes

5. Reboot and make sure you can boot into Windows or Linux.

---

Ok, so I know that some of you may have a macOS machine nearby and some may not so I got the guide for both. The setup overview will be something like this:

1. Prepare a vanilla bare macOS installer
2. Install macOS and get it booting
3. Add extra stuff from this guide

### [OpenCore Laptop Guide by 1Revenger1](https://1revenger1.gitbook.io/laptop-guide/prepare-install-macos/preparing-the-usb-media)

- Please follow the guide properly, and read it fully before doing anything and prepare the needed hardware (you can skip WiFi card replacement).

- Make sure your laptop is charged

- **Use USB2.0 drives**

- Make sure you have a spare USB keyboard/mouse just in case and a USB type A hub

- **Changes** that are needed to do from the guide: (the rest should be the same as the guide prescribes)

  - You can use [ProperTree](https://www.github.com/corpnewt/ProperTree) on windows/linux to make OC's config.plist

  - Gathering Files (from the OpenCore main Guide):
    - Firmware Drivers
      - Use `HfsPlus` instead of `VboxHfs`, it's faster and it's Apple's official driver dumped from real Macs firmware.
      - Do not use `UsbKbDxe`, our keyboard is PS/2
      - `FwRuntimeServices` is already integrated in the OpenCorePkg zip in future releases.
    - Kexts
      - You do not need to use SMCSuperIO/LightSensor/BatteryManager
      - You **MUST** use rehabman's VoodooPS2Controller kext and **NOT** acidanthera's because it's buggy with hard surface trackpads.
      - IntelMausiEthernet from acidandanthera or Mieze (if you're doing the internet install)
      - There is no need for USBInjectAll, use `USBMap.kext` from this repo
      - You do not need to get all the kexts now, here is the list of the ones you really need for the installer:
        - VirtualSMC
        - Lilu
        - WhateverGreen
        - IntelMausi
        - VoodooPS2Controller
        - USBMap
    - SSDTs
      - Take from this guide (this one, not the linked)
        - SSDT-PLUG
          - Will enable native CPU power management
        - SSDT-USBX
          - From this repo, we do not need to fake EC as we already have it properly named.
    - Tools:
      - [Shell.efi](https://cdn.discordapp.com/attachments/573338611337003018/693559496462565447/Shell.efi)
        - Needed for some extra setup. This should be used until Acidanthera releases OpenShell with the next OpenCore releases.

  - OpenCore Template:

    - Note: you do not need to add the files manually in the config (the guide explains why). Just put the files where they should be and you can simply run OC Snapshot (or Clean Snapshot) to populate your config with proper paths for those files. This is covered in the guide in case you didn't follow through.

    - Skylake

      - DeviceProperties

        - `PciRoot(0x0)/Pci(0x2,0x0)`

          - Follow [Display Configuration](https://1revenger1.gitbook.io/laptop-guide/prepare-install-macos/display-configuration)

            - For Xeon models: Intel HD P530

              - `device-id` = `16190000`
              - `AAPL,ig-platform-id` = `00001619`
                - You can try `26190000` and `00002619` combination too

            - For i7 models: Intel HD 530

              - No need for `device-id`
              - Optional: `AAPL, ig-platform-id` = `00001619`

            - For **BOTH**: (our DVMT-prealloc is small, can't change it either)

              | Key                        | Type   | Value      |
              | :------------------------- | :----- | :--------- |
              | `framebuffer-patch-enable` | Number | `1`        |
              | `framebuffer-stolenmem`    | Data   | `00003001` |
              | `framebuffer-fbmem`        | Data   | `00009000` |

        - `PciRoot(0x0)/Pci(0x1f,0x3)`

          - `layout-id` = `29` (Number)

      - Kernel

        - Quirks
          - `XhciPortLimit` = `NO` 
            - There is no need for this
          - `AppleCpuPmCfgLock` = `NO`
            - There is no need for this

      - NVRAM

        - `4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14` (Booter Path)
          - For those with 4K display:
            - `UIScale` = `02`
        - `7C436110-AB2A-4BBB-A880-FE41995C9F82`
          - `boot-args`
            - `-v debug=0x100 keepsyms=1` 
              - Use this for this install section, you can remove `-v debug=0x100` once we're done.
          - Remove/Keep empty:
            - `nvda_drv`
            - `prev-lang:kbd`
          - `csr-active-config`
            - Keep it as `00000000` for full SIP (RECOMMENDED)
            - Keep it as `01000000` for unsigned kext allowing (partial SIP disabling, ONLY FOR TESTING KEXTS LOCALLY)

      - PlatformInfo

        - Use `MacBookPro13,3` (better the latter)

      - UEFI

        - Protocols
          - AppleSmcIo
            - Enable this if you're using FileVault2

  - Setting up Input Devices

    - Use **VoodooPS2Controller Rehabman Fork**
      - The Acidanthera one is broken for us

- Follow the rest of the guide as usual but skip:

  - Embedded Controller (EC)
  - USB Pre-Setup

- When done, make sure you check everything again before starting.

### You're good to go and start your macOS installer

1. You can boot your OpenCore drive by starting your laptop to the Boot Menu
   - By pressing Enter until you get the Boot Interrupt Menu, press F12
   - By pressing F12
2. Boot your OpenCore USB
3. When you get to the OpenCore Boot Picker, **quickly press the number for macOS recovery/installer** (you have 5 seconds)
4. After macOS Installer starts up, select Disk Utility
   1. Select View > All Devices 
      - ![ViewDevices](https://github.com/midi1996/X2G2-opencore-hackintosh/raw/master/images/ViewDevices.png)
   2. Select the partition you made earlier
   3. Select Erase
   4. Select APFS as format and name the drive whatever you want
      - ![erase](https://github.com/midi1996/X2G2-opencore-hackintosh/raw/master/images/erase.png)
   5. Select Erase
      - ⚠️ Disk Utility can suddenly crash and go back to the main menu, just wait like a minute or two, open Disk Utility again and see if the drive has been formatted
   6. Close Disk Utility once done and select Install macOS and install macOS obviously.
   7. The installer may reboot several times (at least once) and will automatically choose the drive to boot from, do not select/change the boot order. Make sure you start your USB drive on each reboot, you can do that automatically by moving the USB boot entry in Boot Options in your BIOS Setup to the top of the list order.
   8. Once macOS installed and get to the desktop (make sure you skip Apple Account login) you can now:
      1. Download [MountEFI](https://github.com/corpnewt/MountEFI) and install the Automator Quick Action
      2. While in Finder, click on Finder > Preferences > General > Show these items on the desktop > Hard disks and External disks
      3. You will see your SSD's partitions on the desktop, right click on the macOS partition > Quick Actions > Mount EFI > type in your password when you get the prompt. Your SSD's EFI will show up.
      4. Copy `Your USB's FAT32 partition` > `EFI` > `BOOT` and `OC` to `Your SSD's EFI` > `EFI` > `.`
         - Go `Your SSD's EFI` > `EFI` > `Boot`, rename OC's BOOTx64.EFI to BOOTxOC.EFI (this is so that it doesn't get overwritten after Windows Updates/Linux Grub2 Updates)
      5. Reboot to USB's OC
      6. Select "Shell.efi"
      7. Once you're greeted with the shell
         1. Type `map -b`, usually you'll find the first partition listed is the FAT32 readable partition, should be named `FSX:` where X is a number
            * In case you have multiple drives with FAT32 partitions your EFI might be something different than FS0, always check the files inside the partition you chose by running `ls`.
         2. Type `FSX:` 
         3. Type `bcfg boot add 00 FSX:\EFI\BOOT\BOOTxOC.EFI "OpenCore Booter"`
            - bcfg: Manages the boot and driver options that are stored in NVRAM. -- UEFI Spec sheet
            - boot: what bcfg needs to change
            - add: add entry
            - 00: entry order in the list (00 being the very first entry)
            - FSX:\EFI...: path to the EFI file
            - "OpenCore Booter": name of the entry, you can choose whatever you want as long as it's 3 characters long and with the quotes.
         4. I recommend you run the same commands for `Shell.efi` to make it accessible from the UEFI Boot Menu in case you need to fix/check things.
         5. Press Ctrl + Alt + Del and your laptop will reboot
      8. After that a new entry for the BOOTxOC is made and your laptop will boot to OC automatically.
         - Note that in the event of a Windows Update "replaces your EFI" (which it totally does NOT), you can simply check the boot order in the BIOS Setup > Boot and change the order as you see fit, or if suddenly the entry vanishes, you'll have to redo the steps above
         - I have yet to get this kind of issue
         - OpenCore's NVRAM clearing will reset the EFI boot entries to the defaults, rerun the above after an NVRAM clearing

---

### Fixing macOS and friends

After installing macOS, getting OpenCore to boot, it's time to get the rest of it to work. In this repository you'll find a bunch of SSDTs with a plist for patches that comes with SSDTs (if needed). Note that these ACPI files are made with my machine in mind (the RAM, SSD and HDD differences do not matter), and depending on your motherboard revision and your UEFI Firmware version/variation/revision/options, you may need to change things, but usually you wouldn't need to but just in case, I'll link many resources to get information to fix things on your end.

### ACPI Fixes

| SSDT File Name         | Patch(es) to use with (if needed)                            | Reason to use                                                |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| SSDT-BAXX              | - Change Method(_WAK,1,N) to XXAK<br />- Change Method(GBIF,3,N) to XBIF<br />- Change Method(GBST,4,N) to XBST<br />- Change _L17 to XL17<br />- Change BAT1 to BAX1 (use only if you have one battery) | Battery patches to get battery reading in macOS. The SSDT has the patched OperationRegions + Methods, the OC patches rename the original methods to something else so that macOS uses the new patched methods in the SSDT.<br />This SSDT **does not** take in consideration a dual battery setup. If you're using 2 batteries, refer to SSDT-BATC (google). |
| SSDT-KBD               | - Change Method(\_Q15,0,N) to XQ15<br />- Change Method(\_Q14,0,N) to XQ14<br />- Change Method(\_Q6A,0,N) to XQ6A<br />- Change Method(\_Q16,0,N) to XQ16<br />- Change Method(\_Q64,0,N) to XQ64<br />- Change Method(\_Q66,0,N) to XQ66<br />- Change Method(\_Q67,0,N) to XQ67<br />- Change Method(\_Q68,0,N) to XQ68<br />- Change Method(_Q69,0,N) to XQ69<br /> | Contains Hotkey fixes for Brightness keys, Volume keys and the other keys are all mapped to some Fn key that I totally forgot about. You can map them separately with Karabiners or Keyboard preference panel. |
| SSDT-NoHybGfx          | *none*                                                       | Disables the Nvidia dGPU following bumblebee guidelines (Credit: Maemo) |
| SSDT-PNLF              | *none*                                                       | Fixes brightness by adding a PNLF device.                    |
| SSDT-SBUS-MCHC         | *none*                                                       | Adds SBUS and MCHC devices, needed for macOS.                |
| SSDT-Thinkpad_Trackpad | *none*                                                       | Contains VoodooPS2Controller settings to fix the TrackPoint jumpiness |
| SSDT-USBX              | *none*                                                       | Adds USB properties for AppleBusPowerController for the USB ports, helps with the 10 W output support. |
| SSDT-XCPM              | *none*                                                       | Adds `plugin-type` property to the CPU scope device, helps with CPU Power management. Contains CPUFriend Data. |
| SSDT-XOSI              | _OSI to XOSI                                                 | Renames the _OSI (Operating System Interface Level) method so that we can add macOS identification in the SSDT, this way, features that would only be enabled if Windows was detected would be also available for macOS. In our case it actually doesn't really matter, but just to be sure that it doesn't limit anything later down the road on UEFI Firmware updates. |
| *none*                 | Change SAT1 to SATA                                          | To enable proper compatibility with macOS SATA drivers (for power management). |
| *none*                 | FPU to MATH                                                  | To enable MATH device. macOS look for MATH device.           |
| *none*                 | Change XHCI to XHC                                           | To disable macOS's auto-attachement to the XHCI device and applying the SMBIOS's native USB port mapping, we don't want that, and we're using our own USBMap anyways. |

#### Kernel Extensions (Kexts)

| Kext                      | Use                                                          | Depends on                                             | Source                                               | Download link                                            |
| ------------------------- | ------------------------------------------------------------ | ------------------------------------------------------ | ---------------------------------------------------- | -------------------------------------------------------- |
| Lilu                      | An open source kernel extension bringing a platform for arbitrary kext, library, and program patching throughout the system for macOS. | *none*                                                 | https://github.com/acidanthera/Lilu                  | https://github.com/acidanthera/Lilu/releases             |
| VirtualSMC                | Advanced Apple SMC emulator in the kernel.                   | Lilu                                                   | https://github.com/acidanthera/VirtualSMC            | https://github.com/acidanthera/VirtualSMC/releases       |
| WhateverGreen             | Various patches necessary for certain ATI/AMD/Intel/Nvidia GPUs | Lilu                                                   | https://github.com/acidanthera/WhateverGreen         | https://github.com/acidanthera/WhateverGreen/releases    |
| AppleALC                  | An open source kernel extension enabling native macOS HD audio for not officially supported codecs without any filesystem modifications. | Lilu                                                   | https://github.com/acidanthera/AppleALC              | https://github.com/acidanthera/AppleALC/releases         |
| USBMap                    | Maps the USB ports by personality and address                | *none*                                                 | Made by [USBMap](https://github.com/corpnewt/USBMap) | *in this repository*                                     |
| AirportBrcmFixup          | An open source kernel extension providing a set of patches required for non-native Airport Broadcom Wi-Fi cards. | Lilu                                                   | https://github.com/acidanthera/AirportBrcmFixup      | https://github.com/acidanthera/AirportBrcmFixup/releases |
| CPUFriend                 | A Lilu plug-in for dynamic power management data injection.  | Lilu                                                   | https://github.com/acidanthera/CPUFriend             | https://github.com/acidanthera/CPUFriend/releases        |
| VoodooI2C <sup>1</sup>    | VoodooI2C is a project consisting of macOS kernel extensions that add support for I2C bus devices. In our Case Fore OpenCore, make sure you put the Dependencies (found in VoodooI2C.kext/Contents/Plugins) in this order: | - VoodooI2CServices<br />- VoodooGPIO<br />- VoodooI2C | https://github.com/alexandred/VoodooI2C              | https://github.com/alexandred/VoodooI2C/releases         |
| VoodooI2CHID <sup>1</sup> | A satellite kext for VoodooI2C to enable support for I2C-HID support, like the touchscreen. | VoodooI2C                                              | https://github.com/alexandred/VoodooI2C/             | https://github.com/alexandred/VoodooI2C/releases         |
| NoTouchID                 | Lilu plugin for disabling Touch ID support. Helps with the lag/hang when being asked for password input when using MBP13,1 and later SMBIOSes. | Lilu                                                   | https://github.com/al3xtjames/NoTouchID              | https://github.com/al3xtjames/NoTouchID/releases         |
| SMCBatteryManager         | VirtualSMC Plugin to enable battery states readings.         | VirtualSMC                                             | https://github.com/acidanthera/VirtualSMC            | https://github.com/acidanthera/VirtualSMC/releases       |
| SMCProcessor              | VirtualSMC Plugin to enable CPU information readings (Temp, Freq...) | VirtualSMC                                             | https://github.com/acidanthera/VirtualSMC            | https://github.com/acidanthera/VirtualSMC/releases       |
| VoodooPS2Controller       | Enables PS/2 Support on macOS, make sure you put this kext before VoodooPS2Keyboard. VoodooPS2Mouse and VoodooPS2Trackpad can be removed/disabled. (ProperTree should be able to sort them automatically.) | *none*                                                 | https://github.com/acidanthera/VoodooPS2/            | https://github.com/acidanthera/VoodooPS2/releases        |
| BrcmBluetoothInjector     | The BrcmBluetoothInjector.kext is a codeless kernel extension which injects the BT hardware data using a plist; it does not contain a firmware uploader. | *none*                                                 | https://github.com/acidanthera/BrcmPatchRAM          | https://github.com/acidanthera/BrcmPatchRAM/releases     |
| BrcmFirmwareData          | Holds all the configured firmwares for different Broadcom Bluetooth USB devices | BrcmBluetoothInjector                                  | https://github.com/acidanthera/BrcmPatchRAM          | https://github.com/acidanthera/BrcmPatchRAM/releases     |
| BrcmPatchRAM3             | A macOS driver which applies PatchRAM updates for Broadcom RAMUSB based devices. (Note that BrcmPatchRAM3 is to be used with 10.15, it works with 10.14 but BrcmPatchRAM2 is recommended for that OS version, OpenCore can inject either of them depending on the OS version, make sure you configure it in the config.plist) | - BrcmBluetoothInjector<br />- BrcmFirmwareData        | https://github.com/acidanthera/BrcmPatchRAM          | https://github.com/acidanthera/BrcmPatchRAM/releases     |
| NVMeFix                   | NVMeFix is a set of patches for the Apple NVMe storage driver, IONVMeFamily. Its goal is to improve compatibility with non-Apple SSDs. It may be used both on Apple and non-Apple computers. | Lilu                                                   | https://github.com/acidanthera/NVMeFix               | https://github.com/acidanthera/NVMeFix/releases          |

<sup>1</sup> : Only use this if you have a touchscreen and you want to use it with macOS. Not really the best way o interact with macOS as the driver will turn the touchscreen into a giant trackpad which is uncomfortable if you're going to invoke Launchpad or the like. Not really needed.

#### Note: 

As of writing these things are happening:

- VoodooI2C will be VoodooInput reliant, make sure you load VoodooInput before VoodooI2C, however from what I last tried, it doesn't work well
- An intel Wifi driver is on the work, no promises though
- *to be added if anything*

You should be all done for now. All of these patches will be in `oc-additions.plist`. You will have to merge them in your config.plist that you made earlier with the OpenCore guide.

---

## Issues and small fixes and whatever I can't put in a category lol

### Type C

No (not now)

### USB port mapping

| Port      | Address    | Physical Location                    | Internal/External | Enabled/Disabled in USBMap |
| --------- | ---------- | ------------------------------------ | ----------------- | -------------------------- |
| HSP0/SSP0 | `00000001` | Back Port - Power Share              | E                 | E                          |
| HSP1/SSP1 | `00000002` | Back Port - next to Ethernet Port    | E                 | E                          |
| HSP4/SSP4 | `00000005` | Right Port - next to mDP             | E                 | E                          |
| HSP5/SSP5 | `00000006` | Right Port - next to 3.5mm jack port | E                 | E                          |
| HSP7      | `00000008` | Integrated Camera module             | I                 | E                          |
| HSP8      | `00000009` | Fingerprint Sensor                   | I                 | D                          |
| HSP9      | `0000000A` | Wacom Touchscreen + Pen              | I                 | E                          |
| HSPC      | `0000000F` | X-Rite Pantone Color Sensor          | I                 | D                          |
| HSPD      | `0000000E` | Bluetooth USB Port                   | I                 | E                          |

### WiFi Card replacement

You will need to disassemble your laptop:

1. Remove the battery and power
2. Remove the back cover
   * The screws stay retained in the cover
3. You will find 3 screw holes for the keyboard, THEY ARE LONG
4. Open back the laptop screen and slide the keyboard towards the screen (DO NOT LIFT)
5. The keyboard will loosen up on bottom, you can lift it **GENTLY** from the bottom (aka the tracepoint buttons area)
6. Disconnect the TrackPoint and Keyboard ribbons (BE CAREFUL! THEY VERY FRAGILE)
7. You have now access to the extra 2 RAM slots and WWAN and WLAN slots.

#### Compatible WiFi Cards

As of now there are a lot of WiFi cards that are compatible:

| WiFi card                                    | Quirks and issues                                            |
| -------------------------------------------- | ------------------------------------------------------------ |
| Dell's DW1560<br />Lenovo's PN 04X6020       | Expensive AF now because they're not in production anymore.<br />Lenovo's part **NEEDS** dremeling, not really recommended if you don't know how to do that. |
| Dell's DW1820A<br />Lenovo's 00JT494/00JT493 | Cheap now, works.<br />**Requires** adding `pci-aspm-default` = `0` (number) to its device path under DeviceProperties (for my case it's under `PciRoot(0x0)/Pci(0x1c,0x0)/Pci(0x0,0x0)`, you can check yours by using gfxutil from Acidanther's repo, however technically, it should be the same)<br />Has NaTiVe linux support which is 10/10<br />There is another taping solution from here: [tmx thread](https://www.tonymacx86.com/threads/thinkpad-p50-sierra-10-12-6.229084/post-2083809)<br />Bluetooth firmware fixed with the latest BrcmPatchRam from acidanthera. |
| Apple's BCM94360CS2 or BCM943602CS           | CS2 is limited to 867Mbps on AC and up to 300Mbps on N (2.4Ghz), 2CS goes up to 1.3Gbps.<br />CS2 uses 2 antennae, 2CS needs 3 antennae! (You will have to use one of the WWAN antennae)<br />Technically any card that would fit there would work, CD variant can't because of the antenna connector (M.FL vs MHF4, we need the latter, you will have to use converters)<br />You will have to use a 12 + 6 to A/E adapter like shown in this [album](https://imgur.com/a/wRwnmDV). Since I don't use a WWAN, it made a snug fit there.<br />I got the card for $10, now the price has gone up. |
| *all of the above*                           | You might want to `brcmfx-country=#a` to unlock some bands and get higher speeds. (You may also put your own country identifier) |

### HiDPI Resolutions (for 4k screens users)

By default, if you get proper screen resolution after macOS install, the screen res would be at a 200% DPI, which is for our devices 1920 by 1080, looks small on paper but its actual resolution is twice that at 3840 by 2160 which, you guessed it, your native screen resolution. It makes text sharper, elements of the screen bigger and more comfortable to use, however unlike windows, macOS does not have non-integer scaling, so you will not have a % you can choose from, but you'll have to give macOS a resolution to emulate and then "x2"s it as a Retina resolution. (The example bellow is taken from my tablet's guide, which has a 3:2 aspect ratio and a screen resolution of 2736x1824, the logic is the same).

- So for example, you want to get the "150%" scale on macOS
- Your "resolution" for that scale is 1536x1024 (from X2 guide)
  - If you give this resolution to macOS, the whole display will be blurry and mushy because the display will *upscale* it
  - To get better results visually, you will need to tell macOS that you have double that resolution and then it will "retinize" that resolution
  - So you must give macOS a resolution of 1536\*2 by 1024\*2 which is **3072** by **2048**. 
- To do that, you'll either have to follow [this guide](https://www.tonymacx86.com/threads/adding-using-hidpi-custom-resolutions.133254/) or by simply using this [RDM Utility](https://github.com/usr-sse2/RDM/releases)
  - This utility has the possibility of reading all possible resolutions of your system, and the ones that are marked with a ⚡️ are HiDPI resolutions.
  - You can even add resolutions (make sure they're twice the "seen" resolution and check "HiDPI")
  - This needs SIP disabled
    - ⚠️ Disabling SIP may create security issues on your system as the part of the OS that is critical is now vulnerable to modifications
    - You can completely disable it by rebooting to the recovery and running `csrutil disable`
    - You can completely disable it by editing `config.plist`\\`NVRAM`\\`7C436110-AB2A-4BBB-A880-FE41995C9F8`\\`csr-active-confg` = `E7030000` (in ProperTree or Xcode, if you're doing it with a text editor type `5wMAAA==`) -- not recommended by OC.
      - Reboot to macOS

---

### Documentations and guides that you must read/follow in case you need assistance:

- [OpenCore Configuration](https://github.com/acidanthera/OpenCorePkg/raw/master/Docs/Configuration.pdf)
- [OpenCore Vanilla Guide](https://khronokernel.github.io/Opencore-Vanilla-Desktop-Guide/)
- Rehabman's:
  - [ACPI patching guide](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/)
  - [ACPI hot patching guide](https://www.tonymacx86.com/threads/guide-using-clover-to-hotpatch-acpi.200137/)
  - [Laptop Guide](https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/) (it's old now, I recommend fewtarius' guide)
  - [USB Power Property](https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/)
  - [Battery patching](https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/) (to be used with SMCBattery)
  - [Power Management](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/)
- [Fewtarius' Clover Laptop guide](https://fewtarius.gitbook.io/laptopguide/)
- Acidanthera's
  - WhateverGreen [documentation](https://github.com/acidanthera/WhateverGreen/tree/master/Manual)
  - AppleALC [wiki](https://github.com/acidanthera/AppleALC/wiki)
- Osy's
  - [HDA Fix](https://osy.gitbook.io/hac-mini-guide/details/hda-fix)
  - [Thunderbolt shenanigans](https://osy.gitbook.io/hac-mini-guide/details/thunderbolt-3-fix) (good bed time stories)
- VoodooI2C's [documentation](https://voodooi2c.github.io/#index)

---

And with that, Good Luck and let me know if you succeeded. Also I would love to get fixes and changes to this guide to improve on it. Open an Issue or make a PR and I'll review it.

## Credits

- [Apple](https://www.apple.com) for macOS
- [Acidanthera](https://github.com/acidanthera) for OpenCore and all the kexts/utilities that they made
- [Alex James (aka theracermaster)](https://github.com/al3xtjames) for NoTouchID and information
- [Alexandre Daoud](https://github.com/alexandred/) for VoodooI2C and more
- [CorpNewt](https://github.com/corpnewt/) for many tools and utilities used through this guide ([ProperTree](https://github.com/corpnewt/ProperTree), [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS), [USBMap](https://github.com/corpnewt/USBMap) and many more) and help to get this going in the first versions of OC
- [DhinakG](https://github.com/dhinakg) for various help
- [fewtarius](https://github.com/fewtarius) for Clover Laptop Guide and help
- [Resset](https://github.com/Ressetkk) for help with ACPI trash
- [Mykola Grymalyuk aka khronokernel (boomer-chan)](https://github.com/khronokernel) for the OC guide and help (and being trash)
- [osy86](https://github.com/osy86/) for TB3 debugging and tons of informative writing about thunderbolt
- [Rehabman](https://github.com/RehabMan/) for the patches and guides and kexts
- [ReddestDream](https://github.com/reddestdream) for tons of information
- [r/hackintosh Discord](http://discord.io/hackintosh) ~~for being a shithole~~ for various helping hands and great community
- [InsanelyMac Forums](https://insanelymac.com/forum) for whatever they have there, I haven't posted in that place in years
- [Tonymacx86 forums](https://tonymacx86.com) for being **assholes** and banning me because I asked for volunteers to help me fix TB3, but fuck them anyway! DONT USE THEIR CRAP TOOLS!

Thank you.
