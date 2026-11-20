# Known issues and things to verify

Read this before trusting the system in production.

## 1. Scenario 2 is named day 8 but fires on day 6

The scenario is called "Day 8 WhatsApp follow-up" and its internal filter is
named "Intro sent 6 or more days ago", but the condition is
`parseDate(O) <= now - 6 days`. So the follow-up actually goes out on day 6,
not day 8. Decide which you want and make the name and the condition agree.

## 2. The reply webhook assumes a field named `phone`

Scenario 3 matches on `{{1.phone}}`, meaning it expects AiSensy to post a JSON
body with a top level `phone` field. This has not been tested against a real
AiSensy webhook delivery. If replies are not landing in column Q, run the
webhook in Make, send one real WhatsApp reply, and check what AiSensy actually
posts, then fix the field reference.

## 3. Phone numbers need a country code

AiSensy fails silently on a bare 10 digit number. Column C must hold
`91XXXXXXXXXX`. Claude formats on load. Hand typed rows do not get formatted.

## 4. Reply matching is a substring match

Scenario 3 matches column C with `text:contain` against the caller's number.
If two leads share a number, or one number is a substring of another, the wrong
row gets stamped. Low risk, worth knowing.

## 5. Scenario 1 reads A1:T1, the others read A1:Z1

Functionally fine today, since the sheet is 20 columns wide. If columns are ever
added past T, scenario 1 will not see them while the others will.

## 6. Oppora has two connections and one is dead

One of the two configured Oppora MCP connections returns "invalid, revoked or
expired API key". Only the working one should be used. Regenerate or remove the
dead one.

## 7. The NotebookLM MCP server cannot run in a cloud session

It is configured with a local path on a Mac
(`/Users/lohitaksha/.local/share/...`), so it fails to start anywhere else.
The repo rule in `.claude/rules/mcp-memory.md` on the main project mandates a
NotebookLM query at session start, and that rule cannot be satisfied from a
cloud session.
