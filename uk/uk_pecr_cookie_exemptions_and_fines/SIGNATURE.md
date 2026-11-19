# SIGNATURE — uk/uk_pecr_cookie_exemptions_and_fines

The drafter's reading, not a lawyer's. Shape family: deontic. Predicate prefix: `uk_pecr_cookie_exemptions_and_fines_`.

## Public query surface (summary)

The contract queries (A) to (G) of THE CALLED CONTRACT are the primary surface. The scaffold facade wraps the UK cookie determination as the domain's ELIGIBILITY verdict (query type #2):

`decide_uk_pecr_cookie_exemptions_and_fines(PROFILE, uk_pecr_cookie_exemptions_and_fines_verdict(STATUS, CITATIONS))`

`uk_pecr_cookie_exemptions_and_fines_status(PROFILE, STATUS)`

The other required query types are served as follows:
- COMPARISON (#5): `compare_uk_eu_terminal_equipment_storage_or_access/5`.
- OBLIGATION SURFACING (#14): `uk_pecr_cookie_exemptions_and_fines_obligations/2`.

The guarantees are:
- **Totality:** every query yields exactly ONE solution for every PROFILE term. The input check never fails or raises.
- **Determinism:** no answer is yielded twice. One clause per disjoint route, with ground outputs in the head (C17). No cut, `->` or `*->`.
- **Imports:** all statutory figures are declared once in the slice file with `:- constant_value/2`. Nothing is imported from another domain. The EU limb's readings are restated, not imported.

## Verdict STATUS atoms (replacing the placeholder { required, permitted, not_applicable })

These are the final atoms:
- cookies (UK and EU): `permitted`, `not_permitted`, `not_applicable`;
- comparison: `same`, `differs`;
- breach time: `notification_in_time`, `notification_late_with_reasons`, `notification_out_of_time`, `notification_reasons_for_delay_missing`, `not_applicable`;
- tier: `higher_maximum_amount`, `standard_maximum_amount`;
- amount: a bare non-negative integer (pence).

Not-final answers are status compounds placed ITSELF in the answer position:
- `indeterminate([KEY])`;
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`;
- `needs_legal_review(cross_reference_unresolved(cite(CITE), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)])`;
- `input_problems(PROBLEMS)`.

The bare atom `indeterminate` is never written. `true` and `false` are never placed in verdict_vocabulary or root_exports.

The result constructors are exported and never called as queries: indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1.

The checklist item statuses come from formalize_lib vocabulary: `met`, `unmet(Reason)`, `unknown([Key])`.

## Profile keys (33, in root_exports / input_contract order)

Types:
- **J** = judgement (`true` | `false` | `unsure`);
- **C** = crisp (`true` | `false`);
- **I** = non-negative integer;
- **E** = enumeration.

The profile carries no date terms: both commencement tests are crisp keys (contract). Integer keys carry their unit in the name.

| # | key | type | provision |
|---|-----|------|-----------|
| 1 | storage_or_access_within_regulation_6 | J | reg 6(1), 6(2) |
| 2 | clear_and_comprehensive_information_about_the_purpose_provided | J | Sch A1 paras 2(1)(a), 5(1)(d), 6(1)(c) |
| 3 | consent_to_the_storage_or_access_given | J | Sch A1 para 2(1)(b), 2(3) |
| 4 | technical_storage_or_access_solely_for_transmission_of_a_communication | J | Sch A1 para 3 |
| 5 | information_society_service_requested_by_the_subscriber_or_user | J | Sch A1 para 4(1) |
| 6 | storage_or_access_strictly_necessary_for_the_requested_service | J | Sch A1 para 4(1), 4(2) |
| 7 | person_provides_an_information_society_service | J | Sch A1 para 5(1)(a) |
| 8 | sole_purpose_is_statistical_information_to_improve_the_service_or_website | J | Sch A1 para 5(1)(b) |
| 9 | collected_information_shared_only_to_assist_with_improvements | J | Sch A1 para 5(1)(c) |
| 10 | access_does_not_collect_or_monitor_automatically_emitted_information | J | Sch A1 para 5(2) |
| 11 | simple_free_means_of_objecting_given | J | Sch A1 paras 5(1)(e), 6(1)(d) |
| 12 | subscriber_or_user_has_not_objected | C | Sch A1 paras 5(1)(e), 6(1)(d) |
| 13 | person_provides_an_information_society_service_by_means_of_a_website | J | Sch A1 para 6(1)(a), 1(1) |
| 14 | sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality | J | Sch A1 para 6(1)(b) |
| 15 | communication_received_requests_or_indicates_need_of_emergency_assistance | J | Sch A1 para 7(a), (b) |
| 16 | sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance | J | Sch A1 para 7(c) |
| 17 | storage_or_access_in_terminal_equipment | J | Dir Art 5(3) s1 |
| 18 | storage_or_access_solely_for_transmission | J | Dir Art 5(3) s2 |
| 19 | service_explicitly_requested_by_user | J | Dir Art 5(3) s2 |
| 20 | strictly_necessary_to_provide_requested_service | J | Dir Art 5(3) s2 |
| 21 | user_consent_given | J | Dir Art 5(3) s1, Art 2(f) |
| 22 | clear_and_comprehensive_information_provided | J | Dir Art 5(3) s1 |
| 23 | provider_of_a_public_electronic_communications_service | J | reg 5A(1), 5(1) |
| 24 | personal_data_breach_occurred | J | reg 5A(2) |
| 25 | became_aware_on_or_after_20_august_2025 | C | S.I. 2025/904 reg 2(p) |
| 26 | notification_made_without_undue_delay | J | reg 5A(2) |
| 27 | hours_elapsed_at_notification | I (hours) | reg 5A(2), (3A); Reg 611/2013 Art 2(2); Reg 1182/71 Art 3 |
| 28 | notification_within_72_hours_was_feasible | J | reg 5A(2) |
| 29 | notification_accompanied_by_reasons_for_the_delay | C | reg 5A(3A) |
| 30 | act_or_omission_on_or_after_5_february_2026 | C | S.I. 2026/82 reg 11 |
| 31 | provision_infringed | E | Sch 1 para 18; DPA s.157(2), (4) |
| 32 | penalised_person_is_an_undertaking | J | DPA s.157(5)(a), (6)(a) |
| 33 | total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds | I (whole GBP) | DPA s.157(5)(a), (6)(a) |

`provision_infringed` atoms (17):
- the 14 listed regulations, which give the higher maximum: regulation_5, regulation_6, regulation_7, regulation_8, regulation_14, regulation_19, regulation_20, regulation_21, regulation_21a, regulation_21b, regulation_22, regulation_23, regulation_24, regulation_32b_4_or_5;
- commission_notice_not_complied_with (higher);
- section_142_8b_of_the_data_protection_act_2018 (higher);
- other_provision_of_the_pec_regulations (standard).

## Citation-key atoms (canonical lexicon scheme; citation_vocabulary)

The atoms are spelled exactly as the order states them. No shortened atom is ever invented.

- **UK cookies:**
  - `uk_si_2003_2426_reg_6_1`, `uk_si_2003_2426_reg_6_2`;
  - `uk_si_2003_2426_sch_a1_para_2_1`, `uk_si_2003_2426_sch_a1_para_3`, `uk_si_2003_2426_sch_a1_para_4_1`;
  - `uk_si_2003_2426_sch_a1_para_5_1`, `uk_si_2003_2426_sch_a1_para_6_1`, `uk_si_2003_2426_sch_a1_para_7`.
- **EU cookies:** `eu_dir_2002_58_art_5_3`, `eu_dir_2002_58_art_5_3_s1`, `eu_dir_2002_58_art_5_3_s2`, `eu_dir_2002_58_art_2_f`.
- **Breach:**
  - `uk_si_2003_2426_reg_5_1`, `uk_si_2003_2426_reg_5a_1`, `uk_si_2003_2426_reg_5a_2`, `uk_si_2003_2426_reg_5a_3a`;
  - `uk_reg_611_2013_art_2_2`, `uk_reg_1182_1971_art_3_1`, `uk_si_2025_904_reg_2_p`.
- **Fines:**
  - `uk_si_2026_82_reg_11_1`, `uk_si_2026_82_reg_11_2`;
  - `uk_si_2003_2426_sch_1_para_18_b_ii`, `uk_si_2003_2426_sch_1_para_18_d`;
  - `uk_dpa_2018_s_157_2`, `uk_dpa_2018_s_157_4`, `uk_dpa_2018_s_157_5`, `uk_dpa_2018_s_157_6`.
- **OUTSIDE-FACT TARGET names** (not citation keys; they appear only inside the two cross_reference_unresolved statuses):
  - `uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025`;
  - `uk_si_2003_2426_as_in_effect_before_5_february_2026`.

## Public predicates (one line each)

**Contract queries (A) to (G):**
- `uk_terminal_equipment_storage_or_access(Profile, Result, Citations)`: UK cookie answer under reg 6 and Sch A1, through ladder U1 to U3. Cites `uk_si_2003_2426_reg_6_1` with the six Sch A1 paragraphs, or `reg_6_2` for not_applicable.
- `eu_terminal_equipment_storage_or_access(Profile, Result, Citations)`: EU own-limb answer, through ladder EU1 to EU3. Cites `eu_dir_2002_58_art_5_3`.
- `compare_uk_eu_terminal_equipment_storage_or_access(Profile, UkResult, EuResult, Difference, ChangedBy)`: side-by-side answers and DIFFERENCE under the status rule (CMP1 to CMP3). CHANGED_BY holds the UK CITATIONS only when the answer differs and UK is final. Cites the UK side's keys.
- `uk_breach_notification_timing(Profile, Result, Citations)`: reg 5A(2)/(3A) timing, through ladder B-1 to B-5. Cites `uk_si_2003_2426_reg_5a_2`, `uk_reg_611_2013_art_2_2` and `uk_reg_1182_1971_art_3_1`, plus `reg_5a_3a` on the late branches, or `reg_5_1`/`reg_5a_1`/`reg_5a_2` for not_applicable.
- `uk_penalty_maximum_tier(Profile, Result, Citations)`: higher or standard maximum, through T-1 to T-3. Cites Sch 1 para 18(b)(ii)/(d), DPA s.157(2)/(4) and S.I. 2026/82 reg 11(2).
- `uk_penalty_maximum_amount_in_pence(Profile, Result, Citations)`: maximum in integer pence, through M-1 to M-9. Cites the T-3 citations plus `uk_dpa_2018_s_157_5` or `uk_dpa_2018_s_157_6`.
- `uk_pecr_cookie_exemptions_and_fines_input_problems(Profile, Problems)`: THE INPUT CHECK, returning the BARE problem list (duplicate_key/wrong_type in contract order, then unknown_key in first-occurrence order, or [wrong_type(profile)]). Cites none.

**Scaffold facade:**
- `decide_uk_pecr_cookie_exemptions_and_fines(Profile, Verdict)`: ELIGIBILITY verdict. Verdict = `uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)`, where Status and Citations are exactly the RESULT and CITATIONS of `uk_terminal_equipment_storage_or_access/3`. Cites as (A).
- `uk_pecr_cookie_exemptions_and_fines_status(Profile, Status)`: the Status of the verdict above (one solution). Cites as (A).
- `uk_pecr_cookie_exemptions_and_fines_checklist(Profile, Checklist)`: a cited checklist, as a flat list of formalize_lib `item(WayId, ItemStatus, cite(Key))`, one per scope test and per way. The ids are `regulation_6_scope`, `way_a_consent`, `way_b_transmission`, `way_c_strictly_necessary`, `way_d_statistical_purposes`, `way_e_website_appearance_or_functionality` and `way_f_emergency_assistance`. ItemStatus is `met`, `unmet(KeysFalse)` or `unknown(KeysAbsentOrUnsure)`. With input problems the checklist is `[]`. Cites reg 6(1) and Sch A1 paragraphs 2 to 7.
- `uk_pecr_cookie_exemptions_and_fines_what_if(Profile, Key, Value, Status)`: re-decides the cookie verdict with Key set to Value. Uses profile_set/3 to replace Key; an absent Key is added. Cites as (A).
- `uk_pecr_cookie_exemptions_and_fines_obligations(Profile, Obligations)`: OBLIGATION SURFACING (#14), returning one flat list of `obligation(Duty, cite(Key))`, in this order:
  - `obligation(do_not_store_or_access_information_in_terminal_equipment, cite(uk_si_2003_2426_reg_6_1))` when the UK cookie answer is not_permitted;
  - `obligation(notify_personal_data_breach_to_the_information_commission_without_undue_delay_and_where_feasible_within_72_hours, cite(uk_si_2003_2426_reg_5a_2))` when the provider and breach judgements are both true and the awareness key is true;
  - `obligation(accompany_notification_with_reasons_for_the_delay, cite(uk_si_2003_2426_reg_5a_3a))` when `hours_elapsed_at_notification >= 73`;
  - `[]` with input problems or when nothing is owed on the facts.
- `uk_pecr_cookie_exemptions_and_fines_fixture(Name, Profile)`: named fixture profiles (see fixtures). Cites none.

## Package layout (unchanged): kernel -> citations -> parameters -> slice -> queries -> fixtures -> facade

- **kernel.clausal** holds the shared floor only:
  - the typed key table `contract_key(Key, Type)` in input_contract order;
  - the enumeration atom table;
  - the input check;
  - the PAIRS builder `inputs_relied_on_pairs(Profile, OwnKeys, Pairs)`;
  - the key-state reader `key_state(Profile, Key, State)`, where State is `given(Value)`, `given_unsure` or `absent`;
  - the generic STATUS-RULE engine (below).
- **citations.clausal** holds the `citation(Key, Unit, Text)` rows for the 26 atoms above, plus the two target-name rows marked `outside_fact`.
- **parameters.clausal** keeps the scaffold module. It re-exports nothing figure-bearing. The value facts live in the slice (rule: VALUE facts are owned by the slice).
- **queries.clausal** binds the contract predicate names to the slice predicates.
- **fixtures.clausal** holds named profiles.
- **The package facade** exports the 7 contract queries, the 5 facade predicates, the fixture predicate and the constructors.

### Shared predicates (kernel.clausal; the only cross-slice sharing)
- `uk_pecr_cookie_exemptions_and_fines_input_problems/2`: THE INPUT CHECK. Uses profile shape checks over the raw term. Never fails and never raises; guards with `is_list`/`ground`-style type tests on each element.
- `key_state/3`: presence first, then value. Uses profile_get/3, profile_has/2, profile_lacks/2.
- `inputs_relied_on_pairs/3`: Key-Value pairs of present own keys, in root_exports order, values as given.
- `status_rule/5`: `status_rule(Profile, OwnKeys, DecisionClosure, ReferralClosure, Outcome)`. Outcome is one of `settled(Answer)`, `first_missing(Key)` or `refer(Key)`.
  - Completions range over the finite domains: J/C keys over {true, false}, the enumeration key over its 17 atoms, and the integer key `hours_elapsed_at_notification` over the two classes {72, 73}. This is exact, because the decision function reads that key only through `=< 72`.
  - MATTERS: two completions differing only in K give different answers.
  - BEHIND: per the behind test, which reduces to the first-missing-key rule for two-valued keys.
  - Only keys of not-yet-decided ways are free, which bounds the enumeration. For the 22-key comparison, the side independence is used: a UK key matters for DIFFERENCE iff it can switch the UK answer between a1 and a2, and the EU side can reach a1 or a2. EU keys are symmetric.
  - The penalty-amount query does NOT use the engine. Its integer turnover key is decided by the explicit ladder M-1 to M-9.

## SLICE — uk_pecr_cookie_exemptions_and_fines.clausal (the one determination slice)

This file is self-contained: value facts, way tables, decision functions, ladders, referral rows, checklist, obligations, verdict.

### VALUE facts owned by this slice (declared once)
- `:- constant_value(notification_period_hours, 72).` (reg 5A(2)). Within means `hours_elapsed_at_notification =< constant(notification_period_hours)`.
- `:- constant_value(higher_maximum_fixed_amount_pence, 1750000000).` (s.157(5)).
- `:- constant_value(higher_maximum_turnover_percent, 4).` (s.157(5)(a)).
- `:- constant_value(standard_maximum_fixed_amount_pence, 870000000).` (s.157(6)).
- `:- constant_value(standard_maximum_turnover_percent, 2).` (s.157(6)(a)).
- `:- constant_value(breach_time_amendment_commencement_iso, \u00272025-08-20\u0027).` (S.I. 2025/904 reg 2(p)).
- `:- constant_value(enforcement_amendment_commencement_iso, \u00272026-02-05\u0027).` (S.I. 2026/82 reg 2, reg 11).
  - Both commencement dates are converted to date objects with date_string_iso/2 (library(datetime)).
  - They are used in fixture labels and the version statement only, never on profile values: the profile gives crisp keys.

### Tables
- `uk_way(WayId, Keys, Cite)` lists the six UK ways A to F, with the key lists of THE LIMBS:
  - A: [2, 3], para_2_1;
  - B: [4], para_3;
  - C: [5, 6], para_4_1;
  - D: [2, 7, 8, 9, 10, 11, 12], para_5_1;
  - E: [2, 11, 12, 13, 14], para_6_1;
  - F: [15, 16], para_7.
- `eu_way(WayId, Keys)` lists the three EU ways:
  - a: [storage_or_access_solely_for_transmission];
  - b: [service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service];
  - c: [user_consent_given, clear_and_comprehensive_information_provided].
- `provision_tier(Atom, Tier, TierCitations)` holds the 17 rows of T-3:
  - the 14 listed regulations map to `higher_maximum_amount` with [sch_1_para_18_b_ii, dpa s_157_2, reg_11_2];
  - `commission_notice_not_complied_with` maps to higher with [s_157_4, reg_11_2];
  - `section_142_8b_of_the_data_protection_act_2018` maps to higher with [sch_1_para_18_d, reg_11_2];
  - `other_provision_of_the_pec_regulations` maps to `standard_maximum_amount` with [s_157_2, reg_11_2].
- `tier_amount(Tier, FixedConstant, PercentConstant, AmountCite)`:
  - higher maps to (higher_maximum_fixed_amount_pence, higher_maximum_turnover_percent, uk_dpa_2018_s_157_5);
  - standard maps to (standard_maximum_fixed_amount_pence, standard_maximum_turnover_percent, uk_dpa_2018_s_157_6).
- `referral_row(Query, Key, Cite)` covers the UK cookie query, the EU query, the comparison, breach timing and the amount query:
  - **UK cookie query:**
    - key 1 maps to reg_6_1;
    - keys 2 and 3 map to sch_a1_para_2_1;
    - key 4 maps to para_3;
    - keys 5 and 6 map to para_4_1;
    - keys 7, 8, 9, 10 and 11 map to para_5_1;
    - keys 13 and 14 map to para_6_1;
    - keys 15 and 16 map to para_7.
    - Crisp key 12 is never referred.
  - **EU query:**
    - 17 and 22 map to art_5_3_s1;
    - 18, 19 and 20 map to art_5_3_s2;
    - 21 maps to art_2_f.
  - **Comparison:** the same citation as the key's own side.
  - **Breach timing:**
    - 23 maps to reg_5a_1;
    - 24, 26 and 28 map to reg_5a_2.
  - **Amount query:** 32 maps to s_157_5 (higher tier) or s_157_6 (standard tier), one row each.

### Rules / requirements
1. **Input problems first (all queries).** RESULT is `input_problems(Problems)` and CITATIONS is []. In the comparison, all three results are `input_problems(Problems)` and CHANGED_BY is [].
2. **UK cookie decision function:**
   - key 1 false gives not_applicable;
   - some way all true gives permitted;
   - every way with a key false gives not_permitted.
   - Ladder U1 settled. CITATIONS are the fixed 7-atom list for permitted/not_permitted, or [reg_6_1, reg_6_2] for not_applicable.
   - Ladder U2: the first absent key that matters and is not behind. Key 1 absent with no settled answer is named first.
   - Ladder U3: the first unsure judgement that matters goes to open_textured referral, with PAIRS from the 16 own keys.
3. **EU decision function and ladder EU1 to EU3:**
   - key 17 false gives not_applicable; ways a, b, c decide the rest;
   - all final answers cite [eu_dir_2002_58_art_5_3];
   - PAIRS are taken over keys 17 to 22.
4. **Comparison CMP1 to CMP3:**
   - UK_RESULT and EU_RESULT are the side queries' outputs, verbatim;
   - DIFFERENCE is same/differs from the side decision functions, under the status rule over 22 own keys, with PAIRS over keys 1 to 22;
   - CHANGED_BY is the UK CITATIONS iff DIFFERENCE is differs and UK_RESULT is a final atom, else [].
5. **Breach ladder B-1 to B-5, exactly as THE LIMBS order it:**
   1. the awareness key: absent gives indeterminate; false gives the cross-reference referral to `uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025`, citing `uk_si_2025_904_reg_2_p`;
   2. provider or breach false gives not_applicable;
   3. the settled time answer from the four timing keys;
   4. the first absent key that matters, in the fixed order;
   5. the first unsure judgement that matters goes to referral, with PAIRS over keys 23 to 29.
   - Boundary: hours 72 gives in time; 73 gives not within.
6. **Tier ladder T-1 to T-3:**
   1. the act date key: absent gives indeterminate; false gives the cross-reference referral (`uk_si_2026_82_reg_11_1` to `uk_si_2003_2426_as_in_effect_before_5_february_2026`), with PAIRS over keys 30 and 31;
   2. provision absent gives indeterminate;
   3. the provision_tier row decides.
   - The query reads no other key.
7. **Amount ladder M-1 to M-9:**
   - M-1 and M-2 are as the tier ladder;
   - the TIER, FIXED and PERCENT come from the tables;
   - PercentageAmountPence = Percent * TurnoverPounds;
   - Result = int_max(Fixed, PercentageAmountPence) when undertaking is true; Fixed when undertaking is false, or when the turnover is present with percentage =< Fixed;
   - missing turnover (undertaking true or unsure) is named before a missing undertaking judgement;
   - an unsure undertaking with percentage > Fixed goes to referral (s_157_5 or s_157_6);
   - CITATIONS are the T-3 citations plus the amount cite;
   - PAIRS are taken over keys 30 to 33.
8. **Present keys decide.** Filling an absent key that does not matter never changes RESULT, CITATIONS or CHANGED_BY.
9. **Checklist and obligations** are as defined in the public predicates. Each is one flat list with one solution.

### Verdict atoms produced by this slice
- `permitted`, `not_permitted`, `not_applicable`;
- `same`, `differs`;
- `notification_in_time`, `notification_late_with_reasons`, `notification_out_of_time`, `notification_reasons_for_delay_missing`;
- `higher_maximum_amount`, `standard_maximum_amount`;
- integer pence;
- the status compounds.

### Shared with another slice
None besides the kernel predicates listed above: input check, key_state, inputs_relied_on_pairs and status_rule. There is only one determination slice.

## Tests (seven modes; v2 manifest)

1. **Unit, per rule:**
   - each UK way alone gives permitted;
   - all ways failed gives not_permitted;
   - key 1 false gives not_applicable;
   - each EU way;
   - each breach branch;
   - each of the 17 provision atoms.
2. **Boundary:**
   - hours 72 versus 73;
   - turnover 437500000 pounds at the higher tier (4*T = 1750000000, tie gives 1750000000) and 437500001 (gives 1750000004);
   - turnover 435000000 at the standard tier (tie gives 870000000).
3. **Missing key:**
   - first-missing naming per ladder;
   - the first-missing-key rule 'behind' cases;
   - a missing key named despite an unsure judgement.
4. **Referral:**
   - every referral row fires with the right cite and PAIRS;
   - both cross-reference statuses.
5. **Input check:**
   - wrong_type for each type;
   - attested(...) values;
   - floats and strings;
   - unbound value;
   - duplicate ordering;
   - non-atom key;
   - non-list, partial-list and unbound profile give [wrong_type(profile)].
6. **Determinism / totality:** findall plus length 1 for every query on every fixture. Uses validate_props prop_totality and prop_determinism.
7. **Comparison:**
   - same versus differs with both sides final;
   - differs settled while one side is not final;
   - DIFFERENCE status naming an EU key;
   - CHANGED_BY empty unless the answer differs and the UK side is final.
- Every `fail` test is paired with a positive test over the same case.

## Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, profile_keys/2;
  - memberd/2, not_member/2, int_max/3;
  - item/3, unmet/1, unknown/1, attribute/2;
  - vocabulary atom `met`.
- **kit/query_combinators:** what_if/5, as the engine of `uk_pecr_cookie_exemptions_and_fines_what_if/4`, with the closure `decide_status` (profile override through profile_set/3).
- **validate_props:** run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3, bad_citation/1. These are tests only.
- **library(datetime):** date_string_iso/2 for the two commencement constants. This is the native-datetime idiom; no date/3 terms and no [Y, M, D] lists are used.
- **Not used, with reason:**
  - kit/deadline_lib: the 72-hour period is an hour count the caller supplies under THE CLOCK, not a day-date deadline;
  - kit/compliance_lib: the six-way any-sufficing rule plus the status rule do not fit its deny-overrides lattice;
  - currency_vocab: amounts are in pence by contract, with no currency term in the answer. `gbp` is noted in documentation only.
- **Built locally (domain-specific; candidate kit module noted in NOTES S2):** the generic status_rule/5 engine in kernel.clausal.
