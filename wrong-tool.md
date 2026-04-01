---
description: Fix a tool misrouting — identify what went wrong, draft a routing rule, and prevent it from happening again.
argument-hint: "[description of what went wrong]"
---

The user indicated that a tool call was routed to the wrong system. This happens when multiple MCP servers or skills have overlapping vocabulary and the AI picks the wrong one.

## Step 1: Identify the Collision

Determine:
- **What tool was called?** (check the most recent tool call in the conversation)
- **What tool did the user intend?** (ask if $ARGUMENTS doesn't make it clear)
- **What did the user say that triggered the wrong tool?** (find the prompt that caused the misrouting)

If $ARGUMENTS describes the problem (e.g., "I meant CloudJournal not Local Brain"), use that. Otherwise, ask the user to clarify which tool they intended.

## Step 2: Explain Why

Explain briefly why the wrong tool was selected:
- Did the tools share a trigger word? (e.g., both respond to "save this")
- Was the wrong tool's name or description a closer match to the user's phrasing?
- Did one tool shadow the other?

Keep this short — the user wants a fix, not a lecture.

## Step 3: Draft a Routing Rule

Write a CLAUDE.md routing rule that prevents this specific misrouting:

```
When I say "[the trigger phrase that caused the problem]", use [intended tool full name], not [wrong tool full name].
```

If the collision is broader than one phrase, draft a rule that covers the vocabulary:

```
For [domain/context] tasks, use [tool A]. For [other domain/context], use [tool B].
```

Show the drafted rule to the user.

## Step 4: Ask Where to Apply

Ask the user:
- **a)** Add the rule to this project's CLAUDE.md (applies to this project only)
- **b)** Add the rule to `~/.claude/CLAUDE.md` (applies to all projects)
- **c)** Skip — don't add a rule right now

If they choose (a) or (b), write the rule under a `## Tool Routing Rules` section in the appropriate file. Create the section if it doesn't exist. Append — never overwrite existing rules.

## Step 5: Check for Related Collisions

After fixing the immediate problem, check if the two conflicting servers have other overlapping tools. List any additional collisions briefly:

"These two servers also overlap on: [tool pair], [tool pair]. Want me to run a full audit with /audit-tools?"

This turns one fix into comprehensive coverage.
