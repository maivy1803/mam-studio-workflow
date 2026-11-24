# ghep_storyboard.ps1 - compose storyboard panels into PNG sheets (Windows PowerShell 5.1, System.Drawing).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File ghep_storyboard.ps1 -Manifest <manifest.json> -OutDir <dir> [-Cols 3] [-Rows 2] [-PanelWidth 640] [-SafeZone916]
# Manifest (UTF-8 JSON):
#   { "title": "...", "panels": [ { "id": "S01", "frames": "f1-51 (2.13s)", "framing": "...", "action": "...", "dialogue": "...", "image": "flow/SB_S01.jpg" } ] }
# "image" may be absolute or relative to the manifest file. Text in the manifest can be Vietnamese (Arial covers it).
# Script literals are kept ASCII on purpose: PowerShell 5.1 misreads non-ASCII in BOM-less script files.

param(
    [Parameter(Mandatory = $true)][string]$Manifest,
    [Parameter(Mandatory = $true)][string]$OutDir,
    [int]$Cols = 3,
    [int]$Rows = 2,
    [int]$PanelWidth = 640,
    [switch]$SafeZone916
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$manifestPath = (Resolve-Path -LiteralPath $Manifest).Path
$baseDir = Split-Path -Parent $manifestPath
$data = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$panels = @($data.panels)
if ($panels.Count -eq 0) { throw "Manifest has no panels." }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$imgW = $PanelWidth
$imgH = [int][math]::Round($PanelWidth * 9 / 16)
$capH = 150
$pad = 24
$headerH = 64
$cellW = $imgW
$cellH = $imgH + $capH
$pageW = $pad + $Cols * ($cellW + $pad)
$pageH = $headerH + $pad + $Rows * ($cellH + $pad)

$px = [System.Drawing.GraphicsUnit]::Pixel
$fTitle = New-Object System.Drawing.Font -ArgumentList 'Arial', ([single]22), ([System.Drawing.FontStyle]::Bold), $px
$fHead  = New-Object System.Drawing.Font -ArgumentList 'Arial', ([single]15), ([System.Drawing.FontStyle]::Bold), $px
$fBody  = New-Object System.Drawing.Font -ArgumentList 'Arial', ([single]13), ([System.Drawing.FontStyle]::Regular), $px
$fLine  = New-Object System.Drawing.Font -ArgumentList 'Arial', ([single]13), ([System.Drawing.FontStyle]::Italic), $px
$bBlack = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(20, 20, 20))
$bGrey  = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(85, 85, 85))
$bLine  = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(30, 70, 140))
$bMiss  = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(225, 225, 225))
$pFrame = New-Object System.Drawing.Pen -ArgumentList ([System.Drawing.Color]::FromArgb(40, 40, 40)), ([single]2)
$pSafe  = New-Object System.Drawing.Pen -ArgumentList ([System.Drawing.Color]::FromArgb(220, 230, 40, 40)), ([single]2)
$pSafe.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash

function New-RectF([double]$x, [double]$y, [double]$w, [double]$h) {
    return New-Object System.Drawing.RectangleF -ArgumentList ([single]$x), ([single]$y), ([single]$w), ([single]$h)
}

$perPage = $Cols * $Rows
$pages = [int][math]::Ceiling($panels.Count / $perPage)

for ($p = 0; $p -lt $pages; $p++) {
    $bmp = New-Object System.Drawing.Bitmap -ArgumentList $pageW, $pageH
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.Clear([System.Drawing.Color]::White)
    $titleText = "{0}   |   {1}/{2}" -f [string]$data.title, ($p + 1), $pages
    $g.DrawString($titleText, $fTitle, $bBlack, (New-RectF $pad 18 ($pageW - 2 * $pad) 34))

    for ($i = 0; $i -lt $perPage; $i++) {
        $idx = $p * $perPage + $i
        if ($idx -ge $panels.Count) { break }
        $pn = $panels[$idx]
        $c = $i % $Cols
        $r = [int][math]::Floor($i / $Cols)
        $x = [int]($pad + $c * ($cellW + $pad))
        $y = [int]($headerH + $pad + $r * ($cellH + $pad))

        $imgPath = [string]$pn.image
        if ($imgPath -and -not [System.IO.Path]::IsPathRooted($imgPath)) { $imgPath = Join-Path $baseDir $imgPath }
        $dest = New-Object System.Drawing.Rectangle -ArgumentList $x, $y, $imgW, $imgH
        if ($imgPath -and (Test-Path -LiteralPath $imgPath)) {
            $src = [System.Drawing.Image]::FromFile($imgPath)
            # cover-fit the source into the 16:9 box (center crop)
            $sr = $src.Width / $src.Height
            $dr = $imgW / $imgH
            if ($sr -gt $dr) { $sh = $src.Height; $sw = [int]($sh * $dr); $sx = [int](($src.Width - $sw) / 2); $sy = 0 }
            else { $sw = $src.Width; $sh = [int]($sw / $dr); $sx = 0; $sy = [int](($src.Height - $sh) / 2) }
            $srcRect = New-Object System.Drawing.Rectangle -ArgumentList $sx, $sy, $sw, $sh
            $g.DrawImage($src, $dest, $srcRect, $px)
            $src.Dispose()
        } else {
            $g.FillRectangle($bMiss, $dest)
            $g.DrawString(("Missing image: " + [string]$pn.image), $fBody, $bBlack, (New-RectF ($x + 10) ($y + 10) ($imgW - 20) 60))
        }
        if ($SafeZone916) {
            $sw916 = $imgH * 9 / 16
            $g.DrawRectangle($pSafe, [single]($x + ($imgW - $sw916) / 2), [single]$y, [single]$sw916, [single]$imgH)
        }
        $g.DrawRectangle($pFrame, $dest)

        $head = "{0}    {1}    {2}" -f [string]$pn.id, [string]$pn.frames, [string]$pn.framing
        $g.DrawString($head, $fHead, $bBlack, (New-RectF $x ($y + $imgH + 6) $imgW 22))
        $g.DrawString([string]$pn.action, $fBody, $bGrey, (New-RectF $x ($y + $imgH + 30) $imgW 64))
        if ($pn.dialogue) {
            $g.DrawString([string]$pn.dialogue, $fLine, $bLine, (New-RectF $x ($y + $imgH + 96) $imgW 52))
        }
    }

    $out = Join-Path $OutDir ("storyboard_trang_{0:D2}.png" -f ($p + 1))
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Output ("Wrote " + $out)
}
