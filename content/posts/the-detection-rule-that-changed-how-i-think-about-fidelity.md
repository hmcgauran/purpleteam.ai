---
title: "The Detection Rule That Changed How I Think About Fidelity"
slug: "the-detection-rule-that-changed-how-i-think-about-fidelity"
date: 2026-08-20
tags:
  - "Detection Engineering"
  - post
author: Hugh McGauran
excerpt: "There is one detection rule in my career that genuinely changed how I think about detection fidelity. It was not a clever rule. It was a simple rule. The simplicity is what taught me the most. Here is the rule and what it taught me"
layout: layouts/post.njk
permalink: /essays/the-detection-rule-that-changed-how-i-think-about-fidelity/
---

There is one detection rule in my career that genuinely changed how I think about detection fidelity. It was not a clever rule. It was a simple rule. The simplicity is what taught me the most about what a good detection rule actually is.

I am going to describe the rule and what it taught me. I am going to be careful about the specifics. The client is not identified. The rule is generalised. The lesson is real.

## The rule

The rule was this. If a process on a workstation spawns a child process that the parent process has never spawned before, the rule fires. The rule is the parent-child process anomaly rule. The rule is the kind of rule that the modern endpoint detection platforms can express natively. The rule was not a clever rule. The rule was a simple rule.

The rule was deployed across the entire fleet. The rule was deployed in a non-blocking mode. The rule was deployed with the appropriate scope and the appropriate exclusion list. The rule was deployed to a small blast radius and monitored for a week. The rule was deployed to the entire fleet after the week of monitoring.

The rule fired. The rule fired more than anyone expected. The rule fired on software installers, on legitimate software updates, on a handful of development workflows, and on three real attacks. The three real attacks were all the same kind. The three real attacks were all the credential-dumping kind, where the malware spawned a child process to read the browser's credential store. The credential-dumping kind was a real attack. The credential-dumping kind was a real attack that the SOC had not been detecting before.

The rule fired on the credential-dumping attacks. The rule fired on the credential-dumping attacks with no false negatives. The rule was a high-fidelity detection. The rule was the kind of rule that the SOC analyst could trust.

## What the rule taught me

The rule taught me several things about detection fidelity. The first is that the fidelity of a detection rule is not the same as the cleverness of the detection rule. The fidelity of the rule is the measure of how often the rule fires on the things the rule is supposed to fire on, and how rarely the rule fires on the things the rule is not supposed to fire on. The fidelity of the rule is not the cleverness of the rule. The fidelity of the rule is the operational behaviour of the rule.

The clever rule is the rule that the detection engineer is proud of. The clever rule is the rule that uses the latest machine learning technique. The clever rule is the rule that the detection engineer writes and the SOC analyst suppresses. The clever rule is the rule that the detection engineer writes and the detection engineer has to retire.

The simple rule is the rule that the SOC analyst uses. The simple rule is the rule that fires on the right things. The simple rule is the rule that the SOC analyst trusts. The simple rule is the rule that the SOC analyst does not suppress.

The second is that the fidelity of a detection rule is a function of the operational environment, not the rule logic. The rule logic is the same everywhere. The operational environment is different everywhere. The operational environment is the specific systems, the specific users, the specific workflows, the specific threat landscape. The operational environment is what makes the rule fire on the right things and not on the wrong things.

The detection engineer who writes the rule in one operational environment and deploys the rule in another operational environment is the detection engineer who is going to be surprised. The detection engineer who writes the rule in the operational environment and deploys the rule in the same operational environment is the detection engineer who is going to be reliable.

The third is that the tuning of a detection rule is more important than the writing of the detection rule. The writing of the rule is the technical work. The tuning of the rule is the operational work. The operational work is the work that takes longer. The operational work is the work that produces the fidelity. The operational work is the work that the leadership is most likely to want to skip. The operational work is the work that the leadership cannot afford to skip.

The fourth is that the exclusions of a detection rule are the most important part of the detection rule. The exclusions are the list of the things that the rule is allowed not to fire on. The exclusions are the things that the SOC analyst is going to use to argue that the rule is broken. The exclusions are the things that the detection engineer is going to use to argue that the rule is correct.

The exclusions should be specific. The exclusions should be named. The exclusions should have owners. The exclusions should have a reason. The exclusions should be reviewed regularly. The exclusions should be the part of the rule that the detection engineer is the most careful about.

The fifth is that the fidelity of a detection rule is a function of the relationship between the rule and the SOC analyst. The rule is the technical thing. The relationship is the human thing. The fidelity of the rule is the measure of whether the SOC analyst trusts the rule enough to investigate the alert that the rule fires. The fidelity of the rule is not the technical thing. The fidelity of the rule is the human thing.

The SOC analyst who trusts the rule is the SOC analyst who investigates the alert. The SOC analyst who does not trust the rule is the SOC analyst who suppresses the alert. The detection engineer who builds the relationship with the SOC analyst is the detection engineer who produces the high-fidelity rule. The detection engineer who does not build the relationship with the SOC analyst is the detection engineer who produces the suppressed rule.

The sixth is that the fidelity of a detection rule is a function of the documentation of the rule. The rule is the technical thing. The documentation is the explanation of the technical thing. The documentation is the thing that the SOC analyst reads at 11pm when the alert fires. The documentation is the thing that the SOC analyst uses to decide whether to investigate the alert.

The documentation should be clear. The documentation should be honest. The documentation should be specific. The documentation should be the explanation that the SOC analyst needs.

The seventh is that the fidelity of a detection rule is a function of the time the rule has been running. The rule is the technical thing. The time is the operational thing. The time is the duration for which the rule has been running. The time is the duration for which the SOC analyst has been investigating the alerts that the rule fires. The time is the duration for which the detection engineer has been tuning the rule.

The rule that has been running for a month is a different rule than the rule that has been running for a day. The rule that has been running for a month is a tuned rule. The rule that has been running for a day is an untuned rule. The tuned rule is the rule that is the high-fidelity rule. The untuned rule is the rule that is the low-fidelity rule.

## The honest answer

The honest answer is that the detection rule that changed how I think about fidelity was a simple rule. The honest answer is that the simplicity of the rule is what made the rule useful. The honest answer is that the simplicity of the rule is what made the rule high-fidelity. The honest answer is that the simplicity of the rule is what made the rule worth writing.

If you are a detection engineer, write the simple rule. If you are a detection engineer, deploy the simple rule. If you are a detection engineer, tune the simple rule. If you are a detection engineer, document the simple rule. The simple rule is the rule that is the high-fidelity rule. The simple rule is the rule that is worth writing.
