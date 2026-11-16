# SIGNATURE — eu/data_act_connected_product_data_sharing

Public query surface. The four contract queries `product_design_duty_status(PROFILE, RESULT, CITATIONS)`, `pre_contract_information_duty_status(PROFILE, RESULT, CITATIONS)`, `user_access_request_status(PROFILE, RESULT, CITATIONS)` and `third_party_sharing_request_status(PROFILE, RESULT, CITATIONS)` (names fixed by the order's called contract, so they carry no package prefix), the input check `data_act_connected_product_data_sharing_input_problems(PROFILE, PROBLEMS)`, and the scaffold facade `decide_data_act_connected_product_data_sharing(PROFILE, data_act_connected_product_data_sharing_verdict(STATUS, CITATIONS))`, `data_act_connected_product_data_sharing_status(PROFILE, STATUS)`, `data_act_connected_product_data_sharing_checklist(PROFILE, CHECKLIST)`, `data_act_connected_product_data_sharing_what_if(PROFILE, KEY, VALUE, STATUS)` serving query type #2 (eligibility of the user's access request, Art 4). Every public predicate is TOTAL (one answer for every term, the input check included, never raising) and DETERMINISTIC (exactly one solution; a correct answer yielded twice is wrong). No figure is imported: the order contains no numeric threshold and no date arithmetic.

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

Query RESULT atoms (final):
- product_design_duty_status: `design_duty_met`, `design_duty_not_met`, `not_applicable`.
- pre_contract_information_duty_status: `information_duty_met`, `information_duty_not_met`, `not_applicable`.
- user_access_request_status: `access_due`, `not_applicable`, `refusal_permitted_security_restriction`, `personal_data_not_to_be_made_available`, `withholding_permitted_trade_secrets`.
- third_party_sharing_request_status: `sharing_due`, `not_applicable`, `third_party_not_eligible_gatekeeper`, `personal_data_not_to_be_made_available`, `trade_secret_disclosure_not_permitted`, `withholding_permitted_trade_secrets`.

Non-final RESULTs (every query, CITATIONS always []): `indeterminate([KEY])` (one-key list; the bare atom indeterminate is NEVER written), `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`, `input_problems(PROBLEMS)`.

Facade eligibility STATUS (query type #2, over user_access_request_status): `eligible` (access_due), `ineligible` (any other final RESULT), or the non-final RESULT passed through unchanged.

Checklist item statuses (formalize_lib): `met`, `unmet(REASON)`, `unknown([KEY])`. Checklist labels for assess/6: `labels(requirements_met, requirements_unknown, requirements_unmet)` (internal; never the bare atom indeterminate).

Result constructors (exported, never called as queries): input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2.

The atoms true and false are never pinned in verdict_vocabulary or root_exports.

## Profile keys

PROFILE = [attribute(KEY, VALUE), ...], read ONLY with formalize_lib profile_get/3 (presence first, then value). Bare values; attested(...) is wrong_type. No numeric or date keys exist (no unit suffix needed; the market-placement date is a caller boolean). Order below = order of root_exports, of input_contract, and of every query's decision order.

| # | key | type | read by |
|---|-----|------|---------|
| 1 | connected_product_or_related_service | judgement | design, information, access, sharing |
| 2 | small_enterprise_exemption_applies | judgement | design, information, access, sharing |
| 3 | placed_on_market_after_12_september_2026 | boolean | design |
| 4 | data_accessible_by_default_as_required | judgement | design |
| 5 | directly_accessible_where_relevant_and_feasible | judgement | design |
| 6 | pre_contract_contract_kind | enum: purchase_rent_or_lease_of_connected_product, provision_of_related_service | information |
| 7 | required_information_provided_before_contract | judgement | information |
| 8 | requester_is_user | judgement | access |
| 9 | request_by_or_on_behalf_of_user | judgement | sharing |
| 10 | addressee_is_data_holder | judgement | access, sharing |
| 11 | requested_data_readily_available | judgement | access, sharing |
| 12 | data_directly_accessible_by_user | judgement | access |
| 13 | security_restriction_agreed_applies | judgement | access |
| 14 | testing_data_not_yet_on_market | boolean | sharing |
| 15 | third_party_use_contractually_permitted | boolean | sharing |
| 16 | third_party_is_designated_gatekeeper | judgement | sharing |
| 17 | other_persons_personal_data_requested | boolean | access, sharing |
| 18 | gdpr_conditions_for_making_available_met | judgement | access, sharing |
| 19 | requested_data_identified_as_trade_secrets | boolean | access, sharing |
| 20 | trade_secret_disclosure_strictly_necessary | judgement | sharing |
| 21 | trade_secret_measures_agreed_and_kept | judgement | access, sharing |
| 22 | exceptional_trade_secret_refusal_invoked | boolean | access, sharing |

Judgement: true | false | unsure. Boolean: true | false (unsure is wrong_type). Fifteen judgements, six booleans, one enum.

## Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml; never shortened)

Definitions: eu_reg_2023_2854_art_2_5, eu_reg_2023_2854_art_2_6, eu_reg_2023_2854_art_2_12, eu_reg_2023_2854_art_2_13, eu_reg_2023_2854_art_2_15, eu_reg_2023_2854_art_2_16, eu_reg_2023_2854_art_2_17.
Article 3: eu_reg_2023_2854_art_3_1, eu_reg_2023_2854_art_3_2, eu_reg_2023_2854_art_3_2_a, eu_reg_2023_2854_art_3_2_b, eu_reg_2023_2854_art_3_2_c, eu_reg_2023_2854_art_3_2_d, eu_reg_2023_2854_art_3_3, eu_reg_2023_2854_art_3_3_a, eu_reg_2023_2854_art_3_3_b, eu_reg_2023_2854_art_3_3_c, eu_reg_2023_2854_art_3_3_d, eu_reg_2023_2854_art_3_3_e, eu_reg_2023_2854_art_3_3_f, eu_reg_2023_2854_art_3_3_g, eu_reg_2023_2854_art_3_3_h, eu_reg_2023_2854_art_3_3_i.
Article 4: eu_reg_2023_2854_art_4_1, eu_reg_2023_2854_art_4_2, eu_reg_2023_2854_art_4_6, eu_reg_2023_2854_art_4_7, eu_reg_2023_2854_art_4_8, eu_reg_2023_2854_art_4_12.
Article 5: eu_reg_2023_2854_art_5_1, eu_reg_2023_2854_art_5_2, eu_reg_2023_2854_art_5_3, eu_reg_2023_2854_art_5_7, eu_reg_2023_2854_art_5_9, eu_reg_2023_2854_art_5_10, eu_reg_2023_2854_art_5_11.
Exemption and dates: eu_reg_2023_2854_art_7_1, eu_reg_2023_2854_art_7_t1, eu_reg_2023_2854_art_50_t2, eu_reg_2023_2854_art_50_t3.

Load-bearing in RESULT or referral citations: art_2_5, art_2_12, art_2_13, art_2_17, art_3_1, art_3_2, art_3_3, art_4_1, art_4_2, art_4_7, art_4_8, art_4_12, art_5_1, art_5_3, art_5_7, art_5_9, art_5_10, art_5_11, art_7_1 (all with the eu_reg_2023_2854_ prefix). The others are recorded in citations.clausal with their verbatim text and pin hashes as provenance of the readings (points of Art 3(2) and 3(3), Art 2(6), (15), (16), Art 4(6), Art 5(2), Art 7(1) second subparagraph, Art 50). Lint note: the segments `reg` and `art` are fixed by the canonical lexicon; if C6 flags them, add `% lint: allow-abbreviation canonical-citation-key` beside the citation facts, never rename. The key `gdpr_conditions_for_making_available_met` is fixed by the contract likewise.

## Public predicates

- `product_design_duty_status(Profile, Result, Citations)`: Art 3(1) design duty: design_duty_met / design_duty_not_met / not_applicable, final CITATIONS [cite(eu_reg_2023_2854_art_3_1)]; or a non-final RESULT with [] + Art 3(1), Art 50 third paragraph, Art 7(1), Art 2(5).
- `pre_contract_information_duty_status(Profile, Result, Citations)`: Art 3(2)/(3) information duty: information_duty_met / information_duty_not_met (CITATIONS [cite(eu_reg_2023_2854_art_3_2)] or [cite(eu_reg_2023_2854_art_3_3)] by kind) / not_applicable ([cite(eu_reg_2023_2854_art_3_2), cite(eu_reg_2023_2854_art_3_3)]) + Art 3(2), 3(3), Art 7(1), Art 2(5).
- `user_access_request_status(Profile, Result, Citations)`: Art 4 user access request: limbs (3.1) to (3.6) + Art 4(1), 4(2), 4(7), 4(8), 4(12).
- `third_party_sharing_request_status(Profile, Result, Citations)`: Art 5 third-party sharing request: limbs (4.1) to (4.7) + Art 5(1), 5(2), 5(3), 5(7), 5(9), 5(10), 5(11).
- `data_act_connected_product_data_sharing_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract; [] when well-formed + the order's INTERFACE - THE INPUT CHECK.
- `decide_data_act_connected_product_data_sharing(Profile, Verdict)`: Verdict = data_act_connected_product_data_sharing_verdict(Status, Citations), Status the eligibility STATUS over user_access_request_status, Citations those of that query + Art 4.
- `data_act_connected_product_data_sharing_status(Profile, Status)`: the eligibility STATUS alone (eligible / ineligible / non-final passthrough) + Art 4(1).
- `data_act_connected_product_data_sharing_checklist(Profile, Checklist)`: cited checklist of the Art 4 conditions, items item(RequirementId, Status, cite(KEY)) via formalize_lib assess/6 + Art 2(5), 7(1), 2(12), 2(13), 2(17), 4(1), 4(2), 4(12), 4(7), 4(8).
- `data_act_connected_product_data_sharing_what_if(Profile, Key, Value, Status)`: eligibility STATUS after setting Key to Value (formalize_lib profile_set/3, then status/2; the input check applies to the edited profile) + Art 4.
- `data_act_connected_product_data_sharing_fixture(Name, Profile)`: named fixture profiles (fixtures.clausal).
- `data_act_connected_product_data_sharing_fixture_expectation(Name, Query, Result, Citations)`: expected answer per fixture and query.

## Planned reuse (manifest `uses:`)

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, check_tri/4, check_tri_neg/4, check_true/4, check_false/4, assess/6, eval_requirements/4, not_defeated/3, memberd/2, not_member/2, attribute/2, item/3, unmet/1, unknown/1, labels/3, assessment/3.
- validate_props: run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_missing_key_coverage/3, bad_citation/1 (tests only).
- kit.query_combinators: not needed for what_if (attribute lists, not dicts: profile_set/3 is used); none imported.
- Not used, with reason: kit.deadline_lib, date_time, kit.rolling_window (no clock or date arithmetic is read: reading (4), deferred manner and timing); kit.compliance_lib (THE LIMBS fix a first-ground-decides order and a settled/missing/referral discipline that the deny-overrides lattice does not express); currency_vocab, vat_category, country (no money, tax or country keys);  (no planning query).
- Family backbone (`_common`, deontic): none required beyond formalize_lib; the completion engine is local (flagged in the working notes (not published) as a kit candidate).

## Slice: data_act_connected_product_data_sharing.clausal

Self-contained for the whole order: the four queries, their limbs, the completion engine and the input check.

Statutory VALUE facts owned here (no shared constants file):
- No numeric threshold, period or table exists in the units read. The two Art 50 dates (12 September 2025; after 12 September 2026, read as 13 September 2026 or later) are NOT computed: they are recorded as provenance comments beside the facts below and enter only as the caller boolean placed_on_market_after_12_september_2026 and the order's default (reading (4)). date/3 is not written (it does not exist yet).
- `contract_key(Position, Key, Type)`: the twenty-two keys, positions 1 to 22, Type in judgement / boolean / enumeration(purchase_rent_or_lease_of_connected_product, provision_of_related_service).
- `query_key(Query, Key)` facts per query, listed in decision order (design: keys 1, 2, 3, 4, 5; information: 1, 2, 6, 7; access: 1, 2, 8, 10, 11, 12, 13, 17, 18, 19, 21, 22; sharing: 1, 2, 9, 10, 11, 14, 15, 16, 17, 18, 19, 20, 21, 22).
- `referral_citation(Query, Key, Citation)` facts: the referral tables of THE LIMBS (required_information_provided_before_contract has two rows, conditioned on the enum value, resolved from the profile, where it is necessarily present by then).
- `final_citations(Query, Result, Kind, Citations)` facts: the CITATIONS of every final RESULT (kind only matters for limbs (2.2) and (2.3)).

Rules / requirements (outcome rule over a COMPLETE assignment, one head-folded clause per limb, defaults guarded by once/1 defeaters of the earlier limbs via not_defeated/3):
- design: (1.1) connected false, or exemption true, or placed_after false: final(not_applicable, art_3_1); (1.2) both design judgements true: final(design_duty_met, art_3_1); (1.3) otherwise final(design_duty_not_met, art_3_1).
- information: (2.1) connected false or exemption true: final(not_applicable, [art_3_2, art_3_3]); (2.2) provided true: final(information_duty_met, kind citation); (2.3) otherwise final(information_duty_not_met, kind citation).
- access: (3.1) connected false / exemption true / requester false / data holder false / readily available false / directly accessible true: not_applicable [art_4_1]; (3.2) security true: refusal_permitted_security_restriction [art_4_2]; (3.3) other persons true and gdpr false: personal_data_not_to_be_made_available [art_4_12]; (3.4) trade secrets true and measures false: withholding_permitted_trade_secrets [art_4_7]; (3.5) trade secrets true and exceptional true: refer(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8))); (3.6) otherwise access_due [art_4_1].
- sharing: (4.1) connected false / exemption true / on-behalf false / data holder false / readily available false / (testing true and permitted false): not_applicable [art_5_1]; (4.2) gatekeeper true: third_party_not_eligible_gatekeeper [art_5_3]; (4.3) other persons true and gdpr false: personal_data_not_to_be_made_available [art_5_7]; (4.4) trade secrets true and strictly necessary false: trade_secret_disclosure_not_permitted [art_5_9]; (4.5) trade secrets true and measures false: withholding_permitted_trade_secrets [art_5_10]; (4.6) trade secrets true and exceptional true: refer(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_5_11))); (4.7) otherwise sharing_due [art_5_1].
- Engine steps per query (THE LIMBS, exactly): (0) input problems non-empty: input_problems(PROBLEMS), []; (1) collect, with findall/3 and sort/2, the ANSWER of every completion (absent query keys over their type, unsure judgements over true/false, all else fixed); one answer: settled (final gives RESULT and CITATIONS; refer gives needs_legal_review(REASON, [inputs_relied_on(PAIRS)]), []); (2) otherwise the first absent query key in decision order that MATTERS (some pair of completions agreeing on every other key but differing in it gives different ANSWERS; tested with a guarded once/1 existence check): indeterminate([KEY]), []; (3) otherwise the first unsure judgement that matters: needs_legal_review(open_textured(KEY, cite(referral citation)), [inputs_relied_on(PAIRS)]), []. ANSWER comparison ignores CONTEXT. Routes are disjoint head-folded clauses chosen by list shape; no cut, no if-then-else.
- Input check: shape test (nonvar profile, proper list, every element nonvar attribute(_, _)) else [wrong_type(profile)]; then per contract key in contract order duplicate_key(KEY) (count by ==, values unread) else wrong_type(KEY) if present with a value outside its type (unbound or attested(...) included); then unknown_key(KEY) per non-contract key (non-atoms and unbound keys included, as given) in first-occurrence order, deduplicated by ==. Never fails, never raises.

Verdict atoms: as listed under Verdict STATUS atoms for the four queries.

Predicates SHARED with another slice: none (there is only one determination slice). The facade-level eligibility wiring lives in queries.clausal and calls this slice's exported query predicates; it is not shared logic.

## Other layers (scaffold files kept; names unchanged)

- kernel.clausal: the small shared floor only: `judgement_value(true). judgement_value(false). judgement_value(unsure).` and `boolean_value(true). boolean_value(false).` used by the slice's input check and by the checklist requirements in queries.clausal. Nothing else.
- citations.clausal: one fact per citation key above, with the verbatim unit text, unit id (for example 32023R2854#art4_p1) and the pin hashes; citation_vocabulary is exactly this list.
- parameters.clausal: no load-bearing value (the order has none); a header comment records that the Art 50 dates are read as the caller boolean and the order's default, not computed.
- queries.clausal: facade wiring: eligibility mapping (one head-folded clause per access RESULT: access_due to eligible; the four ineligible results; passthrough of indeterminate/1, needs_legal_review/2, input_problems/1), the checklist requirement/4 predicate (head order requirement(RequirementId, Profile, Status, Citation); three mutually exclusive clauses per requirement: met / unmet / unknown) with requirement ids connected_product_or_related_service_holds (check_tri, art_2_5), small_enterprise_exemption_absent (check_tri_neg, art_7_1), requester_is_user_holds (art_2_12), addressee_is_data_holder_holds (art_2_13), requested_data_readily_available_holds (art_2_17), data_not_directly_accessible (check_tri_neg, art_4_1), security_restriction_absent (check_tri_neg, art_4_2), personal_data_conditions_satisfied (met when other_persons_personal_data_requested false or gdpr true, art_4_12), trade_secret_measures_satisfied (met when trade secrets false or measures true, art_4_7), exceptional_refusal_not_invoked (met when trade secrets false or exceptional false; an invoked refusal is unknown, art_4_8); and what_if via profile_set/3.
- fixtures.clausal: named profiles with expectations, at least: smart_thermostat_access_due (access_due, [art_4_1]); tractor_trade_secret_measures_breached (withholding_permitted_trade_secrets, [art_4_7]); wearable_other_person_data_without_basis (personal_data_not_to_be_made_available, [art_4_12]); gatekeeper_recipient (third_party_not_eligible_gatekeeper, [art_5_3]); prototype_testing_not_permitted (not_applicable, [art_5_1]); small_enterprise_exempt (not_applicable in all four queries); placed_before_september_2026_design (not_applicable, [art_3_1]); design_duty_met_complete; related_service_information_met ([art_3_3]); not_connected_product_only (settled not_applicable with every other key absent); access_requester_absent (indeterminate([requester_is_user])); access_data_holder_unsure (needs_legal_review(open_textured(addressee_is_data_holder, cite(eu_reg_2023_2854_art_2_13)), ...)); access_exceptional_refusal (needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), ...)); information_kind_absent (indeterminate([pre_contract_contract_kind])); input_duplicate_key, input_unknown_key, input_not_a_list, input_unsure_boolean (wrong_type), input_attested_value (wrong_type).
- package facade: re-exports the four queries, the input check, decide/status/checklist/what_if, the fixtures and the result constructors.

## Tests (per rule, per limb)

One positive and one paired negative test per limb of each query; settled-with-absent-keys tests (a settled value decides before a key it makes irrelevant); the status rule tests (absent key named although a judgement is unsure); the first-missing-key rule tests (only the first mattering absent key named); referral-citation tests per key; COUNTING tests (findall length 1 for every query on every fixture); input-check tests for every problem kind and ordering; totality and determinism properties via validate_props over exhaustive small generators; citation completeness against citation_vocabulary.
