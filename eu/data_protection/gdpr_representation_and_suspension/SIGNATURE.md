# SIGNATURE — eu/data_protection/gdpr_representation_and_suspension

## Overview

The package has five contract queries, one input check and the scaffold facade. Layout: kernel -> citations -> parameters -> gdpr_representation_and_suspension -> queries -> fixtures -> package facade. File and module names are unchanged.

Guarantees:

- Every public predicate is TOTAL and DETERMINISTIC: exactly ONE solution for every input. The scorer counts every solution, so a duplicate answer is a refutation.
- There is no cut, no `->` and no `*->`.
- Ground outputs are folded into clause heads (C17).
- Ladder steps are disjoint clauses guarded with `\+`.
- A first-in-order scan picks the one firing key.
- The PROFILE is read only through `profile_get/3`.

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

Final RESULT atoms (ten):

| Query | Positive atom | Negative atom |
|---|---|---|
| `mandated_representation` | `may_act_on_mandate` | `may_not_act_on_mandate` |
| `representation_without_mandate` | `may_act_without_mandate` | `may_not_act_without_mandate` |
| `court_contact_duty` | `contact_duty_applies` | `contact_duty_does_not_apply` |
| `court_suspension_option` | `may_suspend_proceedings` | `suspension_not_available` |
| `court_declining_jurisdiction_option` | `may_decline_jurisdiction` | `declining_jurisdiction_not_available` |

Status compounds. A non-final RESULT is exactly one of:

- `indeterminate([KEY])`;
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`;
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`;
- `input_problems(PROBLEMS)`.

NEVER write the bare atom `indeterminate` (atom-shadowing trap). For the same reason, `assess/6` with `labels/3` is NOT used to make a decision.

For query type #2 (eligibility), the five positive atoms are the 'eligible' answers and the five negative atoms are the 'ineligible' answers. `indeterminate([KEY])` and `needs_legal_review/2` are the indeterminate answers.

Other atoms in `root_exports`:

- ACTION atoms: `lodge_complaint_under_article_77`, `exercise_rights_under_article_78`, `exercise_right_under_article_79`, `receive_compensation_under_article_82`.
- Value atoms: `unsure`, `absent`, `not_attempted`.
- The eighteen keys.

Problem terms:

- `duplicate_key(KEY)`
- `wrong_type(KEY)`
- `wrong_type(profile)`
- `wrong_type(action)`
- `unknown_key(KEY)`

Result constructors (exported, never queried):

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`
- `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

## Profile keys (eighteen; this order is canonical everywhere)

PROFILE is `[attribute(KEY, VALUE), ...]`. A key may be absent; absence is never an input problem.

| # | Key | Type |
|---|---|---|
| 1 | `body_is_not_for_profit` | crisp |
| 2 | `body_properly_constituted_under_member_state_law` | judgement |
| 3 | `body_statutory_objectives_in_public_interest` | judgement |
| 4 | `body_active_in_protection_of_data_subjects_rights_and_freedoms` | judgement |
| 5 | `data_subject_mandated_the_body` | crisp |
| 6 | `member_state_law_provides_for_mandated_compensation_claims` | outside fact |
| 7 | `member_state_law_provides_for_the_action_without_mandate` | outside fact |
| 8 | `body_considers_data_subject_rights_infringed_by_processing` | crisp |
| 9 | `court_is_competent_court` | crisp |
| 10 | `court_has_information_on_proceedings_pending_in_another_member_state` | crisp |
| 11 | `other_proceedings_pending_in_court_of_another_member_state` | crisp |
| 12 | `other_proceedings_concern_same_controller_or_processor` | crisp |
| 13 | `other_proceedings_concern_same_subject_matter` | judgement |
| 14 | `court_is_court_first_seized` | crisp |
| 15 | `other_proceedings_pending_at_first_instance` | crisp |
| 16 | `party_applied_for_court_to_decline_jurisdiction` | crisp |
| 17 | `court_first_seized_has_jurisdiction_over_the_actions` | outside fact |
| 18 | `law_of_court_first_seized_permits_consolidation` | outside fact |

Values by type:

- **crisp**: `true` or `false`.
- **judgement**: `true`, `false` or `unsure`.
- **outside fact**: `attested(true|false, attestation(BY, AT, REASON, EVIDENCE))`. EVIDENCE is `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)`.

The domain has no numeric keys and no dates.

## Citation-key atoms (canonical lexicon scheme; never shortened)

- `eu_reg_2016_679_art_80_1`
- `eu_reg_2016_679_art_80_2`
- `eu_reg_2016_679_art_81_1`
- `eu_reg_2016_679_art_81_2`
- `eu_reg_2016_679_art_81_3`

Cross-reference TARGET atoms, used only inside `cite(...)` of an absent referral:

| TARGET | Outside fact |
|---|---|
| `member_state_law_on_mandated_compensation_claims_statement` | `member_state_law_provides_for_mandated_compensation_claims` |
| `member_state_law_on_action_without_mandate_statement` | `member_state_law_provides_for_the_action_without_mandate` |
| `court_first_seized_jurisdiction_statement` | `court_first_seized_has_jurisdiction_over_the_actions` |
| `consolidation_under_law_of_court_first_seized_statement` | `law_of_court_first_seized_permits_consolidation` |

## Public predicates

### Contract queries

These names are fixed by THE CALLED CONTRACT and keep their contract spelling.

- `mandated_representation(Profile, Action, Result, Basis, Citations)`
  - Art 80(1) ladder.
  - BASIS is `[outside_fact(member_state_law_provides_for_mandated_compensation_claims, Attested)]` only when ACTION is compensation, that key is present and the result is final.
  - Cites `eu_reg_2016_679_art_80_1`.
- `representation_without_mandate(Profile, Action, Result, Basis, Citations)`
  - Art 80(2) ladder.
  - For compensation it gives `may_not_act_without_mandate` with BASIS `[]`.
  - Cites `eu_reg_2016_679_art_80_2`.
- `court_contact_duty(Profile, Result, Citations)`
  - Art 81(1).
  - Cites `eu_reg_2016_679_art_81_1`.
- `court_suspension_option(Profile, Result, Citations)`
  - Art 81(2).
  - Cites `eu_reg_2016_679_art_81_2`.
- `court_declining_jurisdiction_option(Profile, Result, Basis, Citations)`
  - Art 81(3).
  - BASIS holds the present attested `court_first_seized_has_jurisdiction_over_the_actions`, then `law_of_court_first_seized_permits_consolidation`, on a final result.
  - Cites `eu_reg_2016_679_art_81_3`.
- `gdpr_representation_and_suspension_input_problems(Profile, Problems)`
  - The typed input check. It never fails or raises and has one solution.
  - Cites none; it is structural.

### Scaffold facade (names kept)

REQUEST is one of:

- `request(mandated_representation, Profile, Action)`
- `request(representation_without_mandate, Profile, Action)`
- `request(court_contact_duty, Profile)`
- `request(court_suspension_option, Profile)`
- `request(court_declining_jurisdiction_option, Profile)`

Any other REQUEST gives `input_problems([wrong_type(request)])`, BASIS `[]` and CITATIONS `[]`.

The facade predicates:

- `decide_gdpr_representation_and_suspension(Request, Verdict)`
  - Verdict is `gdpr_representation_and_suspension_verdict(Result, Basis, Citations)`, delegated to the contract query named in REQUEST.
  - Court queries without a BASIS give BASIS `[]`.
  - Citation is the query's own article key (above).
- `gdpr_representation_and_suspension_status(Request, Result)`
  - The RESULT of the decide predicate, as it is, never wrapped.
  - Same citation as the query.
- `gdpr_representation_and_suspension_checklist(Request, Checklist)`
  - Query type #7 (justification).
  - A list of `item(RequirementIdentifier, Status, cite(CitationKey))` built with `formalize_lib:eval_requirements/4` over the query's requirement closure.
  - Status is one of:
    - `met`;
    - `unmet(Reason)`;
    - `unknown([Key])`, used for an absent key, an absent outside fact or an unsure judgement.
  - Every item, met included, carries `cite(...)`.
  - The checklist JUSTIFIES and never DECIDES: the RESULT always comes from the ladder.
  - On input problems the checklist is `[]`.
- `gdpr_representation_and_suspension_what_if(Request, Key, Value, Result)`
  - Replaces `attribute(Key, _)` in the request's profile with `formalize_lib:profile_set/3`, then returns the new status RESULT.
  - It must REPLACE, never append, so that it never manufactures a `duplicate_key`.
  - Same citation as the query.
- `gdpr_representation_and_suspension_fixture(Name, Request, ExpectedResult)`
  - Named worked cases in `fixtures.clausal`.
  - At least one per ladder step of every query, plus <<DNUM>> versus <<DNUM>> contrast pairs and input-problem cases.
  - Each fixture's ExpectedResult carries the query's article key.

## Planned reuse (manifest `uses:`)

**formalize_lib:**

- `profile_get/3`: the only profile reader; reads presence first, then value.
- `profile_set/3`: used by what-if.
- `eval_requirements/4` and `item/3`: build the checklist; no hand-rolled findall row helper (R1).
- `check_true/4`: crisp items.
- `check_tri/4`: judgement items (Kleene); no clone (C15).
- `memberd/2` and `not_member/2`: deterministic membership for ACTION atoms and key tables.
- `attribute/2`, `unmet/1`, `unknown/1`: constructors.

**validate_props** (tests only):

- `run_props/1`
- `prop_totality/3` and `prop_determinism/3`: one solution per query over generated profiles of every key state (absent / true / false / unsure / attested true / attested false / ill-typed).
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`

**Not used:**

- `assess/6` and `decide_labeled/3`: their `labels/3` would force a bare indeterminate atom.
- `compliance_lib`: the deontic answers here are explicit atoms, not a lattice verdict.
- `deadline_lib` and the datetime modules: no periods or dates.
- `country`: no Member State is identified.
- The money and currency modules.

**`_common` family backbone:** none required.

## kernel.clausal — shared floor

There is one determination slice, so NO domain predicate must be shared, and the kernel gains no Art 80 or Art 81 logic. It keeps the scaffold floor plus two domain-neutral shape tests:

- `proper_attribute_list(Term)`: a proper, fully bound list whose every element is `attribute(_, _)`. It is used by the input check before any key is read.
- `ground_attestation_arguments(Attestation)`: `attestation/4` whose four arguments neither are nor hold an unbound variable. Nothing else of them is read.

## parameters.clausal

No statutory figures. Arts 80 and 81 have no thresholds, periods or amounts, so no `constant_value/2` is declared. The file stays as the scaffold leaves it, with a comment stating this.

## Slice: gdpr_representation_and_suspension.clausal (self-contained)

### VALUE facts owned here (tables, not constants)

- `contract_key(Position, Key, Type)`
  - Eighteen rows: the key order with types `crisp`, `judgement` or `outside_fact`.
  - These rows drive both the input check and every first-in-order scan.
- `action_atom(Action)`: the four ACTION atoms.
- `outside_fact_entry(Key, Citation, Target)`: four rows, as in the cross-reference TARGET table, each with the query citation it belongs to:
  - `member_state_law_provides_for_mandated_compensation_claims`: `eu_reg_2016_679_art_80_1`, `member_state_law_on_mandated_compensation_claims_statement`.
  - `member_state_law_provides_for_the_action_without_mandate`: `eu_reg_2016_679_art_80_2`, `member_state_law_on_action_without_mandate_statement`.
  - `court_first_seized_has_jurisdiction_over_the_actions`: `eu_reg_2016_679_art_81_3`, `court_first_seized_jurisdiction_statement`.
  - `law_of_court_first_seized_permits_consolidation`: `eu_reg_2016_679_art_81_3`, `consolidation_under_law_of_court_first_seized_statement`.
- `judgement_referral(Query, Key, Citation)`: the referral rows.
  - The three body judgements cite `eu_reg_2016_679_art_80_1` in `mandated_representation` and `eu_reg_2016_679_art_80_2` in `representation_without_mandate`.
  - `other_proceedings_concern_same_subject_matter` cites `eu_reg_2016_679_art_81_1`, `_81_2` and `_81_3` in the three court queries.
- `query_reads(Query, Action, Keys)`: which query reads which key, in key order.
  - Mandated, other actions: the five body and mandate keys.
  - Mandated, compensation: those five plus key 6.
  - Without mandate, other actions: keys 1–4, 7 and 8.
  - Without mandate, compensation: `[]`.
  - Contact: keys 9, 10, 12, 13.
  - Suspension: keys 9, 11, 12, 13, 14.
  - Declining: keys 11–18.
- `wanted_value(Query, Key, Want)`: the value that satisfies the conjunct.
  - `true` for every key except `court_is_court_first_seized`, which wants `false`.
  - Outside facts want attested true.

### Shared ordered scans

These are local to the slice. Each is deterministic by disjoint recursive clauses over a key list.

- `first_failing_key(Profile, Keys, Key)`: the first present key whose value is the opposite of its wanted value. Attested false counts as failing for an outside fact. `unsure` never fails.
- `first_absent_key(Profile, Keys, Key)`: non-outside-fact keys only.
- `first_absent_outside_fact(Profile, Keys, Key)`.
- `first_unsure_judgement(Profile, Keys, Key)`.

Using the FIRST key makes the settled-negative step yield one solution even when several keys fail.

### Rules / requirements and ladders

Step 0 for every query is the input check (`input_problems`). For the two Art 80 queries, `wrong_type(action)` is appended after the profile problems.

**R80.1 `mandated_representation`** — Art 80(1).

1. A failing key among the five, or (compensation only) key 6 attested false: `may_not_act_on_mandate`.
2. Compensation and key 6 absent: absent referral on key 6 (before step 3).
3. The first absent of keys 1–5: `indeterminate([Key])`.
4. The first unsure of keys 2–4: `open_textured(Key, cite(eu_reg_2016_679_art_80_1))`. PAIRS are `[key2-V, key3-V, key4-V]`.
5. Otherwise: `may_act_on_mandate`.

BASIS on a final result: key 6 copied when ACTION is compensation and key 6 is present.

**R80.2 `representation_without_mandate`** — Art 80(2).

1. Compensation: `may_not_act_without_mandate`, BASIS `[]`.
2. A failing key among 1–4 and 8, or key 7 attested false: `may_not_act_without_mandate`.
3. The first absent of 1, 2, 3, 4, 8: `indeterminate`.
4. Key 7 absent: absent referral (<<DNUM>> (a)).
5. The first unsure of 2–4: `open_textured(..., cite(eu_reg_2016_679_art_80_2))`.
6. Otherwise: `may_act_without_mandate`.

BASIS: key 7 copied at steps 2 and 6 when present.

**R81.1 `court_contact_duty`**.

1. A failing key among 9, 10, 12, 13: `contact_duty_does_not_apply`.
2. The first absent: `indeterminate`.
3. Key 13 unsure: `open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_1))`. PAIRS are `[other_proceedings_concern_same_subject_matter-unsure]`.
4. Otherwise: `contact_duty_applies`.

**R81.2 `court_suspension_option`**.

1. Key 9, 11, 12 or 13 false, or key 14 true: `suspension_not_available`.
2. The first absent of 9, 11, 12, 13, 14: `indeterminate`.
3. Key 13 unsure: `open_textured(..., cite(eu_reg_2016_679_art_81_2))`.
4. Otherwise: `may_suspend_proceedings`.

**R81.3 `court_declining_jurisdiction_option`**. Competence is not read (Q3).

1. Key 11, 12, 13, 15 or 16 false, key 14 true, or key 17 or 18 attested false: `declining_jurisdiction_not_available`.
2. The first absent of 11, 12, 13, 14, 15, 16: `indeterminate`.
3. The first absent of 17, then 18: absent referral.
4. Key 13 unsure: `open_textured(..., cite(eu_reg_2016_679_art_81_3))`.
5. Otherwise: `may_decline_jurisdiction`.

BASIS on a final result: keys 17 and 18 that are present, in that order.

Shared outputs:

- Every non-final step gives BASIS `[]` and CITATIONS `[]`.
- Every final step gives `[cite(QueryCitation)]`.

### Input check

`gdpr_representation_and_suspension_input_problems/2` works in three stages:

1. If `proper_attribute_list` fails (unbound, partial, unbound element, non-attribute element): `[wrong_type(profile)]` alone.
2. Otherwise, per `contract_key` in order:
   - `duplicate_key(Key)` if the key occurs more than once; its values are not read;
   - else `wrong_type(Key)` if the value is unbound or outside its type.
3. Then `unknown_key(Key)` once per non-contract key (non-atom keys included, as given; an unbound key is reported as that same variable), in order of first occurrence.

The ACTION check (`memberd` over `action_atom`, unbound ACTION never enumerated) is added only by the two Art 80 queries.

### Requirement closures for the checklist

The requirement predicate is `representation_and_suspension_requirement(RequirementIdentifier, Profile, Status, Citation)`, with RequirementIdentifier first. Each identifier has three mutually exclusive clauses: met, unmet, unknown.

| Query | Identifiers (cited key) |
|---|---|
| `mandated_representation` | `mandate_body_not_for_profit`, `mandate_body_properly_constituted`, `mandate_body_public_interest_objectives`, `mandate_body_active_in_data_protection`, `mandate_given_by_data_subject` (all `_80_1`); for compensation also `mandate_compensation_provided_by_member_state_law` |
| `representation_without_mandate` | `without_mandate_body_not_for_profit`, `without_mandate_body_properly_constituted`, `without_mandate_body_public_interest_objectives`, `without_mandate_body_active_in_data_protection`, `without_mandate_provided_by_member_state_law`, `without_mandate_body_considers_rights_infringed` (all `_80_2`); for compensation only `without_mandate_action_covered`, which is unmet |
| `court_contact_duty` | `contact_court_competent`, `contact_information_on_other_proceedings`, `contact_same_controller_or_processor`, `contact_same_subject_matter` (`_81_1`) |
| `court_suspension_option` | `suspension_court_competent`, `suspension_other_proceedings_pending`, `suspension_same_controller_or_processor`, `suspension_same_subject_matter`, `suspension_court_not_first_seized` (`_81_2`) |
| `court_declining_jurisdiction_option` | `declining_other_proceedings_pending`, `declining_same_controller_or_processor`, `declining_same_subject_matter`, `declining_court_not_first_seized`, `declining_other_proceedings_at_first_instance`, `declining_party_application`, `declining_court_first_seized_has_jurisdiction`, `declining_consolidation_permitted` (`_81_3`) |

### Verdict atoms of this slice

All ten RESULT atoms and the status compounds listed above.

### Shared with another slice

Nothing. The only kernel use is the two shape tests named under kernel.clausal.

## Totality / determinism claims

- Each query and the input check yields exactly one solution for every term, unbound arguments included.
- A key a query does not read never changes its answer.
- Tests check these claims with `findall` plus `length(Solutions, 1)` and with `prop_totality/3` and `prop_determinism/3`.
- Every negative (`fail`) test is paired with a positive test on the same case.
