---
title: "Purple Teaming a PCI Environment: What a Generic Identity Exercise Misses"
slug: "purple-teaming-a-pci-environment"
date: 2026-10-15
tags:
  - "Purple Teaming"
  - "PCI"
  - "Identity"
  - "Red Team"
  - "Detection Engineering"
  - post
author: Hugh McGauran
excerpt: "A generic identity-focused purple team exercise will tell you whether you can detect a credential-driven intrusion. A PCI environment is a different problem. The Cardholder Data Environment is segmented, the QSA is watching, the assessor sign-off is at stake, and the parts of the framework that hold in a flat enterprise are the parts that break first behind a PCI scope. This is the essay on what changes when the perimeter is a regulated one, and why a generic exercise is the wrong shape of test"
layout: layouts/post.njk
permalink: /essays/purple-teaming-a-pci-environment/
---

A generic identity-focused purple team exercise will tell you whether the SOC can spot a credential-driven intrusion. That is what the exercise is designed to do. It will not tell you whether the exercise held inside a Cardholder Data Environment, against a QSA on a Tuesday, with the next quarterly scan due in nine days and a P2PE segment the attacker cannot see but the assessor's evidence pack requires you to prove.

The two questions are not the same. The exercise as usually scoped answers the first one and assumes the second. In a PCI environment, that assumption is expensive.

This essay is for the practitioner running — or thinking about running — an identity-focused purple team exercise in a cardholder data environment. It draws on work with payment processors, acquiring banks, large merchants, and service providers across QSA-assessed environments — the specifics anonymised because the customers are not the lesson. The pattern is the lesson.

It belongs to the same series as the identity-focused practitioner guide and the credential-driven response essay. The previous essay ended with a promise to write the longer-tail piece on turning the lessons of one exercise into a quarterly cadence. That essay will be written. This one sits in front of it for a reason: the framework the cadence would operate on has to be tested in the hardest environment the practitioner works in, and the hardest environment most practitioners work in is a PCI one.

## What "PCI environment" actually means in identity terms

The acronym does a lot of work. PCI-DSS — the Payment Card Industry Data Security Standard — covers twelve requirements across six goals, written by the PCI Security Standards Council, enforced through contracts between merchants, acquirers, and the card brands. The compliance artefact is a Report on Compliance (ROC) issued by a QSA after an annual assessment. The operational artefact is the network, the systems, and the controls inside the Cardholder Data Environment (CDE) and any system that can affect the security of the CDE — the "connected" and "shared" systems in PCI parlance.

Most of the PCI environment is identity. Cardholder data sits behind an authorisation boundary. The boundary is enforced by network segmentation, by access control, and by authentication. The QSA's evidence pack for the access control domain is the IdP configuration, the access reviews, the MFA enforcement, the privileged-access management, and the logs. If the identity layer is solid, the CDE is solid. If the identity layer is what a generic enterprise has — credentials in a sprawl, a help-desk account that has not been rotated since the last acquisition, an OAuth integration that grants more than it should — the CDE is only as solid as the IdP.

The exercise that tests the identity layer has to test it as the QSA will see it. The exercise that does not will produce a finding the CDE controls can be defended against on paper, while the actual reach is wider than the assessor knew. That is the gap this essay is about.

## What a generic exercise misses

Three things, in order of how often they bite.

**1. The CDE segment is invisible to the exercise's path graph.**

A standard identity-focused exercise runs the path graph against the enterprise IdP and the systems joined to it. The graph shows every principal, every group, every reachable resource. The exercise tests whether the attacker can use a leaked credential to traverse the graph from a low-trust entry to a Tier Zero target.

In a PCI environment, the Tier Zero target is the CDE — but the CDE is segmented. The segmentation may be physical (separate network), logical (firewall + VLAN), or application (P2PE, tokenisation, end-to-end encryption). The path graph the generic exercise built does not model the segmentation accurately, because the exercise was scoped to identity paths, not network paths. The result is a graph that shows "principal P can reach resource R", where R is a host that has a path through the CDE firewall, and the exercise reports that reach as a credential compromise. The QSA reads the report. The QSA asks whether the CDE firewall was modelled. The exercise cannot answer, because the exercise did not scope network reach. The finding is technically true and operationally misleading.

The exercise that holds inside a PCI environment treats the CDE segment as a first-class object in the path graph. The path "P can reach host H, which has a route to CDE" is not equivalent to "P can reach CDE". The first requires a network path that the CDE firewall enforces. The second requires the attacker to cross the CDE boundary. The exercise has to test the boundary, not assume it.

**2. The QSA evidence pack is the artefact the exercise has to talk to.**

Most programmes scope the exercise to detection, response, and reach. The PCI environment adds a third axis: the evidence the QSA will need at the next assessment. The exercise that surfaces a credential-driven finding inside the CDE produces two outputs. The first is the detection and response work — the standard purple team output. The second is the control-evidence gap — the part of the QSA's evidence pack that does not match what the exercise found.

In one engagement, the exercise found a service account with administrative rights to a CDE-adjacent system. The account was in the QSA's evidence pack as a service account with monitoring, MFA, and quarterly access review. The exercise found the MFA was enforced on the human principal but not on the service account's automated authentication path. The control was documented as in place. The control was not in place. The QSA's evidence was stale.

The exercise has to include a control-evidence walkthrough as a final step. The findings get written up. The control documentation gets read against the findings. The gaps between the documentation and the actual control state get reported separately, not as a security finding but as a compliance evidence gap. The QSA's next assessment is in nine days. The compliance team needs the gap list to update the ROC before the assessment, not after it. A generic exercise does not produce this output. A PCI-aware exercise does.

**3. The assessor sign-off is the cycle the exercise has to fit inside.**

A generic enterprise exercise runs on a programme calendar — quarterly, monthly, whatever the team agreed. A PCI environment runs on the QSA assessment cycle. The annual assessment is in Q-something. The quarterly internal scan is in the month before it. The ASV scan is in the six weeks before that. The exercise has to land in a window where its findings can be remediated and the remediation can be evidenced before the next QSA visit.

Most programmes schedule the exercise in the wrong window. They run it in Q1 because Q1 is when the security team planned it. The QSA assessment is in Q3. The exercise produces a finding in Q1. The remediation lands in Q2. The QSA assessment in Q3 sees the Q2 remediation and the unremediated Q1 finding in the same report. The exercise has made the QSA's job harder, not easier.

The exercise that holds inside a PCI environment is scheduled in the eight-to-ten week window before the QSA assessment. Long enough to remediate the findings, short enough that the findings are still current. The exercise is part of the QSA's evidence cycle, not a parallel calendar the security team runs.

## The four exercise types a PCI environment actually needs

The identity-focused framework the previous essays named — the joins, the containment order, the rehearsal — applies. The exercise type that is run inside a PCI environment is shaped by the environment's specifics.

**Type 1: CDE adjacency.** A leaked credential at a non-CDE system. The exercise tests whether the credential can reach the CDE through the segmentation, and what the SOC sees on the way. This is the most common exercise type and the most likely to produce a real find, because the segmentation is where most CDE controls break.

**Type 2: CDE internal.** A credential with a defined role inside the CDE — a payments application operator, a settlement system administrator, a key management service user. The exercise tests whether the credential's actual reach matches its documented role, and whether the SOC can spot a credential doing something outside its role. The output is almost always a control gap: the role is broader than the documentation, the documentation is broader than the actual control, and the SOC has no signal to tell the difference.

**Type 3: Supplier adjacency to the CDE.** A third party that has a defined access path into the CDE — the payment gateway vendor, the fraud-detection SaaS, the QSA's evidence-collection tool. The exercise tests the supplier's path with the same scrutiny the previous essays applied to the supplier-help-desk path, and adds the CDE-specific question: does the supplier's reach match what the QSA's evidence pack says it should. In one engagement, a payment-gateway vendor's admin access was documented as scoped to a specific CDE subnet. The exercise found the access was scoped at the application layer, not the network, and the vendor's admin role could reach systems the QSA believed to be out of scope.

**Type 4: PCI evidence gap.** Not a TTP exercise at all. A walkthrough of the QSA's evidence pack against the actual control state. The exercise is a structured review: every control in the access-control domain, every documented configuration, every sample account. The output is the list of evidence gaps — controls documented as in place that the walkthrough cannot verify, controls in place that are not documented, and the gaps between. The output is what the compliance team needs before the next assessment.

## What the exercise has to verify before it can claim a PCI result

Five things. Three are inherited from the identity-focused framework. Two are PCI-specific.

**1. The path graph models the CDE segment.** The exercise scope includes the CDE firewall rules, the P2PE tokenisation boundary, the encryption layer, and the network segmentation. The path graph does not produce a reach finding that crosses the CDE without naming the boundary it crossed.

**2. The SOC analyst can join the auth event to the CDE boundary.** The identity signals — the joins post-28 named — are wired up for the CDE-adjacent systems. A leaked credential attempting to cross the CDE boundary produces a join the SOC can act on in under ten minutes, including the CDE firewall log line.

**3. The containment order rehearses the CDE-specific moves.** Credential revoked. Session killed. CDE-specific session tokens (P2PE tokens, payment application sessions) invalidated. The tokenisation provider notified if the credential could reach the tokenisation boundary. The exercise dry-runs these moves against a real scenario, in the CDE order, with the tokenisation provider's IR contact in the room.

**4. The QSA evidence pack matches the control state.** Every control in the access-control domain is reviewed against the live state. The gaps are listed, with owner, due date, and the part of the ROC the gap will affect. The compliance team has the list before the next assessment, not during it.

**5. The exercise window leaves time to remediate.** The findings are produced in time for the QSA's evidence to be updated. The exercise is not a one-time event; it is a recurring input to the compliance cycle.

## What the previous framework does not survive

The identity-focused framework the previous essays built — the join work, the rehearsal work, the response work — survives in a PCI environment, but the priorities change. The join work is unchanged. The rehearsal work is unchanged. The response work is extended to include the CDE-specific containment moves, the tokenisation provider, and the evidence pack update.

The thing that does not survive is the time-to-detect dashboard. A generic exercise produces a metric — median time to detect, median time to contain — and the metric is reported as a programme output. In a PCI environment, the metric is necessary but not sufficient. The QSA asks for the metric. The QSA also asks for the control evidence, the access review, the MFA enforcement on every principal type including service accounts, and the evidence walkthrough. The metric without the evidence is a finding the QSA will note. The evidence without the metric is a finding the SOC will note. Both are required.

The exercise that holds inside a PCI environment produces both. The metric is the SOC's output. The evidence gap list is the compliance team's output. The two are produced from the same exercise run. The exercise is sized to produce both — the SOC's slice is three weeks of analyst time, the compliance team's slice is one week of evidence review. The exercise is not a single artefact. It is two artefacts from one run.

## What this means for the exercise

The identity-focused exercise is not finished when it produces a real find. The PCI environment adds two completion criteria: the find is reported against the CDE segment accurately, and the control evidence gap is listed for the compliance team before the next QSA assessment.

The exercise has to fit inside the QSA's evidence cycle. The exercise has to model the CDE segment as a first-class boundary. The exercise has to produce a control-evidence gap list, not just a security finding. The exercise has to be the input to the compliance cycle, not a parallel programme that occasionally lands a finding in the QSA's report.

If the exercise cannot verify these four things, the report it produces is a report on what would have been contained if the CDE had been modelled. That is a generic report, not a PCI one. A generic report in a PCI environment is the kind of report the QSA reads, asks two questions about the CDE modelling, and notes in the ROC that the exercise did not address the segmentation assumption.

Most programmes running a generic identity-focused exercise in a PCI environment today are running exactly that report. The fix is not a new framework. The fix is the existing framework, applied to the CDE specifically, with the evidence cycle wired in. The same joins, the same containment order, the same rehearsal work — extended to the CDE boundary, sized to the QSA's window, and producing two outputs instead of one.

## The discipline that earns the next exercise

The identity-focused exercise finds the credential. The PCI environment adds the boundary. The QSA's evidence cycle gives the exercise its place in the calendar. The next exercise, in the next quarter, runs in the same window, against the same boundary, with the gap list from this exercise as its scope.

The work that makes the PCI environment survivable is the work that happens between exercises. The CDE segment is modelled. The control evidence is reviewed. The compliance cycle is closed before the QSA's next visit. The next exercise inherits a smaller gap list, a tighter CDE model, and a compliance team that has read the gap list before the assessor did.

That is what the PCI-environment version of identity-focused purple teaming is for.

---

This essay is the third in a series on purple teaming in environments where identity is the perimeter. The first was [Purple Teaming Your Identity Environment: Where the Real Attacks Live Now](/essays/purple-teaming-your-identity-environment/). The second was [Containing a Credential-Driven Intrusion: What Good Looks Like in the First Hour](/essays/containing-a-credential-driven-intrusion/). The next will be the longer-tail piece: how to turn the lessons of one exercise into a quarterly cadence that actually changes the exposure graph, not just the report — with a worked example that runs across the QSA's evidence cycle, not parallel to it.
