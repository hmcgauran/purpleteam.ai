---
title: "Why Your Red Team Tests Are Designed to Fail, And You Don't Know It"
slug: "red-team-tests-designed-to-fail"
date: 2026-04-02
tags:
  - "Purple Teaming"
  - post
author: Hugh McGauran
excerpt: "Red team comes in on Monday. They've got a scope, a timeline, and a list of techniques to test. By Friday, they've \"successfully executed\" initial access, lateral movement, persistence, and exfiltration"
layout: layouts/post.njk
permalink: /essays/red-team-tests-designed-to-fail/
---
Red team comes in on Monday. They've got a scope, a timeline, and a list of techniques to test. By Friday, they've "successfully executed" initial access, lateral movement, persistence, and exfiltration.

Blue team reviews the engagement. They have a list of "findings." Detection missed everything. Security posture looks weak.

So you hire another consultant. You buy more tooling. You run the test again next quarter.

Same results.

Here's what nobody tells you: **Your red team isn't testing what you think they're testing.**

## The Scope Problem

Let me walk you through a real engagement.

Client is a mid-market insurance company. They scope the red team exercise: "Test our security posture against advanced threats. Use realistic techniques. Show us what an attacker could do."

Red team scope:
- Initial access (phishing, watering hole, supply chain)
- Lateral movement (everything on the network)
- Persistence (any means necessary)
- Exfiltration (any data, any method)

This sounds comprehensive. It sounds realistic. It's actually a fantasy.

**Reality:** An attacker targeting this client doesn't have "any means necessary" access to "everything on the network." They have:

- Initial access: Maybe phishing works. Maybe it doesn't. They don't get to pivot to every possible next step.
- Lateral movement: They can move within the compromised subnet and maybe one adjacent network. Hard segmentation blocks them beyond that.
- Persistence: Certain accounts and systems work; others have additional logging and monitoring.
- Exfiltration: They can exfil data, but they're constrained by network egress points and monitoring.

But the red team scope doesn't acknowledge these constraints. So red team tests in a sandbox where every attack succeeds because they're not fighting the real environment—they're fighting an idealized version of it.

## The Environment Problem

Here's where it gets messy.

Red team asks: "What systems can we access?"

Blue team (or the client) says: "Whatever an attacker could realistically access."

This is ambiguous. So red team interprets it broadly: everything reachable on the network is fair game.

What they should have asked: "What systems can an attacker realistically access given our segmentation, credential controls, and monitoring?"

The answer is usually much smaller. A real attacker targeting insurance data doesn't have access to the file servers in marketing, the development lab, or the HVAC management system. But if nobody explicitly excludes those from scope, red team tests them anyway.

Then when red team successfully gets to the marketing server (which has no monitoring), blue team documents it as a detection failure. Really, it's a scope definition failure.

## The Technique Problem

Red team gets creative. They use techniques that sound realistic but aren't actually part of any real attack chain for this environment:

- Kerberos relay attacks (requires certain network conditions that don't exist here)
- Memory-only persistence (requires no EDR; EDR is deployed)
- Named pipe lateral movement (works in the test, but in production the pipes are monitored)
- PowerShell obfuscation (detected by their logging; they just didn't run it in the test)

Red team succeeds because they're testing in isolation. They're testing: "Is this technique *possible*?" not "Is this technique *undetectable in your environment*?"

Blue team thinks detection failed. Really, detection is fine—the technique just wasn't realistic.

## The Time Problem

Red team has unlimited time to find a path. An attacker has limited time before they're detected.

Real attack: Attacker lands, spends 30 minutes poking around, tries three things, gets blocked/detected on the third, leaves (or adapts).

Red team test: Attacker lands, tries thirty things over a week, finds one that works, uses it, succeeds.

The persistence and thoroughness of a week-long engagement is not representative of the speed/detection requirements of a real intrusion.

But nobody talks about this in the debrief. Red team just marks it as "successful lateral movement."

## What This Means

Your red team engagement tells you:

> "Over an extended period, using known techniques, with no time pressure, against systems and networks we can freely access and test, we were able to move laterally and exfiltrate data."

What it doesn't tell you:

> "Against your actual threat model, in real time, with your actual monitoring and detection in place, this is what would happen."

Those are very different questions.

## The Better Approach

**Real-world red team engagements should be scoped to match reality:**

1. **Threat-model driven scope.** Don't test "everything." Test what your actual adversary would target and how they'd move.

2. **Time-limited and detection-aware.** Red team doesn't have unlimited time to brute-force techniques. They have 48 hours to land, move, and exfil before they assume they're burned. Blue team knows they're in the environment and is actively hunting.

3. **Constrained to realistic access.** Red team starts from actual initial access vector (phishing, supply chain, etc.) not from "we've already compromised a workstation." They work with the access they actually get.

4. **Detection evasion is the goal, not secondary.** Red team doesn't just run commands; they try to run them in ways that avoid detection. If it's immediately flagged, it fails—doesn't matter if the technique "works."

5. **Realistic tool constraints.** Red team uses tools an attacker would actually use, not just "what works in this test." If they'd use living-off-the-land, they do. If they'd avoid Mimikatz because EDR would catch it, they do.

## The Uncomfortable Conversation

Here's what I'd tell a client:

> "Your last red team engagement tested whether advanced techniques are *possible* in your environment, not whether they'd *succeed* in a real attack. The findings are less meaningful than you think. Let's reframe the next engagement around your actual threat model and realistic constraints."

This is hard because:
- Red team has to work harder
- Results are less "impressive" (maybe red team fails certain objectives)
- It requires more collaboration between red and blue teams
- It can't be outsourced to a generic red team vendor

But it's honest.

## A Simple Test

Ask yourself: 

- Did red team use techniques because they were realistic for your threat model, or because they worked in the test?
- Would your actual threat actor have access to every system red team tested?
- Did red team have to evade detection, or was it just running commands and seeing what worked?
- Were there time or detection constraints that matched a real attack, or was it an extended, unmolested testing window?

If the answer to any of these is "not really," your engagement was testing techniques, not threats.

---

**Further Reading:**
- NIST SP 800-115 (Technical Security Testing): How to scope and run engagements properly
- Adversary emulation vs. penetration testing: The difference matters
- Detection-driven red teaming: A better framework

**Reality check:** When was your last red team engagement? What did it actually prove?

---

*Next week: How to properly scope a red team exercise. Plus: A case study where realistic constraints changed the entire engagement outcome.*
