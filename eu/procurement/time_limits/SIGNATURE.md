# SIGNATURE — eu/procurement/time_limits

`decide_time_limits(PROFILE, time_limits_verdict(STATUS, MINIMUM_DAYS, CONFORMITY,
CITATIONS))` with projections `time_limits_status/2` (STATUS only),
`minimum_days/2` (MINIMUM_DAYS only) and `time_limits_conformity/2`
(CONFORMITY only), plus the facade `time_limits_checklist/2` /
`time_limits_decision_resolvable/1` and the query layer `time_limits_what_if/4`,
`time_limits_enumerate/4`, `time_limits_floor/3`.

PROFILE keys (six):
`procedure_type_key` (one of the `eu.procurement.directive_2014_24.vocabulary` Art 26 atoms:
`open_procedure`, `restricted_procedure`,
`competitive_procedure_with_negotiation`, `competitive_dialogue`,
`innovation_partnership`), `stage_key` (`receipt_of_tenders` |
`receipt_of_participation_requests`), and the three circumstance flags
`prior_information_notice_published`, `electronic_submission_accepted`,
`state_of_urgency_substantiated` (each `True` | `False`), and
`observed_time_limit_days` — the day count the contract notice ACTUALLY allowed
for this stage (a positive integer). The first five decide what the law
required; the sixth is what the record shows, and only it is optional: without
it the verdict reports `observed_days_not_supplied` rather than guessing.

STATUS in `{minimum_days_prescribed, no_minimum_prescribed,
stage_not_applicable}`. MINIMUM_DAYS is an integer day count when
`minimum_days_prescribed`, the atom `n_a` otherwise. CONFORMITY in
`{meets_prescribed_minimum, shorter_than_prescribed_minimum,
observed_days_not_supplied, no_prescribed_minimum_to_meet}`: the observed day
count against the prescribed minimum, an INCLUSIVE floor (Art 27(1) "shall be
35 days", so allowing exactly 35 complies). Neither an unsupplied day count nor
a (procedure, stage) with no prescribed minimum is a conformity claim in either
direction; each has its own atom saying so. The decision is total
over the 5 x 2 (procedure, stage) grid and deterministic (exactly one verdict
per well-formed profile); `negotiated_procedure_without_prior_publication` is
out of scope (no call for competition, hence no time-limit table) and yields
no verdict. Every day figure lives in `time_limits.clausal`, anchored row-by-row
to Directive 2014/24/EU Arts 27-31; procedure atoms are imported from
`eu.procurement.directive_2014_24.vocabulary`, never re-declared.
