---
stardate: 2005-04-09
repo: git
branch: main
engineer: Linus Torvalds
---

# Captain's Log — 2005-04-09
**Repo:** git  **Branch:** main

---

## Summary

**Started with:** No way to navigate history without manually tracking SHA hashes.
**Ended with:** HEAD exists. Refs exist. History is navigable by name. Branch architecture clear. Distributed model confirmed.

### What Mattered Today
- A ref is a text file containing a SHA. That's it. HEAD is `.dircache/HEAD`. Moving HEAD means overwriting a file. No database, no locking, no protocol. Trivially simple, fundamentally important.
- Branches will be refs in a namespace. Creating a branch = creating a file. Deleting = deleting a file. Switching = updating HEAD. Branching is nearly free.
- Confirmed: no central server, ever. Every clone is a full repository. SHA-1 addresses are permanent. This is consistent with content-addressable model. The design is coherent end to end.
- rsync is the only sync mechanism today. Not a long-term solution. Logged.

---

## Raw Log

### 09:00 — Refs: a file is a reference
**Type:** `aha`

A reference = a text file containing a SHA-1. HEAD = `.dircache/HEAD`. To advance HEAD, overwrite the file. To read HEAD, read the file. No database. No locking. Git is already a filesystem — refs are just filesystem pointers. This resolves the SHA-tracking problem completely.

---

### 10:30 — Branch model
**Type:** `decision`

Branches = refs stored at conventional paths. Eventually `.git/refs/heads/main`. Create branch = create file. Delete branch = delete file. Switch branch = update HEAD to point at different ref. No server coordination. No locking. Just file operations. Branching is cheap by design.

---

### 13:00 — Distributed: no central server
**Type:** `decision`

BitKeeper and SVN require a central server for authoritative history. Single point of failure. Offline work impossible. Git will be fully distributed — every clone is a full repository. SHA-1 addresses are permanent by definition; no external references that break if a server goes down. Consistent with content-addressable model. Design is coherent.

---

### 15:45 — rsync sync gap
**Type:** `opened`

Two repositories can only synchronize today via rsync of `.dircache`. Works for solo use. Does not scale to 200 kernel developers. A native transfer protocol needs to: enumerate objects each side has, negotiate minimal transfer set, send only the delta. Future work. Not blocking today.
