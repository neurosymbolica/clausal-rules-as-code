# Predicate Signatures — uk/british_nationality_act_1981

Source authority: British Nationality Act 1981 (c. 61) as enacted; S.I. 1982/933.
Every public predicate gives exactly one answer for a well-formed query.

## Public predicates

`british_citizenship_status(PROFILE, DATE, STATUS)`: STATUS is the person's British
    citizenship on DATE:
    `british_citizen(MODE, GROUNDS)`, where MODE is `by_descent` or `otherwise_than_by_descent`
    (s. 14), and GROUNDS lists `ground(PROVISION, ROUTE, SINCE)`. PROVISION is one of
    `section_1_1`, `section_1_2`, `section_1_5`, `section_2_1_a`, `section_2_1_b`,
    `section_2_1_c`, `section_11_1`, a registration provision or a naturalisation provision.
    ROUTE is `through(mother)`, `through(father)` or `none`. SINCE is the date the ground was
    acquired.
    Otherwise STATUS is `not_british_citizen`, or `indeterminate` when the input check finds a
    problem.

`british_citizenship_registration(PROFILE, PROVISION, APPLICATION_DATE, RESULT)`: PROVISION is
    one of `registration_provision/1`. RESULT is `assessment(OUTCOME, CONDITIONS)`. OUTCOME is
    `entitled`, `at_discretion`, `not_entitled` or `indeterminate`. CONDITIONS lists
    `condition(NAME, met | unmet | waivable, CITATION)`.

`british_citizenship_naturalisation(PROFILE, PROVISION, APPLICATION_DATE, RESULT)`: PROVISION is
    `section_6_1` or `section_6_2`. RESULT is `assessment(OUTCOME, CONDITIONS)`. OUTCOME is
    `requirements_fulfilled`, `requirements_fulfilled_only_if_waived`,
    `requirements_not_fulfilled` or `indeterminate`. The grant itself is always the
    Secretary of State's discretion.

`british_nationality_input_problems(DETERMINATION, PROFILE, PROBLEMS)`: DETERMINATION is
    `citizenship`, `registration` or `naturalisation`. PROBLEMS lists every input problem;
    `[]` means the profile is well formed.

`registration_provision(PROVISION)`, `naturalisation_provision(PROVISION)`: the provisions
    formalised.

`british_nationality_subject(SUBJECT)`, `british_nationality_profile_for(SUBJECT, PROFILE)`:
    the named fixtures.

`citation(KEY, RECORD)`, `implements(KEY)`: the citation registry.

## Query predicates (queries.clausal)

`british_nationality_answer(PROFILE, QUERY, ANSWER)`: QUERY is `citizenship(DATE)`,
    `registration(PROVISION, DATE)` or `naturalisation(PROVISION, DATE)`; ANSWER is what the
    named determination answers.

`british_nationality_what_if(PROFILE, CHANGES, QUERY, compared(BEFORE, AFTER))`: CHANGES is a
    list of `Key-Value` and `remove(Key)`; BEFORE and AFTER answer QUERY for the profile as
    given and as changed. Malformed CHANGES give AFTER = `indeterminate`.

`british_citizenship_status_history(PROFILE, HISTORY)`: HISTORY is
    `[since(DATE, STATUS), ...]` from the date of birth, one entry per change, or
    `indeterminate`.

`british_citizenship_absence_figures(PROFILE, PROVISION, DATE, FIGURES)`: PROVISION is
    `section_1_4`, `section_3_5`, `section_4_2`, `section_6_1` or `section_6_2`; FIGURES lists
    `figure(NAME, DAYS_ABSENT, LIMIT, EXCESS)`, or is `indeterminate`.

`british_citizenship_routes(PROFILE, DATE, ROUTES)`: ROUTES lists `route(PROVISION, OUTCOME)`
    for every registration and naturalisation provision, best outcome first.

`british_citizenship_earliest_application(PROFILE, PROVISION, FROM, RESULT)`: PROVISION is
    `section_1_4`, `section_4_2`, `section_6_1` or `section_6_2`; RESULT is `earliest(DATE)`,
    `none_within(HORIZON_DATE)` (20 years after FROM) or `indeterminate`.
