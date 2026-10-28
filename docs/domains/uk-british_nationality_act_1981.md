# Is this person a British citizen on a given date under the British Nationality Act 1981 (as enacted), and if not, which registration or naturalisation route is open, and from when?

`uk/british_nationality_act_1981`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 157/157 | enforced: 237 units: 123 formalized, 114 deferred (0 authorized, 114 expansion), 0 unaccounted | pass | pass | pass |

## Scope

The British Nationality Act 1981 (c. 61) AS ENACTED, in force from 1 January 1983 (S.I. 1982/933), for British citizenship only: whether a person is a British citizen on a given day, and by descent or otherwise (ss. 1(1), 1(2), 1(5)-(6), 2(1)-(2), 11(1) as a stated input, 14(1)(a) and (c), 47(1), 50(2)-(5), (9)-(11)); whether, on an application made on a given date, he is entitled to be registered as a British citizen, or may be registered at the Secretary of State's discretion (ss. 1(3), 1(4), 1(7), 3(1)-(6), 4(1)-(6)); and whether he fulfils the requirements for naturalisation (s. 6, Schedule 1 paras 1-4 and 9(1)). The input is a profile dict per person (keys in profile_keys.yaml); parents, adopters and a spouse are nested profiles, so a parent's citizenship is itself decided by the same rules. Registrations and naturalisations that happened are stated facts. A profile that is ...

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX  | base act | 2026-10-25 | `61dd97620e43a80d...` |
| CELEX  | base act | 2026-10-25 | `26445d4cb91e1392...` |
| CELEX  | base act | 2026-10-25 | `93cc068be6975a81...` |
| CELEX  | base act | 2026-10-25 | `08327a51ed23f134...` |
| CELEX  | base act | 2026-10-25 | `23f7b0bdb42875ff...` |
| CELEX  | base act | 2026-10-25 | `3d0d460a6565f0d3...` |
| CELEX  | base act | 2026-10-25 | `7bb666b43495c648...` |
| CELEX  | base act | 2026-10-25 | `9dbff7446970cc68...` |
| CELEX  | base act | 2026-10-25 | `fa5ece47942e7b32...` |
| CELEX  | base act | 2026-10-25 | `c626f6529056c1d7...` |
| CELEX  | base act | 2026-10-25 | `27d25f879d18aec2...` |
| CELEX  | base act | 2026-10-25 | `bf9772eca14e5716...` |

[Side-by-side provision report](../reports/uk-british_nationality_act_1981.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/uk/british_nationality_act_1981){ .md-button }

## Provisions deferred, and what follows

??? info "headings"

    **Why:** Section, Schedule and paragraph headings and cross-headings carry no rule. Deferred so that every unit of the pinned extracts is accounted for.

    **Consequence for a user:** None. A heading states no rule.

??? info "definition_cross_reference"

    **Why:** s. 1(8) only says that "settled" has the meaning given by s. 50; the rules apply s. 50(2)-(5) directly (citizenship.clausal settled_on_day_t/3).

    **Consequence for a user:** None.

??? info "designation_of_service_by_order"

    **Why:** Which services the Secretary of State has designated by order under s. 2(3) is not formalised; the caller states a service as designated_service.

    **Consequence for a user:** A service wrongly stated as designated (or not) gives a wrong answer under s. 2(1)(b) and Schedule 1 para 4(d).

??? info "citizenship_at_commencement_conditions"

    **Why:** Who became a British citizen at commencement depends on the law before 1983 (citizenship of the United Kingdom and Colonies, the right of abode under the Immigration Act 1971, and the special cases of s. 11(2)-(3)). The caller states the result in citizenship_at_commencement; s. 11(1) is cited only as the ground it gives.

    **Consequence for a user:** A wrong stated status at commencement gives a wrong status for that person and for every child or grandchild whose citizenship is derived through him or her.

??? info "by_descent_at_commencement_and_other_registrations"

    **Why:** s. 14(1)(b) and s. 14(2)-(3) decide whether a person who became a citizen at commencement is one by descent (pre-1983 law, stated by the caller as citizenship_at_commencement by_descent); s. 14(1)(d)-(h) concern registration under ss. 5, 8, 10, 13 and Schedule 2, which are not formalised.

    **Consequence for a user:** A person who is a citizen by descent only because of one of these limbs must be stated as such by the caller; registrations under ss. 5, 8, 9, 10 and 13 cannot be stated at all, so a person whose only ground is one of them reads as not a British citizen.

??? info "legitimation_by_law_of_domicile"

    **Why:** Whether a marriage legitimated the child by the law of the father's domicile is not formalised; the caller states the date of legitimation in legitimated_on.

    **Consequence for a user:** A legitimation that the law of the domicile did not effect, if stated, makes the father count from the marriage when he should not.

??? info "settled_in_a_dependent_territory"

    **Why:** s. 50(3)(b) concerns settlement in a dependent territory, which no formalised rule asks about.

    **Consequence for a user:** None for British citizenship as formalised.

??? info "naturalisation_history_ships_and_definitions"

    **Why:** s. 50(6) (who was naturalised in the UK under the former Acts), s. 50(7) (births on ships and aircraft), s. 50(8) (an application is made when received), s. 50(12) (Schedule 3 countries include their dependencies) and s. 50(13) (amending Schedule 6) are not formalised: the caller supplies place_of_birth after applying s. 50(7), and the date of an application as the date of its receipt.

    **Consequence for a user:** A birth on a ship or aircraft must be stated as in or outside the United Kingdom as s. 50(7) deems it; an application date that is not the date of receipt can move a residence period.

??? info "citation_commencement_and_extent"

    **Why:** s. 53 other than subsection (2) is about the short title, the early commencement of ss. 49 and 53, and territorial extent.

    **Consequence for a user:** None for the questions answered here.

??? info "british_dependent_territories_naturalisation"

    **Why:** Schedule 1 paras 5-8, 9(2) and 10 are the requirements for naturalisation as a British Dependent Territories citizen under s. 18; only British citizenship is formalised.

    **Consequence for a user:** None for British citizenship; British Dependent Territories citizenship is not answered at all.

