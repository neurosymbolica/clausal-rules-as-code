# Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3) and (4): for an essential or important entity and an incident taken as given, whether the incident is significant (Art ...

`eu/nis2_incident_reporting`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 174/174 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3) and (4): for an essential or important entity and an incident taken as given, whether the incident is significant (Art 23(3)(a) or (b), each a judgement the caller states), which reporting steps of Art 23(4)(a) to (e) are due with their limits (24 hours for the early warning, 72 hours for the incident notification or 24 hours for a trust service provider whose trust services are affected, an intermediate report on request, a final report one month after the notification, and for an ongoing incident a progress report and a later final report), and whether a submitted early warning or incident notification was on time given the whole hours elapsed since becoming aware (late is late: no reasons-for-delay exception; inside the limit, without undue delay is a judgement referred to a lawyer when unsure). Out of scope: the entity class (Arts 2, 3), the definition of incident (Art 6), the competent CSIRT or authority, sector acts under Art 4, the moment of becoming aware, the content of each report, the calendar computation of the one-month limits, Art 23(2), Art 23(5) to (10) (the authorities' side) and the implementing acts under Art ...

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

    **Why:** Art 23(11) empowers the Commission to adopt implementing acts specifying the cases in which an incident is significant, and required it to do so by 17 October 2024 for DNS service providers, TLD name registries, cloud computing, data centre, content delivery network, managed service and managed security service providers, and for online marketplaces, online search engines and social networking services platforms. Implementing Regulation (EU) 2024/2690 is such an act; it is pinned in the source library but is NOT part of this order's extract, so its thresholds are not applied.

    **Consequence for a user:** For those entity types the significance answer is the Directive's general test only; the caller must apply Implementing Regulation (EU) 2024/2690 itself.

