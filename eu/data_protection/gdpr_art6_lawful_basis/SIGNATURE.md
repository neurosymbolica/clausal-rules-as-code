# SIGNATURE — eu/data_protection/gdpr_art6_lawful_basis

The public query surface consists of the called contract and the facade over it.

The called contract has three predicates:
- `lawful_basis_status(PROFILE, RESULT, BASIS, CITATIONS)` (Art 6(1)).
- `purpose_compatibility(PROFILE, RESULT, BASIS, CITATIONS)` (Art 6(4)).
- `gdpr_art6_lawful_basis_input_problems(PROFILE, PROBLEMS)`.

The scaffold facade wraps the contract:
- `decide_gdpr_art6_lawful_basis(PROFILE, gdpr_art6_lawful_basis_verdict(STATUS, CITATIONS))`
- `gdpr_art6_lawful_basis_status(PROFILE, STATUS)`
- `gdpr_art6_lawful_basis_checklist(PROFILE, CHECKLIST)`
- `gdpr_art6_lawful_basis_what_if(PROFILE, KEY, VALUE, STATUS)`

PROFILE is an attribute list `[attribute(Key, Value), ...]` over the twenty keys below, read only through `formalize_lib:profile_get/3` and its siblings. A read happens only after the input check has found no problem, so no key repeats.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every term given, unbound or malformed included. The scorer counts solutions, so a duplicate answer is a refutation.

No statutory figure is imported or declared. The order has no thresholds, periods or amounts, and Art 8 ages are deferred.

The scaffold placeholder status set `{ required, permitted, not_applicable }` is REPLACED by the atoms of section 1.

## 1. Verdict STATUS atoms

`lawful_basis_status/4` RESULT is one of:
- `eligible` (final)
- `ineligible` (final)
- `indeterminate([Key])`, with exactly one bare key atom. It is never a judgement-free bare `indeterminate`.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`
- `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([Key-absent])])`
- `input_problems(Problems)`

`purpose_compatibility/4` RESULT is one of:
- `purpose_compatible` (final)
- `purpose_not_compatible` (final)
- `compatibility_test_not_engaged` (final)
- `compatibility_not_ascertained` (final)
- `indeterminate([new_purpose_processing])`
- `indeterminate([compatible_purpose])`
- `needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing-true, compatible_purpose-unsure])])`
- `input_problems(Problems)`

The result atoms are this order's own. None shares a name with a query. `true`, `false` and `unsure` are values, not verdicts, and are never in `verdict_vocabulary` or `root_exports`.

Checklist item statuses (formalize_lib vocabulary) are `met`, `unmet(failing_keys(Keys))` and `unknown(Keys)`. The `Keys` of `unknown` are the unresolved keys of an open way, in root order.

## 2. Profile keys (root_exports order = input_contract order)

All twenty are bare atoms. There are no numeric or date keys.

| # | Key | Kind | Values | Unit |
|---|---|---|---|---|
| 1 | `basis_claimed` | enumeration | `consent`, `contract`, `legal_obligation`, `vital_interests`, `public_interest_task`, `legitimate_interests` | Art 6(1) |
| 2 | `consent_given_and_conditions_met` | outside fact | `attested(true or false, attestation(By, At, Reason, Evidence))` | Art 6(1)(a) |
| 3 | `contract_necessary` | judgement | `true`, `false`, `unsure` | Art 6(1)(b) |
| 4 | `legal_obligation_necessary` | judgement | `true`, `false`, `unsure` | Art 6(1)(c) |
| 5 | `legal_obligation_laid_down_by_law` | outside fact | attested | Art 6(3) |
| 6 | `vital_interests_necessary` | judgement | `true`, `false`, `unsure` | Art 6(1)(d) |
| 7 | `public_interest_task_necessary` | judgement | `true`, `false`, `unsure` | Art 6(1)(e) |
| 8 | `public_interest_task_laid_down_by_law` | outside fact | attested | Art 6(3) |
| 9 | `processing_by_public_authority_in_its_tasks` | crisp | `true`, `false` | Art 6(1) last subparagraph |
| 10 | `legitimate_interests_pursued` | judgement | `true`, `false`, `unsure` | Art 6(1)(f) |
| 11 | `interests_overridden` | judgement | `true`, `false`, `unsure` | Art 6(1)(f) |
| 12 | `child_data_subject` | outside fact (flag only) | attested | Art 6(1)(f) |
| 13 | `special_category` | outside fact (flag only) | attested | Art 9(1) |
| 14 | `new_purpose_processing` | crisp | `true`, `false` | Art 6(4) |
| 15 | `compatible_purpose` | judgement | `true`, `false`, `unsure` | Art 6(4) |
| 16 | `link_between_purposes_taken_into_account` | crisp, OPTIONAL | `true`, `false` | Art 6(4)(a) |
| 17 | `collection_context_taken_into_account` | crisp, OPTIONAL | `true`, `false` | Art 6(4)(b) |
| 18 | `nature_of_data_taken_into_account` | crisp, OPTIONAL | `true`, `false` | Art 6(4)(c) |
| 19 | `possible_consequences_taken_into_account` | crisp, OPTIONAL | `true`, `false` | Art 6(4)(d) |
| 20 | `appropriate_safeguards_taken_into_account` | crisp, OPTIONAL | `true`, `false` | Art 6(4)(e) |

Evidence is one of `none`, `url(Url, RetrievedAt)` or `document(UploadIdentifier, Sha256)`. It is not inspected beyond `ground/1`.

## 3. Citation-key atoms (citation_vocabulary; canonical lexicon, never shortened)

`eu_reg_2016_679_art_6_1`, `eu_reg_2016_679_art_6_1_a`, `eu_reg_2016_679_art_6_1_b`, `eu_reg_2016_679_art_6_1_c`, `eu_reg_2016_679_art_6_1_d`, `eu_reg_2016_679_art_6_1_e`, `eu_reg_2016_679_art_6_1_f`, `eu_reg_2016_679_art_6_1_second_subpara`, `eu_reg_2016_679_art_6_3`, `eu_reg_2016_679_art_6_4`, `eu_reg_2016_679_art_6_4_a`, `eu_reg_2016_679_art_6_4_b`, `eu_reg_2016_679_art_6_4_c`, `eu_reg_2016_679_art_6_4_d`, `eu_reg_2016_679_art_6_4_e`, `eu_reg_2016_679_art_9_1`.

The deferred units (Art 6(2), Art 6(3)(a) and (b), Art 4(11), Art 7(1) to (4), Art 8(1) to (3)) are recorded in the manifest's deferred set by pinned unit identifier. They are NOT citation_vocabulary atoms, because no answer cites them, and no atom is invented for them.

Referral targets (`outside_facts:`), as key, citation, target:
- `consent_given_and_conditions_met`, `eu_reg_2016_679_art_6_1_a`, `consent_basis_statement`
- `legal_obligation_laid_down_by_law`, `eu_reg_2016_679_art_6_3`, `legal_obligation_law_statement`
- `public_interest_task_laid_down_by_law`, `eu_reg_2016_679_art_6_3`, `public_interest_task_law_statement`
- `child_data_subject`, `eu_reg_2016_679_art_6_1_f`, `child_data_subject_statement` (never referred)
- `special_category`, `eu_reg_2016_679_art_9_1`, `special_category_statement` (never referred)

For every outside fact the fetcher is `none` and the kinds are `attested` then `fetched`.

## 4. Public predicates

- `lawful_basis_status(Profile, Result, Basis, Citations)`: Art 6(1) lawful-basis verdict over the considered ways, by steps (0) to (6) of THE LIMBS. Exactly one solution. Cites `eu_reg_2016_679_art_6_1` plus the per-way atoms.
- `purpose_compatibility(Profile, Result, Basis, Citations)`: Art 6(4) compatibility test by steps (0), (7), (7a), (8) and (9). Basis is always `[]`. Cites `eu_reg_2016_679_art_6_4`, and for not-ascertained also `eu_reg_2016_679_art_6_4_a` to `_e`.
- `gdpr_art6_lawful_basis_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. The result is `[]`, `[wrong_type(profile)]`, or ordered `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms. Total, never raises, exactly one solution. Covers all keys and units above.
- `decide_gdpr_art6_lawful_basis(Profile, Verdict)`: Verdict is `gdpr_art6_lawful_basis_verdict(Result, Citations)`, with Result and Citations those of `lawful_basis_status/4`. Query type #2 (eligibility). Cites `eu_reg_2016_679_art_6_1`.
- `gdpr_art6_lawful_basis_status(Profile, Status)`: Status is the RESULT of `lawful_basis_status/4`. Query type #3 (status determination). Cites `eu_reg_2016_679_art_6_1`.
- `gdpr_art6_lawful_basis_checklist(Profile, Checklist)`: the cited checklist, query type #7 (justification).
  - Each considered way, in point order, gives `item(WayIdentifier, Status, cite(PointCitation))` with Status `met`, `unmet(failing_keys(Keys))` or `unknown(Keys)`.
  - With input problems the checklist is `[item(input_check, unmet(input_problems(Problems)), cite(eu_reg_2016_679_art_6_1))]`.
  - Every item carries a `cite(...)`. The point citations are `eu_reg_2016_679_art_6_1_a` to `_f`.
- `gdpr_art6_lawful_basis_what_if(Profile, Key, Value, Status)`: what Status `lawful_basis_status/4` gives when Key's value is replaced by Value. Every existing entry of Key is removed first and one entry is added, so no duplicate is created. A Value of the atom `absent` only removes the key. Exactly one solution. Cites `eu_reg_2016_679_art_6_1`.
- `gdpr_art6_lawful_basis_fixture(Name, Profile)` and `gdpr_art6_lawful_basis_fixture_expected(Name, Query, Result, Basis, Citations)`: named fixtures and their expected answers. Keep the scaffold's fixture predicate names if they differ. Each fixture cites the units it exercises.

Result constructors (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `flagged/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`. The optional `provenance/2` item is NOT produced (it is unscored and is left out).

## 5. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - Profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`.
  - Checklist construction: `eval_requirements/4`, with the closure `gdpr_art6_lawful_basis_way_requirement`, called as `(WayIdentifier, Profile, Status, Citation)`, RequirementId first.
  - Defeasible point (f) and the law-statement defeaters of (c) and (e): `not_defeated/3`. Verify its call shape in P2: DefeatPred is called with `(RuleId, Profile)`.
  - Constructors `item/3`, `unmet/1`, `unknown/1` and `attribute/2`.
  - `check_tri/4` and `check_tri_neg/4` are used for the per-key tri-state reads where their status vocabulary matches. Otherwise the reads are local, without re-implementing them (C15).
  - `assess/6` is NOT used: it is conjunctive, while Art 6(1) is disjunctive (NOTES decision 16).
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `declare_vacuous/1`, for the property test mode. The generators enumerate the tri-state and absent value of each key per way.
- `kit.query_combinators`: not used. Its `what_if/5` / `override_key/4` are dictionary-based. The what-if over attribute lists is a local remove-then-add in the facade.
- `kit.compliance_lib`, `deadline_lib`, `rolling_window`, `date_time`, `currency_vocab`, `vat_category` and `country`: not used (no modality lattice, dates, money or countries).

## 6. Layer plan (files and modules unchanged)

- **kernel.clausal**: the shared floor; see section 8.
- **citations.clausal**: the citation atoms of section 3. It also holds the `outside_facts:` table `gdpr_art6_lawful_basis_outside_fact_entry(Key, Citation, Target)`, five facts, and the referral eligibility `gdpr_art6_lawful_basis_referable(Key)` for the first three outside facts.
- **parameters.clausal**: deliberately holds NO statutory value. There is no threshold, period or amount in Art 6, and the Art 8 ages are deferred. It keeps only the pinned-consolidation comment. It declares no `constant_value`, so no figure is invented.
- **gdpr_art6_lawful_basis.clausal**: the one determination slice (section 7).
- **queries.clausal**: the facade predicates of section 4, delegating to the slice.
- **fixtures.clausal**: named profiles (section 9).
- **package facade**: re-exports the public predicates and constructors.

## 7. Slice: gdpr_art6_lawful_basis.clausal

The slice is self-contained for Art 6(1) and Art 6(4). It owns its value tables, its derived key-state and way-state arithmetic, its per-rule tests, its checklist and its verdict.

### 7.1 Value facts owned (tables, not shared)

- **Way table.** `gdpr_art6_lawful_basis_way(WayIdentifier, ClaimAtom, PointCitation)`, six facts:
  - `way_consent`, `consent`, `eu_reg_2016_679_art_6_1_a`
  - `way_contract`, `contract`, `eu_reg_2016_679_art_6_1_b`
  - `way_legal_obligation`, `legal_obligation`, `eu_reg_2016_679_art_6_1_c`
  - `way_vital_interests`, `vital_interests`, `eu_reg_2016_679_art_6_1_d`
  - `way_public_interest_task`, `public_interest_task`, `eu_reg_2016_679_art_6_1_e`
  - `way_legitimate_interests`, `legitimate_interests`, `eu_reg_2016_679_art_6_1_f`
- **Needed values.** `gdpr_art6_lawful_basis_way_needs(WayIdentifier, Key, NeededValue)`, in root order within the way:
  - consent: `consent_given_and_conditions_met` needs `attested_true`.
  - contract: `contract_necessary` needs `true`.
  - legal_obligation: `legal_obligation_necessary` needs `true`; `legal_obligation_laid_down_by_law` needs `attested_true`.
  - vital_interests: `vital_interests_necessary` needs `true`.
  - public_interest_task: `public_interest_task_necessary` needs `true`; `public_interest_task_laid_down_by_law` needs `attested_true`.
  - legitimate_interests: `processing_by_public_authority_in_its_tasks` needs `false`; `legitimate_interests_pursued` needs `true`; `interests_overridden` needs `false`.
- **Holding citations.** `gdpr_art6_lawful_basis_holding_citations(WayIdentifier, Citations)`:
  - (a) `[cite(eu_reg_2016_679_art_6_1_a)]`
  - (b) `[cite(eu_reg_2016_679_art_6_1_b)]`
  - (c) `[cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]`
  - (d) `[cite(eu_reg_2016_679_art_6_1_d)]`
  - (e) `[cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]`
  - (f) `[cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]`
- **Failing citations.** The point citation, plus these additions:
  - `cite(eu_reg_2016_679_art_6_3)` for (c) when `legal_obligation_laid_down_by_law` is attested false, and for (e) when `public_interest_task_laid_down_by_law` is attested false.
  - `cite(eu_reg_2016_679_art_6_1_second_subpara)` for (f) when `processing_by_public_authority_in_its_tasks` is true.
- **Open-textured citations.** `gdpr_art6_lawful_basis_open_textured_citation(Key, Citation)`:
  - `contract_necessary`: `eu_reg_2016_679_art_6_1_b`
  - `legal_obligation_necessary`: `eu_reg_2016_679_art_6_1_c`
  - `vital_interests_necessary`: `eu_reg_2016_679_art_6_1_d`
  - `public_interest_task_necessary`: `eu_reg_2016_679_art_6_1_e`
  - `legitimate_interests_pursued` and `interests_overridden`: `eu_reg_2016_679_art_6_1_f`
  - `compatible_purpose`: `eu_reg_2016_679_art_6_4`
- **Factor keys.** `gdpr_art6_lawful_basis_factor_key(Key)` for keys 16 to 20.
- **Not-ascertained citations.** `gdpr_art6_lawful_basis_not_ascertained_citations(Citations)` is Art 6(4) and `_a` to `_e`.

### 7.2 Rules / requirements

- **R0, input gate.** `kernel:gdpr_art6_lawful_basis_input_problems/2` runs first. A non-empty result gives `input_problems(Problems)`, `[]`, `[]` for both queries.
- **R1, key state.** `gdpr_art6_lawful_basis_key_state(Profile, Key, Needed, State)`, with State one of:
  - `satisfied`
  - `opposite`: false for a needed true, true for a needed false, `attested(false, _)` for `attested_true`
  - `absent`
  - `unsure`: judgements only

  It is exactly one clause per state, guarded by presence (`profile_has/2` / `profile_lacks/2`) and then by value.
- **R2, way state.** `gdpr_art6_lawful_basis_way_state(Profile, WayIdentifier, WayState)` is computed from the list of key states. WayState is:
  - `holds`: all satisfied
  - `fails`: some key opposite
  - `open(UnresolvedKeys)`: otherwise, with the keys in root order

  Defeasible reading for (c), (e) and (f): the prima facie rule is the necessity judgement (and, for (f), `legitimate_interests_pursued`). The defeaters are the law statement attested false, `processing_by_public_authority_in_its_tasks` true, and `interests_overridden` true. They are probed with `once/1`-guarded defeater clauses through `formalize_lib:not_defeated/3`. An unproven defeater never makes a way hold; holding needs the positive values (fail-closed).
- **R3, considered ways.** `gdpr_art6_lawful_basis_considered_ways(Profile, WayIdentifiers)`. When `basis_claimed` is present, the result is the one way whose ClaimAtom matches. When it is absent, it is all six in point order.
- **R4, step selection (lawful_basis_status).** `gdpr_art6_lawful_basis_lawful_step(Profile, Step)` gives exactly one Step from mutually exclusive guards over the summary:
  - `holding(Ways)`
  - `all_failing(Ways)`
  - `one_step_named(Key)`: step (3a), first judgement or crisp absent key of a one-step way, in root order
  - `one_step_referred(Key)`: step (3b), first outside fact absent key of a one-step way
  - `missing_named(Key)`: step (4)
  - `absent_referred(Key)`: step (5)
  - `unsure_referred(Key)`: step (6)

  The first match in root order is taken by filtering the fixed root key list and taking its head, with no backtracking choice.
- **R5, answer construction.** One `lawful_basis_status/4` clause per step, with ground outputs in the head where constant (C17).
  - CITATIONS for eligible: `cite(eu_reg_2016_679_art_6_1)` plus the holding citations of every holding way, deduplicated.
  - CITATIONS for ineligible: `cite(eu_reg_2016_679_art_6_1)` plus the failing citations of every way, deduplicated.
  - BASIS for eligible: in root order, the `outside_fact(Key, Attested)` of holding ways' outside facts. Then `flagged(child_data_subject, Attested)` if `way_legitimate_interests` is considered and holds and the child fact is attested true. Then `flagged(special_category, Attested)` if that fact is attested true.
  - BASIS for ineligible: the `outside_fact` of considered ways' outside facts attested false, in root order.
  - Referral PAIRS for step (6), as `Key-Value` in root order, over the PRESENT keys among:
    - `basis_claimed`
    - the keys of considered ways
    - `child_data_subject` when `way_legitimate_interests` is considered
  - PAIRS for (3b) and (5) are `[Key-absent]`.
  - Not-final BASIS and CITATIONS are `[]`.
- **R6, purpose_compatibility.** Mutually exclusive clauses:
  - NP false: `compatibility_test_not_engaged` with `[cite(eu_reg_2016_679_art_6_4)]`.
  - NP absent: `indeterminate([new_purpose_processing])`.
  - NP true and some factor key false (`once/1` over the five factor keys): `compatibility_not_ascertained` with the six citations.
  - NP true, no factor false, CP true: `purpose_compatible`.
  - NP true, no factor false, CP false: `purpose_not_compatible`.
  - NP true, no factor false, CP absent: `indeterminate([compatible_purpose])`.
  - NP true, no factor false, CP unsure: the open_textured referral with PAIRS `[new_purpose_processing-true, compatible_purpose-unsure]`.
  - BASIS is always `[]`. Absent or true factor keys change nothing.
- **R7, checklist requirement.** `gdpr_art6_lawful_basis_way_requirement(WayIdentifier, Profile, Status, Citation)` maps `holds` to `met`, `fails` to `unmet(failing_keys(Keys))` and `open(Keys)` to `unknown(Keys)`, with Citation `cite(PointCitation)`. There are three exclusive clauses. It is fed to `eval_requirements/4` over the considered ways.

### 7.3 Verdict atoms

`eligible`, `ineligible`, `purpose_compatible`, `purpose_not_compatible`, `compatibility_test_not_engaged` and `compatibility_not_ascertained`, plus the status compounds of section 1.

### 7.4 Per-rule tests (in the slice's test file)

Each way gets a holds, a fails and an open case. (c), (e) and (f) also get a defeater case each, and every negative test is paired with a positive one over the same case. Then:
- **basis_claimed restriction:** a claimed way fails while another would hold, giving ineligible.
- **Precedence:**
  - (3a) versus (3b).
  - (3b) over a missing key of a non-one-step way.
  - (4) over an unsure judgement.
  - (5) over (6).
- **Ties in root order.**
- **Flags:**
  - child flagged only when (f) holds;
  - special_category on eligible only;
  - never on ineligible.
- **Citation growth with an extra holding way.**
- **Art 6(4):**
  - every branch;
  - a factor false overriding CP true;
  - absent factor keys never named.
- **Solution counts:** `findall` length 1 on every query.

### 7.5 Shared with another slice

There is only one slice, so nothing is shared slice-to-slice. The slice imports only the kernel predicates of section 8, which the queries, fixtures and facade also need.

## 8. kernel.clausal (shared floor only)

- `gdpr_art6_lawful_basis_root_keys(Keys)`: the twenty keys in root_exports order.
- `gdpr_art6_lawful_basis_key_kind(Key, Kind)`: Kind is one of `enumeration`, `judgement`, `crisp`, `optional_crisp` or `outside_fact`.
- `gdpr_art6_lawful_basis_input_problems(Profile, Problems)`: THE INPUT CHECK, used by both queries, the facade and the fixtures.
  - Attribute-list shape check: `is_list/1` plus every element nonvar `attribute(_, _)`.
  - Identity-based (`==`) duplicate count.
  - Type check per kind: an attested shape with `ground/1` on the four attestation arguments, and the enumeration membership.
  - Unknown keys in first-occurrence order, deduplicated by `==`.
- `gdpr_art6_lawful_basis_attested_value(Profile, Key, TruthValue, Attested)`: the read of an attested outside fact, returning its truth value and the whole term to copy.
- `gdpr_art6_lawful_basis_absent_referral(Key, Result)`: builds THE ABSENT REFERRAL from the citations table.

## 9. Fixtures and test modes

The fixtures cover:
- each way holding alone;
- all ways failing with both law statements attested false;
- the claimed consent way with the statement absent (referral);
- an (f) one-step case with `interests_overridden` absent;
- an (f) unsure balance with child present (PAIRS carries `child_data_subject`);
- an unsure contract with a missing vital interests key (named first);
- special_category flagged on eligible;
- each input-problem kind: duplicate, wrong_type attested on a judgement, bare `true` on an outside fact, unbound attestation argument, unknown non-atom key, partial-list profile;
- the Art 6(4) branches: not engaged, missing NP, factor false, compatible, not compatible, missing CP, unsure CP.

The scaffold's seven test modes and the v2 manifest are kept unchanged. The validate_props properties are totality, determinism (exactly one solution), citation completeness (every cite in citation_vocabulary) and missing-key coverage (no outside fact or factor key ever in MISSING_KEYS).
