# clausal-rules-as-code

Laws written as executable logic programs. Each folder under a jurisdiction (`eu/`, `ch/`,
`uk/`, `cn/`, `ind/`, `sg/`, `us/`, `ae/`) is one **domain**: one narrowly scoped legal question, drawn from
one or a few articles (for example, *is this person a beneficial owner under AMLR Art 52?*, or
*does this aid stay under the de minimis ceiling?*). No domain is a complete formalization of a
statute. For each domain you get:

- the **rulebase** (`*.clausal`, Clausal Prolog), where every rule carries the provision it
  implements, and under `iso/` the same rules and tests as plain ISO Prolog (`*.pl`),
  generated from it;
- the **tests** (`tests/`);
- the **statute text it was written against** (`sources/`), pinned by URL and SHA-256 (the Singapore, Colorado, Texas and UAE
  domains carry no statute text: they link to the official legislation sites instead, see `NOTICE`);
- a **manifest** (`manifest.yaml`) stating the domain's scope, its public interface, and
  every provision it deliberately does not implement, with the reason and the consequence;
- a **provision-tracking ledger** (`provisions.yaml`), for the eight domains listed below
  that have one.

The programs run on [Clausal Prolog](https://github.com/neurosymbolica/clausal-prolog). The
shared libraries in `kit/` are still written in the engine's earlier syntax (`.seam`); every
domain's own rules are in `.clausal`.

Documentation, with every domain, its checks and, for the eight ledger domains, a
side-by-side statute report: <https://neurosymbolica.github.io/clausal-rules-as-code/>

## Disclaimer

These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

Every domain folder added on 2026-11-16, 2026-11-18, 2026-11-21, 2026-11-22 or 2026-11-25 repeats this in its own `README.md`.

## What is in it

151 domains and 29,966 tests (29,935 in the domains, 31 in the shared procurement vocabulary),
all passing on Clausal Prolog, Scryer Prolog and Trealla Prolog. All are law in force.

| Area | Domains |
|---|---|
| EU: GDPR (including the GDPR Procedural Regulation) | 45 |
| EU: AI Act | 11 |
| EU: NIS 2 Directive and its implementing regulation | 9 |
| EU: public procurement (Directives 2014/24 and 2014/25) | 5, plus the shared vocabulary `eu/procurement/directive_2014_24/` |
| EU: state aid (de minimis, single undertaking, SME definition, GBER general conditions) | 4 |
| EU: working time (daily rest, weekly rest, weekly limit, night work) | 4 |
| EU: anti-money laundering (AMLR beneficial ownership) | 2 |
| EU: CBAM (de minimis, origin exclusions) | 2 |
| EU: ePrivacy Directive | 2 |
| EU: Digital Operational Resilience Act (DORA) | 30 |
| EU: Cyber Resilience Act (Art 14 reporting, administrative fines, manufacturer duties) | 3 |
| EU: Digital Markets Act (Art 3, Art 5(2), Arts 6(9) and 6(10)) | 3 |
| EU: Digital Services Act (Art 14 terms and conditions, Art 28 minors) | 2 |
| EU: Data Act | 1 |
| Switzerland: Federal Act on Data Protection | 5 |
| United Kingdom: UK GDPR, Data Protection Act 2018, Data (Use and Access) Act 2025, PECR | 5 |
| China: Personal Information Protection Law | 2 |
| India: Digital Personal Data Protection Act 2023 and Rules 2025 | 5 |
| Singapore: GST registration, PDPA data breach notification, corporate service providers, small-company audit exemption, payment services licensing, securities offer exemptions | 6 |
| United States: Virginia Consumer Data Protection Act, Colorado Privacy Act, Texas Data Privacy and Security Act | 3 |
| United Arab Emirates: Personal Data Protection Law (Federal Decree-Law 45 of 2021): scope and exclusions, lawful processing and consent | 2 |

`_index/STATUS.md` lists every domain with its test count and the result of each check.

Not included: proposals that are not yet law, and domains whose source texts are not cleared
for republication (see `NOTICE`).

### How the domains were made

The first release (2026-11-16) began with eight EU domains, chosen because they pass every check
in this repository, including robustness tests that feed each decision missing, mistyped and
incomplete inputs (a bad input must be refused or answered "indeterminate", never guessed).
They are the only domains with a provision-tracking ledger and a side-by-side report:

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

The other 135 domains were added on 2026-11-16 (66), 2026-11-18 (19), 2026-11-21 (25), 2026-11-22 (1) and 2026-11-25 (24); on 2026-11-18 eight of
the earlier ones, on 2026-11-21 seventeen and on 2026-11-22 one, were also replaced by amended versions. Each was produced through the Clausify
harness, and its answers were scored against an independently written, sealed test oracle that
is not published (the verdicts were recorded after the runs and are not authenticated); its
tests here pass on all three engines. They have no provision-tracking ledger, so no check
accounts for how much of the statute each one covers, and no side-by-side report.

On 2026-11-20 6 Singapore domains were added. They quote no Singapore legislation: each citation record carries a label and a link to [Singapore Statutes Online](https://sso.agc.gov.sg), where the text can be read, and no statute text is pinned in the domain folder.

The Colorado Privacy Act and Texas Data Privacy and Security Act domains, added on 2026-11-21, are published the same way: they quote no Colorado or Texas law, and their citation records give a label and a link to the Colorado Secretary of State and to the Texas Statutes site.

The two United Arab Emirates domains (Personal Data Protection Law, Federal Decree-Law 45 of 2021: scope and exclusions; lawful processing and consent), added on 2026-11-26, are published the same way: they quote no UAE legislation beyond titles, headings and short terms used as citation labels, and their citation records give a label and a link to the [UAE Legislation portal](https://uaelegislation.gov.ae), where the text can be read.

Licence: EUPL-1.2 (see `LICENSE`). The legal texts quoted here are not official
versions of the law; see `NOTICE`.

## Catalogue by law

`catalog.json` at the root lists every rule set in the repository: its folder, jurisdiction, the acts and
articles its citation records cite, whether it has a provision-tracking ledger, and the date of the first
release that contained it. `_index/by-law/` has one page per act (for example `gdpr.md`, `dora.md`,
`nis2.md`, `ai-act.md`) listing the rule sets that cite it. Both are generated from the tree by
`_tools/catalog.py generate`, and `_tools/catalog.py check` fails if either one differs from the tree.
Folders and domain ids are unchanged.

## Running it

```sh
pip install 'clausal>=1.4.0' pyyaml   # the engine (Clausal Prolog), and YAML for the tools
python run_tests.py                   # every domain's tests
python run_tests.py eu/aml            # one jurisdiction or area
```

The same tests, through the generated ISO Prolog in each domain's `iso/` folder, on
[Scryer Prolog](https://www.scryer.pl) or [Trealla Prolog](https://github.com/trealla-prolog/trealla):

```sh
python run_iso_tests.py scryer /path/to/scryer-prolog
python run_iso_tests.py trealla /path/to/tpl
```

This release was tested with Clausal Prolog 1.4.0, Scryer Prolog v0.10.0-137-g9acba77a and
Trealla Prolog v2.92.3.

## How the formalizations are checked

These are the checks the corpus runs. Not every domain has every kind yet: which checks
each domain has, and passes, is listed in `_index/STATUS.md`, generated at export. You can
re-run all of them yourself, except the three under "Hidden tests", which are kept private
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

- **Public interface**: each domain's public predicates are listed in `manifest.yaml`
  (`public_interface`) and exported by its `__init__.clausal`; `tests/test_public_interface.*`
  exercises them. The corpus's interface catalogue, the per-domain `INTERFACE-SPEC.md`
  generated from it and the conformance check still read only the engine's earlier syntax,
  so they are not in this release; they return when they read `.clausal`.

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
mike.amy@neurosymbolic.solutions, naming the domain.

## Contributing

Outside contributions cannot be merged yet: they will need a signed contributor licence
agreement, which is being prepared.
