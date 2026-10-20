# clausal-rules-as-code

Laws written as executable logic programs. Each folder under a jurisdiction (`eu/`, and
later others) is one **domain**: one legal question (for example, *is this person a
beneficial owner under AMLR Art 52?*, or *does this aid stay under the de minimis
ceiling?*). For each domain you get:

- the **rulebase** (`*.seam`, plus `*.pl` ISO Prolog versions where they exist), where
  every rule carries the provision it implements;
- the **tests** (`tests/`);
- the **statute text it was written against** (`sources/`), pinned by URL and SHA-256;
- a **manifest** (`manifest.yaml`) stating the domain's scope, its public interface, and
  every provision it deliberately does not implement, with the reason and the consequence;
- a **provision-tracking ledger** (`provisions.yaml`), where one exists.

The programs run on [Clausal Prolog](https://github.com/neurosymbolica/clausal-prolog).

## This is a preview

This first release holds eight EU domains, chosen because they pass every check in this
repository (see `_index/STATUS.md`), including robustness tests that feed each decision missing, mistyped and incomplete
inputs (a bad input must be refused or answered "indeterminate", never guessed):

| Domain | Question |
|---|---|
| `eu/aml/amlr_bo_chain` | Is a person a beneficial owner through direct and indirect holdings in a chain of entities (AMLR Art 52(1))? |
| `eu/aml/amlr_beneficial_ownership_threshold` | Does a person's effective holding reach the 25 % threshold (AMLR Art 52)? |
| `eu/state_aid/de_minimis_cumulation` | How much de minimis aid has an undertaking received in the rolling three-year window, and is it under the ceiling (Regulation (EU) 2023/2831)? |
| `eu/procurement/framework_agreements` | Is a framework agreement's term, and a call-off under it, lawful (Directive 2014/24 Art 33)? |
| `eu/procurement/life_cycle_costing` | Is a life-cycle costing method valid, and what does it compute (Art 68)? |
| `eu/procurement/shortlisting` | May the authority limit the number of candidates, and to how many (Art 65)? |
| `eu/procurement/time_limits` | What is the minimum time limit for receipt (Art 27-31)? |
| `eu/procurement/utilities_negotiated_without_prior_call` | May a utility negotiate without a prior call for competition (Directive 2014/25 Art 50)? |

`eu/procurement/directive_2014_24/` is the shared vocabulary the procurement domains
import. More domains follow as they pass the same checks.

Licence: EUPL-1.2 (see `LICENSE`). The legal texts quoted here are not official
versions of the law; see `NOTICE`.

## Running it

```sh
pip install clausal pyyaml            # the engine (Clausal Prolog), and YAML for the tools
python run_tests.py                   # every domain's tests
python run_tests.py eu/aml            # one jurisdiction or area
```

## How the formalizations are checked

These are the checks the corpus runs. Not every domain has every kind yet: which checks
each domain has, and passes, is listed in `_index/STATUS.md`, generated at export. You can
re-run all of them yourself, except the two under "Hidden tests", which are kept private
on purpose.

### Tests in this repository

- **Public interface tests** (`tests/test_public_interface.*`): each exported predicate
  answers the documented questions with the documented answers.
- **Query tests** (`tests/test_queries.*`): worked cases for each kind of question the
  domain answers (eligibility, thresholds, what-if, sensitivity, and so on).
- **Property tests** (`tests/test_properties.*`): totality (every valid input gets a
  verdict), determinism (one verdict, not several), monotonicity where the law is
  monotone, and consistency between related predicates.
- **Input and output mode tests**: the predicates behave correctly when arguments are
  given or left open.
- **Negative controls** (`tests/test_negative_controls.*`): deliberately wrong inputs
  that must be refused or answered "indeterminate", never guessed.

### Traceability to the statute

- **Citations** (`_tools/check_citations.py`): every provision a rule cites has exactly
  one citation record, and every record's quotation is checked word for word against the
  pinned statute text.
- **Parameters** (`_tools/check_parameters.py`): every number taken from the law (a
  threshold, a deadline, a ceiling) has a record quoting the provision that fixes it.
- **Provision tracking** (`_tools/check_provisions.py`): for a domain with a pinned
  extract, every unit of that extract (article, paragraph, point) must be accounted for.
  It is either **formalized** (a rule cites it), **deferred** (with a stated reason and
  the consequence for anyone relying on the domain), or **excluded** from scope by
  design. Nothing is left silently unread. Where a domain's manifest says
  `provision_tracking: enforced`, an unaccounted provision fails the check.

### Provision-tracking reports

`_tools/render_provisions.py <domain>/provisions.yaml --out report.html` writes a
self-contained page, one row per unit of the statute. The provision's own text is on
the left, and the claim made about it is on the right: the rule's quotation, or the
deferral's reason and consequence. Each row is colour-coded: green formalized, amber
deferred within the domain's commissioned scope, grey deferred as an expansion beyond that
scope, red unaccounted, and "contradicted" where a unit is both cited and deferred (the
report shows the conflict rather than picking a side). The report is built from the ledger alone, so what you read
is exactly what the check scored.

### Interface and conventions

- **Interface conformance** (`_tools/check_interface_conformance.py`): each domain's
  public interface, read from the code, follows the corpus's naming and verdict
  conventions. The generated catalogue is in `_index/interface-catalog/`, and each
  domain's `INTERFACE-SPEC.md` is generated from it.

### Hidden tests

Three kinds of test are deliberately not published, because a test you can see is a test
you can write to:

- **An independent reference implementation**, written separately from the rulebase,
  scores each domain on held-out cases.
- **Mutation testing**: small, plausible errors are injected into the rulebase (a `>=`
  turned into `>`, a condition dropped, a deadline shortened), and the reference cases
  must catch them. A mutant that survives shows a gap in the tests.
- **Adversarial red-team testing**: an automated adversary attacks each domain, looking
  for the ways a formalization can look right and be wrong. For example, it looks for a
  missing input silently defaulting to an answer, a rule calling a predicate that does
  not exist (so it fails without saying why), two parts of the domain that disagree, or
  a rule that tests a proxy instead of the condition the statute names. A confirmed
  finding blocks the domain until it is fixed; leads it cannot confirm go to a human
  reviewer.

Their per-domain results will be listed in `_index/STATUS.md` from the next release.

The adversarial red-team report for a domain is available on request: email
mikeamycoder@gmail.com, naming the domain.

## Contributing

Outside contributions cannot be merged yet: they will need a signed contributor licence
agreement, which is being prepared.
