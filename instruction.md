Cursor prompt

We are building a small, privacy-first iOS app in SwiftUI called “Say It Later”.

This is a mental health–adjacent app, but it is not a therapy or crisis app.
It is a private space for writing things you are not ready to say out loud, then letting them go.

The app must be buildable entirely with Apple-native tools. No backend. No accounts.

⸻

Product intent

Help users release mental pressure by externalising heavy thoughts.

This app is about:
	•	release, not journalling
	•	honesty, not self-improvement
	•	privacy, not tracking

Avoid anything that feels like:
	•	habits
	•	streaks
	•	advice
	•	analysis
	•	AI responses

⸻

Core flow
	1.	App opens
	2.	User writes freely
	3.	User finishes writing
	4.	User reflects briefly
	5.	User chooses what happens to the writing

Everything else is secondary.

⸻

Screens and behaviour

Splash screen
	•	App name
	•	Short line: “A private place to say what you can’t yet”
	•	Auto-advance

⸻

First launch welcome (one time only)
	•	Explain purpose in 1–2 short lines
	•	State privacy clearly: nothing is shared
	•	Primary action: Start writing

No sign-up. No permissions.

⸻

Main writing screen (home)

This is the default and primary screen.

Requirements:
	•	Large text input
	•	Keyboard open immediately
	•	Prompt at top: “What do you need to say right now?”
	•	No history visible here
	•	No distractions

No word count. No formatting. No timestamps while writing.

⸻

Writing completion

When user taps Done:

Before any save or delete, ask:
“How do you feel now?”

Options:
	•	lighter
	•	the same
	•	heavier

Store this result with the entry.

⸻

Post-writing actions

After the feeling is selected, show three options:
	•	Keep for later
	•	Let go
	•	Close

Behaviour:
	•	Let go deletes permanently after a gentle confirmation
	•	Close returns to empty writing screen
	•	Keep for later saves entry and navigates to history

⸻

History screen

Accessible only after saving at least one entry.

Design:
	•	Simple vertical list
	•	Each card shows:
	•	first line preview
	•	date
	•	feeling result

No search. No filters.

⸻

Entry detail screen
	•	Full text
	•	Date
	•	Feeling result

Actions:
	•	Delete
	•	Back

⸻

Safety-aware behaviour (very important)

Detection

On-device detection only.
Use simple keyword or phrase matching for:
	•	suicidal ideation
	•	self-harm intent

Do not analyse severity.
Do not score users.
Do not store extra metadata beyond a boolean flag.

⸻

Safety interruption

If content triggers detection:
	•	Allow writing to finish
	•	Do not block or delete content

After writing, show a calm support screen:
	•	Acknowledge heaviness
	•	Reassure privacy
	•	No advice
	•	No judgement

Actions:
	•	Get support now
	•	Not right now

⸻

Support resources

UK-based:
	•	Samaritans 116 123
	•	NHS 111
	•	Emergency services

Static content only.

⸻

Important rule

If a safety-triggered entry is saved using “Keep for later”:
	•	The history card must include a subtle “Get support” action
	•	This action is always visible when viewing that entry
	•	Do not re-trigger the full interruption flow again

Support should remain one tap away without pressure.

⸻

Privacy and trust
	•	All data stored locally
	•	No analytics
	•	No remote logging
	•	No content leaves the device

Be explicit about this in copy.

⸻

Security
	•	Optional Face ID / passcode lock
	•	Use LocalAuthentication
	•	Store lock preference in Keychain

⸻

Data storage

Use Core Data or SwiftData.

Each entry stores:
	•	id
	•	text
	•	date
	•	feeling result
	•	safety flag (bool)

⸻

Monetisation (£5 one-time)

Use StoreKit.

Paid features:
	•	Face ID lock
	•	Export entries
	•	Reflection view (simple insights like “most entries felt lighter”)

Do not paywall writing or deletion.

⸻

What NOT to build
	•	Accounts or login
	•	Social features
	•	Chat or messaging
	•	Advice or coping strategies
	•	AI-generated responses
	•	Subscriptions

⸻

Architecture
	•	SwiftUI
	•	MVVM
	•	Clear separation between views, models, and logic
	•	Preview-friendly
	•	Clean, readable code

⸻

Deliverables
	•	SwiftUI views for all screens
	•	Local data model
	•	Safety detection logic
	•	Face ID integration
	•	StoreKit setup
	•	Thoughtful empty states

Start by scaffolding:
	•	data models
	•	main writing screen
	•	navigation flow