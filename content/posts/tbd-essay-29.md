---
title: "Containing a Credential-Driven Intrusion: What Good Looks Like in the First Hour"
slug: "tbd-essay-29"
date: 2026-10-08
tags:
  - "Purple Teaming"
  - "Identity"
  - "Incident Response"
  - "Detection Engineering"
  - post
author: Hugh McGauran
excerpt: "Detection is half the problem. The other half is what happens in the first hour after the SOC believes the credential is real — the joins, the actions, the order, and the things the playbook never rehearsed. This is the response side of identity-focused purple teaming"
layout: layouts/post.njk
permalink: /essays/tbd-essay-29/
---

The exercise finds the exposure. The exercise does not contain it.

Most identity-focused purple team exercises end with a report and a remediation ticket. The ticket joins a queue. The queue grows. The next exposure finds the queue, and the queue joins the next quarter's review. Detection coverage looks acceptable on a dashboard. The exercise is treated as done. The response work has not started.

This essay is about the response work. It is the second in the series on identity-focused purple teaming. The first was [Purple Teaming Your Identity Environment: Where the Real Attacks Live Now](/essays/purple-teaming-your-identity-environment/) — it covered what to look for, what to emulate, what to detect, and what to measure. This one covers the part that follows: what good containment looks like against a credential-driven intrusion in the first hour, and what an exercise needs to verify before that hour arrives.

The hour is short. The decisions inside it are not.

## Why the first hour is different for credential-driven attacks

A credential-driven intrusion looks like a user working. The session is valid. The device is managed. The IP is in the user's normal range. The authentication event looks like every other authentication event the SOC has seen that morning. The first signal is rarely an alert. The first signal is an analyst noticing something the alert did not catch, or a user reporting something the analyst would not have caught.

Three things make the first hour of a credential-driven intrusion different from the first hour of a malware-driven intrusion.

The first is that the obvious moves are wrong. Isolating the device, blocking the IP, killing the process — none of those are the right move, because the device is not the problem. The credential is the problem. The device is the user's laptop. Blocking the IP does not work because the IP is the user's IP. Killing the process does not work because there is no process. The instinct to do something technical and visible has to be replaced with the discipline to act on the credential.

The second is that the credential has reach. A leaked credential is not a single asset. It is a graph. From the credential, the attacker can reach every resource the identity can reach, through every integration the identity has, for as long as the session is valid and the token is alive. The first hour is not about understanding what happened. The first hour is about shrinking the graph before the attacker walks it further.

The third is that the response itself is detectable. A credential that authenticates and is then revoked mid-session leaves traces. A session that is killed produces artefacts. A device that is forcibly signed out produces a help-desk ticket. Containment is a signal the attacker can read. The order of the containment moves matters. Get the order wrong, and the attacker knows they have been burned before the SOC has finished revoking.

## The first decision: is the credential real?

Most reported credential exposures turn out to be test data, old data, or data attached to an identity that no longer exists. The first decision is the unglamorous one: confirm the credential is real, in scope, and currently valid.

Three checks, in this order:

1. **Is the credential associated with a live identity?** The account is active, not suspended, not deleted, not merged into another account by an identity cleanup project. A leaked credential for a deleted account is not an incident. A leaked credential for an active account, even one nobody has logged into for eighteen months, is an incident.
2. **Is the credential currently usable?** It has not been rotated, it has not expired, MFA is not enforced on the path the credential authenticates against, the IdP has not been reconfigured. The credential does not need to work today for it to matter — it needs to work on the path the attacker would take.
3. **Is the credential in the environment the leak implies?** A leaked credential surfaced from a developer's personal GitHub repository may or may not be the same credential the developer uses at work. People reuse passwords. People also have separate personal accounts. The check is not "is this the work password" — it is "has this password ever authenticated against any system we own."

These three checks take less than ten minutes if the data is there. They take an hour if the data is not. The exercise that found the credential should have rehearsed this step. If the exercise did not rehearse this step, the report is incomplete.

## What to disable first

Speed matters more than completeness on the first hour. The instinct is to do everything at once: revoke the credential, kill the session, isolate the device, disable the account, notify the user, page the legal team, call the CEO. The instinct is wrong. Each action produces a side effect. The side effects have an order.

The order:

1. **Revoke the credential.** Disable the password, invalidate the API key, expire the OAuth token, rotate the service-account secret. This is the action that stops the next authentication. It does not stop the current session. It does not stop a session that is already authenticated and holding a long-lived token. It stops the next login.
2. **Kill the active session.** Force a sign-out from every device. Revoke refresh tokens. Invalidate session cookies. This is the action that stops the session that is already running. It is detectable to the attacker, because the user's browser stops working. Get the credential revocation done first, so the attacker cannot simply re-authenticate.
3. **Isolate the device, if there is a device.** A managed device can be remotely locked and wiped at the device-management layer. A contractor's laptop cannot. An unmanaged personal device that the user signed into a SaaS tenant from cannot be reached at all. The device step is conditional. The credential step is not.
4. **Disable the account, only if the credential cannot be safely revoked without it.** Some legacy systems cannot revoke a credential without disabling the account that owns it. Account disable is the nuclear option. It blocks the legitimate user too. Do not do it unless the credential revocation is genuinely impossible.

The order is not a preference. It is a sequence. Get the sequence wrong, and the containment produces the alert the attacker uses to know they have been burned, and the alert is fired before the credential is dead.

## The reach assessment

Once the credential is dead, the question is what it could have done while it was alive. The exercise should have measured this in advance. If it did not, the response team is now measuring it under pressure, which is the worst time to do a join query across the identity graph.

Three joins the response team needs to be able to run, in the first hour, against production data:

- **Credential to identity.** Which identity authenticated with this credential, on what systems, in what time window. Without this, the rest of the joins have no anchor.
- **Identity to resource.** What this identity can normally reach. Which SaaS tenants, which file shares, which crown-jewel systems, which Tier Zero resources. Without this, the response team does not know what the attacker could have read, written, or exported.
- **Identity to time and place.** When this identity normally works, from where, against what. Without this, the response team cannot distinguish a session the user would have started from a session the attacker started.

The purple team exercise that runs a credential scenario without verifying these joins exist and return under an hour has produced a finding about data, not a finding about response. The data work has to be done before the response work can be rehearsed.

## The supplier and the customer

A large share of credential-driven intrusions originate in a supplier, a vendor, or a third-party service that the customer does not control. The help-desk account at the MSP. The OAuth integration at the SaaS vendor. The build dependency at the open-source project. The credential sits in someone else's environment. The exposure lives in yours.

The order of communications matters:

1. **Contain your side first.** Revoke the credential at your IdP. Kill the session in your tenant. Disable the supplier's access path if the supplier's credential cannot be revoked separately. Do this before calling the supplier. The supplier's first action on a phone call is sometimes to log into your environment to "check." You do not want a logged-in session running while you are explaining the situation.
2. **Then call the supplier.** Be specific. Give them the credential, the leak source, the time window. Ask what they have done in response. Do not assume the supplier has MFA enforced on the account. Ask. Document the answer.
3. **Then notify the customer, if the data the credential could reach includes customer data.** A leaked supplier credential that reaches a tenant holding regulated data is a notifiable event in most jurisdictions. The legal team needs the reach assessment before they can advise. The reach assessment comes after step 1, not before.

Most IR playbooks do not cover the order. Most IR playbooks assume the attacker is in your network. Most credential-driven intrusions start in someone else's. The exercise needs to rehearse the supplier path, not just the attacker-in-your-network path.

## What to do after the first hour

The first hour is containment. After the first hour is the longer work.

- **Trace the reach retrospectively.** What did the credential actually do in the time it was valid? Pull the auth logs. Pull the access logs. Pull the export logs. The exercise's reach assessment is the upper bound; the actual reach is what the logs say.
- **Fix the control that made the credential survivable.** MFA on the supplier account. Rotation on the API key. Ownership assignment on the service account. The credential was the symptom. The control gap was the disease. Without the fix, the next credential finds the same gap.
- **Extend the search.** One leaked credential reaches Tier Zero through a missing control. Other leaked credentials will reach Tier Zero through the same control. Run the trace across the surface — same vendor, same leak source, same time window. Do not wait for the next exercise to find them.
- **Rehearse what the playbook did not cover.** Every real incident surfaces a step the playbook did not have. Write it down. The next exercise uses the updated playbook. The playbook improves by being wrong, not by being written.

## What this means for the exercise

The identity-focused purple team exercise is not finished when it produces a real find. It is finished when it has rehearsed the response to a real find under the time pressure of the first hour.

Three things the exercise has to verify before it can claim the response work is done:

1. **The first-decision data exists.** The three checks — live identity, current validity, environment scope — run in under ten minutes against production data. If they do not, the response team is doing the data work during the incident, and the incident is over before the data work is.
2. **The containment moves work in the right order.** Credential revoked first. Session killed second. Device isolated third, if there is a device. Account disabled last. The exercise has to run a real scenario and verify the order, not assume the order from reading the playbook.
3. **The supplier and customer communications have a script.** Who calls the supplier. Who notifies the customer. In what order. With what information. The exercise has to dry-run the call. Most programmes learn the script does not exist when the call is real.

If the exercise cannot verify these three things, the report it produces is a report on what would have been contained if the response work had been done. That is a response report, not a containment report.

## The discipline that earns the next hour

The purple team exercise finds the credential. The response team contains the credential. The two teams meet in the first hour, under pressure, with a playbook that may or may not have been rehearsed.

The work that makes the hour survivable is the work that happens before the hour. The joins are wired up before the exercise. The containment moves are rehearsed in the exercise. The supplier path is dry-run in the exercise. The data is queryable in ten minutes because the data work was done in the last quarter, not because someone is doing it now.

Most programmes skip this work because the work is not visible on a dashboard. Coverage scores move when detections are added. Containment scores do not move. There is no metric for "we did not have to do the data work during the incident." There is only the absence of a quiet failure, which is hard to celebrate and easy to underfund.

The exercise is the place to fund it. Rehearse the response in the exercise. Measure the time. Find the gaps before the attacker finds them. Fix the control that made the credential survivable, not just the credential.

That is what the response side of identity-focused purple teaming is for.

---

This essay is the second in a series on purple teaming in environments where identity is the perimeter. The first was [Purple Teaming Your Identity Environment: Where the Real Attacks Live Now](/essays/purple-teaming-your-identity-environment/). The next will cover the longer tail: how to turn the lessons of one exercise into a quarterly cadence that actually changes the exposure graph, not just the report.
