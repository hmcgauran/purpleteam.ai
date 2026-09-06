---
title: "How to Scope a Red Team Engagement That Tells You Something Real"
slug: "scoping-a-red-team-engagement"
date: 2026-04-17
tags:
  - "Red Team"
  - "Purple Teaming"
  - "Threat Modelling"
  - post
author: Hugh McGauran
excerpt: "Most red team engagements produce an impressive document and a set of \"critical findings\" that the security team could have predicted before the first phishing email was sent"
layout: layouts/post.njk
permalink: /essays/scoping-a-red-team-engagement/
---
Most red team engagements produce an impressive document and a set of "critical findings" that the security team could have predicted before the first phishing email was sent.

The problem is usually not the red team. It's the scope conversation. Nobody has it properly.

Here is how to have it.

## Start with the question you actually want answered

The scoping conversation that produces useless engagements sounds like this:

> "Test our security posture against advanced threats. Be creative."

The scoping conversation that produces useful engagements sounds like this:

> "Given that our primary threat is financially motivated actors targeting customer payment data, can they reach the payment processing systems from a compromised workstation in our Manchester office, and would we detect them before they got there?"

The second version has a specific adversary, a specific entry point, a specific objective, and a detection question embedded in it. The first version has none of those things, so red team invents all of them — usually in their own favour.

**Your first job in scoping is to write down the question you want answered.** One paragraph. If you cannot write it down, you are not ready to scope.

## Build scope from threat model, not from technique list

Most scoping starts with techniques: "We want to test phishing, lateral movement, persistence, and exfil." That is backwards.

Start with the threat model:

- **Who is likely to target us?** Be specific. Financially motivated criminals? Competitors? Nation-state? Insider?
- **What do they want?** What data or systems are the actual target?
- **How do they typically get in?** Phishing? Supply chain? Exposed credentials?
- **What does realistic movement look like?** Not "everything on the network" — what would they actually try to reach and how?
- **What constraints do they operate under?** Time pressure? Detection avoidance? Noise tolerance?

Once you have answered those questions, the technique list writes itself. And more importantly, techniques that do not fit your actual threat model get dropped.

## Write explicit success and failure criteria

This is the single most neglected part of red team scoping. Most engagements have no stated criteria for what success looks like.

Without success criteria, red team will always succeed — because they define success as "we got somewhere interesting."

Write it down before the engagement:

**Success for red team:** They reach the target system, exfiltrate a defined data set, and do so without detection.

**Success for blue team:** They detect the activity within a defined time window, from a defined detection point, and contain it before objective is reached.

**Partial success:** What does it mean if red team reaches the target but is detected? What if they are not detected but never reach the target because segmentation blocked them?

These definitions have to be agreed by both teams and by leadership before the engagement starts. They cannot be redefined after the fact.

## Define the starting position precisely

"Assume initial access" is not a starting position. It is an excuse to skip the hardest part.

For a useful engagement, the starting position should be:

- **Where exactly is red team?** A phishing-compromised user workstation in a specific office? A contractor account? A supply chain compromise?
- **What access does that starting position realistically give them?** What systems can they reach? What credentials do they have? What can they see?
- **What controls are in place at that starting position?** EDR, network monitoring, conditional access?

If you say "assume workstation compromise in the marketing department," that means red team starts with the access a phished marketing employee actually has — not admin on the domain controller.

## Scope systems explicitly, not by implication

The most common scoping failure: undefined boundaries.

If you do not explicitly say a system is in scope, red team will assume it is. That leads to findings on systems that have nothing to do with your threat model, which wastes everyone's time.

Write it out:

**In scope:**
- Workstations in the Manchester office
- The shared file server at [address]
- The payment processing staging environment
- Credentials available from a phished marketing employee

**Out of scope:**
- Production payment systems (test in staging only)
- SCADA and operational technology systems
- HR systems (different threat model, separate engagement)
- Any system requiring physical access

If you do not write the out-of-scope list, red team will find their way into systems that generate impressive-sounding findings but tell you nothing about the threat you actually face.

## Agree time constraints upfront

Real attacks are not multi-week affairs where the attacker has unlimited attempts. They are time-pressured.

Define it:

- Red team has 48 hours from initial access to reach the objective
- If not reached in 48 hours, the engagement concludes that phase
- Blue team knows an exercise is running and is actively hunting from hour zero

This changes the exercise significantly. Red team cannot brute-force their way through every possible technique. They have to prioritise, which is what a real attacker does.

## The detection question is as important as the access question

Most scoping focuses entirely on whether red team can reach the objective. That is only half the question.

The equally important question: at what point does blue team know red team is in the environment?

Design the scope to answer both:

- Can an attacker reach the target? (access question)
- When and how would we know they were there? (detection question)

If you only answer the first question, you learn you have a gap but not how to close it. If you answer both, you have something to act on.

## Practical scope document structure

A usable scope document has six sections:

1. **The question** — one paragraph, what you are trying to learn
2. **Threat model** — who, what they want, how they operate
3. **Starting position** — precise definition of initial access and access level
4. **In scope systems** — explicit list, no ambiguity
5. **Out of scope systems** — explicit list, with brief rationale
6. **Success and failure criteria** — defined for red team, blue team, and partial outcomes

That document gets signed off by red team lead, blue team lead, and the engagement sponsor before anyone runs a single command.

## The uncomfortable outcome of good scoping

When you scope properly, two things happen that most organisations find uncomfortable.

First, red team may fail. They may not reach the objective within time constraints, because your controls work for the threat model you care about. That is a good outcome. It should be celebrated, not treated as a sign the exercise was not worthwhile.

Second, the findings are narrower. You will not get a 40-page report with 200 findings. You will get a precise answer to the precise question you asked. That is more valuable, but it looks less impressive in a board deck.

If your organisation rewards impressive-looking reports over honest answers, that is a culture problem. Fix the culture, not the scope.

---

*Next week: Building a detection baseline — the work nobody wants to do, and why it is the foundation of everything else.*
