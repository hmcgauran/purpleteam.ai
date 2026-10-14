---
title: "Quarterly Cadence: How Identity Purple Teaming Survives a Year in a Regulated Environment"
slug: "quarterly-identity-purple-team-cadence"
date: 2026-10-22
tags:
  - "Purple Teaming"
  - "Identity"
  - "PCI"
  - "Detection Engineering"
  - "Programme Operations"
  - post
author: Hugh McGauran
excerpt: "The first three essays in this thread built the framework. The fourth is the one the framework was for: what happens when the same exercise runs four quarters in a row in the same environment, against the same boundary, with the previous gap list as its scope. This is a longitudinal essay — one anonymised regulated environment, four quarterly runs, the deltas in the gap list, the CDE model, the response time, and the evidence pack. It closes the identity series with the thing the previous essays deferred: a cadence that survives a year."
layout: layouts/post.njk
permalink: /essays/quarterly-identity-purple-team-cadence/
---

The three previous essays in this series built the framework. The first described where the credential attacks live in an identity environment. The second described what good looks like in the first hour of a credential-driven intrusion. The third described what a generic identity exercise misses in a PCI environment.

This essay is the one the framework was for.

The question the previous essays deferred is the question that decides whether the framework holds in a programme. The question is not whether the exercise can find a credential. The question is whether the exercise, run four quarters in a row in the same environment, against the same boundary, with the previous gap list as its scope, changes the exposure graph — or whether it produces four reports on the same exposure graph.

The answer is closer than most programmes think. Most programmes that run a quarterly cadence are not running a cadence. They are running a single exercise four times. The difference is in the part between the exercises, and the part between the exercises is where the regulated environment either earns the cadence or breaks it.

This essay draws on work with a single anonymised regulated environment — professional services, regulated data holding, 1,800 staff, 174 identity principals, 71% of accounts running with at least one privilege escalation path in Q1 — across four quarterly runs of the same identity-focused exercise. The specifics are anonymised because the customer is not the lesson. The cadence is the lesson. The shape — the deltas in the gap list, the CDE model, the response time, the evidence pack — is what survives across environments and sectors.

It is the fourth and final essay in the identity series.

---

## What the quarterly cadence is actually for

A quarterly cadence is not four exercises. A quarterly cadence is one exercise, run four times, against a baseline the previous run established. The exercise in Q1 finds the gap list. The exercise in Q2 runs against the Q1 gap list. The exercise in Q3 runs against the Q2 gap list. The exercise in Q4 runs against the Q3 gap list. The gap list at the end of the year is the delta from the gap list at the start of the year. The cadence is the delta.

The thing most programmes miss is that the gap list is the scope of the next exercise, not the report of the last one. The Q1 gap list contains twelve findings. The Q2 exercise runs against those twelve findings — does each one still hold, has any of them been remediated, has the remediation introduced a new path. The Q2 report is not "we found twelve things." The Q2 report is "nine of the twelve still hold, two were remediated, one was replaced by a different path that surfaced in the Q2 exercise." The cadence is the discipline of treating the previous gap list as the scope of the next exercise.

The discipline is hard. Most programmes write the gap list into a remediation backlog and forget it. The remediation backlog gets a quarterly review. The exercise gets a fresh scope. The two never meet. The cadence becomes a clock on a wall that says it is running.

In a regulated environment, the gap list is not just a programme artefact. It is the exercise input to the next QSA cycle. The QSA reads the previous report. The QSA asks which findings were remediated, which findings were inherited into the next exercise, which findings were closed by a control change versus which were closed by an evidence change. The cadence is the thing the QSA is auditing, not the rule the QSA is auditing. The difference matters.

## What a four-quarter run actually looks like

The Q1 exercise in this environment found twelve findings. Three were CDE-segmentation findings: the boundary held, but the boundary was modelled as a single subnet rather than as the segmented zones the assessor's evidence pack required. Three were service-account findings: 23 service accounts running with no MFA, four of which had active session tokens older than ninety days. Two were detection findings: two SOC alerting rules had been silently disabled in a change window and the SOC did not know. Two were join findings: the join between the identity provider and the asset inventory was ninety-six hours stale, which meant the credential-driven scenario in the exercise ran against a join that was already broken. Two were evidence findings: the access review had not been updated since the last assessor visit, and the access review was the artefact the QSA was going to ask for first.

The Q2 exercise ran against those twelve findings. The CDE segmentation was re-modelled into four zones. The service-account MFA enforcement was extended to all 23 service accounts and the session-token rotation was put on a 30-day schedule. The two detection rules were re-enabled and the change window was added to the SOC's exception register. The identity-asset join was moved to a fifteen-minute cadence. The access review was re-run before the next assessor visit.

The Q2 exercise found seven new findings. Three were CDE-adjacent findings — the four-zone segmentation held, but the access path between zones two and three had a service account that bypassed the segmentation in a way the Q1 model had not represented. Two were detection findings — the SOC's alerting on cross-zone service-account activity was missing. Two were evidence findings — the re-modelled CDE segmentation required an updated network diagram in the evidence pack, and the diagram had not been updated since the re-model.

The Q3 exercise ran against those seven findings. The cross-zone service account was re-scoped to a zone-internal account. The cross-zone alerting was added. The network diagram was updated.

The Q3 exercise found four new findings. Two were evidence findings — the evidence pack update introduced two control changes the QSA had not been briefed on. One was a join finding — the new alerting on cross-zone activity was joined to the wrong asset table and was firing on the wrong principals. One was a CDE-segmentation finding — the cross-zone re-scoping had created a new inter-zone path that the segmentation model did not represent.

The Q4 exercise ran against those four findings. The evidence briefing was added to the assessor's pre-walk. The join was re-pointed. The inter-zone path was added to the segmentation model.

The Q4 exercise found two new findings. One was the finding the Q1 exercise could not have found: a credential rotation gap in a SaaS integration that held the regulated data for a downstream customer — a credential that had not been rotated since the integration was onboarded eighteen months before the Q1 exercise, and that the Q1 exercise had not modelled because the integration had not been in the Q1 scope. One was an evidence finding — the assessor's pre-walk surfaced a control gap the exercise had not been designed to find, because the assessor's evidence cycle asks questions the exercise does not.

The Q4 gap list has three findings. The Q1 gap list had twelve. The cadence is the delta from twelve to three. The cadence is also the reason the Q4 exercise could find a credential rotation gap that the Q1 exercise could not have found: the Q4 exercise was scoped against a baseline the Q1 exercise established, and the baseline included the join between the identity provider and the asset inventory, the join between the identity provider and the SaaS integration registry, and the join between the SaaS integration registry and the regulated data holding. None of those joins existed in Q1. All of them existed in Q4 because the Q2 and Q3 exercises had added them.

The cadence is the work between exercises, not the exercises themselves. The work between exercises is the join work, the evidence work, the remediation work. The exercises measure the delta. The work between exercises produces the delta.

## What survives the QSA's evidence cycle

The thing that makes a regulated-environment cadence survivable is the thing the exercise has to be wired into: the QSA's evidence cycle. The QSA visits annually. The QSA's evidence cycle is the work the customer does between visits. The exercise is one input to that work. The evidence pack is the artefact the QSA reads. The exercise produces findings. The findings become remediation. The remediation becomes evidence. The evidence becomes the evidence pack.

The cadence holds when the exercise is sized to produce the evidence, not just the finding. The exercise in Q1 produces a finding and a control-evidence gap. The exercise in Q2 produces a finding and a control-evidence update. The exercise in Q3 produces a finding and a control-evidence reconciliation. The exercise in Q4 produces a finding and a control-evidence briefing for the assessor's next visit.

The cadence breaks when the exercise is sized only to produce the finding. The exercise reports the credential rotation gap in Q4. The exercise does not update the evidence pack. The QSA visits in Q1 of the next year. The QSA asks when the credential rotation gap was found, when it was remediated, and what the remediation was. The customer has to reconstruct the timeline from the report, the change-management system, and the evidence pack. The reconstruction is the gap. The cadence is supposed to prevent the reconstruction. The cadence has not prevented it because the exercise was sized for the finding, not for the evidence.

The size of the exercise in a regulated environment is three weeks of analyst time for the SOC's slice and one week of evidence review for the compliance team's slice. The two are produced from the same exercise run. The exercise is not a single artefact. It is two artefacts from one run. The cadence is the two artefacts, repeated four times a year, with the previous gap list as the scope of the next.

## The finding the Q1 exercise could not have found

The Q4 finding — a credential rotation gap in a SaaS integration holding regulated data for a downstream customer — is the kind of finding the cadence earns. The Q1 exercise did not model the integration because the integration had not been in the Q1 scope. The Q1 scope was the on-premises identity environment, the on-premises asset inventory, and the on-premises detection stack. The Q1 exercise could not have found the integration's credential rotation gap because the integration was not in the model.

The Q2 exercise added the SaaS integration registry to the asset inventory. The Q2 exercise did not find the rotation gap because the registry did not carry the credential's last-rotation timestamp. The Q3 exercise added the last-rotation timestamp to the registry. The Q3 exercise did not find the rotation gap because the registry's timestamp was not joined to the credential's actual rotation policy. The Q4 exercise added the join.

The Q4 exercise ran against a model that had been built incrementally over four quarters. The model included the integration, the rotation timestamp, the rotation policy, and the join. The exercise found the gap because the model could represent the gap.

The cadence is the model. The exercise is the thing that runs against the model. The model is built between exercises. The exercises measure the model. The findings are the model's blind spots.

The Q1 exercise could not have found the finding because the model could not have represented it. The cadence is what produces a model that can represent the finding. The cadence is the work. The exercise is the measurement. The work is the join between the identity provider and the asset inventory and the SaaS integration registry and the rotation timestamp and the rotation policy. The cadence is the joins.

## What a quarterly cadence requires that a single exercise does not

A single exercise requires an analyst team and a threat model. A quarterly cadence requires three things the single exercise does not:

1. **A baseline.** The Q1 exercise produces the baseline. The baseline is the asset inventory, the principal inventory, the join between them, the detection stack, the evidence pack, and the segmentation model. The baseline is the artefact the next exercise runs against. Without the baseline, the next exercise is a fresh exercise with a fresh scope. Without the baseline, there is no cadence — there are four fresh exercises.

2. **A join steward.** The joins between the identity provider and the asset inventory and the SaaS integration registry and the rotation timestamp do not maintain themselves. The joins are owned by a person or a team whose job is to keep the joins current. The join steward is the role that does the work between exercises. The join steward is the role the cadence pays for. Most programmes do not have a join steward. Most programmes have an exercise analyst team that writes a report every quarter and a SOC that runs detections and a compliance team that updates the evidence pack. The three teams do not meet. The joins drift. The cadence drifts with them.

3. **A scope handoff.** The Q1 exercise's gap list is the Q2 exercise's scope. The handoff is a meeting, a document, a tracked item in a system. The handoff is not a forward-reference in the Q1 report. The handoff is a specific artefact that says "these twelve findings are the Q2 scope; the Q2 exercise will verify each one and report on which still hold." The handoff is what makes the cadence a cadence. Without the handoff, the Q2 exercise is a fresh exercise.

The cadence requires the baseline, the join steward, and the scope handoff. The cadence does not require a more sophisticated exercise. The cadence requires the same exercise, run four times, against the baseline the previous run produced.

## The discipline that earns the next year

The Q1 exercise finds twelve findings. The Q4 exercise finds three. The delta from twelve to three is the cadence. The delta is also the reason the Q4 exercise could find a credential rotation gap the Q1 exercise could not have found: the cadence produced a model that could represent the gap.

The work that makes a quarterly cadence survivable is the work that happens between exercises. The baseline is established in Q1. The joins are built between Q1 and Q4. The join steward keeps the joins current. The scope handoff carries the gap list from one exercise to the next. The evidence pack is updated from each exercise. The assessor's evidence cycle reads the updates. The cadence earns the next year's evidence cycle by producing the evidence the next cycle reads.

Most programmes run a single exercise every quarter. Most programmes do not run a quarterly cadence. Most programmes have four reports and no delta. The delta is the cadence. The cadence is the work between the exercises.

The exercise is the place to measure the cadence. The exercise is not the cadence. The cadence is the model the exercise runs against. The model is built between exercises. The exercises measure the model. The findings are the model's blind spots.

That is what a quarterly cadence of identity-focused purple teaming is for.

---

This essay is the fourth and final in a series on purple teaming in environments where identity is the perimeter. The first was [Purple Teaming Your Identity Environment: Where the Real Attacks Live Now](/essays/purple-teaming-your-identity-environment/). The second was [Containing a Credential-Driven Intrusion: What Good Looks Like in the First Hour](/essays/tbd-essay-29/). The third was [Purple Teaming a PCI Environment: What a Generic Identity Exercise Misses](/essays/purple-teaming-a-pci-environment/). The series closes here. The next thread will move from the perimeter to the joins — how the joins between identity, asset, SaaS, and rotation registries are built, owned, and kept current, and why the join work is where most identity programmes quietly lose the cadence.