# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception

## 1. Public query surface

The package layout is kept unchanged: `kernel.clausal -> citations.clausal -> parameters.clausal -> request_exception.clausal -> queries.clausal -> fixtures.clausal -> package facade`. The facade re-exports the following predicates.

### 1.1 Scored queries of this order

Each of these yields EXACTLY ONE solution for every profile.

- `request_decision(Profile, Comply)`: the COMPLY field. Cites Art 12(2), (5), (6); Arts 20(1), (3), (4); 21(1), (2), (6); 22(1), (2), (4); 23(1).
- `request_exception(Profile, Exception)`: the EXCEPTION field. It is `none` for every non-final COMPLY and for every input problem. Same citations.
- `gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems)`: THE INPUT CHECK (G1, ruled 2026-11-01). Gives `[]` when well-formed, else `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms in contract order. Contract only; it cites nothing.

### 1.2 Scaffold facade names (kept)

- `decide_request_exception(Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations))`: the full verdict. Citations is always `[]` (citation discipline). Cites the whole in-scope table.
- `request_exception_status(Profile, Status)`: Status is the COMPLY term, identical to `request_decision/2`.
- `request_exception_checklist(Profile, Checklist)`: the justification view (query type #7). It is a list of `item(RequirementId, ItemStatus, cite(CitationAtom))` (formalize_lib `item/3`), one item per limb actually evaluated: engagement, suspension, each exception in test order. ItemStatus is `met`, `unmet(Reason)` or `unknown(Keys)`. Every item, met ones included, carries a cite.
- `gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, Key, Value, Comply)`: re-decide with one key overridden. Built on `what_if/5` with the closure `request_decision`. The overridden profile passes through the input check, so an override can surface `wrong_type(Key)`.
- `gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_compliance_check(Profile, ProposedAction, Verdict)`: query type #13, described in §1.3.
- `fixture(FixtureName, Profile)` and `fixture_expected(FixtureName, Comply, Exception)`: worked cases (§6).

### 1.3 The compliance check (query type #13)

ProposedAction is one of:

- `decline_to_act`
- `charge_reasonable_fee`
- `continue_processing` (objection)
- `apply_automated_decision` (Art 22)
- `withhold_portable_data` (Art 20)

Verdict is `permitted`, `forbidden` or `undetermined(Comply)`. Verdicts are derived from COMPLY and EXCEPTION:

- Under `need_not_comply`, every action is `permitted`, with one exception. `charge_reasonable_fee` is permitted ONLY when EXCEPTION is `art12_5_manifestly_unfounded_or_excessive`; otherwise it is `forbidden` (the Art 12(5) free-of-charge rule).
- Under `must_comply`, the actions are `forbidden`.
- Every non-final COMPLY gives `undetermined(Comply)`.

Cites Art 12(5) plus the provision of the deciding limb.

### 1.4 Result constructors

These are exported and never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `suspended/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

### 1.5 Not exported (SCOPE OF THIS ORDER)

- `decide_data_subject_request/2`, `response_deadline/3`, `request_response_deadline/2` and `request_outside_facts/2` are not exported.
- The decision those relations named is computed internally by `request_exception_verdict/2` in the slice.
- `cross_reference_unresolved/2` and `resolution/2` are never produced, because both outside facts read here are BLOCKING (D1).

### 1.6 Totality and determinism claims

- Every public relation is total over arbitrary terms. A non-list profile gives `input_problems([wrong_type(profile)])`.
- Every public relation is deterministic, with exactly one solution and no duplicates. This holds because of head-folded disjoint clauses, the guarded `once/1` first-MET defeater search, and the findall-then-compare in step (i).
- There is no `!`, `->` or `*->`.

## 2. Verdict STATUS atoms (replacing the placeholder `required/permitted/not_applicable`)

**COMPLY** is exactly one of:

- `must_comply`
- `need_not_comply`
- `indeterminate(MissingKeys)`: MissingKeys is a non-empty list of bare key atoms. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(InputKey, cite(CitationAtom)), [inputs_relied_on(Pairs)])`
- `suspended(art12_6_identity_not_confirmed)`
- `input_problems(Problems)`

**BASIS** is one of: `art20_1`, `art21_1`, `art21_2`, `art21_6`, `art22_1`, `none`.

**EXCEPTION** is one of:

- `art20_3_public_task`
- `art20_4_rights_of_others`
- `art21_1_compelling_legitimate_grounds`
- `art21_1_legal_claims`
- `art21_6_public_interest_task`
- `art22_2_a`
- `art22_2_b`
- `art22_2_c`
- `art12_5_manifestly_unfounded_or_excessive`
- `art12_2_unable_to_identify`
- `art23_legislative_restriction`
- `none`

**CONDITIONS** are:

- `[human_intervention, express_point_of_view, contest_decision]` for `art22_2_a` and `art22_2_c`;
- `[reasonable_fee_may_be_charged]` for `art12_5_manifestly_unfounded_or_excessive`;
- `[]` otherwise.

**Internal limb statuses** (kernel; never returned): `limb_met`, `limb_unmet`, `open_by_absence(Keys)`, `open_by_judgement(JudgementKeys)`.

## 3. Profile keys (fifty-four, exactly; contract = root_exports order)

The profile is `[attribute(Key, Value), ...]`. It is read only with `profile_get/3` and `profile_has/2`. Keys are atoms, never strings.

- **Read by this order:** the keys marked R.
- **Checked by the input check, never read:** the keys marked C.
- **Defeater keys (absent = UNMET):** the keys marked D.

### 3.1 Atom keys

1. `request_type` (R): access | rectification | erasure | restriction | portability | objection | automated_decision. REQUIRED.
2. `objection_ground_claimed` (R): art21_1 | art21_2 | art21_6. Read only for objection, where it is REQUIRED.

### 3.2 Date key

3. `request_received_on` (C): `date(Year, Month, Day)`, ground, a real calendar day.

### 3.3 Crisp flags (the atoms true | false)

4. `extension_claimed` (C, D)
5. `controller_demonstrates_unable_to_identify_data_subject` (R, D)
6. `identity_confirmed` (R; REQUIRED only when the doubts key is true or unsure)
7. `personal_data_inaccurate` (C)
8. `consent_is_the_basis_of_processing` (C)
9. `consent_withdrawn` (C)
10. `other_legal_ground_for_processing_exists` (C)
11. `objection_under_art21_1_made` (C)
12. `objection_under_art21_2_made` (C)
13. `collected_in_relation_to_information_society_services_offer` (C)
14. `accuracy_contested_by_data_subject` (C)
15. `data_subject_opposes_erasure` (C)
16. `data_required_by_data_subject_for_legal_claims` (C)
17. `verification_of_overriding_grounds_pending` (C)
18. `personal_data_provided_by_data_subject` (R)
19. `processing_based_on_consent_or_contract` (R)
20. `processing_carried_out_by_automated_means` (R)
21. `processing_based_on_art6_1_e_or_f` (R)
22. `processing_for_direct_marketing` (R)
23. `processing_for_research_or_statistics_pursuant_to_art89_1` (R)
24. `data_subject_gave_explicit_consent` (R, D)
25. `decision_based_on_special_categories` (R, D)
26. `special_category_condition_and_safeguards_met_for_decision` (R; REQUIRED only when key 25 is true)
27. `personal_data_disclosed_to_recipients` (C)
28. `data_subject_asks_who_the_recipients_are` (C, D)

### 3.4 Judgements (true | false | unsure)

29. `extension_necessary_for_complexity_and_number` (C)
30. `reasonable_doubts_about_identity` (R, D)
31. `request_manifestly_unfounded_or_excessive` (R, D)
32. `personal_data_incomplete_in_light_of_purposes` (C)
33. `data_no_longer_necessary_for_purposes` (C)
34. `overriding_legitimate_grounds_exist` (C)
35. `personal_data_unlawfully_processed` (C)
36. `processing_necessary_for_freedom_of_expression_and_information` (C)
37. `processing_necessary_for_public_task_or_official_authority` (R, D)
38. `processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i` (C)
39. `processing_for_archiving_research_or_statistics_in_accordance_with_art89_1` (C)
40. `erasure_would_render_impossible_or_seriously_impair_processing_objectives` (C)
41. `processing_necessary_for_legal_claims` (R, D)
42. `controller_no_longer_needs_data_for_processing_purposes` (C)
43. `transmission_would_adversely_affect_rights_and_freedoms_of_others` (R, D)
44. `objection_grounds_relate_to_particular_situation` (R)
45. `controller_demonstrates_compelling_legitimate_grounds` (R, D)
46. `decision_based_solely_on_automated_processing` (R)
47. `decision_produces_legal_or_similarly_significant_effects` (R)
48. `decision_necessary_for_contract_with_data_subject` (R, D)
49. `recipient_notification_impossible_or_disproportionate_effort` (C)

### 3.5 Outside facts

Each outside fact has the form `attested(Value, attestation(By, At, Reason, Evidence))`. Evidence is `url(Url, RetrievedAt)`, `document(UploadIdentifier, Sha256)` or `none`.

50. `erasure_required_by_union_or_member_state_law` (C)
51. `processing_required_by_union_or_member_state_law` (C)
52. `decision_authorised_by_union_or_member_state_law` (R, BLOCKING)
53. `legislative_restriction_applies_to_the_right` (R, BLOCKING)
54. `public_holidays` (C): `attested(ListOfDates, attestation(...))`.

No key carries money or another numeric quantity, so no unit-suffixed key is needed.

## 4. Citation-key atoms (`citations.clausal`)

The citation atoms are:

- `eu_regulation_2016_679_article_12_paragraph_2`
- `eu_regulation_2016_679_article_12_paragraph_5`
- `eu_regulation_2016_679_article_12_paragraph_6`
- `eu_regulation_2016_679_article_20_paragraph_1`
- `eu_regulation_2016_679_article_20_paragraph_3`
- `eu_regulation_2016_679_article_20_paragraph_4`
- `eu_regulation_2016_679_article_21_paragraph_1`
- `eu_regulation_2016_679_article_21_paragraph_2`
- `eu_regulation_2016_679_article_21_paragraph_3`
- `eu_regulation_2016_679_article_21_paragraph_6`
- `eu_regulation_2016_679_article_22_paragraph_1`
- `eu_regulation_2016_679_article_22_paragraph_2_point_a`
- `eu_regulation_2016_679_article_22_paragraph_2_point_b`
- `eu_regulation_2016_679_article_22_paragraph_2_point_c`
- `eu_regulation_2016_679_article_22_paragraph_3`
- `eu_regulation_2016_679_article_22_paragraph_4`
- `eu_regulation_2016_679_article_23_paragraph_1`

Each is declared as `citation(Atom, pinned_unit(UnitIdentifier), text_version('02016R0679-20160504'))`. Art 12(3) and 12(4) are pinned for context only: they get no atom, because nothing in this order cites them.

### 4.1 Referrals table: `referral(RowName, RequestType, Ground, InputKey, CitationAtom)`

Ground is `none` outside objection. Each row's minimum PAIRS is `request_type`, then `objection_ground_claimed` on the objection rows, then InputKey.

| RowName | RequestType | Ground | InputKey | CitationAtom |
|---|---|---|---|---|
| portability_public_task | portability | none | processing_necessary_for_public_task_or_official_authority | eu_regulation_2016_679_article_20_paragraph_3 |
| portability_rights_of_others | portability | none | transmission_would_adversely_affect_rights_and_freedoms_of_others | eu_regulation_2016_679_article_20_paragraph_4 |
| objection_particular_situation_article_21_1 | objection | art21_1 | objection_grounds_relate_to_particular_situation | eu_regulation_2016_679_article_21_paragraph_1 |
| objection_compelling_grounds | objection | art21_1 | controller_demonstrates_compelling_legitimate_grounds | eu_regulation_2016_679_article_21_paragraph_1 |
| objection_legal_claims | objection | art21_1 | processing_necessary_for_legal_claims | eu_regulation_2016_679_article_21_paragraph_1 |
| objection_particular_situation_article_21_6 | objection | art21_6 | objection_grounds_relate_to_particular_situation | eu_regulation_2016_679_article_21_paragraph_6 |
| objection_public_interest_task | objection | art21_6 | processing_necessary_for_public_task_or_official_authority | eu_regulation_2016_679_article_21_paragraph_6 |
| automated_decision_solely_automated | automated_decision | none | decision_based_solely_on_automated_processing | eu_regulation_2016_679_article_22_paragraph_1 |
| automated_decision_significant_effects | automated_decision | none | decision_produces_legal_or_similarly_significant_effects | eu_regulation_2016_679_article_22_paragraph_1 |
| automated_decision_contract_necessity | automated_decision | none | decision_necessary_for_contract_with_data_subject | eu_regulation_2016_679_article_22_paragraph_2_point_a |
| manifestly_unfounded_or_excessive | any | any | request_manifestly_unfounded_or_excessive | eu_regulation_2016_679_article_12_paragraph_5 |
| identity_doubts_reasonable | any | any | reasonable_doubts_about_identity | eu_regulation_2016_679_article_12_paragraph_6 |

### 4.2 Outside-facts table: `outside_fact_entry(Key, Direction, CitationAtom, TargetAtom)`

- `decision_authorised_by_union_or_member_state_law`, `blocking`, `eu_regulation_2016_679_article_22_paragraph_2_point_b`, `union_or_member_state_law_authorising_the_decision`
- `legislative_restriction_applies_to_the_right`, `blocking`, `eu_regulation_2016_679_article_23_paragraph_1`, `union_or_member_state_restricting_legislative_measure`

## 5. Shared kernel (`kernel.clausal`)

These are the only predicates shared across the slice, `queries.clausal`, `fixtures.clausal` and the facade.

- `contract_key(Key, KeyType)`: the 54 rows in root_exports order. KeyType is `atom_enum(Atoms)`, `calendar_date`, `crisp`, `judgement`, `outside_fact_boolean` or `outside_fact_dates`.
- `contract_input_problems(Profile, Problems)`: the input check. Duplicates and wrong types come first, in contract order (a duplicated key is never also type-checked); then `unknown_key/1` in first-occurrence order. A non-list profile gives `[wrong_type(profile)]`. It is re-exported under the prefixed name.
- `read_crisp(Profile, Key, LimbStatus)`, `read_judgement(Profile, Key, LimbStatus)`, `read_defeater(Profile, Key, LimbStatus)` and `read_blocking_outside_fact(Profile, Key, LimbStatus)`: three disjoint clauses each, with no cut.
- `limb_and(Statuses, LimbStatus)`, `limb_or(Statuses, LimbStatus)` and `limb_not(LimbStatus, Negated)`: strong Kleene, with absence before judgement.
- `order_keys_by_contract(Keys, OrderedUniqueKeys)`
- the result constructors of §1.4

## 6. Determination slice — `request_exception.clausal`

This slice is self-contained. It owns all value facts and rules for the decision of this order.

### 6.1 Statutory VALUE facts owned (tables, no numeric figures)

- `request_type_in_order(RequestType)`: portability, objection, automated_decision, in this trial order.
- `objection_ground(Ground)`: art21_1, art21_2, art21_6, in trial order.
- `engagement_basis(RequestType, Ground, Basis)` and `engagement_conjuncts(Basis, Keys)`:
  - `art20_1`: [personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means]
  - `art21_1`: [processing_based_on_art6_1_e_or_f, objection_grounds_relate_to_particular_situation]
  - `art21_2`: [processing_for_direct_marketing]
  - `art21_6`: [processing_for_research_or_statistics_pursuant_to_art89_1, objection_grounds_relate_to_particular_situation]
  - `art22_1`: [decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects]
- `specific_exceptions(Basis, ExceptionList)`, in test order:
  - `art20_1`: [art20_3_public_task, art20_4_rights_of_others]
  - `art21_1`: [art21_1_compelling_legitimate_grounds, art21_1_legal_claims]
  - `art21_2`: []
  - `art21_6`: [art21_6_public_interest_task]
  - `art22_1`: [art22_2_a, art22_2_b, art22_2_c]
- `common_exceptions([art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction])`.
- `exception_key(Exception, Key, Reader)`: the reader is `defeater`, `blocking_outside_fact` or `defeater_unless_barred`. The Art 22(2) limbs use the last reader.
- `exception_conditions(Exception, Conditions)`: the table in §2.
- `exception_citation(Exception, CitationAtom)`, `engagement_citation(Basis, CitationAtom)` and `suspension_citation(eu_regulation_2016_679_article_12_paragraph_6)`.
- The referrals table of §4.1 and the outside-facts table of §4.2.
- `parameters.clausal` declares no figures. The Art 12(3) one-month and two-month periods are out of scope and are NOT declared.

### 6.2 Rules and requirements

- **R0 input check first.** If `contract_input_problems` is non-empty, the result is `input_problems(P)`, `none`, `none`, `[]`, `[]`.
- **R1 request_type absent.** Run R2 to R6 for each type in `request_type_in_order` via `findall`. When all candidates agree on COMPLY (whole term) and EXCEPTION, return that answer with its CONDITIONS, the shared BASIS or `none`, and CITATIONS `[]`. Otherwise return `indeterminate([request_type])`.
- **R1b objection without objection_ground_claimed.** The same comparison runs over the three grounds. Disagreement gives `indeterminate([objection_ground_claimed])`.
- **R1c out of order.** A `request_type` that is valid but outside this order gives `indeterminate([request_type])` (D-SCOPE).
- **R2 engagement.** E = `limb_and` of `engagement_conjuncts`. If E is UNMET, the result is `need_not_comply`, `none`, `none`, `[]`.
- **R3 first MET exception.** The guarded `once/1` defeater searches `specific_exceptions ++ common_exceptions`. It is cut-free, and its guard is a ground exception list. The result is `need_not_comply`, with BASIS that of E when E is MET and `none` when E is open, the first MET exception, and its CONDITIONS.
  - BAR = `decision_based_on_special_categories` (defeater) AND NOT `special_category_condition_and_safeguards_met_for_decision`.
  - `art22_2_X` = own key AND NOT BAR.
- **R3a suspension.** SUSP = `reasonable_doubts_about_identity` (defeater) AND NOT `identity_confirmed`. If SUSP is MET, the result is `suspended(art12_6_identity_not_confirmed)`, `none`, `none`, `[]`.
- **R4 open limbs.** If E, SUSP or some exception is open:
  - when any open limb is OPEN BY ABSENCE, the result is `indeterminate(OrderedMissing)`;
  - otherwise it is `needs_legal_review(open_textured(FirstUnsure, cite(Citation)), [inputs_relied_on(Pairs)])`, with the citation taken from the referrals table and Pairs built by the PAIRS rule.
  - In both cases BASIS, EXCEPTION, CONDITIONS and CITATIONS are `none`, `none`, `[]`, `[]`.
- **R5 must_comply.** E MET, SUSP UNMET and every exception UNMET give `must_comply`, BASIS of E, `none`, `[]`. An absent Art 23 fact or Art 22(2)(b) fact is UNMET (A2).

### 6.3 Slice predicates

- **Exported to `queries.clausal`:**
  - `request_exception_verdict(Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations))`
  - `request_exception_items(Profile, Checklist)`
- **Internal:** `engagement_status/4`, `exception_status/3`, `suspension_status/2`, `first_met_exception/3`, `open_limb_outcome/4`, `candidate_answers/3`, `agree_or_name/4`.

### 6.4 Verdict atoms

As in §2.

### 6.5 Predicates shared with another slice

There is no other slice. Only the kernel predicates of §5 are consumed.

### 6.6 Per-rule tests (`tests/`)

One positive and one paired negative test per rule (R0–R5), per exception and per referral row. Additional tests cover:

- counting: `findall` + `length(_, 1)` on every public query;
- the step-(i) agreement and disagreement cases;
- an ignored key, present or absent, never changing the answer;
- the atom-shadowing guard: no bare `indeterminate`.

### 6.7 Fixtures (`fixture_expected/3` gives Comply and Exception)

| Fixture | Comply | Exception |
|---|---|---|
| `portability_engaged_must_comply` | must_comply | none |
| `portability_not_automated_not_engaged` | need_not_comply | none |
| `portability_public_task_relieves` | need_not_comply | art20_3_public_task |
| `portability_rights_of_others_relieves` | need_not_comply | art20_4_rights_of_others |
| `portability_rights_of_others_unsure_refers` | needs_legal_review(...) | none |
| `objection_direct_marketing_absolute` | must_comply | none |
| `objection_article_21_1_compelling_grounds` | need_not_comply | art21_1_compelling_legitimate_grounds |
| `objection_article_21_1_legal_claims` | need_not_comply | art21_1_legal_claims |
| `objection_article_21_6_public_interest_task` | need_not_comply | art21_6_public_interest_task |
| `objection_ground_absent_grounds_disagree` | indeterminate([objection_ground_claimed]) | none |
| `automated_decision_engaged_must_comply` | must_comply | none |
| `automated_decision_contract_with_safeguards` | need_not_comply | art22_2_a (CONDITIONS = Art 22(3) list) |
| `automated_decision_explicit_consent_barred_special_categories` | must_comply | none |
| `automated_decision_authorised_by_law_attested` | need_not_comply | art22_2_b |
| `automated_decision_special_category_safeguards_missing` | indeterminate([special_category_condition_and_safeguards_met_for_decision]) | none |
| `manifestly_excessive_fee_open` | need_not_comply | art12_5_manifestly_unfounded_or_excessive |
| `unable_to_identify_relieves` | need_not_comply | art12_2_unable_to_identify |
| `legislative_restriction_attested_true` | need_not_comply | art23_legislative_restriction |
| `legislative_restriction_absent_stands` | must_comply | none |
| `identity_doubts_suspend` | suspended(art12_6_identity_not_confirmed) | none |
| `request_type_absent_all_types_not_engaged` | need_not_comply | none |
| `request_type_absent_types_disagree` | indeterminate([request_type]) | none |
| `duplicate_and_unknown_keys` | input_problems([...]) | none |
| `crisp_flag_given_unsure_wrong_type` | input_problems([wrong_type(...)]) | none |

## 7. Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`, `profile_set/3`;
  - reads: `check_tri/4` and `check_tri_neg/4` for judgement reads (the absence/unsure split is layered in the kernel; no hand-rolled clone, C15);
  - combinators: `and_status/2`, `or_status/2`, `collect_unknown/2`, `memberd/2`, `not_member/2`;
  - checklist: `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `eval_requirements/4` (the checklist view, R1-lint safe), `not_defeated/3` (defeater guard).
- **kit/query_combinators:** `what_if/5` and `override_key/4`, for the what-if facade.
- **kit/compliance_lib:** `compliance_check/7`, `nm/2` and `resolve_modality/3`, for the #13 compliance check. It uses the closures `request_exception_norm_applies` and `request_exception_repair`, and the deny-overrides lattice.
- **validate_props** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- **library(datetime):** `date_string_iso/2` is not needed. The input check validates a `date(Year, Month, Day)` as a real calendar day via kit/deadline_lib `month_last_day/3`. This is the only date logic, and it is read by the input check alone.
- **Not used:** the deadline arithmetic (out of scope), rolling_window, currency_vocab, vat_category, country.
- **Local kit candidates** (noted in NOTES.md S2): the strong-Kleene absence/judgement limb evaluator and the attested outside-fact reader with ruling-A2 direction.
