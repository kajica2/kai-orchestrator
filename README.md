# Kai Orchestrator — monorepo for the AGI/Orchestrator HF spaces

**Date:** 2026-08-26
**Decision source:** Ecosystem plan (`~/.hermes/plans/2026-08-26-ecosystem-migration.md`)

Nine HF spaces consolidated under one source of truth. Each space lives in its own subdirectory; the HF Space deploys from `spaces/<name>/`.

## Spaces

| Space | SDK | Purpose |
|---|---|---|
| `orchestrator` | gradio | Primary orchestrator UI |
| `orchestrator-v2` | gradio | V2 variant of orchestrator |
| `daily-pipeline-director-cut` | docker | Daily pipeline automation, director-cut variant |
| `mtm-resource-sweep` | docker | Resource sweep workflow |
| `mtm-cycle-6` | static | Cycle 6 artifact |
| `agent6` | docker | Agent 6 runtime |
| `agi-background-working-system` | static | Background working system for AGI |
| `motion-graphic-designer-agi-system` | static | Motion graphics designer AGI system |
| `applied-computing-components-system` | static | Applied computing components |

## Structure

```
kai-orchestrator/
├── README.md              ← you are here
├── spaces/
│   ├── orchestrator/              ← source for kaidjuric/orchestrator (HF gradio)
│   ├── orchestrator-v2/           ← source for kaidjuric/orchestrator-v2 (HF gradio)
│   ├── daily-pipeline-director-cut/  ← source for kaidjuric/daily-pipeline-director-cut (HF docker)
│   ├── mtm-resource-sweep/        ← source for kaidjuric/mtm-resource-sweep (HF docker)
│   ├── mtm-cycle-6/               ← source for kaidjuric/mtm-cycle-6 (HF static)
│   ├── agent6/                    ← source for kaidjuric/agent6 (HF docker)
│   ├── agi-background-working-system/  ← source for kaidjuric/agi-background-working-system (HF static)
│   ├── motion-graphic-designer-agi-system/  ← source for kaidjuric/motion-graphic-designer-agi-system (HF static)
│   └── applied-computing-components-system/  ← source for kaidjuric/applied-computing-components-system (HF static)
└── .gitignore
```

## Sync model

Each HF space's git remote stays as `https://huggingface.co/spaces/kaidjuric/<name>` and deploys from `spaces/<name>/`. This monorepo is the parent source; HF spaces are deployed snapshots.

**Workflow:**
1. Edit in this monorepo under `spaces/<name>/`
2. Commit + push to this monorepo
3. Mirror to the HF space: `cd spaces/<name> && git push hf main`

(Or use `git subtree split` — TBD based on workflow preference.)

## Replaces

- `kajica2/advanced-multiagent-saas` (superseded; will be archived after this repo is live)