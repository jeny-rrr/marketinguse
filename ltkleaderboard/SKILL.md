---
name: ltkleaderboard
description: Register LTK Quick Campaign accepted creators and LTK Leaderboard posts into the Feishu promotion workbook. Use when the user asks to collect LTK campaign creator information, assign creators to Jeny or Hayley by LTK Lists, write shipment records, update the self-built creator database, or register LTK Leaderboard post data into the Feishu publishing sheet.
---

# LTK Leaderboard

Use this skill for the Fitory LTK-to-Feishu workflow. Use Chrome for LTK because the user is already logged in. Use `lark-cli` for Feishu writes because the workbook contains formulas, dropdowns, and duplicate highlighting.

## Required Skills

Load these before acting:

- `chrome:control-chrome` for LTK pages.
- `lark-sheets` and `lark-wiki` for Feishu workbook access.

## Workbook

Primary Feishu wiki URL:

`https://wadliul57pe.feishu.cn/wiki/RiHZwOen2ibvrTk0LeJcNu1Unpd?sheet=8h8fpA`

Known spreadsheet token after wiki resolution:

`OGFpsQDIchiUNOtMojCcI83Anc8`

Known sheet ids:

- Shipment sheet: `Q8vt6p`
- Self-built creator database: `8h8fpA`
- Publishing sheet: `KKYET3`

Do not store or print App Secret values. If the global `lark-cli` config is not writable, use an isolated home such as local `.lark-home` and set both `USERPROFILE` and `HOME` for each `lark-cli` command.

## General Rules

- Treat brown header cells with white text as manual-entry columns.
- Treat black header cells with white text as formula or auto-filled columns.
- Do not overwrite formula cells unless the user explicitly confirms a missing formula result should be manually filled.
- Check duplicates before writing. The workbook has duplicate highlighting, but do not rely on color alone.
- Determine real row numbers from `annotated_csv` `[row=N]` or `cells-get` `row_indices`, never from the visible serial number column.
- Use Unicode escapes or UTF-8-safe input when writing Chinese dropdown values such as image/video. Windows pipes can otherwise write `??`.

## BD Assignment

- If LTK creator Lists include `Jeny`, assign to Jeny.
- If LTK creator Lists include `Hayley`, assign to Hayley.
- If no matching List is visible or the creator is not in a corresponding List, assign to Jeny by default.
- Mark uncertain default assignment in notes when adding new creator records, if a notes column is available.

## Quick Campaign Creator Workflow

1. Open LTK: `https://brands.rewardstyle.com/cmp/home`.
2. Go to `Quick campaigns`.
3. Process all `Active` campaigns.
4. Open each campaign, choose `Manage Creators`, then `Accepted`.
5. Open each creator drawer from the accepted list.
6. Read creator handle, profile link, follower counts, and LTK Lists.
7. Assign BD by the BD Assignment rules.
8. Register creator shipment information into the shipment sheet.
9. Add non-duplicate creators to the self-built creator database.
10. Keep formula columns intact; fill only manual fields and missing formula results after checking.

## Leaderboard Publishing Workflow

1. Open LTK `Analyze > Leaderboard > Top performing posts`.
2. Switch to table view.
3. Sort by `Most recent`.
4. Read rows from the DOM table. The row `data-testid` has the post id, such as `post-row-ae95aa3f-a48a-11f1-be96-5ec4745bf9dc`.
5. Build the post link as `https://www.shopltk.com/explore/<handle>/posts/<post_id>`.
6. Use the handle profile link as `https://www.shopltk.com/explore/<handle>`.
7. Check the publishing sheet for the full post link before writing.
8. Determine BD from the shipment sheet or creator database; if missing, use the LTK List rule.
9. Find the correct publishing section by month and BD. Do not append blindly to the sheet end.
10. Write only the manual fields for the row.
11. Read the row back and confirm formula columns are populated or intentionally blank.

## Publishing Sheet Manual Fields

For LTK Leaderboard posts, write these columns when available:

- `B` BD
- `C` account/handle
- `K` content type: image if the Leaderboard row has no video evidence; video if it has video evidence
- `L` link platform: usually `Store`
- `M` link correct: `Y`
- `N` sales amount
- `O` conversion rate
- `P` publish date
- `Q` content link
- `R` impressions/reach
- `S` clicks

Do not manually write `D/E/F/G/H/J` when formulas can find the creator in the shipment sheet.

## Example Verified Row

Verified on `2026-09-04`:

- Source: LTK Leaderboard `Most recent`
- Creator: `Grace Boros`, handle `Gracabo.art`
- Post date: `2026/8/30`
- Post id: `ae95aa3f-a48a-11f1-be96-5ec4745bf9dc`
- Publishing sheet row: `899`
- BD: `Jeny`
- Written values: `B=Jeny`, `C=Gracabo.art`, `K=image`, `L=Store`, `M=Y`, `N=0`, `O=0`, `P=2026/8/30`, `Q=<post link>`, `R=1331`, `S=2`
- Formula fields auto-filled: profile link, followers, level, creator type, product list.

See `references/publish-table.md` for the exact write and validation sequence.
