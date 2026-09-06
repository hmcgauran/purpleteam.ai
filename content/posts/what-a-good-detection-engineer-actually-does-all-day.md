---
title: "What a Good Detection Engineer Actually Does All Day"
slug: "what-a-good-detection-engineer-actually-does-all-day"
date: 2026-09-24
tags:
  - "Detection Engineering"
  - "Blue Team"
  - post
author: Hugh McGauran
excerpt: "The job description for a detection engineer reads like a software engineer with a security focus. The actual job is more like an editor at a small newspaper. Here is what the work looks like when the title is right and the work is also right"
layout: layouts/post.njk
permalink: /essays/what-a-good-detection-engineer-actually-does-all-day/
---

The job description for a detection engineer reads like a software engineer with a security focus. The actual job is more like an editor at a small newspaper. You are sitting between a stream of inputs and a stream of outputs, and the work is making the right thing land in the right place at the right time.

Here is what the work looks like when the title is right and the work is also right.

## The inputs

The detection engineer has more inputs than they have time. The stream is constant. The SIEM is showing things. The endpoint telemetry is showing things. The threat intel team has published a new report. The vulnerability management team has flagged a CVE. The red team has run a new emulation. The CISO has read a thing in a magazine. The SOC has been paged at 3am for a thing that turned out to be a misconfiguration. Every one of these inputs is potentially actionable. None of them is unambiguously actionable.

The work of the detection engineer is to triage. To read the input, decide whether it changes the detection posture of the environment, and if it does, write a rule that captures the change. The triage is the work. The rule is the artefact.

Most detection engineers spend too much time on the artefact and not enough on the triage. They are too quick to write the rule and too slow to ask whether the rule is the right response to the input. A good detection engineer spends most of their time on the triage and only as much time as necessary on the rule.

## The editing

The detection rule is an editorial product. It is a thing that needs to be clear, accurate, and useful to the SOC analyst who is going to read it at 11pm while they are tired. The analyst needs to know what the rule is detecting, why it is detecting it, what the false-positive profile looks like, and what the response should be. If the rule does not communicate those four things clearly, it is a bad rule, regardless of how clever the detection logic is.

The editing work is the difference between a rule that the SOC trusts and a rule that the SOC suppresses. The rule that the SOC suppresses is a failure of the detection engineering function, not a failure of the SOC. The detection engineering function exists to make the SOC's job possible. If the SOC is suppressing the rule, the detection engineering function has failed.

The most common failure mode is the rule that fires on a hundred things a day. The SOC analyst does not have time to triage a hundred things a day. The SOC analyst suppresses the rule. The detection engineering function declares the rule a success because it is firing. The SOC declares the rule a failure because it is firing. Both are right.

The fix is the editing. The rule needs to fire on the things that matter and not on the things that do not. The detection engineering function is responsible for getting that balance right. The SOC is responsible for using the rule.

## The pipeline

The detection engineering function has a pipeline. The pipeline is what makes the function durable. A detection engineer who writes a rule and deploys it by hand is a detection engineer who will lose track of which rules are deployed. A detection engineering function with a pipeline is a function that knows which rules are deployed, knows which rules are firing, and knows which rules need to be retired.

The pipeline is not glamorous. The pipeline is the unglamorous infrastructure that makes the unglamorous infrastructure work. A detection engineering function without a pipeline is a function that has a hard time scaling and a hard time surviving personnel changes. A detection engineering function with a pipeline is a function that can survive personnel changes and scale.

The minimum viable pipeline has four stages. The first is the writing. The detection engineer writes the rule. The second is the testing. The rule is tested against historical data, against synthetic data, and against the production environment with a small blast radius. The third is the deployment. The rule is deployed to production with the appropriate scope. The fourth is the monitoring. The rule is monitored for false-positive rate, true-positive rate, and overall utility. If the rule is not useful, the rule is retired.

The pipeline does not need to be sophisticated. The pipeline needs to exist. The pipeline is the difference between a function that scales and a function that does not.

## The cadence

The detection engineering function has a cadence. The cadence is the rhythm of the work. The cadence is not the schedule. The cadence is the shape of the week. The cadence is the part of the work that is recurring and the part that is not.

The recurring part is the triage. The detection engineer is reading the inputs every day and deciding which ones to act on. The recurring part is the editing. The detection engineer is reviewing the rules and improving them as the environment changes. The recurring part is the monitoring. The detection engineer is checking the rules and retiring the ones that are not useful.

The non-recurring part is the project. The detection engineering function is part of a larger programme that has projects. The threat emulation programme. The vulnerability management programme. The compliance programme. The detection engineering function contributes to these projects and the projects shape the work of the function.

The cadence is the part of the work that the SOC analyst can predict. If the SOC analyst can predict the cadence, the SOC analyst can plan their work around the cadence. If the SOC analyst cannot predict the cadence, the SOC analyst is reacting to the function instead of working with the function.

## The most underrated part of the work

The most underrated part of the work is the documentation. Every rule needs a documentation entry. What is it detecting. Why is it detecting it. What is the false-positive profile. What is the response. Who owns it. When was it last reviewed. The documentation is the part of the work that nobody wants to do. The documentation is also the part of the work that makes the function durable.

A detection engineering function without documentation is a function that depends on the memory of the individual engineers. When an engineer leaves, the function loses the knowledge of the rules. When an engineer joins, the function cannot transfer the knowledge of the rules. A detection engineering function with documentation is a function that survives personnel changes. The documentation is the part of the work that the function cannot afford to skip.

The documentation is not exciting. The documentation is the work.

## The honest job

The honest job of the detection engineer is the editing, the triage, the pipeline, the cadence, and the documentation. The job is not the clever detection logic. The job is not the threat hunting. The job is not the incident response. Those are parts of the broader function, but the job of the detection engineer is the unglamorous work that makes the broader function possible.

If you are hiring a detection engineer, hire for the editing. The technical skills can be taught. The judgement about when to write a rule and when not to write a rule is much harder to teach. Hire for the judgement.
