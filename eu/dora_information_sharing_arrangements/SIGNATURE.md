# SIGNATURE — eu/dora_information_sharing_arrangements

## Public query surface (overview)

The contract predicates are the following.

- `information_sharing_within_article_45(Profile, Result, Citations)`
- `membership_notification_duty(Profile, Result, Citations)`
- `dora_information_sharing_arrangements_input_problems(Profile, Problems)`

The facade keeps the scaffold names.

- `decide_dora_information_sharing_arrangements(Profile, dora_information_sharing_arrangements_verdict(Status, Citations))`
- `dora_information_sharing_arrangements_status(Profile, Status)`
- `dora_information_sharing_arrangements_checklist(Profile, Checklist)`
- `dora_information_sharing_arrangements_what_if(Profile, Key, Value, Status)`
- the fixtures

The facade Status is the Result of `information_sharing_within_article_45` (query type #2 eligibility).

**Totality and determinism.** Every call of every public predicate, for every term as Profile, yields EXACTLY ONE solution. This is enforced by disjoint head-folded clauses and checked by the `prop_totality` and `prop_determinism` collectors. There is no `!`, no `->`, no `*->` and no `once/1`.

**Imported figures.** There are no statutory figures, money or dates. `parameters.clausal` declares no `constant_value/2`. It holds only the referral-citation table rows listed below, with a comment saying why it holds no numbers.

## Verdict STATUS atoms (replacing placeholder `required / permitted / not_applicable`)

**`information_sharing_within_article_45`.** Final answers:
- `sharing_within_article_45`: eligible, the exchange is covered.
- `sharing_outside_article_45`: ineligible, the exchange is not covered. This does NOT mean forbidden.

**`membership_notification_duty`.** Final answers:
- `notify_participation_upon_validation`
- `notify_cessation_once_effective`
- `no_notification_duty`

**Status compounds** (CITATIONS always `[]`):
- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: optionally followed by one unscored `provenance(Clause, Citations)`. The authored code omits it.
- `input_problems(Problems)`

**Result constructors** (exported, never queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

**Checklist item statuses** come from `formalize_lib` (`met`, `unmet(Reason)`, `unknown(Keys)`). They are used only on the justification surface.

## Profile keys (root_exports / input_contract order; this ORDER is scored)

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`, presence first and then value.

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `information_is_cyber_threat_information_and_intelligence` | judgement | `true`, `false`, `unsure` |
| 2 | `sharing_aims_to_enhance_digital_operational_resilience` | judgement | `true`, `false`, `unsure` |
| 3 | `sharing_takes_place_within_trusted_community_of_financial_entities` | judgement | `true`, `false`, `unsure` |
| 4 | `arrangement_protects_sensitive_information_and_has_rules_of_conduct` | judgement | `true`, `false`, `unsure` |
| 5 | `arrangement_defines_participation_conditions_and_appropriate_details` | judgement | `true`, `false`, `unsure` |
| 6 | `membership_event` | enumeration | `membership_validated`, `membership_cessation_took_effect`, `no_membership_event` |
| 7 | `arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1` | judgement | `true`, `false`, `unsure` |

The value rules are these.
- There are no numeric keys, no money and no dates, so there are no unit suffixes.
- The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.
- No value is a Python boolean or a quoted string.
- The attested-fact wrapper (ruling 2) is not used, because this is not a GDPR order.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2022_2554_art_45_1`: Art 45(1), lead words [32022R2554#parag_045.001]
- `eu_reg_2022_2554_art_45_1_a`: Art 45(1)(a) [32022R2554#point_045.001_a]
- `eu_reg_2022_2554_art_45_1_b`: Art 45(1)(b) [32022R2554#point_045.001_b]
- `eu_reg_2022_2554_art_45_1_c`: Art 45(1)(c) [32022R2554#point_045.001_c]
- `eu_reg_2022_2554_art_45_2`: Art 45(2) [32022R2554#parag_045.002]
- `eu_reg_2022_2554_art_45_3`: Art 45(3) [32022R2554#parag_045.003]

Always written as `cite(Key)`. The citations file declares each key with its unit id, its pinned verbatim text and a one-line gloss. The heading `32022R2554#art_045` is not declared, because it is deferred.

The fixed citation lists are these.
- `SharingCitations` = `[cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]`
- `NotificationCitations` = `[cite(eu_reg_2022_2554_art_45_3)]`

## Public predicates (one line each)

**Contract predicates:**
- `information_sharing_within_article_45(Profile, Result, Citations)`: whether Art 45(1), read with Art 45(2), covers the exchange. The limbs are A0 input problems, A1 any condition false, A2 the first condition absent, A3 the first condition unsure, A4 all five true. Cites SharingCitations on both final answers. [eu_reg_2022_2554_art_45_1, _1_a, _1_b, _1_c, _2]
- `membership_notification_duty(Profile, Result, Citations)`: which notification Art 45(3) requires.
  - B0: input problems.
  - B1: `no_membership_event`, or the arrangement judgement `false`, gives `no_notification_duty`.
  - B2: an absent `membership_event` is named first, then an absent arrangement key.
  - B3: an unsure arrangement key is referred.
  - B4: the event decides the duty.
  - Cites NotificationCitations on every final answer. [eu_reg_2022_2554_art_45_3]
- `dora_information_sharing_arrangements_input_problems(Profile, Problems)`: THE INPUT CHECK. Returns the bare list of `duplicate_key/1` / `wrong_type/1` / `unknown_key/1` terms in the fixed order, `[wrong_type(profile)]` for a non-attribute-list, and `[]` when the profile is well-formed. Never fails, never raises. [input contract; no citation]

**Facade predicates:**
- `decide_dora_information_sharing_arrangements(Profile, Verdict)`: Verdict = `dora_information_sharing_arrangements_verdict(Status, Citations)`, delegating to `information_sharing_within_article_45/3` (#2 eligibility). [SharingCitations]
- `dora_information_sharing_arrangements_status(Profile, Status)`: Status alone, from the same query. [SharingCitations]
- `dora_information_sharing_arrangements_checklist(Profile, Checklist)`: the justification checklist (#7). It is `assess/6` over requirement ids `[cyber_threat_information, resilience_aim, trusted_community, protective_arrangement, participation_conditions]` with the injected `requirement/4` and `labels(sharing_within_article_45, indeterminate_sharing, sharing_outside_article_45)`. Each item is `item(Id, Status, cite(Key))`, met items included. With input problems the checklist is `[]`. [one citation per item]
- `dora_information_sharing_arrangements_what_if(Profile, Key, Value, Status)`: the facade status after overriding Key with Value. It uses `query_combinators:what_if/5` with the closure `dora_information_sharing_arrangements_status`. [SharingCitations]

**Fixtures** (`fixtures.clausal`): `dora_information_sharing_arrangements_fixture(Name, Profile)` and `dora_information_sharing_arrangements_fixture_expected(Name, Query, Result, Citations)`. Named cases:
- `all_conditions_met`
- `community_false_with_absent_others`
- `first_absent_before_unsure`
- `point_c_unsure_referral`
- `paragraph_2_false`
- `membership_validated_true`
- `cessation_effective_true`
- `no_event_with_unsure_arrangement`
- `event_absent_arrangement_unsure`
- `arrangement_absent`
- `arrangement_unsure_referral`
- `duplicate_and_unknown_keys`
- `non_list_profile`
- `unbound_value`

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `check_tri/4`, `assess/6`, `item/3`, `attribute/2`, `labels/3`, `unknown/1`, `unmet/1`, `memberd/2`, `not_member/2`.
  - `check_tri/4` builds the per-condition checklist status. Hand-rolling it is linted as C15.
  - `assess/6` aggregates the checklist. Hand-rolling `eval_requirements` is linted as R1.
- `kit/query_combinators`: `what_if/5`.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:** `kit/compliance_lib` (its lattice would not reproduce the fixed limb order), `kit/deadline_lib` (no time rule), `library(datetime)`, `currency_vocab`, `vat_category`, `country`, `rolling_window`.

## Layout (unchanged)

`kernel` -> `citations` -> `parameters` -> `dora_information_sharing_arrangements` -> `queries` -> `fixtures` -> package facade. Seven test modes; v2 manifest. No file or module is renamed.

### kernel.clausal (shared floor)

Kernel holds ONLY what both queries share. With one slice, that is the input contract and its check, which both contract queries call first (A0/B0).

- `dora_information_sharing_arrangements_contract_key(Key, Type)`: seven facts, in root_exports order. Each `Type` is `judgement` or `membership_event`.
- `dora_information_sharing_arrangements_value_of_type(Type, Value)`:
  - `judgement`: `true`, `false`, `unsure`
  - `membership_event`: `membership_validated`, `membership_cessation_took_effect`, `no_membership_event`
- `dora_information_sharing_arrangements_input_problems(Profile, Problems)`, built in five steps:
  1. **Attribute-list test.** A proper list, every element nonvar and `attribute(_, _)`. Otherwise the answer is `[wrong_type(profile)]`. This also covers an unbound profile, a partial list and an unbound element.
  2. **Contract keys, in contract order.**
     - `duplicate_key(Key)` if the key occurs more than once, with no value read.
     - Otherwise `wrong_type(Key)` if its single value is unbound or not a value of its type. Numbers and strings are always wrong_type.
  3. **Unknown keys.** `unknown_key(Key)` for each key outside the seven, tested by `==`. Each appears once, in order of first occurrence. The value is never checked. Distinct variables are distinct keys; the same variable is one key.
  4. **Non-atom keys.** Compounds, numbers and strings are unknown keys as given.
  5. **Guards.** The check must never fail or raise: use `==` / `\==` and type tests only, never unification against an unbound key.
- `dora_information_sharing_arrangements_well_formed(Profile)`: Problems is `[]`. Both queries use it as the guard of every non-A0/B0 clause, so routes stay disjoint.

### dora_information_sharing_arrangements.clausal (the single determination slice)

**Statutory VALUE facts owned:**
- There are no thresholds, periods or tables.
- The slice owns its condition table: `sharing_condition(RequirementId, Key, CitationKey)`, five facts, in root_exports order.
  - `cyber_threat_information` -> `information_is_cyber_threat_information_and_intelligence` -> `eu_reg_2022_2554_art_45_1`
  - `resilience_aim` -> `sharing_aims_to_enhance_digital_operational_resilience` -> `eu_reg_2022_2554_art_45_1_a`
  - `trusted_community` -> `sharing_takes_place_within_trusted_community_of_financial_entities` -> `eu_reg_2022_2554_art_45_1_b`
  - `protective_arrangement` -> `arrangement_protects_sensitive_information_and_has_rules_of_conduct` -> `eu_reg_2022_2554_art_45_1_c`
  - `participation_conditions` -> `arrangement_defines_participation_conditions_and_appropriate_details` -> `eu_reg_2022_2554_art_45_2`
- Referral rows: `referral(Query, Key, CitationKey, Inputs)`.
  - Five rows for `information_sharing_within_article_45`, Inputs = the five condition keys.
  - One row for `membership_notification_duty`: `arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1` -> `eu_reg_2022_2554_art_45_3`, Inputs = `[membership_event, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1]`.
- The fixed citation lists `sharing_citations/1` and `notification_citations/1`.

**Rules / requirements:**

R1 `information_sharing_within_article_45/3`, one head-folded clause per route.
- A0: `input_problems(Problems)`, `[]` when Problems is not `[]`.
- A1: `sharing_outside_article_45` with SharingCitations when well-formed and SOME condition key is present with value `false`. Write this as ONE clause over a deterministic test 'some false exists', not one clause per key, so that two false keys still give one solution.
- A2: `indeterminate([Key])` when well-formed, no key false, and Key is the first absent condition key. Use a deterministic helper `first_absent_condition(Profile, Key)` that walks the ordered table.
- A3: `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, `[]`, when well-formed, no key false, none absent, and Key is the first unsure key.
- A4: `sharing_within_article_45` with SharingCitations when all five are `true`.

R2 `membership_notification_duty/3`:
- B0: input problems.
- B1: `no_notification_duty` with NotificationCitations when `membership_event` is `no_membership_event` OR the arrangement key is `false`. Write it as one clause over a deterministic disjunction test, so both true gives one solution.
- B2a: `indeterminate([membership_event])` when not B1 and `membership_event` is absent.
- B2b: `indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1])` when not B1, the event is present and the arrangement key is absent.
- B3: referral with `cite(eu_reg_2022_2554_art_45_3)` when the event is validated or ceased and the arrangement key is `unsure`.
- B4a: `notify_participation_upon_validation` when the event is `membership_validated` and the arrangement key is `true`.
- B4b: `notify_cessation_once_effective` when the event is `membership_cessation_took_effect` and the arrangement key is `true`.

R3 `inputs_relied_on_pairs(Profile, Inputs, Pairs)`: `Key-Value` for each Inputs key present in Profile, in root_exports order, with the value as given and the unsure key included.

R4 `requirement(RequirementId, Profile, Status, Citation)`: RequirementId first, for the `assess/6` closure. It is `sharing_condition/3` plus `check_tri(Profile, Key, Reason, Status)`, with Citation `cite(CitationKey)`. Each condition has three mutually exclusive outcomes: met / unmet / unknown. Both an absent and an unsure key are unknown.

**Verdict atoms:** `sharing_within_article_45`, `sharing_outside_article_45`, `notify_participation_upon_validation`, `notify_cessation_once_effective`, `no_notification_duty`, plus the status compounds above.

**Shared with another slice:** nothing beyond the kernel input check. No other predicate belongs in `kernel.clausal`.

**Per-rule tests (in the slice's test file):**
- Each A/B limb, positive and paired negative.
- Two false keys give exactly one solution (`length/2` on findall).
- An absent key is named before an earlier unsure key.
- `no_membership_event` beats an absent or unsure arrangement key.
- An absent event beats an unsure arrangement key.
- PAIRS order and contents.
- Citations compared as a set.
- Every status cites `[]`.
- The notification query is unaffected by the condition keys (Q3).
- Input check:
  - duplicate with equal values
  - a distinct-variable key, and the same variable repeated
  - `7` versus `7.0`
  - an unbound value
  - a partial list
  - an element that is not an `attribute(_, _)` term

### queries.clausal

Facade wiring only: `decide_dora_information_sharing_arrangements/2`, `dora_information_sharing_arrangements_status/2`, `dora_information_sharing_arrangements_checklist/2`, `dora_information_sharing_arrangements_what_if/4`. Each delegates and yields exactly one solution.
