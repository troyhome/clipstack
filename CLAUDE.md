# ClipStack — project brief for Claude Code

ClipStack is a small macOS menu bar utility (Swift / SwiftUI) that keeps a clipboard history, like
Windows Key+V. It starts at login, remembers the last copied items (text, images, Finder files), and a
shortcut (default Command-Shift-V) opens a list near the mouse; picking an item copies it, and the user presses Command-V.

Plan, progress and "later" ideas: `docs/PLAN.md` (read when starting new work).

## About the user
- Troy is new to programming and Terminal. Explain briefly, in plain language, no jargon.
- Short answers, no emojis (also none in the app's UI text).
- Give exact steps when something must be done by hand; otherwise just do it.
- UI rule: no looping/indeterminate animations (spinners, sliding progress bars).

## Decisions already made
- Name ClipStack, bundle id `com.troyhomenchuk.ClipStack`, minimum macOS 14, menu bar only (LSUIElement, no Dock icon).
- App Store only, one version (Troy, 2026-11-01): sandboxed, and picking an item only copies it; the user presses
  Command-V. No Accessibility permission, no key presses (Apple rejects clipboard apps that paste for you, 2.4.5).
- Shortcut: Command-Shift-V by default; Settings offers Control-Option-V and Command-Option-V.
  Uses Carbon `RegisterEventHotKey` (no Accessibility needed, no global key monitoring).
- Clipboard is checked twice a second (`changeCount`); macOS has no change notification.
- Items marked private by password managers (nspasteboard.org Concealed/Transient types) are never saved.
- History: last 25 by default (10/25/50/100), pinned items always kept. Saved in the sandbox container:
  `~/Library/Containers/com.troyhomenchuk.ClipStack/Data/Library/Application Support/ClipStack/`.
- Open at login via `SMAppService.mainApp`; a first-launch window asks first (App Store rule).
- Architecture: MVVM, small files. Folders: `App/`, `Models/`, `Services/`, `Picker/`, `Views/`.
- Xcode project uses a synchronized folder (Xcode 16+): new files in `ClipStack/` are picked up automatically.
- Free on the Mac App Store as "ClipStack - Clipboard History". Upload with `Tools/clipstack.sh appstore`. See `docs/APPSTORE.md`.

## Signing
- Automatic signing, team `DA9YJ36D24` ("Apple Development"), Hardened Runtime on.
- Never put certificates, passwords or keys in the repo.

## Where the project lives and how to build
- GitHub: `troyhome/clipstack` (private). On the Macs: `~/Projects/ClipStack`.
- Build files never go inside the project folder. Use `Tools/clipstack.sh`:
  `build`, `run` (debug build and open), `install` (optimized copy to /Applications/ClipStack.app), `update` (git pull + install),
  `appstore` (build and upload to App Store Connect).
  Everything builds into `~/Library/Developer/ClipStack`.
- Building, signing and notarizing only happen on Troy's Mac. Cloud sessions write code and push.
- After finishing work: commit and `git push`, and say plainly "saved and sent to GitHub". Keep this file under
  200 lines (`wc -l CLAUDE.md`); put details in `docs/`.

## Status (2026-11-13)
- Version 1.0 is "Waiting for Review" (resubmitted 2026-11-13 after a 4.3(a) Spam rejection; reply, new store text and appeal in `docs/APPSTORE-4.3.md`), auto-release on approval.
  Store page done (screenshots in project files, privacy/support page is a public Google Doc, see `docs/APPSTORE.md`).
- After a rejection: fill App Review Notes, Save, "Update Review" on the version page, then "Resubmit to App Review",
  and only call it done when the page says "Waiting for Review".
