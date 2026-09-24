---
title: "Purple Teaming Identity Systems: A Practitioner's Guide"
slug: "purple-teaming-your-identity-environment"
date: 2026-09-24
tags:
  - "Purple Teaming"
  - "Identity"
  - "Detection Engineering"
  - "Red Team"
  - post
author: Hugh McGauran
excerpt: "Identity is the perimeter most attackers now attack first. This is the guide to a purple team exercise that actually tests it: where to look, what to emulate, what to detect, what to measure, and what to do when the exercise finds a real one"
layout: layouts/post.njk
permalink: /essays/purple-teaming-your-identity-environment/
---

Most purple team exercises still test the wrong layer.

A standard exercise starts at the external perimeter, finds a foothold, escalates, pivots, and reports on time-to-detect for the techniques it used. The technique is what gets reported, not the outcome. The attacker is no longer running that exercise. The attacker is logging in with a valid credential that was leaked, exposed, or stolen from a third party the legitimate user has never heard of. The perimeter is not the target. The credential is the target. The credential, the session it opens, and the resources the session can reach are the target.

If your purple team exercise is not testing that, it is not testing the layer the attacker is attacking.

This guide is for the practitioner running an identity-focused exercise. It covers where to look first, what to emulate, what to detect, what to measure, and what to do when the exercise turns up a real exposure. It draws on work with mid-to-large enterprises and managed-service providers across regulated and unregulated environments — the specifics anonymised below because the customers are not the lesson. The pattern is the lesson.

## Where to look first: the credential surfaces

A credential is anything that authenticates: a username and password, a service account key, an OAuth refresh token, an API key in a CI pipeline, a session cookie on a managed device, an SSH key on a jump host, an SSH key on a contractor's laptop, a personal access token on a developer's personal GitHub repository, an AI tool's API key pasted into a config file, a vendor's help-desk password reused on three customer VPNs.

Most of those credentials are not in your environment. They are in the environments around yours: the personal repos of your staff, the public packages your code depends on, the SaaS tools your business runs on a credit card, the help-desk accounts your MSP uses to administer your tenant, the OAuth tokens your AI assistants hold to talk to your data. The exposure you are looking for is the exposure you do not control. That is what "outside in" actually means in identity terms: the credential you have never seen is the credential that gets you owned.

A real exposure monitoring programme covers all of those surfaces. A purple team exercise that wants to test the identity layer starts there, because that is where the attacker starts.

## The numbers that make this urgent

Three numbers from recent work that should change what gets measured.

The first is the lifespan of a leaked secret. In a recent review of public code and package repositories, the majority of secrets that had been verified valid in 2020 were still valid at the start of 2026. Six years is a long time. A credential rotation programme that runs once a year is a credential rotation programme that misses five years of that lifespan.

The second is the volume at one organisation. A mid-sized professional services firm — roughly 1,800 staff — ran a single identity-exposure programme. The result was 174 accounts in scope. Volume is not the problem. The problem is which of those 174 reach a Tier Zero system, a crown-jewel resource, a domain controller, a SaaS tenant holding regulated data. The volume is the queue. The reach is the question.

The third is the gap between coverage and exposure. In one environment, an initial attack-path review found 71% of principals could reach a Tier Zero target, with around three quarters of a million attack paths in the graph. After a focused remediation sprint, the figure dropped to 8%. Eight percent looks like a pass. Inside the 8%, four leaked accounts still reached Tier Zero. Coverage was a milestone, not proof. The exposure was still live, the score had just moved.

These three numbers — six-year lifespan, hundreds of accounts per environment, low scores hiding live paths — are why the exercise matters. They are also why the exercise has to be designed against the actual exposure surface, not against a vendor's demo environment.

## What the supply chain adds

Identity does not stop at your boundary. Three worked examples from the last twelve months.

**The build dependency.** A widely-used open-source security scanner was compromised through a hard-coded token left exposed for roughly twenty days. An AI orchestration library pulled the scanner as a build dependency in the background. The malicious update propagated through the orchestration library into thousands of organisations. Cloud keys, SSH keys, and tokens were exposed. The lesson is not that the scanner vendor was careless — the lesson is that a single leaked token in a build dependency is an identity compromise for every downstream consumer, and most consumers do not know the token exists.

**The supplier help-desk account.** In one engagement, an engineer's working password at a customer's outsourced IT provider appeared in an infostealer dump. That engineer held help-desk rights in the customer's environment, including the right to force a password change on a server admin account. The same leaked password logged straight into the customer's VPN because MFA was not enforced on the supplier account. One credential, one supplier, one missing control, straight onto the internal network.

**The vendor's public repository.** In another environment, a regional utility's external monitoring found a hard-coded secret in a public repository belonging to a SaaS vendor that ran the utility's customer-billing portal. The vendor ran the platform. The utility owned the customer data and the regulatory exposure. The exposure sat in neither environment's patch surface. It sat in a third party's hygiene. The question of who to tell first — the customer or the vendor, and in what order — is a real one, and most IR playbooks do not answer it.

In each of these cases, the attacker's first move was not an exploit. It was a login.

## What to emulate in the exercise

A purple team that is emulating Kerberoasting, Pass-the-Hash, and NTLM relay in isolation is testing a layer the attacker is no longer trying to attack first. Those techniques still matter. They are not the first move.

The first move, in the environments where the work is happening now, looks like one of these:

- A leaked credential surfaced from a public repository, an infostealer dump, or a third-party breach, used to log in via the legitimate entry point — VPN, IdP, SaaS console, supplier portal.
- An OAuth refresh token replayed from a session cookie stolen from a personal device. The token is valid. The session is valid. The user is the user's IP, in the user's browser, in the user's normal pattern.
- A service-account key from a CI pipeline or build dependency used to authenticate against a cloud control plane or internal API.
- A supplier's help-desk account used to reset a privileged password inside the customer environment. The supplier is trusted. The reset is routine. The follow-on is the attacker.
- An AI assistant's API key pasted into a config file, used to read a customer tenant because nobody rotated the key after the assistant was onboarded.

Each of these is a credential. Each is valid. Each logs in. The defender has to spot the one thing the attacker is doing that is not normal. The defender is looking for a needle in a stack of needles.

The exercise should emulate at least three of these patterns. A single TTP is a demo. A pattern is a test.

## What to detect

The detections that matter are not the detections that fire on a single log line. They are the detections that survive the SOC analyst joining them to identity, session, device, resource, and time.

That join is the detection. Without it, the analyst sees an authentication event and closes the queue. With it, the analyst sees an authentication event from a session that has never come from this device, against a resource this identity has never touched, at an hour this identity has never worked.

Five joins the exercise needs to verify are wired up:

- **Identity to session.** Authentication event, session token, refresh event. Without this, session anomaly detections are blind.
- **Session to device.** Managed, compliant, posture-checked. Without this, conditional access bypass detections are blind.
- **Identity to resource.** What this identity can normally read, write, export. Without this, data access anomaly detections are blind.
- **Identity to time.** When this identity normally works, from where. Without this, impossible-travel detections are blind.
- **Credential to identity.** Which credential authenticated which session, and was that credential on a watch list. Without this, infostealer-log replay detections are blind.

If the exercise cannot verify those joins exist and work, the report it produces is a report on what would have been detected if the data had been there. That is a data report, not a detection report.

## What to measure

The exercise is not a success when the SOC detects the test. The exercise is a success when the SOC can answer the questions that matter — who, what, when, where, why, and how do we contain this — and can act on the answers before the attacker finishes.

Three numbers worth reporting:

- **Time to investigate.** Not time to detect. Time from the first signal to the analyst having a picture of identity, session, device, resource, and time joined. If this number is large, the data work has not been done.
- **Time to contain.** Time from the picture to the credential disabled, the session revoked, the device isolated, the resource locked. If this number is large, the response playbooks have not been rehearsed.
- **Paths to Tier Zero.** Number of attack paths from a leaked or compromised credential to a Tier Zero resource, measured against the actual joins. If this number is non-zero, the remediation work has not been done.

Coverage scores are useful as a trend. They are not a verdict. An 8% score with four live paths to Tier Zero is not a pass.

## What to do when the exercise finds a real one

It will. A focused identity exercise against a real environment almost always turns up a real exposure: a leaked credential, a forgotten service account, a supplier password that does not have MFA, a SaaS integration token that has not been rotated in years.

When it does:

1. **Disable the credential first.** Revoke, invalidate, kill the session. Speed matters more than completeness on the first hour.
2. **Trace the reach.** From the credential, what could the attacker have done? Join to identity, to resource, to Tier Zero. The answer drives the severity and the comms.
3. **Fix the control that made the credential survivable.** MFA on the supplier account. Rotation on the API key. Ownership assignment on the service account. The credential was the symptom. The control gap was the disease.
4. **Extend the search.** If one leaked credential reached Tier Zero, others will. Run the same trace against the rest of the surface — same vendor, same leak source, same time window.
5. **Tell the supplier, or the customer, or both.** Use the playbook. If the playbook does not exist, write it down. The "who do we tell first" question deserves an answer before the next incident, not during it.

The exercise has paid for itself the first time it produces a real find. Everything before that find was preparation.

## What an identity-focused exercise actually looks like

Three to five realistic credential scenarios, each sourced from a plausible leak path the environment actually exposes. Phishing-to-MFA-fatigue-to-token-replay. Infostealer-log-to-VPN. Supplier-help-desk-to-privileged-reset. Build-dependency-leak-to-cloud-control-plane. AI-assistant-API-key-to-data-tenant. Pick the three that match the environment's actual exposure surface.

Each scenario tested against the joins the SOC analyst will actually have at 02:00. Each scenario measured on investigation time, containment time, and paths to Tier Zero. Each scenario producing one real find or one real gap — and the gap fixed before the report is written.

If the exercise cannot be run that small, the identity layer is not yet ready to be purple teamed. The work that needs to happen first is the data work, not the TTP work. Most programmes learn this the hard way: the exercise was scheduled, the joins were not wired up, the report said the SOC missed the detection, and the SOC missed the detection because the SOC did not have the data to see it.

## What this means for the annual cycle

The annual penetration test is not dead. The annual penetration test as the whole programme is dead.

Penetration testing gives a benchmark. It does not give a live picture. The live picture is what an identity-focused purple team exercise produces, run against the joins that are actually wired up, against the credentials that are actually exposed, with the response playbooks that are actually rehearsed.

Run the annual pen test. Run the identity-focused exercise on a continuous basis — quarterly at minimum, monthly if the environment changes weekly, which it does. Tie the two together: the annual test sets the baseline, the continuous exercise tracks the drift. When the two disagree, the difference is the work.

The work is the data work. The work is the join work. The work is the response work. The work is not the TTP work — the attacker will iterate on the TTPs, and the iterations will look like ordinary authentication events buried in a normal working day.

That is what the exercise is for.

---

This essay is the second in a series on purple teaming in environments where identity is the perimeter. The first was [Purple Teaming Your Identity Environment: Where the Real Attacks Live Now](/essays/purple-teaming-your-identity-environment/). The next will cover the response side: what good containment looks like against a credential-driven intrusion.
