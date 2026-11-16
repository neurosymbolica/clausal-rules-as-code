# SIGNATURE — eu/nis2_domain_name_data

The public query surface is `decide_nis2_domain_name_data(PROFILE, nis2_domain_name_data_verdict(STATUS, CITATIONS))` and `nis2_domain_name_data_status(PROFILE, STATUS)`. PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only with `profile_get/3`. Every query yields exactly one solution. The package is total and deterministic: every profile gets one answer, and the input check always runs first. The only statutory figure, 72 hours, is declared once in the slice and never inlined.

## Verdict STATUS atoms (replace scaffold placeholders `required/permitted/not_applicable`)

- `eligible`: the provider is addressed by Art 28, so its duties attach (the checklist is cited).
- `ineligible`: the provider is of type other, so Art 28 gives no duty.
- `indeterminate`: a needed key is absent. This is the compound `indeterminate(MISSING_KEYS)` in the query results. The bare atom `indeterminate` is never written as a result.
- Pass-through compounds: `needs_legal_review(open_textured(KEY, cite(KEY)), [inputs_relied_on(PAIRS)])` and `input_problems(PROBLEMS)`.
- Query result atoms: `must_publish_without_undue_delay`, `no_publication_duty`, `must_provide_access`, `no_duty_to_provide_access`, `on_time`, `late(hour_limit)`, `late(without_undue_delay)`.

## Profile keys (seven, in this order)

1. `provider_type`: enumeration `tld_name_registry`, `domain_name_registration_service_entity` or `other`.
2. `point_of_contact_email_address_differs_from_registrant`: crisp `true`/`false`.
3. `point_of_contact_telephone_number_differs_from_registrant`: crisp `true`/`false`.
4. `registration_data_is_personal_data`: judgement `true`/`false`/`unsure`.
5. `requester_is_legitimate_access_seeker`: judgement.
6. `request_is_lawful_and_duly_substantiated`: judgement.
7. `reply_without_undue_delay`: judgement.

Other inputs: `HoursElapsed` is a non-negative integer. For the datetime route, receipt and reply are native datetime objects (ISO-8601 strings at the boundary, converted with `datetime_string_iso/2`).

## Citation-key atoms

`eu_dir_2022_2555_art_28_1`, `eu_dir_2022_2555_art_28_2`, `eu_dir_2022_2555_art_28_2_a`, `eu_dir_2022_2555_art_28_2_b`, `eu_dir_2022_2555_art_28_2_c`, `eu_dir_2022_2555_art_28_2_d`, `eu_dir_2022_2555_art_28_3`, `eu_dir_2022_2555_art_28_4`, `eu_dir_2022_2555_art_28_5`, `eu_dir_2022_2555_art_28_6`. All are written as `cite(KEY)`.

## Public predicates

- `decide_nis2_domain_name_data(Profile, Verdict)`: verdict `nis2_domain_name_data_verdict(Status, Citations)` for query #2, eligible/ineligible/indeterminate. It applies the limbs (0) to (3) of provider_duties, and the cited checklist supports #7. Art 28(1) to (6).
- `nis2_domain_name_data_status(Profile, Status)`: the status alone, from the same decision. Art 28.
- `nis2_domain_name_data_checklist(Profile, Checklist)`: list of `item(RequirementId, Status, cite(KEY))` for the addressed-provider, data-fields, publication and access rules. Every item, met ones included, carries `cite(...)` (#7). Art 28(1) to (5).
- `nis2_domain_name_data_what_if(Profile, Key, Value, Result)`: the decision after overriding one key, via `what_if/5`. Art 28.
- `nis2_domain_name_data_input_problems(Profile, Problems)`: the typed input check. Art 28.
- `provider_duties(Profile, Duties)`: the list of `duty(Duty, cite(Key))`, nine duties in article order, `[]` for other. Art 28(1) to (6).
- `required_registration_data(Profile, Fields)`: the list of `field(Name, cite(Key))`, with the point (d) fields per element. Art 28(2).
- `publication_duty(Profile, Result, Citations)`: Art 28(4).
- `access_duty(Profile, Result, Citations)`: Art 28(5), first sentence.
- `access_reply_timeliness(Profile, HoursElapsed, Result)`: Art 28(5), second sentence. It is called with Hours as an integer.
- `access_reply_hours_elapsed(ReceiptDatetime, ReplyDatetime, HoursElapsed)`: elapsed time rounded UP to whole hours, using native datetime (`date_diff/3`, `timedelta/3`). Art 28(5).
- `access_reply_deadline(ReceiptDatetime, DeadlineDatetime)`: #15, `date_add(Receipt, timedelta(0, 259200), Deadline)`, which is 72 hours from receipt. The consequence of missing it is `late(hour_limit)` with no exception. Art 28(5).
- Result constructors (exported, never queried): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `duty/2`, `field/2`, `late/1`.
- Fixtures: the scaffold fixtures predicate names are kept unchanged.

## Slices

### kernel.clausal (shared floor)

Shared predicates only:
- `nis2_domain_name_data_judgement_value/1`: true, false, unsure.
- `nis2_domain_name_data_crisp_value/1`: true, false.
- `nis2_domain_name_data_provider_type/1`: the three provider types.
- `nis2_domain_name_data_contract_keys/1`: the seven keys in order.

No statutory values live here.

### nis2_domain_name_data.clausal

**Value facts owned:**
- `:- constant_value(reply_limit_hours, 72).`
- `:- constant_value(seconds_per_hour, 3600).`
- The nine duty rows (duty atom + citation key) and the field rows (field atom + citation key) as facts, in article order.

**Rules and requirements:**
1. `provider_addressed`: Art 28(1), by provider_type.
2. `registration_data_fields`: Art 28(2), points (a) to (d).
3. `publication_duty`: Art 28(4).
4. `access_duty`: Art 28(5), first sentence.
5. `access_reply_timeliness`: Art 28(5), second sentence.

The cooperation duty of Art 28(6) is only the last row of the duty list and is not computed.

**Verdict atoms:** `eligible`, `ineligible`, `indeterminate(Keys)`, plus the result atoms above.

**Limb order (first step to answer decides):**
- Input problems, then missing keys, then unsure judgements.
- A false access condition settles `no_duty_to_provide_access` before absent or unsure keys are read.
- Hours above 72 give `late(hour_limit)` before any key is read.

**Shared predicates needed from other slices:** none. This is the only determination slice, and the shared floor is the kernel's lists.

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `missing_keys/3`, `check_tri/4`, `check_true/4`, `check_false/4`, `assess/6`, `eval_requirements/4`, `decide_labeled/3`.
- `kit.query_combinators`: `what_if/5` for the what-if predicate.
- `kit.deadline_lib`: not used, because the period is hours, not days.
- `library(datetime)`: `date_add/3`, `date_diff/3`, `timedelta/3`, `datetime_string_iso/2`.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3` for the tests.
