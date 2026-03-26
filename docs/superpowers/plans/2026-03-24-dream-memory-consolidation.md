# Dream Memory Consolidation Skill — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a `/dream` slash command that performs a 4-phase memory consolidation pass — orienting on existing memories, gathering recent signal from transcripts, merging updates into topic files, and pruning the MEMORY.md index. This replicates the Auto Dream feature that Anthropic is rolling out server-side (gated by `tengu_onyx_plover` flag).

**Architecture:** Single markdown file at `~/.claude/commands/dream.md` that acts as a global slash command. Invoked via `/dream` in any Claude Code session. The command instructs Claude to perform a read-only pass over project files (only writing to memory directory), following 4 phases adapted from the official consolidation prompt but customized for this user's existing auto-memory conventions.

**Tech Stack:** Claude Code custom slash commands (markdown), bash (for transcript grepping)

---

## File Structure

```
~/.claude/commands/
  dream.md              # The slash command (SKILL.md equivalent) — single file, self-contained
```

No supporting files needed. The command is self-contained markdown with inline instructions.

---

### Task 1: Research — Validate Auto-Memory Conventions

Ensure the dream command aligns exactly with the user's existing memory system conventions before writing anything.

**Files:**
- Read: `~/.claude/projects/-home-philgood-projects-drphilgood-com/memory/MEMORY.md`
- Read: `~/.claude/projects/-home-philgood-projects-drphilgood-com/memory/feedback_never_delete_mcp_plugin.md`
- Read: One transcript `.jsonl` file (first 50 lines) to understand format

- [ ] **Step 1: Read the existing MEMORY.md index**

Confirm format: `# Memory Index` header, `## Type` sections, markdown links with one-line descriptions.

- [ ] **Step 2: Read the existing memory file**

Read `feedback_never_delete_mcp_plugin.md` to confirm frontmatter format:
```yaml
---
name: {{name}}
description: {{one-line}}
type: {{user|feedback|project|reference}}
---
```
Plus body content with `**Why:**` and `**How to apply:**` lines for feedback/project types.

- [ ] **Step 3: Sample a transcript file**

```bash
head -5 ~/.claude/projects/-home-philgood-projects-drphilgood-com/*.jsonl | head -50
```

Understand JSONL structure so grep instructions in the command are accurate.

- [ ] **Step 4: Document conventions**

Note any discrepancies between the system prompt's auto-memory spec and actual file contents. The dream command must match reality, not just spec.

---

### Task 2: Write the Dream Command

Create `~/.claude/commands/dream.md` — the core deliverable.

**Files:**
- Create: `~/.claude/commands/dream.md`

- [ ] **Step 1: Write the command file**

The command must include:

1. **Safety constraints** — read-only on project code, only writes to memory directory
2. **Dynamic path resolution** — derive memory dir and transcript dir from current working directory using Claude Code's slugification pattern (`/` → `-`)
3. **Phase 1: Orient** — `ls` memory dir, read MEMORY.md, skim topic files
4. **Phase 2: Gather Signal** — grep transcripts narrowly (user corrections, save requests, decisions, patterns), check for drifted memories, scan CLAUDE.md for uncaptured info
5. **Phase 3: Consolidate** — write/update memory files following exact frontmatter format, merge into existing files, convert relative→absolute dates, delete contradicted facts, respect the "what NOT to save" rules
6. **Phase 4: Prune & Index** — update MEMORY.md under 200 lines, organize by type sections, remove stale entries
7. **Output format** — structured summary of what changed

Key design decisions:
- The command is **global** (`~/.claude/commands/`) so it works in any project
- Path resolution is **dynamic** — computes the slug from `$PWD` at runtime
- Grep patterns target **high-signal terms**: "no", "don't", "stop", "wrong", "remember", "save", "decided", "prefer"
- Explicitly forbids modifying any files outside the memory directory
- Explicitly forbids exhaustive transcript reading (grep narrowly only)
- References the system prompt's auto-memory conventions as source of truth for memory types and what NOT to save

```markdown
# Dream: Memory Consolidation

You are performing a **dream** — a reflective pass over your memory files...
[Full content — see Step 1 below for complete file]
```

- [ ] **Step 2: Verify the command is discoverable**

```bash
ls -la ~/.claude/commands/dream.md
```

Expected: file exists, readable.

- [ ] **Step 3: Test invocation**

In a Claude Code session, type `/dream` and verify the command loads. It should appear in autocomplete and execute the 4-phase consolidation.

- [ ] **Step 4: Commit**

```bash
cd ~/.claude && git add commands/dream.md && git commit -m "feat: add /dream memory consolidation command"
```

Note: `~/.claude` may not be a git repo. If so, skip this step — the file persists without version control.

---

### Task 3: Verify — Manual Dream Run

Run the dream command on the current project (drphilgood.com) to validate it works end-to-end.

**Files:**
- Read: `~/.claude/projects/-home-philgood-projects-drphilgood-com/memory/*`
- Potentially create/modify: memory files in that directory

- [ ] **Step 1: Invoke `/dream` in this session**

Run the command and observe each phase executes correctly:
- Phase 1 lists memory files and reads index
- Phase 2 greps transcripts for signal (should find corrections, preferences)
- Phase 3 creates/updates memory files with correct frontmatter
- Phase 4 updates MEMORY.md within 200-line limit

- [ ] **Step 2: Verify output format**

Confirm the summary includes:
```
## Dream Summary
**Scanned:** X memory files, Y transcript files
**Created:** [list]
**Updated:** [list]
**Pruned:** [list]
```

- [ ] **Step 3: Verify memory file quality**

Read any newly created/updated memory files and confirm:
- Frontmatter is valid YAML with name, description, type
- Content follows conventions (feedback has Why/How to apply, dates are absolute)
- No duplicate memories
- MEMORY.md index is accurate and under 200 lines

---

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Global vs project command | Global (`~/.claude/commands/`) | Dream should work in any project, not just drphilgood.com |
| Path resolution | Dynamic from `$PWD` | Avoids hardcoding project paths |
| Transcript search strategy | Narrow grep with specific terms | Matches Anthropic's official approach; avoids context bloat |
| Memory format | Match existing auto-memory conventions | Consistency with system prompt; no new format to learn |
| File structure | Single self-contained markdown | No supporting files needed; command is instructions only |
| Safety | Explicit read-only constraint on project code | Matches Anthropic's safety model; dream should never modify source |

## Success Criteria

1. `/dream` appears in Claude Code autocomplete
2. Running `/dream` executes all 4 phases without errors
3. Memory files created/updated follow exact frontmatter conventions
4. MEMORY.md stays under 200 lines
5. No project source files are modified
6. Transcript grep is narrow (no full-file reads)
7. Output summary is clear and actionable
