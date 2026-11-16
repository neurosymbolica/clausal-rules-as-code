# Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3), (4): whether an incident is significant (either of two judgement limbs), which reporting steps are then due (early ...

`eu/nis2_incident_reporting`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 115/115 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3), (4): whether an incident is significant (either of two judgement limbs), which reporting steps are then due (early warning, incident notification, intermediate report, final report, progress report and later final report) and whether the early warning and the incident notification were in time (24 and 72 hour limits, 24 for a trust service provider's notification, no excuse after the limit, plus a without-undue-delay judgement). Out of scope and handed to the lawyer: entity class, recipient authority, definition of incident, sector-specific acts, calendar-month periods, content of the reports, notification of service recipients, Art 23(2), and Implementing Regulation (EU) 2024/2690.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022L2555 | as pinned | 2026-11-11 | `a43c2a5e54b91f73...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/nis2_incident_reporting){ .md-button }

## Provisions deferred, and what follows

??? info "recipient_and_threat_communication"

    **Why:** Art 23(2) (communicate to the recipients of services potentially affected by a significant cyber threat the measures they can take, and where appropriate the threat itself) turns on "where applicable" and "where appropriate" and on a significant cyber threat, not an incident; no limb of this order reads it. The same is true of the second sentence of Art 23(1) (notify recipients of services of significant incidents likely to adversely affect them, where appropriate).

    **Consequence for a user:** The answers do not say whether the entity must inform the recipients of its services; the caller must check Art 23(1) second sentence and Art 23(2) itself.

??? info "content_of_the_steps"

    **Why:** The content of the final report (points (d)(i) to (iv)), and of the early warning and incident notification (suspected unlawful or malicious acts, cross-border impact, initial assessment, indicators of compromise, in points (a) and (b)), is not checked: this order lists the steps and their hour limits and judges timeliness only. A content check would have the shape of the content check of the GDPR breach notification order.

    **Consequence for a user:** The answers do not say whether a report contains what Art 23(4) requires; the caller must check the content itself.

??? info "implementing_acts_on_significance"

    **Why:** Art 23(11) empowers the Commission to adopt implementing acts specifying the cases in which an incident is significant, and required it to do so by 17 October 2024 for DNS service providers, TLD name registries, cloud computing, data centre, content delivery network, managed service and managed security service providers, and for online marketplaces, online search engines and social networking services platforms. Implementing Regulation (EU) 2024/2690 is such an act; it is pinned by automated retrieval but is NOT part of this order's extract, so its thresholds are not applied.

    **Consequence for a user:** For those entity types the significance answer is the Directive's general test only; the caller must apply Implementing Regulation (EU) 2024/2690 itself.

