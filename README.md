# research-findings

Goal-directed research **whitepapers** for the Li langverse â€” executive summaries, analysis, code snippets, and machine-readable metadata for dashboards and quick scanning.

## Layout

```
whitepapers/YYYY-MM/<goal-id>/<slug>/
  README.md          # whitepaper body (YAML frontmatter + narrative)
  artifacts.json     # goal_id, agent, run_id, domains, validity_grade, links
  snippets/          # referenced code blocks (.li, .py, .md, â€¦)
index.yaml           # catalog (rebuilt by script)
SCAN.md              # one-page human scan table (rebuilt by script)
templates/
  whitepaper-template.md
```

## Publishing (agents)

Researchers with goals in `li-cursor-agents/config/research-goals.yaml` **must** write or update a whitepaper here each run. See:

- Skill: `li-cursor-agents/.cursor/skills/publish-research-whitepaper/SKILL.md`
- Script: `li-cursor-agents/scripts/publish-research-whitepaper.sh` (rebuilds `index.yaml` + `SCAN.md`)

Override repo root: `LI_RESEARCH_FINDINGS_ROOT` (default: sibling `../research-findings` from `li-cursor-agents`).

## Rebuild index

```bash
cd ../li-cursor-agents
./scripts/publish-research-whitepaper.sh
```

## Lic pointer

`lic/docs/ecosystem/research-findings.md` documents the sibling repo path for humans browsing from **lic**.

## License

Copyright (C) 2026 Julian. Licensed under the [GNU General Public License v3.0](LICENSE).
