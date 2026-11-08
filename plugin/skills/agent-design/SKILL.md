---
name: agent-design
description: Guide for designing tools and environments for AI agents. Use when building agent systems, designing tool APIs, or thinking through what tools an agent needs.
---

# Agent Tool Design Guide

Core insight: **when an agent struggles, don't just tweak the prompt — look at what's missing in its environment and fix it there.**

## The Harness

A harness is the complete ecosystem built around a model: constraints, linters, documentation, and feedback loops. Environment design is often more critical than the specific model being used. LangChain's coding agent climbed to top 5 on Terminal Bench 2.0 just by redesigning the harness, same underlying model.

## Core Principles

### 1. Small, Sharp Tool Sets
Don't give the agent 50 tools. Give it 4-5 that feel natural and well-named — like the right kitchen utensils, not the whole drawer. Agents get confused and wasteful with too many choices.

**When to add a tool**: When the agent repeatedly does something awkward or fails a task type, and a dedicated tool would make that class of actions clean and direct.

**When NOT to add a tool**: When the agent can already do it with existing tools, when it's a one-off edge case, or when it's just a prompt engineering fix.

### 2. Progressive Disclosure
Don't dump 20,000 words of instructions upfront. Organize information into well-named markdown files in folders. The agent reads deeper files only when it needs them — like flipping to the brownie recipe, not reading the whole cookbook.

**Pattern**:
```
docs/
  overview.md          # high level, always read
  api/
    auth.md            # only read when doing auth work
    payments.md        # only read when doing payments
```

### 3. Think Like the Agent
If you had to do the job using only the tools you're giving the agent, what would feel frustrating or missing? Build tools that remove those annoyances. Shape tools to model the agent's natural abilities.

### 4. Safety / Preview Steps
Before dangerous actions (deleting files, spending money, irreversible changes), require the agent to show a clear plan first and wait for confirmation. The `ExitPlanMode` pattern: agent must write its plan and call the exit-plan tool before any implementation starts.

### 5. File System as Memory
A well-organized folder of markdown notes + short summaries is one of the cleanest ways to give an agent long-term memory and skills. Treat it like giving the agent its own tidy notebook instead of cramming everything into one giant prompt.

## Design Anti-Patterns

- **Tool sprawl**: Adding a tool for every edge case until the agent is paralyzed by choice
- **Front-loading context**: Dumping all documentation into the system prompt instead of letting the agent discover what it needs
- **Prompt-only fixes**: Responding to every failure with more prompt text instead of fixing the environment
- **No confirmation gates**: Letting agents take irreversible actions without human checkpoints
- **Opaque tool names**: Generic names like `process()` or `handle()` instead of `create_draft_pr()` or `run_tests()`

## Framework: Diagnosing Agent Failures

1. Agent fails or does something awkward → **Is a tool missing or poorly shaped?**
2. Agent ignores relevant context → **Is the info buried or hard to discover?**
3. Agent takes wrong action confidently → **Is there a confirmation gate missing?**
4. Agent gets lost on long tasks → **Does it have structured memory / checkpoints?**
5. Agent uses wrong API / invents methods → **Does it have access to actual docs?**

## The Real Moat

The value isn't in the model — it's in the feedback loops and architectural guardrails that make agents reliable at scale. Engineers who build great harnesses ship faster than those chasing the latest model.
