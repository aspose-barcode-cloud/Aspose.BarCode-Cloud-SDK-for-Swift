# Repository Instructions

- Do not use Perl in repository scripts or automation. Use Python for text processing, credential insertion, and log sanitizing.
- Do not auto-load `.env` files from scripts. Test and snippet credentials should come from `Tests/configuration.json` or from already exported environment variables such as `TEST_CONFIGURATION_ACCESS_TOKEN`, `TEST_CONFIGURATION_CLIENT_ID`, and `TEST_CONFIGURATION_CLIENT_SECRET`.
