---
name: create-user-stories
description: Creates issue files from the BRD and design document.
  Use when asked to create user stories or break requirements into
  implementable issues.
---

# Skill — Create User Stories

## What You Do
Read the BRD and design document and produce a set of issue files
that break the requirements into discrete, implementable units
grouped by functional slice. Each functional slice produces up to
four issue files:

```
DATABASE → BACKEND → FRONTEND → PLAYWRIGHT
```

Each issue describes a single behaviour or capability. It is written
from the user's perspective where applicable. Each issue must be
independently testable.

## Steps
1. Read `docs/requirements/BRD.md` — extract functional requirements,
   business rules, user roles, and lifecycle states. Use these to
   ensure stories capture the correct behaviours and constraints.
2. Read `docs/design/design-doc.md` — use API contracts, user flows,
   and component structure to inform technical notes per issue.
3. Group the BRD functional requirements into logical feature areas.
   For each feature area, produce up to four issue files (DATABASE,
   BACKEND, FRONTEND, PLAYWRIGHT). Not every feature area needs all
   four types — only produce what is required.
4. Assign a MoSCoW priority to each issue based on BRD analysis:
   - **must-have**: core functional requirement — the feature area does not
     work without this issue
   - **should-have**: important supporting behaviour — expected by users
     but the feature area partially works without it
   - **could-have**: enhancement — adds value but is acceptable to defer
5. For each issue, produce one markdown file in the format below.
6. **Save files to `issues/`:**
   - Name each file using kebab-case:
     `{type}-{kebab-case-title}.md`
     (e.g. `database-book-catalogue.md`, `backend-book-lending.md`,
      `frontend-book-listing.md`, `playwright-book-borrowing.md`)
   - If the folder does not exist, create it.
   - If files already exist from a previous run, overwrite them.

## Issue File Format

```markdown
---
title: [{TYPE}] {Short title describing the behaviour}
type: {database | backend | frontend | playwright}
status: ready
priority: {must-have | should-have | could-have}
source: {comma-separated FR IDs}
dependencies: []
---

# [{TYPE}] {Short Title}

## Assignment Order
Step {N} — assign this issue after {dependency description}.

## User Story
As a {role from BRD},
I can {action — what the user does},
so that {outcome — the value delivered to the user or business}.

## Business Context
One or two sentences explaining why this behaviour matters.
Reference the relevant BRD functional requirement (FR-XXX).

## Acceptance Criteria
- [ ] Given {precondition}, when {action}, then {expected outcome}
- [ ] Given {precondition}, when {action}, then {expected outcome}
- [ ] Given {precondition}, when {action}, then {expected outcome}

## Definition of Done
- All acceptance criteria above are verified and passing
- Behaviour is demonstrable in the running application
- No known defects for this issue

## Technical Notes
Relevant technical context from the design document to guide
implementation. Include:
- Relevant API endpoints from the design doc
- Relevant domain entity states or transitions involved
- Relevant UI components from the component structure
- Any business rules from the BRD that apply to this issue
Do NOT prescribe implementation — describe constraints and contracts.
```

## How to Write Good Issues

**The user story statement (FRONTEND and PLAYWRIGHT issues):**
- Use the exact role name from the BRD — not generic substitutes.
  Bad:  "As a user, I can book a slot"
  Good: "As a Patient, I can select an available slot with a Practitioner"
- The action should describe what the user does, not what the system does.
  Bad:  "As a Patient, I can have an appointment created"
  Good: "As a Patient, I can confirm a booking for an available slot"
- The outcome should state the value, not repeat the action.
  Bad:  "so that I have booked an appointment"
  Good: "so that I have a confirmed time with my Practitioner"

**Acceptance criteria:**
- Use Given/When/Then format consistently.
- Each criterion must be independently testable.
- Cover the happy path first, then edge cases and error states.
- Reference lifecycle states from the BRD verbatim.
  (e.g. "Then the Appointment status is SCHEDULED")
- Include at least one criterion for an error or validation case
  where relevant.

**Priority assignment:**
- Read the BRD functional requirements section.
- Requirements marked as core or primary → must-have.
- Requirements that support or enhance core behaviours → should-have.
- Requirements prefixed with "nice to have" or described as optional
  in the BRD → could-have.
- When in doubt, default to must-have — it is safer to elevate priority
  than to defer a required behaviour.

**Technical notes:**
- Always include the relevant API endpoint from the design doc.
- Always include the relevant entity state transition if the issue
  involves a lifecycle change.
- Keep technical notes brief — this is context for the developer,
  not a specification.

## Issue Granularity Guidelines

**An issue is too large if:**
- It covers more than one user action
- Its acceptance criteria list exceeds 6 items

**An issue is too small if:**
- It describes a single UI element with no user value
- It cannot be demonstrated independently
- It only makes sense in the context of another issue

**Split a large issue by:**
- Separating the happy path from error handling
- Separating creation from editing
- Separating list view from detail view
- Separating one lifecycle state transition per issue

## Naming Conventions
- Issue titles start with the type prefix in brackets:
  `[DATABASE]`, `[BACKEND]`, `[FRONTEND]`, `[PLAYWRIGHT]`
- Titles are short, action-oriented phrases in sentence case.
  (e.g. "[BACKEND] Book lending API", "[FRONTEND] Book listing page")
- File names are kebab-case: `{type}-{title}.md`

## What NOT to Include
- Do NOT add effort estimates.
- Do NOT describe implementation steps or technical decisions.
- Do NOT reference specific technologies, frameworks, or libraries.
- Do NOT write stories for behaviours not in the BRD.
- Do NOT use role names not defined in the BRD.

## Validation Checklist
Before saving, verify:
- [ ] Every functional area has the appropriate issue types (DATABASE, BACKEND, FRONTEND, PLAYWRIGHT)
- [ ] Every issue uses a role name defined in the BRD (where applicable)
- [ ] Every issue traces to at least one BRD FR
- [ ] Every issue has at least 3 Given/When/Then criteria
- [ ] At least one criterion covers an error or validation case
- [ ] Priority is assigned to every issue
- [ ] Every issue has an Assignment Order section
- [ ] DATABASE issues have a Seed Data section
- [ ] FRONTEND issues list `data-testid` values for every interactive element
- [ ] PLAYWRIGHT issues reference the same `data-testid` values as FRONTEND issues
- [ ] No effort estimates appear anywhere in the files
- [ ] File naming convention is correct

## Example

For a Book Lending feature area (FR-006):

**Issues produced:**
```
database-book-catalogue.md       (must-have)
backend-book-lending.md           (must-have)
frontend-book-listing.md          (must-have)
playwright-book-borrowing.md      (should-have)
```

**Example file — `backend-book-lending.md`:**
```markdown
---
title: "[BACKEND] Book lending API"
type: backend
status: ready
priority: must-have
source: FR-006
dependencies: [database-book-catalogue]
---

# [BACKEND] Book lending API

## Assignment Order
Step 2 — assign this issue after the DATABASE issue for Book Catalogue is merged.

## User Story
As a Member,
I can borrow an available book,
so that I have a confirmed loan with a due date.

## Business Context
Core lending behaviour required by FR-006. The Loan must be
created in ACTIVE state upon confirmation.

## Acceptance Criteria
- [ ] Given a book is available, when I request to borrow it,
      then a Loan is created with status ACTIVE and a due date
- [ ] Given I borrow a book, then I receive the Loan details
      including book title, borrow date, and due date
- [ ] Given a book is not available, when I attempt to borrow it,
      then I receive an error response

## Definition of Done
- All acceptance criteria above are verified and passing
- Behaviour is demonstrable in the running application
- No known defects for this issue

## Technical Notes
- API: POST /api/loans (creates Loan in ACTIVE state)
- Domain: Loan lifecycle entry point — status must be ACTIVE
- Business rule: Book must be available at time of borrowing (FR-006)
```
