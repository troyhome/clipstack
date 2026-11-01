# ClipStack — project brief for Claude Code

ClipStack is a small macOS menu bar utility (Swift / SwiftUI) that keeps a clipboard history, like
Windows Key+V. It starts at login, remembers the last copied items (text, images, Finder files), and a
shortcut (default Command-Shift-V) opens a list near the mouse; picking an item pastes it into the app in front.

Plan, progress and "later" ideas: `docs/PLAN.md` (read when starting new work).

## About the user
- Troy is new to programming and Terminal. Explain briefly, in plain language, no jargon.
- Short answers, no emojis (also none in the app's UI text).
- Give exact steps when something must be done by hand; otherwise just do it.
- UI rule: no looping/indeterminate animations (spinners, sliding progress bars).

## Decisions already made
- Name ClipStack, bundle id `com.troyhomenchuk.ClipStack`, minimum macOS 14, menu bar only (LSUIElement, no Dock icon).
- Picking an item pastes for you (Troy, 2026-11-01): ClipStack writes it to the clipboard, then sends Command-V.
  That needs Accessibility permission; without it ClipStack only copies and shows the system permission prompt.
- Shortcut: Command-Shift-V by default; Settings offers Control-Option-V and Command-Option-V.
  Uses Carbon `RegisterEventHotKey` (no Accessibility needed, no global key monitoring).
- Clipboard is checked twice a second (`changeCount`); macOS has no change notification.
- Items marked private by password managers (nspasteboard.org Concealed/Transient types) are never saved.
- History: last 25 by default (10/25/50/100), pinned items always kept. Saved in
  `~/Library/Application Support/ClipStack/` (`history.json` + `Images/`).
- Open at login via `SMAppService.mainApp`; turned on automatically on first launch, only when running from /Applications.
- Architecture: MVVM, small files. Folders: `App/`, `Models/`, `Services/`, `Picker/`, `Views/`.
- Xcode project uses a synchronized folder (Xcode 16+): new files in `ClipStack/` are picked up automatically.
- Not sandboxed (direct download build). An App Store build would need a different paste approach (later list).

## Signing
- Automatic signing, team `DA9YJ36D24` ("Apple Development"), Hardened Runtime on.
- Plan: notarized Developer ID build for direct download; App Store build later.
- Never put certificates, passwords or keys in the repo.
- Accessibility permission is tied to the app's signature. If pasting stops working after an update, remove
  ClipStack from System Settings > Privacy & Security > Accessibility and add it again.

## Where the project lives and how to build
- GitHub: `troyhome/clipstack` (private). On the Macs: `~/Projects/ClipStack`.
- Build files never go inside the project folder. Use `Tools/clipstack.sh`:
  `build`, `run` (debug build and open), `install` (optimized copy to /Applications/ClipStack.app), `update` (git pull + install).
  Everything builds into `~/Library/Developer/ClipStack`.
- Building, signing and notarizing only happen on Troy's Mac. Cloud sessions write code and push.
- After finishing work: commit and `git push`, and say plainly "saved and sent to GitHub". Keep this file under
  200 lines (`wc -l CLAUDE.md`); put details in `docs/`.

## Status (2026-11-01)
- Phase 1 builds and installs on Troy's MacBook Air (2026-11-01). Next: test copying and pasting. See `docs/PLAN.md`.
