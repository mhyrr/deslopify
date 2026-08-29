# Rate limiter

The limiter uses a token bucket per API key. Each bucket holds 100 tokens and
refills at 10 per second. A request costs one token; when the bucket is empty
the request gets a 429 with a `Retry-After` header.

Buckets live in Redis under `rl:{key}`, with a 60-second TTL so idle keys expire
on their own. The refill is computed on read rather than by a background job:
we store the last-seen timestamp and the token count, then derive the current
count when the key is next touched. This costs one round trip and means there is
no sweeper to operate.

Two things it does not do. It does not coordinate across regions, so a client
hitting two regions gets double budget — we accepted that when we scoped it to
per-region fairness rather than global quota. And it does not distinguish
expensive endpoints from cheap ones. Both are tracked in issue 412.

To change the limits, edit `config/limits.exs` and deploy. There is no runtime
override. A limit you can change without a deploy is a limit that no one can
audit later.
