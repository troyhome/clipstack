# ClipStack on the Mac App Store

Free app. There is only one version: the App Store one (sandboxed, copy only, asks before
opening at login). Upload it with `Tools/clipstack.sh appstore`.

## Why copy only
Apple's review has rejected clipboard apps that press Command-V for you (Guideline 2.4.5, 2026).
So ClipStack puts the item on the clipboard and the user presses Command-V.

## One-time steps (Troy, by hand)
1. Xcode > Settings > Accounts: make sure your Apple ID is there (team DA9YJ36D24).
2. https://appstoreconnect.apple.com > Apps > "+" > New App:
   platform macOS, name "ClipStack - Clipboard History" (plain "ClipStack" is taken), language English,
   bundle ID `com.troyhomenchuk.ClipStack`, SKU `clipstack`.
3. Pricing and Availability: Free.
4. App Privacy: "Data Not Collected". Privacy Policy URL: a public page with the text from `docs/PRIVACY.md`.
5. Upload: `Tools/clipstack.sh appstore`.
6. Fill in the listing below, add screenshots (2880x1800 or 1440x900), pick the uploaded build, Submit for Review.

## Listing text

**Name:** ClipStack - Clipboard History (store name only; the app itself is still called ClipStack)
**Subtitle:** Clipboard history in your menu bar
**Category:** Utilities
**Keywords:** clipboard,history,copy,paste,manager,menu bar,pasteboard,snippets,clip

**Description:**
ClipStack remembers what you copy, so you can find it again.

Press Command-Shift-V and a small list of your recent copies appears next to the mouse.
Pick one and it is ready to paste with Command-V.

- Text, images and files from Finder
- Type to search the list
- Pin items you use often so they are always kept
- Keeps the last 10, 25, 50 or 100 items
- Lives in the menu bar, no Dock icon
- Private: everything stays on your Mac. Nothing is sent anywhere.
- Skips passwords copied from password managers

**Review notes (for Apple):**
ClipStack is a menu bar app with no Dock icon. Click the clipboard icon in the menu bar, or press
Command-Shift-V, to open the history list. Copy some text first so the list has items.
