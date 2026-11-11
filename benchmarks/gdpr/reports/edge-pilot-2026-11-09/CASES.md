# Six synthetic GDPR boundary cases

These twelve questions are a separate exploratory extension. The core GDPR-30 dataset remains unchanged.

## E01: Encrypted medical backup and an unverified key exposure

A private rehabilitation company discovers a stolen backup containing identifiable psychiatric findings. The backup uses strong encryption. Primary records remain available. An administrator laptop holding access credentials to the separate key vault was also stolen. Whether those credentials can unlock the vault, whether a second factor was required, and whether keys were accessed are not yet known. Key-vault logs will not be available until tomorrow. The incident team has not completed its risk assessment. Patients are individually reachable. No supervisory-authority decision on communication exists.

- **E01.q1:** Can you determine now whether individual notification is legally required? State what is known and what must be established; do not assume that encryption or theft alone settles it.
- **E01.q2:** May the company defer the whole breach-risk assessment and all response work until the key audit arrives tomorrow? Give the immediate priorities.

## E02: Friday anomaly, Monday confirmation, different reporting roles

An IT processor hosts a private hospital portal. On Friday at 18:00, monitoring shows failed login attempts, but no evidence then establishes unauthorised access, loss or disclosure. The processor starts a reasonable investigation immediately. On Monday at 18:00 it confirms that readable named diagnoses were downloaded; this is the first evidence providing reasonable certainty of a personal data breach. It informs the hospital controller at 18:20. The hospital had no earlier information about the incident. It is now Monday 18:30. Blackmail and stigma are plausible, downloaded copies cannot be recalled, and patients are reachable. No authority decision on communication exists.

- **E02.q1:** Did the hospital controller necessarily miss its Article 33 deadline because 72 hours have passed since Friday? Distinguish suspicion, established awareness and the processor/controller duties.
- **E02.q2:** Must the controller notify the supervisory authority now, or may it wait for a complete forensic report? Explain the role of without undue delay and phased information.

## E03: Deleted public health-data link without download logs

A private clinic confirms that named HIV treatment reports were publicly readable through an indexed link for 18 hours. Access logs were never enabled, so it cannot prove or disprove downloads. It removes the link. The leaked data were plaintext; people are identifiable and individually reachable. The incident team reasonably assesses likely high risk of serious stigma from the confirmed exposure. No evidence shows that all possible copies have been recalled or that high risk has ceased. There is no supervisory-authority decision on communication.

- **E03.q1:** Is individual communication required even though no completed download can be proved? Explain the threshold and information to communicate.
- **E03.q2:** Does deleting the public link establish the subsequent-measures exception under Article 34(3)(b) on these facts? Explain what the deletion does and does not establish.

## E04: Mixed contactability across 100,000 affected people

A service network confirms external download of plaintext health complaints linked to 100,000 people, with a documented likely high risk of blackmail. The exposure has been closed but copied data remain outside its control. Group A contains 70,000 people with verified contact details; individual communication is feasible and proportionate. For group B, 30,000 people, documented reasonable attempts establish that individual contact would involve disproportionate effort. Marketing proposes one banner behind a login for everyone. Only 20% of group B used the portal in the last year; there is no evidence that this banner informs group B equally effectively, and no other substitute channels have yet been evaluated. No authority decision on communication exists.

- **E04.q1:** May the network replace individual communication to group A with the proposed banner merely because group B is difficult to contact? Explain the group-specific duties.
- **E04.q2:** Has the network established that the proposed banner alone fulfils its communication obligation to group B? Distinguish permission to use a substitute from proof that this substitute is sufficient.

## E05: Austrian hospital with unclear public mandate

A hospital operator established in Austria processes central health records for 120,000 patients annually as an indispensable part of clinical treatment. It is a GmbH. The ownership structure, public-law status, and whether it acts under a statutory public mandate have not been established. Do not infer private or public-body status from GmbH alone. A potential GDPR fine is under consideration, but neither its final amount nor the legal applicability of the Austrian public-body exemption has been determined.

- **E05.q1:** Must this operator designate a DPO under Article 37(1)(c), despite the unresolved public/private classification? Explain the relevant facts and next steps.
- **E05.q2:** Can you determine from these facts whether Austria's DSG section 30(5) excludes GDPR fines for this operator? Identify the missing legal and factual checks.

## E06: Contradictory risk flags and verified blackmail

A clinic confirms that identifiable psychiatric notes were downloaded in plaintext and published by an attacker. Several named patients have received credible blackmail messages quoting those notes. Patients are individually reachable. No subsequent measure removes this danger. There is no authority decision on communication. A copied incident form nevertheless marks BOTH "unlikely to result in a risk" and "likely to result in a high risk" as true. These flags describe the same incident, people, time and harms; the first flag is an unreasoned checkbox, not an additional factual finding.

- **E06.q1:** Are the two input flags coherent, and may a no-notification result based on the low-risk checkbox be accepted? Explain how the input conflict should be handled.
- **E06.q2:** On the independently established narrative facts, must the controller communicate to the affected people now? Explain whether correcting the form may delay the response.
