# ClipStack plan

## Phase 1 — working clipboard history (code written 2026-11-01, not yet built)
- [x] Menu bar app, no Dock icon
- [x] Watch the clipboard: text, images, Finder files; skip password-manager items
- [x] History saved between restarts, duplicates move to the top, pinning, size limit
- [x] Shortcut (Command-Shift-V) opens a list near the mouse
- [x] List: arrows + Return, Command-1..9, type to search, Command-P pin, Command-Delete remove, Esc close
- [x] Paste into the app in front (needs Accessibility permission)
- [x] Open at login, Settings window (shortcut, history size, permission status, clear history)
- [ ] First build on the Mac and fix compile errors
- [ ] Test: copy in Safari/Notes/Finder, paste with the list, restart Mac and check it starts by itself

## Phase 2 — polish
- [ ] App icon
- [ ] Show the list near the text cursor instead of the mouse (needs Accessibility to find the cursor)
- [ ] Keep rich text (bold, links) when pasting, not only plain text
- [ ] "Paste as plain text" option (Option-Return)
- [ ] Ignore list: apps whose copies are never saved

## Phase 3 — release
- [ ] Notarized Developer ID build (`dmg`/`release` commands in `Tools/clipstack.sh`, like MacBee)
- [ ] Simple update check

## Later
- Any shortcut the user records (not just the three choices)
- iCloud sync of pinned items between Troy's two Macs
- App Store build: sandboxed apps can't press keys for you, so it would copy only, or need another approach
