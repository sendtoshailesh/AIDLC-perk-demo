# Facilitator Guide

This guide is for the person running the workshop — not the participants.
Read `PRE-SETUP-CHECKLIST.md` first and complete every item before workshop day.

---

## Workshop at a Glance

| Item | Detail |
|------|--------|
| **Duration** | 3–4 hours (half day). Can stretch to a full day with deeper reviews. |
| **Team size** | 5 people (one per role). Works with 3–6 — see role merging below. |
| **Prerequisite** | `PRE-SETUP-CHECKLIST.md` fully completed |
| **Deliverable** | A working feature — from requirement to tested code — built entirely by AI agents |

---

## Roles and Assignments

| Role | What they do | Skills needed |
|------|-------------|---------------|
| **PM** | Runs `brd-agent` and `user-story-agent`, reviews BRD and Issues | Understands the business requirement |
| **Architect** | Runs `design-agent` and `scaffold-agent`, fills in `workshop-stack.md` | Understands the tech stack |
| **Database Dev** | Assigns DATABASE Issues to Copilot, reviews schema and seed PRs | Can read a data model |
| **Backend Dev** | Assigns BACKEND Issues to Copilot, runs `unit-test-agent`, reviews API PRs | Can read backend code |
| **UI Dev** | Assigns FRONTEND Issues to Copilot, reviews UI PRs | Can read frontend code |
| **QA Engineer** | Runs `playwright-agent`, runs E2E tests, reviews test results | Can run terminal commands |

### Fewer than 5 people?

| Team size | Merge these roles |
|-----------|-------------------|
| 4 | Database Dev + Backend Dev (same person, sequential) |
| 3 | PM + Architect, Database Dev + Backend Dev, UI Dev + QA |

---

## Timing Guide

| Phase | Role | Duration | What happens |
|-------|------|----------|-------------|
| **Setup** | Facilitator | 15 min | Clone repo, verify access, confirm `workshop-stack.md` is filled in |
| **Phase 1 — BRD** | PM | 15–20 min | Run `brd-agent` → review PR → merge |
| **Phase 2 — Design** | Architect | 15–20 min | Run `design-agent` → review PR → merge |
| **Phase 3 — Scaffold** | Architect | 10–15 min | Confirm `workshop-stack.md` → run `scaffold-agent` → review PR → merge |
| **Phase 4 — User Stories** | PM | 15–20 min | Run `user-story-agent` → review PR → merge → push Issues |
| **Phase 5a — Database** | Database Dev | 15–20 min | Assign DATABASE Issues → review PRs → merge |
| **Phase 5b — Backend** | Backend Dev | 20–30 min | Assign BACKEND Issues → review PRs → merge → unit tests |
| **Phase 5c — Frontend** | UI Dev | 20–30 min | Assign FRONTEND Issues → review PRs → merge |
| **Phase 6 — E2E Tests** | QA | 15–20 min | Run `playwright-agent` → run tests → report |
| **Wrap-up** | All | 10 min | Demo, retrospective |

> **Total: ~2.5–3.5 hours.** Agent execution time varies — some PRs appear in
> 2 minutes, some take 10. Plan for variability.

---

## Before You Start — Day-of Script

1. **Welcome** (5 min) — explain the goal: "We will take a single business requirement
   and produce tested, working code using AI agents. No one writes code by hand."
2. **Assign roles** — use the table above. Ask who is comfortable with backend vs frontend.
3. **Verify access** — everyone opens the repo on GitHub.com, confirms the Agents tab is visible.
4. **Confirm `workshop-stack.md`** — open it on screen, show the team what stack they are using.
5. **Show the pipeline diagram** — open `docs/COMPLETE-WORKSHOP-FLOW.md` and display the pipeline section.
6. **Start Phase 1** — hand it to the PM.

---

## Key Facilitation Points

### When to intervene

| Signal | Action |
|--------|--------|
| Agent PR has not appeared after 10 minutes | Check the agent session — it may have errored. Re-run with the same instruction. |
| PR contains hallucinated entity names | Add a review comment listing the correct names from the BRD. The agent will retry. |
| Agent modifies pre-built files | Request changes on the PR. Point out which files are pre-built (listed in `workshop-stack.md`). |
| Participant is stuck on PR review | Walk through the review checklist in COMPLETE-WORKSHOP-FLOW.md for their role. |
| Team is blocked waiting for a role | The current role should narrate what they see — screen-share if possible. |

### What NOT to do

- Do not let anyone skip the PR review — the review step is where learning happens.
- Do not merge PRs on behalf of participants — they must own the decision.
- Do not debug code manually — if a PR is wrong, add a review comment and let the agent fix it.
- Do not skip scaffold-agent — without it, implement-agent has no project structure to work with.

---

## `workshop-stack.md` — Who Fills It In and When

The **facilitator or architect** fills in `workshop-stack.md` **before the workshop starts**.
It must be committed to `main` with no `{placeholder}` values remaining.

If you want the Architect to fill it in during the workshop (as a learning exercise),
schedule 10–15 extra minutes after Phase 3 (Design) and before Phase 4 (Scaffold).

Use `docs/STACK-SETUP-GUIDE.md` for step-by-step help and ready-to-copy examples.

---

## The Requirement (Issue #1)

Before the workshop, create **Issue #1** in the repo with the business requirement.

Guidelines for a good workshop requirement:
- **Scope:** 3–5 functional requirements — enough to generate DATABASE, BACKEND, FRONTEND, and PLAYWRIGHT Issues
- **Clarity:** Describe what the user should be able to do, not how to build it
- **Fit:** Should be achievable on top of the pre-built login/registration app
- **Domain:** Use clear entity names (e.g. "Room", "Booking", "Member") — the agents will preserve them exactly

Example requirement topics that work well:
- Room/resource booking system
- Book lending / library catalogue
- Event registration and attendance
- Inventory or asset tracking

---

## Recovery Playbook

### Bad PR was merged

1. Revert the merge commit: go to the merged PR → click **Revert** → merge the revert PR
2. Re-run the agent with updated instructions referencing what went wrong
3. Review the new PR more carefully before merging

### Agent keeps producing wrong output

1. Check that the BRD and Issues are correct — the agent can only be as good as its input
2. Add a detailed review comment explaining exactly what is wrong and what you expect
3. If the agent still fails after 2 attempts, consider editing the file manually and committing

### Copilot coding agent is not available

- This is an org/enterprise admin setting — the facilitator cannot fix it
- Fallback: use VS Code local agents (Copilot Chat → Ask mode → reference the agent)
- Local agents do not auto-create PRs — the participant commits and pushes manually

### Push agent cannot create issues (403 / missing tools)

1. Go to **Settings → Copilot → Cloud Agent → MCP Configuration**
2. Confirm the GitHub MCP server is configured with `issues` in `X-MCP-Toolsets`
3. If missing, add the config from `PRE-SETUP-CHECKLIST.md` section 3 and re-run the agent
4. If still failing, create issues manually from the `issues/*.md` files using the GitHub UI

### App does not start after implementation

1. Check the PR that introduced the error — look at the Files Changed tab
2. Common causes: missing dependency in package manifest, wrong import path, seed data not run
3. Ask the Backend Dev or Architect to add a review comment describing the error
4. The agent will push a fix to the same PR

### Participant loses their place

Direct them to `docs/COMPLETE-WORKSHOP-FLOW.md` → find their role's section (colour-coded).
Each section has clear "wait for" and "hand off to" markers.

---

## Wrap-Up Talking Points

After Phase 6 (or whenever the team finishes):

1. **Demo the app** — have the QA run through the feature in the browser
2. **Show the agent trail** — open the PRs tab, walk through the sequence of PRs from BRD to tests
3. **Highlight traceability** — pick any Issue and trace it back to a BRD requirement (FR-XXX)
4. **Discuss what surprised them** — what did the agents get right? What needed human correction?
5. **Key takeaway:** The human role shifted from writing code to reviewing, guiding, and deciding

---

*Companion document to `PRE-SETUP-CHECKLIST.md` and `COMPLETE-WORKSHOP-FLOW.md`.*
