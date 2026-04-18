---
stardate: 2005-04-11
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-11
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** Single linear history only. No merging. No way to combine divergent work.
**Ended with:** Merge concept designed. Three-way algorithm decided. Object model already supports it — commit parents are a list, not a single pointer.

### What Mattered Today
- Commit parents are a list. Designed it that way from day one without fully reasoning through why. A merge commit has two parents. The object model already supports this. Good design anticipates use cases.
- Three-way merge is the correct algorithm. Two-way merge produces false conflicts. Three-way finds the common ancestor, diffs both sides against it, combines. CVS does two-way — that's why CVS merges are painful.
- Without merge, Git is a personal tool. With merge it's a collaboration tool. The kernel workflow requires merge — subsystem maintainers work in parallel, Linus pulls from all of them. This is the reason Git exists.
- `.dircache` rename overdue. Needs to happen before kernel developers touch it.

---

## Raw Log

### 09:15 — Kernel workflow requires merge
**Type:** `observation`

Kernel structure: tree maintainer (me) + subsystem maintainers (net, drivers, fs, etc). Each works independently. I pull from all of them at release time. Changes will conflict. Without merge, this workflow doesn't exist. Merge is not optional.

---

### 10:30 — Object model already supports merge commits
**Type:** `aha`

Commit object has a parent list, not a single parent pointer. Designed it as a list. A merge commit = two parents. Model supports this without modification. The right design was already there before the use case was fully articulated.

---

### 11:00 — Three-way merge: decision
**Type:** `decision`

Two-way merge diffs A against B. Produces false conflicts wherever A and B both changed from a common base in the same direction. Three-way merge finds common ancestor C, diffs A vs C and B vs C, combines. Only a real conflict if both sides changed the same region. CVS does two-way. That's why CVS merges are painful. Three-way from the start.

---

### 13:00 — `.dircache` rename is overdue
**Type:** `observation`

Repository metadata directory is called `.dircache`. Wrong name. Should be `.git`. Window to rename without breaking anyone is closing — once kernel developers use it, renaming is a compatibility break. Rename before Apr 16.

---

### 15:30 — Conflict UX undefined
**Type:** `opened`

When three-way merge fails, user needs to see: here is the conflict, here are both versions, resolve manually. CVS conflict marker convention is familiar. Will adopt it. User experience of conflict resolution not yet designed. Needed before real use.
