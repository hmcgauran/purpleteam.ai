---
title: "The 7 Most Pointless Findings in OT Pen Tests"
slug: "seven-pointless-ot-pen-test-findings"
date: 2026-04-30
tags:
  - "OT Security"
  - "Purple Teaming"
  - "ICS"
  - "Pen Testing"
author: Hugh McGauran
excerpt: "If you run enough OT pen tests, you start to notice a pattern. The report arrives, the client is confused, and the findings have a peculiar quality: technically correct, operationally impossible to remediate, and…"
layout: layouts/post.njk
---
If you run enough OT pen tests, you start to notice a pattern. The report arrives, the client is confused, and the findings have a peculiar quality: technically correct, operationally impossible to remediate, and almost entirely beside the point.

The pattern is always the same. An IT security finding gets run through an OT environment without adjusting for the context in which those systems operate. A report full of CVEs follows. The client cannot action half of it. The red team writes the same boilerplate recommendations they would write for a corporate network. The OT engineers roll their eyes and nothing changes.

Here are the seven findings I see most often that tell you more about the assessor's understanding of IT security than they do about the actual risk in the environment.

## 1. Plaintext Protocol

**The finding:** Modbus/TCP is unencrypted. This is a critical finding.

**Why it is the wrong question:** Modbus will never be encrypted. It is a protocol designed in 1979 for serial communication between PLCs and HMIs inside a single control loop. There is no version of replacing it that does not require replacing every device in the loop simultaneously, because the protocol is the interface. You cannot upgrade one end of a Modbus conversation without breaking the other.

**What actually matters:** The attack surface here is not confidentiality — it is proximity. If an adversary is on the same network segment as your Modbus traffic, you have larger problems than encryption. The question is network segmentation: what else is on the segment, and what lateral movement is possible from that position? Focus on whether the Modbus network is appropriately isolated from corporate IT, not whether the protocol uses TLS.

---

## 2. SNMP Default Community String

**The finding:** The SNMP community string is set to the vendor default.

**Why it is the wrong question:** On managed switches inside a properly segmented OT network, the risk from SNMP community strings is minimal. These devices are not exposed to the internet, not reachable from corporate IT without crossing a firewall, and the attack path requires an already-compromised position on the OT network. Changing the community string on a managed switch does not prevent an adversary who has already reached that network segment from doing damage.

**What actually matters:** The question is not whether the community string is default — it is whether the OT network is segmented from IT at the firewall level, and whether there are compensating controls that would detect or prevent an adversary from establishing the initial position required to exploit SNMP. If you have no IT/OT boundary control, that is the finding.

---

## 3. Unsupported Operating System

**The finding:** Windows XP Embedded HMI. Vendor is defunct. Operating system is end of life. Critical risk.

**Why it is the wrong question:** Yes, Windows XP Embedded is end of life. Yes, there are published CVEs. The finding is accurate. The remediation is also not replacing a running HMI that a plant operator spent ten years commissioning and tuning, because the vendor no longer exists and the replacement would require re-commissioning the entire control loop.

**What actually matters:** What is the actual exploitability in this environment? Is the HMI reachable from corporate IT? Is it reachable from the internet? Can it initiate outbound connections? An HMI that is fully air-gapped from everything except the PLC it talks to is a very different risk to one that sits on an IT network with a path to the internet. Tell the client what compensating controls reduce the actual risk — network segmentation, application whitelisting, monitoring — not what they already know they cannot do.

---

## 4. No Timed Account Lock

**The finding:** Workstations do not enforce account lockout after failed login attempts. This is a security misconfiguration.

**Why it is the wrong question:** These are control room workstations. During an emergency — a plant trip, a safety event, a night-shift operator responding to an alarm — the last thing you want is a workstation locking out the operator who is trying to bring a system back to a safe state. Account lockout is a deliberate decision by the plant's safety and operations team, not an oversight.

**What actually matters:** What is the physical access control on these workstations? Are they shared accounts? Is there monitoring on the account usage? Is the network-level access to these workstations controlled? The security concern behind account lockout policies — preventing brute force — can be addressed through network-level controls, proximity to the asset, and monitoring. Do not recommend the removal of a safety control without addressing the underlying concern it was designed to handle.

---

## 5. Deploy EDR

**The finding:** EDR is not deployed on PLCs and field devices.

**Why it is the wrong question:** PLCs run proprietary firmware. You cannot install software on them. There is no operating system that EDR supports. This finding demonstrates that the assessor ran a vulnerability scanner against the asset list without understanding what a PLC is or how it operates. The client will notice this. It undermines the credibility of everything else in the report.

**What actually matters:** EDR on engineering workstations and HMIs is a legitimate finding if it is missing — those are Windows or Linux systems that can run EDR agents. The more relevant question is whether the engineering workstation, if compromised, can reach the PLC and what the adversary can do from that position. That is the actual attack path. EDR on the PLC is not the control; network segmentation and monitoring of the engineering workstation are.

---

## 6. Disable Unnecessary Services

**The finding:** Unnecessary services are running on RTUs. These should be disabled.

**Why it is the wrong question:** RTU firmware is locked by the manufacturer. You cannot disable services on it any more than you can disable services on the firmware of a power supply. The RTU ships with a firmware image. That image is certified against the version of the protocol it implements. Flashing a modified firmware image would void the certification, potentially breach the vendor's support agreement, and in many jurisdictions for critical infrastructure would require re-certification of the entire system.

**What actually matters:** What is the actual threat model for these RTUs? Are they reachable from a compromised engineering workstation? Can they be reached directly across the network? The attack surface on a locked RTU is almost entirely in the hands of whatever can communicate with it — which is usually the control system network, not the RTU itself. Tell the client to focus on who can talk to the RTU and what commands are accepted, not on the services running inside the firmware.

---

## 7. SSH v1 Is Enabled

**The finding:** SSH version 1 is enabled on field devices.

**Why it is the wrong question:** In an ideal world, SSH v1 would not be enabled. SSH v2 has been standard for twenty years. The finding is accurate. The remediation — replacing the firmware on 400 field devices to remove SSH v1 — would cost more than most of these organisations' entire annual security budget, and there is no vendor-provided mechanism to do it on many of these devices.

**What actually matters:** Is SSH the actual attack vector here? An adversary who can reach port 22 on 400 field devices has likely already achieved a position that is more useful to them than exploiting SSH v1. The finding is a proxy. The real finding is: how did an adversary get to the point where they can reach port 22 on 400 field devices? Fix that problem first. The SSH v1 finding is a symptom, not the disease.

---

## The Real Problem: Reports Written for Nessus, Not for OT

The common thread across all seven findings is the same. The assessor applied an IT security framework to an OT environment without adjusting for operational context. The findings are accurate in the abstract. They are useless in practice because the remediation path is either operationally impossible, financially disproportionate, or would introduce greater risk than the original finding.

Good OT pen test reports focus on what an adversary can actually do to the physical process — not on what a vulnerability scanner flags as critical. Flame risers, emergency shutdowns, valve positions, tank levels, process integrity — these are the consequences that matter in an OT environment. A finding that says "an adversary who compromises the engineering workstation can modify setpoints on the HMI and cause a process upset" is worth ten CVE criticals. A finding that says "CVE-2024-XXXX on Windows XP Embedded HMI" tells the client nothing they did not already know and nothing they can act on.

The environments are different. The risks are different. The fixes are not the same.

Write the report your OT client can actually use.

---

*Hugh McGauran has 25 years of experience in cybersecurity and is Country Manager for Ireland at Armis. PurpleTeamAI explores practical purple team methodology for practitioners who need results, not frameworks.*
