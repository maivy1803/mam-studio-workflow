# Mam_Studio_Kit - trinh cai cho Windows (PowerShell 5.1+). Ban macOS: install.sh
# Cai: 4 skill (hoac plugin), bo nho du an, tai nguyen, mau CLAUDE.md, model whisper (tuy chon).
# Dung: powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 [-Yes] [-Project <thu_muc>] [-Mode skills|plugin]
#        [-Model] [-NoModel] [-NoMemory] [-NoResources] [-ClaudeMd] [-NoClaudeMd] [-ClaudeHome <thu_muc>]
# An toan: file/thu muc da co ma khong phai do bo cai dat thi HOI truoc khi thay (ban cu duoc sao luu).
# Moi thu bo cai dat duoc ghi vao so <ClaudeHome>\mam-studio-kit.install.txt; uninstall chi go nhung thu trong so.
# Ghi chu: chu trong file giu ASCII (khong dau) vi PowerShell 5.1 doc sai file khong BOM co chu Unicode.
param(
    [switch]$Yes,
    [string]$Project = '',
    [ValidateSet('skills', 'plugin')][string]$Mode = 'skills',
    [switch]$Model,
    [switch]$NoModel,
    [switch]$NoMemory,
    [switch]$NoResources,
    [switch]$ClaudeMd,
    [switch]$NoClaudeMd,
    [string]$ClaudeHome = '',
    [switch]$Help
)
$ErrorActionPreference = 'Stop'
$KitDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($Help) { Get-Content -LiteralPath $MyInvocation.MyCommand.Path -TotalCount 6 | ForEach-Object { $_.TrimStart('# ') }; exit 0 }
$Version = '1.1.0'; if (Test-Path -LiteralPath (Join-Path $KitDir 'VERSION')) { $Version = (Get-Content -LiteralPath (Join-Path $KitDir 'VERSION') -Raw).Trim() }
if (-not $ClaudeHome) { if ($env:CLAUDE_CONFIG_DIR) { $ClaudeHome = $env:CLAUDE_CONFIG_DIR } else { $ClaudeHome = Join-Path $env:USERPROFILE '.claude' } }
$ModelUrl = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin'
$ModelFile = Join-Path $env:USERPROFILE '.cache\whisper\ggml-large-v3-turbo-q5_0.bin'
$TS = Get-Date -Format 'yyyyMMdd-HHmmss'
$Utf8 = New-Object System.Text.UTF8Encoding $false
$Rec = Join-Path $ClaudeHome 'mam-studio-kit.install.txt'

function Say($m) { Write-Host $m }
function Ok($m) { Write-Host ("  [OK] " + $m) -ForegroundColor Green }
function Warn($m) { Write-Host ("  [!]  " + $m) -ForegroundColor Yellow }
function Ask($q, $def) {
    if ($Yes) { return ($def -eq 'y') }
    $hint = 'y/N'; if ($def -eq 'y') { $hint = 'Y/n' }
    $a = Read-Host ("{0} [{1}]" -f $q, $hint)
    if (-not $a) { $a = $def }
    return ($a -match '^(y|yes|c|co)$')
}
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Sha($p) { return (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.ToLower() }

# ---------- So cai dat: doc so cu (neu co) de biet thu nao la cua bo cai ----------
$Prev = @{}; $PrevLines = @{}; $Entries = New-Object System.Collections.ArrayList
if (Test-Path -LiteralPath $Rec) {
    foreach ($l in [System.IO.File]::ReadAllLines($Rec, $Utf8)) {
        $p = $l -split "`t", 5
        if ($p.Count -eq 5 -and $p[0] -match '^[FDLPM]$') {
            $e = [pscustomobject]@{ Kind = $p[0]; Group = $p[1]; Path = $p[2]; Hash = $p[3]; Extra = $p[4] }
            if ($e.Kind -eq 'L') { $PrevLines[$e.Path + "`t" + $e.Extra] = $e } else { $Prev[$e.Kind + "`t" + $e.Path] = $e }
        } elseif ($l -match '^skills=(.*)$') {
            # so cua ban 1.0.0: chi ghi ten skill
            foreach ($s in ($Matches[1] -split '\s+')) { if ($s) { $d = Join-Path $ClaudeHome ('skills\' + $s); $Prev["D`t$d"] = [pscustomobject]@{ Kind = 'D'; Group = 'skills'; Path = $d; Hash = ''; Extra = '' } } }
        }
    }
}
function Add-Entry($kind, $group, $path, $hash, $extra) { [void]$Entries.Add([pscustomobject]@{ Kind = $kind; Group = $group; Path = $path; Hash = $hash; Extra = $extra }) }
function Save-Record {
    $lines = @("# Mam_Studio_Kit - so cai dat. Dung uninstall de go; dung sua tay.", "version=$Version", "date=$TS", "mode=$Mode", "project=$Project", "memdir=$memDir")
    foreach ($e in $Entries) { $lines += ($e.Kind, $e.Group, $e.Path, $e.Hash, $e.Extra) -join "`t" }
    New-Item -ItemType Directory -Force -Path $ClaudeHome | Out-Null
    [System.IO.File]::WriteAllLines($Rec, [string[]]$lines, $Utf8)
}
$GroupAnswer = @{}
# Chep mot file. Quy tac: chua co -> chep; giong het -> giu; la file bo cai dat truoc va chua bi sua -> thay;
# con lai (file cua nguoi dung hoac da bi sua) -> hoi (moi nhom hoi 1 lan), dong y thi sao luu roi thay.
function Install-File($src, $dst, $group, $bkRoot, $label) {
    $old = $Prev["F`t$dst"]
    if (-not (Test-Path -LiteralPath $dst)) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
        Copy-Item -LiteralPath $src -Destination $dst
        $bk = ''; if ($old) { $bk = $old.Extra }
        Add-Entry 'F' $group $dst (Sha $dst) $bk; return 'new'
    }
    $cur = Sha $dst; $new = Sha $src
    if ($cur -eq $new) { if ($old) { Add-Entry 'F' $group $dst $cur $old.Extra }; return 'same' }
    if ($old -and $old.Hash -eq $cur) {
        Copy-Item -LiteralPath $src -Destination $dst -Force; Add-Entry 'F' $group $dst $new $old.Extra; return 'upd'
    }
    if (-not $GroupAnswer.ContainsKey($group)) { $GroupAnswer[$group] = (Ask ("  Da co file khac ban cua bo cai ({0}). Thay bang ban moi? Ban cu se duoc sao luu" -f $label) 'y') }
    if (-not $GroupAnswer[$group]) { if ($old) { Add-Entry 'F' $group $dst $old.Hash $old.Extra }; return 'kept' }
    $rel = Split-Path -Leaf $dst
    $bk = Join-Path $bkRoot $rel; $i = 1; while (Test-Path -LiteralPath $bk) { $bk = Join-Path $bkRoot ("$i-$rel"); $i++ }
    New-Item -ItemType Directory -Force -Path $bkRoot | Out-Null
    Copy-Item -LiteralPath $dst -Destination $bk
    Copy-Item -LiteralPath $src -Destination $dst -Force
    $keep = $bk; if ($old -and $old.Extra) { $keep = $old.Extra }
    Add-Entry 'F' $group $dst $new $keep; return 'backup'
}

Say '=================================================='
Say (" Mam_Studio_Kit {0}  -  cai tren Windows" -f $Version)
Say (" Thu muc Claude: {0}" -f $ClaudeHome)
if ($Prev.Count -gt 0) { Say ' (da co ban cai truoc: lan nay se cap nhat)' }
Say '=================================================='

# ---------- 1. Cong cu ----------
Say ''; Say '1) Kiem tra cong cu'
$need = @()
if (Have 'ffmpeg') {
    Ok ('ffmpeg: ' + ((& ffmpeg -hide_banner -version 2>$null | Select-Object -First 1)))
    $f = (& ffmpeg -hide_banner -filters 2>$null) -join "`n"
    if ($f -match ' whisper ') { Ok 'ffmpeg co bo loc whisper' } else { Warn 'ffmpeg chua co bo loc whisper (can ffmpeg 8+ ban day du)' }
} else { Warn 'chua co ffmpeg'; $need += 'Gyan.FFmpeg' }
if (Have 'node') { Ok ('node: ' + (& node -v)) } else { Warn 'chua co Node.js'; $need += 'OpenJS.NodeJS.LTS' }
$hasClaude = Have 'claude'
if ($hasClaude) { Ok 'claude CLI: co' } else { Warn "chua thay lenh 'claude' (khong bat buoc o che do skills)" }
$gitBash = @($env:CLAUDE_CODE_GIT_BASH_PATH, (Join-Path $env:ProgramFiles 'Git\bin\bash.exe'), (Join-Path ${env:ProgramFiles(x86)} 'Git\bin\bash.exe'), (Join-Path $env:LOCALAPPDATA 'Programs\Git\bin\bash.exe')) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
if ((Have 'bash') -or $gitBash) { Ok 'Git Bash: co' } else { Warn 'chua co Git Bash (Git for Windows: winget install Git.Git). Claude Code tren Windows can no de chay cac script .sh' }
if ($need.Count -gt 0) {
    if ((Have 'winget') -and (Ask ('Cai ' + ($need -join ', ') + ' bang winget?') 'n')) {
        foreach ($p in $need) { & winget install -e --id $p --accept-source-agreements }
    } else { Warn ('Hay tu cai: winget install ' + ($need -join ' ')) }
}

# ---------- 2. Thu muc du an ----------
if (-not $Project) {
    $cand = (Get-Location).Path
    if (-not (Test-Path -LiteralPath (Join-Path $cand 'Halo_Cub'))) {
        $up = Split-Path -Parent (Split-Path -Parent $KitDir)
        if ($up -and (Test-Path -LiteralPath (Join-Path $up 'Halo_Cub'))) { $cand = $up } else { $cand = '' }
    }
    $Project = $cand
    if (-not $Yes) {
        $show = $Project; if (-not $show) { $show = 'bo qua' }
        $a = Read-Host ("Thu muc du an Mam_Studio (chua Halo_Cub) [{0}]" -f $show)
        if ($a) { $Project = $a.Trim('"') }
    }
}
$slug = ''; $memDir = ''
if ($Project) {
    if (-not (Test-Path -LiteralPath $Project)) {
        if (Ask ("Chua co thu muc {0}. Tao moi?" -f $Project) 'y') { New-Item -ItemType Directory -Force -Path $Project | Out-Null } else { $Project = '' }
    }
}
if ($Project) {
    $Project = (Resolve-Path -LiteralPath $Project).Path
    if ($Project -match '^[a-z]:') { $Project = $Project.Substring(0, 1).ToUpper() + $Project.Substring(1) }
    $slug = $Project -replace '[^a-zA-Z0-9]', '-'
    if ($slug.Length -gt 200) { Warn 'Ten thu muc du an qua dai (>200 ky tu): bo nho co the khong khop' }
    $memDir = Join-Path $ClaudeHome ("projects\" + $slug + "\memory")
    Say ''; Say ("   Du an: {0}" -f $Project); Say ("   Bo nho: {0}" -f $memDir)
}

# ---------- 3. Skill / plugin ----------
Say ''; Say ("3) Cai skill (che do: {0})" -f $Mode)
$SkillSrc = Join-Path $KitDir 'plugins\mam-studio\skills'
function Install-Dir($src, $dst, $group, $bkRoot, $label, [switch]$Contents) {
    $old = $Prev["D`t$dst"]; $bk = ''; if ($old) { $bk = $old.Extra }
    if (Test-Path -LiteralPath $dst) {
        if ($old) { Remove-Item -LiteralPath $dst -Recurse -Force -Confirm:$false }
        elseif (Ask ("  Da co {0} (khong phai do bo cai dat). Thay bang ban moi? Ban cu se duoc sao luu" -f $label) 'y') {
            New-Item -ItemType Directory -Force -Path $bkRoot | Out-Null
            $bk = Join-Path $bkRoot (Split-Path -Leaf $dst); Move-Item -LiteralPath $dst -Destination $bk
            Warn ('da sao luu ban cu: ' + $bk)
        } else { Warn ('giu nguyen ' + $dst + ' (khong cai)'); return $false }
    }
    if ($Contents) { New-Item -ItemType Directory -Force -Path $dst | Out-Null; Get-ChildItem -LiteralPath $src -Force | Copy-Item -Destination $dst -Recurse -Force }
    else { Copy-Item -LiteralPath $src -Destination $dst -Recurse }
    Add-Entry 'D' $group $dst '' $bk; return $true
}
if ($Mode -eq 'plugin') {
    if (-not $hasClaude) { Warn "Che do plugin can lenh 'claude'. Chay lai voi -Mode skills."; exit 1 }
    $dest = Join-Path $ClaudeHome 'mam-studio-kit'
    if (Install-Dir $KitDir $dest 'plugin' (Join-Path $ClaudeHome (".backup-mam-studio-" + $TS)) 'thu muc mam-studio-kit' -Contents) {
        & claude plugin marketplace add $dest
        & claude plugin install 'mam-studio@mam-studio-kit'
        if ($LASTEXITCODE -eq 0) { Add-Entry 'M' 'plugin' 'mam-studio-kit' '' ''; Add-Entry 'P' 'plugin' 'mam-studio@mam-studio-kit' '' ''; Ok 'plugin mam-studio da cai (goi skill: /mam-studio:<ten>)' }
        else { Warn 'claude plugin install bao loi' }
    }
} else {
    $skDir = Join-Path $ClaudeHome 'skills'
    New-Item -ItemType Directory -Force -Path $skDir | Out-Null
    Get-ChildItem -LiteralPath $SkillSrc -Directory | ForEach-Object {
        $t = Join-Path $skDir $_.Name
        if (Install-Dir $_.FullName $t 'skills' (Join-Path $skDir (".backup-mam-studio-" + $TS)) ('skill ' + $_.Name)) { Ok ("skill {0} -> {1}" -f $_.Name, $t) }
    }
}
# giu lai muc skill/plugin cua so cu ma lan nay khong dong toi (vd. doi che do)
foreach ($k in $Prev.Keys) { $e = $Prev[$k]; if ($e.Group -in @('skills', 'plugin') -and -not ($Entries | Where-Object { $_.Kind -eq $e.Kind -and $_.Path -eq $e.Path })) { [void]$Entries.Add($e) } }
Save-Record

# ---------- 4. Bo nho ----------
if ((-not $NoMemory) -and $memDir) {
    Say ''; Say '4) Cai bo nho du an'
    New-Item -ItemType Directory -Force -Path $memDir | Out-Null
    $bkMem = Join-Path $memDir ('.backup-mam-studio-' + $TS)
    Get-ChildItem -LiteralPath (Join-Path $KitDir 'memory') -Filter '*.md' | Where-Object { $_.Name -ne 'MEMORY.md' } | ForEach-Object {
        $nm = $_.Name
        $res = Install-File $_.FullName (Join-Path $memDir $nm) 'memory' $bkMem ('bo nho ' + $nm)
        switch ($res) { 'new' { Ok ('them ' + $nm) } 'same' { Ok ('giu ' + $nm + ' (giong nhau)') } 'upd' { Ok ('cap nhat ' + $nm) } 'backup' { Warn ('cap nhat ' + $nm + ' (ban cu o ' + $bkMem + ')') } 'kept' { Warn ('giu ban dang co cua ' + $nm) } }
    }
    $idx = Join-Path $memDir 'MEMORY.md'; $kitIdx = Join-Path $KitDir 'memory\MEMORY.md'
    if (-not (Test-Path -LiteralPath $idx)) { Copy-Item -LiteralPath $kitIdx -Destination $idx; Add-Entry 'F' 'memory' $idx (Sha $idx) ''; Ok 'them MEMORY.md' }
    elseif ($Prev["F`t$idx"] -and $Prev["F`t$idx"].Hash -eq (Sha $idx)) { Copy-Item -LiteralPath $kitIdx -Destination $idx -Force; Add-Entry 'F' 'memory' $idx (Sha $idx) $Prev["F`t$idx"].Extra; Ok 'cap nhat MEMORY.md' }
    else {
        if ($Prev["F`t$idx"]) { $o = $Prev["F`t$idx"]; Add-Entry 'F' 'memory' $idx $o.Hash $o.Extra }
        $cur = [System.IO.File]::ReadAllText($idx, $Utf8)
        foreach ($k in $PrevLines.Keys) { $e = $PrevLines[$k]; if ($e.Path -eq $idx -and $cur.Contains($e.Extra)) { [void]$Entries.Add($e) } }
        foreach ($line in [System.IO.File]::ReadAllLines($kitIdx, $Utf8)) {
            $m = [regex]::Match($line, '\]\(([^)]*\.md)\)')
            if (-not $m.Success) { continue }
            if ($cur.Contains('](' + $m.Groups[1].Value + ')')) { continue }
            if (-not $cur.EndsWith("`n")) { $cur += "`n" }
            $cur += $line + "`n"; Add-Entry 'L' 'memory' $idx '' $line; Ok ('MEMORY.md + ' + $m.Groups[1].Value)
        }
        [System.IO.File]::WriteAllText($idx, $cur, $Utf8)
    }
    Save-Record
} elseif (-not $NoMemory) { Warn 'Bo qua bo nho (chua co thu muc du an). Chay lai voi -Project <thu_muc>.' }

# ---------- 5. Tai nguyen ----------
if ((-not $NoResources) -and $Project) {
    $ResDir = Join-Path $Project '_Mam_Studio_Kit'
    Say ''; Say ('5) Chep tai nguyen -> ' + $ResDir)
    $bkRes = Join-Path $ResDir ('.backup-' + $TS)
    $pairs = New-Object System.Collections.ArrayList
    $base = (Join-Path $KitDir 'tai_nguyen')
    Get-ChildItem -LiteralPath $base -Recurse -File | ForEach-Object { [void]$pairs.Add(@($_.FullName, ('tai_nguyen\' + $_.FullName.Substring($base.Length).TrimStart('\')))) }
    [void]$pairs.Add(@((Join-Path $KitDir 'README.md'), 'README.md'))
    [void]$pairs.Add(@((Join-Path $KitDir 'VERSION'), 'VERSION'))
    [void]$pairs.Add(@((Join-Path $SkillSrc 'thay-nhan-vat-clip-goc\references\quy_trinh_day_du.md'), 'quy_trinh\quy_trinh_day_du.md'))
    $n = @{ new = 0; same = 0; upd = 0; backup = 0; kept = 0 }
    foreach ($p in $pairs) { $res = Install-File $p[0] (Join-Path $ResDir $p[1]) 'resources' (Join-Path $bkRes (Split-Path -Parent $p[1])) ('trong ' + $ResDir); $n[$res]++ }
    Ok ("{0} file moi, {1} cap nhat, {2} giu nguyen" -f $n.new, ($n.upd + $n.backup), ($n.same + $n.kept))
    if ($n.backup -gt 0) { Warn ('ban cu da sao luu o ' + $bkRes) }
    Save-Record
}

# ---------- 6. CLAUDE.md mau ----------
if ($Project -and (-not $NoClaudeMd)) {
    $cm = Join-Path $Project 'CLAUDE.md'; $old = $Prev["F`t$cm"]
    if (Test-Path -LiteralPath $cm) {
        if ($old) { Add-Entry 'F' 'claudemd' $cm $old.Hash $old.Extra; Ok 'giu CLAUDE.md da tao lan truoc' }
        else { Warn 'Du an da co CLAUDE.md: giu nguyen (mau o _Mam_Studio_Kit\tai_nguyen\mau_du_an\CLAUDE.md)' }
    } elseif ($ClaudeMd -or (Ask 'Tao CLAUDE.md (quy tac Mam_Studio) o goc du an?' 'y')) {
        Copy-Item -LiteralPath (Join-Path $KitDir 'tai_nguyen\mau_du_an\CLAUDE.md') -Destination $cm; Add-Entry 'F' 'claudemd' $cm (Sha $cm) ''; Ok ('tao ' + $cm)
    }
}

# ---------- 7. Model whisper ----------
Say ''; Say '7) Model whisper (chep loi clip goc)'
if (Test-Path -LiteralPath $ModelFile) { if ($Prev["F`t$ModelFile"]) { [void]$Entries.Add($Prev["F`t$ModelFile"]) }; Ok ('da co ' + $ModelFile) }
elseif ($Model -or ((-not $NoModel) -and (-not $Yes) -and (Ask ('Tai model whisper 574 MB tu huggingface.co ve ' + $ModelFile + '?') 'n'))) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ModelFile) | Out-Null
    & curl.exe -L --fail -o ($ModelFile + '.part') $ModelUrl
    if ($LASTEXITCODE -eq 0) { Move-Item -LiteralPath ($ModelFile + '.part') -Destination $ModelFile; Add-Entry 'F' 'model' $ModelFile '' ''; Ok 'da tai model' } else { Warn 'tai model loi' }
} else { Warn 'Bo qua. Tai sau: install.ps1 -Model -NoMemory -NoResources' }

# giu lai cac muc cua so cu ma lan nay bo qua (vd. -NoMemory) de uninstall van go duoc
foreach ($k in $Prev.Keys) { $e = $Prev[$k]; if (-not ($Entries | Where-Object { $_.Kind -eq $e.Kind -and $_.Path -eq $e.Path })) { [void]$Entries.Add($e) } }
foreach ($k in $PrevLines.Keys) { $e = $PrevLines[$k]; if (-not ($Entries | Where-Object { $_.Kind -eq 'L' -and $_.Path -eq $e.Path -and $_.Extra -eq $e.Extra })) { [void]$Entries.Add($e) } }
Save-Record
Say ''; Say ('Xong. So cai dat: ' + $Rec)
Say 'Tiep theo: khoi dong lai Claude Code / app Claude, mo thu muc du an, nho Claude dung skill mam-studio-quy-tac.'
