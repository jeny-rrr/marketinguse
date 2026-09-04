# Feishu Publishing Table Reference

Use this reference when registering LTK Leaderboard "Top performing posts" records into the publishing sheet.

## Workbook

- Wiki URL: `https://wadliul57pe.feishu.cn/wiki/RiHZwOen2ibvrTk0LeJcNu1Unpd?sheet=8h8fpA`
- Spreadsheet token: `OGFpsQDIchiUNOtMojCcI83Anc8`
- Publishing sheet id: `KKYET3`
- Shipment sheet id: `Q8vt6p`
- Self-built creator database sheet id: `8h8fpA`

## Lark CLI environment

This workflow uses the workspace-local Feishu auth profile. Set these variables before every `lark-cli.cmd` call if the global Feishu profile is unavailable:

```powershell
$env:USERPROFILE='D:\daisy-codex\LTK\.lark-home'
$env:HOME='D:\daisy-codex\LTK\.lark-home'
```

Do not commit `.lark-home/` or QR-code/auth files.

## Inspect headers

Read header colors and existing formulas before writing rows:

```powershell
lark-cli.cmd sheets +cells-get --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id KKYET3 --range 'A1:AA2' --include value,formula,style --as user --format json
```

The user's rule is:

- Brown header with white text: manual fields to fill.
- Black header with white text: formula or automatic fields; leave blank unless the formula fails to recognize.
- If a formula fails after writing the manual fields, fill the missing field manually and note it.

## Duplicate checks

Search by post URL before writing publishing records:

```powershell
lark-cli.cmd sheets +cells-search --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id KKYET3 --find '<post-url>' --as user --format json
```

For creator registration workflows, search by handle in both the shipment sheet and creator database:

```powershell
lark-cli.cmd sheets +cells-search --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id Q8vt6p --find '<handle>' --as user --format json
lark-cli.cmd sheets +cells-search --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id 8h8fpA --find '<handle>' --as user --format json
```

If a Feishu duplicate highlight turns green after entry, treat it as a duplicate warning and do not add another row unless the user explicitly wants both records kept.

## Row placement notes

Use the real current sheet state first. These are observed anchors, not permanent row rules:

- August section header: row 887.
- August Jeny LTK entries start around row 888.
- August Hayley LTK entries start around row 1215.
- September Jeny section header: row 1141.
- September Hayley Instagram entries were observed around row 1240.

When choosing a row, keep entries inside the correct month and BD section. Prefer the first blank row in that section.

## Publishing row mapping

For one LTK Leaderboard post, write the manual publishing fields into `B:S`:

| Column | Meaning | Fill rule |
| --- | --- | --- |
| B | BD | `Jeny` or `Hayley` |
| C | Account / Handle | LTK creator handle without `@` |
| D | Level | formula, normally blank |
| E | Creator Type | formula, normally blank |
| F | Creator Tags | formula, normally blank |
| G | Platform | formula, normally blank |
| H | Product | formula, normally blank |
| I | Content Form | `图片` or `视频` |
| J | Link Platform | formula, normally blank |
| K | Link Platform | usually dropdown `Store` |
| L | Link OK | usually `Y` |
| M | Sales Amount | numeric value from LTK; use `0` if none |
| N | Conversion Rate | percentage text or numeric value from LTK; use `0` if none |
| O | Publish Time | date like `2026/8/30` |
| P | Content Link | rich text hyperlink to the LTK post URL |
| Q | Impressions / Reach | numeric impressions |
| R | Clicks | numeric clicks |
| S | Interactions | fill only if available; otherwise leave blank |

Use `{}` for formula columns so existing formulas can populate them.

Example payload for row 899:

```powershell
$cells = @(
  @(
    @{ value = 'Jeny' },
    @{ value = 'Gracabo.art' },
    @{}, @{}, @{}, @{}, @{}, @{},
    @{ value = ([char]0x56FE + [char]0x7247) },
    @{},
    @{ multiple_values = @( @{ value = 'Store' } ) },
    @{ value = 'Y' },
    @{ value = 0 },
    @{ value = '0' },
    @{ value = '2026/8/30' },
    @{ rich_text = @( @{ type = 'link'; text = 'https://www.shopltk.com/explore/Gracabo.art/posts/ae95aa3f-a48a-11f1-be96-5ec4745bf9dc'; link = 'https://www.shopltk.com/explore/Gracabo.art/posts/ae95aa3f-a48a-11f1-be96-5ec4745bf9dc' } ) },
    @{ value = 1331 },
    @{ value = 2 }
  )
)
$json = $cells | ConvertTo-Json -Depth 8 -Compress
$json | lark-cli.cmd sheets +cells-set --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id KKYET3 --range 'B899:S899' --cells - --as user --format json
```

## Validate after writing

Read the full written row after every write:

```powershell
lark-cli.cmd sheets +cells-get --spreadsheet-token OGFpsQDIchiUNOtMojCcI83Anc8 --sheet-id KKYET3 --range 'A899:AA899' --include value,formula,style --as user --format json
```

Confirm:

- Manual values are in the intended row.
- Formula fields populated where expected.
- The content link is a hyperlink, not plain text only.
- No unintended cells were overwritten.
