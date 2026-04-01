---
description: Audit all available tools for naming collisions, vocabulary overlap, and shadowing across MCP servers and skills.
argument-hint: "[verbose]"
---

You are performing a tool collision audit. Your job is to detect conflicts between tools from different MCP servers and skills that could cause the AI to route a user's request to the wrong system.

## Step 1: Enumerate

List every tool available in this session. For each tool, record:
- **Full name** (including `mcp__` prefix if applicable)
- **Source** (built-in, MCP server name extracted from prefix, or skill)
- **Description** (the tool's description text)
- **Parameters** (names and types from the input schema)
- **Trigger phrases** — list 3-5 natural language phrases a user would say that would likely cause you to invoke this tool

Group the tools by source/server.

## Step 2: Detect Collisions

Compare every tool pair **across different sources** (skip comparisons within the same server — co-located tools are intentional). For each cross-server pair, evaluate:

### Name collision
Do the base names (strip the `mcp__<server>__` prefix) share words? Identical base names are critical. Shared verbs (capture, search, list, save, get, create, update, delete) are high severity.

### Vocabulary overlap
Would the same natural-language prompt plausibly trigger both tools? Compare your trigger phrase lists. Overlapping phrases mean the model has to guess.

### Functional overlap
Do both tools accept similar input types and produce similar outputs? Two tools that both take a text string and store it with metadata are functionally overlapping regardless of name.

### Shadow risk
For ambiguous prompts, would one tool consistently win? A tool with a more intuitive name, shorter name, or broader description can shadow a more specialized tool, making it effectively invisible.

## Step 3: Score Severity

For each collision found:
- **Critical** — identical base names from different servers. Guaranteed misrouting without explicit prefix usage.
- **High** — strong vocabulary overlap on common verbs (capture, search, list, save, remember, note, task, log, find, get). Wrong tool selected >20% of the time on natural prompts.
- **Medium** — partial vocabulary overlap. Usually routes correctly but fails on ambiguous phrasing.
- **Low** — same domain but descriptions are distinct enough. Worth noting, not urgent.

## Step 4: Report

Present results as a structured report:

```
## Tool Collision Audit Report
Generated: [date]
Tools: [count] MCP tools across [count] servers, [count] built-in, [count] skills

### Critical Collisions
[list or "None"]

### High Severity
[For each:]
**[collision title]**
- [tool 1 full name] — "[description]"
- [tool 2 full name] — "[description]"
- Overlapping triggers: [list phrases]
- Likely winner: [which tool the model would pick and why]
- Recommended fix: [see below]

### Medium Severity
[same format]

### Low Severity
[same format]

### Shadows
[any tools effectively hidden by another]
```

## Step 5: Recommend Fixes

For each collision, recommend fixes in this priority order:

1. **CLAUDE.md routing rule** — draft exact text the user can add:
   ```
   When I say "[trigger phrase]", use [correct tool full name], not [other tool].
   ```
   Routing rules are the fastest fix and work immediately.

2. **Description improvement** — if one tool has a vague description, draft a more specific one that would help you disambiguate. Tell the user which MCP server would need the change.

3. **Tool rename** — if the user controls a server, suggest a more distinctive tool name.

4. **Disable** — if one tool fully supersedes another, suggest disabling the redundant server.

## Step 6: Apply (if requested)

If the user wants to apply routing rules, write them to the project's CLAUDE.md file under a `## Tool Routing Rules` section. Create the section if it doesn't exist. Append new rules — never overwrite existing ones.

If $ARGUMENTS contains "verbose", include the full tool enumeration from Step 1 in the output. Otherwise, only show collisions and recommendations.

If no collisions are found, say so clearly and confirm the environment is clean.
