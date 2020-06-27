---
title:  "Windows Security Tools"
date:   2020-06-28 00:00:00 +0800
categories: infosec
excerpt: "A collection of useful tools for Windows infosec researchers."
header:
  overlay_color: "#000"
  overlay_filter: "0.75"
  overlay_image: /assets/screenshots/cape.png
  caption: "Cape Sandbox"
toc: true
---

## Reverse Engineering

Use multiple tools for comparison when decompiling! Every tool creates different results. **Always** use multiple decompilers if you encounter weird results.
{: .notice--danger}

### Generic Binaries

- [Ghidra](https://ghidra-sre.org)
  - ✅ **Pricing**: Free
  - ✅ **Codebase**: Open-source
  - 📝 **Notes**:
    - Made by NSA
- [Binary Ninja](https://binary.ninja/)
  - ⚠ **Pricing**: Paid ($149 USD/$4,500 NTD)
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - Cheap alternative to IDA Pro
    - Supports plugin development
    - Support native psuedo-code decompiler on the latest dev branch
- [IDA Pro](https://www.hex-rays.com/products/ida/index.shtml)
  - ⚠ **Pricing**: Paid ($1,879 USD/$57,000 NTD)
    - For base application; this does not include any necessary decompilers
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - Industry standard
    - Supports 50+ CPU instruction types

### .NET Binaries

- [dnSpy](https://github.com/0xd4d/dnSpy)
  - ✅ **Pricing**: Free
  - ✅ **Codebase**: Open-source
  - 📝 **Notes**:
    - Cross-platform
    - Has a built-in debugger and anti-anti-debug features
      - By default spoofs `IsDebuggerPresent`, `CheckRemoteDebuggerPresent`, and `System.Diagnostics.Debugger`
- [dotPeek](https://www.jetbrains.com/decompiler/)
  - ✅ **Pricing**: Free
  - ⚠ **Codebase**: Proprietary
- [.NET Reflector](https://www.red-gate.com/products/dotnet-development/reflector/)
  - ⚠ **Pricing**: Paid ($205 USD/$6,200 NTD)
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - **Can decompile to async state machine level**
    - Students can apply for the .NET Developer Bundle for free

## Dynamic Analysis

### Sandbox

- [Cape Sandbox](https://github.com/kevoreilly/CAPEv2)
  - ✅ **Pricing**: Free
  - ✅ **Codebase**: Open-source
  - 📝 **Notes**:
    - Useful for a quick dynamic/static analysis
    - Provides full memory dump
    - Highly configurable
    - [Official host](https://capesandbox.com/)
    - [Backup host](https://sandbox.xor.al/)

### Network

- [Fiddler](https://www.telerik.com/fiddler)
  - ✅ **Pricing**: Free
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - HTTP(s) debugger

- [Burp Suite](https://portswigger.net/burp/communitydownload)
  - ⚠ **Pricing**: Free limited shareware; paid ($399 USD/$12,000 TWD)
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - Cross-platform
    - HTTP(s) debugger
    - Popular among web pentesters

- [FakeNet-NG](https://github.com/fireeye/flare-fakenet-ng)
  - ✅ **Pricing**: Free
  - ✅ **Codebase**: Open-source
  - 📝 **Notes**:
    - Cross-platform
    - ⚠ Based on Python 2.x
    - Listens for DNS/HTTP(s)/SSL requests
    - Attempts to serve legitimate files
      - e.g. if the malware requests an JPG file, it will return the user-specific JPG file
    - Ability to create capture file (`*.pcap`)

### Binary

- [Process Hacker](https://processhacker.sourceforge.io/)
  - ✅ **Pricing**: Free
  - ✅ **Codebase**: Open-source
  - 📝 **Notes**:
    - Based on Process Explorer
    - View process tree, network ports, disk activity
    - Manage services
    - Flag malicious executable
    - Inject DLL
    - Manage per-app thread(s)
    - Show if the process is...
      - Packed by a packer
      - Digitally signed
      - A .NET process
    - Too many to list

- [Process Explorer](https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer)
  - ✅ **Pricing**: Free
  - ⚠ **Codebase**: Proprietary
  - 📝 **Notes**:
    - Created by Microsoft

## Static Analysis

- strings
  - `scoop install strings`
- trid
  - `scoop install trid`
- pestudio
  - Performs `strings` and VirusTotal analysis
  - Shows referenced API calls
  - Checks for signature validity

## PowerShell

### Red Team

- [PowerMemory](https://github.com/giMini/PowerMemory)
  - In-memory credentials discovery
- [CheckPlease](https://github.com/Arvanaghi/CheckPlease)
  - Sandbox evasion
- [UltimateAppLockerByPassList](https://github.com/api0cradle/UltimateAppLockerByPassList)
  - AppLocker bypass techniques
- [Invoke-Obfuscation](https://github.com/danielbohannon/Invoke-Obfuscation)
  - PowerShell obfuscation

### Blue Team

## Useful Notes

- Starting from Windows 10 v1803, `curl` is included with the OS.
  - PowerShell users may need to invoke `curl.exe` instead of `curl` to avoid the `Invoke-WebRequest` alias.
  - Alternatively, remove the alias by using `Remove-Alias curl`.
