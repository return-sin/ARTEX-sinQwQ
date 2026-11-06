# Playwright Browser MCP — Always Prefer for Browser Work

This rule applies to **every session**. The browser-control MCP is **Playwright MCP** (`@playwright/mcp`), configured in `~/.zcode/cli/config.json` under `mcp.servers.playwright` (ZCode user scope, auto-connects at session start).

## Mandatory tool routing

Whenever the user asks to do any of the following, **do not** use shell/`npx playwright` scripts, raw Chrome CDP hacks, or the built-in `WebFetch` as a substitute for interactive control:

- open / control a real browser
- click, type, scroll, fill forms, submit
- take page snapshots / screenshots of a live UI
- verify UI after code changes
- navigate multi-step web flows
- extract content that needs JS rendering or authenticated pages
- generate PDF from a page
- run browser-based QA / smoke checks

**Always:**

1. Use the ZCode MCP tools directly with fully-qualified names such as `mcp__playwright__browser_navigate`, `mcp__playwright__browser_snapshot`, `mcp__playwright__browser_click`, etc. (ZCode naming: `mcp__<server>__<tool>`; tools are already discovered at session start — no search layer needed).
2. Prefer **accessibility snapshots** over screenshots when understanding page structure; use vision/screenshot tools when visual verification is required.
3. Keep the browser session open across multi-step tasks; do not relaunch unnecessarily.
4. 双窗口并行：playwright-dual-slot 启动器给第一个会话占 9222、第二个占 9223，各槽独立 Chrome，禁止跨槽代理或抢另一槽的 CDP。

## When NOT to use Playwright MCP

- Pure static HTTP fetch of a public URL with no interaction → built-in `WebFetch` / `WebSearch` is fine.
- Local file edits, git, terminal, code analysis → built-in tools only.
- The `playwright` MCP server is not connected (no `mcp__playwright__*` tools in this session) → report that clearly and fall back.

## Auto-invocation checklist

Before answering browser-related requests with only text or shell:

- [ ] Are `mcp__playwright__*` tools available in this session?
- [ ] Did I use them for actual control?
- [ ] Did I avoid inventing bash one-liners to drive the browser?

If any checkbox fails and the task needs a real browser, **stop and use the MCP**.

## Session expectation

Playwright MCP is **always enabled** in `~/.zcode/cli/config.json` under `mcp.servers.playwright`. Treat it as a first-class tool path, not an optional plugin the user must re-enable each time.
