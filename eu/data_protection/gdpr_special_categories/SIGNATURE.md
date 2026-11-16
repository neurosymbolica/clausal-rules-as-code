# SIGNATURE — eu/data_protection/gdpr_special_categories

## Public query surface

The main relation is `decide_special_category_processing(PROFILE, special_category_verdict(STATUS, BASES, CONDITIONS, CITATIONS))`. The facade adds projections and slice wrappers, all listed under 'Public predicates' below.

- PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3` (presence first, then value). Keys are never written as strings.
- There are 45 keys. There are no numeric keys and no date keys. The attestation AT field is supplied by the host and is opaque: copied, never read or compared.
- **Totality:** every ground profile gives exactly one verdict.
- **Determinism / COUNTING:** every public query yields each answer exactly ONCE. The scorer collects all solutions. This is achieved with mutually exclusive clause guards and no cut, `->` or `*->`. Defeaters are guarded `once/1` probes.
- There are no statutory figures (this is the deontic family), so nothing is imported from or re-declared in parameters.

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

- `eligible`: bare atom.
- `ineligible`: bare atom.
- `indeterminate(MISSING_KEYS)`: compound. MISSING_KEYS is a non-empty list of bare key atoms in root_exports order, with no duplicates. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(REASON, CONTEXT)`: compound. REASON is one of:
  - `cross_reference_unresolved(cite(CITATION), cite(TARGET))`;
  - `open_textured(INPUT, cite(CITATION))`.

  CONTEXT is one of:
  - `[resolution(cite(TARGET), not_attempted | attested_not_modelled), inputs_relied_on(PAIRS)]`;
  - `[inputs_relied_on(PAIRS)]`.

  Either CONTEXT may optionally be followed by one `provenance(CLAUSE, CITATIONS)`.
- `input_problems(PROBLEMS)`: compound. PROBLEMS items are `duplicate_key(KEY)`, `wrong_type(KEY)`, `unknown_key(KEY)` and `wrong_type(profile)`.

Result constructors are exported and never called as queries:

- input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1;
- special_category_verdict/4, indeterminate/1, needs_legal_review/2;
- open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2;
- outside_fact/2, attested/2, attestation/4, url/2, document/2.

BASES atoms:

- `art9_2_a` .. `art9_2_j`;
- `art10_official_authority`;
- `art10_authorised_by_law`;
- `not_special_category_data`.

CONDITIONS atoms are the closed lists below, plus `no_further_conditions`, `official_authority`, `authorising_law` and `appropriate_safeguards`.

Category atoms (for special_category_scope/2, in this order):

1. `racial_or_ethnic_origin`
2. `political_opinions`
3. `religious_or_philosophical_beliefs`
4. `trade_union_membership`
5. `genetic_data`
6. `biometric_data`
7. `health_data`
8. `sex_life_or_sexual_orientation`

## Profile keys (45, exactly)

Contract key order (the input_contract order, used by the input check) is the order of the four groups below.

**Selector (1):**

- `exception_claimed`: one of `art9_2_a`..`art9_2_j`, or absent.

**Crisp flags (20), the atoms `true` / `false`:**

1. genetic_data_present
2. biometric_data_present
3. biometric_used_for_unique_identification
4. criminal_offence_data_present
5. explicit_consent_given
6. consent_purposes_specified
7. employment_social_security_or_social_protection_field
8. vital_interest_at_stake
9. data_subject_incapable_of_giving_consent
10. not_for_profit_body_with_specified_aim
11. processing_in_course_of_legitimate_activities
12. processing_relates_solely_to_members_or_regular_contacts
13. data_not_disclosed_outside_body_without_consent
14. purpose_is_legal_claims_or_judicial_capacity
15. purpose_is_health_or_social_care
16. processed_under_professional_secrecy
17. pursuant_to_contract_with_health_professional
18. purpose_is_archiving_research_or_statistics
19. processing_under_official_authority_control
20. comprehensive_register_of_criminal_convictions (a defeater)

**Judgements (16), `true` / `false` / `unsure`:**

1. reveals_racial_or_ethnic_origin
2. reveals_political_opinions
3. reveals_religious_or_philosophical_beliefs
4. reveals_trade_union_membership
5. concerns_health
6. concerns_sex_life_or_sexual_orientation
7. consent_satisfies_definition
8. processing_necessary
9. manifestly_made_public_by_data_subject
10. appropriate_safeguards
11. substantial_public_interest
12. public_health_public_interest
13. authorising_law_proportionate_and_respects_essence
14. suitable_and_specific_measures
15. accordance_with_article_89_1
16. criminal_data_law_safeguards_appropriate

**Outside facts (8), `attested(true|false, attestation(BY, AT, REASON, EVIDENCE))` or absent:**

The order below is the `outside_facts:` block order.

1. prohibition_lifting_barred_by_law
2. employment_law_or_collective_agreement_authorises
3. substantial_public_interest_law_exists
4. health_care_law_basis_exists
5. public_health_law_basis_exists
6. research_archiving_statistics_law_basis_exists
7. criminal_data_authorising_law_exists
8. member_state_further_conditions_exist

**root_exports order (alphabetical).** Used for MISSING_KEYS, for PAIRS, and for the first unsure INPUT:

accordance_with_article_89_1, appropriate_safeguards, authorising_law_proportionate_and_respects_essence, biometric_data_present, biometric_used_for_unique_identification, comprehensive_register_of_criminal_convictions, concerns_health, concerns_sex_life_or_sexual_orientation, consent_purposes_specified, consent_satisfies_definition, criminal_data_authorising_law_exists, criminal_data_law_safeguards_appropriate, criminal_offence_data_present, data_not_disclosed_outside_body_without_consent, data_subject_incapable_of_giving_consent, employment_law_or_collective_agreement_authorises, employment_social_security_or_social_protection_field, exception_claimed, explicit_consent_given, genetic_data_present, health_care_law_basis_exists, manifestly_made_public_by_data_subject, member_state_further_conditions_exist, not_for_profit_body_with_specified_aim, processed_under_professional_secrecy, processing_in_course_of_legitimate_activities, processing_necessary, processing_relates_solely_to_members_or_regular_contacts, processing_under_official_authority_control, prohibition_lifting_barred_by_law, public_health_law_basis_exists, public_health_public_interest, purpose_is_archiving_research_or_statistics, purpose_is_health_or_social_care, purpose_is_legal_claims_or_judicial_capacity, pursuant_to_contract_with_health_professional, research_archiving_statistics_law_basis_exists, reveals_political_opinions, reveals_racial_or_ethnic_origin, reveals_religious_or_philosophical_beliefs, reveals_trade_union_membership, substantial_public_interest, substantial_public_interest_law_exists, suitable_and_specific_measures, vital_interest_at_stake.

## Manifest `outside_facts:` block (v2 manifest)

Fetcher is `none` for all eight, so only the `attested` kind is read. The `fetched` kind is declared; if both kinds were present, `attested` would win.

| key | polarity | citation | target |
| --- | --- | --- | --- |
| prohibition_lifting_barred_by_law | blocking | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_a |
| employment_law_or_collective_agreement_authorises | enabling | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_b |
| substantial_public_interest_law_exists | enabling | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_g |
| health_care_law_basis_exists | enabling | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_h |
| public_health_law_basis_exists | enabling | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_i |
| research_archiving_statistics_law_basis_exists | enabling | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_2_j |
| criminal_data_authorising_law_exists | enabling | eu_reg_2016_679_art_10 | eu_reg_2016_679_art_10 |
| member_state_further_conditions_exist | blocking | eu_reg_2016_679_art_9_1 | eu_reg_2016_679_art_9_4 |

## Citation-key atoms (citations.clausal; never shortened)

**Operative atoms (may enter verdict CITATIONS):**

- eu_reg_2016_679_art_9_1
- eu_reg_2016_679_art_9_2_a, eu_reg_2016_679_art_9_2_b, eu_reg_2016_679_art_9_2_c, eu_reg_2016_679_art_9_2_d, eu_reg_2016_679_art_9_2_e
- eu_reg_2016_679_art_9_2_f, eu_reg_2016_679_art_9_2_g, eu_reg_2016_679_art_9_2_h, eu_reg_2016_679_art_9_2_i, eu_reg_2016_679_art_9_2_j
- eu_reg_2016_679_art_9_3
- eu_reg_2016_679_art_9_4
- eu_reg_2016_679_art_10

**Definition atoms (reasoning only, never in verdict CITATIONS):**

- eu_reg_2016_679_art_4_11
- eu_reg_2016_679_art_4_13
- eu_reg_2016_679_art_4_14
- eu_reg_2016_679_art_4_15 (named only in the referral row art_9_4_applicability_health_unsure)

Each atom is mapped to its Formex unit, for example `eu_reg_2016_679_art_9_2_a` to `02016R0679-20160504#point_009.002_a` and `eu_reg_2016_679_art_10` to `02016R0679-20160504#art_010`. The Art 9(2) chapeau (parag_009.002) has no separate atom: it is carried by each point atom.

## Referral rows (owned by processing_permitted.clausal)

Each row is `referral_row(RowId, Input, Citation, Inputs)`. Inputs are in root_exports order.

- **Six scope rows**, `scope_<key>`, one for each of the six scope judgements. Citation `eu_reg_2016_679_art_9_1`. Inputs are exactly the six scope judgements.
- **Limb judgement rows**, `<point>_<key>`, for each judgement a point reads. Citation is the claimed point atom. Inputs are every key that point's limb reads, including its outside fact. The rows are:
  - art_9_2_a_consent_satisfies_definition;
  - art_9_2_b_processing_necessary, art_9_2_b_appropriate_safeguards;
  - art_9_2_c_processing_necessary;
  - art_9_2_d_appropriate_safeguards;
  - art_9_2_e_manifestly_made_public_by_data_subject;
  - art_9_2_f_processing_necessary;
  - art_9_2_g_processing_necessary, art_9_2_g_substantial_public_interest, art_9_2_g_authorising_law_proportionate_and_respects_essence, art_9_2_g_suitable_and_specific_measures;
  - art_9_2_h_processing_necessary;
  - art_9_2_i_processing_necessary, art_9_2_i_public_health_public_interest, art_9_2_i_suitable_and_specific_measures;
  - art_9_2_j_processing_necessary, art_9_2_j_accordance_with_article_89_1, art_9_2_j_authorising_law_proportionate_and_respects_essence, art_9_2_j_suitable_and_specific_measures.
- **Cross-reference rows**, `<point>_authorising_law` for points b, g, h, i and j, and `art_10_authorising_law`. CITATION and TARGET come from the outside_facts block. Inputs are the limb's keys.
- **Art 10 judgement row**, `art_10_criminal_data_law_safeguards_appropriate`. Citation `eu_reg_2016_679_art_10`. Inputs are comprehensive_register_of_criminal_convictions, criminal_data_authorising_law_exists, criminal_data_law_safeguards_appropriate, criminal_offence_data_present and processing_under_official_authority_control.
- **Art 9(4) rows.** Both have inputs biometric_data_present, concerns_health, genetic_data_present and member_state_further_conditions_exist.
  - `art_9_4_applicability_health_unsure`: Input concerns_health, Citation `eu_reg_2016_679_art_4_15`.
  - `art_9_4_further_conditions`: cross-reference to art_9_1 / art_9_4 with status attested_not_modelled.

**PAIRS rule.** PAIRS is built in this order:

1. `exception_claimed-VALUE` first (`exception_claimed-absent` when the key is absent).
2. Then `KEY-VALUE` for each present key in the row's Inputs, in root_exports order. An outside fact pairs with its attested(...) term as given.
3. In step (iii) only, add `KEY-absent` for the absent outside fact of the referring part, placed at its root_exports position. The Art 9(4) referral has no such pair.

No other key ever enters PAIRS.

## Public predicates

- `decide_special_category_processing(Profile, Verdict)`: the whole `special_category_verdict/4`. Input problems come first. Art 9(1)-(4) and Art 10.
- `processing_permitted(Profile, Decision)`: the STATUS field. This is the #13 compliance check: is the proposed processing allowed under Art 9 and Art 10.
- `permitted_bases(Profile, Bases)`: BASES when eligible, else `[]`. Art 9(2)(a)-(j) and Art 10.
- `special_category_scope(Profile, Scope)`: the Art 9(1) determination alone. Scope is one of:
  - the ordered list of true category atoms;
  - `indeterminate(MissingKeys)`;
  - `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_9_1)), [inputs_relied_on(Pairs)])`;
  - `input_problems(Problems)`.
- `special_category_outside_facts(Profile, OutsideFacts)`: `[outside_fact(Key, Attested)]` for the eight keys in block order, each `attested(...)` as given or `absent`; or `input_problems(Problems)`. Art 9(2), 9(4) and Art 10.
- `gdpr_special_categories_input_problems(Profile, Problems)`: the INPUT CONTRACT check, `[]` when well-formed.
- `decide_processing_permitted(Profile, Verdict)`: facade wrapper, identical to decide_special_category_processing/2. Art 9 and Art 10.
- `processing_permitted_status(Profile, Status)`: the #3 status determination, the STATUS field. Art 9 and Art 10.
- `processing_permitted_checklist(Profile, Checklist)`: the #7 justification. Checklist is `[item(RequirementId, Outcome, cite(CitationKey))]`, one item per evaluated requirement:
  - the Art 9 scope;
  - each condition of the claimed point;
  - Art 9(3) for point (h);
  - Art 9(4) when reached;
  - the Art 10 scope and routes.

  Every item, MET items included, carries the cite of its operative provision. Definitions are never cited. Outcome is met, unmet(Key), open_by_absence(Keys), open_by_cross_reference(Key), open_by_judgement(Key) or not_applicable. With input problems the checklist is `[]`.
- `decide_permitted_bases(Profile, permitted_bases_verdict(Status, Bases, Citations))`: projection of the verdict onto the basis question. Art 9(2) and Art 10.
- `permitted_bases_status(Profile, Status)`: the STATUS of the verdict, read as 'is there a permitting basis'. Art 9(2) and Art 10.
- `permitted_bases_checklist(Profile, Checklist)`: one item per closed condition of each MET or evaluated basis, as `item(ConditionId, Outcome, cite(PointKey))`. Art 9(2)(a)-(j), 9(3) and Art 10.
- `gdpr_special_categories_what_if(Profile, Key, Value, Verdict)`: the verdict after overriding Key with Value. Built with query_combinators what_if/5, using the closure `decide_special_category_processing`.
- **Fixtures** (fixtures.clausal): `gdpr_special_categories_fixture(FixtureName, Profile)` and `gdpr_special_categories_fixture_expected(FixtureName, Verdict)`. They are named profiles exercising every row, including:
  - not_special_category;
  - health_with_explicit_consent;
  - missing_claim_ineligible;
  - biometric_without_identification;
  - scope_unsure_referral (the worked PAIRS example);
  - employment_law_absent_cross_reference;
  - further_conditions_attested_true;
  - further_conditions_attested_false;
  - health_unsure_further_conditions;
  - criminal_route_official_authority;
  - criminal_register_defeats_route_by_law;
  - criminal_scope_absent_indeterminate;
  - duplicate_and_unknown_keys.

## Planned reuse (manifest `uses:`)

- **formalize_lib:** profile_get/3, profile_has/2, profile_lacks/2, profile_keys/2, memberd/2, not_member/2, not_defeated/3, eval_requirements/4 (the checklist engine, with the injected closure `gdpr_special_categories_requirement`; no hand-rolled findall row-helper, per lint R1), attribute/2 and item/3.
  - check_tri/4 is NOT used. The judgements have a fourth value, `unsure`, so the local reader is a distinct relation and carries a `% lint:` C15 justification.
- **kit/query_combinators:** what_if/5.
- **validate_props** (tests): run_props/1, prop_totality/3, prop_determinism/3 (exactly one solution), prop_citation_complete/3, prop_missing_key_coverage/3 and bad_citation/1.
- **Not used, with reasons:**
  - kit/compliance_lib: its deny-overrides modality lattice has no five-outcome Kleene precedence and no referral outcomes.
  - currency_vocab, vat_category, deadline_lib, date_time, rolling_window: no money or dates.
  - country: no Member State key, because outside facts are attested per processing.
- There is no family `_common` backbone predicate for attested outside facts. This is noted in the working notes (not published) as recurring and kept local in kernel.clausal.

## Slice: kernel.clausal (the shared floor; only what two or more modules read)

- **Key vocabulary.** `gdpr_special_categories_key(Key, Type)` in contract order, with Type one of selector, crisp, judgement or outside_fact. Also `gdpr_special_categories_root_order(Keys)`, the alphabetical list above, and `gdpr_special_categories_order_keys(Keys, Ordered)`, which sorts and deduplicates into root_exports order.
- **Input check.** `gdpr_special_categories_input_problems/2`, as in the INPUT CONTRACT:
  - duplicate_key before wrong_type, per key in contract order;
  - then unknown_key in first-occurrence order;
  - `[wrong_type(profile)]` for a non-attribute-list.
- **Typed readers.** Three disjoint clauses each, cut-free:
  - `gdpr_special_categories_crisp_outcome(Profile, Key, Outcome)`;
  - `gdpr_special_categories_judgement_outcome(Profile, Key, Outcome)`;
  - `gdpr_special_categories_enabling_fact_outcome(Profile, Key, Outcome)`: attested true is met, attested false is unmet, absent is open_by_cross_reference;
  - `gdpr_special_categories_blocking_fact_outcome(Profile, Key, Outcome)`: attested false is met, absent is met, attested true is unmet.
- **Lattice.**
  - `gdpr_special_categories_conjunction(Outcomes, Outcome)`: unmet dominates; met if all are met; else the highest-precedence open kind. Absence Keys are unioned.
  - `gdpr_special_categories_disjunction(Outcomes, Outcome)`: met if any is met; unmet if all are unmet; else the open kinds of the non-unmet disjuncts by precedence. Precedence is absence, then cross_reference, then judgement.
- **PAIRS builder.** `gdpr_special_categories_pairs(Profile, Inputs, AbsentFacts, Pairs)`.
- Nothing legal-substantive lives here: no point lists, no citations beyond the atoms registered in citations.clausal.

## Slice: processing_permitted.clausal (Art 9 and Art 10: is the processing barred)

**VALUE facts owned:**

- `scope_category(CategoryAtom, Source)`: eight rows in category order. Sources are judgement keys, genetic_data_present, and the biometric pair.
- `exception_point(ExceptionAtom, PointCitation, ConditionIds)`. The closed lists are:
  - art9_2_a [explicit_consent, specified_purposes, consent_definition, no_legal_bar]
  - art9_2_b [necessity, employment_social_security_field, authorising_law, appropriate_safeguards]
  - art9_2_c [necessity, vital_interest, incapacity]
  - art9_2_d [not_for_profit_body, legitimate_activities, members_only, no_external_disclosure, appropriate_safeguards]
  - art9_2_e [manifestly_made_public]
  - art9_2_f [necessity, legal_claims_purpose]
  - art9_2_g [necessity, substantial_public_interest, authorising_law, proportionate_law, suitable_measures]
  - art9_2_h [necessity, health_care_purpose, law_or_contract, professional_secrecy]
  - art9_2_i [necessity, public_health_interest, authorising_law, suitable_measures]
  - art9_2_j [necessity, archiving_research_statistics_purpose, article_89_1, authorising_law, proportionate_law, suitable_measures]
- `point_condition(ExceptionAtom, ConditionId, Key, Reader)`. Reader is crisp, judgement, enabling_fact or blocking_fact.
  - law_or_contract is the disjunction of pursuant_to_contract_with_health_professional (crisp) and health_care_law_basis_exists (enabling).
  - professional_secrecy also cites eu_reg_2016_679_art_9_3.
- The referral rows above.
- `defeater(RuleId, Key)`: two rows. (art9_2_a no_legal_bar, prohibition_lifting_barred_by_law attested true) and (art_10_route_authorised_by_law, comprehensive_register_of_criminal_convictions true). Each is probed by a guarded `once/1` through not_defeated/3.

**Rules / requirements (one requirement id per checklist item):**

1. **Art 9 scope.** Kleene OR. MISSING scope keys are the absent ones that matter; there are none once a category is true.
2. **Art 9 limb** of the claimed exception: the conjunction of its point conditions.
3. **Art 9 part:**
   - scope NA: not_applicable;
   - scope IN with no claim: unmet, giving ineligible citing art_9_1;
   - scope IN with a claim: the limb outcome;
   - scope OPEN: the highest-precedence open kind of the scope and the open limb.
4. **Art 9(4), only when the Art 9 part is met.** G is the Kleene OR of genetic_data_present, biometric_data_present and concerns_health. F is member_state_further_conditions_exist.
   - F absent: stands; nothing appended, nothing cited, nothing named.
   - F attested and G true:
     - F false: append no_further_conditions and cite art_9_4.
     - F true: open_by_cross_reference with `resolution(cite(eu_reg_2016_679_art_9_4), attested_not_modelled)` and no KEY-absent pair.
   - F attested and G false: changes nothing.
   - F attested, none of the three true, one absent: open_by_absence naming the absent ones among the three.
   - F attested, none of the three true, none absent, concerns_health unsure: open_by_judgement on the row art_9_4_applicability_health_unsure.
5. **Art 10 scope:** criminal_offence_data_present. True is IN, false is NA, absent is open_by_absence. An open scope still evaluates the limb.
6. **Art 10 limb:** route A OR route B.
   - Route A is processing_under_official_authority_control (crisp).
   - Route B is the conjunction of criminal_data_authorising_law_exists (enabling) and criminal_data_law_safeguards_appropriate (judgement), defeated by the register.
   - Conditions are [official_authority] when route A is met, else [authorising_law, appropriate_safeguards].
   - A route beside a met route is not read.
7. **Combination, steps (i) to (v)** of the interface:
   1. Ineligible: cite(art_9_1) and/or cite(art_10).
   2. indeterminate: every absent key of the still-open limbs and scopes, in root_exports order. Not named: decided limbs, NA parts, defeaters, and scope flags that do not matter.
   3. Cross-reference: Art 9, then Art 10, then Art 9(4).
   4. open_textured: the first unsure key read, in root_exports order.
   5. Eligible: bases in the order Art 9 then Art 10; conditions concatenated; citations art_9_1, the point, art_9_3 (for h), art_9_4 (when applied), art_10. With both parts NA: [not_special_category_data] citing art_9_1 and art_10.

**Verdict atoms:** the five STATUS forms above.

**Exports:** decide_special_category_processing/2, processing_permitted/2, special_category_scope/2, special_category_outside_facts/2, decide_processing_permitted/2, processing_permitted_status/2, processing_permitted_checklist/2, and `gdpr_special_categories_requirement/4` (RequirementId FIRST, the kit order).

**SHARED:** this slice reads only kernel.clausal and citations.clausal.

**Tests:**

- one per point;
- one per open kind;
- one per COUNTING case (each query has exactly one solution);
- every negative test paired with a positive test on the same case;
- the worked PAIRS example verbatim.

## Slice: permitted_bases.clausal (on which basis is the processing permitted)

**VALUE facts owned:**

- `basis_atom(Part, Route, BasisAtom)`: (art9, ExceptionAtom, ExceptionAtom), (art10, route_a, art10_official_authority), (art10, route_b, art10_authorised_by_law), (none, none, not_special_category_data).
- `basis_citations(BasisAtom, CitationKeys)`: for example art9_2_h gives [eu_reg_2016_679_art_9_1, eu_reg_2016_679_art_9_2_h, eu_reg_2016_679_art_9_3].

**Rules:**

- permitted_bases/2 gives BASES when STATUS is eligible, else `[]`. These are two disjoint clauses, guarded on the STATUS read from decide_special_category_processing/2.
- decide_permitted_bases/2, permitted_bases_status/2 and permitted_bases_checklist/2 project the same single verdict, so nothing is recomputed (COUNTING).
- With input problems, permitted_bases/2 gives `[]`.

**Verdict atoms:** the same STATUS forms; the BASES atoms above.

**SHARED:** none added to kernel. This slice reads decide_special_category_processing/2 and gdpr_special_categories_requirement/4 from processing_permitted.clausal, which precedes it in the scaffold layer chain. No Art 9 or Art 10 rule is restated here.

**Tests:**

- each basis atom;
- route A preferred over route B when both are met;
- `[]` on every non-eligible status;
- `[]` on input problems.

## Other scaffold modules (kept; names and layout unchanged)

- **citations.clausal:** the eighteen citation atoms with their Formex units, and the guard against shortened atoms (bad_citation/1 in tests).
- **parameters.clausal:** no statutory figures exist in this deontic domain. It is retained, empty of figures, with a comment pointing to the manifest `outside_facts:` block.
- **queries.clausal:** gdpr_special_categories_what_if/4, plus the #3, #13 and #7 query entries mapped to the predicates above.
- **fixtures.clausal:** the fixtures listed above.
- **Package facade:** re-exports the public predicates listed in this file.
- **Seven test modes and the v2 manifest:** as scaffolded. Each slice contributes its own per-rule tests, checklist test and verdict test.
