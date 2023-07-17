---
title: How I Extracted an Unreal Engine Game's WWise Audio
excerpt: 'When you *really* want a game''s soundtrack, but the publisher hasn''t released them yet.'
category: infosec
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: /assets/images/posts/unreal-pak/2e2ec2f135afbc4f395cfc393791eb6c16480530d49a2b26fdd6c5a7c100a6b9.png
lastmod: 2021-03-01T15:25:35.048Z
toc: true
---

**⚠ Disclaimer** The following post has the game's name, ID, and encryption key redacted.
{: .notice--info}

I've been playing a game that I love, and the best part of it is its wicked soundtrack. Buuuut, the publisher hasn't released the official soundtrack for it, and I just couldn't wait for its release. Since I knew the game *has to* load in its asset from somewhere, I figured time to crack it wide open then!

## Obtaining the Game Files

I was stumped at this part for a while, as there doesn't appear to be any official documentation on how Windows Apps' filesystem security is handled. I first tried to obtain the files by running a PowerShell session as `NT AUTHORITY/SYSTEM`. After all, SYSTEM *should* have absolute control over the filesystem, right?

![Image](/assets/images/posts/unreal-pak/4ecdb5cf688db0c710f5bf85a853e06470bf3871471d77a5a5b1a7e08f337c9d.png)

Well, er, no?

Despite `icacls` reporting that `NT AUTHORITY/SYSTEM` *should* in theory have access to the directory, I just could not get PowerShell to read anything from there - even after I enabled every security token imaginable.

```
PS C:\Program Files\WindowsApps\[REDACTED]> icacls .
. BUILTIN\Users:(OI)(CI)(Rc,S,RD,REA,X,RA)
  S-1-15-3-247021172-3446442793-3455440376-3877820015-2750965022-664881756-722356460:(OI)(CI)(RX)
  BUILTIN\Users:(OI)(CI)(R)
  NT SERVICE\TrustedInstaller:(I)(F)
  NT SERVICE\TrustedInstaller:(I)(OI)(CI)(IO)(F)
  S-1-15-3-1024-3635283841-2530182609-996808640-1887759898-3848208603-3313616867-983405619-2501854204:(I)(RX)
  S-1-15-3-1024-3635283841-2530182609-996808640-1887759898-3848208603-3313616867-983405619-2501854204:(I)(OI)(CI)(IO)(GR,GE)
  NT AUTHORITY\SYSTEM:(I)(F)
  NT AUTHORITY\SYSTEM:(I)(OI)(CI)(IO)(F)
  BUILTIN\Administrators:(I)(CI)(RX)
  NT AUTHORITY\LOCAL SERVICE:(I)(OI)(CI)(RX)
  NT AUTHORITY\NETWORK SERVICE:(I)(OI)(CI)(RX)
  NT AUTHORITY\RESTRICTED:(I)(OI)(CI)(RX)
  S-1-19-512-4096:(OI)(CI)(RX,D,WDAC,WO,WA)
```

Ah well, time for plan B.

After some research, I found out that [UWPDumper](https://github.com/Wunkolo/UWPDumper.git) does the job perfectly. Looking at the source code, it looks like the application injects itself into the UWP process, sets its access control as `S-1-15-2-1` (ALL_APP_PACKAGES) and creates a remote thread that handles the file read write. Well, at least in the future I'd know what to do now. Anyways, I used the existing binary from the repo and got the files I was looking for.

![Image](/assets/images/posts/unreal-pak/690e643c0e37ab84fec6dddb23bb945511f671fda21ecc18846019fc45295368.png)

## Dumping the Internal Files

Since the majority of the dump came from this `XXXXXX-WinGDK.pak` file, I'd have to assume most of the assets came from this file. The handle view in Process Hacker confirms this, where no other visible files are loaded except for this file, the executable itself, and its dependencies.

![Image](/assets/images/posts/unreal-pak/d90f12ff934b416e3b06ecec6484b7af2a2a942e10e429c52b3590bff5bcfb3b.png)

After some [additional](https://gbatemp.net/threads/how-to-unpack-and-repack-unreal-engine-4-files.531784/) [reading](https://github.com/allcoolthingsatoneplace/UnrealPakTool), I had concluded that this is gonna be more than just a one-click-and-it's-done type of job.

In order to dump the PAK, I had to first determine the version of the Unreal Engine used to build the game. Why? Because apparently Unreal is *really* sensitive to version changes. Any new version increment (excluding patch increment, fortunately) will cause issues. Heck, even different version of `uassets` can cause the engine to not load the asset.

Thankfully, by checking the properties of the game binary, the engine had compiled its version name in there, which is `4.25.0`.

![Image](/assets/images/posts/unreal-pak/ab1411e953c2902b415b3a720ff33c7e7da970c386fe2b1e2ed0414234b9d15c.png)

Next up, let's try dumping the game using UnrealPak, an official utility that handles PAK-related operation. A copy of the [4.25.x UnrealPak can be found on GitHub.](https://github.com/allcoolthingsatoneplace/UnrealPakTool) Let's give it a go!

```
❯ ./unrealpak.exe
LogPaths: Warning: No paths for game localization data were specifed in the game configuration.
LogPakFile: Display: Using command line for crypto configuration
LogPakFile: Error: No pak file name specified. Usage:
LogPakFile: Error:   UnrealPak <PakFilename> -Test
LogPakFile: Error:   UnrealPak <PakFilename> -List [-ExcludeDeleted]
LogPakFile: Error:   UnrealPak <PakFilename> <GameUProjectName> <GameFolderName> -ExportDependencies=<OutputFileBase> -NoAssetRegistryCache -ForceDependsGathering
LogPakFile: Error:   UnrealPak <PakFilename> -Extract <ExtractDir> [-Filter=<filename>]
LogPakFile: Error:   UnrealPak <PakFilename> -Create=<ResponseFile> [Options]
LogPakFile: Error:   UnrealPak <PakFilename> -Dest=<MountPoint>
LogPakFile: Error:   UnrealPak <PakFilename> -Repack [-Output=Path] [-ExcludeDeleted] [Options]
LogPakFile: Error:   UnrealPak <PakFilename1> <PakFilename2> -diff
LogPakFile: Error:   UnrealPak <PakFolder> -AuditFiles [-OnlyDeleted] [-CSV=<filename>] [-order=<OrderingFile>] [-SortByOrdering]
LogPakFile: Error:   UnrealPak <PakFilename> -WhatsAtOffset [offset1] [offset2] [offset3] [...]
LogPakFile: Error:   UnrealPak <PakFolder> -GeneratePIXMappingFile -OutputPath=<Path>
LogPakFile: Error:   Options:
LogPakFile: Error:     -blocksize=<BlockSize>
LogPakFile: Error:     -bitwindow=<BitWindow>
LogPakFile: Error:     -compress
LogPakFile: Error:     -encrypt
LogPakFile: Error:     -order=<OrderingFile>
LogPakFile: Error:     -diff (requires 2 filenames first)
LogPakFile: Error:     -enginedir (specify engine dir for when using ini encryption configs)
LogPakFile: Error:     -projectdir (specify project dir for when using ini encryption configs)
LogPakFile: Error:     -encryptionini (specify ini base name to gather encryption settings from)
LogPakFile: Error:     -extracttomountpoint (Extract to mount point path of pak file)
LogPakFile: Error:     -encryptindex (encrypt the pak file index, making it unusable in unrealpak without supplying the key)
LogPakFile: Error:     -compressionformat[s]=<Format[,format2,...]> (set the format(s) to compress with, falling back on failures)
LogPakFile: Error:     -encryptionkeyoverrideguid (override the encryption key guid used for encrypting data in this pak file)
LogPakFile: Error:     -sign (generate a signature (.sig) file alongside the pak)
LogPakFile: Error:     -fallbackOrderForNonUassetFiles (if order is not specified for ubulk/uexp files, figure out implicit order based on the uasset order. Generally applies only to the cooker order)
LogPakFile: Display: Unreal pak executed in 0.017149 seconds
```

Alright, let's try `-Test` to get a quick start.

```
❯ .\UnrealPak.exe -test .\[REDACTED]-WinGDK.pak
LogPaths: Warning: No paths for game localization data were specified in the game configuration.
LogPakFile: Display: Using command line for crypto configuration
LogWindows: Error: === Critical error: ===
LogWindows: Error:
LogWindows: Error: Fatal error: [File:C:/Users/spark/Desktop/UnrealEngine/Engine/Source/Runtime/PakFile/Private/IPlatformFilePak.cpp] [Line: 273]
LogWindows: Error: Failed to find requested encryption key 00000000000000000000000000000000
LogWindows: Error: [Callstack] 0x00007ffc63238ef6 UnrealPak-PakFile.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffc63231d52 UnrealPak-PakFile.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffc6323dbe8 UnrealPak-PakFile.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffc6323b44f UnrealPak-PakFile.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffc632286d7 UnrealPak-PakFile.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffc630db1a6 UnrealPak-PakFileUtilities.dll!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ff6df52a507 UnrealPak.exe!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ff6df52b278 UnrealPak.exe!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffca85c7034 KERNEL32.DLL!UnknownFunction []
LogWindows: Error: [Callstack] 0x00007ffca9f7d0d1 ntdll.dll!UnknownFunction []
LogWindows: Error:
LogWindows: Error:
LogWindows: Error:
LogWindows: Error:
```

Well darn. It looks like the files are encrypted. [After doing some reading](https://blog.jamie.holdings/2019/03/23/reverse-engineering-aes-keys-from-unreal-engine-4-projects/), it appears Unreal's PAK format are typically encrypted using AES with a SHA-1 key. 

## Decrypting the PAK

Ah yes, debugging time! Thankfully, Unreal Engine is now open-source, meaning I should be able to follow the source code to follow the code and find the decryption routine.

![Image](/assets/images/posts/unreal-pak/fc36c40c3c2bf3bd897951a40c4a68021e01b8bdb4a54c5e2d82d420deb853e2.png)

Let's first find the decryption routine in the 4.25 Unreal source code. We can do that by simply looking up the word `decrypt` in the repo.

<figure class="half">
![Image](/assets/images/posts/unreal-pak/4c349e2126dda6a0297f0e6f11c2b72b6fb8c44f68bbdf17f558bc234d851584.png)
![Image](/assets/images/posts/unreal-pak/20a93629fb3afc6366a4b788cd5482b5e331ff68d853293a8e241e6c84ae782f.png)  
</figure>

That was easy enough. We can also see that the function is also referenced on L5043 - and there are strings surrounding it. Perfect, that should help us pinpoint where exactly the function is in memory. `GetPakEncryptionKey` sounds interesting. We should take a look there later. Let's fire up x64dbg. Since we already know what the surrounding strings are, we can just do a string search for literally any of them - in this case `Failed to find requested encryption key` - to quickly pinpoint the address of the function.

![Image](/assets/images/posts/unreal-pak/a806ab35da0a3332326e46fee23f4438f8f3bcb78466d7b3f4b596588871d6de.png)  

After we've found the address, we can set a breakpoint on its parent routine and watch it run.

<figure class="half">
![Image](/assets/images/posts/unreal-pak/c601b4f213170252d4a2c27ebe823ac6d4646247614968a94a3082a794b8a8f0.png)  
![Image](/assets/images/posts/unreal-pak/07f7f2380b31dddc8672b97f1081ac7ea526139195ece9aeeac926cad964c7c0.png)  
</figure>

"Huh, that's strange. I thought the function was quite small, and if this were `GetPakEncryptionKey`, what happened to the `DecryptData` method?" you may think. What more than likely happened here was compiler optimization. Instead of having to call more than one subroutine, the compiler will often try to find and merge routines together at compile-time to optimize the number of instructions required to carry out the task. 

At this point, it's just the matter of trial and error and seeing what each subroutine returns in their corresponding registers. When a subroutine returns, x64dbg will highlight the register(s) that has changed since the execution in red. 

![Image](/assets/images/posts/unreal-pak/e2587f3173f6d03314faf0fdf19f7d937bc4fcaf0c116dc77787e45935d8e9d8.png)  

By inspecting each register in dump, we can quickly find the AES key required to decrypt the data. In this case, the corresponding register for the decryption method containing the key was RCX. How did I know what was in the dump was in fact the key? We already knew based on previous documentations that the AES encryption key is a SHA-1 hash. There are 160 bits in a SHA-1 hash, which is the equivalent of 20 bytes. The output just so happens to contain a continuous 20-byte data.

![Image](/assets/images/posts/unreal-pak/d738f9312e190b1cb41a474f6609f20b9769e94049a58d99080cff0ffc1dac7f.png)  

Now that we have the SHA-1 AES key, we can now feed it to UnrealPak! UnrealPak takes a Base64'd AES key in its configuration file (typically `crypto.json`). All we need to do now is jot down the key, convert it to Base64, and bam, we can now run the decryption process! For the decryption process, I found that I needed to actually install the Unreal Editor itself for it to work, so I guess we didn't need to download that GitHub mirror after all.

```powershell
. "$env:programfiles\Epic Games\UE_4.25\Engine\Binaries\Win64\UnrealPak.exe" "$env:userprofile\Desktop\DUMP\<REDACTED>\Content\Paks\<REDACTED>-WinGDK.pak" -Extract "$env:userprofile\Desktop\DUMP_PAK" -CryptoKeys="Crypto.json"
```

```json
{
   "$types": {
      "UnrealBuildTool.EncryptionAndSigning+CryptoSettings, UnrealBuildTool, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null": "1",
      "UnrealBuildTool.EncryptionAndSigning+EncryptionKey, UnrealBuildTool, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null": "2",
      "UnrealBuildTool.EncryptionAndSigning+SigningKeyPair, UnrealBuildTool, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null": "3",
      "UnrealBuildTool.EncryptionAndSigning+SigningKey, UnrealBuildTool, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null": "4"
   },
   "$type": "1",
   "EncryptionKey": {
      "$type": "2",
      "Name": "null",
      "Guid": "null",
      "Key": "<REDACTED>"
   },
   "SigningKey": null,
   "bEnablePakSigning": true,
   "bEnablePakIndexEncryption": true,
   "bEnablePakIniEncryption": true,
   "bEnablePakUAssetEncryption": true,
   "bEnablePakFullAssetEncryption": false,
   "bDataCryptoRequired": true,
   "PakEncryptionRequired": true,
   "PakSigningRequired": true,
   "SecondaryEncryptionKeys": [

   ]
}
```

![Image](/assets/images/posts/unreal-pak/0979c7637c516f1bdd6ae87250c466dd642fdcd03667aa75ab0136c8ae807420.png)  

Nice! Now I can explore the game's content to my heart's content with things like `john-wick-parse` for deserializing `*.uasset` files, and `umodel` for viewing models!

## Dumping the Audio

For dumping and extracting the game's WWise audio bank, I had to use a tool called [`wwiseutil`](https://github.com/hpxro7/wwiseutil) to view and extract the game's `*.bnk` files.

![Image](/assets/images/posts/unreal-pak/26e2947cb1b4f248f4568fa101e6573b37dd4025f90d1d116abab7dbd9dbefdd.png)  

Then finally, I can use a foobar2000 extension called [vgmstream](https://www.foobar2000.org/components/view/foo_input_vgmstream) to listen to and transcode the audio from the WEM format to WAV.

![Image](/assets/images/posts/unreal-pak/2e2ec2f135afbc4f395cfc393791eb6c16480530d49a2b26fdd6c5a7c100a6b9.png)  


## Repackaging the Game

This part actually had me stumped for a day or two, since there weren't too many documentations out there that outline for Unreal Editor packs and cooks its PAK file. I had to find out the command-line parameters used by the Editor by viewing them in Process Hacker. Essentially, the Editor first compiles a list of files needed to be in the PAK to a text file in the format of `<path_to_file> <internal_path>`. For example,

```powershell
# ...
"C:/Users/Still/Desktop/DUMP_PAK/Engine/Content/Functions/Engine_MaterialFunctions02/HueShift.uasset" "../../../Engine/Content/Functions/Engine_MaterialFunctions02/HueShift.uasset"
"C:/Users/Still/Desktop/DUMP_PAK/Engine/Content/Functions/Engine_MaterialFunctions02/Lerp_Multiple_Float3.uasset" "../../../Engine/Content/Functions/Engine_MaterialFunctions02/Lerp_Multiple_Float3.uasset"
"C:/Users/Still/Desktop/DUMP_PAK/Engine/Content/Functions/Engine_MaterialFunctions02/SafeNormalize.uasset" "../../../Engine/Content/Functions/Engine_MaterialFunctions02/SafeNormalize.uasset"
# ...
```

Thankfully, I didn't really need to reconstruct one myself. During the previous extraction step, UnrealPak will already print out what files were extracted. Simply capture the output of the tool and replace irrelevant strings that do not conform to the above format and shift the strings around, and you'll be set! After then, run the UnrealPak tool with a `Create`, `Encrypt` and `CryptoKeys` parameter (formatted below).

```powershell
# capture the output to a file
.\UnrealPak.exe "$env:userprofile\Desktop\DUMP\REDACTED\Content\Paks\REDACTED-WinGDK.pak" -Extract "$env:userprofile\Desktop\DUMP_PAK" -CryptoKeys="Crypto.json" > output.log
# do the string replacement here yourself; I always did it by hand with regular expression in VSC.
# repackage the file based on our existing crypto key and file list then launch the game
cd "$env:programfiles\Epic Games\UE_4.25\Engine\Binaries\Win64\"; .\UnrealPak.exe $env:userprofile\Desktop\DUMP\REDACTED\Content\Paks\REDACTED-WinGDK.pak -Create="$env:userprofile\Downloads\UnrealPakTool\output.log" -Encrypt -cryptokeys="Crypto.json"; $env:userprofile\Desktop\DUMP\REDACTED\Binaries\WinGDK\REDACTED-WinGDK-Shipping.exe
```

Have fun modding the game with Shrek or something absolutely memey!

## Conclusion

In this post, we went through how Unreal uses a SHA-1 hash as its AES key to decrypt its content, and how we can dump the said content into its decrypted form. This was a fun exercise for me, as I was truly passionate about discovering more about this game and I wanted to see just how familiar I am with the x64dbg debugger now that I have a full-time job that requires me to work with debugger every day.

While I had fun decrypting and dumping the game and discovering previously uncertain information about the mechanics, there were a few things that disappointed me. First of all, I realized the game chose to opt for Wwise's proprietary compressed audio instead of the uncompressed format. The compression is the equivalent of 192kbps MP3 with a very noticeable 18KHz cut-off. That is what I call a yikes for a game that has its focus on audio. Second, the fact that the developers had unfortunately signed a Microsoft exclusivity contract meant that they had to roll out the game using the MSIX format - a format that I will make a rant on some time after the publication of this post.

![Image](/assets/images/posts/unreal-pak/5ec952c4701a6fced03c7973cc2a5aa87b4d7695ec8f382c4c40f9baa5fed2d7.png)

Ah well, that about wraps up this post, though! Thanks for reading and going through this journey with me!
