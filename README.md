# 三大工作机制插件

## 请示报告 · 督促检查 · 信息服务


[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.0%2B-blue)](https://claude.ai/code)
[![Cursor](https://img.shields.io/badge/Cursor-supported-purple)](https://cursor.sh)
[![Codex](https://img.shields.io/badge/Codex%20CLI-supported-orange)](https://github.com/openai/codex)
[![TRAE](https://img.shields.io/badge/TRAE-supported-teal)](https://trae.ai)

- 将科学的组织管理制度，做成 agent 插件，装在 Claude Code、Cursor 等主流 AI 编码工具上。
- 铁一般的制度锻造铁一般的智能体。
- 铁一般的智能体创造铁一般的生产力。

> > <br />

当前AI编码智能体队伍中，三类问题表现突出：

**一曰不请示不报告。** 该请示的不请示，擅自拍板；该报告的不报告，自行其是。遇歧义不问、遇分歧不商，情况不明决心大，边界不清主意多。拿不准的敢定，划不清的敢闯，把越界当魄力，把擅断当果断。

**二曰不检查不落实。** 重部署轻检查，做没做靠自觉；重产出轻质量，对不对没人把关。该做的没做，做了的不对。查而不纠、错而不改，一本正经瞎糊弄，把应付当完成，把交差当交卷。

**三曰不透明不汇报。** 过程看不见，进度摸不着。干到哪算哪，既不汇报阶段进展，也不预警风险。心中无数，手中无策，一问三不知，协作全靠猜。把沉默当专注，把在位当到位。

这些问题的根源，不在模型能力不够，而是缺少一套科学的、经过我们实践反复检验的工作制度来约束行为、规范流程、压实责任。

基于此，我与 Claude Code（deepseek-V4） 将**三大工作机制**——请示报告、督促检查、信息服务——系统化为一套 agent 行为准则插件，应用于日常编码场景，力求锻造一支**听指挥、会干活、作风优**的 agent 队伍。

> 归结起来，就是：
>
> - 请示要实，执行要力，督促要严，信息要畅。

> - 不懂就问，不决则报；边做边查，即错即改；阶段必结，信息必达。


***

## 快速开始

### Claude Code

```bash
# 终端或 Claude Code 内执行
/plugin marketplace add Jack-infinity420/three-mechanisms-plugin
/plugin install three-mechanisms
```

安装完正常下任务，智能体自动按三大机制行事。可手动load skill：

| 命令      | 做什么                   |
| ------- | --------------------- |
| `/qsbg` | 请示报告 — 检查当前是否需要向你请示   |
| `/dcjc` | 督促检查 — 做一轮自我审查，输出质量报告 |
| `/xxfw` | 信息服务 — 输出当前阶段进展报告     |

**怎么用**：在 Claude Code 对话中直接敲 `/qsbg` 回车。

```
> /qsbg
智能体：当前任务无方案选择困境，进度正常，无需请示。

> /dcjc
智能体：⚠️ 发现 install.sh 第 23 行引用了不存在的文件...

> /xxfw
智能体：输出当前项目进展报告表格，含进度百分比和风险项。
```

### Cursor

```bash
git clone https://github.com/Jack-infinity420/three-mechanisms-plugin.git
cd three-mechanisms-plugin
./install.sh /path/to/your-cursor-project
```

脚本检测到 `.cursor/` 后，自动安装 `.cursor/rules/three-mechanisms.mdc`（`alwaysApply: true`）。每次在 Composer / Agent 模式下打开项目，规则自动加载，Skills 自动触发。

**没有** **`/`** **命令**，全是自动的。在 Composer 里问 "描述你的三大工作机制" 验证加载。

### Codex CLI

```bash
git clone https://github.com/Jack-infinity420/three-mechanisms-plugin.git
cd three-mechanisms-plugin
./install.sh /path/to/your-codex-project
```

脚本安装 `AGENTS.md` 和 `skills/` 到项目目录。Codex 启动时自动加载 `AGENTS.md`，Skills 自动触发。跟 Claude Code 一样正常下任务即可。

### TRAE

```bash
git clone https://github.com/Jack-infinity420/three-mechanisms-plugin.git
cd three-mechanisms-plugin
./install.sh /path/to/your-trae-project
```

脚本安装 `.trae/rules/three-mechanisms.md` 和 `skills/`。Builder / SOLO 模式下自动加载规则，Skills 自动触发。

***

> **通用安装**：不确定用哪个框架？直接跑安装脚本，它会自动检测并安装对应格式。

***

## 它做什么

插件为 AI 智能体建立三条工作纪律：

| 机制       | 规则               | 触发时机                    |
| -------- | ---------------- | ----------------------- |
| **请示报告** | 方案不唯一时暂停请示，不自行决断 | 需求模糊、技术选型、架构调整、大规模改动    |
| **督促检查** | 执行中自我审查，发现问题立即告警 | 代码质量偏离、进度滞后 >50%、工具连续失败 |
| **信息服务** | 里程碑必须输出结构化进展报告   | 阶段完成、重大风险、任务结束          |

自动触发，不需要你手动调命令。`/qsbg`、`/dcjc`、`/xxfw` 是你主动"遥控"的入口。

***

## 兼容框架

| 框架                 | 安装方式                             | `/` 命令 | Skills |
| ------------------ | -------------------------------- | ------ | ------ |
| **Claude Code**    | `/plugin install` 或 `install.sh` | ✅      | ✅      |
| **Cursor**         | `install.sh` / `install.ps1`     | —      | ✅      |
| **Codex CLI**      | `install.sh` / `install.ps1`     | —      | ✅      |
| **TRAE**           | `install.sh` / `install.ps1`     | —      | ✅      |
| **GitHub Copilot** | `install.sh` / `install.ps1`     | —      | —      |
| **Windsurf**       | `install.sh` / `install.ps1`     | —      | ✅      |
| **Aider**          | 手动配置 `read: AGENTS.md`           | —      | —      |

***

## 效果

```
之前："帮我重构认证模块"
智能体：直接写代码，中途可能跑偏，做完才告诉你

之后："帮我重构认证模块"  
智能体：先问清楚——框架？JWT/Session？兼容旧接口？——确认完再动手
      中途遇到问题主动告警，每个阶段输出进展报告
```

***

## 与其他插件共存

采用三层隔离架构，不会覆盖 oh-my-claudecode 等其他插件：

- **`AGENTS.md`** — 已存在则追加（含 `<!-- BEGIN/END -->` 标记）
- **`CLAUDE.md`** — 已存在则只提示手动添加 `@AGENTS.md`，绝不自动修改
- **`skills/`** — 逐目录检测，同名 skill 跳过并警告
- **`.claude/rules/`** — 独立文件，天然隔离
- **`.claude/commands/`** — 逐文件检测，不覆盖已有命令

需要强制覆盖时加 `--force` / `-Force`。

***

## 项目结构

```
├── AGENTS.md                    # 核心行为准则（跨框架真源）
├── CLAUDE.md                    # 薄壳：@AGENTS.md
├── install.sh / install.ps1     # 安装脚本
├── .claude-plugin/plugin.json   # Claude Code 插件清单
├── .claude/commands/            # /qsbg /dcjc /xxfw 命令
├── skills/qsbg dcjc xxfw/       # 三个 skill
├── rules/                       # 各框架规则文件
└── .github/                     # Copilot 规则
```

***

## FAQ

**Q: 会影响现有配置吗？**
不会。默认追加模式，只有 `--force` 才覆盖。

**Q: 能和其他插件一起用吗？**
能。与 OMC 等插件共存，各写各的文件。

**Q: 可以只装一两个机制吗？**
可以。手动复制对应 skill 目录即可。

**Q: 怎么卸载？**

```bash
rm AGENTS.md CLAUDE.md
rm -rf skills/qsbg skills/dcjc skills/xxfw
rm .claude/rules/three-mechanisms.md
rm .claude/commands/qsbg.md .claude/commands/dcjc.md .claude/commands/xxfw.md
```

**Q: 支持英文吗？**
当前规则内容为中文。欢迎贡献英文翻译。

***

## 贡献

欢迎 Issue、PR。讨论 → [GitHub Discussions](https://github.com/Jack-infinity420/three-mechanisms-plugin/discussions)。

## 许可

MIT
