# Propose-provisions brief

What an operator runs against a `--pack`, to get a draft unit↔clause registry back for
`--validate` to check. This is a document, not code — the drafter (a model, a person doing
it by hand) reads it and the pack together, and hands back a proposal.

**The tool that brackets this brief never calls a model and never writes the enforced
artifact.** `--pack` emits read-only evidence; you (or a model, prompted with this brief and
the pack) draft a proposal from it; `--validate` checks the proposal and rejects anything
that does not resolve; a human accepts a validated proposal into `citations.clausal` and
`manifest.yaml` by hand. Nothing in this loop writes those two files for you.

```
export PYTHONPATH="kit:$PWD"
python -m _tools.propose_provisions --pack <domain_dir> --out pack.yaml
# draft a proposal.yaml against pack.yaml, following this brief
python -m _tools.propose_provisions --validate <domain_dir> proposal.yaml
```

## What you are given

The pack is **evidence, not instruction**: units of the pinned statute (each unit's text as
a list of RUNS — see "quote within one run" below), the domain's operative clauses with
their `file:line` and existing cites, any citation records already bound, and the deferral
register (manifest + which entries the order authorizes). It never tells you which clause
implements which article — that judgement is what this brief asks you to make, and the pack
deliberately withholds it so it cannot be made for you.

## What you propose

A proposal is data: for each **citation record**, an atom, the `units` it binds, and a
`verbatim` quote; for each **clause**, the cites to add; for each **deferral**, the units it
binds. See the module docstring in `propose_provisions.py` for the exact shape.

## What you may NOT do

These are not style preferences `--validate` happens to also check. Each is something the
tool downstream of you — the reviewer, the gate — depends on you NOT having done, and the
checker exists specifically to catch it before a human's attention is spent.

1. **Invent statute text.** Every `verbatim` must be a quote copied from the pack, not a
   paraphrase, a corrected typo, or a "close enough" reconstruction. This is
   machine-checked — `--validate` runs the exact matcher the enforced gate uses,
   containment-matching your quote against the pinned document's own text — before any
   human ever reads it. A quote that does not match is rejected with where it stopped
   matching, not merely that it failed.

2. **Bind a unit id that is not in the pack.** Every `units` entry, on a citation record or a
   deferral, must be one of the ids the pack's `units` list actually contains. A unit id you
   remember from a previous domain, or one you construct by pattern from a real one, is not
   good enough — the pack is the only source of what ids exist for THIS document.

3. **Propose a cite for a clause that is not in the pack.** A clause is identified by its
   `functor/arity`; only ones the pack's `clauses` list contains are real. Do not propose a
   cite for a predicate you believe should exist, or one from a different domain.

4. **Resolve a scope question.** Whether a provision is DEFERRED — carved out of what this
   domain implements — is a judgement a human makes, weighing what the order authorized
   against what the rulebase actually does. You are the least well-positioned party in this
   loop to make that call: you see the statute and the code, not the business reason the
   order drew its boundary where it did. Propose citations and cites; leave deferrals to the
   human, or at most flag a unit you could not otherwise account for and say why, without
   proposing it be deferred.

5. **Quote across a run boundary.** A unit's text is a list of runs, not one joined string,
   because joining them fabricates an adjacency the statute itself does not have — the
   lettered points between a chapeau and its continuation are their own units, and text on
   either side of them is not one sentence. Your `verbatim` must sit inside a SINGLE run of
   one bound unit id. **This is stricter than the enforced gate**, which joins runs the
   document itself joins (adjacent runs of the same unit, e.g. a chapeau read together with
   its own continuation) when scoring a committed citation. `--validate` does not extend you
   that leniency: a proposal is checked before a human has looked at it, so a quote that
   spans a run boundary is refused here even in a case the gate would later accept once a
   human has bound it explicitly as such. If your citation genuinely needs both runs, propose
   it as two records (or one record naming both units, each with its own single-run quote) —
   never a quote that joins them into text the document does not read as one sentence.

## What happens to your proposal

`--validate` prints every rejection it finds, not just the first — fix them all in one pass,
not one round-trip per problem. A clean run means the proposal resolves; it does NOT mean it
is right. A human still reads it, decides whether each citation names the correct provision
and each cite belongs on that clause, and only then hand-copies the accepted parts into
`citations.clausal` and `manifest.yaml`. That acceptance step, and every deferral decision
inside it, is not something this tool or this brief can do for you.
