# ============================================================
#  三大工作机制插件 — 跨框架安装脚本 (Windows PowerShell)
# ============================================================

param(
    [switch]$Force,
    [string]$ProjectRoot
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  三大工作机制插件 — 安装脚本" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ---------- 检测项目根目录 ----------
if ($ProjectRoot) {
    if (-not (Test-Path $ProjectRoot)) {
        New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
    }
    $ProjectRoot = (Resolve-Path $ProjectRoot).Path
} else {
    $ProjectRoot = Get-Location
}

Write-Host "目标项目: $ProjectRoot" -ForegroundColor Yellow
Write-Host ""

# ---------- 检测已安装的 AI 编码框架 ----------
$DetectedFrameworks = @()

if ((Test-Path "$ProjectRoot\.claude") -or (Test-Path "$ProjectRoot\CLAUDE.md")) {
    $DetectedFrameworks += "claude"
    Write-Host "  [✓] 检测到: Claude Code" -ForegroundColor Green
}

if ((Test-Path "$ProjectRoot\.cursor") -or (Test-Path "$ProjectRoot\.cursorrules")) {
    $DetectedFrameworks += "cursor"
    Write-Host "  [✓] 检测到: Cursor" -ForegroundColor Green
}

if (Test-Path "$ProjectRoot\.codex") {
    $DetectedFrameworks += "codex"
    Write-Host "  [✓] 检测到: Codex CLI" -ForegroundColor Green
}

if (Test-Path "$ProjectRoot\.trae") {
    $DetectedFrameworks += "trae"
    Write-Host "  [✓] 检测到: TRAE" -ForegroundColor Green
}

if (Test-Path "$ProjectRoot\.github") {
    $DetectedFrameworks += "copilot"
    Write-Host "  [✓] 检测到: GitHub Copilot" -ForegroundColor Green
}

if ((Test-Path "$ProjectRoot\.windsurf") -or (Test-Path "$ProjectRoot\.windsurfrules")) {
    $DetectedFrameworks += "windsurf"
    Write-Host "  [✓] 检测到: Windsurf" -ForegroundColor Green
}

if (Test-Path "$ProjectRoot\.aider.conf.yml") {
    $DetectedFrameworks += "aider"
    Write-Host "  [✓] 检测到: Aider" -ForegroundColor Green
}

if ($DetectedFrameworks.Count -eq 0) {
    Write-Host "  [!] 未检测到已知 AI 编码框架。" -ForegroundColor Yellow
    Write-Host "  将仅安装通用文件 (AGENTS.md + skills/)"
    Write-Host ""
}

Write-Host ""

# ---------- 安装 ----------
Write-Host "开始安装..." -ForegroundColor Cyan
Write-Host ""

# 1. AGENTS.md (条件追加)
$AgentsDest = Join-Path $ProjectRoot "AGENTS.md"
$AgentsSrc  = Join-Path $ScriptDir "AGENTS.md"
if ($Force) {
    if ((Test-Path $AgentsDest) -and ($AgentsDest -ne $AgentsSrc)) {
        Copy-Item $AgentsDest "$AgentsDest.bak" -Force
        Write-Host "  [!] AGENTS.md 已备份为 AGENTS.md.bak" -ForegroundColor Yellow
    }
    Copy-Item $AgentsSrc $AgentsDest -Force
    Write-Host "  [✓] 安装: AGENTS.md (强制覆盖)" -ForegroundColor Green
}
elseif (Test-Path $AgentsDest) {
    if (Select-String -Path $AgentsDest -Pattern "三大工作机制" -SimpleMatch -Quiet) {
        Write-Host "  [✓] AGENTS.md 已包含三大工作机制，跳过"
    }
    else {
        Add-Content -Path $AgentsDest -Value ""
        Add-Content -Path $AgentsDest -Value "<!-- BEGIN: 三大工作机制插件 -->"
        Get-Content -Path $AgentsSrc | Add-Content -Path $AgentsDest
        Add-Content -Path $AgentsDest -Value "<!-- END: 三大工作机制插件 -->"
        Write-Host "  [✓] 安装: AGENTS.md (内容已追加)" -ForegroundColor Green
    }
}
else {
    Copy-Item $AgentsSrc $AgentsDest
    Write-Host "  [✓] 安装: AGENTS.md (新建)" -ForegroundColor Green
}

# 2. CLAUDE.md (薄壳 shim)
$ClaudeDest = Join-Path $ProjectRoot "CLAUDE.md"
$ClaudeSrc  = Join-Path $ScriptDir "CLAUDE.md"
if ($Force) {
    if ((Test-Path $ClaudeDest) -and ($ClaudeDest -ne $ClaudeSrc)) {
        Copy-Item $ClaudeDest "$ClaudeDest.bak" -Force
        Write-Host "  [!] CLAUDE.md 已备份为 CLAUDE.md.bak" -ForegroundColor Yellow
    }
    Copy-Item $ClaudeSrc $ClaudeDest -Force
    Write-Host "  [✓] 安装: CLAUDE.md (强制覆盖)" -ForegroundColor Green
}
elseif (Test-Path $ClaudeDest) {
    if (Select-String -Path $ClaudeDest -Pattern '@AGENTS.md' -SimpleMatch -Quiet) {
        Write-Host "  [✓] CLAUDE.md 已含 @AGENTS.md，跳过"
    }
    else {
        Write-Host "  [!] CLAUDE.md 已存在但未引用 AGENTS.md" -ForegroundColor Yellow
        Write-Host "     请手动添加此行到 CLAUDE.md 开头: @AGENTS.md" -ForegroundColor Yellow
    }
}
else {
    @"
@AGENTS.md

# Claude Code 专用规则
# 三大工作机制核心准则通过 @AGENTS.md 加载。
# 如需添加 Claude Code 专属规则，请在下方追加。
"@ | Set-Content -Path $ClaudeDest -Encoding UTF8
    Write-Host "  [✓] 安装: CLAUDE.md (薄壳新建)" -ForegroundColor Green
}

# 3. skills/ 目录 (逐 skill 安装，避免覆盖已有同名 skill)
$SkillsSrc = Join-Path $ScriptDir "skills"
if (Test-Path $SkillsSrc) {
    $SkillsDest = Join-Path $ProjectRoot "skills"
    New-Item -ItemType Directory -Path $SkillsDest -Force | Out-Null
    Get-ChildItem -Path $SkillsSrc -Directory | ForEach-Object {
        $skillName = $_.Name
        $targetSkillDir = Join-Path $SkillsDest $skillName
        if (Test-Path $targetSkillDir) {
            if ($Force) {
                Copy-Item -Path $_.FullName -Destination $SkillsDest -Recurse -Force
                Write-Host "  [✓] 安装: skills/$skillName (强制覆盖)" -ForegroundColor Green
            }
            else {
                Write-Host "  [!] skills/$skillName 已存在(可能来自其他插件)，跳过" -ForegroundColor Yellow
            }
        }
        else {
            Copy-Item -Path $_.FullName -Destination $SkillsDest -Recurse
            Write-Host "  [✓] 安装: skills/$skillName" -ForegroundColor Green
        }
    }
}

# 3.5. .claude/commands/ (Claude Code 命令)
$CommandsSrc = Join-Path $ScriptDir ".claude\commands"
if (Test-Path $CommandsSrc) {
    $CommandsDest = Join-Path $ProjectRoot ".claude\commands"
    New-Item -ItemType Directory -Path $CommandsDest -Force | Out-Null
    Get-ChildItem -Path $CommandsSrc -File | ForEach-Object {
        $cmdName = $_.Name
        $targetCmdFile = Join-Path $CommandsDest $cmdName
        if (Test-Path $targetCmdFile) {
            if ($Force) {
                Copy-Item -Path $_.FullName -Destination $CommandsDest -Force
                Write-Host "  [✓] 安装: .claude/commands/$cmdName (强制覆盖)" -ForegroundColor Green
            }
            else {
                Write-Host "  [!] .claude/commands/$cmdName 已存在，跳过" -ForegroundColor Yellow
            }
        }
        else {
            Copy-Item -Path $_.FullName -Destination $CommandsDest
            Write-Host "  [✓] 安装: .claude/commands/$cmdName" -ForegroundColor Green
        }
    }
}

# 4. 框架专用规则文件
foreach ($fw in $DetectedFrameworks) {
    switch ($fw) {
        "claude" {
            $dest = "$ProjectRoot\.claude\rules"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            if (Test-Path "$ScriptDir\rules\claude-rules.md") {
                Copy-Item "$ScriptDir\rules\claude-rules.md" "$dest\three-mechanisms.md" -Force
                Write-Host "  [✓] 安装: .claude\rules\three-mechanisms.md" -ForegroundColor Green
            }
        }
        "cursor" {
            $dest = "$ProjectRoot\.cursor\rules"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item "$ScriptDir\rules\cursor-rules.mdc" "$dest\three-mechanisms.mdc" -Force
            Write-Host "  [✓] 安装: .cursor\rules\three-mechanisms.mdc" -ForegroundColor Green
        }
        "codex" {
            $dest = "$ProjectRoot\.codex\skills"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item "$ScriptDir\skills\*" $dest -Recurse -Force
            Write-Host "  [✓] 安装: .codex\skills\" -ForegroundColor Green
        }
        "trae" {
            $dest = "$ProjectRoot\.trae\rules"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item "$ScriptDir\rules\trae-rules.md" "$dest\three-mechanisms.md" -Force
            Write-Host "  [✓] 安装: .trae\rules\three-mechanisms.md" -ForegroundColor Green
        }
        "copilot" {
            $dest = "$ProjectRoot\.github"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            $copilotFile = "$dest\copilot-instructions.md"
            $copilotSrc  = "$ScriptDir\rules\copilot-instructions.md"
            if ($Force) {
                if (Test-Path $copilotFile) {
                    Copy-Item $copilotFile "$copilotFile.bak" -Force
                }
                Copy-Item $copilotSrc $copilotFile -Force
                Write-Host "  [✓] 安装: .github\copilot-instructions.md (强制覆盖)" -ForegroundColor Green
            }
            elseif (Test-Path $copilotFile) {
                if (Select-String -Path $copilotFile -Pattern "三大工作机制" -SimpleMatch -Quiet) {
                    Write-Host "  [✓] .github\copilot-instructions.md 已包含三大工作机制，跳过"
                }
                else {
                    Add-Content -Path $copilotFile -Value ""
                    Add-Content -Path $copilotFile -Value "<!-- BEGIN: 三大工作机制插件 -->"
                    Get-Content -Path $copilotSrc | Add-Content -Path $copilotFile
                    Add-Content -Path $copilotFile -Value "<!-- END: 三大工作机制插件 -->"
                    Write-Host "  [✓] 安装: .github\copilot-instructions.md (内容已追加)" -ForegroundColor Green
                }
            }
            else {
                Copy-Item $copilotSrc $copilotFile
                Write-Host "  [✓] 安装: .github\copilot-instructions.md (新建)" -ForegroundColor Green
            }
        }
        "windsurf" {
            $dest = "$ProjectRoot\.windsurf\rules"
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            Copy-Item "$ScriptDir\rules\windsurf-rules.md" "$dest\three-mechanisms.md" -Force
            Write-Host "  [✓] 安装: .windsurf\rules\three-mechanisms.md" -ForegroundColor Green
        }
        "aider" {
            Write-Host "  [!] Aider 需要手动添加 'read: AGENTS.md' 到 .aider.conf.yml" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "已安装的文件:"
Write-Host "  • AGENTS.md          — 核心行为准则 (所有框架自动加载)"
Write-Host "  • CLAUDE.md           — 薄壳 shim (@AGENTS.md)"
Write-Host "  • skills/             — 三大机制详细流程 (自动触发)"
Write-Host "  • .claude/commands/   — /qsbg /dcjc /xxfw 命令"
Write-Host ""

if ($DetectedFrameworks.Count -gt 0) {
    Write-Host "框架专用规则已安装至对应目录。"
    Write-Host "重新打开 IDE 或终端即可生效。"
}
