# n8n + Postgres patterns

Three small, generic n8n workflows for patterns I use constantly when running automations in production. They are examples I wrote from scratch, with no client data or credentials.

| Workflow | Pattern |
|---|---|
| `01-webhook-upsert` | Receive a webhook, validate input, upsert into Postgres. Safe to retry: the same payload twice gives one row. |
| `02-incremental-sync-watermark` | Every 15 minutes, fetch only records changed since the last run, upsert them in one batch, then move the watermark. |
| `03-error-alert` | Error workflow that posts the failing workflow, node and error to Slack. |

## Why these patterns

- **Idempotent writes.** Webhooks and schedules get retried. `INSERT ... ON CONFLICT DO UPDATE` makes a retry harmless.
- **Watermark, not full reload.** The sync reads `max(last_synced_at)`, asks the API only for newer records, and advances the watermark after the batch is written. Less load, faster runs, and a failed run simply retries from the old watermark.
- **Parameterized queries.** Values go through query replacement, never string-concatenated into SQL.
- **One batch statement.** `jsonb_to_recordset` writes all fetched rows in a single round trip.
- **Failures are loud.** Every production workflow should point at an error workflow like #3.

## Use it

1. Run `schema.sql` on a Postgres database.
2. In n8n, import each file from `workflows/`.
3. Attach your own Postgres credential to the Postgres nodes, and replace the example API URL and Slack webhook URL.

## Notes

- Built for n8n 1.x/2.x. Node versions may need a bump on very old instances.
- Credentials are intentionally not included. Nothing in these files is secret.

Dioni Riesco · [LinkedIn](https://www.linkedin.com/in/driescov/)
