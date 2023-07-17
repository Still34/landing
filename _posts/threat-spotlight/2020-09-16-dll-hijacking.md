---
title: Threat Spotlight - DLL Hijacking (and .NET)
excerpt: How does Windows determine which DLL to load 🤔?
category: threat-spotlight
tags: [en-us, dotnet, guide]
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: /assets/images/posts/dll-hijacking/cd38de9e8b20864e3746acc9a30424b98389f3a7a0889ec02fccdfb3211a2698.png
toc: true
---

Welcome to a new series I'm calling Threat Spotlight! In this series, we will focus on common vulnerabilities or potential risk factors that developers or security researchers should consider when securing their systems.

In this article, we'll be focusing on the way Windows handles DLL loading, how threat actors may attack the search chain, and what developers can do to avoid such weakness.

## TL;DR

Make sure your environment has the entire orange section secured, and use `LoadLibraryEx` with [secure flags](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryexa#security-remarks) and use absolute path for the DLL if possible.

![Image](/assets/images/posts/dll-hijacking/dll-hijack.png)

## DLL Search Order

As always, to understand how Windows handles things, we need to look no further than the official documentation - [Dynamic-Link Library Search Order](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order). In the section "Search Order for Desktop Applications," the documentation notes the following.

> Desktop applications can control the location from which a DLL is loaded by specifying a full path, using DLL redirection, or by using a manifest. If none of these methods are used, the system searches for the DLL at load time as described in this section.
>
> Before the system searches for a DLL, it checks the following:
>
>
> - If a DLL with the same module name is already loaded in memory, the system uses the loaded DLL, no matter which directory it is in. The system does not search for the DLL.
> - If the DLL is on the list of known DLLs for the version of Windows on which the application is running, the system uses its copy of the known DLL (and the known DLL's dependent DLLs, if any). The system does not search for the DLL. For a list of known DLLs on the current system, see the following registry key: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs`.

So, what does that tell us? The paragraph tells us that before searching for a DLL, Windows will first check: a) if the library is already loaded in the memory, if so, use that, to avoid loading the same DLL in memory; b) if the DLL is in the `KnownDLLs` list under `HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs`.

![Image](/assets/images/posts/dll-hijacking/dll-hijack-pre-search.png)

This section is generally safe from threat actor, as these factors cannot be controlled by attackers under normal circumstances.

**⚠ Warning** By default, Windows uses what is known as the "Safe DLL Search Mode" to search for the requested library. This mode is controlled by the `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode` registry value. Because `SafeDLLSearchMode` is enabled by default, we will only cover the default behavior.
{: .notice--warning}

But what about after that? Once again, let's refer to the official documentation for clues.

> 1. The directory from which the application loaded.
> 2. The system directory. Use the `GetSystemDirectory` function to get the path of this directory.
> 3. The 16-bit system directory. There is no function that obtains the path of this directory, but it is searched.
> 4. The Windows directory. Use the `GetWindowsDirectory` function to get the path of this directory.
> 5. The current directory.
> 6. The directories that are listed in the PATH environment variable. Note that this does not include the per-application path specified by the App Paths registry key. The App Paths key is not used when computing the DLL search path.

Given the above steps, we can plot out what the search order is going to look like:

![Image](/assets/images/posts/dll-hijacking/dll-hijack.png)

## The Problem

See the problem? The parts marked in red can easily be manipulated by threat actors, especially if they have arbitrary write permissions. If the attacker could drop files into the application folder or into any of the environment path folders with weak permissions, they could easily cause havoc by replacing the intended DLL with a malicious one (with exceptions, see [The Solution](#the-solution)).

Consider the following C# code:

```cs
[DllImport("unknown.dll")]
public static extern void UnknownMethod();
static void Main(string[] args) => UnknownMethod();
```

And our `unknown.dll` C++ code:

```cpp
#include <iostream>
extern "C" __declspec(dllexport)
void UnknownMethod()
{
  std::cout << "Hello, World!" << std::endl;
}
```

When we run the application, it will attempt to look for `unknown.dll` in various directories based on the search order. In this instance, `unknown.dll` is planted at where the current working directory is (where `dotnet myapp.dll` is called). We can observe this behavior using [Process Monitor](https://docs.microsoft.com/en-us/sysinternals/downloads/procmon).

<figure>
  ![Image](/assets/images/posts/dll-hijacking/cd38de9e8b20864e3746acc9a30424b98389f3a7a0889ec02fccdfb3211a2698.png)
  ![Image](/assets/images/posts/dll-hijacking/b206464da7a1598bb0b1d0593909488192c36e57df91ec0aa0c6c09b144fbedd.png)
  <figcaption>
    The dotnet application successfully found the requested DLL at the current working directory.
    Our program executed as expected with "Hello, World!" printed.
  </figcaption>
</figure>

So let's say our threat actor has managed to gain access to the Windows or System directory and dropped in their malicious DLL, what would happen when we execute the application again?

<figure>
  ![Image](/assets/images/posts/dll-hijacking/9f106adc2832cff974a4bfb0b7031e8a52b7bf3048cdec08333769a4b6659bcb.png)
  ![Image](/assets/images/posts/dll-hijacking/fab77737c6b3ede70cf936a773a2c1a4891ee70e8891e37d327178acb2e54da4.png)
  <figcaption>
    Suddenly, our program stopped executing with the expected behavior!
  </figcaption>
</figure>

Now, this is a very unlikely scenario as the threat actor would first have to elevate their user account with one that has Administrator ACL permissions in order to perform a file write into a protected directory.

Here's a more likely scenario - what if we were to delete the DLL from the application folder and find a weak ACL controlled directory that is present within our `%PATH%`? Fortunately for us (and me), [PrivescCheck](https://github.com/itm4n/PrivescCheck) can help us find PATH directories with weak permissions.

![Image](/assets/images/posts/dll-hijacking/d5675e55e1f7c0f327214d5d828ad1938ca9b8d145db65012f3136bc2c860ceb.png)

With `Invoke-DllHijackingCheck`, we are able to quickly find folders that anyone under `NT AUTHORITY\Authenticated Users` can write to. Let's try moving our malicious DLL there.

<figure>
  ![Image](/assets/images/posts/dll-hijacking/f5c1ce936ff73e71ad2ddd9eb0f8afc8165342ae52a4d46c699fa72749ea92ab.png)
  ![Image](/assets/images/posts/dll-hijacking/fab77737c6b3ede70cf936a773a2c1a4891ee70e8891e37d327178acb2e54da4.png)
  <figcaption>
    Success! We managed to successfully hijack the unknown.dll.
  </figcaption>
</figure>

DLL hijacking could also be used to target Windows services - though very few of them, if at all, are still vulnerable in one way or another. With PrivescCheck, we can find potentially vulnerable services by invoking `Invoke-HijackableDllsCheck`. It will list out the services that has hijackable DLLs, what user account will the process be run as when the hijack is complete, and whether or not a reboot is required for the hijack to work. 

```powershell
PS C:\Users\Still> Invoke-HijackableDllsCheck

Name               Description                                       RunAs                     RebootRequired
----               -----------                                       -----                     --------------
cdpsgshims.dll     Loaded by CDPSvc upon service startup             NT AUTHORITY\LocalService           True
WptsExtensions.dll Loaded by the Task Scheduler upon service startup LocalSystem                         True
```

For more details and hands on practices of DLL hijacking, I recommend itm4n's excellent article regarding DLL hijacking, which can be found in the [Additional Resources](#additional-resources) section.

## The Solution

### .NET

~~You may have noticed my peculiar language/runtime choice for testing DLL hijacking. There is a reason that I chose dotnet over C/C++ here. Here's the problem - **there is not a single good solution to avoid DLL hijacking when working with dotnet.** At least, not that I can tell. The only method that I can tell is by invoking the `LoadLibrary` call directly, as opposed to calling the DLL exports. With `LoadLibraryEx`, DLL hijacking can be alleviated to some degree (see below).~~

~~If you do know a good method of preventing dotnet DLL hijacking, please do let me know in the comments.~~

For .NET Core 3.0 and above (inc. .NET 5), [the use of `System.Runtime.InteropServices.NativeLibrary` class](https://docs.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.nativelibrary?view=netcore-3.1) is preferred. So, in our case, we can rewrite the application like this to specify that we only want to search within the assembly directory:

```cs
public delegate void UnknownMethod();
static void Main(string[] args)
{
    if (NativeLibrary.TryLoad("unknown.dll", typeof(Program).Assembly, DllImportSearchPath.AssemblyDirectory, out var entryPointer))
    {
        if (NativeLibrary.TryGetExport(entryPointer, "UnknownMethod", out var methodPointer))
        {
            var MyUnknownMethod = Marshal.GetDelegateForFunctionPointer<UnknownMethod>(methodPointer);
            MyUnknownMethod();
        }
    }
    else
    {
        Console.WriteLine("Failed to locate the DLL within the application directory.");
    }
}
```

No more exceptions when dealing with `extern` with missing DLL or fumbling with DLL search order!

### Win32 `LoadLibraryEx`

In Windows 8 or above (or Windows 7 or below with KB2533623 installed), the `LoadLibraryEx` function has a number of new flags that are created specifically to address this issue. 

The new flags are `LOAD_LIBRARY_SEARCH_APPLICATION_DIR`, `LOAD_LIBRARY_SEARCH_SYSTEM32`, `LOAD_LIBRARY_SEARCH_USER_DIRS` and more. Additionally, there are flags such as `LOAD_LIBRARY_REQUIRE_SIGNED_TARGET`, `LOAD_LIBRARY_SAFE_CURRENT_DIRS` to better ensure the integrity of the library before it is loaded. I'm not going to delve into what each flag does here, as they are best explained in the [LoadLibraryExA function (libloaderapi.h)](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryexa) documentation.

## Additional Resources

The following are excellent articles that provide better insights into this type of attack and remedy,

- [Preventing DLL hijacking vulnerability does not working in C#](https://stackoverflow.com/questions/45272417/preventing-dll-hijacking-vulnerability-does-not-working-in-c-sharp)
- [Windows DLL Hijacking (Hopefully) Clarified](https://itm4n.github.io/windows-dll-hijacking-clarified/) by itm4n
- [Dynamic-Link Library Search Order - Win32 apps](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order#search-order-for-desktop-applications)
- [Dynamic-Link Library Security - Win32 apps](https://docs.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-security)
- [Triaging a DLL planting vulnerability - Microsoft Security Response Center](https://msrc-blog.microsoft.com/2018/04/04/triaging-a-dll-planting-vulnerability/)
- [Windows 10 - Task Scheduler service - Privilege Escalation/Persistence through DLL planting](https://remoteawesomethoughts.blogspot.com/2019/05/windows-10-task-schedulerservice.html)
