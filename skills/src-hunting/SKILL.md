---
name: src-hunting
description: |
  SRC 漏洞挖掘方法论 + 48 篇分类型知识库。用于：判断一个发现是否值得投入（什么洞值钱/什么不收）、
  规划进站攻击顺序、按漏洞类型查具体测试手法、定级与写报告。
  覆盖：越权/IDOR、未授权访问、认证绕过、OAuth/JWT、注入（SQLi/NoSQL/模板/命令）、SSRF、文件上传、
  路径遍历/LFI、XXE、反序列化、原型链污染、GraphQL、HTTP 走私、缓存投毒、竞争条件、XSS/CSRF/CSP、
  JS 逆向找接口、WAF 绕过、信息泄露、子域接管、LLM 安全、白盒审计要点。
  挖任何 Web 目标、决定下一步打哪里、或评估一个 finding 的真实危害时加载本技能。
---

# SRC 挖洞方法论

## 0. 铁律（先读这段）

- **只认"有实际危害"的发现**：未授权本身不是漏洞；**未授权 + 敏感数据 / 写操作 / 账号接管**才是。
  判断标准永远是"这个洞实际流出了什么数据 / 能做什么"，而不是"这个门有没有关"。
- **CORS 不挖**（无实际影响的 CORS 一律不收，别花时间）。
- **最小伤害**：越权优先用读/列表差分证明；写越权先"添加"再删自己刚加的那条；不改/删他人已有对象；禁止批量、禁止真实资损、禁止破坏数据。
- **禁止登出/注销/吊销任何人（含自己测试账号）的会话**；不测"退出后会话是否有效"。
- **无 PoC 不报**；同一根因合并成一份报告，别拆成多份。

## 1. 什么才算有价值（发力前先判断）

有价值 = 能打到高危/严重：

| 值得打 | 说明 |
|---|---|
| 跨租户/跨用户读或写 | 真实用户数据、PII（姓名/证件号/手机号/地址）、他人业务数据 |
| 未登录出业务敏感 | 名单/详情/附件/实名信息/证书/导出包；**不是**公开参考数据（行政区划/公开词表/展示文案） |
| 认证接管 | 发会话 / 重置 / 改绑 / 换票；**进号或改密才算**，只拿到验证码不算 |
| 低权到平台管理员 | 垂直提权链 |
| 注入出他主体 | SQLi 能读其他表/他人数据、命令执行 |
| RCE | 命令/代码执行（最小证明，如 id/whoami） |
| 完整攻击链 | 发现点 → 跨用户写 / 账号接管 / 代码执行 |

**不值钱（直接放弃，别写报告）：** 无数据回吐的"接口无鉴权"、banner/配置/公开文件读取、用户枚举、缺安全头、self-XSS、点击劫持、CDN/缓存配置类、仅理论无 PoC、第三方组件已知 CVE（无利用证明）、**参考/公开数据导出**、无实际影响的 CORS。

## 2. 力气分配（进站先砸哪里）

| 顺序 | 打什么 | 判定点 |
|---|---|---|
| 1 | **未登录出他人/他主体**：不登录出名单/详情/附件/导出 | 有真实数据回吐 |
| 2 | **认证接管**：发会话/重置/改绑/换票 | 进号或改密 |
| 3 | **换 id**（有了会话或未授权通了再换，不限字段名） | 他主体数据出现 = 打穿 |
| 4 | **有号写/逻辑**：加 role、改金额/状态、跳审核、券/库存并发 | 资损或提权 |
| 5 | **四件套**（有回显/差分才打）：注入、SSRF、XSS、RCE | 稳定差分或回显 |
| 6 | **JS 钥匙**：盐、硬编码钥、演示号 | 能换出会话/数据 |

- **没号**：未授权通了再换 id → 认证口 → JS 钥匙 → 有差分面的四件套
- **有号**：带会话换 id → 加字段/跳步/钱 → 四件套打在已经出数的业务参数上

## 3. 挖到就继续（别停在半截）

- 文件通道开了 → 立刻转业务 API、可执行类型、路径、SSRF 链
- 发码接口通了 → 跟认证链：回包有没有码、码绑不绑号、重置换不换用户
- **中危落了先升链再换站**：同一对象走到写 / 跨用户 / 接管 / 可执行
- 回包里冒出 id / 下载地址 / token / 内部 host → 进队列再打
- 公开静态/接口 200 有 JSON → 转跨用户、注入、提权

## 4. 知识库索引（按场景读 `知识库/<file>.md`）

**侦察与接口**
- `recon-methodology.md` 资产测绘与信息收集
- `js-reverse-guide.md` JS 逆向找接口/密钥
- `api-gateway-test.md` API 网关
- `info-leak-test.md` 信息泄露（源码/配置/凭据）
- `insecure-scm-test.md` 不安全的 SCM/Git/SVN 暴露

**授权与认证**
- `idor-test.md` 越权/IDOR/BOLA（对象引用换号）
- `authbypass-test.md` 认证绕过
- `401-403-bypass.md` 401/403 绕过
- `oauth-jwt-test.md` OAuth/JWT 缺陷
- `dns-rebinding-test.md` DNS 重绑定
- `subdomain-takeover-test.md` 子域接管

**注入类**
- `injection-test.md` 通用注入（SQLi/NoSQL/命令/模板）
- `jndi-injection-test.md` JNDI 注入
- `hpp-test.md` 参数污染
- `type-juggling-test.md` 类型混淆
- `deserialization-test.md` 反序列化
- `prototype-pollution-test.md` 原型链污染
- `xslt-injection-test.md` XSLT 注入
- `xxe-test.md` XXE

**文件与路径**
- `file-upload-test.md` 文件上传（白名单/黑名单/解析）
- `path-traversal-lfi-test.md` 路径遍历/LFI
- `dependency-confusion-test.md` 依赖混淆
- `cloud-ide-codex-rce-chain.md` 云端 IDE/Codex 类 RCE 链

**客户端**
- `xss-test.md` XSS（反射/存储/DOM）
- `csrf-test.md` CSRF
- `csp-bypass-test.md` CSP 绕过
- `clickjacking-test.md` 点击劫持（通常不收）
- `dangling-markup-test.md` 悬垂标记
- `el-injection-test.md` 表达式/EL 注入
- `crlf-injection-test.md` CRLF 注入
- `csv-formula-injection-test.md` CSV 公式注入（通常不收）

**协议与传输**
- `http-smuggling-test.md` HTTP 请求走私
- `http2-attacks-test.md` HTTP/2 攻击
- `http-host-header-test.md` Host 头攻击
- `cache-poisoning-test.md` 缓存投毒
- `race-condition-test.md` 竞争条件
- `websocket-test.md` WebSocket

**其它**
- `ssrf-test.md` SSRF
- `graphql-test.md` GraphQL（introspection 一般不收）
- `llm-security-test.md` LLM/AI 安全（提示注入等）
- `logic-test.md` 业务逻辑
- `open-redirect-test.md` 开放重定向（多数程序不收，先确认 scope 政策）
- `email-header-injection-test.md` 邮件头注入
- `agent-tool-exec-test.md` Agent/工具执行
- `waf-bypass.md` WAF 绕过手法
- `ghost-bits-cast-test.md` Ghost Bits Cast
- `打穿短表.md` 一页速查：目标特征 → 先测模块

## 5. 报告与定级

- 每个 finding 必须含：精确 URL、请求/响应原文、**时间戳**、完整复现步骤（含 payload/命令）、实际影响说明。
- 定级看真实影响，不看漏洞类型名："能读到多少条什么数据" > "这是个 IDOR"。
- **同一根因的多个表现合并叙述**（避免被判拆分/递减）；不同根因才分开报。
- 参考 `参考/vuln-report-format.md`（报告格式）与 `参考/src-value-hunting.md`（完整价值导向规则）。

> 注：知识库文件内引用的 `~/.zcode/rules/xxx.md` 是原包的路径约定，在本环境不存在。对应关系：`vuln-report-format`/`src-value-hunting` → 本 skill 的 `参考/` 目录；`dig-scope-workflow`/`hunt-iter` 等流程规则 → 以本文件 §1–§3 为准；遇到其它未收录的引用直接忽略，不影响使用。
