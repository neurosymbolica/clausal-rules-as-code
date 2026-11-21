# SIGNATURE — eu/data_protection/gdpr_complaints_and_judicial_remedies

## Public query surface

The facade answers one verdict per query, for each of the five queries, in this fixed order:

`complaint_right`, `authority_decision_remedy_right`, `authority_inaction_remedy_right`, `controller_processor_remedy_right`, `controller_processor_forum`.

The verdict shape is:

`decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(Query, Result), Citations))`

Facade guarantees:

- **Totality and determinism**: exactly five solutions for every term given as Profile, one per query.
- **Input problems**: when the profile has input problems, each of the five solutions carries `input_problems(Problems)` and `[]`.
- **Where the logic lives**: the per-query predicates (prefix `gdpr_complaints_and_judicial_remedies_`) are the authoritative limb logic. Each is total and deterministic: exactly one solution.
- **Parameters**: none are imported or declared. There are no thresholds, amounts or dates, and the three months of Art 78(2) are stated by the caller, not counted.

## Verdict STATUS atoms (replace the placeholder `required / permitted / not_applicable`)

STATUS is `answer(Query, Result)`. Result is one of the following.

Final results, per query:

- `complaint_right`: `complaint_right_exists` | `no_complaint_right`
- `authority_decision_remedy_right`: `decision_remedy_right_exists` | `no_decision_remedy_right`
- `authority_inaction_remedy_right`: `inaction_remedy_right_exists` | `no_inaction_remedy_right`
- `controller_processor_remedy_right`: `judicial_remedy_right_exists` | `no_judicial_remedy_right`
- `controller_processor_forum`: `forum_establishment_state_only` | `forum_establishment_or_habitual_residence_state`

Non-final results:

- `input_problems(Problems)`
- `indeterminate([Key])`: one key, the first missing needed key.
- `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on(Pairs)])`
- `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on(Pairs)])`

The bare atom `indeterminate` is NEVER written.

Eligibility reading (query type #2): `*_exists` is the eligible side, `no_*` is the ineligible side, and `indeterminate/1` and `needs_legal_review/2` are the undetermined side.

Checklist labels for `assess/6`:

- `labels(complaint_right_exists, complaint_right_undetermined, no_complaint_right)`
- `labels(decision_remedy_right_exists, decision_remedy_right_undetermined, no_decision_remedy_right)`
- `labels(inaction_remedy_right_exists, inaction_remedy_right_undetermined, no_inaction_remedy_right)`
- `labels(judicial_remedy_right_exists, judicial_remedy_right_undetermined, no_judicial_remedy_right)`

Result constructors are exported and never called as queries:

`indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `answer/2`, `gdpr_complaints_and_judicial_remedies_verdict/2`.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`. It is read only with `profile_get/3`, presence first. There are eleven keys, given here in root_exports and input_contract order. None is numeric and none is a date, so no unit suffix or `date(Y, M, D)` term occurs.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `is_data_subject` | crisp | `true` / `false` |
| 2 | `data_subject_considers_processing_infringes_regulation` | crisp | `true` / `false` |
| 3 | `decision_is_legally_binding` | judgement | `true` / `false` / `unsure` |
| 4 | `decision_concerns_the_caller` | judgement | `true` / `false` / `unsure` |
| 5 | `complaint_lodged_under_article_77` | crisp | `true` / `false` |
| 6 | `authority_competent_under_articles_55_and_56` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` |
| 7 | `authority_handled_the_complaint` | crisp | `true` / `false` |
| 8 | `three_months_from_the_complaint_have_passed` | crisp | `true` / `false` |
| 9 | `authority_informed_on_progress_or_outcome` | crisp | `true` / `false` |
| 10 | `data_subject_considers_rights_infringed_by_processing` | crisp | `true` / `false` |
| 11 | `defendant_is_member_state_public_authority_acting_in_public_powers` | crisp | `true` / `false` |

The outside fact (key 6) behaves as follows:

- Its fetcher is `none`; kinds in precedence order are `attested`, then `fetched`, and only `attested` is read today.
- `By` and `At` are host-supplied.
- `Evidence` is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`.
- The four attestation arguments are never inspected beyond groundness.
- The value is copied as `outside_fact(authority_competent_under_articles_55_and_56, Attested)` into Basis.

## Citation-key atoms (canonical, from `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2016_679_art_77_1`: Art 77(1), the right to lodge a complaint.
- `eu_reg_2016_679_art_78_1`: Art 78(1), the remedy against a legally binding decision.
- `eu_reg_2016_679_art_78_2`: Art 78(2), the remedy for authority inaction.
- `eu_reg_2016_679_art_79_1`: Art 79(1), the remedy against a controller or processor.
- `eu_reg_2016_679_art_79_2`: Art 79(2), the forum.
- `competence_statement`: the cross-reference TARGET only (the Arts 55 and 56 competence statement). It is never a final-answer citation.

Art 77(2), Art 78(3) and Art 78(4) get NO atom (deferred).

## Public predicates

- `gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems)`: the typed input check. It yields exactly one solution, never fails and never raises. Problems lists, in this order:
  - per contract key in contract order, `duplicate_key(Key)`, else `wrong_type(Key)`;
  - then `unknown_key(Key)` in first-occurrence order (deduplicated with `==`);
  - a non-list, partial list, unbound term or non-`attribute/2` element gives `[wrong_type(profile)]` alone.
  - Citation: input_contract (no provision).
- `gdpr_complaints_and_judicial_remedies_complaint_right(Profile, Result, Citations)`: Art 77(1). Citation: `eu_reg_2016_679_art_77_1`.
- `gdpr_complaints_and_judicial_remedies_authority_decision_remedy_right(Profile, Result, Citations)`: Art 78(1). Citation: `eu_reg_2016_679_art_78_1`.
- `gdpr_complaints_and_judicial_remedies_authority_inaction_remedy_right(Profile, Result, Basis, Citations)`: Art 78(2). Citation: `eu_reg_2016_679_art_78_2`.
- `gdpr_complaints_and_judicial_remedies_controller_processor_remedy_right(Profile, Result, Citations)`: Art 79(1). Citation: `eu_reg_2016_679_art_79_1`.
- `gdpr_complaints_and_judicial_remedies_controller_processor_forum(Profile, Result, Citations)`: Art 79(2). Citation: `eu_reg_2016_679_art_79_2`.
- `decide_gdpr_complaints_and_judicial_remedies(Profile, Verdict)`: the facade.
  - Verdict is `gdpr_complaints_and_judicial_remedies_verdict(answer(Query, Result), Citations)`, one solution per query in fixed order.
  - Basis is not carried; read it from the inaction query.
  - Citations: the per-query citations above.
- `gdpr_complaints_and_judicial_remedies_status(Profile, Status)`: Status is `answer(Query, Result)`, one solution per query. Citations: those of the five queries.
- `gdpr_complaints_and_judicial_remedies_checklist(Profile, Assessment)`: query types #2 and #7.
  - It yields `assessment(Query, Decision, Items)` from formalize_lib `assess/6`, for each of the four right queries (the forum query is not an eligibility and has no checklist).
  - Each item is `item(RequirementId, Status, cite(CitationKey))`, met items included.
  - If the profile has input problems, the checklist has no solution; read Status first.
  - Citations: per item, Arts 77(1), 78(1), 78(2) and 79(1).
- `gdpr_complaints_and_judicial_remedies_what_if(Profile, Key, Value, Verdicts)`: the counterfactual.
  - It replaces or sets `attribute(Key, Value)` with `profile_set/3`, then gives Verdicts, the sorted list of facade verdicts on the edited profile.
  - Citation: as the facade.
- `gdpr_complaints_and_judicial_remedies_fixture(Name, Profile)`: the named example profiles (see Fixtures).
- `gdpr_complaints_and_judicial_remedies_fixture_expected(Name, Query, Result)`: the expected result per fixture and query.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - `check_true/4` for crisp requirement items;
  - `check_tri/4` for the two tri-state judgement items (`unsure` reads as unknown). If, at authoring, `check_tri/4` is found NOT to treat the atom `unsure` as unknown, stop and report it rather than clone it (lint C15);
  - `assess/6`, `labels/3`, `assessment/3`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.
- **validate_props** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Considered and NOT used**, with the reason for each:
  - `kit/deadline_lib`: the three months are not counted (Q4).
  - `country`: the forum names a category of courts, not a State.
  - `kit/compliance_lib`: the order states the existence of rights, not a compliance verdict over obligations.
  - `library(datetime)`: no dates.
  - `kit/query_combinators`: `what_if/5` expects a dict-shaped profile, so the attribute-list counterfactual uses `profile_set/3`.
- **Family backbone `_common` (deontic)**: none needed beyond formalize_lib.

## Module placement (layout unchanged)

- `kernel.clausal`: the shared floor. Nothing domain-specific is added, because there is only one determination slice and it shares no predicate with another slice.
- `citations.clausal`: the citation facts for the six atoms above, with pinned units.
- `parameters.clausal`: no statutory figures. The file stays a placeholder-free empty parameter module, with a comment saying why.
- `gdpr_complaints_and_judicial_remedies.clausal`: the slice (below).
- `queries.clausal`: re-exports the input check and the five queries.
- `fixtures.clausal`: the fixtures.
- The package facade holds `decide_`, `status`, `checklist` and `what_if`.

## Slice: gdpr_complaints_and_judicial_remedies.clausal

### Value facts owned

None are numeric.

- The 'three months' of Art 78(2) is NOT a `constant_value`: it is never computed with, and the caller states whether it has run (Q4).
- The slice owns the contract key list as a fact table: `gdpr_complaints_and_judicial_remedies_contract_key(Position, Key, Kind)`, with Kind one of `crisp`, `judgement` or `outside_fact`, in the eleven-key order.

### Input check

`gdpr_complaints_and_judicial_remedies_input_problems/2`:

- Disjoint clauses on the shape of the profile: `var/1` gives `[wrong_type(profile)]`; not a proper list gives `[wrong_type(profile)]`; an element that is unbound or not `attribute(_, _)` gives `[wrong_type(profile)]`; a well-formed list gets the full check.
- Duplicates are counted with `==`, and the values of a duplicated key are never read.
- Value typing:
  - crisp: `true` or `false`;
  - judgement: `true`, `false` or `unsure`;
  - outside fact: `attested(V, attestation(By, At, Reason, Evidence))` with V `true` or `false` and each of the four arguments ground.
  - An unbound value gives `wrong_type(Key)`.
- Unknown keys, non-atom and unbound keys included, are deduplicated with `==` in first-occurrence order.
- There is no cut and no if-then-else, and the check yields exactly one solution.

### Rules / requirements (limbs; the first step that answers decides; one clause per disjoint route, ground result folded into the head)

Step 0 is shared by every query. If Problems is non-empty, the Result is `input_problems(Problems)`, Citations is `[]`, and Basis is `[]` where the query has one.

**complaint_right**

1. `is_data_subject` false: `no_complaint_right`, `[cite(eu_reg_2016_679_art_77_1)]`.
2. `data_subject_considers_processing_infringes_regulation` false (with `is_data_subject` not false): `no_complaint_right`, `[cite(eu_reg_2016_679_art_77_1)]`.
3. The first absent key of [`is_data_subject`, `data_subject_considers_processing_infringes_regulation`]: `indeterminate([Key])`, `[]`.
4. Both true: `complaint_right_exists`, `[cite(eu_reg_2016_679_art_77_1)]`.

**authority_decision_remedy_right**

1. Either judgement false: `no_decision_remedy_right`, `[cite(eu_reg_2016_679_art_78_1)]`.
2. The first absent key of [`decision_is_legally_binding`, `decision_concerns_the_caller`]: `indeterminate([Key])`, `[]`.
3. Both present, neither false, the first unsure Key: `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding-V1, decision_concerns_the_caller-V2])])`, `[]`.
4. Both true: `decision_remedy_right_exists`, `[cite(eu_reg_2016_679_art_78_1)]`.

**authority_inaction_remedy_right**

A local helper, `gdpr_complaints_and_judicial_remedies_authority_failure(Profile, FailureState)`, gives exactly one of three states, through disjoint clauses:

- `authority_failure_holds` when:
  - three months true AND informed false (whatever handled is); OR
  - handled false (and not the previous case).
- `authority_failure_absent` when handled true AND (three months false OR informed true).
- `authority_failure_missing(Key)` otherwise. Key is:
  - `authority_handled_the_complaint` when handled is absent;
  - `three_months_from_the_complaint_have_passed` when handled is true and three months is absent (and informed is not true);
  - `authority_informed_on_progress_or_outcome` when handled is true, three months is true and informed is absent.

The steps:

1. `is_data_subject` false: `no_inaction_remedy_right`, Basis `[]`, `[cite(eu_reg_2016_679_art_78_2)]`.
2. `complaint_lodged_under_article_77` false: as step 1.
3. Competence attested false: `no_inaction_remedy_right`, Basis `[outside_fact(authority_competent_under_articles_55_and_56, Attested)]`, `[cite(eu_reg_2016_679_art_78_2)]`, whatever the other keys are.
4. FailureState is `authority_failure_absent` (competence absent or attested true): `no_inaction_remedy_right`, Basis `[]`, `[cite(eu_reg_2016_679_art_78_2)]`.
5. The first absent needed key, in order `is_data_subject`, `complaint_lodged_under_article_77`, then the Key of `authority_failure_missing(Key)`: `indeterminate([Key])`, `[]`, `[]`. Competence is never named.
6. All needed keys present, the failure holds, competence absent: `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56-absent])])`, `[]`, `[]`.
7. The failure holds and competence is attested true: `inaction_remedy_right_exists`, Basis `[outside_fact(authority_competent_under_articles_55_and_56, Attested)]`, `[cite(eu_reg_2016_679_art_78_2)]`.

**controller_processor_remedy_right**

1. `is_data_subject` false: `no_judicial_remedy_right`, `[cite(eu_reg_2016_679_art_79_1)]`.
2. `data_subject_considers_rights_infringed_by_processing` false: as step 1.
3. The first absent key of [`is_data_subject`, `data_subject_considers_rights_infringed_by_processing`]: `indeterminate([Key])`, `[]`.
4. Both true: `judicial_remedy_right_exists`, `[cite(eu_reg_2016_679_art_79_1)]`.

**controller_processor_forum**

1. The exception key is absent: `indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers])`, `[]`.
2. The key is true: `forum_establishment_state_only`, `[cite(eu_reg_2016_679_art_79_2)]`.
3. The key is false: `forum_establishment_or_habitual_residence_state`, `[cite(eu_reg_2016_679_art_79_2)]`.

### Checklist requirements

The requirements are read by `gdpr_complaints_and_judicial_remedies_requirement(RequirementId, Profile, Status, Citation)`, RequirementId first. Each has exactly three disjoint clauses: met, `unmet(Reason)` and `unknown([Key])`.

- **complaint_right** (cite `eu_reg_2016_679_art_77_1`):
  - `complaint_data_subject`: `check_true` on `is_data_subject`.
  - `complaint_infringement_considered`: `check_true` on `data_subject_considers_processing_infringes_regulation`.
- **authority_decision_remedy_right** (cite `eu_reg_2016_679_art_78_1`):
  - `decision_legally_binding`: `check_tri` on `decision_is_legally_binding`.
  - `decision_concerns_caller`: `check_tri` on `decision_concerns_the_caller`.
- **authority_inaction_remedy_right** (cite `eu_reg_2016_679_art_78_2`):
  - `inaction_data_subject`: `check_true` on `is_data_subject`.
  - `inaction_complaint_lodged`: `check_true` on `complaint_lodged_under_article_77`.
  - `inaction_authority_competent`: attested true is met, attested false is unmet, absent is `unknown([authority_competent_under_articles_55_and_56])`. This is a justification item only; the RESULT never names the key.
  - `inaction_authority_failure`: maps the three FailureStates to met, unmet and `unknown([Key])`.
- **controller_processor_remedy_right** (cite `eu_reg_2016_679_art_79_1`):
  - `remedy_data_subject`: `check_true` on `is_data_subject`.
  - `remedy_rights_infringement_considered`: `check_true` on `data_subject_considers_rights_infringed_by_processing`.

Consistency obligation, tested: for a well-formed profile, a final positive Result gives the Pos label, a final negative Result gives the Neg label, and a non-final Result gives the undetermined label.

### Verdict atoms of this slice

All the STATUS atoms listed above. The slice owns all five queries.

### Shared with another slice (belongs in kernel.clausal)

None. There is only one slice.

## Fixtures (planned; `fixture/2` plus `fixture_expected/3`)

- `full_positive`: every right exists. Competence is attested true; handled is false; the forum key is false.
- `not_a_data_subject`: every data-subject right is absent. The decision remedy is unaffected.
- `decision_unsure_binding`: an open_textured referral on `decision_is_legally_binding`.
- `decision_unsure_and_missing`: `decision_is_legally_binding` is unsure and `decision_concerns_the_caller` is absent, giving `indeterminate([decision_concerns_the_caller])`.
- `inaction_competence_absent`: the cross_reference_unresolved referral.
- `inaction_competence_false`: `no_inaction_remedy_right` with Basis, even with `is_data_subject` absent.
- `inaction_handled_and_informed`: `no_inaction_remedy_right` with competence absent.
- `inaction_three_months_uninformed_handled_absent`: the failure holds without `authority_handled_the_complaint`.
- `inaction_handled_three_months_absent`: `indeterminate([three_months_from_the_complaint_have_passed])`.
- `forum_public_authority`: `forum_establishment_state_only`.
- `empty_profile`: every query gives `indeterminate([FirstKey])`, and the forum query names its key.
- `malformed_duplicate_and_unknown`: `input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)])`.
- `malformed_unbound_attestation`: `input_problems([wrong_type(authority_competent_under_articles_55_and_56)])`.

## Tests (per-rule, across the seven test modes)

- One positive and one paired negative test per limb route.
- Input-check tests for every problem kind and shape: an unbound profile, a partial list, a non-attribute element, a non-atom key, an unbound value and an unbound attestation argument.
- Facade tests use `findall` plus `sort` or `length`, never `once/1`.
- validate_props properties: totality, determinism (exactly one Result per query), citation completeness (every final Result has a non-empty canonical Citations list and every non-final Result has `[]`), and missing-key coverage.