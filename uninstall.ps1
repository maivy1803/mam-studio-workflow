# Go Mam_Studio_Kit (Windows). Chi go nhung thu ghi trong so cai dat <ClaudeHome>\mam-studio-kit.install.txt.
# Dung: powershell -NoProfile -ExecutionPolicy Bypass -File uninstall.ps1 [-All] [-Yes] [-ClaudeHome <thu_muc>]
#   Mac dinh: go skill/plugin, roi hoi co go ca bo nho, tai nguyen, CLAUDE.md, model whisper khong (mac dinh: khong).
#   -All: go ca nhung thu do. -Yes: khong hoi (chi go skill/plugin, tru khi co -All).
#   File da bi sua sau khi cai thi giu lai. File cu bi thay luc cai (co sao luu) thi duoc tra ve cho cu.
param([switch]$All, [switch]$Yes, [string]$ClaudeHome = '')
$ErrorActionPreference = 'Stop'
if (-not $ClaudeHome) { if ($env:CLAUDE_CONFIG_DIR) { $ClaudeHome = $env:CLAUDE_CONFIG_DIR } else { $ClaudeHome = Join-Path $env:USERPROFILE '.claude' } }
$Utf8 = New-Object System.Text.UTF8Encoding $false
$Rec = Join-Path $ClaudeHome 'mam-studio-kit.install.txt'
function Ok($m) { Write-Host ("  [OK] " + $m) -ForegroundColor Green }
function Warn($m) { Write-Host ("  [!]  " + $m) -ForegroundColor Yellow }
function Ask($q, $def) {
    if ($Yes) { return ($def -eq 'y') }
    $hint = 'y/N'; if ($def -eq 'y') { $hint = 'Y/n' }
    $a = Read-Host ("{0} [{1}]" -f $q, $hint); if (-not $a) { $a = $def }
    return ($a -match '^(y|yes|c|co)$')
}
if (-not (Test-Path -LiteralPath $Rec)) { Write-Host ('Khong thay so cai dat ' + $Rec + ' (chua cai, hoac da go).'); exit 1 }

$head = @{}; $entries = New-Object System.Collections.ArrayList
foreach ($l in [System.IO.File]::ReadAllLines($Rec, $Utf8)) {
    $p = $l -split "`t", 5
    if ($p.Count -eq 5 -and $p[0] -match '^[FDLPM]$') { [void]$entries.Add([pscustomobject]@{ Kind = $p[0]; Group = $p[1]; Path = $p[2]; Hash = $p[3]; Extra = $p[4] }) }
    elseif ($l -match '^([a-z]+)=(.*)$') { $head[$Matches[1]] = $Matches[2].Trim() }
}
if ($entries.Count -eq 0 -and $head['skills']) {
    # so cua ban 1.0.0
    foreach ($s in ($head['skills'] -split '\s+')) { if ($s) { [void]$entries.Add([pscustomobject]@{ Kind = 'D'; Group = 'skills'; Path = (Join-Path $ClaudeHome ('skills\' + $s)); Hash = ''; Extra = '' }) } }
    if ($head['mode'] -eq 'plugin') { [void]$entries.Add([pscustomobject]@{ Kind = 'D'; Group = 'plugin'; Path = (Join-Path $ClaudeHome 'mam-studio-kit'); Hash = ''; Extra = '' }); [void]$entries.Add([pscustomobject]@{ Kind = 'M'; Group = 'plugin'; Path = 'mam-studio-kit'; Hash = ''; Extra = '' }); [void]$entries.Add([pscustomobject]@{ Kind = 'P'; Group = 'plugin'; Path = 'mam-studio@mam-studio-kit'; Hash = ''; Extra = '' }) }
}

Write-Host '=================================================='
Write-Host (' Go Mam_Studio_Kit {0}  (cai ngay {1})' -f $head['version'], $head['date'])
Write-Host '=================================================='
$hasOther = [bool]($entries | Where-Object { $_.Group -notin @('skills', 'plugin') })
$doAll = $All
if (-not $doAll -and $hasOther) { $doAll = Ask 'Go ca bo nho, tai nguyen, CLAUDE.md va model do bo cai dat? (file da sua sau khi cai van duoc giu)' 'n' }
$groups = @('skills', 'plugin'); if ($doAll) { $groups += @('memory', 'resources', 'claudemd', 'model') }

function Restore($e) {
    if ($e.Extra -and (Test-Path -LiteralPath $e.Extra) -and -not (Test-Path -LiteralPath $e.Path)) {
        Move-Item -LiteralPath $e.Extra -Destination $e.Path; Ok ('tra lai ban cu: ' + $e.Path)
    }
}
$left = New-Object System.Collections.ArrayList
for ($i = $entries.Count - 1; $i -ge 0; $i--) {
    $e = $entries[$i]
    if ($e.Group -notin $groups) { [void]$left.Insert(0, $e); continue }
    switch ($e.Kind) {
        'P' { if (Get-Command claude -ErrorAction SilentlyContinue) { try { & claude plugin uninstall $e.Path } catch {} }; Ok ('go plugin ' + $e.Path) }
        'M' { if (Get-Command claude -ErrorAction SilentlyContinue) { try { & claude plugin marketplace remove $e.Path } catch {} }; Ok ('go marketplace ' + $e.Path) }
        'D' { if (Test-Path -LiteralPath $e.Path) { Remove-Item -LiteralPath $e.Path -Recurse -Force -Confirm:$false; Ok ('go ' + $e.Path) }; Restore $e }
        'F' {
            if (Test-Path -LiteralPath $e.Path) {
                $h = (Get-FileHash -LiteralPath $e.Path -Algorithm SHA256).Hash.ToLower()
                if (-not $e.Hash -or $h -eq $e.Hash) { Remove-Item -LiteralPath $e.Path -Force -Confirm:$false; Ok ('go ' + $e.Path); Restore $e }
                else { Warn ('giu ' + $e.Path + ' (da sua sau khi cai)'); if ($e.Extra -and (Test-Path -LiteralPath $e.Extra)) { Warn ('  ban truoc khi cai van o ' + $e.Extra) } }
            } else { Restore $e }
        }
        'L' {
            if (Test-Path -LiteralPath $e.Path) {
                $lines = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($e.Path, $Utf8))
                $k = $lines.IndexOf($e.Extra)
                if ($k -ge 0) { $lines.RemoveAt($k); [System.IO.File]::WriteAllText($e.Path, (($lines -join "`n") + "`n"), $Utf8); Ok ('bo dong khoi ' + $e.Path) }
            }
        }
    }
}
# Don thu muc rong do bo cai tao (tai nguyen, thu muc sao luu rong)
function Remove-EmptyDirs($root) {
    if (-not $root -or -not (Test-Path -LiteralPath $root)) { return }
    Get-ChildItem -LiteralPath $root -Recurse -Directory -Force | Sort-Object { $_.FullName.Length } -Descending | ForEach-Object {
        if (-not (Get-ChildItem -LiteralPath $_.FullName -Force)) { Remove-Item -LiteralPath $_.FullName -Force -Confirm:$false }
    }
    if (-not (Get-ChildItem -LiteralPath $root -Force)) { Remove-Item -LiteralPath $root -Force -Confirm:$false }
}
if ($doAll -and $head['project']) { Remove-EmptyDirs (Join-Path $head['project'] '_Mam_Studio_Kit') }
foreach ($d in @((Join-Path $ClaudeHome 'skills'), $head['memdir'], $ClaudeHome)) {
    if ($d -and (Test-Path -LiteralPath $d)) { Get-ChildItem -LiteralPath $d -Directory -Force -Filter '.backup-mam-studio-*' | ForEach-Object { Remove-EmptyDirs $_.FullName } }
}

if ($left.Count -gt 0) {
    $out = @('# Mam_Studio_Kit - so cai dat (phan con lai sau khi go). Dung uninstall -All de go not.')
    foreach ($k in 'version', 'date', 'mode', 'project', 'memdir') { $out += ($k + '=' + $head[$k]) }
    foreach ($e in $left) { $out += ($e.Kind, $e.Group, $e.Path, $e.Hash, $e.Extra) -join "`t" }
    [System.IO.File]::WriteAllLines($Rec, [string[]]$out, $Utf8)
    Write-Host ('Xong. Con giu bo nho/tai nguyen; so van o ' + $Rec + ' (go not: uninstall -All).')
} else {
    Remove-Item -LiteralPath $Rec -Force -Confirm:$false
    Write-Host 'Xong. Da go het nhung gi bo cai dat.'
}
