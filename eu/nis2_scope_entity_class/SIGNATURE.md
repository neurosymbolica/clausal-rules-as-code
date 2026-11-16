# SIGNATURE — eu/nis2_scope_entity_class

Public query surface: `decide_nis2_scope_entity_class(Profile, nis2_scope_entity_class_verdict(Status, Citations))`, `nis2_scope_entity_class_status(Profile, Status)`, `nis2_scope_entity_class_checklist(Profile, Checklist)`, `nis2_scope_entity_class_what_if(Profile, Key, Value, Verdict)`, plus the three called queries `size_class/3`, `scope_decision/3`, `entity_class/3` and the input check. Every query yields exactly ONE solution, so there is totality and determinism. Imported figures come from formalize_lib. The statutory figures live only in the slice file.

## Verdict STATUS atoms (replacing the scaffold placeholders)

Facade Status is one of:
- `eligible` (in scope)
- `ineligible` (out of scope)
- `indeterminate(MissingKeys)`: a non-empty list of bare key atoms in root_exports order. The bare atom is never used.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: an optional trailing `provenance(Clause, Citations)` is unscored.
- `input_problems(Problems)`: Problems is a list of `duplicate_key(K)`, `wrong_type(K)`, `unknown_key(K)` or `wrong_type(profile)`.

Query results:
- size: microenterprise, small_enterprise, medium_sized_enterprise, large_enterprise
- scope: in_scope, out_of_scope
- class: essential_entity, important_entity, out_of_scope
- each may also be a compound status as above

## Profile keys (21, in root_exports order)

Judgement keys are true, false or unsure. Crisp keys are true or false.

1. annex_i_type (judgement)
2. annex_ii_type (judgement)
3. services_or_activities_in_union (crisp)
4. staff_headcount (non-negative integer, persons)
5. annual_turnover_eur (non-negative integer, whole euros)
6. annual_balance_sheet_total_eur (non-negative integer, whole euros)
7. public_electronic_communications_provider (crisp)
8. trust_service_provider_status (not_a_trust_service_provider | non_qualified_trust_service_provider | qualified_trust_service_provider)
9. tld_name_registry (crisp)
10. dns_service_provider (crisp)
11. sole_provider_of_an_essential_service_in_a_member_state (judgement)
12. disruption_could_significantly_impact_public_safety_security_or_health (judgement)
13. disruption_could_induce_a_significant_systemic_risk (judgement)
14. critical_by_specific_national_or_regional_importance (judgement)
15. public_administration_kind (not_public_administration | central_government | regional_with_risk_assessed_services | other_public_administration)
16. public_administration_in_national_security_defence_or_law_enforcement (crisp)
17. critical_entity_under_directive_2022_2557 (crisp)
18. domain_name_registration_service_entity (crisp)
19. exempted_from_dora_scope_by_member_state (crisp)
20. identified_by_member_state_as_essential_entity (crisp)
21. former_operator_of_essential_services_kept_essential_by_member_state (crisp)

No dates are used. Money is whole euros, as the contract fixes, not cents. Values are never quoted strings and never Python booleans.

## Citation-key atoms

Each is written `cite(KEY)`:
- eu_dir_2022_2555_art_2_1
- eu_dir_2022_2555_art_2_2
- eu_dir_2022_2555_art_2_2_a_i
- eu_dir_2022_2555_art_2_2_a_ii
- eu_dir_2022_2555_art_2_2_a_iii
- eu_dir_2022_2555_art_2_2_b
- eu_dir_2022_2555_art_2_2_c
- eu_dir_2022_2555_art_2_2_d
- eu_dir_2022_2555_art_2_2_e
- eu_dir_2022_2555_art_2_2_f_i
- eu_dir_2022_2555_art_2_2_f_ii
- eu_dir_2022_2555_art_2_3
- eu_dir_2022_2555_art_2_4
- eu_dir_2022_2555_art_2_7
- eu_dir_2022_2555_art_2_9
- eu_dir_2022_2555_art_2_10
- eu_dir_2022_2555_art_3_1_a
- eu_dir_2022_2555_art_3_1_b
- eu_dir_2022_2555_art_3_1_c
- eu_dir_2022_2555_art_3_1_d
- eu_dir_2022_2555_art_3_1_e
- eu_dir_2022_2555_art_3_1_f
- eu_dir_2022_2555_art_3_1_g
- eu_dir_2022_2555_art_3_2

No invented shortened atoms. The Recommendation has no key of its own and is cited through art_2_1.

## Public predicates

- `decide_nis2_scope_entity_class(Profile, nis2_scope_entity_class_verdict(Status, Citations))`: the eligibility verdict (in scope = eligible), from the scope_decision result. Art 2.
- `nis2_scope_entity_class_status(Profile, Status)`: the Status of the verdict alone. Art 2.
- `nis2_scope_entity_class_checklist(Profile, Checklist)`: a checklist of `item(Id, Status, cite(Key))` for the exclusions X1 to X2 and the scope grounds G1 to G13, each with provenance. Art 2.
- `nis2_scope_entity_class_what_if(Profile, Key, Value, Verdict)`: the verdict after overriding one key. Art 2.
- `size_class(Profile, Size, Citations)`: the size category, Art 2(1) and the Recommendation Annex Art 2.
- `scope_decision(Profile, Result, Citations)`: in_scope, out_of_scope or a status, Art 2(1) to (4), (7), (9), (10).
- `entity_class(Profile, Class, Citations)`: essential_entity, important_entity, out_of_scope or a status, Art 3(1) and (2).
- `nis2_scope_entity_class_input_problems(Profile, Problems)`: the input check, exactly one solution, order of keys then unknown keys.
- `nis2_scope_entity_class_fixtures(Name, Profile, ExpectedResult)`: named fixtures for the seven test modes.
- Result constructors, exported and never called as queries: indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1.

## Determination slice: nis2_scope_entity_class.clausal

**Value facts it owns** (integer constants, each declared once with `constant_value` and read with `constant(Name)`):
- staff ceilings: 250, 50, 10 persons (strict, `<`)
- turnover ceilings: EUR 50 000 000, 10 000 000, 2 000 000 (`=<`)
- balance sheet ceilings: EUR 43 000 000, 10 000 000, 2 000 000 (`=<`)
- the contract key list and enumeration atom lists (trust service status, public administration kind)
- the referral-citation tables (scope stage and class stage)

**Rules and requirements:**
- Input check: duplicate_key, then wrong_type, then unknown_key.
- Size: s1 to s4, with derived tests AT_LEAST_MEDIUM, EXCEEDS_MEDIUM and MEDIUM_SIZED.
- Exclusions: X1 (cites 2_7, 2_9) and X2 (cite 2_10), decided first.
- Scope grounds G1 to G13 in the fixed order, with test T.
- Class grounds E1 to E9, then the important default (cite 3_2).
- Ladder rule, written once and used by every stage.
- Per-rule tests, checklist and verdict, all within this file.

**Verdict atoms:** the Status atoms above, and the size, scope and class atoms listed under that heading.

**Shared with other slices (kernel.clausal):** none beyond the kernel floor. This is the only slice, so no predicate is shared.

## Planned reuse (manifest `uses:`)

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, missing_keys/3, memberd/2, not_member/2, assess/6 (checklist engine via a `requirement/4` closure), decide_labeled/3, item/3, int_min/3, int_max/3
- validate_props: run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3
- kit.query_combinators: what_if/5, flip_scan/4, diff_checklists/3
- No use of date_time, deadline_lib, compliance_lib, rolling_window, currency_vocab, vat_category or country, because the order has no dates, plans, norms or currencies beyond whole euros.
