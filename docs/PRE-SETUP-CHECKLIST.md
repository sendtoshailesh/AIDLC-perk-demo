# Pre-Setup Checklist

Complete every item **before** the workshop day.
Check the box when done. If any item is blocked, resolve it before proceeding.

---

## 1. Repository

- [ ] Create the workshop repo (or fork the template) on your GitHub Enterprise instance
- [ ] Confirm the `.github/agents/` folder and all agent definition files are on the `main` branch
- [ ] Confirm `workshop-stack.md`, `init-workspace.sh`, and `init-workspace.ps1` are present at the repo root
- [ ] Add all participants as **Collaborators** with Write access (Settings → Collaborators)

## 2. Copilot Coding Agent Access

- [ ] Confirm **GitHub Copilot Enterprise** licence is assigned to every participant
- [ ] Confirm **Copilot coding agent** is enabled at the organisation or enterprise level
- [ ] Verify the **Agents tab** is visible on the repo page for at least one participant (have them check)
- [ ] Verify **Copilot** appears as an assignee option when editing any Issue (this confirms coding agent works)

> If the Agents tab is missing or Copilot is not available as an assignee,
> the IT or admin team must enable coding agent — this is **not** a repo-level setting.

## 3. MCP Configuration (Required for Issue Push Agent)

The `push-issues-to-GitHub-agent` needs the GitHub MCP server configured to create issues.
Without this, the agent can only read — not write — issues.

- [ ] Go to **Settings → Copilot → Cloud Agent → MCP Configuration**
- [ ] Add the following JSON and click **Save MCP configuration**:

```json
{
  "mcpServers": {
    "github-mcp-server": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "tools": ["*"],
      "headers": {
        "X-MCP-Toolsets": "repos,issues,users,pull_requests"
      }
    }
  }
}
```

- [ ] Verify the configuration saved without errors

> This configuration uses the built-in Copilot MCP endpoint — no Personal Access Token
> or secret is required. The coding agent authenticates automatically.

## 4. Requirement (Issue #1)

- [ ] Create **Issue #1** in the repo with the business requirement text for the workshop
- [ ] The issue should describe the feature clearly — the PM will reference this issue number when running `brd-agent`
- [ ] If you have a prepared requirement document, paste the full text into the issue body

## 5. Tech Stack (`workshop-stack.md`)

- [ ] Decide the tech stack for the workshop (language, framework, database, frontend)
- [ ] Fill in `workshop-stack.md` — no `{placeholder}` values should remain
- [ ] Use `docs/STACK-SETUP-GUIDE.md` if you need help or want a ready-to-copy example
- [ ] Commit the filled-in `workshop-stack.md` to `main` before the workshop starts

> All agents read `workshop-stack.md`. If it has unfilled placeholders, scaffold-agent
> and implement-agent will produce incorrect output.

## 6. Participant Machines

Each participant needs:

- [ ] VS Code (latest stable) — if using VS Code agents
- [ ] GitHub Copilot and GitHub Copilot Chat extensions installed and signed in
- [ ] Git installed and authenticated with the GitHub Enterprise instance
- [ ] Network access to GitHub Enterprise (no VPN issues, no proxy blocks)
- [ ] The repo cloned locally — have them run `init-workspace.sh` or `init-workspace.ps1`

## 7. Optional — Playwright (for QA phase)

If the workshop includes E2E testing:

- [ ] Node.js installed on the QA participant's machine (Playwright requires it)
- [ ] Playwright MCP server configured — see `docs/playwright-mcp-setup.md`
- [ ] Run `npx playwright install` to download browser binaries ahead of time

---

## Day-of Quick Verification

On the morning of the workshop, do a 5-minute smoke test:

1. Open the repo on GitHub.com → confirm the **Agents tab** is visible
2. Open any Issue → confirm **Copilot** appears in the Assignees dropdown
3. Open `workshop-stack.md` → confirm no `{placeholder}` values remain

If all three pass, you are ready to start.

---

*Companion document to `FACILITATOR-GUIDE.md` — read that next for timing, roles, and recovery steps.*
