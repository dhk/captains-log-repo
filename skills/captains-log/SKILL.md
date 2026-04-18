---
name: captains-log
description: "Passive session note-taker that observes working sessions and records structured log entries to a repo file. Captures state changes, problems opened/closed, technical aha moments, business insights, and workflow observations — not implementation details or play-by-play. Trigger this skill whenever the user makes a git commit or push, saves context, creates a context file, says 'take a note', 'log this', 'note that', 'add to the log', 'what have we done today', 'give me my session log', 'tidy up', 'clean up the log', or ends a working session. Also trigger when significant state changes are observed mid-session — a problem resolved, a decision made, a direction shifted. Trigger on 'captains log help', 'captain's log help', or 'cl help' to show the help screen. Trigger on 'captains log demo' to show the interactive demo. This skill runs continuously in the background of any working session, not just at the end."
---

# Captain's Log

> *"Stardate. We began with X. We now have Y. The following is worth remembering."*

A passive, always-on session logger. Observes working sessions and records structured entries to a Markdown file in a dedicated repo. The log captures state changes and signal — not the journey, just the delta.

---

## Core Philosophy

**What belongs in the log:**
- Technical aha moments — something that wasn't understood before, now is
- Business insights — implications for strategy, process, or prioritization
- Workflow/process observations — something about how work gets done worth preserving
- Problems opened — a blocker, question, or unknown that emerged
- Problems closed — a blocker, question, or unknown that was resolved
- Decisions made — a fork in the road, and which path was taken
- Context files created — a named artifact that preserves state for future sessions

**What does not belong:**
- Implementation details (how a query was written, what flags were used)
- Play-by-play narration of what happened
- Tool outputs, code snippets, or raw data
- Anything that would only matter during the session itself

The test: *Would this be interesting to read in 6 months?* If yes, log it. If no, skip it.

---

## Log File Structure

### File layout
```
captains-log/
  captains-log-YYYY-MM-DD.md       # One file per day
```

Location depends on config (see First-Run Setup).

### Day file — two-fold structure

Each day file has two sections. The Summary is manager-readable. The Raw Log is the timestamped record.

``` markdown
# Captain's Log — YYYY-MM-DD
**Repo:** [repo name]  **Branch:** [branch name]  **Ticket:** [if detected]

---

## Summary
> *Populated by the tidy-up pass. Empty until then.*

**Started with:** [one line — situation at top of day]
**Ended with:** [one line — situation at close of day]

### What Mattered Today
[3-7 bullets. Signal only. Written for a manager who wasn't in the room.]

### Context Files Created
[List any context files created, with one-line descriptions. Omit if none.]

---

## Raw Log

### HH:MM — [Entry Title]
**Context:** [work stream, ticket, KR, or project — if applicable]
**Type:** `aha` | `insight` | `thought` | `decision` | `opened` | `closed` | `observation` | `context-file`

[2-4 sentences max. Lead with the signal.]

---
```

---

## Entry Types

| Type | Meaning |
|------|---------|
| `aha` | Something technical that clicked — a new understanding |
| `insight` | A business or strategic implication worth preserving |
| `thought` | A half-formed idea or hypothesis worth preserving — not yet a decision, not yet an insight, but worth capturing before it evaporates |
| `decision` | A fork was reached and a path was chosen |
| `opened` | A problem, question, or unknown emerged |
| `closed` | A problem, question, or unknown was resolved |
| `observation` | A workflow or process note — how work gets done |
| `context-file` | A context file was created — name it, describe what it preserves |

---

## Branch Detection

On activation, attempt to detect the current git branch:

```bash
git branch --show-current
```

**If successful:** Parse branch name for ticket reference using pattern `[A-Z]{2,3}-\d{1,4}` (e.g. `AA-1141`, `ANA-42`). Convention is `TICKET-title-words` — ticket prefix auto-populates the Context field on every entry. No need to ask.

Examples:
- `AA-1141-improve-ingestion-pipeline` → ticket `AA-1141`
- `ANA-42-refactor-dbt-models` → ticket `ANA-42`

**If no ticket prefix found:** Record branch as-is. Leave Context blank.

**If detection fails:** Ask: *"What repo and branch are we working in today?"*

**If branch switches mid-session:** Re-run detection. Log the switch as an `observation`. Update header and carry new ticket forward.

---

## First-Run Setup

On first use, check for `~/.captains-log-config`. If missing, run onboarding.

### Onboarding

Greet the user:

> "Captain's Log keeps a daily diary of your working sessions — what you started with, what changed, what mattered. Two quick questions before we begin."

**Question 1 — Where should logs live?**

Offer three options:

> **A) Global folder** — `~/Documents/captains-log/`
> One place for all your work. Good if you move between projects frequently.
>
> **B) Per-repo** — `captains-log/` inside each repo root
> Logs travel with the project and live in version control. Note: Captain's Log is a daily diary, not a per-ticket log — if you work across multiple repos in a day, each repo only captures its own context.
>
> **C) Custom path** — specify your own

**Question 2 — Want to see example logs?**

> "I have demo logs from two real projects — the creation of Git in April 2005, and the seven days of Genesis reframed as an engineering build. Want to see one before we start?"

If yes, run the demo flow (see Demo Commands below).

Write config to `~/.captains-log-config`:

```
location=global           # or: per-repo, custom
path=~/Documents/captains-log   # omit for per-repo
```

Never ask again. To reconfigure: *"reconfigure captain's log."*

---

## Demo Commands

### `captains log demo`

Interactive demo. Shows what a finished log looks like. Run at any time — first-run or not.

**Step 1 — Choose a demo project:**

> "Two demo projects available:
>
> **1. Git — April 1995** — Seven days in Linus Torvalds' notes as he built Git from scratch. Terse. Technical. Decisions logged at speed.
>
> **2. Genesis — The Engineering Build** — The seven days of creation reframed as a system build, narrated by Dr. McCoy with tickets filed by Spock. Same format, completely different voice.
>
> Which would you like to see? (or 'both')"

**Step 2 — Show the summary view:**

Display a compact summary — one line per day:

===
Git — April 2005
─────────────────────────────────────────────────────
Day 1  Apr 7   Self-hosting achieved. Object model locked.
Day 2  Apr 8   Index and three-space model. zlib compression.
Day 3  Apr 9   Refs and HEAD. Distributed design confirmed.
Day 4  Apr 10  Plumbing/porcelain split named. First porcelain.
Day 5  Apr 11  Merge designed. Three-way algorithm. Multi-parent commits.
Day 6  Apr 14  .git rename. git- prefix. rsync fetch. Kernel-ready.
Day 7  Apr 16  Linux kernel commit. 6.7M lines. Problem closed.
===

**Step 3 — Offer to drill in:**

> "Want to see a full day? Pick a number (1–7) or 'all'."

When a day is selected, display the full two-fold log — Summary first, Raw Log below.

**Step 4 — Offer to switch projects or start logging:**

> "See the other demo, or ready to start your own log?"

---

## Trigger Behaviors

### On activation / session start
Check for `~/.captains-log-config`. If missing, run first-run onboarding.

Detect branch. If no log file exists for today, create it with the two-fold template. Ask:
> *"Captain's Log — [date], [repo/branch]. What are we starting with today?"*

Use their answer to populate **Started with:** as a placeholder (refined on tidy-up).

### On git commit or push
Extract commit message as a hint. Write a raw log entry capturing *why* the commit matters — not what changed. The diff is in git; the log captures intent and implication.

### On context file creation
Log immediately as a `context-file` entry:

===markdown
### HH:MM — Context File Created: [filename]
**Type:** `context-file`
[filename] created. Preserves: [one line on what state this captures and why.]
===

Also surfaces in **Context Files Created** during tidy-up.

### On context save / handoff
Note what state is being preserved and what a future session needs to know picking this up cold.

### On "take a note" / "log this"
Write raw log entry immediately. Classify type. Ask for clarification only if signal is genuinely ambiguous.

### On passive mid-session observation
If a significant state change is observed — problem closes, decision crystallizes, direction shifts — prompt:
> *"Worth logging? [one-line description]"*

Don't interrupt flow. If ignored or declined, move on.

### On "tidy up" / "clean up the log" / end of session
Run the tidy-up pass.

---

## Tidy-Up Pass

Raw log is captured as-you-go: noisy, redundant, mid-thought. Tidy pass produces the clean Summary.

**What tidy-up does:**
1. Read all raw log entries for the day
2. Merge related entries (3 notes on same problem → 1 closed entry)
3. Promote sharpest signal if something noted multiple times
4. Rewrite in clean declarative register — factual, no hedging
5. Populate **What Mattered Today** (3-7 bullets, signal only)
6. Populate **Context Files Created** list from `context-file` entries
7. Update **Ended with:** based on arc of the day
8. Leave Raw Log completely intact — never edited, permanent record

Tidy-up can run multiple times. Each pass refreshes Summary from all raw entries to that point.

---

## Writing Style

Entries are factual, signal-forward, no editorializing. Short declarative sentences. No hedging.

**Good:**
> Discovered that the existing dbt lineage graph cannot be queried without a paid Datafold license. Blocked the KEA peer review automation as designed. Pivoting to static lineage snapshot approach.

**Not good:**
> We were working on the KEA skill and ran into some issues with dbt lineage. After some investigation it turned out that Datafold has licensing restrictions which might affect our approach going forward.

Summary bullets are written for a manager who wasn't in the room. Complete thoughts. No jargon without a one-phrase gloss.

---

## Context Modes

### Personal / Open Work
No external ticket system. Use project name as context field.

### Corporate Work
Ticket auto-detected from branch name (`[A-Z]{2,3}-\d{1,4}`). Pre-populates Context field — no manual input.

If a KR or OKR is also relevant:
===markdown
**Context:** AA-1141 / KR: Reduce time-to-insight by 30%
===

Ask about KR anchoring at session start if work seems strategically significant. Carry forward if confirmed. Note sprint context if known.

---

## Help

When user types "captain's log help", "captains log help", or "cl help":

---

**Captain's Log** — your daily working diary.

Runs in the background. Captures what changed, what you learned, what mattered. Skips the play-by-play.

**Commands:**
| Say this | What happens |
|----------|-------------|
| `take a note` / `log this` | Logs what just happened |
| `what have we done` | Shows today's raw log |
| `tidy up` | Cleans raw log into manager-readable Summary |
| `give me my session log` | Shows full day file |
| `captains log demo` | Interactive demo with real example logs |
| `captains log help` | Shows this |
| `reconfigure captain's log` | Changes storage location |

**Auto-logged:**
- Git commits and pushes — the *why*, not the diff
- Context file creation — name and what it preserves
- Branch switches mid-session

**Logs live at:** your configured path (run `captains log demo` to see examples before configuring)

---
