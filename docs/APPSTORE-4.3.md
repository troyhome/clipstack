# Rejection 2026-11-13: Guideline 4.3(a) Design - Spam

Apple said ClipStack "shares a similar binary, metadata, and/or concept as apps submitted by other
developers, with only minor differences." Plan: reply, update the store text so the differences are
obvious, resubmit. If rejected again, appeal to the App Review Board.

## What sets ClipStack apart (checked in the code, 2026-11-13)
| Claim | Where in the code |
|---|---|
| Pinned items kept forever, outside the history limit (works as a snippet list) | `HistoryStore.trimToLimit`, `clearUnpinned`; Command-P in `PickerViewModel` |
| Type-to-search, instant filter | `PickerViewModel.visibleItems` |
| Command-1 to 9 quick copy | `PickerViewModel.handleKey` |
| Opens next to the mouse | `PickerController` (`NSEvent.mouseLocation`) |
| Text, images, Finder files, Photos pictures | `Capture.swift` |
| Skips password-manager items (nspasteboard.org types, 1Password) | `ClipboardReader.privateTypes` |
| No internet access at all (sandbox, no network entitlement) | `ClipStack.entitlements` |
| No Accessibility permission, no key monitoring (Carbon hot key) | `HotKey.swift` |
| Menu bar only, no Dock icon, 10-100 items | project settings (LSUIElement), `Settings.swift` |

Not true, so do not claim: a separate snippet editor, iCloud sync, rich text, OCR.

## Similar apps (honest comparison, 2026-11-13)
| App | Price | On Mac App Store | How it compares |
|---|---|---|---|
| Maccy | Free from GitHub; $9.99 on the App Store | Yes (paid) | Closest match: menu bar, search, pins, images, skips passwords, open source. Main difference on the store: price. |
| Flycut | Free | Yes | Text only, last updated 2020, no pins (has "favorites"). |
| Clipy | Free | No (GitHub only) | Text plus snippet folders; not updated in years. |
| Paste | $29.99/year subscription | Yes | Large visual timeline, iCloud sync, iPhone app. Much heavier. |
| PastePal | Paid (one-time or subscription) | Yes | Many features, sync, iPhone app. |
| Pastebot | $24.99/year on store | Yes | Text filters, paste stacks. |
| Raycast / Alfred | Clipboard is part of a larger launcher (paid tiers) | No | Not a stand-alone clipboard app. |

Sources: apps.apple.com listings for Maccy (id1527619437) and Flycut (id442160987);
switchingtomac.com "Best Clipboard Managers for Mac 2026".

## Reply to App Review (paste into the message to Apple)
```
Hello,

Thank you for reviewing ClipStack. I would like to ask you to reconsider the 4.3(a) decision.

ClipStack is my own app, written from scratch in Swift. It is not built from a template or another
developer's code, and it is the only app I have submitted.

Clipboard history is a common kind of utility, but ClipStack is built around a specific design
that I could not find in a free App Store app:

- Free, with no in-app purchases, subscriptions, ads or account.
- Pinned items: pin text you reuse (addresses, replies, code) and it is kept permanently,
  separate from the rolling history, so it works as a simple snippet list.
- Quick search: press Command-Shift-V and start typing; the list filters instantly.
  Command-1 to 9 copies one of the first nine items in one keystroke.
- Opens as a small list next to the mouse pointer, not a full window.
- Private by design: the app has no network entitlement, so it cannot connect to the internet.
  Nothing is collected. Items marked private by password managers are never saved.
- Needs no Accessibility permission and does not monitor the keyboard. It only copies;
  the user presses Command-V (Guideline 2.4.5).
- Lightweight: menu bar only, no Dock icon, sandboxed, keeps 10 to 100 items.

I have updated the description, subtitle and keywords so these differences are clear on the
store page. I would be happy to answer any questions.

Thank you,
Troy Homenchuk
```

## App Review Board appeal (only if rejected again)
Form: https://developer.apple.com/contact/app-store/?topic=appeal
```
App name: ClipStack - Clipboard History (macOS), bundle ID com.troyhomenchuk.ClipStack
Guideline: 4.3(a) Design - Spam

I believe this rejection was made in error. Guideline 4.3 is aimed at duplicate apps, template
apps and developers flooding the store. ClipStack is none of these: it is the only app I have
submitted, written from scratch by me, with no shared code, template or reused metadata.

Clipboard history apps are an established category on the Mac App Store, and ClipStack offers
a distinct combination not available in any other free App Store app: pinned items kept
permanently as a snippet list, instant type-to-search, Command-1 to 9 quick copy, a small list
that opens next to the mouse, and strict privacy (no network entitlement, no data collected,
password-manager items skipped, no Accessibility permission needed). It is free with no
purchases or ads.

The closest similar app on the store is paid. ClipStack gives Mac users a free, private,
lightweight option. I would be grateful if the Board would review the app and its description.
```

## New store text (replaces "Listing text" in `APPSTORE.md`)
**Subtitle (30 max):** `Free, private, pin and search` (29)

**Keywords (100 max):**
`clipboard,history,pin,snippets,search,copy,paste,private,free,menu bar,pasteboard,offline,manager` (97)

**Promotional text (170 max):**
`Free and private: no internet access, no ads, no account. Pin what you reuse and find any copy by typing.`

**Description:**
```
ClipStack is a free, private clipboard history that lives in your menu bar.

Press Command-Shift-V and a small list of your recent copies opens next to the mouse. Start typing to find something, or press Command-1 to 9 to grab one of the first nine. Pick an item and it is ready to paste with Command-V.

PIN WHAT YOU REUSE
Pin text you paste again and again: your address, email replies, code. Pinned items are kept forever, outside the history limit, so they work as a simple snippet list. Press Command-P in the list to pin.

QUICK SEARCH
Just type. The list filters as you go, across text and file names.

PRIVATE BY DESIGN
- No internet access at all: the app has no network permission
- No account, no ads, no tracking, nothing collected
- Skips passwords copied from password managers
- No Accessibility permission needed

LIGHT AND SIMPLE
- Menu bar only, no Dock icon
- Text, images, and files from Finder and Photos
- Keeps the last 10, 25, 50 or 100 items (your choice)
- Free, with no in-app purchases
```

## Steps (Troy, in App Store Connect)
1. Open the rejection message (App Review) and reply with the text above. Do not attach anything new.
2. On the macOS version page, replace Subtitle, Promotional Text, Description and Keywords with the text above. Save.
3. Click "Update Review", then "Resubmit to App Review" on the submission page.
4. Reload and check the status says "Waiting for Review". Only then is it done.
5. If Apple rejects again for 4.3, send the appeal text using the form link above.
