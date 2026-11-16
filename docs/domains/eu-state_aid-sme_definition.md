# Whether an enterprise is a micro, small or medium-sized enterprise (SME) under the Annex to Commission Recommendation 2003/361/EC, Articles 1 to 6, or under Annex I to ...

`eu/state_aid/sme_definition`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 237/237 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether an enterprise is a micro, small or medium-sized enterprise (SME) under the Annex to Commission Recommendation 2003/361/EC, Articles 1 to 6, or under Annex I to Commission Regulation (EU) No 651/2014 (GBER), Articles 1 to 6 (consolidated text of 2023-07-01), read as one test whose TEXT argument changes only the citation keys. Decided here: the size class of one accounting period from the enterprise's own figures plus the declared partner enterprises (pro rata) and linked enterprises (100 %) (Articles 2, 5, 6(1), 6(2)); the size class held after the two-period rule of Article 4(2), with Article 4(1) and 4(3) on the reference period; the exclusion of Article 3(4) for control by public bodies; the SME status; whether the medium-sized ceilings are met or exceeded (at_least_medium, without Article 3(4)); and the relationship type of one other enterprise (linked, partner, or neither) under Article 3(1) to 3(3), with the investor exception and the presumption of no dominant influence. Handed to the caller or a lawyer: whether an entity is an enterprise (Article 1), dominant influence by contract or articles, same or adjacent markets (open-textured judgements referred with ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `ac609a5842802e1b...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `e6c7d5852505e3c4...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `73bef608be2e2fe1...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `b543b99ed7fc2b17...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `708db38b347b3fe7...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `68293585dd81af4b...` |
| CELEX 02014R0651-20230701 | as pinned | 2026-11-12 | `1243e38d921bd91a...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `7d460d24e0753e64...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `fd1735e6706df21f...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `be8d64d507e8554e...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `f5bafa684a25decd...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `0c0a3e6330d94fb5...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `e41dfa1f122feeb1...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `7d04b773832ca3e9...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `176178715d43de45...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `25eccb1dfdfd3654...` |
| CELEX 32003H0361 | as pinned | 2026-11-11 | `b53082fe346b0717...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/state_aid/sme_definition){ .md-button }

## Provisions deferred, and what follows

??? info "indirect_relationships"

    **Why:** Article 3(3) third subparagraph (relationships through one or more other enterprises or through a listed investor also link) is folded into the meaning of the four keys of points (a) to (d) (reading (9), Q11): the order does not follow a chain of enterprises.

    **Consequence for a user:** relationship_type is only as right as the caller's four values for indirect relationships.

??? info "data_of_partner_and_linked_enterprises"

    **Why:** Article 6(3) says how the data of each partner and linked enterprise are built (consolidated accounts, 100 % of the enterprises linked to a partner, pro rata the partners of a linked enterprise). The caller gives each declared enterprise's figures as Article 6(3) builds them (reading (6), Q5).

    **Consequence for a user:** The size answers are only as right as the figures the caller gives for each declared enterprise.

??? info "staff_where_consolidated_accounts_show_none"

    **Why:** Article 6(4) (staff figures where the consolidated accounts show none for an enterprise) is left to the caller's staff figures (reading (6), Q5).

    **Consequence for a user:** own_staff_annual_work_units_hundredths and the STAFF arguments are taken as given.

