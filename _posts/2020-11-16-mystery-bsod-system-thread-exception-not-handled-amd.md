---
title: The Mysterious SYSTEM_THREAD_EXCEPTION_NOT_HANDLED and Hyper-V
excerpt: AMD PSS + Hyper-V = F
category: misc
---

## TL;DR

If the BSoD happened after enabling Hyper-V-related features, *and* if you are on an AMD platform, disable AMD PSS in the BIOS.

Disabling Memory Integrity supposedly works too, but **NOT RECOMMENDED** for security reasons.
{: .notice--warning}

## The Story

My weekend could have been a lot smoother this week. Here's the story: I've been using Hyper-V ever since WSL 2 was first introduced to the Windows 10 preview builds. Since running a hypervisor (VMware layer) inside another hypervisor (Hyper-V layer) is not exactly ideal performance-wise, I figured I might as well give Hyper-V a try.

![Image](/assets/images/posts/e722c7e01dd42b7e3b8729e2b56697c334c3f6281a07ab9997b35696410af0e5.png)  

Fast forward to yesterday. I was setting up a Windows 7 Hyper-V instance for my malware lab at home. During the setup, I figured I'd add my on-board Wi-Fi module as an External VM Hyper-V Switch.

...annnnd I couldn't. I keep running into this mysterious `Element not found` and `Folder already exists` error. Looking it up, I had tried everything from `netcfg -d` to reinstalling the network driver - nothing worked. Great.

![Image](/assets/images/posts/3bb00caa35e52b5f699c90910bdabd07bd3fc0d1cde0ee72431603d0407bd42a.png)  

As a last resort, I tried the nuke approach: re-install the Hyper-V feature on my Windows 10 20H2 (19042.630) installation by disabling and re-enabling the Hyper-V and its related Windows features (i.e., `Hyper-V`, `Virtual Machine Platform`, `Windows Hypervisor Platform`, `Windows Subsystem for Linux`, `Microsoft Defender Application Guard`). And that was where my trouble got even worse.

After re-enabling the features, my Windows couldn't even reach the Windows loading screen without this pesky `SYSTEM_THREAD_EXCEPTION_NOT_HANDLED` BSoD.

![Image](/assets/images/posts/3f4359142bf87d749b0a5cf2b756e3be7afd66699d7cdf9bce12702f807d7e74.png)  

At this point I was like, "Welp, I guess my system is just cursed." I didn't even bother troubleshooting beyond the basic "let's enter safe mode and see if that works" and "let's see what the Internet has to say" steps. Since I already have regular backups (*you should too*), reinstalling Windows really wasn't that big of a deal to me; might as well just do it then.

![Image](/assets/images/posts/aca24a4af39768458fd3034667ae0f451975142b5c7e0e3dbdd13ba4f181a193.jpg)  

After reinstalling Windows 20H2 (*after like an hour or two of getting the latest Windows ISO, thanks Microsoft for throttling the traffic*) and getting my most essential programs set up, I went ahead and enabled Hyper-V features again.

![Image](/assets/images/posts/37488bb1b84a7ff265ea968c2a1d64a6af25623a3c00c2ebd3dad9c0ef7a9b02.png)  

...annnnd we're back to this blue screen crap.

Thankfully, a Microsoft employee on the PowerShell Discord that I visit regularly suggested that it was a known issue on some platforms, particularly, Lenovo laptops with biometric passthrough. Initially I didn't really buy into that suggestion, as it seemed like a niche Lenovo-related incident, but he did suggest turning off virtualization features in the BIOS to see if it would help. Disabling AMD SVM (the AMD equivalent of Intel VT-d) did allow me to boot back into Windows. Upon getting past the loading screen, Windows noticed the installed features aren't working as intended and rolled back the features.

That's great and all, but... I kinda need SVM if I want to use any software that utilize hardware virtualization at all! Since the person on Discord mentioned that it was "certain features" causing this BSoD, I decided to try to pinpoint the issue myself. I first tried disabling certain CPU features that I knew I wasn't using or explicitly required to be on, then I enabled Windows Features one by one, instead of enabling all at once. Everything booted. Okay cool.

Let's try re-enabling AMD PSS, one of the features I disabled. And ladies and gentlemen, that was it! This non-descriptive feature with a vaguely technical description was causing the issue. I can't imagine why ACPI-related features would lead to this bizarre issue, but more importantly - whoever in charge of writing the feature description over at ASUS needs to revise them. I have *no idea* what any of that meant without consulting AMD's tech specs.

![Image](/assets/images/posts/24fceb358766c2eaeecf139b8e69776dd3688d801ccb8b71802eab2823d6dfce.jpg)  

By the way, the Wi-Fi bridging VM switch thing? Still doesn't work after a reinstall. Thanks Microsoft. I swear, VMware seems more than reliable at this rate.
