# 三大工作机制 — AI 智能体行为准则插件

> 一套轻量、跨框架的 AI 编码智能体行为规范。让智能体在工作中做到：**不懂就问，边做边查，做完就说。**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.0%2B-blue)](https://claude.ai/code)
[![Cursor](https://img.shields.io/badge/Cursor-supported-purple)](https://cursor.sh)
[![Codex](https://img.shields.io/badge/Codex%20CLI-supported-orange)](https://github.com/openai/codex)
[![TRAE](https://img.shields.io/badge/TRAE-supported-teal)](https://trae.ai)

---

## 一句话

安装后，AI 智能体会主动请示关键决策、自我审查代码质量、在每个里程碑汇报进展——而不是闷头干完才告诉你。

---

## 它做什么

| 机制 | `/` 命令 | 触发时机 | 效果 |
|------|---------|---------|------|
| **请示报告** | `/qsbg` | 方案选择、需求模糊、架构调整、大规模改动、多智能体并行 | 智能体暂停，列出方案对比，请你决策 |
| **督促检查** | `/dcjc` | 代码质量偏离、进度滞后 >50%、工具连续失败、安全漏洞 | 智能体主动输出质量告警 + 修复建议 |
| **信息服务** | `/xxfw` | 里程碑完成、重大风险出现、任务结束 | 智能体输出结构化进展报告表格 |

**自动触发**：智能体根据场景自动激活对应机制，不需要你手动调命令。`/qsbg`、`/dcjc`、`/xxfw` 是你主动"遥控"的入口。

---

## 兼容框架

| 框架 | 安装方式 | `/` 命令 | Skills 自动触发 |
|------|---------|---------|----------------|
| **Claude Code** | `install.sh` / `install.ps1` | ✅ `/qsbg` `/dcjc` `/xxfw` | ✅ |
| **Cursor** | `install.sh` / `install.ps1` | — `.mdc` 自动加载 | ✅ |
| **Codex CLI** | `install.sh` / `install.ps1` | — `AGENTS.md` 加载 | ✅ |
| **TRAE** | `install.sh` / `install.ps1` | — rules 自动加载 | ✅ |
| **GitHub Copilot** | `install.sh` / `install.ps1` | — `copilot-instructions.md` | — |
| **Windsurf** | `install.sh` / `install.ps1` | — rules 自动加载 | ✅ |
| **Aider** | 手动配置 | — `read: AGENTS.md` | — |

---

## 安装

### 方式一：一键安装（推荐）

```bash
# 1. 克隆插件仓库
git clone https://github.com/Jack-infinity420/three-mechanisms-plugin.git
cd three-mechanisms-plugin

# 2. 安装到你的项目
./install.sh /path/to/your-project

# Windows PowerShell
.\install.ps1 -ProjectRoot C:\path\to\your-project
```

安装脚本会自动检测项目使用的 AI 编码框架，安装对应格式的规则文件。

**安全设计**：默认条件追加，不会覆盖已有配置。如需强制覆盖已有文件：

```bash
./install.sh --force /path/to/your-project
.\install.ps1 -Force -ProjectRoot C:\path\to\your-project
```

### 方式二：Claude Code 插件市场

等待仓库发布后，通过 Claude Code 插件市场安装：

```bash
claude plugin marketplace add Jack-infinity420/three-mechanisms-plugin
claude plugin install three-mechanisms@Jack-infinity420/three-mechanisms-plugin
```

### 方式三：仅核心规则

只想用最简规则？复制 `AGENTS.md` 到项目根目录，在 `CLAUDE.md` 开头加一行 `@AGENTS.md`。

---

## 怎么用

### 日常就是正常下任务

你不需要改变任何习惯。正常下任务——智能体行为变化如下：

```
# 你："帮我重构认证模块"
智能体：先问清楚——什么框架？JWT/Session？要不要兼容旧接口？——确认完再动手
      （请示报告 自动触发）

# 中途智能体发现问题
智能体：⚠️ 质量告警：redis 连接失败 3 次，建议先排查网络配置再继续
      （督促检查 自动触发）

# 完成一个阶段
智能体：输出进展报告表格——已完成/进行中/未开始，进度百分比，下一步计划
      （信息服务 自动触发）
```

### 主动遥控

觉得智能体沉默太久、担心跑偏、或者想主动做质量审查时：

| 命令 | 效果 |
|------|------|
| `/qsbg` | 智能体重新审视当前任务，检查是否需要向你请示 |
| `/dcjc` | 智能体对当前工作做一轮自我审查，输出质量报告 |
| `/xxfw` | 智能体输出当前阶段的进展报告 |

---

## 为什么需要

AI 编码智能体越来越强，但普遍存在三个行为问题：

1. **不请示** — 收到模糊任务直接动手，自行决断架构决策
2. **不自查** — 发现问题自行消化，拖延上报，错过修正窗口
3. **不汇报** — 做完才告诉你，中间状态你完全不知

这套机制用极简的三条规则解决这三个问题。它不增加你的负担——你继续正常提需求，智能体自动改变行为。

---

## 项目结构

```
three-mechanisms-plugin/
├── AGENTS.md                    # 核心行为准则（跨框架真源）
├── CLAUDE.md                    # 薄壳：@AGENTS.md
├── README.md                    # 本文件
├── install.sh                   # Linux / macOS 安装脚本
├── install.ps1                  # Windows PowerShell 安装脚本
├── .claude-plugin/
│   └── plugin.json              # Claude Code 插件清单
├── .claude/
│   ├── commands/
│   │   ├── qsbg.md              # /qsbg 命令
│   │   ├── dcjc.md              # /dcjc 命令
│   │   └── xxfw.md              # /xxfw 命令
│   └── rules/
│       └── three-mechanisms.md  # Claude Code 规则
├── skills/
│   ├── qsbg/SKILL.md            # 请示报告 skill
│   ├── dcjc/SKILL.md            # 督促检查 skill
│   └── xxfw/SKILL.md            # 信息服务 skill
├── rules/                       # 各框架规则文件
│   ├── claude-rules.md
│   ├── cursor-rules.mdc
│   ├── trae-rules.md
│   ├── windsurf-rules.md
│   └── copilot-instructions.md
└── .github/
    └── copilot-instructions.md
```

---

## 与已有插件共存

本插件遵循三层隔离架构，不会覆盖其他插件（如 oh-my-claudecode）的配置：

| 安装位置 | 策略 |
|----------|------|
| `AGENTS.md` | 已存在则追加（含 `<!-- BEGIN/END -->` 标记），不覆盖 |
| `CLAUDE.md` | 已存在则只提示手动添加 `@AGENTS.md`，绝不自动修改 |
| `skills/` | 逐目录检测，遇到同名 skill 跳过并警告 |
| `.claude/rules/` | 独立文件，天然隔离 |
| `.claude/commands/` | 逐文件检测，不覆盖已有命令 |

---

## FAQ

**Q: 会影响我的现有配置吗？**
A: 不会。默认追加模式，已有文件不会被覆盖。只有显式加 `--force` 才会覆盖。

**Q: 能和其他插件一起用吗？**
A: 能。采用 rules 目录隔离 + skill 命名空间 + 条件追加，与 OMC、其他 skill 插件共存。

**Q: 可以只装其中一两个机制吗？**
A: 可以。手动复制对应 skill 目录和 AGENTS.md 中的对应章节即可。

**Q: 怎么卸载？**
A: 删除项目中的 `AGENTS.md`、`CLAUDE.md`、`skills/qsbg`、`skills/dcjc`、`skills/xxfw`、`.claude/rules/three-mechanisms.md`、`.claude/commands/qsbg.md`、`.claude/commands/dcjc.md`、`.claude/commands/xxfw.md`。

**Q: 支持中文以外的语言吗？**
A: 当前规则内容为中文。欢迎贡献英文翻译。

---

## 贡献

欢迎提 Issue、PR。讨论请前往 [GitHub Discussions](https://github.com/Jack-infinity420/three-mechanisms-plugin/discussions)。

## 许可

MIT License — 随便用，随便改。
