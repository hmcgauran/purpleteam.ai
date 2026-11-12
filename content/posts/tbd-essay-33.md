---
title: "The Principals That Never Log In: Service Accounts, API Keys, and Revoking What Nobody Owns"
slug: "the-principals-that-never-log-in"
date: 2026-11-12
tags:
  - "Purple Teaming"
  - "Identity"
  - "Detection Engineering"
  - "Programme Operations"
  - post
author: Hugh Mc Gauran
excerpt: "The last essay ended by promising the next one would cover the principals in the model that never authenticate like a person. This is it: service accounts, API keys and the standing machine credentials that fill a join inventory once you build one, why their count is the least interesting number about them, and what it costs to revoke a credential when the thing it unlocks has no owner."
layout: layouts/post.njk
permalink: /essays/the-principals-that-never-log-in/
---

The last essay in this thread ended by promising the next one would cover the principals in the model that never authenticate like a person. This is that essay. It is about the thing that appears in a join inventory the moment you build one, the thing that quietly outnumbers everything else in it, and the reason that nobody gets to the interesting part of it.

The claim is this. A credential that belongs to a person has a blast radius you can reason about, because a person has a job, a team, a manager and a replacement plan, and the credential inherits all four. A credential that belongs to a machine has none of those things. Its blast radius is whatever the system was told it could do, which was set by an integration someone wrote once, in a window, and never revisited. So when you build the join inventory that the last essay argued for, you do not get a tidy list of principals with owners. You get a list that is mostly machines, most of the machines have no owner, and the ones with no owner are the ones nobody can turn off.

## What a machine principal actually is

A principal is an identity the directory can authenticate. A machine principal is one that authenticates as itself rather than as a person.

In practice that is four kinds of thing, and they behave differently enough to be worth separating. The service account is a directory object with a name that describes a function: `svc-tms-export`, `svc-payroll-feed`. The API key or token is a credential with no directory object at all — a string, a certificate, a bearer token, a shared secret in a configuration file. The workload identity is a machine identity the platform mints: a container's service account, a compute instance's role, a pipeline's token, issued automatically and short-lived by design. The legacy shared account is the one that pretends to be a person: it has a first name, a surname, a mailbox, a password that gets rotated by a person who remembers.

The first three are the modern problem. The fourth is the old one, and it is smaller than it was, and it is the only one most organisations have an existing process for, because a shared account with a password in a vault looks like a user account to every tool that cares about users.

The distinction that matters is not how the credential is stored. It is what happens when it is turned off.

## What the join inventory does to the numbers

This draws on work with mid-sized enterprises and managed-service providers across regulated and unregulated environments — the specifics are composite, because the customers are not the lesson and the pattern is.

Build the joins the last essay described. Join identity to assets, join identity to applications, join credentials to rotation records. Then look at what the identity provider holds when you stop filtering to humans.

The first thing that happens is the shape of the data changes. A typical mid-sized organisation has somewhere between two and five thousand human principals. It also has tens of thousands of machine ones, and they were always there; they were simply not in scope, because every tool that reports on "users" reports on the people. The moment the inventory stops filtering, machine principals outnumber human principals by an order of magnitude, and the dashboard that showed a healthy estate last month now shows something alarming and entirely artificial.

This is where most organisations get the response wrong, and the wrong response is a real position, not a straw one: the number is wrong, so we filter it out, so we go back to reporting on humans. The filter is not wrong as a reporting decision. It is wrong as a conclusion, because the filtered-out set is where the standing privilege lives.

Most service accounts do not have standing privilege. They have *function* privilege — the ability to read one table, write one feed, call one endpoint — and the credential outlives the function. A `svc-tms-export` account created in 2019 to write nightly files to a customer's SFTP server still exists because nobody deleted it, and it still holds the database role that can read every consignment note in the system, because roles are rarely reduced and nobody re-asks what the account needs.

The second thing that happens is the ownership field. Human principals in a mature identity provider have an owner most of the time: a manager, a service desk ticket, a departure process. Machine principals have an owner field too, usually populated with the name of the team that created the credential, and it is accurate at the moment of creation and decays from there. When the person who asked for the service account leaves, the owner field does not clear, because nothing in the identity provider's lifecycle watches machine objects. It keeps asserting, with total confidence, that a team that no longer exists still depends on this credential.

## The case where the count stopped being the point

A freight and logistics group, about 2,400 staff, eleven depots, a legacy transport management system that predates the current management team, a warehouse system, a customer portal and a telematics platform.

Their identity provider held 3,110 human principals and 38,700 machine principals. The inventory they built in the second quarter of the year listed every one of them with a source, a creation date, a last-used date where the platform recorded one, and an owner where the platform held one.

The headline they produced was "38,700 service accounts in production" and it was, in the way those things are, both true and useless. The number that came out of the join with the application registry was different: of the machine principals, 27,400 had no owner at all. That is 71%. The other 11,300 had an owner field, and when the steward worked through the exception queue, they found that 8,900 of those owner fields named teams that had been merged, renamed or stood down.

Then they joined the credential records. Of the 38,700, 14,900 had not authenticated in over eighteen months. Of those, roughly 4,000 still held a role with standing privilege — the ability to read or write across a whole data domain rather than one table.

One of them was `svc-warehouse-export`, held a role that could read every consignment note in the warehouse system including customer addresses and the scanned signatures of drivers, had not authenticated since the week their telematics provider had been replaced, and whose owner field named a depot operations team that had been centralised into a regional role eighteen months earlier. Nobody had noticed, because the credential was in use by an integration that nobody had switched off because nobody knew it existed.

They tried to revoke it in the third quarter. It took nine weeks and four escalations. Not because it was difficult technically — it was one line in a grant script — but because no one could answer the only question that mattered: what breaks if this stops?

The answer existed. It was in the joins. The integration that used it was in the application registry, the application was in the asset registry, and the customer whose files it fed was named in the integration's own configuration. The join inventory could have said, in an afternoon, "this credential serves four customers' overnight feeds, the oldest contract runs to March next year". Instead, nobody had joined the credential to the integration that used it, so the question took nine weeks and four people, and the answer came out of a spreadsheet and an email thread.

The purple team exercise that ran in the fourth quarter found nothing about this. The exercise emulated a credential-driven intrusion using human principals, which is what credential-driven intrusions look like from the inside. `svc-warehouse-export` was never in scope, because scope is built from the people in the model, and the model was still filtering to humans.

## What a machine principal has that a human credential does not

A human credential is bounded by a person, and a person is bounded by an organisation. Machine credentials are bounded by whatever the integration was granted, and integrations are granted generously, once, by someone who was solving a problem that week.

The three asymmetries are worth naming individually.

The first is that privilege decays in opposite directions. When a person leaves, their access is usually reviewed or expires by policy, so the credential's reach shrinks over time even if nobody thinks about it. When an integration stops being used, nothing shrinks. The grant stays at the level it was granted at on the day it was set up, indefinitely, and it is not visible in any human review.

The second is that the owner question has a different answer for a machine. A person's owner is a person, and the honest answer when they leave is "nobody, and here is the ticket". A machine principal's owner is a *purpose*, and the purpose outlives everyone who held it, which is why the owner field decays silently and why every exception queue in this space is full of "service accounts whose owner had left".

The third is that the credential's lifetime is not bounded by any policy that a human would recognise. Nobody sets a password expiry for an API key in a vault. Rotation, where it exists, is triggered by a policy attached to a human account, and machine credentials are attached to no human account, so they are outside the policy by construction. The rotation join in the last essay — credential to rotation record — is where this shows up as an absence rather than as a failure. There is nothing to join to.

## Why revocation is the hard part

The interesting number about a machine principal is not how many there are. It is how many you could safely turn off this afternoon.

That requires an answer to a question that most inventories cannot answer: what does this credential unlock? For a human principal, the answer is a role, and the role is reviewed by a person who knows the work. For a machine principal, the answer is a data flow, and the flow is not written down anywhere except the code that consumes it, and the code is often in a repository that the identity team cannot see, owned by a team that does not consider identity to be their problem.

This is the part where the last essay's argument turns back on itself, and it is worth stating plainly: the joins are what make revocation possible, and the joins are only worth building if they are joined in the direction that supports the decision. A credential-to-rotation join is useful. A credential-to-application join is the one that lets you answer the question, and it is the one that requires the application registry, which is the least-governed of the four registries in most organisations for exactly the reason we are talking about.

There is a version of this problem where you do not need to know what breaks, and it is worth saying what it is and where it stops being the answer. You can revoke by default and repair by exception: turn off everything that has not authenticated in a year, and put back the ones that break. It works, it is fast, and it is how many organisations first attack this problem. It also requires a rollback path and someone willing to be on the other end of it, and it converts an inventory problem into an outage. The version that holds up is the one where the join already knows.

## Where a machine credential actually lives

An exercise that emulates a human credential theft looks for credentials in the places humans keep them: the password manager, the browser, the email account, the laptop. That is the right search for that scenario and it is the wrong search for this one.

Machine credentials live in systems. In a vault, but not usually in the one the organisation reviews — the application's own secret store, a cloud secret manager, an encrypted config file in a repository, a CI variable, a Kubernetes secret, a value in a spreadsheet of integration details passed around by email, a Post-it in a server room, a wiki page from three years ago. Each of these has an owner, a lifecycle and a review cadence, and the credential in it does not, and that gap is where the finding lives.

The purple team's job in this scenario is not to authenticate as the machine. It is to find where the machine's credential is written down, and then to ask the question that the last essay's join inventory exists to answer: who owns it, when did it last change, and what would break if it stopped working.

In the freight group's case, `svc-warehouse-export` was in three places: a deployment pipeline variable in a repository, a config file on a warehouse application server, and a password manager entry created by a contractor two years before the credential was granted its role. Only the third was in a system with a review cycle, and it had been excluded from it by being tagged as a service account, which is the label that means nobody looks at it.

## The three numbers

Three numbers describe whether a machine principal population is managed or merely counted.

The first is the share of machine principals with no owner. Not "no owner field" but no owner: no team, no person, no ticket, no name that resolves to something that still exists. For the freight group, 71%. An organisation with a machine principal population in the single digits as a percentage of its total is rare, and an organisation whose unowned machine principals are in the single digits as a percentage of their machine principals is rarer, and those are the two numbers worth having on a wall.

The second is the age of the oldest unrotated credential that still holds standing privilege. Not the oldest credential — old credentials with function privilege are cheap, and function privilege that outlives the function is untidy rather than dangerous. The number that matters is the oldest one whose reach is a whole domain, because that is the one that turns a tidiness problem into an incident. At the freight group it was three years and two months, and it was the same credential.

The third is the share of machine principals whose revocation blast radius is known, which is to say: for how many of them can you say what stops working if you turn it off today. This is the only one of the three that measures the joins rather than the estate, and it is the one that moves when you put someone in the job. For the freight group it was 11% before the steward started and 46% after two quarters of clearing exceptions, and the movement came almost entirely from the application registry join rather than from the identity work.

## The discipline that makes the machine principals countable

The last essay argued that the exercise is where you find out whether the joins are good enough, and not where the joins get fixed. That holds here with a sharper edge. The exercise that emulates a human credential theft will never tell you whether your machine principals are managed, because the machine principals are not in scope and the scope is built from the model, and the model is what you have to fix.

So the machine principal population has to be brought into the model on purpose, which means it has to be joined on purpose, and joining it on purpose means joining it to the application registry — the registry nobody bought a tool for — and to the rotation record, which for machine principals is mostly an absence. That work is unglamorous, it is the same work as the last essay's, and it is the only thing that makes the question "what breaks if this stops" answerable by anyone other than the person who built the integration.

The credential you cannot revoke is the one that survives every exercise. Revocation needs an owner, and ownership is the thing the join inventory was for.

---

This essay continues the identity thread — [Purple Teaming Your Identity Environment](/essays/purple-teaming-your-identity-environment/), [Containing a Credential-Driven Intrusion](/essays/containing-a-credential-driven-intrusion/), [Purple Teaming a PCI Environment](/essays/purple-teaming-a-pci-environment/), [Quarterly Cadence](/essays/quarterly-identity-purple-team-cadence/), [The Joins Nobody Owns](/essays/the-joins-nobody-owns/) — and delivers the thread's promised next piece: the principals in the model that never authenticate like a person. The next essay in this thread will cover the detection side of the same population: what a purple team can actually emulate when there is nobody to impersonate, and the difference between a credential that is monitored and a credential that is merely present.
