# Skill: push-issues

Push all issue files from the `issues/` folder to GitHub Issues interactively.

## When This Skill Is Used
The PM runs `issue-push-agent` after merging the user-story-agent PR.
The agent follows this skill to preview, confirm, and create GitHub Issues.

---

## Step 1 — Read Issue Files

Read every `.md` file inside `issues/`. Skip any file named `.gitkeep`.

For each file extract:
- **Title** — the first line that starts with `# ` (strip the leading `# `)
- **Role label** — derived from the filename prefix:
  - `database-*` → `database`
  - `backend-*`  → `backend`
  - `frontend-*` → `frontend`
  - `playwright-*` → `playwright`
  - anything else → `user-story`
- **Feature label** — strip the role prefix from the filename (e.g. `database-booking` → `booking`)
- **Step label** — find the first line matching `^Step [0-9]` inside the file;
  extract the number and format as `step-NN` (zero-padded, e.g. `step-03`)
- **Body** — the full file content

---

## Step 2 — Present Confirmation List

Before creating anything, display the full list of issues found:

```
I found N issue files ready to push:

  1. [DATABASE] Room Catalogue        labels: database, user-story, step-01, room
  2. [BACKEND] Room API               labels: backend,  user-story, step-02, room
  3. [FRONTEND] Room Listing Page     labels: frontend, user-story, step-03, room
  4. [PLAYWRIGHT] Room Booking Flow   labels: playwright, user-story, step-04, room

Reply "push all" to create all issues.
Reply "skip 2,4" (or any numbers) to exclude specific issues.
Reply "cancel" to abort.
```

**Wait for the user's reply before proceeding.**

---

## Step 3 — Apply User's Response

- `push all` — proceed with all N files
- `skip N,M,...` — remove those numbered files from the list; proceed with the rest
- `cancel` — stop and do nothing

If the user's reply is ambiguous, ask for clarification before proceeding.

---

## Step 4 — Deduplicate

Before creating each issue, check if a GitHub Issue with the exact same title already exists (open issues, case-sensitive exact match).

- If a match is found → skip and note it as **skipped (duplicate)**
- If no match → proceed to create

---

## Step 5 — Ensure Labels Exist

Before creating any issue, ensure the following standard labels exist (create if missing):

| Label | Color | Description |
|---|---|---|
| `user-story` | `#e4e669` | Agent-generated user story |
| `frontend` | `#0075ca` | Frontend work |
| `backend` | `#e05d44` | Backend work |
| `database` | `#6f42c1` | Database / schema work |
| `playwright` | `#00b388` | E2E Playwright tests |
| `step-01` through `step-30` | `#f9d0c4` | Assignment order step |

Also create the feature label for each issue (e.g. `booking`, `room`) with color `#bfd4f2`
and description `Feature: {name}` — create only if it does not already exist.

---

## Step 6 — Create Issues

For each confirmed, non-duplicate issue:
1. Create the GitHub Issue with:
   - title from Step 1
   - body = full file content
   - labels: role label + `user-story` + step label (if found) + feature label
2. Note the created issue number and URL

If creation fails for any issue, record the failure and continue with the rest.
Do not stop the entire run on a single failure.

---

## Step 7 — Report Results

After all issues are processed, output a summary:

```
Issue creation complete:

  ✓ Created  #12 — [DATABASE] Room Catalogue
  ✓ Created  #13 — [BACKEND] Room API
  ✗ Skipped  #—  — [FRONTEND] Room Listing Page  (duplicate — already exists)
  ✓ Created  #14 — [PLAYWRIGHT] Room Booking Flow

4 issues processed — 3 created, 1 skipped (duplicate), 0 failed.

Next step — hand off to Architect to run design-agent.
```
