---
title: rgbCTF 2020 Writeup - Part 1
categories: writeup
header:
  overlay_color: '#000'
  overlay_filter: '0.75'
  overlay_image: /assets/images/posts/rgbctf-2020-07-14/pt1/d3174f495bb9d3d5fbb39d6828adde84647973b2484bbf992b834311d9836477.webp
  actions:
    - label: Part 2
      url: /writeup/rgbctf-2020-part-2
toc: true
excerpt: 'Everything in 2020''s gotta have RGB, even CTFs!'
permalink: /writeup/rgbctf-2020-part-1
---

## Prologue

I was not planning on participating any CTF this week, but I figured I'd check the CTFTime schedule few days ago. That was when I saw a CTF named "rgbCTF" was coming up within a few days. I was like "screw it, let's go, why not?" My interest peaked when I saw that the first team gets free Chroma keyboards - even though I knew full well that I wasn't going to get top 5, and of course we didn't.

This time around I figured I'd hit up Emzi, a friend of mine on Discord - the same person that challenged me to [Capture the Nitro]({% post_url /writeup/2020-06-23-capture-the-nitro %}). This is his first CTF, and he solved quite a few challenges, which was amazing. He will be writing the Part 2 of the writeup. If some challenges seem to be missing in this post, please refer to Part 2 instead!

Interestingly, the rgbSec team seems to be using something called [mellivora](https://github.com/Nakiami/mellivora) instead of the usual CTFd, which appears to be much more stable and looks far more stylish. This might be an alternative solution to consider in the future when hosting a jeopardy-styled CTF.

![picture 11](/assets/images/posts/rgbctf-2020-07-14/pt1/6e44fb45319f4e7de8989870e3b08a96179852a54d215fe45b1a7f6e442ef5dd.webp)  

There were 7 major categories for this CTF, with the `ZTC` one being basically the `Misc` category made by the sponsors of this competition.

![picture 7](/assets/images/posts/rgbctf-2020-07-14/pt1/f1c86d6bff1bd6359a4ce0f75cd1956820ee8bb19ca07557a5b8c52df1353466.webp)  

Out of all of the challenges, I *loved* the PI series under the `Forensics` category. A lot of work was definitely put into making the challenge. Kudos to the author(s)! When I was solving PI1, a challenge involving reading the btsnoop log, it took me few hours to figure out the HID keycodes, and when I thought I had it with the number `0736727859`, I found out that that still wasn't the flag! Emzi solved it for me in Part 2 of the series - it turns out that I was so focused on the numbers, I didn't read any of the other text sent by the keyboard. I still learned a lot from this challenge though!

Towards the end we were able to secure 53rd place out of the 1345 teams - that's the top 4% of the scoreboard! While I wish that we could have climbed our way to top 50, we were just *close enough* to the target. Oh well, we'll get em' next time!

![picture 6](/assets/images/posts/rgbctf-2020-07-14/pt1/d3174f495bb9d3d5fbb39d6828adde84647973b2484bbf992b834311d9836477.webp)  

![picture 10](/assets/images/posts/rgbctf-2020-07-14/pt1/f35c08a7b4141d233b3c1c5c12a6155dcdd6512c143bf2598864fc91517e8a9d.webp)


## Beginner

### Joke Check! (50 pts)

> Challenge description
>
> `What do you call a chicken staring at lettuce?`

The provided string was `crmNEQ{l_nstnvpy_nlpdlc_dlwlo}`, which was obviously an ROT13 string. Just plop it into Cyberchef and rotate it a few times and bang.

![I hate this joke thanks](/assets/images/posts/rgbctf-2020-07-14/pt1/0bf583e7ca23aff579cc85e17be7831c6b407835cba9261fe7481940647858ff.webp)  

Flag: `rgbCTF{a_chicken_caesar_salad}`

### Shoob (50 pts)

> Challenge description
>
> `s h o o b`

![Shoob doggo](/assets/images/posts/rgbctf-2020-07-14/pt1/6e66ceec62e0cedb82df6c5aec3cf5cbb60196939a0678ddd17759d4977eb326.webp)  

At first I couldn't tell what was going on with this image. It's just a doggo with no helpful EXIF data according to `exiftool` and no embedded data according to `binwalk`. It wasn't until another while that I figured out that the image has a *very* faint string on the doggo.

![picture 14](/assets/images/posts/rgbctf-2020-07-14/pt1/5283972c951b04f4c61cadf6b4d0a5eb0f3dce28432ffcfc9215a9a5fd3a140a.webp)  

Flag: `rgbCTF{3zier_4haN_s4n1ty}`

### A Fine Day (50 pts)

> Challenge description
>
> ```plaintext
> It's a fine day to break some ciphers!
> Sujd jd bgxopksbm ljsu tg tqqjgb xjkubo. Tqqjgb xjkubod tob t qvor vq dhidsjshsjvg xjkubo. Jsd nbp xvgdjdsd vq slv ghribod, t tgm i. Sv bgxopks t cbssbo, rhcsjkcp jsd kctxb jg sub tckutibs (dv t=0, i=1, bsx.) ip t, tgm subg tmm i. Qjgtccp stnb suts rvm 26 tgm xvgwbos js itxn jgsv t xutotxsbo.
> Sub tqqjgb xjkubo jdg's obtccp suts dsovgf. Djgxb js'd rvm 26, subob tob vgcp t qbl uhgmobm mjqqbobgs nbpd, lujxu xtg ib btdjcp iohsb qvoxbm. Tgpltp, ubob'd pvho qctf: ofiXSQ{t_qjgb_tqqjgb_xjkubo}
> ```

Seems like a substitution cipher! Let's plop this into [Substitution Cipher Solver Tool](https://www.boxentriq.com/code-breaking/cryptogram) and let the tool do the job.

The top result was the following:

```plaintext
this is encrypted with an affine cipher affine ciphers are a form of substitution cipher its key consists of two numbers a and b to encrypt a letter multiply its place in the alphabet so a b etc by a and then add b finally take that mod and convert it back into a character the affine cipher isn t really that strong since it s mod there are only a few hundred different keys which can be easily brute forced anyway here s your flag rgbctf a fine affine cipher
```

Flag: `rgbCTF{a_fine_affine_cipher}`

### Simple RSA (50 pts)

> Challenge description
> 
> Can you find a way to attack this RSA implementation?
> 
> 📎 Attachments: `simple_rsa.txt`, `simple_rsa.py`

```powershell
❯ cat .\simple_rsa.txt
n = 5620911691885906751399467870749963159674169260381
e = 65537
c = 1415060907955076984980255543080831671725408472748
```

Why yes! This is simple RSA! In fact, it was so simple that I all had to do was to fire up the infamous [RsaCtfTool](https://github.com/Ganapati/RsaCtfTool) to solve it.

```powershell
❯ ./RsaCtfTool.py -n 5620911691885906751399467870749963159674169260381 -e 65537 --uncipher 1415060907955076984980255543080831671725408472748
private argument is not set, the private key will not be displayed, even if recovered.

[*] Testing key /tmp/tmpqjqs9llh.
[*] Performing londahl attack on /tmp/tmpqjqs9llh.
[*] Performing pollard_p_1 attack on /tmp/tmpqjqs9llh.
[*] Performing fermat attack on /tmp/tmpqjqs9llh.
[*] Performing factordb attack on /tmp/tmpqjqs9llh.

Results for /tmp/tmpqjqs9llh:

Unciphered data :
HEX : 0x00007d33637230665f33747572627b465443626772
INT (big endian) : 2792069716136470955248443562608151407320262514
INT (little endian) : 167201404043347807005542357307720988742653755326464
STR : b'\x00\x00}3cr0f_3turb{FTCbgr'
```

You might notice that the string seems a little weird; that's because as stated by the source, the string was encrypted with little-endian in mind.

Flag: `rgbCTF{brut3_f0rc3}`

### Quirky Resolution (50 pts)

> Challenge Description
>
> `":joy:"`

Once again, I couldn't tell what was wrong at first until I started messing with the image in an image editor.

![picture 15](/assets/images/posts/rgbctf-2020-07-14/pt1/31a00e4ccf8635675b2d65bde3dd51951e1764487eaef85636c97afae5b7cb2c.webp)  

Hey, look, it's a QR code!

![picture 43](/assets/images/posts/rgbctf-2020-07-14/pt1/6294d1d44516586a936ecd3f7ee82d15abb16aede4d39054d6c515e8777083f6.webp)  

```markdown
VfuflVAouacXoIOHsrNP
xgSDHLQSDBIO7fZ1w8zV
SUdwzyRJLKEHkqP2i0NK
h5fYSD1b3rymDWKkx9uw
fZELgZV2l0xllyyMADkw
voRu9GvHFy3qI7BK3yAL
EIUOvFKPbxcci6ExsXFv
G5YlE7Id9NELQ3NL5Kex
gaf6UQ77Q8aQkmjY6vzq
IF45ubpqdAZertRvfnER
XIj9b7ZGaep7Aspqvzhu
P6IhEFnLdlx0w5BSjo0A
L9ifDGyICNqaxNywIeAg
mxWg0h8XpHRN3Ai6P3aU
rgbCTF{th3_qu1rk!er_th3_b3tt3r}
VXPphIDrM0WagtZJYecY
PjXSHuJTAcLK9uUnGrCB
PW2MjAPE6KGe1iB8Hmqg
3WfKjbXOXXNVMj79F2UI
gzFHSU1HN9KAKhwPElOf
x9lL2wLHtee0KG90DFW9
OoO0YnJDU8Kfm7sFADjQ
XJ7FnxIARmTZ0WgGKeyS
AQEgDg8Sx1XBicDHfZ2i
OxvFwnTl9FKQTm1UikjK
aifFg3hc1gKLJWAjC5b4
q2SoVWnm95W2DNVGFtzf
cxaLH9lpesGwhehpv8YU
zO9W4DZM6uIlhCAyM1Hj
```

Flag: `rgbCTF{th3_qu1rk!er_th3_b3tt3r}`

## Cryptography

### I Love Rainbows (50 pts)

> Challenge description
>
> `Can you figure out why?`

Yes, I can. The challenge provided us with a list of hash intended for us to "crack," and judging by the title, it probably wanted us to use a rainbow table.

```markdown
4b43b0aee35624cd95b910189b3dc231
cd0aa9856147b6c5b4ff2b7dfee5da20aa38253099ef1b4a64aced233c9afe29
3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d
0d61f8370cad1d412f80b84d143e1257
63ee3b90f0bc64026eafa8cde95c5f410c847be841536b7240d778688cfed72a
6874f52cfc77bd71e9394fa143bedd8f30811e91b8e64ff8818323df42d4af31
cbd27e9b76c7ad85ae3f36cbe78e546d45327ed1a50787d9c3b989af27e62bf0
44ba660a6bd8ff6b11b3423f9f3bf0dff4550cc6eb7b2e8a09ed3d4694faeb83
5e07d6fdc602b0f9b99f6ea24c39e65835992faac400264c52449bc409cf4efa
7b774effe4a349c6dd82ad4f4f21d34c
c0828e0381730befd1f7a025057c74fb
c195aeabeeee007891190b9ff8a32c70
a87ff679a2f3e71d9181a67b7542122c
67d4143062b55c25f383c9fabbbf1422fad06a2fe0644b43da67c17886dd4bd4
b14a7b8059d9c055954c92674ce60032
50e721e49c013f00c62cf59f2163542a9d8df02464efeb615d31051b0fddc326
97fb5f8538b89f6c1accfd19836b65a73b61fbc2e0cbf84bb858a0fffa3f1592
1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9
24cafc74b88dfafb0524ecc85a76f8bd
3fffd018d2223020be85670d93f565b63df54a9ce3ed2cdf6347a61df016938c
2510c39011c5be704182423e3a695e91
582967534d0f909d196b97f9e6921342777aea87b46fa52df165389db1fb8ccf
cd0aa9856147b6c5b4ff2b7dfee5da20aa38253099ef1b4a64aced233c9afe29
d10b36aa74a59bcf4a88185837f658afaf3646eff2bb16c3928d0e9335e945d2
```

For those uninitiated, a hash is a one-way process. Hashing takes a stream of data, performs a series of calculations to obtain a unique stream of data that is *most of the time* unique to this object. It is important to distinguish the difference between hashing and encryption; hashing is *not* a form of encryption, and therefore cannot be "decrypted." However, one could in theory keep track of a string that may produce the same hash and keep a database of this key value pair - and that is the gist of a rainbow table. [CrackStation](https://crackstation.net/) is one of such site that keeps track of frequently seen strings and their respective hashes. Let's submit our hashes and see if there are matching results!

![picture 16](/assets/images/posts/rgbctf-2020-07-14/pt1/8c84b5247a12e74efe18a5400334354a1e1b03f5a519d55cae9a0f5fa2eeea75.webp)  

Annnd this looks promising! Let's submit all the hashes and get the flag.

Flag: `rgbCTF{4lw4ys_us3_s4lt_wh3n_h4shing}`

## Forensics/OSINT

### Alien Transmission 1 (219 pts)

> Challenge description
>
> `I was listening to my radio the other day and received this strange message... I think it came from an alien?`

<audio controls src="https://www.dropbox.com/s/qgsrr0rqcineslu/squeakymusic.wav?dl=1"></audio>

I thought this was some sort of weird signal that I had to decipher, but this seemed... awfully familiar. I had heard something similar before... Where?

{% include video id="91LB9ssE__k" provider="youtube" %}

...It's an SSTV signal isn't it? I thought this seemed familiar because I was around when Valve added their [Transmission Received ARG](https://half-life.fandom.com/wiki/Portal_ARG) back when Portal 2 was imminent. As described by Wikipedia,

> Slow Scan television (SSTV) is a picture transmission method used mainly by amateur radio operators, to transmit and receive static pictures via radio in monochrome or color.

The fact that this signal was used in space by NASA matches the challenge description as well,

> SSTV was used to transmit images of the far side of the Moon from Luna 3.

So let's try feeding this to an [SSTV decoder](https://play.google.com/store/apps/details?id=xdsopl.robot36).

![picture 17](/assets/images/posts/rgbctf-2020-07-14/pt1/c79244034a6e1709da1c475cd13b34b8be97b4bb4c79114ba8d860b1c1cba1ba.webp)  

And that was indeed it!

Flag: `rgbctf{s10w_2c4n_1s_7h3_W4V3}`

### Robin's Reddit Password (490 pts)

> Challenge description
>
> ```markdown
> I'm Batman!
> Lately Robin's been acting suspicious... I need to see what he's been up to. Can you get me his reddit password? Just don't try to break into reddit's server...
>
> Tip : Wrap the Password in flag format
> ```

This one took me soooooo long, and it wasn't even rewarding to get the answer. Therefore, this was my *least* favorite challenge out of the entire CTF. I spent hours trying to figure out what the heck this means.

After searching for various combinations of `reddit`, `password`, `robin` for what felt like an eternity, I found [this](https://news.ycombinator.com/item?id=15596253).

![picture 18](/assets/images/posts/rgbctf-2020-07-14/pt1/1bee4afdd88562f1668bb97dac7c94f2fedc08b7fd3e13943c3657910a57bb81.webp)  

Apparently, there's an obscure Easter egg on reddit's site for the infamous `/etc/passwd` file. If you go to www.reddit.com`/etc/passwd`, you'd see a fake `/etc/passwd` containing a list of users and their hashes. Thankfully, someone did the work for us and decoded the passwords for us as shown in the screenshot.

The main reason why I hated this challenge so much was a) this doesn't necessarily encourage or teach the audience what an forensics or OSINT user might do b) without any hints, this challenge became a huge guessing game, which makes the challenge *very* unenjoyable to solve. c) the fact that we were told to "find someone's password," most of us would instinctively think that we're supposed to look through places like password dumps. If you are a CTF challenge planner, please never do something like this.

Flag: `rgbCTF{bird}`

## Misc

### Hallo? (50 pts)

> Challenge description
>
> ```markdown
> The flag is exactly as decoded. No curly brackets.
> NOTE: keep the pound symbols as pound symbols!
> ```

<audio controls src="https://www.dropbox.com/s/gfmpdu4vb3vzo0e/hmm.mp3?dl=1"></audio>

For those of you who have recently called someone or texted someone (you have in the last few months, right?), this tone should be familiar.

Yup, it's a series of DTMF (Dual-Tone Multi-Frequency signaling) tones. A DTMF tone is most frequently heard over a landline telephone or dumb phone in the early 2000s. Whenever you dial someone, a combination of tones are generated to let the phone and the operator know what numbers were being punched.

> Dual-tone multi-frequency signaling (DTMF) is a telecommunication signaling system using the voice-frequency band over telephone lines between telephone equipment and other communications devices and switching centers. DTMF was first developed in the Bell System in the United States, and became known under the trademark Touch-Tone for use in push-button telephones supplied to telephone customers, starting in 1963. DTMF is standardized as ITU-T Recommendation Q.23. It is also known in the UK as MF4.
>
> \- [Wikipedia](https://en.wikipedia.org/wiki/Dual-tone_multi-frequency_signaling)

After knowing that it's a DTMF tone, we can plop the results into a [DTMF decoder](https://play.google.com/store/apps/details?id=com.audiocommunication) and see what we get.

The decoded result was `7774222228333#99933338#386333#866666337777#`, annnnd sent!

...wait, what do you mean this wasn't the flag? It turns out there *was* a reason that silences were included in the mp3 file.

![picture 29](/assets/images/posts/rgbctf-2020-07-14/pt1/577f6df57830a60b29d056ec812283e90bbd8bc28824c04a09016a966d68d295.webp)  

To those of us cool kids (not really) in the 2000s, T9 texting was the only reliable and most common texting input we had. What was T9 texting? Since there are more than a dozen characters in the English alphabet, the only way people could cram all those characters onto a T9 keypad was to assign multiple characters to a single key. Essentially, to enter a single character on a limited T9-style keypad, you had to press a key for multiple times to select the character you wanted to input. It was an *awful* time. I'm glad those days were over.

![picture 30](/assets/images/posts/rgbctf-2020-07-14/pt1/142bad672ba295a1193f98e9b19135a7c1b2539822b3abc11ea37180836129ea.webp)  

So after analyzing the text, we were able to get `rgbctf#yeet#dtmf#tones#`, and that was indeed the flag!

Flag: `rgbctf#yeet#dtmf#tones#`

### Penguins (295 pts)

> Challenge description
>
> *waddle waddle*

The attached file was called `2020-06-29-173949.zip`. Upon extracting the archive, it becomes obvious that the archive is just a zipped git repo.

```powershell
❯ ls


    Directory: C:\Users\Still\AppData\Local\Temp\git

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           7/15/2020  8:18 PM                .git
-a---           7/15/2020  8:18 PM             93 1yeet
-a---           7/15/2020  8:18 PM             34 2yeet
-a---           7/15/2020  8:18 PM             88 3penguin
-----           6/30/2020  5:13 AM             60 flag
```

Obviously, `flag` does not contain anything useful. Let's dive deeper into the directory.

```powershell
❯ cat flag
cmon now
u didnt think ACTUALLY think it would be that easy
```

```powershell
❯ ls -File -Recurse | %{$_; cat $_}
...
    Directory: C:\Users\Still\AppData\Local\Temp\git\.git\logs

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-----           6/30/2020  5:39 AM           2999 HEAD
0000000000000000000000000000000000000000 9dcf170a0fb6ae21b5299669b4336a6324c0c316 John Doe <John@doe.com> 1593464930 +0000      commit (initial): first commit
9dcf170a0fb6ae21b5299669b4336a6324c0c316 1117a337faf1ac693cf26bb3bcccb3caa0381d6d John Doe <John@doe.com> 1593464967 +0000      commit: birds are cool
1117a337faf1ac693cf26bb3bcccb3caa0381d6d 1117a337faf1ac693cf26bb3bcccb3caa0381d6d John Doe <John@doe.com> 1593464995 +0000      checkout: moving from master to feature1
1117a337faf1ac693cf26bb3bcccb3caa0381d6d 955eeb70bcb49d8de331b61f38219bccb7e8f933 John Doe <John@doe.com> 1593465063 +0000      commit: add content
955eeb70bcb49d8de331b61f38219bccb7e8f933 7d6997a74cfa2b5e266355d33fd73c76c9fe9b75 John Doe <John@doe.com> 1593465146 +0000      commit: cooler bird
7d6997a74cfa2b5e266355d33fd73c76c9fe9b75 1117a337faf1ac693cf26bb3bcccb3caa0381d6d John Doe <John@doe.com> 1593465153 +0000      checkout: moving from feature1 to master
1117a337faf1ac693cf26bb3bcccb3caa0381d6d 8ee62379b45217202e75011966b813512cafcbb0 John Doe <John@doe.com> 1593465185 +0000      commit: added an interesting file
8ee62379b45217202e75011966b813512cafcbb0 b474ae165218fec38ac9fb8d64f452c1270e68ea John Doe <John@doe.com> 1593465223 +0000      commit: some new info
b474ae165218fec38ac9fb8d64f452c1270e68ea 102b03d19f932fc5e76d460604804dd522d6850d John Doe <John@doe.com> 1593465324 +0000      commit: some more changes
102b03d19f932fc5e76d460604804dd522d6850d 27440c52e8a7a3d2e50f8fcdee0a88b0f937598d John Doe <John@doe.com> 1593465369 +0000      commit (merge): Merge branch 'feature1'
27440c52e8a7a3d2e50f8fcdee0a88b0f937598d b474ae165218fec38ac9fb8d64f452c1270e68ea John Doe <John@doe.com> 1593465694 +0000      checkout: moving from master to b474ae1
b474ae165218fec38ac9fb8d64f452c1270e68ea b474ae165218fec38ac9fb8d64f452c1270e68ea John Doe <John@doe.com> 1593465718 +0000      checkout: moving from b474ae165218fec38ac9fb8d64f452c1270e68ea to fascinating
b474ae165218fec38ac9fb8d64f452c1270e68ea d14fcbfd3c916a512ad1b956cd19fb7be16c20c6 John Doe <John@doe.com> 1593465745 +0000      commit: an irrelevant file
d14fcbfd3c916a512ad1b956cd19fb7be16c20c6 cfd97cd36fe6c5e450d5057bf25aa1d7ddeca9ef John Doe <John@doe.com> 1593465781 +0000      commit: add content to irrelevant file
cfd97cd36fe6c5e450d5057bf25aa1d7ddeca9ef 5dcac0eddbcb4bffdec552a1172f84762a0b4174 John Doe <John@doe.com> 1593465822 +0000      commit: another perhaps relevant file
5dcac0eddbcb4bffdec552a1172f84762a0b4174 fb70ca39a7437eaba2850703018e1cf9073789e6 John Doe <John@doe.com> 1593465988 +0000      commit: probably not relevant
fb70ca39a7437eaba2850703018e1cf9073789e6 57adae71c223a465b6db3a710aab825883286214 John Doe <John@doe.com> 1593466025 +0000      commit: relevant file
[ommitted]
57adae71c223a465b6db3a710aab825883286214 800bcb90123137a6ee981c93c140bd04c75f507f John Doe <John@doe.com> 1593466646 +0000      commit: some things are not needed
800bcb90123137a6ee981c93c140bd04c75f507f 27440c52e8a7a3d2e50f8fcdee0a88b0f937598d John Doe <John@doe.com> 1593466672 +0000      checkout: moving from fascinating to master
...
```

By reading all the files in the directory, we quickly found out HEAD contains some useful git log. Let's try checking out to these commits.

```powershell
❯ git checkout fb70ca39a7437eaba2850703018e1cf9073789e6
Note: switching to 'fb70ca39a7437eaba2850703018e1cf9073789e6'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at fb70ca3 probably not relevant
❯ ls


    Directory: C:\Users\Still\AppData\Local\Temp\git

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           7/15/2020  8:15 PM                .git
-a---           7/15/2020  8:15 PM              0 1yeet
-a---           7/15/2020  8:15 PM              0 2yeet
-a---           7/15/2020  8:15 PM              0 3parakeet
-----           6/30/2020  5:13 AM             60 flag
-a---           7/15/2020  8:15 PM             37 irrelevant_file
-a---           7/15/2020  8:15 PM             40 perhaps_relevant
-a---           7/15/2020  8:15 PM            150 perhaps_relevant_v2

❯ cat .\perhaps_relevant_v2
YXMgeW9kYSBvbmNlIHRvbGQgbWUgInJld2FyZCB5b3UgaSBtdXN0IgphbmQgdGhlbiBoZSBnYXZlIG1lIHRoaXMgLS0tLQpyZ2JjdGZ7ZDRuZ2wxbmdfYzBtbTE3c180cjNfdU5mMHI3dW40NzN9

❯ ConvertFrom-Base64 YXMgeW9kYSBvbmNlIHRvbGQgbWUgInJld2FyZCB5b3UgaSBtdXN0IgphbmQgdGhlbiBoZSBnYXZlIG1lIHRoaXMgLS0tLQpyZ2JjdGZ7ZDRuZ2wxbmdfYzBtbTE3c180cjNfdU5mMHI3dW40NzN9
as yoda once told me "reward you i must"
and then he gave me this ----
rgbctf{d4ngl1ng_c0mm17s_4r3_uNf0r7un473}
```

And there's the file we're looking for!

Flag: `rgbctf{d4ngl1ng_c0mm17s_4r3_uNf0r7un473}`

## Pwn/Reverse

### Too Slow (50 pts)

> Challenge description
>
> `I've made this flag decryptor! It's super secure, but it runs a little slow.`
>
> 📎 Attachment: `a.out`

```markdown
❯ file a.out
a.out: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=462dfe207acdfe1da2133cac6b69b45de5169ee2, for GNU/Linux 3.2.0, not stripped
```

So it looks like a standard Linux ELF executable. What happens if I run it?

```powershell
❯ ./a.out
Flag Decryptor v1.0
Generating key...
```

...and it hangs indefinitely. Yup, talk about slow. Looks like it's time to investigate using [Ghidra](https://ghidra-sre.org/)! Upon examining the `main` method's pseudo-code output, we see the following,

```c
undefined8 main(void)
{
  uint uVar1;
  puts("Flag Decryptor v1.0");
  puts("Generating key...");
  uVar1 = getKey();
  win((ulong)uVar1);
  return 0;
}
```

```c
ulong getKey(void)
{
  uint local_10;
  uint local_c;
  
  local_10 = 0;
  while (local_10 < 0x265d1d23) {
    local_c = local_10;
    while (local_c != 1) {
      if ((local_c & 1) == 0) {
        local_c = (int)local_c / 2;
      }
      else {
        local_c = local_c * 3 + 1;
      }
    }
    local_10 = local_10 + 1;
  }
  return (ulong)local_10;
}
```

If you take a closer look at `getKey`, you'll realize that it's doing some meaningless calculation inside a `for` loop until it loops `0x265d1d22` times, which is 643,636,515 times in decimal!

![ameowglare](https://cdn.discordapp.com/emojis/394885502895128576.gif?v=1)

Since all we care about is for `local_10` (or `i`) to reach the expected value, which is `0x265d1d22`, we can just patch the binary to make it start with that value. To do this in Ghidra, we'll select the instruction we want to patch and hit `CTRL`+`SHIFT`+`G` and modify the instruction accordingly.

![picture 37](/assets/images/posts/rgbctf-2020-07-14/pt1/544d7ede2543c4322bae0af1cce6ba7c5bf3a758fb1e39c25c3c7a72c16d337f.webp)  

![picture 38](/assets/images/posts/rgbctf-2020-07-14/pt1/8cde0b2446add385a770c5c4a5e39bbded5c0c37b42195805d9f1c7a653a4861.webp)  

Unfortunately, Ghidra's binary patching is a little bit broken for the moment. While a [PR (#1505)](https://github.com/NationalSecurityAgency/ghidra/pull/1505) is on its way to fix the behavior of `Export Program` (File > `Export Program`), you will have to wait another while for that PR to get merged. In the meantime though, an alternative method is to import the binary as a raw binary when adding the program in the current Ghidra Project, patch the instruction, and export the program that way.

![picture 39](/assets/images/posts/rgbctf-2020-07-14/pt1/e79f6eb8c3c37a4726d6af336bbefd100cfa3af3c6baf0c53bf41b0f7ba8fcb5.webp)  

![picture 40](/assets/images/posts/rgbctf-2020-07-14/pt1/47fa6712b11488f883c67e1a795ac30a0f37619339cb0055897aa464478fd4be.webp)  

And with that, we were able to successfully get the flag in less than a second!

```powershell
❯ ./a.out.bin
Flag Decryptor v1.0
Generating key...
Your flag: rgbCTF{pr3d1ct4bl3_k3y_n33d5_no_w41t_cab79d}
```

Flag: `rgbCTF{pr3d1ct4bl3_k3y_n33d5_no_w41t_cab79d}`

### Object Oriented Programming (413 pts)

> Challenge description
>
> `There's this small up and coming language called java I want to tell you about`

This solve was made possible by our Java guru, [Kieran](https://github.com/k-boyle), who pointed me to the right direction. Go give them a follow!
{: .notice--success}

The moment I saw the `Main.java` file I burst out in tears. Just... [take a look](https://gist.github.com/Still34/cc33aa76c6649761f95769dfc9e0094f).

```java
    import java.lang.reflect.*;//think of this as #include <stdio.h>, basically every program needs it for IO
    //...
    //it's always good practice to declare constants for unclear magic values
    public static final int ZERO = BigInteger.valueOf(0).intValue(); //BigInteger for precision
    //...
    public static void main(String[] args) throws Exception { //running Java is dangerous, that's why everything throws an Exception
      InputStream standardInputStream = new StandardInputStreamInstantiator().getStandardInputStreamFactory().getStandardInputStream();
      //i'm going to take a shortcut here, behold the power of java libraries - so many lines saved!
      Scanner scanner = Scanner.class.getConstructor(standardInputStream.getClass().getSuperclass().getSuperclass()).newInstance(standardInputStream);
      //...
    }
    //...
    protected static char secureEncryptionKey; //it's protected, how you gonna crack it now?
```

Even if you've *never ever* touched Java before, as long as you had dabbled with OOP, you should notice the absurdity the author is trying to convey here.

Anyways... It looks like the majority of the code is security by obscurity - the code tries to hide what it's doing by giving the reverse engineer a harder time decoding the meaning of the code. With a debugger though, it's slightly easier to understand what it's trying to do. Let's break this down by following the execution of each line in `main`.

```java
  String userInput = getUserInputMethodFromScannerAndInvokeAndReturnOutput(scanner);
  if (userInput.length() != SIXTEEN)
   System.exit(0);
```

> It should be safe to assume that these lines want to ensure that the length to be 16.

![picture 41](/assets/images/posts/rgbctf-2020-07-14/pt1/1cc4bd531008e90169714ea2a69f871efee3047546a63c86a4c67ec5bc0891b8.webp)  

When you step through the `executeCodeThatDoesSomethingThatYouProbablyNeedToFigureOut` method, you will notice that the string is getting "encrypted," as the variable states. The string is also getting split into chunks, per 4 characters. It is also at this time that I should note that there were other classes included with the `Main.java` file as illustrated below.

![picture 42](/assets/images/posts/rgbctf-2020-07-14/pt1/7b3fae5ba2cf806851c597f83aa513fd6841f13b97d7709699ccd3b5afd9d036.webp)  

After stepping through multiple times, it becomes apparent that every 4 characters are broken down into 2 groups of characters. For example, `asdf` -> `cqfd` -> `['cq', 'fd']`. Notice what happens if I let the execution continue:

```java
Exception in thread "main" java.lang.ClassNotFoundException: cq
 at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:581)
 at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178)
 at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:522)
 at java.base/java.lang.Class.forName0(Native Method)
 at java.base/java.lang.Class.forName(Class.java:315)
 at Main.executeCodeThatDoesSomethingThatYouProbablyNeedToFigureOut(Main.java:48)
 at Main.main(Main.java:33)
```

A stack trace is thrown telling me it can't find the class `cq`. What is happening here is that it is taking the first 2 characters and then using reflection to find the class and using the latter 2 characters as the method name to call. If we take a look at the other classes included,

```java
public class qa {

public String go() {
 return "kz";
}

public String bl() {
 return "pu";
}
//...
```

...you'll see that if I were to find a set of characters that can translate to `qago`, then it would call the `qa` class and execute the method `go`, and then returning the characters `kz`. Additionally, the `if (executeCodeThatDoesSomethingThatYouProbablyNeedToFigureOut(userInput).equals(scanner.getClass().getPackageName().replace(".", "")))` check essentially wants the translated to string to match the word `javautil`. So, all that's left is to figure out what character sets would give us the output we want!

After a bit of trial and error, I was able to figure out that the input should be `enterprisecodeee`, and that was indeed the flag!

```powershell
enterprisecodeee
Nice. Flag: rgbCTF{enterprisecodeee}
```

Flag: `rgbCTF{enterprisecodeee}`

### Five Fives (476 pts)

> Challenge description
>
> `java SecureRandom is supposed to be, well, secure, right? nc challenge.rgbsec.xyz 7425`

The included source code was as follows,

```java
import java.util.*;
import java.io.*;
import java.nio.ByteBuffer;
import java.util.concurrent.ThreadLocalRandom;
import java.security.*;

public class Main {
    public static void main(String[] args) throws Exception {
        Scanner in = new Scanner(System.in);

        System.out.println("Welcome to the Five Fives Lotto!");
        System.out.println("Generating seed...");

        //You'll never find my seed now!
        int sleep = ThreadLocalRandom.current().nextInt(10000);
        Thread.sleep(sleep);
        long seed = System.currentTimeMillis();
        ByteBuffer bb = ByteBuffer.allocate(Long.BYTES);
        bb.putLong(seed);
        SecureRandom r = new SecureRandom(bb.array());
        Thread.sleep(10000 - sleep);

        System.out.println("Yesterday's numbers were: ");
        for (int i = 0; i != 5; i++) {
            System.out.print((r.nextInt(5) + 1) + " ");
        }
        System.out.println();

        System.out.println("You have $20, and each ticket is $1. How many tickets would you like to buy? ");
        int numTries = Integer.parseInt(in.nextLine());
        if (numTries > 20) {
            System.out.println("Sorry, you don't have enough money to buy all of those. :(");
            System.exit(0);
        }

        int[] nums = new int[5];
        for (int a = 0; a != 5; a++) {
            nums[a] = r.nextInt(5) + 1;
        }

        for (int i = 0; i != numTries; i++) {
            System.out.println("Ticket number " + (i + 1) + "! Enter five numbers, separated by spaces:");
            String[] ticket = in.nextLine().split(" ");

            boolean winner = true;
            for (int b = 0; b != 5; b++) {
                if (nums[b] != Integer.parseInt(ticket[b])) {
                    winner = false;
                    break;
                }
            }

            if (!winner) {
                System.out.println("Your ticket did not win. Try again.");
            } else {
                System.out.println("Congratulations, you win the flag lottery!");
                outputFlag();
            }
        }
    }

    public static void outputFlag() {
        try {
            BufferedReader in = new BufferedReader(new FileReader("flag.txt"));
            System.out.println(in.readLine());
        } catch (IOException e) {
            System.out.println("Error reading flag. Please contact admins.");
        }
    }
}
```

Upon first glace, it really doesn't seem like there's much we can do here. It's PRNG, but the use of `SecureRandom` takes the P (pseudo) out of the PRNG. As stated by the Oracle Java documentation,

```markdown
This class provides a cryptographically strong random number generator (RNG).
A cryptographically strong random number minimally complies with the statistical random number generator tests specified in FIPS 140-2, Security Requirements for Cryptographic Modules, section 4.9.1. Additionally, SecureRandom must produce non-deterministic output. Therefore any seed material passed to a SecureRandom object must be unpredictable, and all SecureRandom output sequences must be cryptographically strong, as described in RFC 1750: Randomness Recommendations for Security.

A caller obtains a SecureRandom instance via the no-argument constructor or one of the getInstance methods:

      SecureRandom random = new SecureRandom();

Many SecureRandom implementations are in the form of a pseudo-random number generator (PRNG), which means they use a deterministic algorithm to produce a pseudo-random sequence from a true random seed. Other implementations may produce true random numbers, and yet others may use a combination of both techniques.

Typical callers of SecureRandom invoke the following methods to retrieve random bytes:

      SecureRandom random = new SecureRandom();
      byte bytes[] = new byte[20];
      random.nextBytes(bytes);

Callers may also invoke the generateSeed method to generate a given number of seed bytes (to seed other random number generators, for example):

      byte seed[] = random.generateSeed(20);

Note: Depending on the implementation, the generateSeed and nextBytes methods may block as entropy is being gathered, for example, if they need to read from /dev/random on various Unix-like operating systems.
```

So that means we should potentially seek for other attack vectors instead of focusing on the "cryptographically-secure RNG." Let's try connecting to the remote server first then plot our attack later.

```markdown
❯ nc challenge.rgbsec.xyz 7425
Welcome to the Five Fives Lotto!
Generating seed...
Yesterday's numbers were:
2 3 1 3 1
You have $20, and each ticket is $1. How many tickets would you like to buy?
1
Ticket number 1! Enter five numbers, separated by spaces:
1 1 1 1 1
Your ticket did not win. Try again.
```

After connecting to the server once and trying out the challenge hands-on, I was able to plot out the following flowchart.

![Lotto flowchart](/assets/images/posts/rgbctf-2020-07-14/pt1/lotto-flowchart.svg)

Let's take a step back to see if we can find any other potential attack vectors in the code. If we take a look at how the program determines the number of tickets can be bought, we quickly find a loophole that we can exploit.

```java
int numTries = Integer.parseInt(in.nextLine());
// no lower bound!
if (numTries > 20) {
    System.out.println("Sorry, you don't have enough money to buy all of those. :(");
    System.exit(0);
}
// ...
// loop until i matches numTries
for (int i = 0; i != numTries; i++) {
}
```

Yup, because the program did not account for the lower-bound of the `parseInt` or explicitly use `parseUnsignedInt`, the user can enter a negative integer and it would happily take the input and loop infinitely for us until something breaks out of the loop. With that in mind, we can write a script that brute-forces the challenge for us.

```python
import pwn
pwn.context.timeout = 1
r = pwn.remote("167.172.123.213", 7425)
# while loop due to the quirkiness of pwntool's recv when dealing with tubes that delay for an abnormal amount of time
while True:
    l = r.recv(timeout=0.5)
    print(l)
    if 'buy?' in l.decode():
        break
r.sendline('-1')
print(r.recvline())
# attempts is an array of all combinations of 1 ~ 5
for attempt in attempts:
    try:
        print(r.recvline())
        r.sendline(attempt)
        print(attempt)
        print(r.recvline_contains('Congratulations', timeout=0.5))
        print(r.recvuntil('rgbCTF', timeout=pwn.Timeout.maximum))
    except:
        pass
```

In a nutshell, the Python script will continue to try for all the possible combinations until the flag was sent by the server. After a short while, I was able to get the following:

```python
b'Your ticket did not win. Try again.\n'
1 4 1 4 3
b'Congratulations, you win the flag lottery!'
b'rgbCTF{s0m3t1m3s_4ll_y0u_n33d_1s_f0rc3}\n'
```

Awesome, and it looks like the author did intend us to brute-force according to the flag.

Flag: `rgbCTF{s0m3t1m3s_4ll_y0u_n33d_1s_f0rc3}`

## ZTC

### Ralphie! (50 pts)

> Challenge description
>
> Ralphie, on the double! Little Orphan Annie sent you this decoder ring, decode the secret message!

![picture 19](/assets/images/posts/rgbctf-2020-07-14/pt1/5483a9c5b58d3d6a3fc9add0612bad4c69da886d189594d65551dfb94dbb9d4b.webp)  

Well at least this QR code is painfully obvious. Let's just fiddle around with the brightness and crop the QR code.

![picture 20](/assets/images/posts/rgbctf-2020-07-14/pt1/2ff639d2e20cfae4c448ed5cf6c983f0342492aded22f7920a6975873144658c.webp)  

Wait, what?

![picture 21](/assets/images/posts/rgbctf-2020-07-14/pt1/e2fdde278de101da448c695536f1017f679cd26f6f26024e2f7d04075b580268.webp)  

Uhhh, I bet it must be the color that's screwing with the code. Let's slap a B&W filter over the image.

![picture 23](/assets/images/posts/rgbctf-2020-07-14/pt1/f40b2e2b91f038ca4024fbd01814727a90a108fefa021812293df64360d0adc1.webp)  

![picture 22](/assets/images/posts/rgbctf-2020-07-14/pt1/6a309ca6214a59305fe2e6cb32667b90aa2ef9c85cc75a41e50df87f1230f1b0.webp)  

It was! But why? Color screws with QR code output? Apparently, yes! One can store more than one layer of data in QR code based on the use of color and can lead to different output, as pointed out in the [ART-UP: A Novel Method for Generating Scanning-robust Aesthetic QR codes](https://arxiv.org/abs/1803.02280) paper.

> The use of colors in QR codes enhances its functionality now. The data rate which is high among the 2D barcodes can be further enhanced with the use of colors.

Huh, TIL!

Flag: `rgbCTF{BESURETODRINKYOUROVALTINE}`

### Vaporwave 1 (190 pts)

> Challenge description
>
> Do you believe in synesthesia?
> 📎 Attachment: `vaporwave1.mp3`

As someone who had previously worked in the audio SFX and mastering industry, I happened to have learned a lot during that journey. One of the most common thing that a audio mastering engineer or producer would have to do is check for frequency collisions and other anomalies that may appear in the raw audio. This typically involves two things: a spectrum analyzer and an EQ visualizer.

In laymen's term, a spectrum analyzer plots out a graph that helps a mixing engineer see the fidelity of the audio as well as identify what portion of the track use up what section of the frequency and how loud it is (*keep in mind I'm drastically simplifying things here*).

![picture 32](/assets/images/posts/rgbctf-2020-07-14/pt1/aeb749ddd511bc0329591afd7458d263ad3639849b55e8c0b5b3135c2e5d07c9.webp)  

Sometimes an artist may also plant an easter egg within the spectrogram of the track. For example, the following screenshot features John Romero's sprite from DOOM 2 in Mick Gordon's DOOM 2016 soundtrack, SkullHacker.

![picture 33](/assets/images/posts/rgbctf-2020-07-14/pt1/b00142b45640a6817f3b63dfde111dee279c79bde660eea5c6d3643cd859e400.webp)  

My knowledge happens to acquainted me with one of the most common steganography techniques used among beginner audio steganography challenges: hiding textual or visual information within these spectrums. That's why my first instinct was to open up the file in a spectrogram viewer - in this case, [spek](http://spek.cc/).

I happened to have solved the track without trying! Awesome!

![picture 34](/assets/images/posts/rgbctf-2020-07-14/pt1/1bb1cfa169c5f8fcb333a8835c954d639b275fac2849ca44f668a232fb829bc6.webp)  

Funnily enough, last year I made a similar challenge for our CTF club, Pingtung Hacker, though the flag was *far more* subtle. The base track was SeamlessR's Bass Antics; I just slapped an image containing the flag into Harmor and played it along with the base track.

<audio controls src="https://www.dropbox.com/s/55xc7o8sqihj1j6/bass-antics.wav?dl=1"></audio>

![picture 36](/assets/images/posts/rgbctf-2020-07-14/pt1/204c763a75d5fc3ffa2365f97963fa283abb79be865f9de682e3a049ded418e9.webp)  

Flag: `rgbCTF{s331ng_s0undz}`

### peepdis (263 pts)

> Challenge description
>
> Do you peep what I peep?

The included file was called `peepdis.dae`. Opening the file reveals that it's an XML-like file.

```xml
❯ cat .\peepdis.dae | head
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<COLLADA xmlns="http://www.collada.org/2005/11/COLLADASchema" version="1.4.1">
  <asset>
    <contributor>
      <author>Assimp</author>
      <authoring_tool>Assimp Exporter</authoring_tool>
    </contributor>
    <created>2020-06-24T20:07:24</created>
    <modified>2020-06-24T20:07:24</modified>
    <unit name="meter" meter="1" />
```

The XML version header claims that it's using the COLLADA Schema. Huh. I can't say I've ever heard of this schema before. Let's look up what this is.

> COLLADA is an interchange file format for interactive 3D applications. It is managed by the nonprofit technology consortium, the Khronos Group, and has been adopted by ISO as a publicly available specification, ISO/PAS 17506.

Huh, does that mean it's a 3D model of some sorts? Let's see if I can open it with a [3D viewer online](https://www.creators3d.com/online-viewer).

![picture 25](/assets/images/posts/rgbctf-2020-07-14/pt1/9040a13a679ddaa67678abda71f7c25908dcea392047c02631fa3474b9a5cc69.webp)  

Okay...? It's a square?

![picture 26](/assets/images/posts/rgbctf-2020-07-14/pt1/d85328768a56102996c255d50fb634057b050b5c3d7cbb188412e632ffe9ad7d.webp)  

Wait... No, that's a QR code? Let's play around with the lighting a bit and see if we can get the QR code part to show up a bit more.

![picture 27](/assets/images/posts/rgbctf-2020-07-14/pt1/94a8065b821712af094daf5ea550bfa205e5ff01e318e41cdf6b4381b0f21da7.webp)  

Annnd let's plop this into an image editor.

![picture 28](/assets/images/posts/rgbctf-2020-07-14/pt1/1738abd86491f26e0b98fa959d3c0777bef94bdc38aaac6e41a8dc41cdae8426.webp)  

And with that we were able to obtain the flag! I have to say though, while this was creative, this *really* doesn't have much to do with steganography techniques but a novelty. I wouldn't say this was the best challenge.

Flag: `rgbCTF{3d-1337!}`
