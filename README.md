# ClipStack

A small Mac menu bar app that remembers what you copy, like Windows Key+V.

- Starts when you log in and sits in the menu bar.
- Remembers your recent copies: text, images and files.
- Press Command-Shift-V to see the list, pick one, then press Command-V to paste it.
- Pin items you want to keep. Password manager copies are never saved.

Requires macOS 14 or later. Free on the Mac App Store.

## First time on a Mac

1. If the folder is not on this Mac yet, open Terminal and run:
   `git clone https://github.com/troyhome/clipstack.git ~/Projects/ClipStack`
2. Then: `cd ~/Projects/ClipStack && Tools/clipstack.sh run`
   (or double-click `ClipStack.xcodeproj` and press Command-R in Xcode).
3. A clipboard icon appears in the menu bar. Copy a few things, then press Command-Shift-V.
4. The first time, ClipStack asks whether to open at login.
5. When happy, run `Tools/clipstack.sh install` so it lives in /Applications.

## Build

```bash
Tools/clipstack.sh run
```

```bash
Tools/clipstack.sh install
```
