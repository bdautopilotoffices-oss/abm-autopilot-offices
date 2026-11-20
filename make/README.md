# Make scenarios

Six scenarios. Make holds no cadence logic: it reads a Supabase view, sends,
and reports back. All the rules live in the database.

## Import

For each JSON here: Make, Create a new scenario, three dots, Import Blueprint.

Then find and replace three placeholders in every imported scenario:

| Placeholder | Replace with | Where to get it |
|---|---|---|
| `__SUPABASE_URL__` | `https://xxxx.supabase.co` | Supabase, Project Settings, API |
| `__SUPABASE_SERVICE_ROLE_KEY__` | the `service_role` key | same page. **Never put this in chat or in git.** |
| `__AISENSY_API_KEY__` | your AiSensy key | AiSensy, Manage, API Key |
| `__MAKE_HOOK_ID__` | the webhook id | created when you add the webhook in scenario 4 |

## What each one does

| File | Scenario | Runs | Reads | Then |
|---|---|---|---|---|
| `scenario-0-intake.json` | ABM 0, intake | on demand, called by Claude | nothing | `abm_intake()` |
| `scenario-1-wa-intro.json` | ABM 1, Day 2 intro | hourly | `v_abm_due_wa_intro` | AiSensy `abm_intro_v1`, then `abm_mark_sent('wa_intro')` |
| `scenario-2-wa-followup.json` | ABM 2, Day 6 follow-up | daily 11:00 | `v_abm_due_wa_followup` | AiSensy `abm_followup_v1`, then mark |
| `scenario-3-wa-final.json` | ABM 3, Day 8 final | daily 11:30 | `v_abm_due_wa_final` | AiSensy `abm_final_v1`, then mark |
| `scenario-4-replies.json` | ABM 4, replies | on webhook | AiSensy payload | `abm_record_reply()` |
| `scenario-5-housekeeping.json` | ABM 5, housekeeping | daily 02:00 | nothing | `abm_expire_sequences()` |

## The old scenarios

The four sheet-based scenarios in the Make account (7120707, 7108734, 7108740,
7108746) are superseded by these. Leave them switched OFF, or delete them once
these are running. Do not run both: they would double-message.

## Scenario 4 needs checking against a real payload

`abm_record_reply` is called with `{{1.phone}}` and `{{1.text}}`. Those field
names are a guess at what AiSensy posts. Before going live, run the webhook in
Make, send one real WhatsApp reply, look at what actually arrives, and fix the
two field references if they differ. This is the single most likely thing to
be wrong on first run.

## Operations cost

Roughly 4 operations per lead per touch. A 50-lead batch over 8 days is about
600 to 700 operations.
