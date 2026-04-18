# The Notes You Never Take

*Field Notes — dhkondata.substack.com*

---

Here's the version of this I lived for years: finish a work session, look back at what happened, and find nothing. No record of the decision that changed the direction. No note about the thing that finally clicked. Just artifacts — files, commits, tickets — and the fading memory of why any of it matters.

The problem isn't discipline. It's timing. The insight worth keeping happens in the middle of doing something. By the time you have space to write it down, the texture is gone. You remember the conclusion but not the reasoning. You remember the outcome but not the fork in the road that got you there.

I built something to fix this. It's called Captain's Log.

---

## What it is

Captain's Log is a Claude skill — a set of instructions that teaches Claude to act as a passive session logger alongside any working session.

It doesn't track what you did. Git does that. Tickets do that. It tracks what it meant.

Every session produces a Markdown file with two sections:

**The Raw Log** — timestamped entries captured as the session goes. Rough. Real. Written at speed.

**The Summary** — a distillation pass at the end of the day. Three to seven bullets. Signal only. Written for a manager who wasn't in the room, or for the version of you who opens this file in six months and needs to remember what was actually happening.

The raw log is never edited. It's the record. The summary is the distillation. Both live in the same file.

---

## How it works in practice

You don't start it. It starts when you start working.

On the first notable event — a git commit, a "take a note," a context save — Captain's Log activates. It detects your repo and branch. If your branch name follows the convention `TICKET-title` (say, `ANA-42-refactor-models`), it pulls the ticket reference automatically and pre-populates it on every entry for the session. You don't have to remember to tag things.

During the session, the prompts are minimal. When something significant happens — a problem closes, a decision crystallizes — it surfaces a one-liner: *"Worth logging? [description of what happened]."* You say yes or ignore it. Either way, you stay in flow.

When you make a git commit, it logs the *why* behind the commit message. Not what changed — that's in the diff. Why it matters. What shifted.

When you create a context file or a handoff document, that gets logged too. Name and one-line description of what it preserves.

At end of day, you say *"tidy up."* The raw entries get distilled into the Summary. Related notes collapse into single entries. The sharpest version of each insight surfaces. The **Started with** and **Ended with** lines get written. The raw log stays untouched below.

---

## The format question

I spent time thinking about what a session log entry should look like before I built this. The instinct is to make it flexible — let people write whatever. But flexible formats produce noise. The goal is signal density.

Every entry has a type:

| Type | What it captures |
|------|-----------------|
| `aha` | Something technical that clicked |
| `insight` | A business or strategic implication |
| `decision` | A fork reached, a path chosen |
| `opened` | A problem or unknown emerged |
| `closed` | A problem or unknown resolved |
| `observation` | Something about how the work gets done |
| `context-file` | A handoff artifact was created |

The type does two things. It forces you to characterize what you're logging — you can't write *"spent time on X"* if you have to pick whether it's an `aha` or an `observation.* And it makes the log filterable later. Show me all the `decision` entries from the last month. Show me everything that was `opened` but not `closed`.

---

## The demo problem

Skills are hard to explain in the abstract. You need to see one working to understand what it produces.

I needed demo logs — real-looking sessions that show the format in use. Contrived examples feel thin. Real work sessions are private.

So I reconstructed two historical ones.

**The first is the creation of Git.** April 7–16, 2005. Linus Torvalds, ten days, building a version control system from scratch because BitKeeper's license got revoked and the Linux kernel needed something immediately. The commit history is public. The design decisions and their rationale are documented in mailing list archives and retrospective interviews. I reconstructed seven days of working notes in the voice they'd have been written: terse, technical, no ceremony. A decision logged in two sentences. An insight stated once. Next problem.

**The second is the seven days of Genesis, reframed as an engineering build.** Same format, completely different register. Dr. McCoy is the engineer on call. Spock files the tickets. Kirk ships things before the dependencies are ready. Uhura notices the communication problems nobody else logged. The raw entries have internal conflict, deferred debt, and a wall covered in warnings nobody acted on.

The Genesis logs are not serious engineering documentation. They're a demonstration that the same format works for completely different contexts — and that the voice of the author is what makes a log worth reading, not the structure.

Both sets are in the repo. Run `captains log demo` from any Claude session to browse them interactively.

---

## What surprised me

I expected the value to be retrospective — you'd look back at a week of logs and find the thread you'd lost. That's real. But the bigger value turned out to be prospective.

The act of logging a decision forces you to state it. *A fork was reached. This path was chosen. Here's why.* That sentence — written at the moment of choosing — is worth more than any amount of retroactive reconstruction. It's the reasoning, not just the conclusion.

The `opened` / `closed` pattern turned out to matter more than I expected. An opened entry is a commitment to return to something. A closed entry is the proof that you did. The log becomes a lightweight accountability system without requiring a separate project management tool.

And the tidy-up pass — the distillation at the end of the day — turned out to be the most valuable step. Not because the summary is better than the raw log. Because writing the summary forces you to answer the question: *what actually mattered today?* That question, asked daily, changes how you work. You start building toward an answer worth writing.

---

## The install

Captain's Log is a Claude skill. One file. Drop it in your Claude skills directory and it's live.

The repo includes:

- The skill definition (`skills/captains-log/SKILL.md`)
- An install script that finds your Claude skills directory automatically
- Both demo log sets (`demo/git-1.0/` and `demo/genesis/`)
- This README

On first use, it asks two questions: where to store logs, and whether you want to see a demo first. After that it runs in the background.

The logs are plain Markdown files. No database. No proprietary format. Readable without any tooling. Committable to any repo.

**→ [github.com/dhk/captains-log](https://github.com/dhk/captains-log)**

---

## The thing I keep coming back to

The notes you take are a record of how you think, not just what you did. Most knowledge work produces artifacts — documents, code, tickets, dashboards. The artifacts are what you made. The notes are how you made them, and why, and what you learned.

Most of that disappears.

Captain's Log is an attempt to stop it disappearing — not by demanding more discipline, but by making capture cheap enough that it happens naturally alongside the work.

The log doesn't tell you what to do next. It tells you what you actually did. Those are different things. Both matter.

---

*Captain's Log is open source and free to use. The repo includes install instructions, demo logs, and a help command. Questions and contributions welcome.*

*— dhk*
