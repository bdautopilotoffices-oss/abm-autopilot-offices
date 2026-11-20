# The 14-day cadence

This is the sequence from the process diagram, written out as the system
implements it. Day 1 is the day the lead enters the system.

| Day | Touch | Who gets it | Channel | Queue |
|---|---|---|---|---|
| 1 | Connect request, no pitch | everyone with a LinkedIn URL | LinkedIn | `v_abm_due_li_connect` |
| 2 | Intro message | HOT and WARM with a valid +91 mobile | WhatsApp | `v_abm_due_wa_intro` |
| 3 to 5 | First real message | anyone who accepted the invite | LinkedIn | `v_abm_due_li_message` |
| 4 to 6 | Cold call | HOT leads, plus anyone who replied on any channel | phone, human | `v_abm_call_list` |
| 8 | Follow-up one | still no reply | WhatsApp + LinkedIn | `v_abm_due_wa_followup`, `v_abm_due_li_followup` |
| 14 | Final follow-up | still no reply | WhatsApp + LinkedIn | `v_abm_due_wa_final`, `v_abm_due_li_final` |
| 15+ | Stop, park 60 days | still no reply | none | `abm_expire_sequences()` |

## A note on "8 day" versus "14 day"

You said 8-day cadence. Your diagram and your email to Saniel Sir both say 14
days, with a follow-up on day 8 and a final on day 14. I have built the 14-day
version, because that is what is being approved.

If you actually want to compress it to 8 days, it is a one-line change in two
views: change `>= 14` to `>= 8` in `v_abm_due_wa_final` and `v_abm_due_li_final`,
and `> 14` to `> 8` in `v_abm_to_expire`. Say the word.

## Why the days are `>=` and not `=`

If a Make scenario is off for a day, an `=` check would skip that touch
permanently. `>=` means the lead gets it on the next run instead. Nobody falls
through a gap because something was paused.

## What stops a sequence

Any one of these ends it immediately, on every channel at once:

- the lead replies on any channel
- the lead is on the DNC list
- the lead reaches day 15 with no reply
- stage moves to `closed_won`, `closed_lost` or `dnc`

This is the cross-channel stop. It did not exist in the first build, where a
reply on WhatsApp did nothing to the LinkedIn sequence.

## Volume ceiling per lead

Three WhatsApp messages. Four LinkedIn touches. One call. Over 14 days. That
is the whole budget and the views enforce it.

## Scores

| Score | LinkedIn | WhatsApp | Call |
|---|---|---|---|
| HOT | yes | yes | yes, day 4 to 6 |
| WARM | yes | yes | only if they reply |
| COLD | yes | no | only if they reply |

COLD leads get LinkedIn only. That is deliberate: LinkedIn touches are free
and low risk, WhatsApp messages cost money and burn goodwill.
