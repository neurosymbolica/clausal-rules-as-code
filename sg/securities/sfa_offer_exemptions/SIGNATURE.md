# SIGNATURE — sg/securities/sfa_offer_exemptions

## Public query surface

`sfa_offer_exemption(PROFILE, RESULT)` — the called contract. Exactly one
solution per profile. RESULT = `offer_exemption(DECISION, COVERED_BY, WINDOW_AMOUNT_CENTS, WINDOW_PERSONS, CITATIONS)`.
Citation: sg_sfa_2001_s274, sg_sfa_2001_s275_1, sg_sfa_2001_s275_1a, sg_sfa_2001_s272a_1, sg_sfa_2001_s272b_1, sg_sfa_2001_s240.

`decide_sfa_offer_exemptions(PROFILE, RESULT)` — the internal decision predicate.
One solution per profile. RESULT = `offer_exemption(DECISION, COVERED_BY, WINDOW_AMOUNT_CENTS, WINDOW_PERSONS, CITATIONS)`.

`sfa_offer_exemptions_status(PROFILE, STATUS)` — the verdict predicate (query type #2).
STATUS ∈ {exempt, prospectus_required, indeterminate}.

`sfa_offer_exemptions_checklist(PROFILE, CHECKLIST)` — the cited checklist (query type #2).
Each item carries a `cite/1` provenance atom.

`sfa_offer_exemptions_what_if(THRESHOLD_KEY, VALUE, PROFILE, RESULT)` — the threshold
boundary query (query type #6). Exposes the boundary at which the outcome flips.

`fixtures/0` — the test fixture generator.

## Verdict STATUS atoms

- `exempt` — every offeree is covered by at least one exemption.
- `prospectus_required` — at least one offeree is not covered; a prospectus is required.
- `indeterminate` — a required profile key is absent, or total offerees is zero.

## Profile keys

| Key | Type | Required? | Notes |
|-----|------|-----------|-------|
| offer_date | date(Year, Month, Day) | yes | The date of the offer. |
| institutional_offerees | integer ≥ 0 | yes | Count of institutional-investor offerees. |
| relevant_person_offerees | integer ≥ 0 | yes | Count of relevant-person offerees. |
| other_offerees | integer ≥ 0 | yes | Count of other (residual) offerees. |
| amount_raised_cents | integer ≥ 0 | yes | Amount raised by THIS offer, in cents. |
| advertisement | true \| false | yes | Whether the offer is accompanied by an advertisement. |
| non_permitted_selling_expenses | true \| false | yes | Whether non-permitted selling/promotional expenses are paid. |
| prospectus_state | none \| expired \| registered_authority_notified \| registered_authority_and_offerees_notified \| registered_not_notified | yes | The state of any prospectus. |
| personal_offer | true \| false | no (default false) | s 272A(3) assertion. |
| statement_and_resale_notification_given | true \| false | no (default false) | s 272A(1)(b) assertion. |
| acquires_as_principal | true \| false | no (default false) | s 275(1A) assertion. |
| minimum_consideration_per_transaction_cents | integer ≥ 0 | no (default 0) | s 275(1A)(a) minimum per transaction. |
| prior_small_offers | list of prior(date(Year, Month, Day), integer) | no (default []) | s 272A(5) aggregation inputs. |
| prior_private_placement_offerees | list of prior(date(Year, Month, Day), integer) | no (default []) | s 272B(3) aggregation inputs. |

## Citation-key atoms

| Atom | Maps to |
|------|---------|
| sg_sfa_2001_s274 | s 274 — institutional investor exemption |
| sg_sfa_2001_s275_1 | s 275(1) — relevant person exemption |
| sg_sfa_2001_s275_1a | s 275(1A) — principal acquisition exemption |
| sg_sfa_2001_s272a_1 | s 272A(1) — small personal offer exemption |
| sg_sfa_2001_s272b_1 | s 272B(1) — private placement exemption |
| sg_sfa_2001_s240 | s 240 — prospectus requirement (cited when prospectus_required) |

## Public predicates

```
sfa_offer_exemption(PROFILE, RESULT):
    The called contract. Exactly one solution per profile.
    RESULT = offer_exemption(DECISION, COVERED_BY, WINDOW_AMOUNT_CENTS, WINDOW_PERSONS, CITATIONS).
    DECISION ∈ {exempt, prospectus_required, indeterminate}.
    COVERED_BY ⊆ [s274, s275_1, s275_1a, s272a, s272b] in that exact order.
    WINDOW_AMOUNT_CENTS: integer (n_a when indeterminate).
    WINDOW_PERSONS: integer (n_a when indeterminate).
    CITATIONS: one bare atom per COVERED_BY entry in the same order;
               [sg_sfa_2001_s240] when prospectus_required; [] when indeterminate.
    Citation: sg_sfa_2001_s274, sg_sfa_2001_s275_1, sg_sfa_2001_s275_1a,
              sg_sfa_2001_s272a_1, sg_sfa_2001_s272b_1, sg_sfa_2001_s240

decide_sfa_offer_exemptions(PROFILE, RESULT):
    The internal decision predicate. One solution per profile.
    RESULT = offer_exemption(DECISION, COVERED_BY, WINDOW_AMOUNT_CENTS, WINDOW_PERSONS, CITATIONS).
    DECISION ∈ {exempt, prospectus_required, indeterminate}.
    COVERED_BY ⊆ [s274, s275_1, s275_1a, s272a, s272b] in that exact order.
    WINDOW_AMOUNT_CENTS: integer (n_a when indeterminate).
    WINDOW_PERSONS: integer (n_a when indeterminate).
    CITATIONS: one bare atom per COVERED_BY entry in the same order;
               [sg_sfa_2001_s240] when prospectus_required; [] when indeterminate.
    Citation: sg_sfa_2001_s274, sg_sfa_2001_s275_1, sg_sfa_2001_s275_1a,
              sg_sfa_2001_s272a_1, sg_sfa_2001_s272b_1, sg_sfa_2001_s240

sfa_offer_exemptions_status(PROFILE, STATUS):
    Verdict predicate (query type #2). STATUS ∈ {exempt, prospectus_required, indeterminate}.
    Citation: same as above.

sfa_offer_exemptions_checklist(PROFILE, CHECKLIST):
    Cited checklist (query type #2). One item per exemption rule evaluated.
    Each item: item(RuleId, Status, Citation).
    RuleId ∈ {s274, s275_1, s275_1a, s272a, s272b}.
    Status ∈ {met, unmet, unknown}.
    Citation: same as above.

sfa_offer_exemptions_what_if(THRESHOLD_KEY, VALUE, PROFILE, RESULT):
    Threshold boundary query (query type #6).
    THRESHOLD_KEY ∈ {window_amount_cents, window_persons, minimum_consideration_per_transaction_cents}.
    Exposes the boundary value at which the decision flips between exempt and prospectus_required.
    Citation: same as above.

fixtures/0:
    Test fixture generator. Yields a stream of (PROFILE, EXPECTED_RESULT) pairs
    covering all seven test modes.
```

## Imports (measured from the code, 2026-10-05)

Every kit and engine-library module this package's rule files import, with the predicates imported
(read from the `:- use_module` directives of its non-test `.clausal` files; sibling `sg/...` modules omitted).
This replaces the producer's "Planned reuse" table, which listed modules and predicates the code never
imports (e.g. `kit/deadline_lib`).

| Module | Predicates imported | Imported by |
|---|---|---|
| `formalize_lib` | `not_member/2` | sfa_offer_exemptions.clausal |
| `kit/query_combinators` | `flip_scan/4`, `override_key/4` | queries.clausal |
| `library(clpz)` | (whole module) | sfa_offer_exemptions.clausal |
| `library(datetime)` | `date_add/3`, `timedelta/3` | sfa_offer_exemptions.clausal |

## Determination slice: sfa_offer_exemptions.clausal

### Statutory value facts (owned by this slice)

| Constant name | Value | Source |
|---------------|-------|--------|
| small_offer_window_limit_cents | 500000000 | s 272A(1)(a) — $5,000,000 |
| private_placement_person_limit | 50 | s 272B(1)(a) |
| principal_minimum_consideration_cents | 20000000 | s 275(1A)(a) — $200,000 |
| window_months | 12 | s 272A(1)(a), s 272B(1)(a) |

### Rules / requirements

| Rule ID | Statute | Condition (all must hold) |
|---------|---------|---------------------------|
| s274 | s 274 | institutional_offerees > 0 (no further condition) |
| s275_1 | s 275(1) | relevant_person_offerees > 0 AND COMMON AND PROSPECTUS_OK |
| s275_1a | s 275(1A) | acquires_as_principal AND minimum_consideration_per_transaction_cents >= 20000000 AND COMMON AND PROSPECTUS_OK |
| s272a | s 272A(1) | personal_offer AND statement_and_resale_notification_given AND COMMON AND PROSPECTUS_OK_272A AND WINDOW_AMOUNT_CENTS <= 500000000 |
| s272b | s 272B(1) | COMMON AND PROSPECTUS_OK AND WINDOW_PERSONS <= 50 |

Where:
- COMMON = (advertisement = false) AND (non_permitted_selling_expenses = false)
- PROSPECTUS_OK = prospectus_state ∈ {none, expired, registered_authority_and_offerees_notified}
- PROSPECTUS_OK_272A = prospectus_state ∈ {none, expired, registered_authority_notified, registered_authority_and_offerees_notified}
- WINDOW_AMOUNT_CENTS = amount_raised_cents + sum(amounts of in-window prior_small_offers)
- WINDOW_PERSONS = residual_offerees + sum(persons of in-window prior_private_placement_offerees)
- residual_offerees = other_offerees + (relevant_person_offerees if s275_1 failed, else 0)

### Verdict atoms

- `exempt`
- `prospectus_required`
- `indeterminate`

### Shared predicates (belong in kernel.clausal)

None. This is the sole determination slice; all logic is self-contained in
sfa_offer_exemptions.clausal. The kernel provides only the shared floor
(module declaration, imports, and the `offer_exemption/5` term definition).
