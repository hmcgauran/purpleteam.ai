---
title: "The Red Team Engagement That Changed How I Think About Risk"
slug: "the-red-team-engagement-that-changed-how-i-think-about-risk"
date: 2026-08-06
tags:
  - "Red Team"
  - "Purple Teaming"
  - post
author: Hugh McGauran
excerpt: "There is one engagement in my career that genuinely changed how I think about cybersecurity risk. It was not the most sophisticated operation I have run. It was not the most expensive. It was the one that taught me the most. Here is what it was and what it taught me"
layout: layouts/post.njk
permalink: /essays/the-red-team-engagement-that-changed-how-i-think-about-risk/
---

There is one engagement in my career that genuinely changed how I think about cybersecurity risk. It was not the most sophisticated operation I have run. It was not the most expensive. It was not the most clever. It was the one that taught me the most about what risk actually looks like inside a real enterprise.

I am going to describe it, but I am going to be careful about the details. The client is not identified. The specifics are changed. The lesson is real.

## The setup

The client was a mid-sized financial services firm. They had a SOC. They had a detection engineering function. They had just rolled out a new EDR. They had just rolled out a new SIEM. They had just rolled out a new SOAR. The CISO was presenting to the board in two months. The CISO wanted to be able to say that the new stack was working.

The engagement was a sixty-day red team. The scope was the production environment. The objective was to emulate a realistic threat actor and report on what the blue team could detect. The deliverable was a report. The CISO was going to take the report to the board.

We were told the new stack was working. We were told the EDR was catching the new attacks. We were told the SIEM was correlating. We were told the SOAR was automating the response. We were told the blue team was confident.

## What we did

We did what a realistic threat actor would do. We started with a phishing campaign. We targeted twenty specific employees, all in roles that would have access to the systems a real attacker would want to reach. We crafted the phishing to look like the kind of thing a real attacker would send. We did not use zero-days. We did not use exotic tooling. We used the same off-the-shelf tooling that a real attacker would use, configured in the same default configuration that a real attacker would use.

The phishing got through. Eleven of the twenty recipients clicked. Nine of the eleven entered their credentials on the credential-harvesting page. We had nine sets of credentials, all on the first day.

We then did what a real attacker would do with nine sets of credentials. We logged in. We moved laterally. We escalated. We found the file server. We found the database. We found the backup system. We exfiltrated a small, representative sample of the data. We did not take the whole database. We did not encrypt the file server. We did notransomware anything. We took a sample, left a marker, and reported.

The whole thing took us four hours. The whole thing took us four hours, from the first click to the exfiltration of the sample.

## What the blue team saw

The blue team saw none of it. Not the phishing, not the lateral movement, not the privilege escalation, not the file access, not the exfiltration. The blue team saw nothing. The new stack was not working.

When we debriefed, the SOC manager told us the stack was working. The SOC manager told us the EDR was catching the new attacks. The SOC manager told us the SIEM was correlating. The SOC manager told us the SOAR was automating the response. The SOC manager was wrong about all of it. The new stack was not working. The new stack was not configured. The new stack was reporting on a dashboard that nobody was watching.

The CISO was not happy. The CISO was about to take a report to the board that said the new stack was working. The CISO had been told the new stack was working for six months. The CISO was about to be wrong, in front of the board, on the basis of a lie that the CISO had been told by the people who were supposed to be telling the CISO the truth.

We had a long conversation. The conversation was not pleasant. The conversation was necessary. The conversation ended with the CISO understanding that the new stack was not working, that the blue team was not detecting the attacks, and that the report the CISO was about to take to the board was not the report the CISO should be taking to the board.

## What the engagement taught me

The engagement taught me several things. The first is that the gap between the SOC's confidence and the SOC's actual capability is often very large. The SOC was confident. The SOC was not capable. The SOC's confidence was based on the dashboard that the new stack was reporting on. The SOC's confidence was not based on the actual detection of the actual attacks.

The second is that the new stack is a tool. The new stack is not a capability. The capability is the people who configure the tool, who monitor the tool, who triage the alerts that the tool fires. The new stack without the people is a dashboard. The new stack with the people is a detection capability. The new stack is not the detection capability.

The third is that the CISO is the last person to know. The CISO is the last person to know because the CISO is told by the people who are supposed to be telling the CISO the truth, and the people who are supposed to be telling the CISO the truth are the people who are most invested in the CISO believing the truth that the CISO is being told. The feedback loop between the CISO and the actual capability is broken. The CISO is being told what the CISO wants to hear. The CISO is not being told what the CISO needs to hear.

The fourth is that the only way to know the truth is to test it. The CISO is being told the new stack is working. The CISO is being told the blue team is confident. The CISO is being told the new stack is detecting the new attacks. The CISO is being told all of these things. The only way to know whether the CISO is being told the truth is to test the truth. The red team engagement is the test.

The fifth is that the red team engagement is more useful than the red team report. The red team report is the artefact. The red team engagement is the work. The work is the four hours of the engagement, the conversations during the engagement, the debrief at the end of the engagement, the conversation with the CISO about the truth. The report is the document that captures the work. The work is the conversation that changes the CISO's understanding.

The sixth is that the red team engagement is more useful as a baseline than as a verdict. The engagement is a single data point. The engagement is not a verdict. The engagement is a snapshot of the detection capability at a specific point in time. The engagement is the baseline against which the next engagement will be measured. The engagement is the document that says "this is what the detection capability looked like on this date." The next engagement is the document that says "this is what the detection capability looked like on that date." The difference between the two documents is the change in the detection capability. The change is the thing that the CISO actually needs to know.

The seventh is that the most dangerous week of a CISO's tenure is the week before the CISO presents to the board. The most dangerous week is the week when the CISO is most exposed, most vulnerable, and most likely to be told what the CISO wants to hear. The most dangerous week is the week when the red team engagement is most useful.

The eighth is that the red team engagement is not the answer. The red team engagement is the question. The question is "are we actually able to detect the things that we need to detect?" The answer is in the changes that the engagement drives. The answer is not in the report. The answer is in the next report, the one after the changes are made, the one that says the new stack is actually working because the new stack is actually working.

## The honest answer

The honest answer is that the red team engagement is one of the most useful things that a CISO can do. The honest answer is that most CISOs do not do the red team engagement as often as the CISO should, and the red team engagements that the CISO does are not as honest as the red team engagements should be. The honest answer is that the red team engagement that changes how the CISO thinks about risk is the engagement that is the most useful, and that engagement is rare.

If you are a CISO, run a red team engagement. If you are a CISO, run the engagement as a baseline. If you are a CISO, take the report to the board not as a verdict but as a question. If you are a CISO, answer the question with the next engagement. The answer is in the work. The work is the change.
