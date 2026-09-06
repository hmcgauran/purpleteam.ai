---
title: "The Insider Threat Problem Is Not What You Think"
slug: "insider-threat-problem"
date: 2026-05-07
tags:
  - "Insider Threat"
  - "Detection Engineering"
  - "Threat Modelling"
  - post
author: Hugh McGauran
excerpt: "Your insider threat programme is aimed at the wrong target"
layout: layouts/post.njk
permalink: /essays/insider-threat-problem/
---
Your insider threat programme is aimed at the wrong target.

You have a list of indicators: large data downloads, access outside business hours, USB device usage, attempts to email sensitive files to external addresses. You have rules in your DLP. You may even have a dedicated "insider risk" analyst, or a tool that promises to find malicious insiders using machine learning.

Almost none of that matters. Because the actual insider threat in your organisation is not a malicious employee quietly exfiltrating customer data. It is an engineer who pushed a Terraform plan with an AWS access key to a public GitHub repo. It is a finance manager who pasted last quarter's revenue figures into ChatGPT to "summarise them." It is a sales rep whose laptop phoned home to a credential-stuffing proxy because the same password was reused on three different services. It is a junior HR coordinator who clicked a phishing link disguised as a candidate CV.

None of those are malicious insiders. All of them are insider risk. And almost every detection programme I see is configured to find the first category and blind to the second.

### A composite scenario

Take a mid-sized software company. Two hundred engineers, a customer base that includes regulated industries, a CISO who answers to a board that reads about insider threats in the Financial Times every quarter.

Last year, three incidents happened. None of them made the news. All of them were real insider risk.

The first: a senior backend engineer was debugging a production latency issue. He wanted a quick look at the database. He had no standing access. He asked a teammate for a temporary credential. The teammate, under deadline pressure, shared their production database password over Slack. The incident only came to light six weeks later during a routine access review. The teammate had forgotten about it. The engineer had used it once, fixed the bug, and moved on. The credential was still valid. The audit trail was incomplete because the shared credential belonged to a service account whose activity was not surfaced in the SIEM.

The second: a product manager was preparing a competitive analysis deck for the leadership offsite. She screenshotted the company's pricing tiers, the customer's industry segmentation, and the strategic roadmap from the internal wiki. She pasted the screenshots into ChatGPT and asked it to "structure this into a competitive analysis." ChatGPT, on its standard plan, retained the conversation and used it for model training. The screenshots, which included customer names in the segmentation, lived inside OpenAI's training pipeline for ninety days.

The third: a salesperson whose contract was not renewed spent his last two weeks downloading the customer contact database to a personal device. This one was the classic insider threat story the board expected. His manager noticed because he had asked HR to confirm the non-renewal the day before, and HR had quietly flagged the leaver cohort to security. The download was logged. The investigation was clean. The matter was settled in a settlement agreement.

The first incident was not malicious. The second incident was not malicious. The third was the actual malicious insider, and it was caught not by the insider threat tooling but by the leaver process.

That ratio — two unintentional, one intentional, only the intentional one caught by the conventional programme — is the rule, not the exception.

This essay is about that mismatch, what good insider risk programmes actually measure, and how to build a credible one without spending six figures on yet another vendor product.

## The framing problem in one paragraph

When security leaders say "insider threat," the picture in their head is a disgruntled employee on their way out, copying the customer database to a personal Dropbox before walking into a competitor. That picture is wrong for two reasons.

First, it is rare. Intentional, premeditated insider data theft is a real phenomenon, but it represents a small minority of insider incidents. Industry telemetry from the likes of Code42, DTEX, and the Ponemon Institute consistently puts the unintentional or compromised-account category at somewhere between 70 and 85 percent of insider incidents. When you build a programme around the 15 percent, you are optimising for the wrong outcome.

Second, the indicators you use to find the malicious insider are often identical to the indicators of completely legitimate work. The senior finance controller who logs in at 23:00 to close the quarter books. The data scientist who downloads 400,000 rows of customer behaviour data for a model training job. The lawyer who exports a contract folder to work on a flight. Every one of those triggers a "suspicious insider activity" alert, and every one of them is doing their job.

If your SOC has learned to tune those alerts down to silence because most of them are noise, you have a programme that detects only the dumbest insider attacks and misses every realistic one. That is the state of most insider risk programmes I have audited.

## What the actual insider threat looks like

Let me walk through the categories that actually drive insider risk in mid-sized and large organisations, ordered roughly by frequency.

### Compromised accounts

This is the largest category by volume and the one most programmes miss entirely. An attacker phishes or credential-stuffs an employee, gains access to a legitimate account, and operates inside the environment using that account. From the perspective of access patterns, identity provider logs, and data access, the activity looks like the employee. The behaviour does not change because the human at the keyboard has not changed in any measurable way at first.

The classic indicators are network-level and endpoint-level: impossible travel in sign-in logs, sign-ins from new ASNs, MFA fatigue prompts, sign-ins from residential proxies. If you are only looking for "user downloaded too much data," you will miss this completely.

### Unintentional data exposure

The accidental push to GitHub. The spreadsheet emailed to the wrong distribution list. The customer support ticket forwarded to a personal Gmail because the agent wanted to keep working on it from home. The S3 bucket left public. The SharePoint link shared with "Everyone" when the user meant "People in Marketing."

Most of these are not malicious. They are the predictable outcome of humans doing their jobs under time pressure, with tools that default to openness. A credential posted to a public GitHub repo is the modern equivalent of leaving a confidential printout on the train. The exposure is real, but the actor did not intend it.

### Shortcuts and workarounds

This is the category security teams hate because it is the user's fault and the user's choice, but it is rarely malicious. People paste customer data into ChatGPT because ChatGPT is genuinely useful. People forward work email to personal Gmail because their phone mailbox is bigger. People use personal Dropbox because the corporate one is slow. People share credentials with the team because getting a new starter provisioned takes three weeks.

Every one of these is a risk decision made by a human who has decided, consciously or not, that the friction of doing it the right way is greater than the perceived cost of doing it the wrong way. Your detection programme cannot stop it by rule. It can only stop it by changing the friction.

### Departing employees doing legitimate things at speed

The two weeks before resignation are a genuine risk window, but the behaviour that shows up is not "user is stealing data." It is "user is exporting their work email, syncing files, exporting contacts, building a personal archive." Sometimes that is because they are joining a competitor and want to take work with them. Sometimes it is because they are anxious about losing access to things they care about and want a personal copy. Sometimes it is just because the leaver process is unclear and the employee is doing what they would do if they were switching laptops internally.

This is where most "insider threat" tools earn their keep, and where most of them are also wildly over-tuned. You do not need machine learning to flag that a leaver synced 8,000 files to OneDrive in their last week. You need a leaver workflow that revokes access, recovers data, and tells the manager what is normal.

### The actual malicious actor

Yes, this exists. A developer who downloads the source code repository before joining a competitor. A sales engineer who screenshots the strategic account list before moving to a rival. An administrator who quietly escalates permissions for an external party in exchange for money. These are real and they happen.

But they are rare, they are usually preceded by warning signs the programme missed (performance issues, conflicts, prior policy violations), and they are usually caught by HR or finance before they are caught by security tooling. The right detection layer for these is not exotic UEBA. It is good identity hygiene, good HR partnership, and good investigative discipline when something does surface.

## Why rule-based DLP fails

Data Loss Prevention has been sold as the answer to insider threat for twenty years. It has not worked in most organisations, and it will not start working now. Here is why.

### DLP rules are proxies, not signals

A DLP rule says "block emails containing 16-digit numbers that match the format of credit card numbers." The rule is not measuring risk. It is measuring pattern match. The user can trivially evade it by typing the digits into the body of an email with spaces, by writing them as words, by attaching a screenshot, or by pasting them into a file and zipping the file. The rule has nothing to say about a contractor emailing a screenshot of the customer database to their personal address, because the screenshot contains no detectable pattern.

Every rule you write is a guess about how a particular user might exfiltrate a particular type of data. The number of possible exfiltration paths is approximately infinite. The number of rules you can write and tune is finite. The asymmetry cannot be solved by writing more rules.

### DLP creates alert volume the SOC cannot absorb

The classic DLP deployment: a vendor installs the agent, runs a discovery scan, identifies "sensitive data" everywhere, and turns on a few hundred rules. Within weeks the SOC has a queue of ten thousand "potential data loss events" per week. The vast majority are false positives. The SOC tunes them down. The business complains that DLP is blocking legitimate work. The vendor blames the SOC for not tuning properly. The programme either dies quietly or survives as compliance theatre.

The metrics that prove DLP is working in this state are exactly the wrong ones. "Number of events detected" is high. "Number of incidents remediated" is near zero. "User satisfaction with security" is in the basement. The programme exists because an auditor wanted to see it, not because it is preventing harm.

### Users route around DLP instantly

Once DLP is in place, any user with a small amount of technical skill learns the rules within a week. They know the file types that get flagged. They know the destinations that get flagged. They know the patterns that get flagged. They shift to destinations and formats that do not. Email moves to personal accounts. Files move to personal cloud storage. Confidential data ends up in Slack DMs, in Notion pages, in Trello boards, in ChatGPT conversations, in Microsoft Teams chats to external users.

Every one of those channels is, from a DLP rule perspective, invisible. You can keep adding rules to cover them, but the user moves faster than the rule writer. This is the same dynamic as anti-virus in 2008: a defender catalogue that loses to an adaptive adversary.

### DLP treats symptoms, not causes

The deepest problem is conceptual. DLP asks "is sensitive data leaving the environment?" The right question is "why is sensitive data being put somewhere it can leave?" The first question produces alerts. The second question produces fixes.

If engineers are pasting secrets into GitHub, the fix is a secrets scanning pre-commit hook and a fast, friction-free path to secret rotation. If salespeople are forwarding customer lists to personal email, the fix is a CRM that works on their phone without a VPN. If finance staff are pasting numbers into ChatGPT, the fix is a sanctioned enterprise LLM with appropriate data controls. The right answer to insider risk is almost never a detection rule. It is a reduction in the conditions that make the rule necessary.

### The data classification prerequisite most teams skip

Almost every DLP failure I have seen has the same root cause that nobody wants to discuss: the organisation has not done data classification, and DLP without classification is blind.

A DLP rule that blocks credit card numbers relies on pattern matching. A DLP rule that blocks "confidential" documents relies on metadata tags. A DLP rule that blocks "source code" relies on file type heuristics. None of those are data classification. All of them are proxies for it.

Real data classification means: the business has decided, for every class of data, what its sensitivity is, who can access it, where it can live, and what can be done with it. That decision produces labels that travel with the data. Those labels are what the DLP engine actually uses.

Most organisations skip this step. They buy DLP first, on the assumption that the tool will discover and classify the data for them. The tool does discover, sort of. The result is a list of files containing credit card numbers or appearing to contain source code or matching a "confidential" string pattern. That list is not classification. It is the appearance of classification. It does not reflect any business decision about what the data actually is, who should have it, or what should happen if it is exposed.

The Microsoft Purview DLP documentation says this in plain language and is still ignored. Symantec DLP has been saying it for fifteen years and is still ignored. Forcepoint DLP, Digital Guardian, the whole lot — they all need a classification scheme to work. If you do not have one, do not buy DLP. Buy a data classification consultancy first, or build the classification scheme in house, or accept that DLP will not work for you.

The classification scheme is also the foundation of every insider risk control. You cannot decide what behaviour is risky without knowing what data is sensitive. You cannot decide what behaviour is acceptable without knowing what data is not. The scheme is the answer to the question "what are we actually protecting?" Without it, the programme is guessing.

## Behavioural baselining, and why it usually disappoints

The natural next step is to give up on rules and try behaviour-based detection. UEBA (User and Entity Behaviour Analytics) products from Exabeam, Splunk, Securonix, Microsoft, and others promise to baseline normal behaviour per user and flag deviations.

The idea is correct. The implementation almost always disappoints. Here is what goes wrong.

### Single-event anomalies are not what matters

A UEBA tool will flag "this user has never connected to the finance file server before, and they just downloaded 10,000 files from it." That is exactly the kind of alert the marketing says you will get. In practice it fires constantly: the new starter in week one, the employee who changed teams, the contractor who was just granted temporary access. Each one of those is a legitimate behavioural change. Each one produces an alert. The SOC drowns.

What actually matters is sustained change in behaviour, or behaviour change correlated with other risk indicators. The UEBA tool that flags every first-time event is no better than a rule engine. It just uses ML to write the rules automatically and with less transparency.

### UEBA cannot see what it is not fed

A UEBA tool that ingests only authentication logs will not see data movement. A UEBA tool that ingests only endpoint telemetry will not see cloud app usage. A UEBA tool that ingests only Active Directory will not see source code repository access. Most UEBA deployments have significant gaps in their data sources because the vendor's reference architecture assumes a particular stack.

The result is a partial picture. The model baselines what it can see and remains blind to what it cannot. A real insider incident that uses channels outside the visible set is undetectable regardless of how good the model is.

### UEBA tools require sustained tuning and a human owner

UEBA is not a fire-and-forget product. The models need tuning to your environment. The risk scores need calibration to your business. The alerts need a triage workflow. The output needs an analyst who understands what the tool is saying.

Most organisations that buy UEBA assign it to the SOC and expect the existing SOC to absorb it. The SOC does not have headcount. The tool produces noise. After twelve to eighteen months the licence is up for renewal, the alerts are being ignored, and the question is whether to renew or quietly let it lapse. This is the typical lifecycle. It is not a tool problem. It is an ownership problem.

## What good insider risk programmes actually measure

A serious insider risk programme measures behaviour change over time, on a defined set of risk indicators, owned by a cross-functional team, with HR and legal as co-equal partners to security. The technical controls are supporting infrastructure, not the programme.

Here are the indicator categories that matter.

### Account compromise indicators

The clearest insider-adjacent risk is the compromised account. Indicators include:

- Sign-ins from new ASNs or geolocations inconsistent with the user's history
- Impossible travel events across short windows
- MFA fatigue patterns (multiple denied pushes followed by an approval)
- Concurrent sessions from different devices or locations
- New OAuth applications granted consent by the user
- Credential exposure in public breach corpora (your identity team should be running continuous credential exposure monitoring against your domain)

Tools like Microsoft Entra ID Risk, Okta ThreatInsight, and Push Security handle these signals well. They are not insider threat tools. They are identity protection tools that happen to cover most of the actual insider-adjacent risk.

### Behavioural drift over weeks, not minutes

The right unit of analysis is the change in behaviour over weeks, not the single suspicious event. Indicators worth tracking:

- A user who has not contacted customers in six months suddenly exporting the full CRM
- A developer who has never accessed the production secrets store now reading from it daily
- An engineer who has always worked in their own repositories now cloning dozens of unfamiliar repos
- A finance user whose outbound email volume has tripled in the last month, with most of it to external addresses
- An employee whose OneDrive activity has jumped by an order of magnitude, particularly to files they have not touched before

This is a job for analytics, not for a real-time alert engine. You run these queries weekly. You correlate with HR data (recent performance issues, recent role changes, recent compensation changes). You produce a short list of accounts worth a human conversation.

### Departing employee workflow

The leaver process is the single highest-yield insider risk control. Indicators worth instrumenting:

- Resignation or role-change events from HRIS, pushed into your access review queue
- Mass download or sync activity in the 14 days before a known leaver
- Forwarding rules added to mailbox in the last 30 days
- New OAuth grants in the last 30 days
- Personal device sign-ins that did not exist before
- Repository clones from source control by users in the leaver cohort

Tools like Code42 Incydr and DTEX are good at this specific slice. They are not full insider threat platforms; they are leaving-detection products. Treat them as such.

### Sensitive data movement to unsanctioned destinations

Not blocking, observing. Indicators:

- Outbound email to known personal webmail domains
- Uploads to personal cloud storage (Dropbox personal, Google Drive personal, WeTransfer)
- Use of unsanctioned LLMs and AI tools with corporate data
- Paste events from corporate applications into browsers on unsanctioned domains
- Public link sharing from sanctioned storage to external recipients

This is where tools like Netskope, Microsoft Defender for Cloud Apps, and Cyberhaven earn their place. They sit on the network egress and on the endpoint and observe traffic patterns. The output is a risk score, not a block, and that is exactly the right posture.

### Source code and secrets exposure

For any organisation that writes software, the most common unintentional insider incident is secret leakage. Indicators:

- Secrets detected in public repositories (GitHub, GitLab, public S3 buckets)
- Commits to personal repositories from corporate devices
- Source code pasted into AI tools
- New SSH keys added to production systems by non-admin users

Tools like GitGuardian, TruffleHog, and 1Password Developer are purpose-built for this. They are not insider threat tools. They are secrets posture tools. Same answer.

### Phishing repeat offenders and security friction patterns

Some users will fail phishing simulations repeatedly. Some users will accumulate helpdesk tickets about locked accounts because of credential reuse. Some users will call the SOC to ask how to bypass a control. These are leading indicators of insider risk because they correlate with the shortcuts and workarounds that produce incidents.

This is a job for your existing ticketing system, your existing phishing simulation platform (KnowBe4, Proofpoint, Hoxhunt), and basic analytics. No new product required.

## The role of HR and legal

Insider risk is a people programme. Security owns the technical signals, but security alone cannot interpret them. Without HR and legal as full partners, you will either over-react to legitimate behaviour or under-react to behavioural warning signs because you do not know how to act on them.

### HR owns the lifecycle

HR knows who is leaving, who is on a performance plan, who has just been promoted, who has just had a compensation complaint upheld. All of those are correlated with insider risk. None of them are visible to the security team unless HR feeds them in.

A serious insider risk programme integrates HRIS events into the security analytics pipeline. When an employee is flagged in HRIS as a leaver, that signal flows into the access review queue and the departing employee analytics. When an employee is put on a performance plan, that signal adjusts the risk score for their account. When an employee changes role, the security team gets a notification to validate that access has changed appropriately.

Most HR teams will not volunteer this. You have to ask, and you have to make the case that the data flows in one direction (into security analytics) and never out (no security findings into HR records).

### Legal owns the investigation framework

When the security team identifies a concerning pattern, what happens next? You cannot simply revoke access and confront the user. You need:

- A documented policy on what monitoring is conducted and on what basis
- A documented escalation path from "indicator observed" to "investigation opened"
- An agreement with legal on what evidence can be collected and preserved
- An agreement with HR on who is involved in any conversation with the employee
- An agreement with executive leadership on thresholds for involving law enforcement

If those agreements do not exist, your security team will either ignore concerning indicators (because acting on them is too risky) or act on them inconsistently (because each one is improvised). Both outcomes are bad. Both are common.

### The privacy line is real

You are monitoring employees. That has legal constraints in most jurisdictions, including GDPR in Europe. The programme must have a documented legal basis, must be proportionate, must be transparent to employees (in most cases), and must minimise data collected to what is necessary.

This is not an inconvenience. It is a feature. The privacy review forces you to define what you are monitoring and why, which is exactly the discipline most insider risk programmes lack. If you cannot explain to legal exactly what signals you are collecting and why, you should not be collecting them.

## The vendor problem: rebranded DLP with worse UX

If you go to market for an "insider threat platform," you will find a steady stream of vendors selling products that, examined closely, are either:

- DLP with new branding
- UEBA with new branding
- A point solution for one category (leaver risk, code risk, browser risk) wrapped in a "platform" story

This is not always the vendor's fault. Insider risk is broad enough that almost any single tool covers a slice of it. The problem is the buying pattern: organisations buy one tool, expect it to cover the whole insider risk problem, and end up with a partial answer that produces noise on the slice it does cover and is blind to the rest.

The honest pricing math is also instructive. A typical "insider threat platform" costs more than a DLP deployment of the previous generation, requires a similar tuning effort, and demands a dedicated analyst to triage. The total three-year cost of ownership, including the headcount, is in the same range as a mid-sized detection engineering team. That money, spent on people instead of licences, often produces more.

The few cases where a vendor product genuinely pays for itself are narrow:

- Code42 Incydr or DTEX for leaver risk if you have a large developer or research population
- GitGuardian or similar if you have a large engineering footprint and are worried about secret leakage
- Push Security or similar if you are a Microsoft Entra shop and have weak session and identity posture
- Cyberhaven or similar if your IP risk is concentrated in code and documents

In each case, the product is solving a specific problem, not "insider threat" in general. Buy accordingly.

## Building an insider risk programme without buying another product

Here is a credible programme that does not depend on a new vendor. It assumes you already have an EDR, a SIEM, an identity provider (Entra ID or Okta), an email gateway, and a cloud access security broker or equivalent. If you do not have those, get those first.

### Step 1: Get HRIS data into the security pipeline

Integrate Workday, BambooHR, or whatever you use with your SIEM. The events you want flowing in:

- New starter (joiner event)
- Role change (mover event)
- Resignation or termination (leaver event)
- Performance plan opened or closed
- Leave of absence

This is plumbing. It takes a week of integration work. It is the highest-leverage data source in the whole programme, because every other signal is interpreted in light of HR context.

### Step 2: Build a leaver risk dashboard

For every employee in the 30-day window before and after a leaver event:

- File sync volume from their endpoint
- Mail forwarding rules added in the last 30 days
- New OAuth grants in the last 30 days
- Personal cloud storage sign-ins from corporate devices
- Repository clones from corporate source control
- Last-day exports from sanctioned storage

This is a daily dashboard, not an alert engine. The output is a list the security manager reviews with HR weekly. Most weeks the list is empty. The weeks it is not empty, you have a conversation.

### Step 3: Build an account compromise dashboard

Use your identity provider's built-in risk signals (Entra ID Risk, Okta ThreatInsight). Pull the events into your SIEM. Build a weekly report of:

- Impossible travel events
- MFA fatigue patterns
- New ASNs in sign-in history
- Risky OAuth grants
- Credential exposure hits from breach monitoring

Most weeks this is also empty. When it is not, your incident response process takes over. You are not building new capability here. You are operationalising what the identity platform already gives you.

### Step 4: Build a sensitive data movement dashboard

This is where you need the CASB or equivalent. The metrics:

- Outbound traffic to personal webmail domains
- Outbound traffic to unsanctioned cloud storage
- Uploads to unsanctioned LLM endpoints
- Public link shares from sanctioned storage

Do not block. Observe. The output is a weekly report stratified by user. You are looking for sustained patterns, not single events. When a user shows a sustained pattern, you have a conversation. The conversation is usually enough.

### Step 5: Build a source code exposure programme

If you have any engineering footprint at all:

- Run GitGuardian or TruffleHog against your public GitHub organisation continuously
- Run TruffleHog or similar against internal repos on a scheduled basis
- Instrument pre-commit hooks to block secrets
- Run a quarterly credential rotation drill to ensure rotation works when needed

This is mostly free. The tools are open source. The cost is engineering time and discipline. It is the single highest-yield control for the unintentional data exposure category.

### Step 6: Stand up an insider risk working group

A monthly meeting with security, HR, legal, and a senior business sponsor. The agenda:

- Review of leaver risk dashboard for the month
- Review of any concerning behavioural indicators surfaced by security
- Review of any HR-side indicators (performance plans, grievances, compensation issues)
- Review of policy questions legal has surfaced
- Decisions on any active investigations

This meeting is the actual programme. The dashboards and tools are supporting infrastructure. If you stand up the tools and skip the meeting, you have a tool deployment, not a programme.

### Step 7: Write the policy

A short document that covers:

- What signals are monitored and on what legal basis
- What data is retained and for how long
- Who has access to insider risk data
- What the escalation path is from indicator to investigation
- What the investigation process looks like
- What employee transparency exists about the programme

Without this document, every action your team takes is improvised and legally exposed. With this document, the programme is defensible. Most organisations skip this step. Do not skip it.

## What this looks like in practice

A financial services firm with 4,000 employees, a heavy regulatory burden, and a real fear of data loss runs this programme with:

- One security engineer at 50 percent allocation building and maintaining the dashboards
- One HR business partner at 25 percent allocation attending the working group and acting on leaver signals
- One senior lawyer at 10 percent allocation reviewing policy questions
- A monthly working group meeting of 90 minutes
- A weekly 30-minute review of the leaver dashboard by the security manager

The technology stack is the existing identity provider, the existing SIEM, the existing CASB, and one open source secrets scanner. The total incremental cost is headcount and meeting time. The total incremental benefit is a credible insider risk programme that does not depend on a six-figure vendor licence and a separate SOC team.

That is a realistic programme. It is not a marketing-deck programme. It is what works.

## Common anti-patterns to avoid

A short list of programme patterns I have seen fail, so you can recognise them in your own organisation.

### The dedicated insider threat team that nobody talks to

Some organisations create a specialist insider risk team, give them a tool, and seat them next to the SOC. The team runs the tool, produces alerts, and has no relationships with HR, legal, IT, or the business. After twelve months the team has a backlog of unresolved alerts, no investigations closed, and a frustrated leadership who cannot see what the team does. This is the most common failure mode.

The fix is structural: the insider risk function is a federated role, not a centralised team. The analyst sits inside the security function but reports to a working group that includes HR and legal. The investigation model is collaborative, not siloed.

### The board deck with misleading metrics

I have seen insider risk programmes report quarterly on metrics like "events detected" or "alerts triaged" or "policies enforced." None of those measure whether harm has been prevented. None of them measure whether the programme has caught a real incident.

The metrics that matter are: incidents contained before material harm, leavers whose departures were reviewed against insider risk indicators, account compromises remediated within the response SLA, secrets detected and rotated before exploitation, and unsanctioned tool usage that was reduced through friction fixes. Those metrics are harder to collect and less flattering than alert counts. They are the ones the board should see.

### The annual insider risk tabletop that goes nowhere

Many organisations run an annual insider risk exercise involving senior leadership, HR, legal, and security. The exercise produces a document. The document lists actions. The actions are not tracked. The next year the same exercise is run, with slightly different participants, and produces a similar document.

A tabletop only matters if its findings feed into the standing insider risk working group and are tracked to closure. If the working group does not exist, the tabletop is theatre.

### The "monitor everything" surveillance posture

Some insider risk programmes, usually driven by leadership anxiety after a media-reported incident, drift toward monitoring every employee all the time. They collect every signal, retain it indefinitely, and treat any deviation as suspicious. This posture is legally exposed in most jurisdictions, demotivates employees, and produces more noise than signal.

The discipline is to define what is monitored and why, to retain only what is needed, and to use the minimum data necessary to answer the risk question. That discipline is not weakness. It is what makes the programme defensible.

### The training programme that addresses the wrong audience

Most insider risk training is delivered to all employees annually, in a thirty-minute e-learning module that nobody remembers. It tells people not to steal data. It does not change behaviour.

The training that actually matters is targeted: developers need to know how to handle secrets. Salespeople need to know what customer data they can take to personal devices. Finance staff need to know how to use the sanctioned LLM. Managers need to know how to escalate concerns about a team member's behaviour. Each audience gets a short, specific module delivered at the point of need, not a generic annual compliance video.

## Practical takeaways for Monday morning

If you take nothing else from this essay, take these:

1. **Most of your insider incidents are not malicious.** If your programme is optimised to find malicious insiders, it is optimised for the wrong target. Reframe it around compromised accounts, unintentional exposure, and friction-driven workarounds.

2. **DLP has failed for twenty years.** Stop expecting the next vendor iteration to succeed where the last one did not. DLP treats symptoms. Treat causes instead.

3. **Behavioural baselining is right in concept, wrong in most deployments.** Stop measuring single-event anomalies. Start measuring sustained behavioural drift over weeks, correlated with HR context.

4. **The leaver process is the single highest-yield control.** Build it, instrument it, and review it weekly. Do not let it be an HR checklist. Make it a security and HR partnership.

5. **HR and legal are not optional partners.** Insider risk without HR context is blind. Insider risk without legal framework is exposed. Build the working group first. Build the tools second.

6. **Most "insider threat tools" are partial answers wrapped in platform stories.** Buy point solutions for specific slices if you have the budget. Do not buy a platform expecting it to cover the whole problem.

7. **You probably do not need a new product.** You need HRIS integration, identity provider risk signals operationalised, a CASB egress dashboard, a secrets scanning pipeline, and a monthly working group. Most of that is plumbing and discipline, not licence spend.

8. **The privacy discipline is a feature, not a constraint.** If you cannot explain to legal exactly what you are monitoring and why, you should not be monitoring it. The act of defining it is what makes the programme defensible.

The insider threat problem is not what you think. It is not the malicious actor. It is the engineer, the salesperson, the finance manager, the HR coordinator, the contractor, the junior developer, the tired employee at the end of a long week who makes a small decision that turns into a large incident. The programme you build should be designed for them, not for the Hollywood insider in a hoodie walking out the door with a hard drive.

That programme looks less impressive in a board deck. It prevents more harm. Build it anyway.

---

**Further reading:**

- Code42 Incydr Annual Insider Risk Report — annual telemetry on insider incident categories
- DTEX Systems Insider Threat Intelligence Reports — behavioural telemetry on departing employees
- NIST SP 800-53 control family AC, AU, PS — the standards baseline for insider risk controls
- The "Verizon Data Breach Investigations Report" insider misuse section — useful for sanity-checking assumptions
- "The CERT Guide to Insider Threats" — older but still the foundational reference for categorisation

**Have a counter-argument or a programme that has worked well for you?** Reply in the Discord community. Insider risk programmes are built by practitioners arguing through edge cases, not by vendors selling point solutions.

---

*Next week: Detection engineering for the unintentional insider — building alerts that fire on the patterns that matter instead of the patterns the marketing literature describes.*