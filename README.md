# tool-audit

Two Claude Code skills that detect and fix tool conflicts across MCP servers.

When you have multiple MCP servers installed, their tools can overlap. "Remember this" might hit Local Brain or CloudJournal. "Search my notes" might go to the wrong system entirely. The AI picks one — and you may never know it picked wrong.

These skills fix that.

## What's Included

**`/audit-tools`** — Scans every tool in your current session across all MCP servers and skills. Detects naming collisions, vocabulary overlap, functional duplication, and shadowed tools. Generates a severity-scored report with actionable fixes. Can write routing rules directly to your CLAUDE.md.

**`/wrong-tool`** — Run this when the AI just used the wrong tool. It identifies what happened, explains why, drafts a routing rule to prevent recurrence, and offers to apply it. Turns one bad routing event into a permanent fix.

## Install

One command:

```bash
curl -fsSL https://raw.githubusercontent.com/Chapworks/tool-audit/main/install.sh | bash
```

This installs globally to `~/.claude/commands/` (works in all projects).

For a single project only:

```bash
curl -fsSL https://raw.githubusercontent.com/Chapworks/tool-audit/main/install.sh | bash -s -- --project
```

Or clone and run locally:

```bash
git clone https://github.com/Chapworks/tool-audit.git
cd tool-audit
./install.sh
```

## Usage

### Proactive: Audit your environment

Run after adding a new MCP server, or periodically:

```
/audit-tools
```

Add `verbose` to see the full tool enumeration:

```
/audit-tools verbose
```

### Reactive: Fix a misroute

When the AI uses the wrong tool:

```
/wrong-tool I meant CloudJournal not Local Brain
```

Or just:

```
/wrong-tool
```

The skill will check the last tool call and ask which tool you intended.

## How It Works

Claude already knows every tool available in the current session — MCP tools, built-in tools, and skills are all in its context. These skills simply ask Claude to reflect on what it sees, compare tools across servers, and identify where natural-language prompts would be ambiguous.

No MCP protocol extensions. No server-to-server communication. No configuration files to parse. Just prompt-driven introspection of information the model already has.

## What It Detects

- **Name collisions** — identical tool names from different servers
- **Vocabulary overlap** — different names but the same trigger phrases ("save this," "capture this")
- **Functional overlap** — different tools that accept similar inputs and produce similar outputs
- **Shadows** — one tool hiding another because its name or description is a better match for common prompts

## What It Recommends

1. **CLAUDE.md routing rules** — "When I say X, use tool A, not tool B." Applied directly to your project or global config.
2. **Description improvements** — more specific tool descriptions that help the model disambiguate.
3. **Tool renames** — if you control a server, use a more distinctive name.
4. **Disable redundant tools** — if one fully supersedes another.

## Why This Matters

The MCP spec has no namespacing requirement, no collision detection, and no routing rules. Claude Code's `mcp__server__tool` prefix prevents name collisions but not semantic collisions — two tools with different names that respond to the same intent. As the MCP ecosystem grows, this problem gets worse. These skills are a practical fix that works today.

## License

MIT
