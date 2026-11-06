# ClipStack plan

## Phase 1 — working clipboard history (built 2026-11-01)
- [x] Menu bar app, no Dock icon
- [x] Watch the clipboard: text, images, Finder files; skip password-manager items
- [x] History saved between restarts, duplicates move to the top, pinning, size limit
- [x] Shortcut (Command-Shift-V) opens a list near the mouse
- [x] List: arrows + Return, Command-1..9, type to search, Command-P pin, Command-Delete remove, Esc close
- [x] Copy the picked item (user presses Command-V; App Store only, 2026-11-01)
- [x] Open at login, Settings window (shortcut, history size, permission status, clear history)
- [x] First build on the Mac (built and installed with no errors, 2026-11-01)
- [x] Test: copy in Safari/Notes/Finder/Photos, paste with the list (Troy, 2026-11-01)

## Phase 2 — polish
- [x] App icon ("Layers", source in `Design/AppIcon.svg`)
- [ ] Show the list near the text cursor instead of the mouse (needs Accessibility, not allowed for App Store apps)
- [ ] Keep rich text (bold, links) when pasting, not only plain text
- [ ] "Paste as plain text" option (Option-Return)
- [ ] Ignore list: apps whose copies are never saved

## Phase 3 — release (App Store only, no separate download version)
- [x] Store page, screenshots, privacy page, age rating, price Free
- [x] Submitted 2026-11-01; Apple asked for more info (2.1) on 2026-11-02
- [x] Replied with video + answers, filled App Review Notes, resubmitted 2026-11-05 ("Waiting for Review")
- [ ] Approved and live on the Mac App Store

## Later
- Any shortcut the user records (not just the three choices)
- iCloud sync of pinned items between Troy's two Macs
- Maybe ask Apple whether auto-paste would be allowed (see `docs/APPSTORE.md`)
