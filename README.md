# Tidal

## Test account (local development)

- Email: `tidal.hackathon.test@gmail.com`
- This account exists only in the local development database, not on the deployed app. Its password isn't stored here; if you don't have it, use "Forgot password" on the sign-in screen and read the reset code from the server logs (locally, codes are printed there instead of emailed).

## Serverpod version

This project is pinned to **Serverpod 4.0.0** (the CLI and every `pubspec.yaml`). Everyone working on it should use the same CLI version. A different version regenerates `tidal_server/test/integration/test_tools/serverpod_test_tools.dart` differently, and the server tests stop loading.

The `serverpod` command here comes from **App Studio**, so `serverpod upgrade` won't upgrade it (it would install a separate copy). To upgrade, use App Studio, and upgrade the CLI and all `pubspec.yaml` versions together.
