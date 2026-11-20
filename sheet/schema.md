# ABM Leads Master, column schema

Sheet `1v_PegL5zdNzUNMQ8vLzqoQQiAk8oEy7VbKXtMiE_Qqo`, tab `Untitled`,
header row `A1:T1`.

Make refers to columns by zero based index, so column A is `0` and column T is
`19`. That mapping is what the blueprints use.

| Col | Index | Name | Written by |
|---|---|---|---|
| A | 0 | First_Name | scenario 0 |
| B | 1 | Last_Name | scenario 0 |
| C | 2 | Phone | scenario 0 |
| D | 3 | Email | scenario 0 |
| E | 4 | Company | scenario 0 |
| F | 5 | Designation | scenario 0 |
| G | 6 | Company_Location | scenario 0 |
| H | 7 | Employees | scenario 0 |
| I | 8 | LinkedIn_URL | scenario 0 |
| J | 9 | Score | scenario 0 |
| K | 10 | Why_Now | scenario 0 |
| L | 11 | Call_Opener | scenario 0 |
| M | 12 | Notes | scenario 0 |
| N | 13 | WA_Status | scenario 1 |
| O | 14 | WA_Sent_Date | scenario 1 |
| P | 15 | FollowUp_Status | scenario 2 |
| Q | 16 | Replied | scenario 3 |
| R | 17 | Campaign | scenario 0 |
| S | 18 | Target_Office | scenario 0 |
| T | 19 | Added_On | scenario 0 |

Scenario 0 never touches N through Q, so the status columns are owned entirely
by the sending and reply scenarios. That separation is what lets several
campaigns share one sheet.

## Score values

`HOT`, `WARM`, `COLD`. Only HOT and WARM are messaged.

## Date format

`DD/MM/YYYY` throughout, written with `formatDate(now; "DD/MM/YYYY")`.
Scenario 2 reads it back with `parseDate`, so the format must not change.
