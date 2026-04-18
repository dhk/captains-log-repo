---
stardate: 2005-04-14
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-14
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** Git functional for single-user single-machine use. Not ready for kernel developers.
**Ended with:** `.git` rename done. `git-` command prefix established. rsync fetch roughed in. Performance confirmed at kernel scale. Two days to kernel import.

### What Mattered Today
- `.dircache` → `.git` rename complete. Window was closing. Done before anyone outside this machine used it.
- `git-` prefix unifies all tools: `git-commit`, `git-diff`, `git-log`. Discoverability goes up. Porcelain shape is visible.
- rsync fetch works between two machines. Crude — sends more than necessary, no object negotiation. Sufficient to start. Native protocol is future work.
- Performance test at kernel scale passed. 17,000 files, object store handled it. Design vindicated at target scale.
- Two days to kernel commit. Deadline is real.

### Context Files Created
- Internal notes on fetch/rsync transport — what it handles now, what native protocol needs to handle later.

---

## Raw Log

### 08:30 — `.dircache` → `.git`: now
**Type:** `decision`

Nobody outside this machine has used it yet. That window closes the moment kernel developers start. Renamed. `.git` is obvious and self-describing. Done.

---

### 09:15 — `git-` prefix: all commands
**Type:** `decision`

Tools currently named `update-cache`, `write-tree`, `commit-tree` — no namespace, invisible in a crowded PATH. New convention: `git-<verb>`. `git-update-cache`, `git-write-tree`, `git-commit`. Eventually a top-level `git` dispatcher. Users type `git commit`. Plumbing stays `git-commit-tree` for scripts. Porcelain is `git commit` for humans.

---

### 10:45 — rsync fetch: works, wrong long-term
**Type:** `observation`

Two machines can exchange objects by rsyncing `.git/objects`. Not efficient — transfers everything regardless of what the other side has. No object negotiation. For kernel scale this will be slow and bandwidth-heavy. Adequate to start. Native protocol needed: enumerate what each side has, negotiate minimal transfer, send delta only. Future work.

---

### 13:00 — Performance at kernel scale: confirmed
**Type:** `closed`

Ran import of Linux 2.6.12-rc2 tree. 17,000 files. Object store handled it. Index handled it. Write time acceptable. Git is not slow. Performance goal confirmed at target scale. Full patch-application benchmark still pending — targeting 29 April.

---

### 15:30 — Pre-kernel checklist
**Type:** `observation`

What's left before Apr 16:
- `.git` rename ✓
- `git-` prefix ✓
- Enough porcelain for kernel developers to use without embarrassment — marginal
- Merge tested with a real branch — not yet

Apr 16 is a proof of concept, not a launch. But it's public. Once it works, people will ask to use it.
