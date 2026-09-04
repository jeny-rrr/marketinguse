param(
  [Parameter(Mandatory=$true)][string]$Row,
  [Parameter(Mandatory=$true)][string]$BD,
  [Parameter(Mandatory=$true)][string]$Handle,
  [Parameter(Mandatory=$true)][string]$PostUrl,
  [Parameter(Mandatory=$true)][string]$PostDate,
  [Parameter(Mandatory=$true)][ValidateSet('image','video')][string]$ContentType,
  [string]$LinkPlatform = 'Store',
  [string]$LinkOk = 'Y',
  [decimal]$Sales = 0,
  [string]$ConversionRate = '0',
  [int]$Impressions = 0,
  [int]$Clicks = 0,
  [string]$SpreadsheetToken = 'OGFpsQDIchiUNOtMojCcI83Anc8',
  [string]$SheetId = 'KKYET3',
  [string]$LarkHome = ''
)

$ErrorActionPreference = 'Stop'

if ($LarkHome) {
  $env:USERPROFILE = $LarkHome
  $env:HOME = $LarkHome
}

$duplicate = lark-cli.cmd sheets +cells-search --spreadsheet-token $SpreadsheetToken --sheet-id $SheetId --find $PostUrl --as user --format json | ConvertFrom-Json
if ($duplicate.data.total_matches -gt 0) {
  Write-Output (@{
    ok = $true
    skipped = $true
    reason = 'duplicate'
    matches = $duplicate.data.matches
  } | ConvertTo-Json -Depth 6)
  exit 0
}

$typeValue = if ($ContentType -eq 'video') {
  [char]0x89C6 + [char]0x9891
} else {
  [char]0x56FE + [char]0x7247
}

$range = "B${Row}:S${Row}"
$cells = @(
  @(
    @{ value = $BD },
    @{ value = $Handle },
    @{}, @{}, @{}, @{}, @{}, @{}, @{},
    @{ value = $typeValue },
    @{ multiple_values = @( @{ value = $LinkPlatform } ) },
    @{ value = $LinkOk },
    @{ value = $Sales },
    @{ value = $ConversionRate },
    @{ value = $PostDate },
    @{ rich_text = @( @{ type = 'link'; text = $PostUrl; link = $PostUrl } ) },
    @{ value = $Impressions },
    @{ value = $Clicks }
  )
)

$json = $cells | ConvertTo-Json -Depth 8 -Compress
$write = $json | lark-cli.cmd sheets +cells-set --spreadsheet-token $SpreadsheetToken --sheet-id $SheetId --range $range --cells - --as user --format json | ConvertFrom-Json

$verifyRange = "A${Row}:AA${Row}"
$verify = lark-cli.cmd sheets +cells-get --spreadsheet-token $SpreadsheetToken --sheet-id $SheetId --range $verifyRange --include value,formula,style --as user --format json | ConvertFrom-Json

Write-Output (@{
  ok = $true
  skipped = $false
  row = $Row
  write = $write.data
  verify = $verify.data.ranges[0].cells[0]
} | ConvertTo-Json -Depth 10)
