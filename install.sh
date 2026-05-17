#!/usr/bin/env bash
set -e

# ============================================================
#  三大工作机制插件 — 跨框架安装脚本 (Linux / macOS / WSL)
# ============================================================

# ---------- 参数解析 ----------
FORCE=false
TARGET_DIR=""

for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --help|-h)
            echo "用法: ./install.sh [--force] [目标项目路径]"
            echo ""
            echo "  --force  强制覆盖已存在的文件（默认追加模式）"
            echo "  目标路径  要安装到的项目根目录（默认: 当前目录）"
            echo ""
            echo "示例:"
            echo "  ./install.sh                          # 安装到当前目录"
            echo "  ./install.sh /path/to/project          # 安装到指定项目"
            echo "  ./install.sh --force /path/to/project  # 强制覆盖安装"
            exit 0
            ;;
        *) TARGET_DIR="$arg" ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  三大工作机制插件 — 安装脚本${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# ---------- 检测项目根目录 ----------
if [ -n "$TARGET_DIR" ]; then
    PROJECT_ROOT="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"
    mkdir -p "$PROJECT_ROOT" 2>/dev/null || true
else
    PROJECT_ROOT="$(pwd)"
fi

echo -e "目标项目: ${YELLOW}$PROJECT_ROOT${NC}"
echo ""

# ---------- 检测已安装的 AI 编码框架 ----------
detected_frameworks=()

# Claude Code
if [ -d "$PROJECT_ROOT/.claude" ] || [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    detected_frameworks+=("claude")
    echo -e "  [✓] 检测到: ${GREEN}Claude Code${NC}"
fi

# Cursor
if [ -d "$PROJECT_ROOT/.cursor" ] || [ -f "$PROJECT_ROOT/.cursorrules" ]; then
    detected_frameworks+=("cursor")
    echo -e "  [✓] 检测到: ${GREEN}Cursor${NC}"
fi

# Codex
if [ -d "$PROJECT_ROOT/.codex" ] || [ -f "$PROJECT_ROOT/AGENTS.md" ]; then
    # Codex is detected if .codex dir exists; AGENTS.md alone is ambiguous
    if [ -d "$PROJECT_ROOT/.codex" ]; then
        detected_frameworks+=("codex")
        echo -e "  [✓] 检测到: ${GREEN}Codex CLI${NC}"
    fi
fi

# TRAE
if [ -d "$PROJECT_ROOT/.trae" ]; then
    detected_frameworks+=("trae")
    echo -e "  [✓] 检测到: ${GREEN}TRAE${NC}"
fi

# GitHub Copilot
if [ -d "$PROJECT_ROOT/.github" ]; then
    detected_frameworks+=("copilot")
    echo -e "  [✓] 检测到: ${GREEN}GitHub Copilot${NC}"
fi

# Windsurf
if [ -d "$PROJECT_ROOT/.windsurf" ] || [ -f "$PROJECT_ROOT/.windsurfrules" ]; then
    detected_frameworks+=("windsurf")
    echo -e "  [✓] 检测到: ${GREEN}Windsurf${NC}"
fi

# Aider
if [ -f "$PROJECT_ROOT/.aider.conf.yml" ]; then
    detected_frameworks+=("aider")
    echo -e "  [✓] 检测到: ${GREEN}Aider${NC}"
fi

if [ ${#detected_frameworks[@]} -eq 0 ]; then
    echo -e "${YELLOW}  [!] 未检测到已知 AI 编码框架。${NC}"
    echo -e "  将仅安装通用文件 (AGENTS.md + skills/)"
    echo ""
fi

echo ""

# ---------- 安装 ----------
echo -e "${CYAN}开始安装...${NC}"
echo ""

# 1. AGENTS.md (条件追加)
if $FORCE; then
    if [ -f "$PROJECT_ROOT/AGENTS.md" ] && [ "$PROJECT_ROOT/AGENTS.md" != "$SCRIPT_DIR/AGENTS.md" ]; then
        cp "$PROJECT_ROOT/AGENTS.md" "$PROJECT_ROOT/AGENTS.md.bak"
        echo -e "  ${YELLOW}[!] AGENTS.md 已备份为 AGENTS.md.bak${NC}"
    fi
    cp "$SCRIPT_DIR/AGENTS.md" "$PROJECT_ROOT/AGENTS.md"
    echo -e "  [✓] 安装: ${GREEN}AGENTS.md (强制覆盖)${NC}"
elif [ -f "$PROJECT_ROOT/AGENTS.md" ]; then
    if grep -q "三大工作机制" "$PROJECT_ROOT/AGENTS.md" 2>/dev/null; then
        echo -e "  [✓] AGENTS.md 已包含三大工作机制，跳过"
    else
        echo "" >> "$PROJECT_ROOT/AGENTS.md"
        echo "<!-- BEGIN: 三大工作机制插件 -->" >> "$PROJECT_ROOT/AGENTS.md"
        cat "$SCRIPT_DIR/AGENTS.md" >> "$PROJECT_ROOT/AGENTS.md"
        echo "<!-- END: 三大工作机制插件 -->" >> "$PROJECT_ROOT/AGENTS.md"
        echo -e "  [✓] 安装: ${GREEN}AGENTS.md (内容已追加)${NC}"
    fi
else
    cp "$SCRIPT_DIR/AGENTS.md" "$PROJECT_ROOT/AGENTS.md"
    echo -e "  [✓] 安装: ${GREEN}AGENTS.md (新建)${NC}"
fi

# 2. CLAUDE.md (薄壳 shim)
if $FORCE; then
    if [ -f "$PROJECT_ROOT/CLAUDE.md" ] && [ "$PROJECT_ROOT/CLAUDE.md" != "$SCRIPT_DIR/CLAUDE.md" ]; then
        cp "$PROJECT_ROOT/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md.bak"
        echo -e "  ${YELLOW}[!] CLAUDE.md 已备份为 CLAUDE.md.bak${NC}"
    fi
    cp "$SCRIPT_DIR/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"
    echo -e "  [✓] 安装: ${GREEN}CLAUDE.md (强制覆盖)${NC}"
elif [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    if grep -q '@AGENTS.md' "$PROJECT_ROOT/CLAUDE.md" 2>/dev/null; then
        echo -e "  [✓] CLAUDE.md 已含 @AGENTS.md，跳过"
    else
        echo -e "  ${YELLOW}[!] CLAUDE.md 已存在但未引用 AGENTS.md${NC}"
        echo -e "  ${YELLOW}   请手动添加此行到 CLAUDE.md 开头: @AGENTS.md${NC}"
    fi
else
    cat > "$PROJECT_ROOT/CLAUDE.md" << 'CLAUDE_EOF'
@AGENTS.md

# Claude Code 专用规则
# 三大工作机制核心准则通过 @AGENTS.md 加载。
# 如需添加 Claude Code 专属规则，请在下方追加。
CLAUDE_EOF
    echo -e "  [✓] 安装: ${GREEN}CLAUDE.md (薄壳新建)${NC}"
fi

# 3. skills/ 目录 (逐 skill 安装，避免覆盖已有同名 skill)
if [ -d "$SCRIPT_DIR/skills" ]; then
    mkdir -p "$PROJECT_ROOT/skills"
    shopt -s nullglob
    for skill_dir in "$SCRIPT_DIR/skills/"*; do
        skill_name=$(basename "$skill_dir")
        if [ -d "$PROJECT_ROOT/skills/$skill_name" ]; then
            if $FORCE; then
                cp -r "$skill_dir" "$PROJECT_ROOT/skills/"
                echo -e "  [✓] 安装: ${GREEN}skills/$skill_name (强制覆盖)${NC}"
            else
                echo -e "  ${YELLOW}[!] skills/$skill_name 已存在(可能来自其他插件)，跳过${NC}"
            fi
        else
            cp -r "$skill_dir" "$PROJECT_ROOT/skills/"
            echo -e "  [✓] 安装: ${GREEN}skills/$skill_name${NC}"
        fi
    done
    shopt -u nullglob
fi

# 3.5. .claude/commands/ (Claude Code 命令)
if [ -d "$SCRIPT_DIR/.claude/commands" ]; then
    mkdir -p "$PROJECT_ROOT/.claude/commands"
    shopt -s nullglob
    for cmd_file in "$SCRIPT_DIR/.claude/commands/"*; do
        cmd_name=$(basename "$cmd_file")
        if [ -f "$PROJECT_ROOT/.claude/commands/$cmd_name" ]; then
            if $FORCE; then
                cp "$cmd_file" "$PROJECT_ROOT/.claude/commands/"
                echo -e "  [✓] 安装: ${GREEN}.claude/commands/$cmd_name (强制覆盖)${NC}"
            else
                echo -e "  ${YELLOW}[!] .claude/commands/$cmd_name 已存在，跳过${NC}"
            fi
        else
            cp "$cmd_file" "$PROJECT_ROOT/.claude/commands/"
            echo -e "  [✓] 安装: ${GREEN}.claude/commands/$cmd_name${NC}"
        fi
    done
    shopt -u nullglob
fi

# 4. 框架专用规则文件
for fw in "${detected_frameworks[@]}"; do
    case "$fw" in
        claude)
            mkdir -p "$PROJECT_ROOT/.claude/rules"
            if [ -f "$SCRIPT_DIR/rules/claude-rules.md" ]; then
                cp "$SCRIPT_DIR/rules/claude-rules.md" "$PROJECT_ROOT/.claude/rules/three-mechanisms.md"
                echo -e "  [✓] 安装: ${GREEN}.claude/rules/three-mechanisms.md${NC}"
            fi
            ;;
        cursor)
            mkdir -p "$PROJECT_ROOT/.cursor/rules"
            if [ -f "$SCRIPT_DIR/rules/cursor-rules.mdc" ]; then
                cp "$SCRIPT_DIR/rules/cursor-rules.mdc" "$PROJECT_ROOT/.cursor/rules/three-mechanisms.mdc"
                echo -e "  [✓] 安装: ${GREEN}.cursor/rules/three-mechanisms.mdc${NC}"
            fi
            ;;
        codex)
            mkdir -p "$PROJECT_ROOT/.codex/skills"
            if [ -d "$SCRIPT_DIR/skills" ]; then
                shopt -s nullglob
                for skill_dir in "$SCRIPT_DIR/skills/"*; do
                    cp -r "$skill_dir" "$PROJECT_ROOT/.codex/skills/"
                done
                shopt -u nullglob
            fi
            echo -e "  [✓] 安装: ${GREEN}.codex/skills/${NC}"
            ;;
        trae)
            mkdir -p "$PROJECT_ROOT/.trae/rules"
            if [ -f "$SCRIPT_DIR/rules/trae-rules.md" ]; then
                cp "$SCRIPT_DIR/rules/trae-rules.md" "$PROJECT_ROOT/.trae/rules/three-mechanisms.md"
                echo -e "  [✓] 安装: ${GREEN}.trae/rules/three-mechanisms.md${NC}"
            fi
            ;;
        copilot)
            mkdir -p "$PROJECT_ROOT/.github"
            COPILOT_FILE="$PROJECT_ROOT/.github/copilot-instructions.md"
            if $FORCE; then
                if [ -f "$COPILOT_FILE" ]; then
                    cp "$COPILOT_FILE" "$COPILOT_FILE.bak"
                fi
                cp "$SCRIPT_DIR/rules/copilot-instructions.md" "$COPILOT_FILE"
                echo -e "  [✓] 安装: ${GREEN}.github/copilot-instructions.md (强制覆盖)${NC}"
            elif [ -f "$COPILOT_FILE" ]; then
                if grep -q "三大工作机制" "$COPILOT_FILE" 2>/dev/null; then
                    echo -e "  [✓] .github/copilot-instructions.md 已包含三大工作机制，跳过"
                else
                    echo "" >> "$COPILOT_FILE"
                    echo "<!-- BEGIN: 三大工作机制插件 -->" >> "$COPILOT_FILE"
                    cat "$SCRIPT_DIR/rules/copilot-instructions.md" >> "$COPILOT_FILE"
                    echo "<!-- END: 三大工作机制插件 -->" >> "$COPILOT_FILE"
                    echo -e "  [✓] 安装: ${GREEN}.github/copilot-instructions.md (内容已追加)${NC}"
                fi
            else
                cp "$SCRIPT_DIR/rules/copilot-instructions.md" "$COPILOT_FILE"
                echo -e "  [✓] 安装: ${GREEN}.github/copilot-instructions.md (新建)${NC}"
            fi
            ;;
        windsurf)
            mkdir -p "$PROJECT_ROOT/.windsurf/rules"
            if [ -f "$SCRIPT_DIR/rules/windsurf-rules.md" ]; then
                cp "$SCRIPT_DIR/rules/windsurf-rules.md" "$PROJECT_ROOT/.windsurf/rules/three-mechanisms.md"
                echo -e "  [✓] 安装: ${GREEN}.windsurf/rules/three-mechanisms.md${NC}"
            fi
            ;;
        aider)
            echo -e "  ${YELLOW}[!] Aider 需要手动添加 'read: AGENTS.md' 到 .aider.conf.yml${NC}"
            ;;
    esac
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "已安装的文件:"
echo -e "  • AGENTS.md          — 核心行为准则 (所有框架自动加载)"
echo -e "  • CLAUDE.md           — 薄壳 shim (@AGENTS.md)"
echo -e "  • skills/             — 三大机制详细流程 (自动触发)"
echo -e "  • .claude/commands/   — /qsbg /dcjc /xxfw 命令"
echo ""

if [ ${#detected_frameworks[@]} -gt 0 ]; then
    echo -e "框架专用规则已安装至对应目录。"
    echo -e "重新打开 IDE 或终端即可生效。"
fi

echo ""
echo -e "更多信息: https://github.com/Jack-infinity420/three-mechanisms-plugin"
