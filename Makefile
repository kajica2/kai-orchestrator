# kai-orchestrator sync — keeps HF spaces in lockstep with monorepo
# Usage:
#   make sync             # push each space that has uncommitted local changes
#   make sync-<space>     # push one specific space
#   make status           # show which spaces have local-vs-remote drift
#   make dry-run          # print what would sync without pushing
#
# Each space is a git clone of its HF backing repo (with `origin` = HF URL).
# An alias remote `hf` is also added so `git push hf main` works the same
# as `git push origin main` from the monorepo context.
#
# IMPORTANT: each recipe uses `bash -c '...'` so `cd spaces/$*` persists.
# (Reviewer finding #9 / #32 — plain `;`-separated shell would run each
# command in a new subshell and `git push` would happen in the monorepo
# root, not the space subdir.)
#
# Note: $(addprefix sync-,$(SPACES)) inside the .PHONY declaration doesn't
# expand under some make versions. We list each per-space target explicitly
# in .PHONY to be safe.

SPACES := orchestrator orchestrator-v2 daily-pipeline-director-cut \
          mtm-resource-sweep mtm-cycle-6 agent6 \
          agi-background-working-system \
          motion-graphic-designer-agi-system \
          applied-computing-components-system

.PHONY: all sync status dry-run help
.PHONY: sync-orchestrator sync-orchestrator-v2 sync-daily-pipeline-director-cut
.PHONY: sync-mtm-resource-sweep sync-mtm-cycle-6 sync-agent6
.PHONY: sync-agi-background-working-system sync-motion-graphic-designer-agi-system
.PHONY: sync-applied-computing-components-system

all: help

help:
	@echo "kai-orchestrator sync Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  sync                       Push all spaces that have local changes"
	@echo "  sync-<space>               Push one specific space (e.g. sync-orchestrator)"
	@echo "  status                     Show local-vs-remote drift for each space"
	@echo "  dry-run                    List spaces that would be pushed (no actual push)"
	@echo ""
	@echo "Spaces:"
	@for s in $(SPACES); do echo "  $$s"; done
	@echo ""

# Each sync-% target is explicit (no pattern rule) because pattern targets
# confuse some Make implementations when the target name matches a subdir.
sync-orchestrator:
	@bash -c 'set -euo pipefail; cd spaces/orchestrator; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/orchestrator; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [orchestrator] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-orchestrator-v2:
	@bash -c 'set -euo pipefail; cd spaces/orchestrator-v2; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/orchestrator-v2; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [orchestrator-v2] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-daily-pipeline-director-cut:
	@bash -c 'set -euo pipefail; cd spaces/daily-pipeline-director-cut; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/daily-pipeline-director-cut; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [daily-pipeline-director-cut] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-mtm-resource-sweep:
	@bash -c 'set -euo pipefail; cd spaces/mtm-resource-sweep; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/mtm-resource-sweep; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [mtm-resource-sweep] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-mtm-cycle-6:
	@bash -c 'set -euo pipefail; cd spaces/mtm-cycle-6; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/mtm-cycle-6; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [mtm-cycle-6] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-agent6:
	@bash -c 'set -euo pipefail; cd spaces/agent6; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/agent6; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [agent6] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-agi-background-working-system:
	@bash -c 'set -euo pipefail; cd spaces/agi-background-working-system; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/agi-background-working-system; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [agi-background-working-system] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-motion-graphic-designer-agi-system:
	@bash -c 'set -euo pipefail; cd spaces/motion-graphic-designer-agi-system; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/motion-graphic-designer-agi-system; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [motion-graphic-designer-agi-system] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

sync-applied-computing-components-system:
	@bash -c 'set -euo pipefail; cd spaces/applied-computing-components-system; \
	  git remote get-url hf >/dev/null 2>&1 || \
	    git remote add hf https://huggingface.co/spaces/kaidjuric/applied-computing-components-system; \
	  if [ -n "$$(git status --porcelain)" ]; then \
	    echo "  [applied-computing-components-system] committing..."; \
	    git add -A; \
	    git commit -m "sync from kai-orchestrator $$(git rev-parse --short HEAD)" || true; \
	  fi; \
	  git push hf main'

# Sync all spaces
sync: sync-orchestrator sync-orchestrator-v2 sync-daily-pipeline-director-cut \
      sync-mtm-resource-sweep sync-mtm-cycle-6 sync-agent6 \
      sync-agi-background-working-system sync-motion-graphic-designer-agi-system \
      sync-applied-computing-components-system

status:
	@printf "%-42s %-10s %-10s %s\n" "SPACE" "LOCAL" "REMOTE" "STATUS"
	@for s in $(SPACES); do \
	  LOCAL=$$(cd spaces/$$s && git rev-parse --short HEAD 2>/dev/null || echo none); \
	  REMOTE=$$(cd spaces/$$s && git rev-parse --short hf/main 2>/dev/null || echo no-remote); \
	  if [ "$$LOCAL" = "$$REMOTE" ]; then STATUS=OK; else STATUS=DRIFT; fi; \
	  printf "  %-40s %-10s %-10s %s\n" $$s $$LOCAL $$REMOTE $$STATUS; \
	done

dry-run:
	@for s in $(SPACES); do \
	  if [ -d spaces/$$s ] && [ -n "$$(cd spaces/$$s && git status --porcelain)" ]; then \
	    echo "would sync: $$s"; \
	  fi; \
	done
	@echo "(no pushes performed; safe to inspect above list)"