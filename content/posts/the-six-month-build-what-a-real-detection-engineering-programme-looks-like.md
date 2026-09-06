---
title: "The Six-Month Build: What a Real Detection Engineering Programme Looks Like"
slug: "the-six-month-build-what-a-real-detection-engineering-programme-looks-like"
date: 2026-07-17
tags:
  - "Detection Engineering"
  - "Blue Team"
  - post
author: Hugh McGauran
excerpt: "Most 'detection engineering programmes' are not programmes. They are a person with a Sigma rule and a prayer. Here is what a real six-month build looks like, in order, and what each phase actually costs"
layout: layouts/post.njk
permalink: /essays/the-six-month-build-what-a-real-detection-engineering-programme-looks-like/
---

Most "detection engineering programmes" are not programmes. They are a person with a Sigma rule and a prayer. The person writes a rule, the rule fires on a hundred things a day, the SOC analyst suppresses the rule, the person writes another rule, and the cycle continues.

Here is what a real six-month build looks like, in order, and what each phase actually costs.

## Month 1: data engineering

The first month is data engineering. The data is the foundation. The data is the thing the detections are built on. The data is the thing the SOC analyst queries when the alert fires. The data is the thing the red team validates when the red team is emulating the threat.

Most environments have a third of the data they think they have. The collection agent is installed but not running. The collection agent is running but not shipping. The collection agent is shipping but the schema changed and nobody updated the parser. The collection agent is fine but the data is being dropped at the SIEM because the SIEM is at capacity. There is always something.

The first month is the work of finding those things. The first month is the work of fixing those things. The first month is the work of making sure that the data the detections are built on is the data that the environment is producing.

The first month is also the work of building the data pipeline. The data pipeline is the thing that takes the data from the source, normalises the data, enriches the data, and delivers the data to the query layer. The data pipeline is the unglamorous infrastructure that makes the unglamorous infrastructure work.

The first month is the most expensive month. The first month is the month that the leadership is most likely to want to skip. The first month is the month that the leadership cannot afford to skip. The detections built on a broken data pipeline are detections that fire on the wrong things. The detections built on a working data pipeline are detections that fire on the right things. The difference is the first month.

## Month 2: profiling

The second month is profiling. The profiling is the work of understanding what the environment actually looks like when nothing interesting is happening. The profiling is the work of building the baseline.

The profiling is the work of asking the environment what the environment looks like. For each identity, what is the pattern of authentication. For each host, what is the pattern of process execution. For each network flow, what is the pattern of communication. The profiling is the work of answering those questions with data, not with assumptions.

The profiling is the work that most programmes skip. The profiling is the work that is the most under-valued. The profiling is the work that is the most important. The detections built on a bad profile are detections that fire on the wrong things. The detections built on a good profile are detections that fire on the right things. The difference is the second month.

The second month is the month that the detection engineering function learns the environment. The second month is the month that the detection engineering function builds the mental model of the environment. The second month is the month that the detection engineering function stops guessing about the environment and starts measuring the environment.

## Month 3: detection backlog

The third month is the detection backlog. The detection backlog is the list of the detections that the detection engineering function is going to write. The detection backlog is the priority order of the detections. The detection backlog is the thing that the SOC analyst is going to live with.

The detection backlog is the most under-discussed part of the function. Most programmes have a backlog that is a list of "things we should detect." Most programmes have a backlog that is a list of "things that would be nice to have." Most programmes have a backlog that is not the priority list of the detections that the function is going to write in the next six months.

The detection backlog should be prioritised by risk. The detection backlog should be prioritised by the threats that are credible to the environment. The detection backlog should be prioritised by the threats that the threat intelligence programme has identified as the credible threats. The detection backlog should be prioritised by the gaps that the red team has identified in the detection coverage.

The detection backlog is the most important part of the function. The detection backlog is the thing that the leadership is most likely to want to skip. The detection backlog is the thing that the leadership cannot afford to skip. The detections built on a bad backlog are detections that fire on the wrong things. The detections built on a good backlog are detections that fire on the right things. The difference is the third month.

## Month 4: writing

The fourth month is writing. The writing is the work of turning the backlog into detections. The writing is the work of writing the rule, testing the rule, deploying the rule, and monitoring the rule.

The writing is the most visible part of the function. The writing is the part that the leadership sees. The writing is the part that the SOC analyst sees. The writing is the part that the red team sees. The writing is the part that gets the credit and the blame.

The writing is also the least expensive part of the function. The writing is the part that scales with the size of the team. The writing is the part that is the most easily measured. The writing is the part that the leadership is the most comfortable talking about.

The writing is also the part that is the most easily done wrong. The writing is the part that the SOC analyst is the most exposed to. The writing is the part that produces the noise that the SOC analyst has to triage. The writing is the part that produces the false positives that the SOC analyst has to suppress. The writing is the part that is the most important to get right.

The fourth month is the month that the detection engineering function writes the first set of detections. The fourth month is the month that the SOC analyst starts to see the work. The fourth month is the month that the function starts to ship.

## Month 5: testing and tuning

The fifth month is testing and tuning. The testing is the work of validating the detections. The tuning is the work of adjusting the detections to fire on the right things and not on the wrong things.

The testing is the work that most programmes skip. The testing is the work that is the most expensive. The testing is the work that is the most important. The detections that are not tested are detections that fire on the wrong things. The detections that are not tested are detections that the SOC analyst suppresses. The detections that are not tested are the detections that are not worth the work.

The testing has three parts. The first is the historical test. The detection is run against historical data, and the detection's true-positive rate and false-positive rate are measured. The second is the synthetic test. The detection is run against synthetic data that represents the threat the detection is designed to detect. The third is the production test. The detection is deployed to a small blast radius in the production environment, and the detection's behaviour is observed.

The tuning is the work of adjusting the detection based on the testing. The tuning is the work of reducing the false-positive rate. The tuning is the work of increasing the true-positive rate. The tuning is the work of making the detection useful to the SOC analyst.

The fifth month is the month that the detection engineering function tunes the detections. The fifth month is the month that the SOC analyst starts to trust the detections. The fifth month is the month that the function starts to be useful.

## Month 6: operationalisation

The sixth month is operationalisation. The operationalisation is the work of making the function durable. The operationalisation is the work of making the function survive personnel changes. The operationalisation is the work of making the function survive changes in the environment.

The operationalisation has three parts. The first is the documentation. The function is documented. The detections are documented. The pipeline is documented. The runbook is documented. The documentation is the part of the function that is the most under-valued. The documentation is the part of the function that is the most important.

The second is the pipeline. The function has a pipeline. The pipeline is the thing that makes the function durable. The pipeline is the thing that makes the function survive personnel changes. The pipeline is the thing that makes the function survive changes in the environment.

The third is the cadence. The function has a cadence. The cadence is the rhythm of the work. The cadence is the part of the work that is recurring. The cadence is the part of the work that the SOC analyst can predict. The cadence is the part of the work that makes the function a function.

The sixth month is the month that the function becomes a function. The sixth month is the month that the function becomes durable. The sixth month is the month that the function is ready to be the foundation for the next six months of work.

## The honest cost

The honest cost of a real six-month build is two to three detection engineers, one to two data engineers, and the dedicated time of a senior detection engineering lead. The honest cost is a meaningful investment. The honest cost is the cost of doing the work.

The honest cost of not doing the work is much higher. The honest cost of not doing the work is a function that produces noise. The honest cost of not doing the work is a function that the SOC analyst suppresses. The honest cost of not doing the work is a function that is not worth the money.

The honest answer is that the six-month build is the work. The honest answer is that the work is the investment. The honest answer is that the work is the difference between a function that is useful and a function that is not.
