# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_articles_15_to_18_decision_and_exception

## Public query surface

The kept queries yield exactly one solution for every in-scope profile. In-scope means one of three cases:

- `request_type` is absent;
- `request_type` is one of access, rectification, erasure or restriction;
- the profile has an input problem.

These are the kept queries:

- `request_decision(Profile, Comply)`: the COMPLY field, decided by THE DECISION steps (0), (i), (ii), (iii), (iii-a), (iv) and (v). Cites Arts 12(2), 12(5), 12(6), 15(1), 16, 17(1), 17(3), 18(1) and 23(1).
- `request_exception(Profile, Exception)`: the first MET exception at step (iii), else `none`. It is `none` for every non-final COMPLY. Cites Arts 17(3), 12(5), 12(2) and 23(1).
- `gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems(Profile, Problems)`: the INPUT CHECK (G1). Gives `[]` when the profile is well formed.

The scaffold facade names are kept:

- `decide_request_exception(Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations))`: the full verdict.
  - For a non-final COMPLY, Citations is `[]`.
  - For `must_comply` or `need_not_comply`, Citations is the `cite(...)` of the BASIS provision and of the EXCEPTION provision, each where it is not `none`.
  - Reasoning-only provisions never appear in Citations.
- `request_exception_status(Profile, Status)`: the COMPLIANCE CHECK, query type #13. It answers whether the controller's proposed action "not acting on the request" is allowed in the current state. Status is the COMPLY field, read as:
  - `need_not_comply`: the action is allowed.
  - `must_comply`: the action is forbidden.
  - Any other value: not yet decided.
  - Cites as for `request_decision`.
- `request_exception_checklist(Profile, Checklist)`: the JUSTIFICATION, query type #7.
  - Checklist is a list of `item(RequirementId, Status, cite(CitationKey))`, with one item each for `engagement`, `identity_suspension` and every exception of the request type, in order.
  - Status is `met`, `unmet(Reason)` or `unknown(Keys)`.
  - Every item, met ones included, carries `cite(...)`.
- `gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if(Profile, Key, Value, Comply)`: the COMPLY field for the profile with Key set to Value. It uses `what_if/5` with the closure `request_decision`.
- Fixtures: `fixture(Name, Profile)` and `fixture_expected(Name, Comply, Exception)` in fixtures.clausal. There is at least one fixture per BASIS atom, per EXCEPTION atom, per non-final status and per input-problem kind.

The original's `decide_data_subject_request/2`, `response_deadline/3`, `request_response_deadline/2` and `request_outside_facts/2` are NOT exported.

## Verdict STATUS atoms

These replace the scaffold's `required`, `permitted` and `not_applicable`.

COMPLY is exactly one of:

- `must_comply`
- `need_not_comply`
- `indeterminate(MissingKeys)`, where MissingKeys is a non-empty list of bare key atoms. The bare atom `indeterminate` is never written.
- `needs_legal_review(Reason, Context)`, where Reason is one of:
  - `open_textured(Input, cite(CitationKey))`
  - `cross_reference_unresolved(cite(CitationKey), cite(TargetKey))`
- `suspended(art12_6_identity_not_confirmed)`
- `input_problems(Problems)`

Context is one of:

- `[inputs_relied_on(Pairs)]`
- `[resolution(cite(TargetKey), not_attempted), inputs_relied_on(Pairs)]`

Pairs may end with one `provenance(Clause, Citations)`.

BASIS is one of:

- `art15_1`
- `art16_inaccurate_data`, `art16_incomplete_data`
- `art17_1_a`, `art17_1_b`, `art17_1_c`, `art17_1_d`, `art17_1_e`, `art17_1_f`
- `art18_1_a`, `art18_1_b`, `art18_1_c`, `art18_1_d`
- `none`

EXCEPTION is one of:

- `art17_3_a`, `art17_3_b`, `art17_3_c`, `art17_3_d`, `art17_3_e`
- `art12_5_manifestly_unfounded_or_excessive`
- `art12_2_unable_to_identify`
- `art23_legislative_restriction`
- `none`

CONDITIONS is `[]` or `[reasonable_fee_may_be_charged]`.

Problem terms are `unknown_key(Key)`, `wrong_type(Key)`, `wrong_type(profile)` and `duplicate_key(Key)`.

The exported result constructors are:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`
- `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `suspended/1`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- `attested/2`, `attestation/4`, `url/2`, `document/2`

The atoms `art15_1`, `art17_3_a` and the like carry `% lint: allow C6 contract-atom`.

## Profile keys

There are fifty-four keys. The list below gives them in root_exports order. Profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3`, and no key is ever written as a string.

**Atom keys (2)**

1. `request_type`: one of `access`, `rectification`, `erasure`, `restriction`, `portability`, `objection`, `automated_decision`. Required.
2. `objection_ground_claimed`: one of `art21_1`, `art21_2`, `art21_6`. Type-checked only.

**Date key (1)**

3. `request_received_on`: a ground `date(Year, Month, Day)` of a real calendar day. Type-checked only.

**Crisp keys (25), each `true` or `false`**

4. `extension_claimed`
5. `controller_demonstrates_unable_to_identify_data_subject`
6. `identity_confirmed`
7. `personal_data_inaccurate`
8. `consent_is_the_basis_of_processing`
9. `consent_withdrawn`
10. `other_legal_ground_for_processing_exists`
11. `objection_under_art21_1_made`
12. `objection_under_art21_2_made`
13. `collected_in_relation_to_information_society_services_offer`
14. `accuracy_contested_by_data_subject`
15. `data_subject_opposes_erasure`
16. `data_required_by_data_subject_for_legal_claims`
17. `verification_of_overriding_grounds_pending`
18. `personal_data_provided_by_data_subject`
19. `processing_based_on_consent_or_contract`
20. `processing_carried_out_by_automated_means`
21. `processing_based_on_art6_1_e_or_f`
22. `processing_for_direct_marketing`
23. `processing_for_research_or_statistics_pursuant_to_art89_1`
24. `data_subject_gave_explicit_consent`
25. `decision_based_on_special_categories`
26. `special_category_condition_and_safeguards_met_for_decision`
27. `personal_data_disclosed_to_recipients`
28. `data_subject_asks_who_the_recipients_are`

**Judgement keys (21), each `true`, `false` or `unsure`**

29. `extension_necessary_for_complexity_and_number`
30. `reasonable_doubts_about_identity`
31. `request_manifestly_unfounded_or_excessive`
32. `personal_data_incomplete_in_light_of_purposes`
33. `data_no_longer_necessary_for_purposes`
34. `overriding_legitimate_grounds_exist`
35. `personal_data_unlawfully_processed`
36. `processing_necessary_for_freedom_of_expression_and_information`
37. `processing_necessary_for_public_task_or_official_authority`
38. `processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i`
39. `processing_for_archiving_research_or_statistics_in_accordance_with_art89_1`
40. `erasure_would_render_impossible_or_seriously_impair_processing_objectives`
41. `processing_necessary_for_legal_claims`
42. `controller_no_longer_needs_data_for_processing_purposes`
43. `transmission_would_adversely_affect_rights_and_freedoms_of_others`
44. `objection_grounds_relate_to_particular_situation`
45. `controller_demonstrates_compelling_legitimate_grounds`
46. `decision_based_solely_on_automated_processing`
47. `decision_produces_legal_or_similarly_significant_effects`
48. `decision_necessary_for_contract_with_data_subject`
49. `recipient_notification_impossible_or_disproportionate_effort`

**Outside facts (5)**

Each is `attested(Value, attestation(By, At, Reason, Evidence))`. Value is `true` or `false`, except for `public_holidays`, whose Value is a list of real-date `date(Y, M, D)` terms. Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`.

50. `erasure_required_by_union_or_member_state_law`: ENABLING, declared in `outside_facts:`.
51. `processing_required_by_union_or_member_state_law`: BLOCKING, declared.
52. `legislative_restriction_applies_to_the_right`: BLOCKING, declared.
53. `decision_authorised_by_union_or_member_state_law`: contract-only and type-checked.
54. `public_holidays`: contract-only and type-checked.

There are no numeric keys, so no unit suffixes are needed.

**Defeater keys** (absent means UNMET):

- keys 4, 5, 25, 28, 30 and 31;
- every Art 17(3) exception key, which are keys 36 to 41 and key 51;
- key 52.

Every other key that a limb reads is REQUIRED: absent means OPEN BY ABSENCE.

## Citation-key atoms

Cited in verdicts and checklist items:

- `eu_regulation_2016_679_article_12_paragraph_2`
- `eu_regulation_2016_679_article_12_paragraph_5`
- `eu_regulation_2016_679_article_12_paragraph_5_point_a`
- `eu_regulation_2016_679_article_12_paragraph_6`
- `eu_regulation_2016_679_article_15_paragraph_1`
- `eu_regulation_2016_679_article_16`
- `eu_regulation_2016_679_article_17_paragraph_1`, plus `eu_regulation_2016_679_article_17_paragraph_1_point_a` through `eu_regulation_2016_679_article_17_paragraph_1_point_f`
- `eu_regulation_2016_679_article_17_paragraph_3`, plus `eu_regulation_2016_679_article_17_paragraph_3_point_a` through `eu_regulation_2016_679_article_17_paragraph_3_point_e`
- `eu_regulation_2016_679_article_18_paragraph_1`, plus `eu_regulation_2016_679_article_18_paragraph_1_point_a` through `eu_regulation_2016_679_article_18_paragraph_1_point_d`
- `eu_regulation_2016_679_article_23_paragraph_1`

Targets of cross-references:

- `union_or_member_state_law_erasure_obligation`
- `union_or_member_state_law_processing_obligation`
- `union_or_member_state_law_restriction_measure`

The units of the source are listed in citations.clausal through `citation_unit(CitationKey, UnitId)`, for example `parag_017.003`.

## Planned reuse (manifest `uses:`)

**formalize_lib**

- `profile_get/3`, `profile_has/2` and `profile_lacks/2`, for every read.
- `profile_keys/2`, for the input check.
- `check_tri/4` and `check_tri_neg/4`, for leaf limbs.
- `and_status/2` and `or_status/2`, for leaf combination.
- `collect_unknown/2`.
- `not_defeated/3`, for defeaters under a guarded `once/1`.
- `first_applicable/2`, for first-met BASIS and EXCEPTION.
- `memberd/2` and `not_member/2`.
- `item/3`, `unmet/1`, `unknown/1` and `attribute/2`.
- `eval_requirements/4`, for the checklist, injecting the slice's `requirement/4` closure with RequirementId FIRST.

**kit.query_combinators**

- `what_if/5`, behind the `what_if/4` facade.

**validate_props**

These are used in tests:

- `run_props/1`
- `prop_totality/3` and `prop_determinism/3`, for the exactly-one-solution claim.
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`

**library(datetime)**

- `date_string_iso/2`, which is used ONLY to validate that `request_received_on` and `public_holidays` dates are real calendar days.
- No day arithmetic is used.

**Not used**

- `kit/compliance_lib`: its deny-overrides modality lattice has no five-way Kleene openness or first-met exception order. Query type #13 is served by `request_exception_status/2` over the local pipeline.
- `kit/deadline_lib`: THE PERIOD is out of scope.
- currency_vocab, vat_category and country: not relevant.

**Local, as a kit candidate**

The kind-carrying Kleene limb status `limb(met)`, `limb(unmet)`, `limb(open(AbsentKeys, UnsureKeys, OutsideKeys))` and its AND, OR and NOT. This is noted in the working notes (not published).

## Package layout (unchanged)

The layout is kernel, then citations, then parameters, then request_exception, then queries, then fixtures, then the package facade.

- **parameters.clausal** holds no statutory figures, because this order has no numeric value.
- **queries.clausal** exports the kept queries and the facade predicates.
- **The facade** re-exports the public surface and the result constructors.

## Slice: request_exception.clausal

### Value facts owned by this slice

These facts live here, and not in a shared constants file.

**`decided_request_type(Type)`**: `access`, `rectification`, `erasure`, `restriction`.

**`engagement_point(Type, Order, BasisAtom, PointCitationKey)`**, taking the first met point:

| Type | Order | BASIS | Citation |
|---|---|---|---|
| access | 1 | `art15_1` | article 15 paragraph 1 |
| rectification | 1 | `art16_inaccurate_data` | article 16 |
| rectification | 2 | `art16_incomplete_data` | article 16 |
| erasure | 1 to 6 | `art17_1_a` to `art17_1_f` | article 17 paragraph 1, points a to f |
| restriction | 1 to 4 | `art18_1_a` to `art18_1_d` | article 18 paragraph 1, points a to d |

**`exception_order(Type, Order, ExceptionAtom, CitationKey)`**:

- For erasure, `art17_3_a` to `art17_3_e` come first, at orders 1 to 5.
- Then come the three common exceptions for every type: `art12_5_manifestly_unfounded_or_excessive`, then `art12_2_unable_to_identify`, then `art23_legislative_restriction`.

**`exception_conditions(ExceptionAtom, Conditions)`**: `[reasonable_fee_may_be_charged]` for `art12_5`, and `[]` for every other exception.

**`referral(Type, JudgementKey, CitationKey)`**, the `referrals:` table:

| Type | Judgement key | Citation |
|---|---|---|
| rectification | `personal_data_incomplete_in_light_of_purposes` | article 16 |
| erasure | `data_no_longer_necessary_for_purposes` | 17(1)(a) |
| erasure | `overriding_legitimate_grounds_exist` | 17(1)(c) |
| erasure | `personal_data_unlawfully_processed` | 17(1)(d) |
| erasure | `processing_necessary_for_freedom_of_expression_and_information` | 17(3)(a) |
| erasure | `processing_necessary_for_public_task_or_official_authority` | 17(3)(b) |
| erasure | `processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i` | 17(3)(c) |
| erasure | `processing_for_archiving_research_or_statistics_in_accordance_with_art89_1` | 17(3)(d) |
| erasure | `erasure_would_render_impossible_or_seriously_impair_processing_objectives` | 17(3)(d) |
| erasure | `processing_necessary_for_legal_claims` | 17(3)(e) |
| restriction | `personal_data_unlawfully_processed` | 18(1)(b) |
| restriction | `controller_no_longer_needs_data_for_processing_purposes` | 18(1)(c) |
| all four types | `request_manifestly_unfounded_or_excessive` | 12(5) |
| all four types | `identity_doubts_reasonable` | 12(6) |

The row `identity_doubts_reasonable` serves the suspension SUSP, whose judgement key is `reasonable_doubts_about_identity`.

**`outside_fact_row(Key, Direction, CitationKey, TargetKey)`**, the `outside_facts:` table:

| Key | Direction | Citation | Target |
|---|---|---|---|
| `erasure_required_by_union_or_member_state_law` | enabling | 17(1)(e) | `union_or_member_state_law_erasure_obligation` |
| `processing_required_by_union_or_member_state_law` | blocking | 17(3)(b) | `union_or_member_state_law_processing_obligation` |
| `legislative_restriction_applies_to_the_right` | blocking | 23(1) | `union_or_member_state_law_restriction_measure` |

The slice has no numeric thresholds and no periods.

### Rules / requirements

**Leaf limbs**

Each leaf returns `limb(met)`, `limb(unmet)` or `limb(open(Absent, Unsure, Outside))`. The read depends on the kind of key:

- **Required crisp or judgement key**: true gives met, false gives unmet, absent gives `open([K], [], [])`, and unsure gives `open([], [K], [])`.
- **Defeater key**: present true gives met, absent or false gives unmet, and unsure gives `open([], [K], [])`.
- **NOT key**: swaps met and unmet, and keeps the openness of the key.
- **Outside fact**: attested true gives met and attested false gives unmet. If absent, an enabling fact gives `open([], [], [K])` and a blocking fact gives unmet.

**Combinators**

- `limb_and/2`: unmet dominates, then open, with the open parts merged.
- `limb_or/2`: met dominates, then open, with the open parts merged and the keys of decided siblings dropped.

**Engagement E by type**

- **access**: met, with no key read.
- **rectification**: inaccurate OR incomplete.
- **erasure**: A to F.
  - A = `data_no_longer_necessary_for_purposes`.
  - B = consent basis AND withdrawn AND NOT other ground.
  - C = (21(1) objection AND NOT overriding) OR 21(2) objection.
  - D = `personal_data_unlawfully_processed`.
  - E = the enabling outside fact.
  - F = `collected_in_relation_to_information_society_services_offer`.
- **restriction**: A to D.
  - A = `accuracy_contested_by_data_subject`.
  - B = `personal_data_unlawfully_processed` AND `data_subject_opposes_erasure`.
  - C = `controller_no_longer_needs_data_for_processing_purposes` AND `data_required_by_data_subject_for_legal_claims`.
  - D = `objection_under_art21_1_made` AND `verification_of_overriding_grounds_pending`.

**Exceptions Xi**

- **Erasure specific exceptions**:
  - `art17_3_a` = freedom of expression and information.
  - `art17_3_b` = the blocking outside fact OR the public task judgement.
  - `art17_3_c` = public health.
  - `art17_3_d` = archiving, research or statistics AND the impairment judgement.
  - `art17_3_e` = legal claims.
- **Common exceptions**:
  - `art12_5` = `request_manifestly_unfounded_or_excessive`.
  - `art12_2` = `controller_demonstrates_unable_to_identify_data_subject`.
  - `art23` = the blocking outside fact.
- Every exception key is a defeater, tested under a guarded `once/1` so that each test yields one solution.

**Suspension**

- SUSP = `reasonable_doubts_about_identity` (a defeater) AND NOT `identity_confirmed` (required).

**Decision clauses**

There is one clause per disjoint route. Each ground output is folded into the clause head. No `!`, `->` or `*->` is used.

| Step | Route | Result |
|---|---|---|
| (0) | input problems present | input problems |
| (i) | `request_type` absent | `indeterminate([request_type])` |
| (ii) | E unmet | `need_not_comply`, BASIS `none` |
| (iii) | first exception met | `need_not_comply` with that exception, and BASIS the first met point of E when E is met, else `none` |
| (iii-a) | SUSP met | `suspended(art12_6_identity_not_confirmed)` |
| (iv)-a | open limbs with absent required keys | `indeterminate(MissingKeys)`, merged in key order |
| (iv)-b | otherwise, enabling outside fact open | `needs_legal_review(cross_reference_unresolved(...))` |
| (iv)-c | otherwise | `needs_legal_review(open_textured(FirstUnsureKey, cite(ReferralCitation)), [inputs_relied_on(Pairs)])` |
| (v) | E met, SUSP unmet, all exceptions unmet | `must_comply` with the BASIS of E |

**Pairs**

`decision_pairs/3` builds Pairs as follows:

- `request_type-Type` comes first.
- Next come the present judgement keys read by every limb that is open as a whole, in key order, each with its value.
- Last comes `KEY-absent` for the absent enabling fact.

**Checklist**

`requirement(RequirementId, Profile, Status, Citation)` has its arguments in that order, with RequirementId first. It maps limb statuses to checklist statuses:

- `limb(met)` becomes `met`.
- `limb(unmet)` becomes `unmet(not_engaged)` for E, or `unmet(exception_not_met)` for an exception.
- An open limb becomes `unknown(Keys)`.

### Verdict atoms of this slice

All the COMPLY, BASIS, EXCEPTION and CONDITIONS atoms listed above.

### Predicates shared through kernel.clausal

These are the predicates needed by the queries, the fixtures and the facade beside this slice:

- `contract_key(Key, Kind, Order)`: Kind is `atom_enumeration(Values)`, `calendar_date`, `crisp`, `judgement`, `outside_fact_boolean` or `outside_fact_date_list`. These are the fifty-four rows in root_exports order.
- `key_order_sort/2`: sorts keys into contract order without duplicates.
- `profile_input_problems/2`, the input check. It is re-exported under the long prefixed name.
- `real_calendar_date/1`.
- `attestation_well_formed/1`.

Nothing else is shared. The Kleene limb combinators stay in the slice, because only this slice evaluates limbs.
