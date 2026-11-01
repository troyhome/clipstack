# ClipStack

A small Mac menu bar app that remembers what you copy, like Windows Key+V.

- Starts when you log in and sits in the menu bar.
- Remembers your recent copies: text, images and files.
- Press Command-Shift-V to see the list, pick one, and it pastes where you were typing.
- Pin items you want to keep. Password manager copies are never saved.

Requires macOS 14 or later. To let ClipStack paste for you, allow it in
System Settings > Privacy & Security > Accessibility.

## Build

```bash
Tools/clipstack.sh run
```

```bash
Tools/clipstack.sh install
```
