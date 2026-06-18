# Git

## Never run git add, git commit, or git push

NEVER run `git add`, `git commit`, or `git push` (or anything that creates or
publishes commits, e.g. `git commit -a`, `gh pr merge`, `git rebase` that
rewrites history) on the user's behalf. In any project, ever, even when it
seems like the obvious next step to complete a task.

Make the file changes, then stop and tell the user what is ready to commit.
The user stages, commits, and pushes themselves.

# GitHub

## Never create labels for issues

When filing GitHub issues, only apply labels that already exist in the target
repo. Never create new labels (no `gh label create`). If a requested label
doesn't already exist, drop the `--label` flag for it. The user wants to
control which labels exist in their repos.

Before `gh issue create`, list existing labels with
`gh label list --repo <owner/repo>` and pass `--label` only for ones that
already exist.

# Writing style

## Never use em-dashes

Never use em-dashes (`—`, U+2014) or en-dashes (`–`, U+2013). Anywhere. Not in
prose, not in code comments, not in commit messages, not in PR descriptions,
not in chat responses, not in docstrings, not in markdown.

Why:
- They are a well-known AI writing tell.
- They break source files read by JVMs / tools with non-UTF-8 default charsets
  (e.g. Jenkins agents reading `*.jenkinsfile` via `FilePath.readToString`,
  which has thrown `MalformedInputException` on em-dashes in this repo).

Use one of these instead, picked by what the sentence is doing:
- `,` for a mid-sentence aside
- `:` to introduce an explanation or list
- `()` for a parenthetical
- `.` to start a new sentence
- `-` (ASCII hyphen) only for compound words and CLI flags, not as a dash

If you catch yourself typing an em-dash, rewrite the sentence rather than
swapping in a hyphen as a like-for-like replacement.

# Coding preferences

## Comments

Do not add comments unless there is a clear, non-obvious reason that belongs in
the source: typically a complicated *why* (hidden constraint, subtle invariant,
workaround for a specific bug, behaviour that would surprise a future reader).

Do not write comments that:
- Restate what well-named identifiers already say
- Narrate the *what* of the next line ("// loop over files", "// return early")
- Summarise what a function does when the name + body already convey it
  ("# Block until the DB is reachable" above `wait_for_connection`)
- Act as section banners that just label what comes next
  (`# --- ECS task definition ---` above an obvious ECS resource,
  `# 1. Optional schema apply ---`)
- Reference the current task, PR, or caller ("// added for X flow", "// used by Y")
- Mark code as new, removed, refactored, or temporary

If removing the comment wouldn't confuse a future reader, don't write it.

This rule applies in every language and config format: Python, TypeScript,
Bash, Terraform, YAML, Dockerfiles, SQL. Anywhere comments exist, the
principle is the same: well-named identifiers and clear control flow already
convey the *what*; comments earn their keep only when they explain *why*.

Operator-facing file headers (usage docs, env-var contracts, CLI examples)
are interface documentation, not source narration. Those are fine.

## Functional style

Prefer a functional style over imperative iteration. Reach for collection
combinators (`map`, `reduce`, `filter`, `flatMap`, `Array.from({ length }, ...)`,
and their equivalents in other languages) instead of mutable-accumulator loops
(`for`, `for...of`, `while` pushing into an array).

- Build a derived list with `Array.from(...)` + `map`, not a `while` loop that
  pushes into an array.
- Accumulate async results with something like `pMap(...).flat()` rather than a
  `for...of` with `.push`.
- Prefer library constants/helpers (e.g. `date-fns`) over hand-rolled magic
  numbers.

Accepted exception: cursor pagination against an opaque cursor, where there is
no clean functional equivalent, may use `do/while`.

## Prefer const over let

Declare bindings with `const` (or the language's immutable-binding form) by
default. Only use `let` when the variable genuinely must be reassigned. Favouring
`const` reinforces the functional style above: if a value needs `let`, that is
often a signal the logic could be expressed as a `map`/`reduce` returning a new
value instead of mutating one in place.

## Always ask before installing libraries

Never install or add a new dependency without asking first. The user wants to
validate every new library (security posture, maintenance, licensing) before it
enters a project. This applies in every project and to every package manager
and manifest: `npm install`, `uv add`, `pip install`, `terraform` providers/
modules, and also hand-editing a dependency into `package.json` /
`pyproject.toml` / lockfiles.

When a new library would help, propose it: name, what it's for, and why it
beats the hand-rolled alternative, then wait for approval. Using dependencies
already present in the project's manifest is fine and needs no approval.
