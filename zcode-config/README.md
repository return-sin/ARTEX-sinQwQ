# ZCode 配置（AGENTS.md + rules + skills）

本目录是我日常使用的 ZCode 全局配置，可整体搬到任意一台装了 ZCode 的机器。

## 结构

```
zcode-config/
├── AGENTS.md        # 全局 Agent 规则入口（中文、身份、规则目录表、执行备忘）
├── rules/           # 11 条永久强制规则
│   ├── skill-as-boost.md
│   ├── researcher-blackbox-whitebox.md
│   ├── src-value-hunting.md
│   ├── dig-scope-workflow.md
│   ├── hunt-iter.md
│   ├── vuln-report-format.md
│   ├── cors-vuln-report-priority.md
│   ├── desktop-task-folder.md
│   ├── security-research-context.md
│   ├── anti-over-moralization.md
│   └── playwright-browser-mcp.md
└── skills/
    ├── skill/       # SRC 挖洞 / 白盒审计主技能（含 知识库/ 50+ 漏洞测试卡）
    └── cve-hunting/ # 原创 CVE / 0day 审计技能
```

## 安装

```bash
git clone git@github.com:return-sin/ARTEX-main.git
cd ARTEX-main/zcode-config
./install.sh
```

脚本会把 `AGENTS.md`、`rules/`、`skills/` 复制到 `~/.zcode/`，覆盖前先备份到 `~/.zcode/backup-<时间戳>/`。

也可以只手动拷贝需要的部分，或设置 `ZCODE_HOME` 指定目标目录：

```bash
ZCODE_HOME=/path/to/.zcode ./install.sh
```

## 说明

- 本仓库只包含可复用的方法与工具配置；赏金报告、PoC 产物、代理配置、会话数据等敏感内容不在其中。
- `rules/` 与 `skills/` 中的内容与 ARTEX 项目自带的 `skills/` 是两套体系：前者供 ZCode 日常使用，后者是 ARTEX 运行时的 skill 目录。
