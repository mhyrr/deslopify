# Release notes

The importer handles 4,000 rows per second. Configure it with `IMPORT_BATCH=500`.
Results are posted to https://example.com/status.

We measured the new parser against the old one on the Acme dataset, and the design
earns its place: 2x faster.
