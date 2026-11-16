# SIGNATURE — eu/nis2_jurisdiction_registration

Public query surface: `decide_nis2_jurisdiction_registration(PROFILE, nis2_jurisdiction_registration_verdict(STATUS, CITATIONS))`, `nis2_jurisdiction_registration_status(PROFILE, STATUS)`, `nis2_jurisdiction_registration_checklist(PROFILE, CHECKLIST)` and `nis2_jurisdiction_registration_what_if(PROFILE, KEY, VALUE, RESULT)`, plus the five slice queries and the input check. PROFILE is an attribute list [attribute(KEY, VALUE), ...] read only with profile_get/3. Every query yields exactly ONE solution (total and deterministic). No figure is imported: the statutory periods (3 months, 2 weeks) live in the slice.

## Verdict STATUS atoms (replacing satisfied/not_satisfied)

- eligible: a jurisdiction basis is settled (any basis other than no_rule_in_article_26).
- ineligible: basis no_rule_in_article_26 (Art 26(3) does not apply).
- indeterminate(MISSING_KEYS): non-empty list of bare key atoms in root_exports order. The bare atom indeterminate is never written.
- needs_legal_review(open_textured(KEY, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on(PAIRS)]): never a final answer.
- input_problems(PROBLEMS) with CITATIONS []: comes first.
- Constructors: indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, item/2, limit/3, months_after_change/1, weeks_after_change/1.
- Basis atoms: state_of_establishment, state_where_services_are_provided, state_that_established_the_entity, state_of_main_establishment, state_of_representative, any_member_state_where_services_are_provided_may_take_legal_action, no_rule_in_article_26.
- Result atoms: state_where_cybersecurity_risk_management_decisions_are_taken, state_where_cybersecurity_operations_are_carried_out, state_of_establishment_with_most_employees_in_the_union.

## Profile keys (root_exports order)

1. entity_category: general_entity | public_electronic_communications_provider | main_establishment_provider | public_administration_entity
2. established_in_union: crisp
3. offers_services_in_union: crisp
4. representative_designated_in_union: crisp
5. decisions_predominantly_taken_in_one_union_member_state: judgement true/false/unsure
6. cybersecurity_operations_carried_out_in_one_union_member_state: judgement true/false/unsure
7. sector_and_subsector_applicable: crisp
8. member_states_list_applicable: crisp

There are no dates and no money. Values are bare atoms, never strings.

## Citation keys

eu_dir_2022_2555_art_26_1, eu_dir_2022_2555_art_26_1_a, eu_dir_2022_2555_art_26_1_b, eu_dir_2022_2555_art_26_1_c, eu_dir_2022_2555_art_26_2, eu_dir_2022_2555_art_26_3, eu_dir_2022_2555_art_27_2_a, eu_dir_2022_2555_art_27_2_b, eu_dir_2022_2555_art_27_2_c, eu_dir_2022_2555_art_27_2_d, eu_dir_2022_2555_art_27_2_e, eu_dir_2022_2555_art_27_2_f, eu_dir_2022_2555_art_27_3, eu_dir_2022_2555_art_3_4, eu_dir_2022_2555_art_3_4_a, eu_dir_2022_2555_art_3_4_b, eu_dir_2022_2555_art_3_4_c, eu_dir_2022_2555_art_3_4_d. Only canonical lexicon atoms are used; no shortened atoms are invented.

## Public predicates

- decide_nis2_jurisdiction_registration(Profile, Verdict): eligibility verdict nis2_jurisdiction_registration_verdict(STATUS, CITATIONS), derived from jurisdiction_basis; Art 26.
- nis2_jurisdiction_registration_status(Profile, Status): the STATUS of the verdict; Art 26.
- nis2_jurisdiction_registration_checklist(Profile, Checklist): cited checklist, one item(Id, Status, cite(KEY)) per limb, met items included; Art 26, 27, 3(4).
- nis2_jurisdiction_registration_what_if(Profile, Key, Value, Result): verdict after overriding one key; Art 26.
- nis2_jurisdiction_registration_fixtures(Fixtures): named profiles for tests.
- nis2_jurisdiction_registration_input_problems(Profile, Problems): the input check against the typed contract; Problems [] when well-formed.
- jurisdiction_basis(Profile, Basis, Citations): basis of jurisdiction, an atom never a Member State; Art 26(1), (2), (3).
- main_establishment_rule(Profile, Result, Citations): deciding step of the main-establishment test (decisions, then operations, then most employees); Art 26(2).
- registry_submission_items(Profile, Items): single list of item(Name, cite(Key)); [] for categories other than main_establishment_provider; Art 27(1), Art 27(2).
- entity_list_submission_items(Profile, Items): single list of item(Name, cite(Key)) for the Member States' list; applies to every category; Art 3(3), Art 3(4).
- change_notification_limits(Profile, Limits): single list of limit(Regime, Period, cite(Key)); registry limit months_after_change(3) Art 27(3), list limit weeks_after_change(2) Art 3(4).

The five slice queries are exported by the facade under the predicate prefix nis2_jurisdiction_registration_ (for example nis2_jurisdiction_registration_main_establishment_rule/3) and are defined in the slice as jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2 and change_notification_limits/2.

## Determination slices

### nis2_jurisdiction_registration.clausal

- Value facts it owns: the periods months_after_change(3) (Art 27(3)) and weeks_after_change(2) (Art 3(4)); the registry item table (Art 27(2)(a)-(f)); the list item table (Art 3(4)(a)-(d)); the category-to-basis table (Art 26(1)); the three main-establishment step results (Art 26(2)). They are declared with constant_value and read in this file, not in a shared constants file.
- Rules/requirements (checklist ids): category_basis; main_establishment_provider_basis (Art 26(1)(b), 26(2)); non_union_representative (Art 26(3)); main_establishment_decisions_step; main_establishment_operations_step; main_establishment_employees_step; registry_items; entity_list_items; change_limits. Limbs follow the order in the spec: input problems, then entity_category, then category, then established_in_union, offers_services_in_union and representative_designated_in_union as needed.
- Verdict atoms: eligible, ineligible, indeterminate(Keys), needs_legal_review(...), input_problems(...).
- Shared with another slice: nothing, so kernel.clausal holds only the input check and its helpers already scaffolded.
- Counting: each query yields one answer once, with ground outputs folded into clause heads, one clause per disjoint route, no cuts or if-then-else. Check predicates have three exclusive clauses (met, unmet, unknown).

## Planned reuse

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, missing_keys/3, all_present/2, memberd/2, not_member/2, assess/6, decide_labeled/3 (requirement/4 closure with the requirement id first).
- kit.query_combinators: what_if/5 (for the what_if facade), diff_checklists/3.
- validate_props: run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_missing_key_coverage/3.
- Not used: deadline_lib (limits are listed, not computed), date_time, currency_vocab, country (no Member State is named).
