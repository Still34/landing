---
title: Threat Spotlight - DLL Hijacking
excerpt: How does Windows determine which DLL to load 🤔?
category: threat-spotlight
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: 
toc: true
---

Welcome to a new series I'm calling Threat Spotlight! In this series, we will focus on common vulnerabilities or potential risk factors that developers or security researchers should consider when securing their systems.

In this article, we'll be focusing on the way Windows handles DLL loading, how threat actors may attack the search chain, and what developers can do to avoid such weakness.

## TL;DR

## DLL Search Order

### Pre-search

As always, to understand how Windows handles things, we need to look no further than the official documentation - [Dynamic-Link Library Search Order](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order). In the section "Search Order for Desktop Applications," the documentation notes the following.

> Desktop applications can control the location from which a DLL is loaded by specifying a full path, using DLL redirection, or by using a manifest. If none of these methods are used, the system searches for the DLL at load time as described in this section.
>
> Before the system searches for a DLL, it checks the following:
>
>
> - If a DLL with the same module name is already loaded in memory, the system uses the loaded DLL, no matter which directory it is in. The system does not search for the DLL.
> - If the DLL is on the list of known DLLs for the version of Windows on which the application is running, the system uses its copy of the known DLL (and the known DLL's dependent DLLs, if any). The system does not search for the DLL. For a list of known DLLs on the current system, see the following registry key: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs`.

So, what does that tell us? The paragraph tells us that before searching for a DLL, Windows will first check: a) if the library is already loaded in the memory, if so, use that, to avoid loading the same DLL in memory; b) if the DLL is in the `KnownDLLs` list under `HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs`.

{% picture figure "/assets/images/posts/dll-hijacking/dll-hijack-pre-search.png" %}

This section is generally safe from threat actor, as these factors cannot be controlled by attackers under normal circumstances.

### Begin Search

**⚠ Warning** By default, Windows uses what is known as the "Safe DLL Search Mode" to search for the requested library. This mode is controlled by the `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode` registry value. Because `SafeDLLSearchMode` is enabled by default, we will only cover the default behavior.
{: .notice--warning}

Once again, let's refer to the official documentation for clues.

> 1. The directory from which the application loaded.
> 2. The system directory. Use the `GetSystemDirectory` function to get the path of this directory.
> 3. The 16-bit system directory. There is no function that obtains the path of this directory, but it is searched.
> 4. The Windows directory. Use the `GetWindowsDirectory` function to get the path of this directory.
> 5. The current directory.
> 6. The directories that are listed in the PATH environment variable. Note that this does not include the per-application path specified by the App Paths registry key. The App Paths key is not used when computing the DLL search path.

{% picture figure "/assets/images/posts/dll-hijacking/dll-hijack.png" %}

Watch what happens in `procmon` when I execute the following C# code,

```cs
[DllImport("unknown.dll")]
public static extern void UnknownMethod();
static void Main(string[] args) => UnknownMethod();
```

{% picture "/assets/images/posts/dll-hijacking/2020.09.16_195838_Procmon64.png" %}


## The Problem

## The Solution
