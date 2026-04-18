---
stardate: 2005-04-10
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-10
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** Object store, index, refs — all functional. No usable commit workflow. Eight manual steps to make a commit.
**Ended with:** Plumbing/porcelain distinction named and formalized. First shell script wrappers exist. Commit workflow reduced from eight steps to two.

### What Mattered Today
- Plumbing/porcelain is the architectural naming decision of the day. Low-level C tools are stable plumbing. High-level scripts are replaceable porcelain. Right place to take shortcuts is porcelain. Right place to be conservative is plumbing.
- First porcelain scripts exist. Not beautiful. Functional enough that a kernel developer could use them without copying SHAs by hand.
- Target user is a kernel developer who already knows what a changeset is. Usability bar is "better than what we had" not "accessible to beginners." This scopes the problem correctly.
- Performance at kernel scale not yet benchmarked. Needs to happen before Apr 16.

---

## Raw Log

### 09:30 — Current commit workflow is eight steps
**Type:** `observation`

Written out:
1. `update-cache <file>` for every changed file
2. `write-tree` → SHA
3–6. Set four author/committer env vars
7. `echo "message" | commit-tree <sha>` → commit SHA
8. Write commit SHA into HEAD manually

Eight steps. Not a workflow.

---

### 10:00 — Naming the layers: plumbing and porcelain
**Type:** `decision`

C tools = plumbing. Stable, low-level, not for daily direct use. Shell scripts = porcelain. Human-facing, can change without breaking the foundation. Plumbing is conservative. Porcelain is where iteration happens. This naming makes the architectural principle explicit and enforceable.

---

### 11:00 — First porcelain: commit wrapper
**Type:** `closed` (partial)

Shell script wraps `update-cache`, `write-tree`, `commit-tree`, HEAD update into one command. Still requires env vars for author info. Still requires explicit file listing. But the mechanical plumbing is now one command. Good enough for kernel developers. Not good enough for anyone else.

---

### 13:30 — Performance: not yet proven at scale
**Type:** `opened`

Object store writes fast on small repos. Kernel has tens of thousands of files. Need to benchmark writes, reads, and diff operations at that scale before Apr 16 kernel import. Design should be fast — haven't proven it.

---

### 16:00 — Target user scoping
**Type:** `insight`

Kernel developers know what a patch is, what a changeset is, what a tree diff is. They used BitKeeper. They understand the model. Don't need to teach them version control — need to give them a better tool for workflows they already have. Usability problem is scoped: efficient for experts, not accessible to beginners. That's acceptable for now.
