# ClipStack

A small Mac menu bar app that remembers what you copy, like Windows Key+V.

- Starts when you log in and sits in the menu bar.
- Remembers your recent copies: text, images and files.
- Press Command-Shift-V to see the list, pick one, and it pastes where you were typing.
- Pin items you want to keep. Password manager copies are never saved.

Requires macOS 14 or later. To let ClipStack paste for you, allow it in
System Settings > Privacy & Security > Accessibility.

## First time on a Mac

1. If the folder is not on this Mac yet, open Terminal and run:
   `git clone https://github.com/troyhome/clipstack.git ~/Projects/ClipStack`
2. Then: `cd ~/Projects/ClipStack && Tools/clipstack.sh run`
   (or double-click `ClipStack.xcodeproj` and press Command-R in Xcode).
3. A clipboard icon appears in the menu bar. Copy a few things, then press Command-Shift-V.
4. The first time, macOS asks to allow Accessibility. Click Open System Settings and turn
   ClipStack on. Without it, picking an item only copies it (paste with Command-V yourself).
5. When happy, run `Tools/clipstack.sh install` so it lives in /Applications and opens at login.

## Build

```bash
Tools/clipstack.sh run
```

```bash
Tools/clipstack.sh install
```
