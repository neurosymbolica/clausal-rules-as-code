# SIGNATURE — eu/dma_art_5_2_data_combination_order

Shape family: deontic. Predicate prefix: `dma_art_5_2_data_combination_order_`. Layout (unchanged):

`kernel -> citations -> parameters -> dma_art_5_2_data_combination_order -> queries -> fixtures -> package facade`

## Public query surface (summary)

The called contract has three queries plus the input check:

- `article_5_application_status/4`
- `personal_data_practice_status/4`
- `consent_request_repetition_status/6`
- `dma_art_5_2_data_combination_order_input_problems/2`

The facade wraps `personal_data_practice_status/4` as the package verdict:

- `decide_dma_art_5_2_data_combination_order(PROFILE, dma_art_5_2_data_combination_order_verdict(STATUS, CITATIONS))`
- `dma_art_5_2_data_combination_order_status(PROFILE, STATUS)`

**Totality and determinism.** Every query yields EXACTLY ONE solution for every input term, and the input check never fails and never raises. This is achieved without cut, without `->` and without `*->`:

- each input is first mapped by a classifier to exactly one state;
- a decision table over those states is chosen by mutually exclusive head patterns.

**No imported figures.** The only statutory figures are the one-year period and the single permitted repeat. Both are declared in the slice (`constant_value`).

## Verdict STATUS atoms (replace the placeholders `required / permitted / not_applicable`)

**Final atoms:**

- `article_5_application_status`:
  - `article_5_obligations_apply`
  - `article_5_obligations_do_not_apply`
- `personal_data_practice_status` (the facade STATUS):
  - `practice_allowed_with_consent`
  - `practice_allowed_on_other_legal_basis`
  - `practice_prohibited`
  - `practice_outside_article_5_2`
  - `article_5_obligations_do_not_apply`
- `consent_request_repetition_status`:
  - `repeated_request_permitted`
  - `repeated_request_not_permitted`
  - `request_after_one_year_period`
  - `article_5_obligations_do_not_apply`

**Not-final status compounds.** Each appears in the RESULT position itself, never inside a list:

- `indeterminate([Key])`, with exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(eu_reg_2022_1925_art_5_2)), [inputs_relied_on(Pairs)])`
- `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

**Result constructors.** These are exported and never queried, with exact arities:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`
- `resolution/2`, `inputs_relied_on/1`, `provenance/2`
- `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- `cite/1` and `'-'/2`

## Profile keys (root_exports order = input_contract order)

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`, presence first and then value.

1. `designated_as_gatekeeper_for_core_platform_service`
   - Kind: OUTSIDE FACT.
   - Value: `attested(true|false, attestation(By, At, Reason, Evidence))`.
   - Target: `commission_designation_decision`.
   - Citation: `eu_reg_2022_1925_art_5_1`.
2. `practice_under_article_5_2`
   - Kind: PRACTICE.
   - Values: `processing_for_online_advertising_services`, `combining_personal_data`, `cross_using_personal_data`, `signing_in_end_users_to_combine_personal_data`, `none_of_the_four_practices`, `unsure`.
3. `end_user_presented_with_specific_choice`
   - Kind: JUDGEMENT.
   - Values: `true`, `false`, `unsure`.
4. `end_user_consent_given`
   - Kind: OUTSIDE FACT.
   - Target: `digital_markets_end_user_consent_statement`.
   - Citation: `eu_reg_2022_1925_art_5_2`.
5. `gatekeeper_may_rely_on_article_6_1_c_d_or_e`
   - Kind: OUTSIDE FACT.
   - Target: `digital_markets_article_6_1_c_d_e_basis_statement`.
   - Citation: `eu_reg_2022_1925_art_5_2`.
6. `consent_request_already_repeated_in_period`
   - Kind: CRISP.
   - Values: `true`, `false`.
   - Read only by `consent_request_repetition_status`.

**Evidence values.** Evidence is `url(Url, RetrievedAt)`, `document(UploadIdentifier, Sha256)` or `none`. All four attestation arguments must be ground and are otherwise uninspected.

**Fetching.** The fetcher is `none` for all three outside facts, so only `attested` is read.

**Date arguments.** These are query arguments, not profile keys: `RefusalDate` and `RequestDate`, each `date(Year, Month, Day)` with three bare integers, year 1 to 9999.

## Citation-key atoms (canonical lexicon, never shortened)

- `eu_reg_2022_1925_art_5_1`: Art 5(1), scope of Article 5.
- `eu_reg_2022_1925_art_5_2`: Art 5(2), the prohibition, the repeated-request limit and the Art 6(1)(c)(d)(e) proviso.
- `eu_reg_2022_1925_art_5_2_a`: Art 5(2)(a).
- `eu_reg_2022_1925_art_5_2_b`: Art 5(2)(b).
- `eu_reg_2022_1925_art_5_2_c`: Art 5(2)(c).
- `eu_reg_2022_1925_art_5_2_d`: Art 5(2)(d).
- `eu_reg_2022_1925_art_2_32`: Art 2(32), consent.

**Outside-fact targets** (used as `cite(Target)` in referrals):

- `commission_designation_decision`
- `digital_markets_end_user_consent_statement`
- `digital_markets_article_6_1_c_d_e_basis_statement`

## Public predicates

**Called contract:**

- `article_5_application_status(Profile, Result, Basis, Citations)`: whether the Article 5 obligations apply to the listed core platform service. LIMBS steps 0 to 3. Cites `eu_reg_2022_1925_art_5_1`.
- `personal_data_practice_status(Profile, Result, Basis, Citations)`: whether Art 5(2) prohibits, allows with consent, allows on another legal basis, or does not reach one practice. LIMBS steps 0 and 4 to 15. Cites `eu_reg_2022_1925_art_5_1`, `eu_reg_2022_1925_art_5_2`, the point key, and `eu_reg_2022_1925_art_2_32` when consent allows.
- `consent_request_repetition_status(Profile, RefusalDate, RequestDate, Result, Basis, Citations)`: whether a repeated consent request on RequestDate is permitted within the one-year period from RefusalDate. LIMBS steps 0 and 16 to 21. Cites `eu_reg_2022_1925_art_5_1` and `eu_reg_2022_1925_art_5_2`. Query type #15.
- `dma_art_5_2_data_combination_order_input_problems(Profile, Problems)`: the input check. Problems is a bare list, `[]` when the profile is well-formed. Implements the typed input contract.

**Facade:**

- `decide_dma_art_5_2_data_combination_order(Profile, Verdict)`: Verdict is `dma_art_5_2_data_combination_order_verdict(Status, Citations)`, with Status and Citations copied from `personal_data_practice_status/4`. Cites Art 5(1), Art 5(2) and its points, and Art 2(32).
- `dma_art_5_2_data_combination_order_status(Profile, Status)`: the RESULT of `personal_data_practice_status/4` only. Same citations.
- `dma_art_5_2_data_combination_order_checklist(Profile, Checklist)`: the query type #7 justification. Checklist is a list of `item(RequirementIdentifier, Status, cite(Key))` built with `eval_requirements/4` over `requirement/4`. Each item cites its rule: Art 5(1), Art 5(2) point, Art 5(2), Art 2(32) and Art 5(2).
- `dma_art_5_2_data_combination_order_what_if(Profile, Key, Value, Status)`: Status is the facade STATUS after replacing or adding `attribute(Key, Value)`. Uses kit `what_if/5` with the closure `dma_art_5_2_data_combination_order_status`. Cites Art 5(2).
- `dma_art_5_2_data_combination_order_one_year_period_end(RefusalDate, Anniversary)`: the deadline helper for query type #15. Anniversary is the first day on which the second-subparagraph limit no longer applies, written as a `date(Year, Month, Day)` triple, which may be in year 10000. It fails cleanly when RefusalDate is not a valid date. Cites `eu_reg_2022_1925_art_5_2`.

**Fixtures:**

- `dma_art_5_2_data_combination_order_fixture(Name, Profile)`: the named profiles listed in the slice section.
- `dma_art_5_2_data_combination_order_date_fixture(Name, RefusalDate, RequestDate)`: the named date pairs listed in the slice section.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` for presence-first reads;
  - `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1` for the checklist;
  - `attribute/2`;
  - `memberd/2` for the deterministic key-membership test in the input check.
- **kit/deadline_lib**: `month_last_day/3`, used to check the Gregorian real-day rule and to clamp 29 February to 28 February.
- **kit/query_combinators**: `what_if/5`, for the facade what_if.
- **validate_props** (tests only):
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `prop_boundary_coverage/2`.

**Considered and not used:**

- kit/compliance_lib: this order has one norm with fixed exits, not a lattice of competing norms.
- `deadline_months_after/3`: it gives the LAST DAY of a period counted from the day after the anchor, not the same-day anniversary this order needs.
- `check_tri/4`: practice classification is a five-plus-unsure vocabulary, and the order's precedence is not Kleene conjunction.
- `assess/6` labels: the verdict comes from the ordered LIMBS table, not from met/unmet/unknown aggregation.

**Native datetime.** library(datetime) is not used for the ANNIVERSARY comparison. The reasons are in NOTES decision 10:

- `date/3` does not exist yet;
- the anniversary may fall in year 10000.

All arithmetic is whole calendar days by integer triples, with no hand-rolled day count.

## kernel.clausal

The kernel holds only predicates SHARED between slices. There is one determination slice, so nothing domain-specific is shared. The kernel keeps:

- the result-constructor exports listed above;
- `cite/1`;
- the root_exports key order fact `dma_art_5_2_data_combination_order_root_key(Position, Key)` for positions 1 to 6, so that queries and fixtures use one order.

## citations.clausal

This file holds `citation_vocabulary` facts for the seven citation keys and the three targets, with their pinned unit identifiers:

- `parag_005.001`, `parag_005.002`
- `point_005.002_a`, `point_005.002_b`, `point_005.002_c`, `point_005.002_d`
- `point_002_32`

The pin data is recorded as provenance: source sha256 `d6af21a4f11c2b001b0486391fbd0813deba32305fb0d3865fbceccd45b827eb`, OJ L 265, 12.10.2022.

## parameters.clausal

No shared parameters. The statutory values live in the slice. This file stays as a documented pass-through (no TODO).

## Slice: dma_art_5_2_data_combination_order.clausal

### Value facts owned by this slice

**Statutory figures:**

- `:- constant_value(consent_request_period_years, 1).`: the period of the second subparagraph of Art 5(2).
- `:- constant_value(repeated_requests_permitted_in_period, 1).`: 'not ... more than once'.
- Leap-day rule: when month 2 and day 29, the anniversary day is 28 (reading (8)).

**Point table** `practice_point_citation(PracticeAtom, CitationKey)`:

- `processing_for_online_advertising_services` → `eu_reg_2022_1925_art_5_2_a`
- `combining_personal_data` → `eu_reg_2022_1925_art_5_2_b`
- `cross_using_personal_data` → `eu_reg_2022_1925_art_5_2_c`
- `signing_in_end_users_to_combine_personal_data` → `eu_reg_2022_1925_art_5_2_d`

**Outside-fact table** `outside_fact_entry(Key, CitationKey, Target)`, in referral order:

- designation → `eu_reg_2022_1925_art_5_1`, `commission_designation_decision`
- consent → `eu_reg_2022_1925_art_5_2`, `digital_markets_end_user_consent_statement`
- Art 6 basis → `eu_reg_2022_1925_art_5_2`, `digital_markets_article_6_1_c_d_e_basis_statement`

**Key-type table** `contract_key_type(Key, Type)`, with Type one of:

- `outside_fact`
- `one_of([...practice atoms..., unsure])`
- `one_of([true, false, unsure])`
- `one_of([true, false])`

### Rules

**Input check:**

- **R0 input check.** `dma_art_5_2_data_combination_order_input_problems/2` decides in this order:
  - A Profile that is not a proper list of `attribute(_, _)` gives `[wrong_type(profile)]`. This covers an unbound profile, a partial list, an unbound element and a non-attribute element.
  - Otherwise, for each contract key in order:
    - `duplicate_key(Key)` if the key occurs more than once, without reading its values;
    - else `wrong_type(Key)` if its present value is outside its type. An unbound value, or an attestation argument that holds an unbound variable, is wrong_type.
  - Then `unknown_key(Key)` once per non-contract key, in first-occurrence order. A non-atom key is reported as given.
  - Implementation: structural tests (`is_list`-free recursion on `[]` and `[_|_]` with `nonvar` guards, `ground/1` on attestation arguments). Exactly one solution.

**Classifier:**

- **R1 state classifier.** For a well-formed profile, map each key to exactly one state:
  - outside fact: `fact_true(Attested)`, `fact_false(Attested)` or `fact_absent`;
  - practice: `point(CitationKey)`, `none_of_the_four_practices`, `unsure` or `absent`;
  - judgement: `true`, `false`, `unsure` or `absent`;
  - crisp: `true`, `false` or `absent`.

**article_5_application_status (Art 5(1)):**

- **R2.** Designation `fact_true` gives `article_5_obligations_apply`.
- **R3.** Designation `fact_false` gives `article_5_obligations_do_not_apply`.
- **R4.** Designation `fact_absent` gives a designation referral with Pairs `[designated_as_gatekeeper_for_core_platform_service-absent]`.

**personal_data_practice_status, LIMBS steps 4 to 15.** These are encoded as a decision over the state tuple. Each clause head folds its ground RESULT (C17), and the guards make the clauses disjoint.

- **Step 4.** Designation false: `article_5_obligations_do_not_apply`.
- **Step 5.** Designation true and practice none: `practice_outside_article_5_2`.
- **Step 6.** Designation true, a point, choice true and consent true: `practice_allowed_with_consent`. Citations are Art 5(1), Art 5(2), the point and Art 2(32). Basis is designation and consent.
- **Step 7.** Designation true, a point, consent route fails, Art 6 basis true: `practice_allowed_on_other_legal_basis`. Citations are Art 5(1), Art 5(2) and the point. Basis is designation and the Art 6 fact.
  - The consent route fails when choice is false or consent is false.
- **Step 8.** As step 7 with the Art 6 basis false: `practice_prohibited`. Same citations and basis shape, and the consent fact is never copied.
- **Step 9.** Practice absent: `indeterminate([practice_under_article_5_2])`.
- **Step 10.** Choice absent, practice not none, consent not false: `indeterminate([end_user_presented_with_specific_choice])`.
- **Step 11.** Designation absent: designation referral.
- **Step 12.** Consent absent and choice not false: consent referral.
- **Step 13.** Art 6 basis absent and not (choice true and consent true): Art 6 basis referral.
- **Step 14.** Practice unsure: `open_textured(practice_under_article_5_2, cite(eu_reg_2022_1925_art_5_2))`.
- **Step 15.** Choice unsure: `open_textured(end_user_presented_with_specific_choice, cite(eu_reg_2022_1925_art_5_2))`.

**PAIRS rule** for steps 11 to 15:

- Take the present pairs of `practice_under_article_5_2` and `end_user_presented_with_specific_choice`, unsure values included.
- For a cross-reference referral, merge in `Key-absent` for the referred fact.
- Order the whole list by root_exports.

**consent_request_repetition_status (Art 5(1), Art 5(2) second subparagraph):**

- **R5 date check.** `valid_calendar_date(date(Year, Month, Day))` holds when all three are integers, `1 =< Year =< 9999`, `1 =< Month =< 12`, and `1 =< Day =< LastDay` with `month_last_day(Year, Month, LastDay)`.
  - Problems are the profile problems, then `wrong_type(refusal_date)`, then `wrong_type(request_date)`.
  - `wrong_type(request_date)` is given when RequestDate is invalid, or when both dates are valid and RequestDate is before RefusalDate.
- **R6 anniversary.** `one_year_anniversary(date(Year, Month, Day), date(NextYear, Month, AnniversaryDay))` with:
  - `NextYear is Year + consent_request_period_years`;
  - AnniversaryDay 28 when Month 2 and Day 29, else Day.
- **R7 within period.** RequestDate is lexicographically less than the anniversary on integer triples. This is `calendar_triple_before/2`, two exclusive clause families (before / not before).
- **Steps 16 to 21:**
  - **Step 16.** Designation false: `article_5_obligations_do_not_apply`.
  - **Step 17.** Designation true and not within the period: `request_after_one_year_period`.
  - **Step 18.** Designation true, within the period and crisp true: `repeated_request_not_permitted`.
  - **Step 19.** Designation true, within the period and crisp false: `repeated_request_permitted`.
  - **Step 20.** Within the period and crisp absent, designation true or absent: `indeterminate([consent_request_already_repeated_in_period])`.
  - **Step 21.** Designation absent, otherwise: designation referral with Pairs `[designated_as_gatekeeper_for_core_platform_service-absent]`.
- **Basis and citations.**
  - Final answers have Basis `[outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)]`.
  - Citations are `[cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2)]`, except step 16, which cites Art 5(1) only.

**Checklist:**

- **R8 checklist requirements.** `requirement(RequirementIdentifier, Profile, Status, Citation)`, RequirementIdentifier first, with three exclusive clauses each (met / unmet / unknown):
  - `service_listed_in_designation_decision`: Art 5(1).
  - `practice_within_article_5_2`: the point citation, or Art 5(2) when the practice is none or unsure.
  - `specific_choice_presented`: Art 5(2).
  - `consent_given_within_regulation_2016_679`: Art 2(32).
  - `article_6_1_c_d_or_e_basis_available`: Art 5(2).
- **Statuses.** An absent key gives `unknown([Key])`. An unsure key gives `unknown([Key])` and is never invented as met.

### Verdict atoms of this slice

All the final atoms and status compounds listed above.

### Predicates shared with another slice

None. Only the root key order and the constructors sit in the kernel.

### Fixtures and tests (seven test modes)

**Profile fixtures:**

- `listed_combining_with_consent`: step 6.
- `listed_cross_use_no_choice_legal_obligation`: step 7.
- `listed_sign_in_consent_refused_no_basis`: step 8. Consent is attested false, and the basis omits consent.
- `listed_none_of_the_four`: step 5.
- `not_listed_everything_unsure`: step 4.
- `practice_missing`: step 9.
- `choice_missing`: step 10.
- `choice_missing_consent_refused_basis_true`: step 7, the choice is not named.
- `designation_absent_complete`: step 11.
- `consent_absent`: step 12.
- `basis_absent`: step 13.
- `practice_unsure_complete`: step 14.
- `choice_unsure_consent_true`: step 15.
- `duplicate_and_unknown_keys`: R0.
- `unbound_attestation_reason`: wrong_type.
- `partial_list_profile`: `wrong_type(profile)`.

**Date fixtures:**

- the refusal day itself;
- the day before the anniversary;
- the anniversary day;
- refusal on 2024-02-29 with requests on 2025-02-27 (within) and 2025-02-28 (after);
- refusal in 9999;
- request before refusal;
- 2023-02-29 invalid;
- `date(2025, 13, 1)` invalid;
- non-integer components.

**Test modes:**

- per-step positive and paired negative tests;
- exactly-one-solution counts via `findall` and `length/2`;
- totality and determinism properties;
- citation completeness;
- missing-key coverage;
- boundary coverage at the anniversary;
- input-check ordering.
