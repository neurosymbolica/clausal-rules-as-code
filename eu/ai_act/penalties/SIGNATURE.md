# SIGNATURE — eu/ai_act/penalties

## Public query surface

### The called contract (exact)

- `maximum_fine(Profile, InfringementDate, Maximum, Citations)` gives the Union ceiling for an Art 99 or Art 100 fine. Citations: Art 99(3) to (6a), Art 99(8), Art 100(1) to (3), Art 113 point (a).
- `general_purpose_ai_model_maximum_fine(Profile, InfringementDate, Maximum, Citations)` gives the Commission's ceiling under Art 101. Citations: Art 101(1), points (a) to (d), Art 113, Art 113 point (b).
- `penalties_input_problems(Profile, Problems)` is the input check. Problems is a bare flat list, [] when the profile is well-formed.

### Determinism and totality

Every query yields EXACTLY ONE solution for every term it is given, and never raises.

- The steps are disjoint clauses. Each clause guards on the negation of every earlier step.
- Ground outputs are folded into the clause heads (C17).
- There is no cut, no if-then-else and no once/1.
- profile_get/3 is only reached after the input check has excluded duplicate keys, so each key has at most one value.

### Figures

All statutory figures are declared once with `:- constant_value(Name, Value).` in penalties.clausal and read with `constant(Name)`. None are imported from another domain, and none are re-declared elsewhere.

## Maximum and status vocabulary

These replace the scaffold placeholders `required`, `permitted` and `not_applicable`.

### MAXIMUM terms (argument 3 of both queries)

Final answers:

- `fine_maximum(AmountEurCents, Basis)`, where Basis is `fixed_amount` or `turnover_percentage`;
- `no_union_maximum`;
- `set_by_member_state_rules`;
- `not_applicable_on_date`;
- `earlier_version_applies` (maximum_fine only);
- `no_commission_fine` (general_purpose_ai_model_maximum_fine only).

Not-final answers (Citations is always []):

- `indeterminate([Key])`, a list of exactly one bare key atom. The bare atom indeterminate is NEVER written.
- `needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently-unsure])])`.
- `input_problems(Problems)`.

Problem terms are `unknown_key(Key)`, `wrong_type(Key)` (including `wrong_type(profile)` and `wrong_type(infringement_date)`) and `duplicate_key(Key)`.

### Facade verdict STATUS atoms (eligibility, query type #2)

| STATUS | When |
|---|---|
| `union_maximum_determined` | Maximum is fine_maximum/2 (eligible-like) |
| `no_union_maximum_determined` | Maximum is one of the final atoms (ineligible-like) |
| `information_missing` | Maximum is indeterminate/1 (the indeterminate label; never the bare atom indeterminate) |
| `legal_review_needed` | Maximum is needs_legal_review/2 |
| `input_rejected` | Maximum is input_problems/1 |

The assess/6 labels are `labels(union_maximum_determined, information_missing, no_union_maximum_determined)`. The two remaining statuses, `legal_review_needed` and `input_rejected`, are mapped by penalties_status from the Maximum shape.

## Profile keys

The six keys are listed in root_exports order and input_contract order. The profile is `[attribute(Key, Value), ...]`, read only with profile_get/3.

1. `offender_category`, an enumeration of six atoms:
   - `micro_small_or_medium_sized_enterprise`
   - `small_mid_cap_enterprise`
   - `other_undertaking`
   - `not_an_undertaking`
   - `public_authority_or_body`
   - `union_institution_body_office_or_agency`
2. `infringement`, an enumeration of twelve atoms:
   - `prohibited_practice`
   - `prohibited_practice_under_article_5_1_ba_bb_1a_or_1b`
   - `provider_obligations_under_article_16`
   - `authorised_representative_obligations_under_article_22`
   - `importer_obligations_under_article_23`
   - `distributor_obligations_under_article_24`
   - `provider_and_operator_obligations_under_article_25_2_or_4`
   - `deployer_obligations_under_article_26`
   - `notified_body_requirements_and_obligations`
   - `transparency_obligations_under_article_50`
   - `incorrect_incomplete_or_misleading_information`
   - `other_infringement`
3. `offender_is_general_purpose_ai_model_provider`, crisp: `true` or `false`.
4. `general_purpose_ai_model_infringement`, an enumeration of five atoms:
   - `infringed_relevant_provisions`
   - `information_request_not_complied_with_or_incorrect_information`
   - `measure_under_article_93_not_complied_with`
   - `access_for_evaluation_under_article_92_not_given`
   - `none_of_article_101_1`
5. `provider_acted_intentionally_or_negligently`, a judgement: `true`, `false` or `unsure`.
6. `worldwide_annual_turnover_eur`, a non-negative integer of whole euros. The unit suffix is mandated by the contract; amounts derived from it are `_eur_cents`.

The date is NOT a profile key. It is the argument InfringementDate, a ground `date(Year, Month, Day)` term. It is validated as a real calendar day and converted to a native datetime date object for comparison (see the kernel).

## Citation-key atoms

These live in citations.clausal as citation_vocabulary facts, each with its pinned unit id, in the canonical _lexicon/citations.yaml scheme. They are never shortened.

| Citation key | Pinned unit |
|---|---|
| `eu_reg_2024_1689_art_99_3` | parag_099.003 |
| `eu_reg_2024_1689_art_99_4` | parag_099.004 |
| `eu_reg_2024_1689_art_99_4_a` | point_099.004_a |
| `eu_reg_2024_1689_art_99_4_b` | point_099.004_b |
| `eu_reg_2024_1689_art_99_4_c` | point_099.004_c |
| `eu_reg_2024_1689_art_99_4_d` | point_099.004_d |
| `eu_reg_2024_1689_art_99_4_da` | point_099.004_da |
| `eu_reg_2024_1689_art_99_4_e` | point_099.004_e |
| `eu_reg_2024_1689_art_99_4_f` | point_099.004_f |
| `eu_reg_2024_1689_art_99_4_g` | point_099.004_g |
| `eu_reg_2024_1689_art_99_5` | parag_099.005 |
| `eu_reg_2024_1689_art_99_6` | parag_099.006 |
| `eu_reg_2024_1689_art_99_6a` | parag_099.006A |
| `eu_reg_2024_1689_art_99_8` | parag_099.008 |
| `eu_reg_2024_1689_art_100_1` | parag_100.001 |
| `eu_reg_2024_1689_art_100_2` | parag_100.002 |
| `eu_reg_2024_1689_art_100_3` | parag_100.003 |
| `eu_reg_2024_1689_art_101_1` | parag_101.001 |
| `eu_reg_2024_1689_art_101_1_a` | point_101.001_a |
| `eu_reg_2024_1689_art_101_1_b` | point_101.001_b |
| `eu_reg_2024_1689_art_101_1_c` | point_101.001_c |
| `eu_reg_2024_1689_art_101_1_d` | point_101.001_d |
| `eu_reg_2024_1689_art_113` | art_113 |
| `eu_reg_2024_1689_art_113_a` | point_113_a |
| `eu_reg_2024_1689_art_113_b` | point_113_b |

## Public predicates

### Called contract

- `maximum_fine(Profile, InfringementDate, Maximum, Citations)`: steps (0) to (9) of the limbs. Citations: Art 99(3) to (8), Art 100(1) to (3), Art 113(a).
- `general_purpose_ai_model_maximum_fine(Profile, InfringementDate, Maximum, Citations)`: steps (10) to (15). Citations: Art 101(1)(a) to (d), Art 113, Art 113(b).
- `penalties_input_problems(Profile, Problems)`: the input check. Citation: the input contract.

### Scaffold facade (names kept)

Case is `penalties_case(QueryName, Profile, InfringementDate)`, with QueryName either `maximum_fine` or `general_purpose_ai_model_maximum_fine`.

- `decide_penalties(Case, Verdict)`: Verdict is `penalties_verdict(Status, Maximum, Citations)`. It gives exactly one solution, delegating to the named query. Citations: as that query.
- `penalties_status(Case, Status)`: the facade STATUS atom only. Exactly one solution. Citations: as the query.
- `penalties_checklist(Case, Checklist)`: a cited checklist, with each item `item(RequirementId, Status, cite(Key))`, met items included (query type #7). It is built with `eval_requirements/4` from formalize_lib and the closure `penalties_requirement(QueryName, InfringementDate)`; the kit appends (RequirementId, Profile, Status, Citation).
  - Requirement ids for maximum_fine:
    - `profile_well_formed`;
    - `date_within_pinned_text` (art_113);
    - `prohibition_in_application` (art_113_a);
    - `offender_category_known`;
    - `infringement_known`;
    - `union_tier_identified` (the TIER citation);
    - `turnover_known` (the TIER citation).
  - Requirement ids for general_purpose_ai_model_maximum_fine:
    - `profile_well_formed`;
    - `article_101_in_application` (art_113, art_113_b);
    - `offender_is_provider` (art_101_1);
    - `act_under_article_101_1` (art_101_1 with its point);
    - `intent_or_negligence_found` (art_101_1, through check_tri/4);
    - `turnover_known` (art_101_1).
- `penalties_what_if(Case, Key, Value, Verdict)`: overrides one profile key with `profile_set/3` (formalize_lib), then gives `decide_penalties` on the edited case. Exactly one solution. Citations: as the query.
- `penalties_fixture(Name, Case, ExpectedMaximum, ExpectedCitations)` in fixtures.clausal: named worked cases, with every boundary listed in the working notes (not published) item 11, the Art 113 dates, and each status shape.

### Result constructors

These are exported but never called as queries: fine_maximum/2, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1 and duplicate_key/1.

## Planned reuse (manifest `uses:`)

### formalize_lib

- profile_get/3, profile_has/2, profile_lacks/2, profile_set/3 for profile access.
- missing_keys/3 to find the first absent key in root_exports order.
- int_max/3 and int_min/3 for HIGHER and LOWER.
- check_tri/4 for the judgement checklist item.
- check_eq/5 and check_true/4 for checklist items.
- eval_requirements/4 and assess/6 for the checklist engine. These are not hand-rolled (R1).
- item/3, unmet/1, unknown/1, attribute/2 and labels/3.

### Dates

- kit/deadline_lib month_last_day/3 validates a real calendar day without raising.
- library(datetime) supplies the native date: date/4 (date(Y, M, D, Object)) builds the date object from the validated date(Y, M, D). The objects are compared with @< and @>=, which order real dates chronologically.
- The statutory dates are held as constant_value date(Y, M, D) terms in the slice, and converted the same way.

### validate_props

run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3 and prop_monotone/5 (the amount is non-decreasing in turnover).

### kit/query_combinators

flip_scan/4 for the turnover boundary tests. Its Probe is the closure `penalties_basis_at(Query, Profile, Date)`, called with (Turnover, Basis).

### Not used, with reasons

- query_combinators what_if/5: its override works on dicts. penalties_what_if uses profile_set/3 instead.
- compliance_lib: the ceiling is not a modality.
- rolling_window, country, vat_category: not needed.
- currency_vocab: not needed, because the currency is fixed at EUR by the unit suffix.

## Layout

The layout is `kernel -> citations -> parameters -> penalties -> queries -> fixtures -> package facade`. All file and module names are kept.

- **kernel.clausal: the shared floor.** It holds only predicates used by more than one layer (the slice, the queries and the facade):
  - the input contract: the six keys in order, and their types;
  - `penalties_input_problems/2`, which never fails and never raises. It checks the profile as a proper list using non-raising guards on var/1 and is_list/1, then checks each element for the shape attribute(Key, Value);
  - `penalties_real_date(DateTerm, DateObject)`, a non-raising check of ground integer Y, M and D that converts to a native date;
  - `penalties_date_problems(DateTerm, Problems)`, which gives [] or [wrong_type(infringement_date)];
  - `penalties_first_missing(Profile, Keys, Key)`, the first absent key in root_exports order.
- **citations.clausal**: citation_vocabulary(Key, UnitId) facts for the 25 keys above.
- **parameters.clausal**: the file is kept but holds NO statutory figures. The slice owns them. It may re-export the slice's constant names for the manifest.
- **queries.clausal**: re-exports maximum_fine/4 and general_purpose_ai_model_maximum_fine/4 from the slice.
- **fixtures.clausal**: penalties_fixture/4.
- **package facade**: decide_penalties/2, penalties_status/2, penalties_checklist/2, penalties_what_if/4.

## Slice: penalties.clausal

This slice is self-contained for the legal concept 'maximum administrative fine under Arts 99 to 101 of Regulation (EU) 2024/1689'.

### Value facts it owns

Each is declared with constant_value. Dates are date(Year, Month, Day) terms and are converted with the kernel's penalties_real_date.

Dates:

- `penalties_pinned_text_start_date` = date(2026, 7, 27) (pin metadata, Q1)
- `penalties_article_101_application_date` = date(2026, 8, 2) (art_113, second paragraph)
- `penalties_late_prohibitions_application_date` = date(2026, 12, 2) (point_113_a)

Art 99(3) tier:

- `penalties_prohibited_practice_fixed_eur_cents` = 3500000000
- `penalties_prohibited_practice_turnover_percent` = 7

Art 99(4) tier:

- `penalties_operator_obligations_fixed_eur_cents` = 1500000000
- `penalties_operator_obligations_turnover_percent` = 3

Art 99(5) tier:

- `penalties_incorrect_information_fixed_eur_cents` = 750000000
- `penalties_incorrect_information_turnover_percent` = 1

Art 100:

- `penalties_union_institution_prohibited_practice_fixed_eur_cents` = 150000000 (Art 100(2))
- `penalties_union_institution_other_fixed_eur_cents` = 75000000 (Art 100(3))

Art 101(1):

- `penalties_general_purpose_model_fixed_eur_cents` = 1500000000
- `penalties_general_purpose_model_turnover_percent` = 3

Other value facts:

- `penalties_tier(InfringementAtom, FixedConstantName, PercentConstantName, TierCitations)` holds one row per atom.
  - The two Art 5 atoms map to the Art 99(3) tier, with [cite(eu_reg_2024_1689_art_99_3)].
  - The eight Art 99(4) atoms map to the Art 99(4) tier, each with [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_POINT)].
  - incorrect_incomplete_or_misleading_information maps to the Art 99(5) tier, with [cite(eu_reg_2024_1689_art_99_5)].
  - other_infringement has no row.
- `penalties_small_mid_cap_reduced(InfringementAtom)`: one fact per Art 99(4) atom and incorrect_incomplete_or_misleading_information (Art 99(6a)).
- `penalties_article_5_atom(Atom)`: the two prohibited-practice atoms.
- `penalties_article_101_act(Atom, PointCitation)`: one row for each of the four acts.

### Derived arithmetic (exact integers only)

- `penalties_percent_eur_cents(TurnoverEur, Percent, PercentEurCents)` computes PercentEurCents is TurnoverEur * Percent.
- `penalties_higher(FixedEurCents, PercentEurCents, Maximum)` has two disjoint clauses:
  - FixedEurCents >= PercentEurCents gives fine_maximum(FixedEurCents, fixed_amount);
  - FixedEurCents < PercentEurCents gives fine_maximum(PercentEurCents, turnover_percentage).
- `penalties_lower(FixedEurCents, PercentEurCents, Maximum)` has two disjoint clauses:
  - FixedEurCents =< PercentEurCents gives fine_maximum(FixedEurCents, fixed_amount);
  - FixedEurCents > PercentEurCents gives fine_maximum(PercentEurCents, turnover_percentage).
  - With these clauses, equal amounts give fixed_amount (Q10).

### Rules for maximum_fine (one disjoint clause group per step; each guards on not-earlier-steps)

0. Profile problems or date problems give input_problems(ProfileProblems followed by DateProblems), Citations [].
1. Date @< the pinned text start date gives earlier_version_applies, [].
2. Infringement is the late Art 5 atom and Date @< 2026-12-02 gives not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)].
3. offender_category is public_authority_or_body, and it is NOT the case that infringement is absent while Date @< 2026-12-02. This gives set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)].
4. The first absent key of offender_category and infringement gives indeterminate([Key]), [].
5. offender_category is union_institution_body_office_or_agency:
   - an Art 5 atom gives fine_maximum(150000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_2)];
   - any other atom gives fine_maximum(75000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)].
6. other_infringement gives no_union_maximum, [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_5)].
7. not_an_undertaking gives fine_maximum(Fixed, fixed_amount), with the TierCitations.
8. Turnover absent gives indeterminate([worldwide_annual_turnover_eur]), [].
9. Otherwise the answer depends on offender_category, with Citations built from the TierCitations:
   - other_undertaking: HIGHER, with the TierCitations;
   - micro_small_or_medium_sized_enterprise: LOWER, with the TierCitations plus cite(eu_reg_2024_1689_art_99_6);
   - small_mid_cap_enterprise with penalties_small_mid_cap_reduced: LOWER, with the TierCitations plus cite(eu_reg_2024_1689_art_99_6a);
   - small_mid_cap_enterprise with an Art 5 atom: HIGHER, with the TierCitations.

### Rules for general_purpose_ai_model_maximum_fine

10. Input problems, as step 0.
11. Date @< 2026-08-02 gives not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_b)].
12. Any one of the following gives no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)]:
    - provider is false;
    - the act is none_of_article_101_1;
    - intent is false.
    - The three triggers are written as one clause over a disjunction that is made unique, so that two triggers firing together still give ONE solution. The planned form is a single clause guarded by a 'some_settled_negative' test, written as disjoint clauses on the first negative key in order.
13. Otherwise the first absent key of provider, act, intent and turnover, in root_exports order, gives indeterminate([Key]), [].
14. Otherwise intent unsure gives the needs_legal_review term listed above, [].
15. Otherwise HIGHER of 1500000000 and turnover times 3, with Citations [cite(eu_reg_2024_1689_art_101_1), PointCitation].

### Verdict atoms

The slice uses the MAXIMUM vocabulary above. The facade maps it to the STATUS atoms.

### Per-rule tests (seven test modes)

1. **Unit tests, one per step.** Pair every negative test with a positive one over the same case.
2. **Boundary tests.**
   - Dates: 2026-07-26 and 2026-07-27; 2026-08-01 and 2026-08-02; 2026-12-01 and 2026-12-02.
   - Turnover: EUR 500000000 and 500000001 for the 7 % and 3 % tiers; EUR 750000000 and 750000001 for the 1 % tier. The equal points give fixed_amount.
3. **Counting tests.** findall plus length 1 for every case.
4. **Input-check tests.**
   - Duplicate keys.
   - A key that is not an atom.
   - An unbound value.
   - A partial list.
   - A non-attribute element.
   - An invalid date, such as date(2026, 2, 30).
5. **Precedence tests.**
   - A false value with an absent key.
   - An absent key with an unsure judgement.
   - A public authority with an absent infringement, before and after 2026-12-02.
6. **Property tests** with validate_props:
   - totality;
   - determinism;
   - citation completeness against citation_vocabulary;
   - monotone amount in turnover.
7. **Fixture regression.** Each penalties_fixture is run against decide_penalties.

### Shared with other slices

There is none: this is the only slice. Its dependencies on kernel.clausal are penalties_input_problems/2, penalties_real_date/2, penalties_date_problems/2 and penalties_first_missing/3. They are in the kernel because the facade and the queries layer need them too.
