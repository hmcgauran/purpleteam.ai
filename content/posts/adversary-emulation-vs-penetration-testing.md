---
title: "Adversary Emulation vs Penetration Testing: Why the Distinction Matters"
slug: "adversary-emulation-vs-penetration-testing"
date: 2026-07-02
tags:
  - "Red Team"
  - "Purple Teaming"
  - post
author: Hugh McGauran
excerpt: "You paid €80,000 for a \"red team engagement.\" The report arrived with 47 findings, a 12-page executive summary, and a heat map of your network that looked like something out of a disaster movie"
layout: layouts/post.njk
permalink: /essays/adversary-emulation-vs-penetration-testing/
---
You paid €80,000 for a "red team engagement." The report arrived with 47 findings, a 12-page executive summary, and a heat map of your network that looked like something out of a disaster movie.

Then you read it. Three quarters of the findings were misconfigured services and missing patches — work your vulnerability scanner should have flagged months ago. The "sophisticated attack chain" involved exploiting a 2021 CVE on an unpatched internet-facing host that any script kiddie with Shodan could have located in an afternoon. The "red team operators" used off-the-shelf exploitation tooling in default configuration and ran their attacks during business hours, when your SOC was at full staffing.

Your CISO took the report to the board as evidence of advanced adversary testing. Your detection engineers shrugged. They knew the report told them nothing they could act on. Your actual adversaries are not script kiddies scanning for unpatched Apache. They are APT29. They are FIN7. They are Lazarus. They are Scattered Spider. They are specific groups with specific tradecraft, specific tooling, specific objectives, specific constraints, and specific operational patterns.

You did not get an adversary emulation. You got a penetration test with a bigger invoice and a borrowed vocabulary.

This matters more than most security leaders realise. The two engagements answer different questions, produce different evidence, and require different relationships with threat intelligence. Conflating them produces work that looks like security theatre but functions as confirmation bias. Worse, it produces defensive priorities that diverge from the threats you actually face.

Here is the distinction, why it matters operationally, and how to commission the engagement you actually need.

## What a Penetration Test Actually Is

A penetration test is a time-boxed assessment of exploitable weaknesses in your environment. Its primary product is a list of vulnerabilities with proof-of-concept exploitation evidence. Its primary question: **can an attacker with this level of skill and time break into specific systems, and what is the path?**

The classic penetration test has well-defined characteristics that practitioners understand:

- **Breadth over depth.** A good pen test sweeps across your environment looking for exploitable issues. The goal is to find as many as the time budget allows, prioritising by severity and exploitability. Quality pen testers do not stop at the first finding.
- **Vulnerability-led.** The consultant starts with known weaknesses — public CVEs, misconfigurations, exposed services, weak credentials, default configurations. They use these to gain footholds and move laterally. Their methodology is a structured exploitation process.
- **Goal is access or action.** "Can we get domain admin?" "Can we read this database?" "Can we modify this configuration?" Success is binary — the consultant either achieved the defined objective or did not.
- **Reporting focuses on findings.** You receive a list of vulnerabilities with severity ratings, exploitation evidence, and remediation advice. The report is the deliverable. It is what your vulnerability management team uses to drive patching.
- **Adversary-agnostic.** The test does not simulate any specific threat actor. It simulates generic capability at a defined skill level. The same engagement would be run against a law firm, a hospital, a bank, or a defence contractor.

This is not a criticism. A good penetration test is genuinely useful. It tells you about exploitable weaknesses — the kind of things that get you breached by opportunistic attackers, script kiddies, and vulnerability-scanning ransomware affiliates. It is the right tool for many jobs, including compliance testing, application security validation, and vulnerability programme validation.

But it is not what most organisations need when they say "red team."

## What Adversary Emulation Actually Is

Adversary emulation is a threat-intelligence-driven assessment of your detection and response capability against a specific, named adversary. Its primary product is evidence of how your environment performs against that adversary's tradecraft. Its primary question: **can this specific group, using their real methods, achieve their real objective in our environment — and would we know in time to respond?**

The discipline has very different characteristics that change how the engagement is planned, executed, and evaluated:

- **Adversary-led, not vulnerability-led.** The team starts with threat intelligence on a named group — APT29, FIN7, Lazarus, Scattered Spider, Volt Typhoon, or whoever your threat model says you face. They map that group's known tradecraft — tools, techniques, procedures, infrastructure patterns, timing characteristics, OPSEC practices. The emulation is built from that intelligence outward.
- **Tradecraft-first, not exploit-first.** The emulators use the adversary's actual methods. If APT29 uses Kerberoasting, password spraying, and forged authentication certificates via AD FS in their current campaign, that is what the test uses. Not Mimikatz on an unpatched host because the consultant noticed KB5034123 was missing during a routine scan.
- **Detection is the primary product.** The test is designed to exercise your defensive capability end-to-end. Did your EDR fire on the tradecraft? Did your SIEM correlate the activity chain? Did your SOC investigate in time? Did your incident response playbooks hold up under realistic pressure? Detection and response performance is the answer you are buying, not a vulnerability list.
- **Constraints matter.** Real adversaries operate under constraints. Time pressure. Tool availability. Detection risk tolerance. Operational security requirements. Working hours. An emulation that ignores those constraints produces answers that do not generalise to the real adversary.
- **Specific objective against specific environment.** The objective is what the named adversary actually wants from your specific organisation. Not "domain admin" generically. Something specific, like "the SCADA credentials that control heating and ventilation systems in our Manchester plant" if that is what Volt Typhoon actually targets UK utilities for.

The distinction sounds academic. It is not. It changes everything about what the engagement produces, what you learn, and what your defensive team does with the results.

## Why the Confusion Hurts You

The vocabulary problem is real, and it has operational consequences. When procurement teams, leadership, and even experienced security professionals blur the terms, the engagement you receive is shaped by the wrong assumptions. The cost of that confusion is paid in defensive misprioritisation, missed threats, and engagements that confirm what you already believed rather than challenging it.

### The buyer gets misled

Most "red team engagements" sold by traditional penetration testing firms are penetration tests with the word "red team" on the proposal. The firm's consultants are excellent at finding vulnerabilities — that is the discipline they were trained in, often through OSCP, CREST, or similar certification paths. They do not have threat intelligence analysts. They do not have operators who have spent years tracking specific adversary groups. They do not have relationships with MITRE ATT&CK Groups the way a mature adversary emulation team does, because their business model is built around breadth-of-coverage testing, not depth-of-emulation.

The buyer thinks they are getting one thing. They receive another. The report is delivered. The board sees "red team" on the slide. The actual question — "would we have detected APT29 if they targeted us tomorrow, using the tradecraft they are using this quarter?" — is never answered. The money is spent. The risk is unchanged. The defensive team is no better positioned than they were before.

### The defenders get the wrong feedback

Your detection engineers need to know if their rules, their correlations, their playbooks, and their tooling detect the adversary that matters to your environment. When a pen test report says "we achieved domain admin in 14 hours using CVE-2023-23397," the defensive lesson is mostly useless. APT29 did not use that CVE in their 2024 campaign. They used a different chain — different techniques, different tooling, different sequence — to achieve similar outcomes.

Your detection engineers tune for the wrong thing. They build rules for techniques that do not match your threat model. They burn hours on signal that is irrelevant. Meanwhile, the actual tradecraft of the adversary you face sails past your detection stack because you never tested it.

I have watched this happen on multiple engagements. A team builds a beautiful rule for detecting the technique the pen test used. The rule fires in testing. They are proud of it. Six months later, the real adversary uses a different technique that the rule does not cover, and the SOC misses it because their detection engineering effort went into the wrong direction.

### The threat model drifts further from reality

The most insidious damage is to your threat model itself. When your engagements are based on opportunity-driven pen testing, your threat model implicitly becomes "anyone with internet access and time." That is not your actual threat. Your actual threat is a much smaller, much more specific set of actors with much more specific capabilities and much more specific objectives.

A pen test that finds a 2021 CVE on an exposed host does not tell you anything about whether APT29's Kerberos-focused tradecraft would succeed against your environment. A pen test that finds weak password policy does not tell you whether Lazarus's supply-chain compromise of a specific software vendor would have succeeded. A pen test that exploits an unpatched VPN concentrator does not tell you whether Scattered Spider's helpdesk social engineering would reach your identity provider admin.

If the engagements you run do not match the threats you face, you are optimising for the wrong adversary. The detection rules you build are tuned for the wrong techniques. The incident response playbooks you write are calibrated for the wrong scenarios. The board reports you deliver tell the wrong story.

## How to Scope an Adversary Emulation Properly

A poorly scoped emulation is barely distinguishable from a pen test. The structure of the engagement defines whether you get useful answers or expensive theatre. Here is what a proper scoping conversation looks like, with the rigour it requires.

### Pick the named adversary — and be honest about why

The first question is which adversary you are testing against. The answer should come from your threat model, not from what is fashionable in the security press or which group has the best public profile.

If you are a UK financial services firm, FIN7, Scattered Spider, and various ransomware affiliates are realistic candidates. If you are a defence contractor, APT29 and various Chinese state-aligned groups belong at the top of your list. If you are an energy company, Volt Typhoon and Russian-aligned actors targeting operational technology are primary concerns. If you are a healthcare provider, BlackCat and LockBit affiliates, plus various insider threats, deserve attention.

Do not pick APT29 because it sounds impressive. Do not pick Lazarus because it is famous. Pick the adversary that your threat model says is most likely to target you, with the most damaging realistic capability, and with tradecraft documented well enough to emulate.

### Define the specific campaign, not the group generically

Saying "test against APT29" is not specific enough. APT29 has run multiple distinct campaigns over the past decade. Their SolarWinds campaign in 2020 looked very different from their 2024 campaign targeting Microsoft 365 tenants. Their tradecraft evolved. Their infrastructure changed. Their objectives shifted.

Pick a specific campaign with documented tradecraft. Use open-source intelligence — MITRE ATT&CK Groups, vendor threat reports from firms that track specific groups, CISA advisories, NCSC alerts, leaked adversary documentation when available. Build the emulation scenario around that specific campaign's procedures, not a generic "APT29 does APT29 things" mental model.

If you cannot identify a specific campaign with documented tradecraft for the group you have chosen, you have chosen the wrong group, or you have chosen the right group but your threat intelligence is not deep enough. Either way, the engagement is not ready to scope.

### Write the objective like the adversary would

The objective should be what the named adversary actually wants from your environment. Not "domain admin" — that is too generic to produce useful answers. Something specific, written in the language of the adversary's operational objectives:

> "APT29 attempting to access the email mailbox of our Chief Financial Officer to obtain strategic M&A information over a 30-day operational window."

> "FIN7 attempting to deploy POS malware on payment processing systems to harvest card data during the December peak trading period."

> "Scattered Spider attempting to convince the IT helpdesk to reset credentials for a privileged access management account, then pivot to identity provider admin and disable multi-factor authentication organisation-wide."

> "Volt Typhoon attempting to establish persistent access to our operational technology network for future disruptive action, with a 90-day operational window."

When the objective is that specific, the engagement tests something real. The defensive question becomes precise: would we have detected that specific operation, in that specific window, against that specific target, using that specific tradecraft? That is a question your SOC, your detection engineers, and your incident response team can answer with evidence.

### Define the starting position in adversary terms

The starting position should reflect how the named adversary actually gets initial access. For APT29, that might be spear-phishing of a specific department, supply chain compromise via a software vendor you actually use, or exploitation of an edge device you actually have deployed. For FIN7, it might be a phishing email to a regional restaurant manager targeting their POS systems. For Scattered Spider, it might be a phone call to the helpdesk impersonating an employee who has lost their phone.

Not "assume initial access." Not "assume workstation compromise." Those are excuses to skip the realistic constraint that defines the emulation. If the adversary's defining feature is their initial access method, your emulation must include that method.

### Set detection and response as success criteria

This is where emulation diverges most clearly from pen testing. Write down, in advance, what defensive performance you expect:

- **What detections should fire, and when.** If APT29 uses WMI for lateral movement in the chosen campaign, your Sysmon-based WMI rule should fire. If FIN7 uses PowerShell with specific obfuscation patterns, your script block logging and AMSI integration should catch it. If Scattered Spider uses a voice call to the helpdesk, your helpdesk procedure should include verification steps that would defeat social engineering.
- **What response actions should happen.** SOC investigation within X hours. Containment within Y hours. Escalation to incident response within Z hours. Decision criteria for declaring an incident.
- **What a partial success looks like.** Detected but not contained within the time window. Contained but adversary achieved partial objective. Adversary detected early but their initial access was never identified. Define these in advance.
- **What a defensive failure looks like.** Adversary completed objective with no detection at all. Adversary completed objective with detection after objective was achieved. Define this in advance.

These criteria are agreed by red team, blue team, and the engagement sponsor before the engagement starts. They cannot be moved afterwards. The point of emulation is to learn something specific about your defensive performance, and that requires fixed criteria that both teams work against.

### Time-box it like the adversary would

Real adversaries operate under time pressure. APT29 campaigns often run for months, but specific operations within them are days-long. FIN7 dwell time on a target before moving to objective varies. Scattered Spider works fast because their social engineering depends on speed and tempo. Lazarus campaigns targeting financial infrastructure have different operational rhythms than their cryptocurrency theft operations.

Time-box the engagement to reflect that. A 30-day window is appropriate for a state-aligned group operating carefully. A 72-hour window fits a financially motivated group moving quickly. Unlimited time produces fake answers — your detection engineering team will tune rules based on the engagement, and you lose the realistic constraint.

### Define in-scope and out-of-scope explicitly

The most common scoping failure: undefined boundaries. If you do not explicitly say a system is in scope, red team will assume it is. That leads to findings on systems that have nothing to do with your threat model, which wastes everyone's time and produces confusing reports.

Write it out:

**In scope:**
- Specific business units and their associated systems
- Specific data stores the named adversary would target
- Specific applications and services the named adversary would interact with
- The identity infrastructure relevant to the objective

**Out of scope:**
- Systems unrelated to the adversary's likely objectives
- Production systems where emulation could cause operational harm
- Systems protected by different threat models (HR systems, for example, have insider threat as their primary concern, not APT29)
- Anything requiring physical access unless the named adversary's tradecraft includes physical access

If you do not write the out-of-scope list, red team will find their way into systems that generate impressive-sounding findings but tell you nothing about the threat you actually face.

## The Role of Threat Intelligence

Adversary emulation that is not threat-intelligence-driven is not adversary emulation. It is pen testing with more steps and a larger invoice.

The intelligence input has to be specific, current, and operationally relevant. Generic intelligence about "advanced threats" is not useful. You need:

- **Named adversary with documented history.** A group with multiple years of tracked activity, attributed campaigns, and documented tradecraft. Not "an APT" as a vague concept.
- **Documented tradecraft.** Tools, techniques, procedures, infrastructure patterns, C2 frameworks, malware families. Specific enough that the emulation team can replicate the chain.
- **Campaign-specific patterns.** What does this adversary do in this campaign, not what they did five years ago. Adversaries evolve. An emulation built on 2020 tradecraft against a 2024 adversary is testing the wrong thing.
- **Operational constraints.** Time pressure. OPSEC requirements. Tool availability. Working hours. Language patterns in code. Infrastructure patterns in command and control. Detection avoidance practices. These constraints make the emulation realistic.
- **Recent updates.** Adversaries evolve quarterly, sometimes faster. An emulation plan built on tradecraft from 18 months ago is testing a past version of the adversary, not the one you will face tomorrow.

Good threat intelligence comes from multiple sources, and the emulation team should be consuming them all:

- **MITRE ATT&CK Groups database** — useful as a starting point, not as the ending point. ATT&CK gives you the technique IDs but not the sequencing, the tooling, or the operational constraints.
- **Vendor threat reports** — from firms that track specific adversary groups over years (Mandiant, CrowdStrike, Microsoft Threat Intelligence, Recorded Future, Proofpoint, Kaspersky GReAT). These reports give you campaign-level detail.
- **Government advisories** — CISA, NCSC, NSA, FBI joint advisories are excellent and often freely available. They are written for defenders and tend to be operationally useful.
- **Leaked adversary documentation** — Conti leaks, LockBit infrastructure analysis, sandbox dumps of adversary tooling, internal chat logs. Use carefully and ethically, but the operational detail is invaluable.
- **Your own incident history** — if you have been targeted by a specific group, your own telemetry is intelligence. The tradecraft they used against you is the tradecraft to emulate against your improved defences.

The emulation team consumes this intelligence and converts it into a campaign plan. The plan says: "We will perform this initial access technique, this lateral movement chain, this persistence mechanism, this exfiltration method, all aligned to the named adversary's known tradecraft."

If your engagement does not start with that intake, it is not adversary emulation. It is something else wearing the name.

## ATT&CK-Aligned but Not ATT&CK-Driven

ATT&CK is the lingua franca of adversary behaviour. Every serious security team uses it. The question is how.

ATT&CK-driven emulation means: "We will test every technique in the Initial Access tactic, then every technique in Execution, then every technique in Persistence, then every technique in Privilege Escalation." The team works through the matrix systematically, marking coverage.

This produces noise, not signal. The adversary does not chain every technique in a tactic. They use specific techniques in specific sequences, and they skip techniques that do not fit their operational pattern. Your emulation should reflect that.

ATT&CK-aligned emulation means: "APT29's documented SolarWinds campaign used this technique chain — initial access via trojanised update, persistence via scheduled task, lateral movement via WMI, credential access via Kerberoasting — which maps to these ATT&CK technique IDs. We will replicate that chain. We will skip techniques APT29 does not use. We will use the specific tooling they used, in the specific configuration they used it."

That is the right way to use ATT&CK. The framework is the vocabulary. The adversary is the source of truth. ATT&CK tells you what to call things. The adversary tells you what to do.

If your emulation plan looks like a coverage matrix of ATT&CK techniques, you have written a checklist, not an emulation. Adversaries are not checklists. They are specific groups with specific behaviour patterns, and the patterns matter more than the coverage.

## What Bad Emulation Looks Like

It is worth naming what bad emulation looks like, because it is increasingly common as firms rebrand pen testing as emulation to win larger contracts.

Bad emulation looks like this:

- The proposal mentions a named adversary but the engagement plan is the same vulnerability-led methodology the firm uses for pen testing.
- The emulators use generic techniques (credential dumping, lateral movement via SMB) without reference to how the named adversary specifically operates.
- The report lists vulnerabilities with severity ratings and remediation steps. It does not assess detection performance.
- The "intelligence" section of the report is a single paragraph summarising ATT&CK Groups entries, with no campaign-specific detail.
- The starting position is "assume workstation compromise" with no realistic initial access path described.
- The success criteria are about whether red team achieved the objective, not about whether blue team detected the activity.

If your engagement produces that output, you have paid for a pen test with emulation language. The vendor is not necessarily at fault — they may genuinely believe they delivered an emulation. The problem is the discipline gap. Pen testing and emulation require different operator skills, different intelligence inputs, and different evaluation frameworks. Most pen testing firms do not have those capabilities and will not develop them quickly.

The market is also full of firms that have heard "adversary emulation" is the hot term and have rebranded without changing the underlying service. The deliverable looks like a pen test because the work was a pen test.

How do you tell the difference? Read the report. If it tells you about vulnerabilities, you commissioned a pen test. If it tells you about detection performance against a specific tradecraft chain, you commissioned an emulation.

## The Same Objective, Run Two Ways

Let me make this concrete. Suppose you want to test whether an attacker can reach your customer database from outside your perimeter. The objective: read a record from the customer database, exfiltrate it externally, and do so without detection for more than 24 hours.

Here is what each engagement looks like in practice.

### As a penetration test

The pen test consultant starts with reconnaissance. They scan your external perimeter for exposed services. They find an outdated Apache Tomcat instance on a marketing site with a known CVE. They exploit it using Metasploit in default configuration, get a low-privilege shell, escalate to local admin via a misconfigured service, find cached credentials on the host belonging to a service account, use those credentials to pivot to an internal database server, locate the customer database, and exfiltrate a sample row over HTTPS to an external server under their control.

**Time: 6 hours.**
**Findings: 1 critical CVE on the marketing site, 1 weak credential issue on the service account, 1 network path documentation gap showing how the marketing segment connects to the database tier.**
**Detection question answered: barely. Your perimeter EDR fired on the Tomcat exploit but SOC was investigating a separate incident and missed it. The lateral movement went unlogged because your internal network monitoring has gaps. The exfiltration looked like normal HTTPS traffic.**

Report delivered. Findings remediated. CVE patched. Credential rotated. The marketing host gets rebuilt on a current platform. Everyone moves on. The detection engineering team adds a rule for Tomcat exploitation patterns that will never fire on your actual adversaries.

### As an adversary emulation against APT29

The emulation team starts with threat intelligence. APT29's documented 2024 tradecraft against Microsoft 365 environments includes: spear-phishing of IT staff with malicious OAuth consent grants, abuse of legitimate cloud administration tools, persistence via scheduled tasks in Microsoft 365, lateral movement using stolen refresh tokens, credential access via Azure AD enumeration, exfiltration via cloud sync to attacker-controlled tenants.

The starting position is a spear-phishing email sent to three IT staff, with a malicious OAuth consent grant that looks like a legitimate third-party management tool. Two of three click. One consents to the malicious application — a realistic success rate for this kind of campaign.

From there, the emulators use the granted OAuth permissions to enumerate the Microsoft 365 environment via Microsoft Graph API. They find a service principal with overly broad Graph API permissions — a common misconfiguration in organisations that have grown their Microsoft 365 footprint without rigorous permission review. They use the service principal to enumerate mailboxes, find credentials to the customer database stored in an IT admin's mailbox (a realistic failure mode), access the database via the legitimate corporate application path that IT uses for maintenance, and exfiltrate records via a OneDrive sync to an attacker-controlled account.

**Time: 9 days.**
**Detection: Your identity provider logged the OAuth consent grant but your detection rules did not alert on it because consent grants are noisy and your SOC has tuned them down to reduce alert volume. Your SIEM saw Graph API enumeration but treated it as normal admin activity because the service principal had legitimate-looking permissions. Your DLP did not fire on the OneDrive sync because it was to what looked like a "trusted" Microsoft 365 tenant. The adversary exfiltrated 12,000 records before your threat hunting team noticed unusual service principal activity 11 days in.**

**Detection question answered: thoroughly. You know exactly where your identity-based detection failed. You know your consent grant monitoring is misconfigured. You know your DLP does not understand cloud-to-cloud exfiltration patterns. You know your SIEM rules need to distinguish between legitimate Graph API usage and enumeration patterns. You know your SOC needs training on identity-based attacks that look like legitimate admin activity. You have specific, actionable gaps to close, each tied to a specific failure in the chain.**

The two engagements look completely different. They answer different questions. They produce different evidence. They generate different work for the defensive team.

Neither is wrong. But only one is an adversary emulation.

## Communicating the Distinction to Leadership

This is where most practitioners fail. They try to explain the difference to a CISO or board and end up sounding precious, pedantic, or self-serving. "We do real red teaming, those other people just do pen tests" is the kind of statement that makes senior leaders tune out and assume you are protecting territory rather than solving problems.

Here is how to frame it without sounding precious.

**Frame it as a question, not a category.** Do not say "we do adversary emulation, you got a pen test." Say "you are about to invest in security testing — what question do you need answered this quarter?" If the answer is "do we have exploitable vulnerabilities we should fix?" they need a penetration test. If the answer is "would we detect the adversary that actually targets us, using their actual tradecraft?" they need an adversary emulation. Both are legitimate. The category distinction is downstream of the question.

**Use the board's language.** Boards care about risk. Translate the distinction into risk terms. "A penetration test tells us about the vulnerabilities we have. An adversary emulation tells us about our ability to detect and respond to the threat we actually face. They are different risk questions, and the answers drive different defensive investments. Which risk matters more this quarter?"

**Acknowledge the cost difference honestly.** Adversary emulation is more expensive than penetration testing, often significantly so. Threat intelligence work, more senior operators, longer engagement windows, deeper detection analysis, more sophisticated reporting. Pretending otherwise is dishonest. The pitch is value, not price — but value has to be real and demonstrable.

**Show what they will learn.** Boards and senior leaders understand specific outcomes. "At the end of this engagement, we will know exactly how APT29's current tradecraft performs against our detection stack. We will have a prioritised list of detection gaps tied to specific techniques. We will have evidence we can take to the regulator or the board if asked how we tested against the threat we face."

**Avoid the vendor language.** Do not use "adversary emulation" as a brand differentiator if you are selling. Use it as a description of what the buyer is buying. The distinction matters because the buyer is getting different evidence for different decisions. That is the frame, not vendor positioning.

**Bring the SOC into the conversation.** The detection and response team is the audience that will operationalise the findings. If they are not in the briefing where the distinction is explained, the engagement will produce reports that go into a drawer. Bring them in early. Let them ask questions. Let them push back. The conversation will sharpen.

The goal is not to make pen testing look bad. Pen testing is valuable. The goal is to make sure the buyer understands what they are commissioning and why, so they can make the right decision for the question they actually have.

## When Each Is the Right Tool

I am not going to tell you that adversary emulation is always superior and penetration testing is obsolete. That is nonsense. They are different tools for different jobs.

**Penetration testing is the right tool when:**

- You need to know what exploitable vulnerabilities exist across your environment and need a remediation list.
- You are testing the security of a specific application, network segment, or system.
- You need to satisfy a compliance requirement that explicitly asks for penetration testing (PCI-DSS, for example, requires pen testing in certain contexts).
- You are early in your security programme and need a baseline of exploitable risk.
- Your adversaries are opportunistic — script kiddies, vulnerability-scanning ransomware affiliates, automated attack tools — rather than targeted.

**Adversary emulation is the right tool when:**

- You have a defined threat model and need to test your defensive performance against specific adversaries.
- Your SOC and detection engineering functions need evidence of how their work performs against realistic tradecraft.
- You are a high-value target for named threat actors — financial services, defence, critical infrastructure, government, healthcare with valuable research data.
- You need to test specific campaigns before they happen, not generic capability.
- You have a mature detection and response capability that needs realistic stress testing rather than another vulnerability scan.

Most organisations need both, run on different cadences, answering different questions. The mistake is calling one the other and getting the wrong answer for the question you actually have.

If you are running a programme where your SOC and detection engineering priorities are driven by pen test findings rather than adversary emulation results — that is a programme design problem. Fix the design. Separate the budgets. Separate the cadences. Align each engagement with the question it actually answers.

## Practical Takeaways

Here is what to do Monday morning.

**1. Audit your last three engagements and ask what they actually tested.** Not what the proposal said. What did the engagement actually exercise? Was the tradecraft adversary-led or vulnerability-led? Did the report tell you about vulnerabilities or detection performance? If you cannot tell from the deliverables, the engagement was probably misaligned with your threat model.

**2. Write down the adversary you actually face, with sources.** Pick one named group. Document why you picked them. Cite the threat intelligence that supports the choice. Make it a single paragraph. "Our primary threat is [group] because [intelligence source]. They target organisations like ours because [motivation]. They typically gain access via [initial access vector] and pursue objectives related to [what they want]." This becomes the foundation of any future emulation scoping conversation.

**3. Separate your pen testing budget from your emulation budget.** They answer different questions. Mixing them produces poor outcomes. If you only have budget for one, pick the question that matters most this quarter, then commission the engagement that answers it. Do not commission a pen test and call it a red team. Do not commission an emulation and call it a vulnerability assessment.

**4. Demand detection performance evidence from any "red team" engagement.** The deliverable should include specific detection results: what fired, when, what the SOC did, what gaps were exposed. If the report only contains vulnerability findings, you commissioned a pen test. Ask the vendor to redo the deliverable or commission the engagement you actually wanted next time.

**5. Brief your leadership on the distinction once, clearly, then move on.** Do not relitigate it quarterly. Frame it as a procurement and risk question, not a vendor turf war. Once they understand, they will not need it explained again. Save your political capital for the engagements that matter.

**6. If you do not have threat intelligence capability, build it before you commission emulation.** Emulation that is not threat-intelligence-driven is a more expensive pen test. You need either in-house intelligence capability, a vendor who provides it as part of the engagement, or open-source intelligence sources strong enough to scope the campaign properly. Without that foundation, you cannot scope an emulation, and the engagement will degrade into something else.

**7. Run the two engagements on different cadences.** Pen tests typically run quarterly or annually as part of security testing programmes. Adversary emulations run less frequently — typically once or twice per year per named adversary — because they are expensive, the answers change more slowly, and your defensive team needs time to operationalise the findings before the next test.

**8. Bring the SOC into scoping.** The detection and response team is the audience for emulation findings. If they are not in the scoping conversation, the engagement will produce reports that do not match their operational reality. Bring them in early. Let them shape the success criteria. Let them define what detection performance looks like for their environment.

The distinction is not academic. It is the difference between evidence you can act on and evidence that confirms what you already believed. Most security programmes have too much of the latter and not enough of the former.

Get the engagement you actually need. Ask the question you actually have. Commission the work that answers it. Do not pay pen test prices for emulation promises, and do not pay emulation prices for pen test deliverables.

---

*Next week: Building an internal adversary emulation capability without a dedicated team — the operational reality for mid-sized security organisations that cannot justify a full-time emulation function but still need realistic threat-informed testing.*