# Captain's Log

> *"Stardate. We began with X. We now have Y. The following is worth remembering."*

A Claude skill that keeps a daily working diary — automatically.

---

## Summary

Captain's Log is a passive session note-taker. It runs in the background of your working sessions and records what actually mattered: decisions made, problems opened and closed, technical insights, business implications. Not what you did. What it meant.

Each day produces a single Markdown file with two sections:

- **Summary** — manager-readable. Started with / Ended with, signal bullets, context files created. Populated by a tidy-up pass at the end of the day.
- **Raw Log** — timestamped entries as captured throughout the session. Never edited. Permanent record.

---

## Motivation

Notes don't get taken because taking notes requires stopping work to take notes.

The insight that has value — the moment a blocker resolved, the design decision that changed the direction, the thing you figured out that you'll need to remember — happens in the middle of doing something. By the time you have time to write it down, the texture of it is gone.

Captain's Log solves this by treating note-taking as something that happens alongside work, not after it. You log commits. You save context. You say "log this" when something clicks. The skill watches for state changes and prompts when it notices something worth capturing. At the end of the day, a tidy-up pass distills the raw entries into something a manager — or future you — can read in two minutes.

The result is a daily diary that exists without requiring the discipline to keep a daily diary.

---

## Solution

Captain's Log is a Claude skill — a set of instructions that teaches Claude how to behave as a session logger across any working session.

**What it captures automatically:**
- Git commits and pushes (the *why*, not the diff — that's already in git)
- Context file and handoff document creation
- Branch switches mid-session

**What you trigger explicitly:**
- `take a note` / `log this` — logs what just happened
- `tidy up` — distills the day's raw entries into a clean Summary
- `captains log demo` — shows finished example logs before you start

**What it detects from context:**
- Current repo and branch on session start
- Ticket references from branch names (`AA-1141-feature-name` → ticket `AA-1141`)
- KR and sprint context in corporate sessions

**The day file** is a plain Markdown file stored in a location you choose on first use. One file per day. Readable without any tooling. Committable to any repo.

---

## How to Install

### One-line install (macOS/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/dhk/captains-log-repo/main/install.sh | bash
```

The script detects your Claude skills directory automatically and drops the skill in place. Works with both Claude Desktop and Claude Code.

### Clone and install

```bash
git clone https://github.com/dhk/captains-log-repo.git
cd captains-log-repo
./install.sh
```

### Manual install

1. Locate your Claude skills directory:
   - **Claude Code:** `~/.claude/skills/`
   - **Claude Desktop (macOS):** `~/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/.../skills/`
2. Create a folder named `captains-log` inside it
3. Copy `skills/captains-log/SKILL.md` into that folder
4. Restart Claude Desktop / reload Claude Code

### Stopped working?

If the skill stops responding after a Claude Desktop update, just re-run the install. Claude Desktop stores skills under a session-specific path that can change between updates. Claude Code (`~/.claude/skills/`) is unaffected by this.

### First run

On first use, Captain's Log will ask two questions:

1. **Where should logs live?**
   - `~/Documents/captains-log/` — one place for all your work
   - `captains-log/` inside each repo — logs travel with the project
   - Custom path

2. **Want to see an example first?**
   Say yes to run the interactive demo before your first real session.

You can also run the demo at any time with: `captains log demo`

---

## Demo Notes

Two complete demo log sets are included in `demo/`:

### `demo/git-1.0/` — The creation of Git, April 2005

Seven days of reconstructed working notes from Linus Torvalds building Git from scratch. Written in the register of someone logging decisions at speed — terse, technical, no ceremony.

| File | Day | Event |
|------|-----|-------|
| `captains-log-2005-04-07.md` | Day 1 | Initial commit. Object model locked. Self-hosting achieved. |
| `captains-log-2005-04-08.md` | Day 2 | Index and three-space model. zlib compression. |
| `captains-log-2005-04-09.md` | Day 3 | Refs and HEAD. Distributed design confirmed. |
| `captains-log-2005-04-10.md` | Day 4 | Plumbing/porcelain split named. First porcelain scripts. |
| `captains-log-2005-04-11.md` | Day 5 | Merge designed. Three-way algorithm. Multi-parent commits. |
| `captains-log-2005-04-14.md` | Day 6 | `.git` rename. `git-` prefix. rsync fetch. Kernel-ready. |
| `captains-log-2005-04-16.md` | Day 7 | Linux kernel commit. 6.7M lines. Original problem closed. |

### `demo/genesis/` — The Seven Days of Creation as an Engineering Build

The same seven-day arc, completely different voice. Dr. McCoy is the engineer on call. Spock files the tickets. Kirk ships things before the dependencies are ready. Written with raw notes that include internal conflict, deferred debt, and the moment someone realizes they've built something alive.

| File | Day | Event |
|------|-----|-------|
| `day-01-light-and-darkness.md` | Day 1 | Observability layer. Light as a global variable. GENESIS-001 filed. |
| `day-02-firmament.md` | Day 2 | Partition layer. Dome geometry. Known debt logged. |
| `day-03-land-seas-vegetation.md` | Day 3 | Persistence layer. Vegetation deployed before the sun. |
| `day-04-sun-moon-stars.md` | Day 4 | Energy infrastructure. Three days of debt closed at once. |
| `day-05-sea-creatures-birds.md` | Day 5 | First mobile agents. Acoustic layer. The whale incident. |
| `day-06-land-animals-humans.md` | Day 6 | Humans deployed. Free will flagged P1. Tree of Knowledge unguarded. |
| `day-07-rest.md` | Day 7 | System declared complete. 6 open tickets. McCoy signs off. |

**The demo logs serve two purposes:**
1. They show what a finished Captain's Log looks like — structure, voice, signal density
2. They demonstrate that the same format works for completely different contexts and completely different registers

Run `captains log demo` from any Claude session to browse them interactively.

---

## File Structure

```
captains-log/
├── README.md
├── install.sh
├── skills/
│   └── captains-log/
│       └── SKILL.md          # The skill definition
└── demo/
    ├── git-1.0/              # Git creation logs, April 2005
    │   ├── captains-log-2005-04-07.md
    │   ├── captains-log-2005-04-08.md
    │   ├── captains-log-2005-04-09.md
    │   ├── captains-log-2005-04-10.md
    │   ├── captains-log-2005-04-11.md
    │   ├── captains-log-2005-04-14.md
    │   └── captains-log-2005-04-16.md
    └── genesis/              # Genesis engineering build logs
        ├── day-01-light-and-darkness.md
        ├── day-02-firmament.md
        ├── day-03-land-seas-vegetation.md
        ├── day-04-sun-moon-stars.md
        ├── day-05-sea-creatures-birds.md
        ├── day-06-land-animals-humans.md
        └── day-07-rest.md
```

---

## License

MIT. Use it, fork it, adapt it. If you build something interesting with it, the log is probably a good place to document what you learned.
