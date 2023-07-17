---
title: A Closer Look at CAPA
excerpt: A new static analysis tool from FireEye?
date: 2020-07-19T11:18:15.756Z
category: infosec
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: /assets/images/posts/capa/f8bafbb80dbef953655ae30f2933fd8cdc8efa8498efda0b8541741223c56084.png
---

## What is it

While looking around Fireeye's website for the latest news on their Flare-on CTF, I found that they had just recently released a new tool for threat researchers, dubbed `capa`. I thought it'd be a perfect opportunity to further expand ever-growing collection of [Windows Security Tools]({% post_url 2020-06-28-windows-security-tools %}). So what is it?

As explained by the authors themselves,

> capa is the FLARE team’s newest open-source tool for analyzing malicious programs. Our tool provides a framework for the community to encode, recognize, and share behaviors that we’ve seen in malware. Regardless of your background, when you use capa, you invoke decades of cumulative reverse engineering experience to figure out what a program does.
>
> \- [capa: Automatically Identify Malware Capabilities](https://www.fireeye.com/blog/threat-research/2020/07/capa-automatically-identify-malware-capabilities.html)

Time to put it in practice then! For testing, I've downloaded a real-world malware straight from a [CAPE Sandbox test](https://capesandbox.com/analysis/27798/). Hashes of the malicious executable can be found below.

| Name         | Value                                                            |
| ------------ | ---------------------------------------------------------------- |
| File Size    | 601088 bytes                                                     |
| File Type    | PE32 executable (GUI) Intel 80386, for MS Windows                |
| PE timestamp | 1992-06-19 22:22:17                                              |
| MD5          | 040e497c26b9609145715352da4e76d1                                 |
| SHA1         | 901893e827a35fddca1563c35514c69d86899993                         |
| SHA256       | b7a17727462906ac85e4082ac63a7a3884e67c222e36e9696e445b3ff882bf28 |

## Usage

The version of `capa` used in the article is `v1.0.0-9-g97b8a5e`, the earliest release build; features are subject to change.
{: .notice--info}

Let's first take a look at what it can do for us with `capa --help`.

```markdown
usage: capa-v1.0.0-win.exe [-h] [--version] [-r RULES]
                           [-f {auto,pe,sc32,sc64,freeze}] [-t TAG] [-j] [-v]
                           [-vv] [-d] [-q] [--color {auto,always,never}]
                           sample

identify capabilities in programs.

Copyright (C) 2020 FireEye, Inc. All Rights Reserved.

positional arguments:
  sample                path to sample to analyze

optional arguments:
  -h, --help            show this help message and exit
  --version             show program's version number and exit
  -r RULES, --rules RULES
                        path to rule file or directory, use embedded rules by
                        default
  -f {auto,pe,sc32,sc64,freeze}, --format {auto,pe,sc32,sc64,freeze}
                        select sample format, auto: (default) detect file type
                        automatically, pe: Windows PE file, sc32: 32-bit
                        shellcode, sc64: 64-bit shellcode, freeze: features
                        previously frozen by capa
  -t TAG, --tag TAG     filter on rule meta field values
  -j, --json            emit JSON instead of text
  -v, --verbose         enable verbose result document (no effect with --json)
  -vv, --vverbose       enable very verbose result document (no effect with
                        --json)
  -d, --debug           enable debugging output on STDERR
  -q, --quiet           disable all output but errors
  --color {auto,always,never}
                        enable ANSI color codes in results, default: only
                        during interactive session

By default, capa uses a default set of embedded rules.
You can see the rule set here:
  https://github.com/fireeye/capa-rules

To provide your own rule set, use the `-r` flag:
  capa  --rules /path/to/rules  suspicious.exe
  capa  -r      /path/to/rules  suspicious.exe

examples:
  identify capabilities in a binary
    capa suspicous.exe

  identify capabilities in 32-bit shellcode, see `-f` for all supported formats
    capa -f sc32 shellcode.bin

  report match locations
    capa -v suspicous.exe

  report all feature match details
    capa -vv suspicious.exe

  filter rules by meta fields, e.g. rule name or namespace
    capa -t "create TCP socket" suspicious.exe
```

## Standard Report

Quite a few things! Maybe we'll first start off by invoking capa with no parameters and see what it tells us about the malware, so `capa 'Quotation Request.ex_'`.

```markdown
4628 functions [00:26, 175.16 functions/s]
+------------------------+------------------------------------------------------------------------------------+
| md5                    | 040e497c26b9609145715352da4e76d1                                                   |
| path                   | Quotataion Request.ex_                                                             |
+------------------------+------------------------------------------------------------------------------------+

+------------------------+------------------------------------------------------------------------------------+
| ATT&CK Tactic          | ATT&CK Technique                                                                   |
|------------------------+------------------------------------------------------------------------------------|
| COLLECTION             | Input Capture::Keylogging [T1056.001]                                              |
|                        | Screen Capture [T1113]                                                             |
| DEFENSE EVASION        | Obfuscated Files or Information [T1027]                                            |
|                        | Process Injection [T1055]                                                          |
|                        | Virtualization/Sandbox Evasion::System Checks [T1497.001]                          |
| DISCOVERY              | Application Window Discovery [T1010]                                               |
|                        | File and Directory Discovery [T1083]                                               |
|                        | Query Registry [T1012]                                                             |
|                        | System Information Discovery [T1082]                                               |
| EXECUTION              | Shared Modules [T1129]                                                             |
+------------------------+------------------------------------------------------------------------------------+

+------------------------------------------------------+------------------------------------------------------+
| CAPABILITY                                           | NAMESPACE                                            |
|------------------------------------------------------+------------------------------------------------------|
| check for time delay via GetTickCount (4 matches)    | anti-analysis/anti-debugging/debugger-detection      |
| execute anti-VM instructions (15 matches)            | anti-analysis/anti-vm/vm-detection                   |
| log keystrokes                                       | collection/keylog                                    |
| log keystrokes via polling (7 matches)               | collection/keylog                                    |
| capture screenshot (2 matches)                       | collection/screenshot                                |
| compiled with Borland Delphi                         | compiler/delphi                                      |
| encode data using XOR (2 matches)                    | data-manipulation/encoding/xor                       |
| contain a resource (.rsrc) section                   | executable/pe/section/rsrc                           |
| contain a thread local storage (.tls) section        | executable/pe/section/tls                            |
| extract resource via kernel32 functions (4 matches)  | executable/resource                                  |
| get common file path                                 | host-interaction/file-system                         |
| get file size                                        | host-interaction/file-system/meta                    |
| get file version info                                | host-interaction/file-system/meta                    |
| read file                                            | host-interaction/file-system/read                    |
| write file (3 matches)                               | host-interaction/file-system/write                   |
| set application hook (2 matches)                     | host-interaction/gui                                 |
| set global application hook                          | host-interaction/gui                                 |
| enumerate graphical windows (2 matches)              | host-interaction/gui/window/find                     |
| find graphical window                                | host-interaction/gui/window/find                     |
| get keyboard layout (2 matches)                      | host-interaction/hardware/keyboard/layout            |
| get disk information                                 | host-interaction/hardware/storage                    |
| get system information                               | host-interaction/os/info                             |
| allocate RWX memory (2 matches)                      | host-interaction/process/inject                      |
| open registry key (4 matches)                        | host-interaction/registry/open                       |
| query registry entry (4 matches)                     | host-interaction/registry/query                      |
| query registry value (4 matches)                     | host-interaction/registry/query                      |
| create thread (2 matches)                            | host-interaction/thread/create                       |
| link function at runtime (11 matches)                | linking/runtime-linking                              |
| parse PE header (32 matches)                         | load-code/pe                                         |
+------------------------------------------------------+------------------------------------------------------+
```

Interesting! Right off the bat it's already told us a lot about our malware. For example, some red flags often seen in malware, including VM/sandbox detection (`execute anti-VM instructions`), keylogging (`log keystrokes`), allocate read-write-executable memory (`allocate RWX memory`) and more. Neat!

## Verbose Report (`-vv`)

Let's see if we can get more details about the malware by invoking `-vv` as the parameter.

![Image](/assets/images/posts/capa/f8bafbb80dbef953655ae30f2933fd8cdc8efa8498efda0b8541741223c56084.png)

Whoa! All of the sudden we're getting so much more information! Let's break it down by taking a look at some of the features noted by capa.

```markdown
log keystrokes
namespace  collection/keylog
author     moritz.raabe@fireeye.com
scope      function
att&ck     Collection::Input Capture::Keylogging [T1056.001]
examples   C91887D861D9BD4A5872249B641BC9F9:0x4015FD
function @ 0x444928
  or:
    api: user32.MapVirtualKey @ 0x444947

log keystrokes via polling (7 matches)
namespace  collection/keylog
author     michael.hunhoff@fireeye.com
scope      function
att&ck     Collection::Input Capture::Keylogging [T1056.001]
examples   Practical Malware Analysis Lab 11-03.dll_:0x10001030
function @ 0x433434
  or:
    api: user32.GetKeyState @ 0x43345B
function @ 0x436B7C
  or:
    api: user32.GetKeyboardState @ 0x436CB1
function @ 0x444928
  or:
    api: user32.GetKeyNameText @ 0x444960
function @ 0x4489E4
  or:
    api: user32.GetKeyState @ 0x448A08, 0x448A1A
function @ 0x44C0FC
  or:
    api: user32.GetKeyState @ 0x44C13A
function @ 0x44C150
  or:
    api: user32.GetKeyState @ 0x44C15C, 0x44C16B
function @ 0x451128
  or:
    api: user32.GetKeyState @ 0x451130, 0x451151, 0x45115F
```

For example, one of the red flags I mentioned earlier was the fact that it logs keystrokes - but how does capa know this? With the built-in rules Fireeye had put in capa, it can quickly identify and flag common Win32 API calls that threat actors love to use to further exfiltrate user data. In this instance, it found that a function at address `0x444928` was identified to be using the `MapVirtualKey` method from the user32 API. Additionally, several references to `GetKeyState` were found as well. So what are these calls?

> **MapVirtualKeyA function**
>
> An application can use MapVirtualKey to translate scan codes to the virtual-key code constants VK_SHIFT, VK_CONTROL, and VK_MENU, and vice versa. These translations do not distinguish between the left and right instances of the SHIFT, CTRL, or ALT keys.
>
> \- [Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapvirtualkeya)

^

> **GetKeyState function**
>
> The key status returned from this function changes as a thread reads key messages from its message queue. The status does not reflect the interrupt-level state associated with the hardware. Use the GetAsyncKeyState function to retrieve that information.
>
> An application calls GetKeyState in response to a keyboard-input message. This function retrieves the state of the key when the input message was generated.
>
> \- [Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getkeystate)

While the appearance of these functions do not necessarily mean that the host executable is malicious, it is when combined with other red flags that a bigger picture emerge. Let's take a closer look at the referenced addresses, starting with `user32.MapVirtualKey @ 0x444947`. By going to the function address in Ghidra/IDA/other disassemblers, we can indeed see a reference to the `MapVirtualKeyA` function.

![Image](/assets/images/posts/capa/7de1b8783895d2a3cf2e968b3b3524b64d5f732b359ffa043ba7cf22c715591b.png)

What stands out even more about the tool is that it even includes the corresponding [ATT&CK Matrix](https://attack.mitre.org/) for each item and example of where this type of attack method can be found in known samples.

![Image](/assets/images/posts/capa/d39a414d10b8d867489ff458a44546945c172beb41499d79a3093c97a3c0b27b.png)

## Comparisons Against Existing Tools

### pestudio

But does this bring anything new to the table? Let's compare this to my favorite static analysis tool, [pestudio](https://www.winitor.com/).

For those uninitiated, pestudio is a tool that allows malware researchers to quickly examine the PE information of an executable. It analyzes the imports, strings, resources, libraries, etc. referenced within the file and submits the file to VirusTotal (if enabled). After analyzing, everything is scored and highlights any potentially questionable references.

![Image](/assets/images/posts/capa/3a053ff3a736488fee68df402792fc331ebf515dc516ff8833d6437cddedd1b8.png)

So how does it stack up against `capa`? While pestudio also highlights most of the questionable imports or Win32 API calls, it was only able to show the relative offset of the **string** - it failed to find the call in the imports category. It also failed to highlight the corresponding ATT&CK technique - even though it did group the string into `keyboard-and-mouse`.

![Image](/assets/images/posts/capa/330b0105aa6e3e20fa54a46c8c2505053df14bed9fdf20f136c826315c715382.png)

### CAPE Sandbox

Now before you scream about how unfair this comparison may seem, I'd like to remind you that CAPE *does* offer static analysis outside of a hybrid one.

![Image](/assets/images/posts/capa/9fddf82a3662bfbcf5c208c3858ad9c2b19a0165d90ebc03075db29dcf281b23.png)

The following items were what CAPE was able to find during the static analysis,

- PE Information
  - Expected vs. actual checksum
  - Compile time
  - Icon
- Sections
- Resources
- Imports
  - Address
  - API name
    - With direct link to Microsoft Docs!

So given that CAPE was able to get us all the imports and their relevant addresses, doesn't this make `capa` useless? No! Far from it! The fact that `capa` was able to provide us with additional insights such as the relevant ATT&CK techniques and specific characteristics of the API calls is enough to help a researcher.

## Conclusion

As always, there is *never* a perfect tool when it comes to malware analysis, as threat actors will always find ways to evade detections. The fact that there is now an additional tool that can aid blue team/malware researchers is awesome in itself. I can see myself using this tool a lot in the future. In fact, I'd probably use CAPE, capa and pestudio in conjunction in the future when performing an initial malware assessment.

### Suggestions

While the tool is very helpful and adds additional arsenals to blue teams and malware researchers around the world, there are still a few things I'd like to see implemented in the future.

- Show more data relevant to the detection
  - For example, in the malware analyzed above, `capa` was able to detect that the file may attempt to query registry value. If `capa` was able to show the relevant registry key or entry next to the API call that would save researchers a lot of time (assuming it's a compile-time constant or something that can be calculated or obtained during analysis-time).
  - ![Image](/assets/images/posts/capa/279171fbeeefe68bcb39182002702d7ed1a15623505b7aa48a8c10a07cd8badc.png)
- Improve background contrast
  - When using the tool in the default PowerShell window, the foreground color of the text was barely readable.
  - ![Image](/assets/images/posts/capa/ae4ef5ebf9e603f19416f29b66ba49c91fb25ab60c678070f9dbb21ba523b439.png)

