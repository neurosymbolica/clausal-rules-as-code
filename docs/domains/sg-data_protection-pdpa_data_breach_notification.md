# Singapore PDPA 2012 Part 6A (ss 26A to 26E) with the Personal Data Protection (Notification of Data Breaches) Regulations 2021 (S 64/2021) regs 3 to 6 and the Schedule: ...

`sg/data_protection/pdpa_data_breach_notification`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 223/223 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Singapore PDPA 2012 Part 6A (ss 26A to 26E) with the Personal Data Protection (Notification of Data Breaches) Regulations 2021 (S 64/2021) regs 3 to 6 and the Schedule: for a caller-described data breach, whether it is a notifiable data breach (deemed significant harm under reg 3(1)(a) with Schedule Parts 1 and 2 and reg 3(1)(b) with reg 3(2); deemed significant scale at 500 affected individuals under reg 4; the judgements of likely significant harm or scale; the s 26B(4) within-organisation exclusion; the s 26C(1) commencement of 1 February 2021), whether notice to affected individuals is required, prohibited, waived or not required (s 26D(2), (5), (6), (7), in the drafter's priority, Q2), the assessment or notice duty of an organisation or data intermediary (s 26C(2), (3), s 26E), the end of the 3-calendar-day period to notify the Commission (s 26D(1), main reading Q1: every day counts) and the fixed content lists of regs 5 and 6. Out of scope and handed to the caller or a lawyer: whether an incident is a data breach, 'likely' significant harm or scale, 'reason to believe', 'renders it unlikely' (judgements), the classification of data into the data class atoms, Schedule Part 2 ...

## Sources

The statute text is not reproduced here. Read it at Singapore Statutes Online (SSO):

| Instrument | Link | Last read |
|---|---|---|
| IA1965 | <https://sso.agc.gov.sg/Act/IA1965?ProvIds=pr50-> | 2026-11-12 |
| PDPA2012 | <https://sso.agc.gov.sg/Act/PDPA2012?ProvIds=P16A-> | 2026-11-12 |
| S64-2021 | <https://sso.agc.gov.sg/SL/S64-2021> | 2026-11-12 |
| S64-2021 | <https://sso.agc.gov.sg/SL/S64-2021?ProvIds=Sc-> | 2026-11-12 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/sg/data_protection/pdpa_data_breach_notification){ .md-button }

## Provisions deferred, and what follows

??? info "data_breach_definition_limbs_and_account_pair_parts"

    **Why:** The definition of affected individual and the two limbs of the data breach definition (s 26A) are read inside the judgement is_data_breach and the breach kinds (readings (3), (4)); the two parts of reg 3(1)(b) are the atoms account_identifier and account_access_credential, cited through reg 3(1)(b).

    **Consequence for a user:** The answers never say whether an incident is a data breach; the caller's judgement does.

??? info "other_prescribed_circumstances"

    **Why:** s 26B(2)(b) and (3)(b) allow 'other prescribed circumstances'; the pinned Regulations prescribe none beyond regs 3 and 4 (reading (5), (7); Q11).

    **Consequence for a user:** A circumstance prescribed later would add a deemed ground the order does not know.

??? info "prescribed_assessment_requirements"

    **Why:** s 26C(4) requires the assessment to follow 'any prescribed requirements'; none found in the pinned Regulations (reading (8); Q11).

    **Consequence for a user:** The answers never say whether an assessment was carried out correctly.

??? info "notice_knowledge_standard_form_and_sub_items"

    **Why:** s 26D(3) is read only through the fixed content lists of regs 5 and 6 ('[quotation omitted] [quotation omitted]' is not checked); s 26D(4) and reg 5(4) leave the form and manner to the Commission's website, outside the pinned text; the sub-items (i) and (ii) of reg 5(1)(g) and reg 6(d) are read as part of their item.

    **Consequence for a user:** The answers list what a notice must contain; they never check a notice, its form or the knowledge behind it.

??? info "definitions_read_by_the_caller"

    **Why:** The definitions of reg 2 (bank, finance company, identification number) and of Schedule Part 2 paragraph 3 tell the caller which data class atom a piece of data is (reading (5)); no limb decides them.

    **Consequence for a user:** The answers rely on the caller's classification of the breached data.

??? info "schedule_part_1_sub_items"

    **Why:** The sub-items of Schedule Part 1 items 5, 6, 6A, 6B, 7, 16, 17, 18, 19, 20 and 23 are read as part of their item: the caller states the item atom, and the limbs cite the item. The limbs (a) and (b) of Schedule Part 2 paragraph 1 are read through the key publicly_available_or_lawfully_disclosed, and the limbs cite paragraph 1.

    **Consequence for a user:** The answers never say which sub-item a piece of data falls under.

??? info "interpretation_act_computation_of_time"

    **Why:** Interpretation Act 1965 s 50 is quoted for OPEN QUESTION Q1 only; under the main reading (every day of the three counts, reading (9)) no limb reads it. Whether 'calendar days' in s 26D(1) displaces s 50(b) or (d) is put to a lawyer.

    **Consequence for a user:** The period end is never moved for a Sunday or public holiday; if a lawyer says s 50 applies, the period end changes for those cases.

