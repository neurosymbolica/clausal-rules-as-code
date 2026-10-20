# SIGNATURE — eu/procurement/framework_agreements

## Public query surface

This domain answers two separable questions over one profile describing one framework agreement and one proposed call-off: (A) is the framework's own term lawful under the four-year limit of Art 33(1)? (B) is the proposed call-off lawful under Art 33(2)–(5), and by which route? The public facade predicates are `decide_framework_agreements/2` (combined verdict), `framework_agreements_status/2` (route classification), `framework_agreements_checklist/2` (defect enumeration), and `framework_agreements_what_if/4` (threshold boundary probe). All yield exactly one solution per bound input; all outputs are ground terms (bare atoms, bare integers, or lists thereof). No profile dict appears in any argument position of the date-surface predicates; dates cross the boundary only as [YEAR, MONTH, DAY] integer triples.

## Verdict STATUS vocabulary

**Framework term determination:**
- `framework_term_lawful` — the term is within four years, or the excess is covered by a duly justified exceptional case.
- `framework_term_unlawful` — the term exceeds four years and no duly justified exceptional case is asserted.

**Call-off determination:**
- `call_off_lawful` — no defects fire; DEFECT_IDS is empty.
- `call_off_unlawful` — at least one defect fires; DEFECT_IDS is non-empty.

**Route atoms (five):**
- `single_operator_direct_award` — Art 33(3); one operator, no reopening.
- `multi_operator_direct_award_all_terms_set_out` — Art 33(4)(a); two or more operators, all terms set out, no split stipulation.
- `multi_operator_direct_award_under_split_framework` — Art 33(4)(b) direct half; two or more operators, all terms set out, split stipulated.
- `multi_operator_reopened_competition` — Art 33(4)(b) reopening half or Art 33(4)(c); two or more operators, reopening.
- `no_lawful_route` — the combination of parameters falls under none of the three Art 33(4) routes, or a single-operator framework attempts a reopening.

**Date-surface status atoms:**
- `within_four_year_limit` / `exceeds_four_year_limit` (from `framework_term_within_limit/3`)
- `award_date_within_framework_term` / `award_date_outside_framework_term` (from `call_off_award_window_status/4`)

## Profile keys (21, exactly)

| Key | Type | Notes |
|-----|------|-------|
| `framework_start_date` | date(YEAR, MONTH, DAY) term | Framework term start |
| `framework_end_date` | date(YEAR, MONTH, DAY) term | Framework term end |
| `call_off_award_date` | date(YEAR, MONTH, DAY) term | Date the call-off is awarded |
| `framework_operator_count` | scalar integer, >= 1 | 1 → Art 33(3); >= 2 → Art 33(4) |
| `call_off_method_key` | bare atom | `without_reopening_competition` or `with_reopening_competition` |
| `exceptional_case_duly_justified` | native boolean | Art 33(1) save clause |
| `contracting_authority_identified_in_call_for_competition` | native boolean | Art 33(2) first subpara |
| `economic_operator_party_to_framework` | native boolean | Art 33(2) first subpara |
| `call_off_entails_substantial_modification` | native boolean | Art 33(2) third subpara; TRUE = defect |
| `call_off_within_limits_of_framework_terms` | native boolean | Art 33(3); FALSE = defect |
| `framework_sets_out_all_terms` | native boolean | Art 33(4)(a)/(b)/(c) routing |
| `objective_conditions_for_determining_performer_indicated` | native boolean | Art 33(4)(a) documentation |
| `partly_with_partly_without_reopening_stipulated` | native boolean | Art 33(4)(b) stipulation |
| `objective_criteria_for_choice_of_route_stated` | native boolean | Art 33(4)(b) documentation |
| `terms_subject_to_reopening_specified` | native boolean | Art 33(4)(b) documentation |
| `reopened_competition_based_on_framework_terms` | native boolean | Art 33(5) chapeau |
| `capable_operators_consulted_in_writing` | native boolean | Art 33(5)(a) |
| `time_limit_sufficiently_long` | native boolean | Art 33(5)(b) |
| `tenders_submitted_in_writing` | native boolean | Art 33(5)(c) |
| `tender_contents_confidential_until_time_limit_expired` | native boolean | Art 33(5)(c) |
| `award_made_on_framework_award_criteria` | native boolean | Art 33(5)(d) |

## Citation-key atoms

- `eu_dir_2014_24_art_33_para_1` — Art 33(1): framework agreement definition, four-year limit, exceptional case save clause.
- `eu_dir_2014_24_art_33_para_2` — Art 33(2): call-off procedures, identified parties, no substantial modification.
- `eu_dir_2014_24_art_33_para_3` — Art 33(3): single-operator regime, within limits, written request to supplement.
- `eu_dir_2014_24_art_33_para_4` — Art 33(4): three routes for multi-operator frameworks (a), (b), (c).
- `eu_dir_2014_24_art_33_para_5` — Art 33(5): procedure for reopened competitions (a)–(d).

## Public predicates (one line each)

- `decide_framework_agreements(PROFILE, VERDICT)`: combined verdict over both determinations; VERDICT is `framework_agreements_verdict(STATUS, DEFECT_IDS, CITATIONS)` where STATUS is `framework_term_lawful` / `framework_term_unlawful` / `call_off_lawful` / `call_off_unlawful`; citation: eu_dir_2014_24_art_33_para_1, eu_dir_2014_24_art_33_para_2, eu_dir_2014_24_art_33_para_3, eu_dir_2014_24_art_33_para_4, eu_dir_2014_24_art_33_para_5.
- `framework_agreements_status(PROFILE, ROUTE)`: route classification; ROUTE is one of the five route atoms; citation: eu_dir_2014_24_art_33_para_3, eu_dir_2014_24_art_33_para_4.
- `framework_agreements_checklist(PROFILE, CHECKLIST)`: enumerates all fired defects as a list of `item(LIMB_ID, STATUS, CITATION)` terms; citation: all five paragraph keys.
- `framework_agreements_what_if(PROFILE, KEY, VALUE, RESULT)`: threshold boundary probe — overrides one profile key and re-runs the decision; RESULT is the modified verdict; citation: eu_dir_2014_24_art_33_para_1 (four-year boundary).
- `fixtures(FIXTURE_ID, PROFILE)`: test fixture generator; each fixture is a named profile dict.

## Internal predicates (implementation, not in scaffold facade)

- `decide_framework_term(PROFILE, framework_term_verdict(STATUS, DEFECT_IDS, CITATIONS))`: framework-term determination; STATUS in {framework_term_lawful, framework_term_unlawful}; two limb IDs.
- `decide_call_off(PROFILE, call_off_verdict(STATUS, ROUTE, DEFECT_IDS, CITATIONS))`: call-off determination; STATUS in {call_off_lawful, call_off_unlawful}; ROUTE from five atoms; seventeen limb IDs.
- `call_off_route(PROFILE, ROUTE)`: route classification alone; must agree with ROUTE inside the verdict.
- `framework_term_limit_date(FRAMEWORK_START_DATE, LIMIT_DATE)`: computes the fourth-anniversary limit date with 29-February clamp; one triple in, one triple out.
- `framework_term_within_limit(FRAMEWORK_START_DATE, FRAMEWORK_END_DATE, STATUS)`: applies the four-year rule with no exceptional-case escape; STATUS in {within_four_year_limit, exceeds_four_year_limit}.
- `call_off_award_window_status(FRAMEWORK_START_DATE, FRAMEWORK_END_DATE, CALL_OFF_AWARD_DATE, STATUS)`: closed-interval window check; STATUS in {award_date_within_framework_term, award_date_outside_framework_term}.

## Planned reuse (kit / backbone imports)

- `formalize_lib` — MANDATORY: `profile_get/3`, `check_true/4`, `check_false/4`, `eval_requirements/4`, `assess/6`, `item/3`, `met`, `unmet/1`, `cite/1`, `labels/3`, `assessment/3`. Used for the checklist engine and profile access.
- `kit.dates` — `date_from_triple/2` to lift [Y,M,D] triples to native date objects for internal lexicographic comparison and anniversary arithmetic.
- `date_time` — `date/4`, `days_between/3` for internal date arithmetic (anniversary computation, window comparison). Dates cross the public boundary as date(Y, M, D) terms.
- `kit.query_combinators` — `what_if/5` (or `override_key/4` + re-decide) for the `framework_agreements_what_if/4` facade; `flip_scan/4` for the threshold boundary probe.
- `validate_props` — `run_props/1`, `prop_totality/3`, `prop_determinism/3` for the test harness.
- `citations` — shared lexicon; this domain ships LEXICON-ENTRIES.yaml with the five paragraph keys above.

**NOT imported:** `eu.procurement.directive_2014_24.vocabulary` (no contract-type, authority-type, or procedure-type vocabulary is used by any Art 33 clause); `currency_vocab` (no monetary values); `kit.compliance_lib` (not a compliance-check shape); `kit.deadline_lib` (no deadline computation); `kit.optimization_lib` (no planning); `kit.planner_lib` (no planning); `kit.rolling_window` (no look-back window).

**Genuinely local vocabulary (declared in framework_agreements.clausal, not in kernel):**
- All 21 profile key atoms
- Both call-off method atoms: `without_reopening_competition`, `with_reopening_competition`
- Five route atoms: `single_operator_direct_award`, `multi_operator_direct_award_all_terms_set_out`, `multi_operator_direct_award_under_split_framework`, `multi_operator_reopened_competition`, `no_lawful_route`
- Two framework-term status atoms: `framework_term_lawful`, `framework_term_unlawful`
- Two call-off status atoms: `call_off_lawful`, `call_off_unlawful`
- Two date-surface status pairs: `within_four_year_limit` / `exceeds_four_year_limit`; `award_date_within_framework_term` / `award_date_outside_framework_term`
- Two framework-term limb IDs: `framework_term_exceeds_four_year_limit`, `framework_term_exceptional_case_not_duly_justified`
- Seventeen call-off limb IDs (listed in order below)
- Verdict constructors: `framework_term_verdict/3`, `call_off_verdict/4`, `framework_agreements_verdict/3`

**Shared with kernel.clausal (and only that):**
- `cite/1` functor (if not already in formalize_lib — verify; if formalize_lib exports it, do NOT re-declare)
- `item/3` functor (same caveat)
- The `verdict_vocabulary/2` fact table mapping limb IDs to their citation keys (shared so both the term and call-off slices reference the same lexicon entries)

## Determination slice: framework_agreements.clausal

### Statutory value facts owned by this file

- `framework_term_limit_years(4)` — the four-year maximum term of Art 33(1). Sourced from `parameters.clausal`; this file references it via `framework_term_limit_years(YEARS)` in a clause body (does NOT re-declare the fact; the fact lives in parameters.clausal, but the KEY SET must be equal and the key must appear as `framework_term_limit_years(` in a non-parameters file).
- No other numeric constants: the 29-February clamp, the exclusive boundary, and the single-versus-several switch are structural rules, not parameterised figures.

### Rules / requirements (19 total: 2 term + 17 call-off)

**Framework term limbs (2, in verdict_vocabulary order):**

1. `framework_term_exceeds_four_year_limit` — scope: ALWAYS. Fires where `framework_term_within_limit` returns `exceeds_four_year_limit` AND `exceptional_case_duly_justified` is False. Citation: eu_dir_2014_24_art_33_para_1.
2. `framework_term_exceptional_case_not_duly_justified` — scope: ALWAYS. Fires where `framework_term_within_limit` returns `exceeds_four_year_limit` AND `exceptional_case_duly_justified` is False. Citation: eu_dir_2014_24_art_33_para_1.

(Both limbs fire together or not at all: the save clause cures both simultaneously.)

**Call-off limbs (17, in verdict_vocabulary order):**

1. `call_off_awarded_outside_framework_term` — scope: ALWAYS. Fires where `call_off_award_window_status` returns `award_date_outside_framework_term`. Citation: eu_dir_2014_24_art_33_para_2.
2. `contracting_authority_not_identified_in_call_for_competition` — scope: ALWAYS. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_2.
3. `economic_operator_not_party_to_framework` — scope: ALWAYS. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_2.
4. `substantial_modification_of_framework_terms` — scope: ALWAYS (NOT restricted to single-operator; the "in particular" tail is emphasis, not scope). Fires where `call_off_entails_substantial_modification` is TRUE. Citation: eu_dir_2014_24_art_33_para_2.
5. `call_off_outside_limits_of_framework_terms` — scope: FRAMEWORK_OPERATOR_COUNT < 2 ONLY (Art 33(3) says so in terms). Fires where `call_off_within_limits_of_framework_terms` is False. Citation: eu_dir_2014_24_art_33_para_3.
6. `reopening_competition_in_single_operator_framework` — scope: FRAMEWORK_OPERATOR_COUNT < 2 ONLY. Fires where `call_off_method_key` is `with_reopening_competition`. Citation: eu_dir_2014_24_art_33_para_3, eu_dir_2014_24_art_33_para_4.
7. `direct_award_without_all_terms_set_out` — scope: the TWO multi-operator direct routes only (`multi_operator_direct_award_all_terms_set_out` and `multi_operator_direct_award_under_split_framework`). Fires where `framework_sets_out_all_terms` is False. Citation: eu_dir_2014_24_art_33_para_4.
8. `objective_conditions_for_determining_performer_not_indicated` — scope: the TWO multi-operator direct routes only. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_4.
9. `objective_criteria_for_choice_of_route_not_stated` — scope: FRAMEWORK_OPERATOR_COUNT >= 2 AND `partly_with_partly_without_reopening_stipulated` is True (both halves of a split framework). Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_4.
10. `terms_subject_to_reopening_not_specified` — scope: same as (9). Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_4.
11. `reopening_not_available_where_framework_sets_out_all_terms` — scope: FRAMEWORK_OPERATOR_COUNT >= 2. Fires where ROUTE is `no_lawful_route`. Citation: eu_dir_2014_24_art_33_para_4.
12. `reopened_competition_not_based_on_framework_terms` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.
13. `capable_operators_not_all_consulted_in_writing` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.
14. `time_limit_not_sufficiently_long` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.
15. `tenders_not_submitted_in_writing` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.
16. `tender_contents_opened_before_time_limit_expired` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.
17. `award_not_made_on_framework_award_criteria` — scope: ROUTE is `multi_operator_reopened_competition` ONLY. Fires where the flag is False. Citation: eu_dir_2014_24_art_33_para_5.

### Verdict vocabulary (this slice)

- `framework_term_lawful`, `framework_term_unlawful`
- `call_off_lawful`, `call_off_unlawful`
- Five route atoms (listed above)
- `within_four_year_limit`, `exceeds_four_year_limit`
- `award_date_within_framework_term`, `award_date_outside_framework_term`
- `framework_term_verdict(STATUS, DEFECT_IDS, CITATIONS)`
- `call_off_verdict(STATUS, ROUTE, DEFECT_IDS, CITATIONS)`
- `framework_agreements_verdict(STATUS, DEFECT_IDS, CITATIONS)`

### Vocabulary shared with kernel.clausal

- `cite/1` (if not already exported by formalize_lib; verify before declaring)
- `item/3` (same caveat)
- `verdict_vocabulary(LIMB_ID, CITATION_KEY)` fact table (shared reference so both determinations cite from the same lexicon)
- The two call-off method atoms: `without_reopening_competition`, `with_reopening_competition` (referenced by both the route rule and the limb scope tests; declared once in kernel so both the term and call-off slices can see them without circular import)
