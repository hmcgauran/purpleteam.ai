---
title: "Purple Teaming OT: Why \"We Can't Test That\" Is No Longer Acceptable"
slug: "purple-teaming-ot"
date: 2026-04-23
tags:
  - "OT Security"
  - "Purple Teaming"
  - "ICS"
  - "Critical Infrastructure"
  - post
author: Hugh McGauran
excerpt: "I keep hearing the same thing in conversations about operational technology security"
layout: layouts/post.njk
permalink: /essays/purple-teaming-ot/
---
I keep hearing the same thing in conversations about operational technology security.

> "We can't purple team OT. The risk is too high. You can't test live systems."

That view made sense in 2015. It does not make sense now. The threat actors attacking energy, utilities, and critical infrastructure are not holding back out of concern for operational continuity — and your detection capability has no idea whether it works until you test it.

The question is not whether to test OT environments. The question is how to do it without causing the incident you are trying to prevent.

## The real problem is not the systems — it is the approach

When people say OT cannot be tested, they usually mean one of two things: they tried to apply IT purple team methodology directly to OT and something broke, or they have never done it and they are extrapolating from the horror stories of people who did it wrong.

OT environments are unforgiving. A misconfigured command to a PLC does not generate a BSOD — it can trigger a physical consequence. Latency-sensitive protocols like Modbus and DNP3 respond badly to unexpected traffic. Safety instrumented systems exist for a reason.

None of that means you cannot test. It means you need to be more disciplined about how you do it.

## Three principles that change the equation

**1. Craft TTPs with clear operational objectives before you touch anything**

Every TTP you plan to emulate must be tied to a specific detection question. Not "can we simulate Industroyer?" but "if an adversary used Industroyer's lateral movement pattern from the engineering workstation to the HMI, would our SIEM alert on it, and within what timeframe?"

The TTP is a vehicle. The detection question is the destination. If you cannot articulate the detection question, you are not ready to run the test.

This forces the red team to think like a threat, and forces the blue team to pre-commit on what good detection looks like — before they know the outcome.

**2. Test on virtual environments first, without exception**

A high-fidelity OT testbed is not optional — it is the prerequisite for running any test in a live environment. Most asset owners in energy and utilities either have one or can access one through their ICS vendor or an MSSP with OT capability.

You run the full TTP in the virtual environment. You validate that it behaves as expected. You confirm that the detection logic fires (or confirm that it does not, which is itself a finding). You document the exact execution sequence, timing, and expected artefacts.

Only then do you consider a controlled execution in the live environment — and only for those elements where live-environment fidelity actually matters to the detection question.

**3. D-Day tests are controlled, time-boxed, and pre-notified to operations**

If you run a test in a live OT environment without the operations team knowing the time window, you have created unnecessary risk and guaranteed a bad outcome if anything goes wrong.

The D-Day test is not a surprise for operations — it is a surprise for the SOC. The operations team knows: time window, what systems are in scope, what the abort condition is, and who the single point of contact is if they need to halt. The SOC does not know it is happening.

This structure lets you get genuine detection fidelity without creating an incident.

## What you will find

The findings from OT purple team exercises are remarkably consistent. I have seen variants of the same list across energy clients, utilities, and manufacturing environments:

- **Logs not piped to the SIEM.** OT assets generating security-relevant events — historians, HMIs, engineering workstations — are either not logging or logging to a destination that nobody monitors. The SOC has no visibility into what is probably your most targeted environment.

- **Inconsistent asset classification.** The asset inventory treats a Windows-based HMI the same as a corporate laptop. Different patch cadence, different network controls, different authentication standards — but the risk classification does not reflect it. Detection rules built for IT assets do not translate.

- **Detection tools not calibrated for OT protocols.** If your SIEM ingests OT network traffic, the alert rules were almost certainly written for IT traffic patterns. Modbus function code anomalies, unexpected DNP3 unsolicited responses, and OPC-UA enumeration all look different from SQL injection and lateral movement in Active Directory.

- **No playbooks for OT incidents.** The SOC knows what to do when a Windows endpoint is compromised. They have no playbook for a compromised engineering workstation with a live connection to a control system. The decision escalation path does not exist.

None of these findings require you to break anything to discover them. They require you to ask the right questions, map the visibility gaps, and test whether your detection logic can see what it needs to see.

## The asymmetry argument

Here is the strategic case if you still need one.

Adversaries targeting OT environments — state actors, ransomware groups operating in critical infrastructure, hacktivists — are already doing the reconnaissance. Volt Typhoon spent years in US critical infrastructure. Sandworm has hit power grids twice with demonstrable effect. ALPHV hit pipeline infrastructure without triggering a single pre-incident detection.

Your detection coverage in OT is either tested and validated, or it is assumed. Assumption is not a defence posture.

The risk of a controlled, well-scoped purple team exercise is small. The risk of finding out your detection capability is non-existent during an actual incident is significant.

## Where to start

If you have not done OT purple teaming before, start narrow:

1. Pick one site, one asset class, one threat scenario. Not the whole estate.
2. Get a high-fidelity testbed. If you do not have one, find a vendor or partner who does.
3. Define three detection questions before you write a single TTP.
4. Run the testbed exercise end to end. Document every gap.
5. Fix what you can fix before you touch the live environment.
6. Only then plan a live D-Day test, and only for the detection questions where live fidelity is essential.

The first exercise will produce more findings than you can action in a quarter. That is fine. You will have replaced assumption with evidence — and evidence is how you prioritise.

---

*Hugh McGauran is Country Manager for Ireland at Armis and has 25 years of experience in cybersecurity. PurpleTeamAI explores practical purple team methodology for practitioners who need results, not frameworks.*
