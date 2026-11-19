% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(uk_dpa_2018_s_164a_1, [label - 'Data Protection Act 2018 s 164A(1) (complaint by a data subject to the controller)', ref - 'https://www.legislation.gov.uk/ukpga/2018/12/section/164A', verbatim - 'A data subject may make a complaint to the controller if the data subject considers that, in connection with personal data relating to the data subject, there is an infringement of the UK GDPR or Part 3 of this Act.']).
citation(uk_dpa_2018_s_164a_3, [label - 'Data Protection Act 2018 s 164A(3) (acknowledgement of receipt within 30 days)', ref - 'https://www.legislation.gov.uk/ukpga/2018/12/section/164A', verbatim - 'If a controller receives a complaint under this section, the controller must acknowledge receipt of the complaint within the period of 30 days beginning when the complaint is received.']).
citation(uk_dpa_2018_s_165_2, [label - 'Data Protection Act 2018 s 165(2) as amended by Data (Use and Access) Act 2025 s 103(3)(b) (complaint by a data subject to the Commission)', ref - 'https://www.legislation.gov.uk/ukpga/2018/12/section/165', verbatim - 'A data subject may make a complaint to the Commission if the data subject considers that, in connection with personal data relating to him or her, there is an infringement of the UK GDPR or Part 3 or 4 of this Act.']).
citation(uk_si_2026_82_reg_3, [label - 'S.I. 2026/82 (Data (Use and Access) Act 2025 (Commencement No. 6 and Transitional and Saving Provisions) Regulations 2026) reg 3', ref - 'https://www.legislation.gov.uk/uksi/2026/82/regulation/3/made', verbatim - 'The following provisions of the 2025 Act, so far as not already in force, come into force on 19th June 2026']).
citation(uk_si_2026_82_reg_3_a, [label - 'S.I. 2026/82 reg 3(a) (commencement of Data (Use and Access) Act 2025 s 103)', ref - 'https://www.legislation.gov.uk/uksi/2026/82/regulation/3/made', verbatim - 'section 103 (complaints by data subjects);']).
citation(uk_si_2026_82_reg_7, [label - 'S.I. 2026/82 reg 7 (transitional provision: duties in DPA 2018 s 164A(3) and (4) apply to complaints received on or after 19 June 2026)', ref - 'https://www.legislation.gov.uk/uksi/2026/82/regulation/7/made', verbatim - 'The duties in section 164A(3) and (4) of the 2018 Act (handling of complaints by data subjects to controllers) inserted by section 103 of the 2025 Act apply only in relation to a complaint that is received by the controller on or after the 19th June 2026.']).

implements(Key) :-
    citation(Key, _).
