---
stardate: 2005-04-07
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-07
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** No version control system. BitKeeper license revoked. Kernel development blocked.
**Ended with:** Working object store. Git self-hosted from first commit. Core architecture locked.

### What Mattered Today
- Content-addressable storage is the right model. SHA-1 of content = identity of object. Deduplication and integrity checking fall out for free.
- Object model complete: blob, tree, commit, tag. Four types. Nothing else needed.
- Self-hosting achieved on first commit — `e83c5163`. The tool used itself to record its own creation. Proof of concept.
- This is a filesystem, not an SCM. That framing keeps the design clean.
- Usability problem is already visible. Making a commit requires eight manual steps. That's a future problem.

### Context Files Created
- `README` — object model description, four object types, design intent.

---

## Raw Log

### 09:00 — Design decision: content-addressable storage
**Type:** `aha`

SHA-1 of content = identity. Same content, same hash, always. Different content, different hash, always. Deduplication is free. Corruption is detectable by definition. No filename required to address an object. The hash IS the address. This is the right model. Everything else builds on this.

---

### 09:45 — Object types: four, fixed
**Type:** `decision`

- **blob** — file contents, no name, no path
- **tree** — directory listing, maps names to blob hashes
- **commit** — pointer to tree, parent list, author, message
- **tag** — named pointer to a commit

Four types. No more. Complexity goes in the tooling, not the model.

---

### 10:30 — Design framing: filesystem, not SCM
**Type:** `insight`

Not building a version control system. Building a content-addressable filesystem that tracks history. No workflow opinions. No enforced branching strategy. Just objects and pointers. This framing keeps future decisions clean.

---

### 15:13 — First commit: `e83c5163`
**Type:** `closed`

Self-hosting. Git committed itself. 10 files, ~1,000 lines of C. Tools exist: `init-db`, `update-cache`, `write-tree`, `commit-tree`, `read-tree`, `cat-file`, `show-diff`. Object store works. Original problem (no VCS for kernel) not closed yet — this is the foundation.

---

### 15:30 — Usability gap logged
**Type:** `opened`

Current commit workflow: run `update-cache` per file, run `write-tree`, set 4 env vars manually, run `commit-tree`, copy returned SHA by hand into HEAD file. Eight steps. Not a workflow. Porcelain is a future problem.
