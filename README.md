# Kai Orchestrator — monorepo for the AGI/Orchestrator HF spaces

**Date:** 2026-08-26 (initial); 2026-08-27 (contract doc + manifest)
**Decision source:** Ecosystem plan (`~/.hermes/plans/2026-08-26-ecosystem-migration.md`)

Nine HF spaces consolidated under one source of truth. Each space lives in
its own subdirectory as a separate git checkout with its own `.git/` and
HF remote. The parent monorepo tracks them by manifest (see
`.spaces-manifest.json`), not by directory contents.

## Spaces (with contracts)

| Space | SDK | Role | Contract |
|---|---|---|---|
| `orchestrator` | gradio | **Primary UI — swarm router** | Data-driven module registry (`MODULES` dict in `app.py`); dispatches user requests to other HF Spaces via `gradio_client`. Composes: PNG Creator → Association (default preset). Adding a module = append entry + define a preset. No code changes elsewhere. |
| `orchestrator-v2` | gradio | **V2 — deterministic router over 4 tool stubs** | Pure routing; tool stubs all return `PendingResult`. Replace stub bodies with real HF Inference calls (MusicGen, Stable Video, etc.) and the router contract stays the same. Safe place to iterate — graduation path to `orchestrator` once stable. |
| `daily-pipeline-director-cut` | docker | **Daily pipeline corpus viewer** | Reads a folder of director-cut daily deep-dive HTMLs (`DAILY_DIR/*.html`), parses with BeautifulSoup (~26 ms/file), surfaces 4 Gradio tabs: Corpus / Inspector / Trace / Raw JSON. Zero-config: point at folder, auto-discovers. |
| `mtm-resource-sweep` | docker | **Weekly AMT repo survey + live Basic-Pitch demo** | Gradio app, two tabs: Sweep (weekly editorial in director-mode aesthetic) + Demo (drop audio → transcribe). ONNX backend Basic-Pitch so it runs on free CPU Space. No env vars, no API keys, no boot-time model downloads. |
| `mtm-cycle-6` | static | **Cycle-6 deliverable — AMT pipeline + 3 pitch detectors + 11 prompts** | Pure browser, vanilla JS/CSS/HTML. Part A = AMT pipeline visualizer. Part B = ACF2+/YIN/HPS pitch detectors side-by-side. Part C = Long Horizon Prompt generator (11 outputs: 6 original + 3 publishing + 2 new cycle-6). Zero deps. |
| `agent6` | docker | **Agent 6 runtime — breathing supervisor + sub-agent delegation** | FastAPI spine (`main.py`, port 8000) + Gradio dashboard (`gradio_dashboard.py`, port 7860). API endpoints for agent population, breeding, DNA. Persistent memory + state. The most "AGI-shaped" of the 9. **High-leverage target for first sprint improvement.** |
| `agi-background-working-system` | static | **HuggingChat shell — background working system** | Static HTML/CSS/JS wrapper around HuggingChat. No server logic. Lives as a HuggingChat tag-target for agent discoveries. |
| `motion-graphic-designer-agi-system` | static | **HuggingChat shell — motion graphics designer AGI** | Same shape as above. HuggingChat-targeted. |
| `applied-computing-components-system` | static | **HuggingChat shell — applied computing components** | Same shape. HuggingChat-targeted. |

### Three clusters by capability

The 9 spaces break into 3 distinct capability clusters:

1. **Real compute / pipeline** (3 spaces): `orchestrator`, `orchestrator-v2`, `agent6` — these are the actual code that does work
2. **Daily pipeline / content** (2 spaces): `daily-pipeline-director-cut`, `mtm-resource-sweep`, `mtm-cycle-6` — these surface editorial + AMT tooling
3. **HuggingChat shells** (3 spaces): `agi-background-working-system`, `motion-graphic-designer-agi-system`, `applied-computing-components-system` — these are wrappers around HuggingChat for discovery, not real apps

The HuggingChat shells (cluster 3) are essentially placeholder directories. Most engineering value lives in clusters 1 and 2.

## Structure

```
kai-orchestrator/
├── README.md                       ← you are here
├── Makefile                        ← sync-* per-space targets
├── .spaces-manifest.json           ← canonical list of 9 spaces + HF URLs + SDK + purpose
├── .gitignore                      ← spaces/*/ entirely ignored (each is its own repo)
└── spaces/                         ← 9 git checkouts, one per HF space
    ├── orchestrator/                      (.git/, .gitignore, app.py, MODULES registry)
    ├── orchestrator-v2/                   (.git/, app.py, deterministic router)
    ├── daily-pipeline-director-cut/       (.git/, Dockerfile, app.py, Gradio 4 tabs)
    ├── mtm-resource-sweep/                (.git/, Dockerfile, app.py, weekly survey + demo)
    ├── mtm-cycle-6/                       (.git/, index.html — pure static)
    ├── agent6/                            (.git/, Dockerfile, FastAPI + Gradio dashboard)
    ├── agi-background-working-system/     (.git/, index.html — HuggingChat shell)
    ├── motion-graphic-designer-agi-system/(.git/, index.html — HuggingChat shell)
    └── applied-computing-components-system/(.git/, index.html — HuggingChat shell)
```

## Sync model

Each HF space's git remote stays as `https://huggingface.co/spaces/kaidjuric/<name>` and deploys from `spaces/<name>/`. This monorepo is the parent source; HF spaces are deployed snapshots.

**Workflow per space:**
1. Edit in this monorepo under `spaces/<name>/`
2. Commit inside `spaces/<name>/` (its own git repo)
3. Mirror to HF: `cd spaces/<name> && git push hf main` — or `make sync-<name>` from the parent

**Parent monorepo workflow:**
- `make help` — list all targets
- `make status` — show local-vs-HF drift for all 9 spaces
- `make dry-run` — show what `make sync` would push
- `make sync` — push all spaces that have uncommitted local changes
- `make sync-<space>` — push one specific space

(Last `make status` output as of 2026-08-27: all 9 spaces in sync — zero drift. Healthy baseline.)

## Replaces

- `kajica2/advanced-multiagent-saas` (superseded; archived)

## Status baseline (2026-08-27)

```
SPACE                                      LOCAL      REMOTE     STATUS
  orchestrator                             65cd6e4    65cd6e4    OK
  orchestrator-v2                          06034dc    06034dc    OK
  daily-pipeline-director-cut              c87a3a8    c87a3a8    OK
  mtm-resource-sweep                       5e54849    5e54849    OK
  mtm-cycle-6                              b2866b2    b2866b2    OK
  agent6                                   aacf28f    aacf28f    OK
  agi-background-working-system            0a092ec    0a092ec    OK
  motion-graphic-designer-agi-system       c561ab5    c561ab5    OK
  applied-computing-components-system      91a6e07    91a6e07    OK
```

Zero drift = safe to use `make sync` without surprises.