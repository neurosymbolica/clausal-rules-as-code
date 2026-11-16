# SIGNATURE — eu/data_protection/gdpr_records_and_officer

## Public query surface

The package facade exposes:
- `decide_gdpr_records_and_officer(Profile, gdpr_records_and_officer_verdict(Status, Citations))`
- `gdpr_records_and_officer_status(Profile, Status)`
- `gdpr_records_and_officer_checklist(Profile, Checklist)`
- `gdpr_records_and_officer_what_if(Profile, Key, Value, Verdict)`
- the eligibility, compliance and fixture predicates below

The entry relations are re-exported unchanged: `record_obligation/2`, `record_missing_items/2`, `data_protection_officer_designation/2`, `officer_missing_tasks/2`, `data_protection_officer_outside_facts/2`, `officer_position_status/5` and `gdpr_records_and_officer_input_problems/2`.

The PROFILE is an attribute list `[attribute(Key, Value), ...]` of the 45 keys below. It is read only through `profile_get/3`.

Guarantees:
- **Totality.** Every query yields EXACTLY ONE solution for every profile, including malformed ones, which give `input_problems/1`.
- **Explicit exception.** `officer_position_status/5` has no solution for a DUTY outside its five atoms.
- **Determinism.** No answer is produced twice, because the scorer counts solutions.
- **Imported figures.** None; the one statutory figure, 250, is owned by the slice.

## Verdict STATUS atoms (replace the scaffold placeholders `required / permitted / not_applicable`)

Never `true`, `false`, `unknown`, and never a bare `indeterminate`.

- **Facade decision**, STATUS of `gdpr_records_and_officer_verdict/2`:
  - `obligations_owed`
  - `no_obligation_owed`
  - `missing_information`
  - `legal_review_required`
  - `invalid_profile`
- **Exemption eligibility (#2)**, STATUS of `gdpr_records_and_officer_exemption_verdict/2`: `eligible`, `ineligible`. Any other answer passes the status compound of `record_obligation/2` through unchanged: `indeterminate(Keys)`, `needs_legal_review(...)` or `input_problems(...)`.
- **Compliance check (#13)**, STATUS of `gdpr_records_and_officer_compliance_verdict/2`: `permitted`, `prohibited`. Any other answer passes the status compound through.
- **Entry 3 result atoms:** `met`, `not_met`.
- **Result constructors** (exported, never called as queries): `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `missing_record_item/3`, `missing_officer_task/2`, `keep_controller_record/1`, `keep_processor_record/1`, `no_record_required/1`, `designate_data_protection_officer/1`, `no_designation_required/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `not_governed_here/1`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`.
- **Item and duty atoms:**
  - Record items: `contact_details`, `purposes_of_the_processing`, `categories_of_data_subjects_and_personal_data`, `categories_of_recipients`, `third_country_transfers`, `article_49_safeguards_documentation`, `erasure_time_limits`, `security_measures_description`, `categories_of_processing`.
  - Roles: `controller`, `processor`.
  - Tasks: `informing_and_advising`, `monitoring_compliance`, `advising_on_impact_assessment`, `cooperating_with_supervisory_authority`, `acting_as_contact_point`.
  - Duties: `involvement`, `resources_and_access`, `no_instructions_or_penalty`, `direct_reporting`, `conflict_of_interests`.
  - Entry 3 TARGET atoms: `officer_involvement_statement`, `officer_resources_statement`, `officer_independence_statement`, `officer_reporting_line_statement`.
  - Other: `not_attempted`, `absent` (the `outside_facts` placeholder), `unsure` (judgement value).

## Profile keys (45, exactly)

The keys are listed in ROOT_EXPORTS ORDER, which is the standard order of atoms and is also the `input_contract` order. That order governs MISSING_KEYS, PAIRS, the first unsure KEY, and the order of input problems.

Types: C = crisp `true|false`; J = judgement `true|false|unsure`; O = outside fact `attested(true|false, attestation(By, At, Reason, Evidence))`, where Evidence is one of `none`, `url(Url, RetrievedAt)` or `document(UploadId, Sha256)`; I = non-negative integer.

1. `acts_as_controller` C
2. `acts_as_processor` C
3. `controller_erasure_time_limits_possible` J
4. `controller_record_has_article_49_safeguards_documentation` C
5. `controller_record_has_categories_of_data_subjects_and_personal_data` C
6. `controller_record_has_categories_of_recipients` C
7. `controller_record_has_contact_details` C
8. `controller_record_has_erasure_time_limits` C
9. `controller_record_has_purposes` C
10. `controller_record_has_security_measures_description` C
11. `controller_record_has_transfer_details` C
12. `controller_security_measures_description_possible` J
13. `controller_transfers_rely_on_article_49_1_second_subparagraph` C
14. `controller_transfers_to_third_countries` C
15. `is_public_authority_or_body` O
16. `monitoring_is_core_activity` J
17. `monitoring_is_large_scale` J
18. `officer_free_of_instructions_and_penalty` O
19. `officer_involved_properly_and_in_time` O
20. `officer_other_tasks_result_in_conflict_of_interests` J
21. `officer_reports_to_highest_management_level` O
22. `officer_supported_with_resources_and_access` O
23. `officer_tasks_include_acting_as_contact_point` C
24. `officer_tasks_include_advising_on_impact_assessment` C
25. `officer_tasks_include_cooperating_with_supervisory_authority` C
26. `officer_tasks_include_informing_and_advising` C
27. `officer_tasks_include_monitoring_compliance` C
28. `persons_employed` I (a head count, so no unit suffix; compared by value, never a float)
29. `processing_includes_criminal_offence_data` C
30. `processing_includes_special_categories` C
31. `processing_is_by_court_in_judicial_capacity` C
32. `processing_is_occasional` J
33. `processing_likely_to_result_in_risk` J
34. `processing_requires_regular_and_systematic_monitoring` J
35. `processor_record_has_article_49_safeguards_documentation` C
36. `processor_record_has_categories_of_processing` C
37. `processor_record_has_contact_details` C
38. `processor_record_has_security_measures_description` C
39. `processor_record_has_transfer_details` C
40. `processor_security_measures_description_possible` J
41. `processor_transfers_rely_on_article_49_1_second_subparagraph` C
42. `processor_transfers_to_third_countries` C
43. `special_category_processing_is_core_activity` J
44. `special_category_processing_is_large_scale` J
45. `union_or_member_state_law_requires_data_protection_officer` O

Totals: 27 C, 11 J, 6 O, 1 I. No dates and no money in this domain.

## Citation-key atoms (citations.clausal)

These atoms are fixed by the interface. If C6 flags the segments `reg` or `art`, add a `% lint:` pragma rather than renaming them.

- Cited in answers:
  - `eu_reg_2016_679_art_30_1`, `eu_reg_2016_679_art_30_1_a` to `eu_reg_2016_679_art_30_1_g`
  - `eu_reg_2016_679_art_30_2`, `eu_reg_2016_679_art_30_2_a` to `eu_reg_2016_679_art_30_2_d`
  - `eu_reg_2016_679_art_30_5`
  - `eu_reg_2016_679_art_37_1_a`, `eu_reg_2016_679_art_37_1_b`, `eu_reg_2016_679_art_37_1_c`
  - `eu_reg_2016_679_art_37_4`
  - `eu_reg_2016_679_art_38_1`, `eu_reg_2016_679_art_38_2`, `eu_reg_2016_679_art_38_3`, `eu_reg_2016_679_art_38_6`
  - `eu_reg_2016_679_art_39_1_a` to `eu_reg_2016_679_art_39_1_e`
- Each is declared as `gdpr_records_and_officer_citation(Key, regulation_2016_679, UnitId)` with the pinned unit id, for example `'02016R0679-20160504#point_030.001_f'`.
- Reasoning-only sources, declared with role `definition` and never emitted in a cite term: `eu_reg_2016_679_art_4_7`, `eu_reg_2016_679_art_4_8`, `eu_reg_2016_679_art_4_18`.
- A property test asserts that every cite in every answer is in the cited set and never in the definition set.

## Public predicates

**Entry relations (slice; re-exported by the facade)**

- `gdpr_records_and_officer_input_problems(Profile, Problems)`: `[]` or `[duplicate_key(K) | wrong_type(K) ...]` in contract order, then `unknown_key(K)` in first-occurrence order. A non-attribute-list profile gives `[wrong_type(profile)]`. Never fails, never raises. INPUT CONTRACT.
- `record_obligation(Profile, Obligation)`: one list, `[keep_controller_record(cite(eu_reg_2016_679_art_30_1)), keep_processor_record(cite(eu_reg_2016_679_art_30_2))]` (a non-empty subset, controller first), or `[no_record_required(cite(eu_reg_2016_679_art_30_5))]`, or a status compound. Art 30(1), (2), (5).
- `record_missing_items(Profile, Missing)`: one list of `missing_record_item(Role, Item, cite(Key))` in statute order, or `[]`, or a status compound. Art 30(1)(a)-(g), 30(2)(a)-(d).
- `data_protection_officer_designation(Profile, Obligation)`: `[designate_data_protection_officer(cite(...37_1_a|37_1_b|37_1_c|37_4))]`, or `[no_designation_required(cite(eu_reg_2016_679_art_37_4))]`, or a status compound. Art 37(1), (4).
- `officer_missing_tasks(Profile, Missing)`: `[]` or `missing_officer_task(Item, cite(...39_1_x))` in statute order (a)-(e), or a status compound. Art 39(1).
- `data_protection_officer_outside_facts(Profile, OutsideFacts)`: `[outside_fact(is_public_authority_or_body, A1), outside_fact(union_or_member_state_law_requires_data_protection_officer, A2)]`, each A the attested term or `absent`; or `input_problems/1`. Art 37(1)(a), 37(4).
- `officer_position_status(Profile, Duty, Result, Basis, Citations)`: one duty per question; reads exactly one key. Art 38(1), (2), (3), (6).

**Facade**

- `decide_gdpr_records_and_officer(Profile, Verdict)`: Verdict is `gdpr_records_and_officer_verdict(Status, Citations)`, the obligation surfacing (#14) over entries 1 and 2. Art 30(1), (2), (5), 37(1), (4).
- `gdpr_records_and_officer_status(Profile, Status)`: the Status of the decision alone. Same citations.
- `gdpr_records_and_officer_exemption_verdict(Profile, Verdict)`: eligibility (#2) for the Art 30(5) exemption. Verdict is `gdpr_records_and_officer_exemption(eligible, [cite(eu_reg_2016_679_art_30_5)])`, or `gdpr_records_and_officer_exemption(ineligible, Cites)` with Cites the keep_* cites, or the status compound of `record_obligation/2`. Art 30(5).
- `gdpr_records_and_officer_checklist(Profile, Checklist)`: the cited checklist of the eligibility question, `[item(RequirementId, Status, cite(eu_reg_2016_679_art_30_5)), ...]` built by `eval_requirements/4` over `requirement/4`. Requirement ids: `headcount_below_ceiling`, `processing_not_likely_to_result_in_risk`, `processing_occasional`, `no_special_categories`, `no_criminal_offence_data`. Status is `met`, `unmet(Reason)` or `unknown([Key])`; an unsure judgement renders as `unknown([Key])`. It is a VIEW: the authoritative answer is the exemption verdict. Art 30(5).
- `gdpr_records_and_officer_compliance_verdict(Profile, Action, Verdict)`: compliance check (#13). The verdict wrapper is `gdpr_records_and_officer_compliance(Status, Citations)`.
  - Action is one of `operate_without_controller_record`, `operate_without_processor_record`, `operate_without_data_protection_officer`.
  - An action is `prohibited` with the cite of the owed duty when entry 1 or 2 owes that duty.
  - It is `permitted` with `[cite(eu_reg_2016_679_art_30_5)]` or `[cite(eu_reg_2016_679_art_37_4)]` when the entry gives `no_record_required` or `no_designation_required`.
  - A record action whose role flag is false while the other role is true is `permitted` with Citations `[]`.
  - Otherwise the entry's status compound passes through.
  - Art 30, 37.
- `gdpr_records_and_officer_what_if(Profile, Key, Value, Verdict)`: the decision on Profile with Key REPLACED by Value. It replaces via `profile_set/3`, never appending a duplicate, which would become `duplicate_key`.
- Fixtures: `gdpr_records_and_officer_fixture(Name, Profile)` and `gdpr_records_and_officer_fixture_expected(Name, Query, Answer)`.

**Facade decision rule** (one clause per disjoint route; ground status in the head)

Let R be `record_obligation` and D be `data_protection_officer_designation`. The first route that applies decides:

1. R or D is `input_problems(_)`: `invalid_profile`, Citations `[]`.
2. R or D is `indeterminate(_)`: `missing_information`, `[]`.
3. R or D is `needs_legal_review(Reason, _)`: `legal_review_required`, Citations the cite terms inside the Reasons, R's first.
4. R holds a keep_* term or D holds `designate_data_protection_officer`: `obligations_owed`, Citations all cite terms of R then D.
5. Otherwise: `no_obligation_owed`, Citations `[cite(eu_reg_2016_679_art_30_5), cite(eu_reg_2016_679_art_37_4)]`.

## Module layout (unchanged names)

`kernel` -> `citations` -> `parameters` -> `gdpr_records_and_officer` -> `queries` -> `fixtures` -> package facade.

- `parameters.clausal` holds NO statutory figure. It keeps only the pinned consolidation id, `gdpr_records_and_officer_pinned_text('02016R0679-20160504')`.
- `queries.clausal` holds the facade wrappers: the decision, the status, the exemption verdict, the checklist, the compliance verdict and what_if.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3`: the only profile reader. Absence is tested as negation-as-failure of `profile_get/3`.
  - `profile_set/3`: for what_if.
  - `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`: the checklist.
  - `check_tri/4`, `check_tri_neg/4`: the judgement items of the checklist. Verify in P2 that an `unsure` value maps to `unknown`. If it does not, write a local three-clause check and record it in the working notes (not published).
  - `not_defeated/3`: defeasible record duty and limb (a).
  - `memberd/2`, `not_member/2`.
- **validate_props:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` (249 against 250), `prop_missing_key_coverage/3`.
- **kit/query_combinators:** import `what_if/5` only, with the Decide closure `decide_gdpr_records_and_officer`. Do NOT import `not_met/1`, which would shadow the result atom `not_met`. Fall back to `profile_set/3` plus decide if `what_if/5` assumes a dict.
- **kit/compliance_lib:** `compliance_check/7` and `nm/2` for the #13 wrapper.
  - Norms: `nm(record_of_processing_activities_duty, obligatory)` and `nm(data_protection_officer_duty, obligatory)`.
  - Applies closure: `gdpr_records_and_officer_norm_applies`. Its exact call arity must be checked against the kit source in P2.
  - Status compounds short-circuit BEFORE the engine is called, because the lattice has no fail-closed status.
- **Not used:** currency_vocab, vat_category, country, date_time, deadline_lib, rolling_window. No money, dates, plans or windows.

## kernel.clausal (shared floor; only what queries, fixtures and the slice all need)

- `gdpr_records_and_officer_contract_key(Key, Type)`: 45 facts in contract order; Type is `crisp`, `judgement`, `outside_fact` or `head_count`.
- `gdpr_records_and_officer_contract_keys(Keys)`: the ordered list, also used for `root_exports`.
- `gdpr_records_and_officer_input_problems/2`: the input check, rules below.
  - Test `var` and `nonvar` before any unification. A non-list, partial list or unbound element gives `[wrong_type(profile)]`.
  - A non-atom Key, including an unbound one, gives `unknown_key(Key)`, deduplicated with `==`.
  - An unbound Value gives `wrong_type`. `persons_employed` must satisfy `integer`, `>= 0`.
  - Outside-fact shape: `attested(V, attestation(_, _, _, _))` with V `true` or `false`; Evidence is not inspected.
  - Duplicates are counted with `==` and their values are never read.
- `gdpr_records_and_officer_key_state(Profile, Key, State)`: State is `absent` or `value(V)`. One clause each, mutually exclusive, read via `profile_get/3`.
- `gdpr_records_and_officer_outside_fact_state(Profile, Key, State)`: State is `absent`, `attested_true(Attested)` or `attested_false(Attested)`.
- `gdpr_records_and_officer_sorted_keys(Keys, Ordered)`: puts collected keys into contract order without duplicates.
- `gdpr_records_and_officer_pairs(Profile, ReadKeys, AbsentOutsideFacts, Pairs)`: builds `inputs_relied_on` pairs per the PAIRS rule (R14).

## Slice: gdpr_records_and_officer.clausal

### Value facts owned

- `:- constant_value(gdpr_records_and_officer_exemption_headcount_ceiling, 250).` (Art 30(5), 'fewer than 250'; strict `<`).
- Statute-order tables:
  - `controller_record_item(Order, Item, CitationKey)` for 30(1)(a)-(g); item (e) has two rows, `third_country_transfers` and `article_49_safeguards_documentation`.
  - `processor_record_item(...)` for 30(2)(a)-(d).
  - `officer_task(Order, Item, FlagKey, CitationKey)` for 39(1)(a)-(e).
  - `officer_duty(Duty, Key, CitationKey, TargetOrNone)` for the five Art 38 duties.

### Rules and requirements

**Precedence.** Every relation first calls the input check; non-empty problems give `input_problems(Problems)` (for (G): RESULT `input_problems(Problems)`, BASIS `[]`, CITATIONS `[]`).

**(A) record_obligation/2**

1. Absent role keys: `indeterminate(AbsentRoleKeys)`.
2. Both roles false: `needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_30_1), cite(eu_reg_2016_679_art_30_2)]), [inputs_relied_on([acts_as_controller-false, acts_as_processor-false])])`.
3. Exemption defeater `exemption_defeated(Profile)`. It is guarded by `once/1` over the four trigger clauses (risk true; occasional false; special true; criminal true), so several true triggers yield one solution.
4. If no trigger is true and `persons_employed` is absent, or is below 250 with some trigger absent: `indeterminate(Keys)`. Keys are `persons_employed` (if absent) plus the absent triggers, the triggers omitted when the count is at least 250.
5. Count at least 250 or a trigger true: the owed records.
6. All four non-triggering: `no_record_required`.
7. Else: `needs_legal_review(open_textured(K, cite(eu_reg_2016_679_art_30_5)), [inputs_relied_on(Pairs)])`, K the first unsure of (`processing_is_occasional`, `processing_likely_to_result_in_risk`). Pairs: `persons_employed` if present, then each present trigger judgement.

The duty itself is `record_duty_holds(Profile) :- not_defeated(article_30_5_exemption, Profile, exemption_applies)`, a defeasible rule with the exemption as defeater.

**(B) record_missing_items/2**

1. If (A) is `indeterminate` or `not_governed_here`: that status.
2. If (A) is `no_record_required`: `[]`.
3. If (A) is the open_textured trigger referral: collect the absent keys of the records owed by role (as if owed, same read order). Any absent: `indeterminate(Keys)`. Else: (A)'s referral unchanged.
4. Otherwise, per owed record, walk the items.
   - Plain items read their flag; false is missing, absent is named.
   - Item (e): transfers flag absent is named; false is not required. True reads the details flag and the Art 49 reliance flag; reliance true reads the safeguards flag.
   - Where-possible items follow R6 steps (i)-(iv), as in INTERFACE (B).
5. Collect absent keys across all owed records. If any: `indeterminate`.
6. Else, if any possibility judgement read is unsure: `needs_legal_review(open_textured(K, cite(...30_1_f|30_1_g|30_2_d)), [inputs_relied_on(Pairs)])`, K the first unsure in contract order. Pairs: persons, triggers when the count is below 250 or absent, and the possibility judgements read.
7. Else: the list of missing items.

**(C) data_protection_officer_designation/2**

Limb evaluators return `met`, `unmet`, `open_absence(Keys)`, `open_cross_reference` or `open_judgement(UnsureKeys, Pairs)`, one clause per route.

- **Limb (a):**
  - court true: unmet.
  - outside fact attested false: unmet.
  - attested true and court false: met.
  - court absent (and not unmet): `open_absence([processing_is_by_court_in_judicial_capacity])`.
  - outside fact absent and court false: `open_cross_reference`.
  - Limb (a) carries the court exception as a defeater via `not_defeated/3`.
- **Limb (b):** three judgements in strong Kleene AND; any false: unmet.
- **Limb (c):** (special OR criminal; either true settles, both false is unmet, absent ones are named only if the OR is unsettled) AND core AND large-scale.
- **Decision steps (i)-(vi)** per R9. The MET witness is guarded with `once/1` in limb order, so only the first MET limb is answered.
  - (iv) `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_37_1_a), cite(eu_reg_2016_679_art_37_1_a)), [resolution(cite(eu_reg_2016_679_art_37_1_a), not_attempted), inputs_relied_on(Pairs)])`.
  - (v) `open_textured(K, cite(...37_1_b|37_1_c))`.
  - (vi) absent Art 37(4) fact: `cross_reference_unresolved(cite(eu_reg_2016_679_art_37_4), cite(eu_reg_2016_679_art_37_4))` with `inputs_relied_on([union_or_member_state_law_requires_data_protection_officer-absent])`.

**(D) officer_missing_tasks/2**

- Absent task flags: `indeterminate` in contract order.
- Else: the false flags as `missing_officer_task` terms in statute order.

**(E) data_protection_officer_outside_facts/2**

- The two Art 37 facts as given, or `absent`.

**(G) officer_position_status/5**

- `officer_duty/4` lookup; an unknown Duty fails.
- Outside-fact duties: absent gives `needs_legal_review(cross_reference_unresolved(cite(C), cite(T)), [resolution(cite(T), not_attempted), inputs_relied_on([K-absent])])`. Attested true gives `met`, `[outside_fact(K, A)]`, `[cite(C)]`. Attested false gives `not_met`, same.
- `conflict_of_interests`:
  - absent: `indeterminate([K])`.
  - unsure: `needs_legal_review(open_textured(K, cite(eu_reg_2016_679_art_38_6)), [inputs_relied_on([K-unsure])])`.
  - false: `met`.
  - true: `not_met`.
  - BASIS is `[]` in every case; CITATIONS are `[cite(eu_reg_2016_679_art_38_6)]` when decided.

### Verdict atoms

The entry result constructors above, plus `met` and `not_met`. The facade STATUS atoms live in queries.clausal, not in the slice.

### Shared with another module (belongs in kernel.clausal)

Only the contract-key table, the input check, the key and outside-fact state readers, key ordering and the PAIRS builder. Everything else is slice-local.

## Tests (seven modes, per rule in tests/)

1. **Unit per route:** every clause of (A)-(G).
2. **Boundary:** `persons_employed` at 249 and 250; 0; -1 and 249.0 give `wrong_type`.
3. **Missing-key:** each named key and each not-yet-needed key (Q25).
4. **Referral:** each open_textured and cross_reference_unresolved row, with exact PAIRS.
5. **Input-contract:** duplicates, unknown keys, non-atom keys, unbound profile/element/value, `"true"` strings, unsure on a crisp key.
6. **Counting:** `findall` length 1 for every query and fixture, including several true triggers and several MET limbs.
7. **Irrelevance:** toggling a key an entry does not read leaves its answer unchanged, and an unknown Duty fails, paired with a positive test.

Property runs via validate_props cover totality, determinism and citation completeness.

Fixtures:
- `small_controller_occasional_low_risk_exempt` (249)
- `controller_at_ceiling_owes_record` (250)
- `small_processor_special_categories_owes_record`
- `both_roles_record_items_missing`
- `neither_role_referred`
- `unsure_occasional_referred`
- `public_authority_designates`
- `court_in_judicial_capacity_no_designation`
- `member_state_law_requires_officer`
- `large_scale_monitoring_unsure_referred`
- `officer_mandate_lacks_contact_point`
- `officer_reporting_attested_false`
- `conflict_of_interests_absent`
