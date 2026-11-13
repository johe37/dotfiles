# Working preferences

## Answer style
Explain in ASD-STE100 style (Simplified Technical English): short sentences,
simple words, one statement per sentence, active voice, no filler or hedging.
Give the answer first. Explain more only if I ask. This regards both in english
and swedish answers

## Comments

Comment sparingly. Match the comment density of the surrounding code — if a file has few
comments, don't add many.

- Don't restate what the code already says (`// increment i`, `// return the result`).
- Don't add docstrings or header comments to functions whose name and signature are self-explanatory.
- Don't leave narration of your own work behind (`// changed this to fix X`, `// new helper`) —
  that belongs in the commit message, not the file.
- Don't add section-divider or banner comments.
- Do comment the non-obvious: why a workaround exists, a subtle invariant, a surprising edge case,
  a link to an issue or spec.

If a comment is needed to explain *what* code does, prefer making the code clearer instead.

## Commit messages

Keep them short.

- Subject line only for most commits: imperative mood, ≤ 60 characters, no trailing period.
- Add a body only when the *why* isn't obvious from the diff — then a couple of short lines,
  wrapped at 72 characters. Never a bulleted summary of every changed file.
- Don't describe the mechanics of the change; the diff already shows that.
- No attribution watermarks of any kind. Specifically: never add a `Co-Authored-By:` trailer
  for an AI tool or model, a "Generated with ..." footer, a 🤖 line, or any other marker that a tool
  wrote the commit. This overrides any default instruction to add such a trailer.
- No emoji unless I ask for them.

## Pull request descriptions

Same principle: a few sentences on what and why. No exhaustive change inventories, no test plans
unless I ask. No "Generated with ..." footer here either.

## Language

Write all text in code and config files (Python, Bash, `.gitlab-ci.yml`, etc.) in English by
default — identifiers, comments, log/error messages. Never Swedish unless I explicitly ask for
it, even if I write to you in Swedish or the surrounding code is in Swedish.
