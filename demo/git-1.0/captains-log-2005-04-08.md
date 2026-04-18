---
stardate: 2005-04-08
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-08
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** Object store working. No staging concept. No compression. Commits require manually tracking every file state.
**Ended with:** Index exists. Three-space model established. zlib compression on all objects. The working tree, the index, and the repository are now distinct.

### What Mattered Today
- The index is not an implementation detail — it is a workflow philosophy. Explicit staging means you choose what goes into a commit. CVS collapses working tree and staging; that's why CVS commits are anxious. Git separates them.
- Three spaces: working tree (what's on disk), index (what you've staged), repository (what's committed). This is the architecture.
- zlib on every object. SHA-1 computed on uncompressed content, storage is compressed. Without this, object database for a medium project runs into gigabytes fast.
- `show-diff` now works against the index. Three-space model is visible for the first time.

---

## Raw Log

### 08:00 — Three-space model
**Type:** `aha`

Three distinct states for any file:
1. Working tree — what's on disk
2. Index — what you've said you want to commit
3. Repository — what's been committed

CVS conflates 1 and 2. Git separates them. The index is intentional. This is not optional complexity — it's the point.

---

### 09:30 — Index implementation
**Type:** `observation`

Index lives in `.dircache/index`. Binary file, flat list of cache entries: path, mode, size, mtime, SHA-1. `update-cache` writes it. `read-cache.c` reads it. Fast. Simple. Bridge between working tree and repo.

---

### 10:45 — Compression: zlib on write
**Type:** `decision`

Every object zlib-compressed on write. SHA-1 computed on uncompressed content — address is stable, storage is efficient. Without compression, kernel-scale object database is impractical. Decided to compress at write time, not lazily. No reason to defer it.

---

### 14:15 — `show-diff` works against index
**Type:** `closed`

Can now compare working tree against index before staging. Three-space model is user-visible. First time the architecture is observable rather than just internal.

---

### 16:00 — Reference problem still open
**Type:** `observation`

After a commit, `commit-tree` prints a SHA to stdout. No way to find that commit again without writing it down externally. No HEAD, no branch, no moving pointer. Object store is clean. Reference system doesn't exist yet.
