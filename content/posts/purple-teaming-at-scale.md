---
title: "Purple Teaming at Scale: How It Changes When You Have 20 Blue Team Analysts"
slug: "purple-teaming-at-scale"
date: 2026-09-10
tags:
  - "Purple Teaming"
  - "Detection Engineering"
  - post
author: Hugh McGauran
excerpt: "Most purple team advice is written for a team of three. If you scale to twenty, the bottlenecks move, the failure modes change, and the programme either matures or quietly dies on contact with reality. Here is what shifts, and what does not"
layout: layouts/post.njk
permalink: /essays/purple-teaming-at-scale/
---

Most writing about purple teaming is written for the team of three. The senior red-team lead, the senior detection engineer, the CISO who needs to be in the room. The advice scales about as well as the recipe for dinner scales to a wedding. If you are running a programme at twenty blue-team analysts, the patterns that worked at three are now a real liability.

Here is what changes, and what does not.

## The first thing that breaks: the debrief

At three people, the debrief is a thirty-minute conversation over coffee. Everyone who needs to be in the room fits. The red-team lead walks through the kill chain on a whiteboard, the detection engineer pulls up the SIEM query they were running, the SOC manager explains why the alert was suppressed, and the CISO asks the obvious questions. Everyone leaves with a shared understanding of what happened and what to do about it.

At twenty people, that conversation does not happen. You do not have a room big enough and you do not have the time. The debrief becomes a written document. Which means the person who writes it has an enormous amount of power. Which means the most important hire on a scaling purple team is the one who writes the debrief.

If the debrief is good, the programme scales. If the debrief is bad, the programme has a serious morale problem within a quarter and a serious attrition problem within a year.

What makes a debrief good is not the prose. It is the structure. The first section is the kill chain, in plain language, with the specific actions the red team took. The second is what the blue team saw, with the specific alerts that fired and the specific ones that did not. The third is the gap, which is the gap between what the blue team should have seen and what they actually saw. The fourth is the action, which is the specific change that closes the gap and the owner of that change. That is it. Four sections. Owners have names and dates. Gap items are tagged with the relevant detection use case and the threat technique. If your debriefs do not look like that, your programme is going to have a scaling problem long before it has a people problem.

## The second thing that breaks: the threat-library coverage

At three people, you can run a red team that emulates five or six named adversary groups. Everyone knows what FIN7 looks like, what Lazarus looks like, what a generic script kiddie looks like. You do not have to be exhaustive, because the gap between what you cover and what actually shows up on your network is small.

At twenty, the gap is large. A SOC at twenty analysts is going to be facing hundreds of distinct threat behaviours across dozens of adversary groups, and the threat-intelligence team will rightly insist that you cover all of them. Which means your red team cannot just be three good operators any more. They need to be running an operationally-meaningful emulation program that can credibly emulate the threat behaviours your threat-intel team actually cares about.

This is where most programmes fail. They either keep running a small, focused red team and accept that the threat coverage is incomplete, or they try to scale the red team proportionally and discover that good red teamers are a different kind of person than good SOC analysts and the hiring problem is not the same.

The honest answer is somewhere in between. You scale the red team by an order of magnitude smaller than the SOC. The leverage comes from tooling, automation, and a tight threat-library selection process that says no to emulating groups that are not credible threats to your industry. A SOC at twenty that is running a red team of three is fine. A SOC at twenty that is running a red team of three and trying to emulate the full top-twenty threat groups is not.

## The third thing that breaks: the detection engineering pipeline

At three, detection engineering is one person writing a Sigma rule in an editor and committing it to a repo. The deploy pipeline is whatever is there, and the testing is whatever that person remembers to do.

At twenty, detection engineering is a function. There are people who write rules, people who test them, people who deploy them, people who monitor them for false positives. There is a backlog, there are SLAs, there is a CI pipeline. This is a meaningful investment and you should not skip it. The detection rule that works in the test environment and breaks in production is a real problem, and you cannot solve it by having one careful person. You solve it by having a process that catches the failure mode before production.

The mistake most programmes make here is conflating the detection engineering team with the SOC analysts. They are not the same. The SOC analyst triages alerts and investigates incidents. The detection engineer writes, tests, and maintains the rules that fire the alerts. Mixing the two functions looks like a cost saving and works out to a 30 percent productivity tax on both functions. Do not do it.

## What does not change: the principles

The principles that made your three-person programme work still work at twenty. The threat-model-driven analysis still works. The detection engineering grounded in your environment still works. The explicit handoff between red and blue, with a human in the loop, still works. The honest debrief still works. The postmortems that name the specific gap and assign the specific owner still work.

What changes is the operational overhead. At three, the principles are the work. At twenty, the operational overhead is most of the work, and the principles have to be encoded into process or they will be lost.

The way you encode them is the four-section debrief, the threat-library selection process, and the detection engineering pipeline. None of those are exciting. All of them are the difference between a programme that scales and a programme that quietly dies on contact with reality.

## The most underrated hire

If I had to name the single most important hire on a scaling purple team, it is the person who writes the debrief. Not the red team lead. Not the SOC manager. The person who turns the kill chain and the SIEM queries and the alert suppression logic into a four-section document that a tired SOC analyst can read at 11pm and understand.

That is the role nobody applies for, the role nobody trains for, the role that everyone thinks they can do until they try. Find someone who can write, give them the authority to ask the red team and blue team the right questions, and protect their time.

That person is the difference between a programme that scales and a programme that does not.
