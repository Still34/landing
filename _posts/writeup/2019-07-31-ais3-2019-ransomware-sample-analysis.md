---
title:  "AIS3 2019 Ransomware Sample Analysis"
date:   2019-07-31 12:00:00 +0800
categories: writeup
header:
  overlay_color: "#000"
  overlay_filter: "0.75"
  overlay_image: https://i.imgur.com/EJ6sNer.png
toc: true
excerpt: "A quick analysis of the malicious executable used during the AIS3 2019 summer school course."
---

## Dynamic analysis
Dynamic analysis is used here first because it is already actively running on victim's machine, so we might as well start from there.
 
### Discovering malicious executable
- Launch Process Hacker on the victim VM; an anomaly named `5D85C2C17D.exe` can be found in the process list.
- The process is launched with the system, suggesting a daemon service or autorun registry is keeping the process persistent.
  - WhatsInStartup confirms our suspicion
  - ![](https://i.imgur.com/EJ6sNer.png)
- The process clearly has a name with a description of `Microsoft Windows Auto Update`, yet it does not behave like any default Windows applications bundled by Microsoft.
  - The process is not signed by Microsoft, further confirming the previous suspicion.
  - A signed process should contain a signed signature similar to the following,
  ```
      CN = Microsoft Windows Production PCA 2011
      O = Microsoft Corporation
      L = Redmond
      S = Washington
      C = US
  ```
  - ![](https://i.imgur.com/9fS3ZYX.png)
      
### Determining the type of executable
- From Process Hacker's automatic executable categorization, we can see that this process is a .NET assembly.
  - ![](https://i.imgur.com/JN972gg.png)
- [trid](http://mark0.net/soft-trid-e.html) (similar to `file` on Linux) further affirms the type of application.
  - ![](https://i.imgur.com/2VqblIb.png)

### Behavior analysis
- The file is seen constantly probing the victim's storage system.
  - ![](https://i.imgur.com/U4PemZJ.png)
- Common .NET assemblies can be found in the thread stack.
  - ![](https://i.imgur.com/SIeCTNl.png)

## Static analysis

### Deobfuscation

Since we know that the malicious executable is a .NET program, the program could typically be easily reversed via ildasm or any third-party decompilers (e.g. RedGate Reflector, JetBrains dotPeek, dnSpy, etc.).

Unfortunately for us, upon opening the file, we discover that the file had been heavily obfuscated by Confuser.
- ![ConfusedBy attribute](https://i.imgur.com/00OKdnq.png)
- ![Garbage code spat out by decompilers](https://i.imgur.com/3NfcjOp.png)

Fortunately for us, Confuser is a known obfuscation application, and is supported by the [de4dot](https://github.com/0xd4d/de4dot) deobfuscator.

```powershell=
./de4dot 5D85C2C17D.exe
```

The application will pick up the pattern created by Confuser and begin deobfuscation. 

### Analysis via pestudio

[pestudio](https://winitor.com/) is a tool that is designed to gather quick information about a malware. It will gather information such as the target application's manifest, certificate, file header, imported libraries, string table, and more.

#### Hashes

| Hash type | Value |
|---|---|
|md5|F472B4AE02E5956F4F25CCFD6ECFDA4B|
|sha1|F11665C8721466F78A96C106B08F17FC29A12F6C|
|sha256|BFDF5E72651B4EC588BD5FC6A9F17E9E0972248146BBACC10478F48D72F29B81|

#### File header

|  Property | Value  |
|---|---|
| signature|0x50450000|
| machine|Intel|
| sections|3|
| compiler-stamp|0x52DCF9B5 (Mon Jan 20 18:25:57 2014)|
| pointer-symbol-table|0x00000000|
| number-of-symbols|0|
| size-of-optional-header|224 (bytes)|
| processor-32bit|true|
| relocation-stripped|false|
| large-address-aware|false|
| uniprocessor|false|
| system-image|false|
| dynamic-link-library|false|
| executable|true|
| debug-stripped|false|
| media-run-from-swap|false|
| network-run-from-swap|false|

#### Indicators

pestudio lists out some of the indicators that it finds concerning/interesting for us. Here are some of them that seem to fit this application and may aid us in the analysis.

| Indicator  | Severity  |
|---|---|
|The file seems to be a fake Microsoft executable|1|
|The file references (69) file extensions like a Ransomware (or a Wiper)|1|
|The file expects Administrative permission|2|
|The original file name is "Microsoft Windows Auto Update.exe"|3|
|The file signature is 'Microsoft Visual C# v7.0 / Basic .NET'|5|
|The file references (20) blacklisted string(s)|5|
|The file does not contain a digital Certificate|7|
|The file is managed by .NET|9|

As we can see, pestudio already picked up some traits that a typical ransomware would exhibit, such as the fact that an extensive list of extension names can be found in the executable.

#### String table

Upon opening the deobfuscated application, we can already see major red flags in the string table.
- ![](https://i.imgur.com/wc5LbyY.png)

Some of these strings indicate that we are dealing with a ransomware:
- `Payments are processed manually, therefore, the expectation of activation may take up to 48 hours.`
- `This software will be deleted after files decryption, make sure that all important files are decrypted! If software crashes during decryption process, don't panic it will auto restart and your files will be decrypted without making addidional payment, just click Next>>. After all, software will auto remove itself from  your computer!`
- `Make sure that all important files have been decrypted! If part of the files had not been decrypted - move them to the desktop and click <<Retry>> button.  Otherwise, press <<Cancel>> button - this will delete the software from this computer. Please restart your computer to completely destroy this software!`

Without doing any of the code analysis, we can already find several questionable methods used by the malware thanks to pestudio's automatic flagging:
- ![](https://i.imgur.com/dV5blkm.png)

### Analysis via Decompilation

As mentioned before, we could use any .NET reflector to decompile the .NET application to see what the file does now. For this example, we'll opt to use [dnSpy](https://github.com/0xd4d/dnSpy), an open-source debugger and .NET assembly editor. Other decompilers can be used if you are interested in further analysis (RedGate Reflector will drill down to lower-level implementation detail and compiler generated code; JetBrain dotPeek is somewhere in-between).