---
title: "IDA Trickeries #1: Using Saved Desktop Across IDAs"
excerpt: "So like... who at Hex-rays implemented this?"
category: ida-tips
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: /assets/images/posts/ida-1-desktop/json.png
---

Welcome to a new series I'm calling IDA Trickeries! In this series, I'll be looking at weird IDA quirks or not-so-well-known IDA tips that I've learned over the years.

Today's topic: desktop layouts - specifically, the weirdness you may encounter when you try to use saved layouts across different IDA architecture versions on Windows.

Let's start off with the basic. You can create and save one or more "desktops" in IDA by going to `Windows` -> `Save desktop...` and optionally set it as the default layout. When a desktop is saved as the default, the next time IDA opens a new binary, it'll automatically load up the desktop layout that you had previously saved. For example, I might put Strings View on my other monitor and IDA View on my main one.

![Image](/assets/images/posts/ida-1-desktop/2022-01-22_02-03-49-(ida)-.png)

Alright, that sounds great! But wait a second... Why does it not load up the same default desktop in the 64-bit IDA if I save the layout in the 32-bit IDA? It only loads up the default desktop!

![Image](/assets/images/posts/ida-1-desktop/2022-01-22_02-08-51-(ida)-.png)

So, it turns out, IDA saves quite a bit of information as a JSON when you save a desktop layout. These include the state of all the windows, opened views, how big each view is, is sync enabled, etc. The problematic part of this seems to be the windows state, as removing that part of the information magically allows IDA to load up the desktop layout properly. On Windows, you can find this information stored under `HKCU\Software\Hex-Rays\IDA\Desktops` (some of the other settings are stored here in the `IDA` sub-key as well).

![Image](/assets/images/posts/ida-1-desktop/2022-01-22_02-12-33-(regedit)-.png)

If you remove the `window_state` object and store the value back in, the default desktop will suddenly be loadable across different versions of IDA. Neat right? Not sure who at Hex-rays is responsible for this annoying quirk, though.

![Image](/assets/images/posts/ida-1-desktop/json.png)
