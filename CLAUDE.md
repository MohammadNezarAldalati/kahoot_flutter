# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter web app — a Kahoot-style real-time multiplayer quiz game backed by Supabase (auth, database, realtime). Web-only target.

## Commands

```bash
# Run (web only — pass Supabase config as compile-time vars)
flutter run -d chrome \
  --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_ANON_KEY=<key> \
  --dart-define=APP_NAME=<name>

# Lint
flutter analyze

# Test
flutter test

# Build for release
flutter build web --release

# Apply database schema (via Supabase CLI)
supabase link --project-ref <ref>
supabase db push
```

## Architecture

**State management:** Flutter Riverpod (`FutureProvider`, `StreamProvider.family`, `AsyncNotifier`).

**Routing:** GoRouter with auth redirect guards in `lib/router.dart`. Host routes (`/host/*`) require email login. Admin routes (`/host/admin/*`) require `authNotifier.isAdmin`. Player routes (`/game/:id`) are public (anonymous auth).

**Data flow:** UI (ConsumerWidget) → Riverpod providers → Repositories → Supabase. Real-time updates flow back via Supabase stream subscriptions through `StreamProvider`.

**Auth:** Three tiers — admin (password + rate limiting via RPC), host (email magic link OTP), player (anonymous signup).

## Code Layout

```
lib/
├── main.dart              # Supabase init, ProviderScope
├── app.dart               # MaterialApp.router
├── router.dart            # GoRouter config + auth guards
├── constants.dart         # Timing & color constants
├── core/                  # Theme, auth notifier, Supabase client provider
├── providers/             # Riverpod providers (one file per feature area)
├── repositories/          # Data layer (Quiz, Game, Participant, Answer, GameResults)
├── models/                # Plain Dart classes with fromJson/toJson (no Freezed)
├── features/
│   ├── auth/              # Login screen (email suggestions, magic links)
│   ├── host/              # Host dashboard, game control screen
│   ├── player/            # Player join/answer flow
│   ├── admin/             # CRUD screens for quiz sets, questions, games
│   └── shared/            # Common widgets (leaderboard, QR, timer)
```

Database migration: `supabase/migrations/20260305000000_create_quiz_game_schema.sql`

## Conventions

- Screens extend `ConsumerWidget` or `ConsumerStatefulWidget`
- Models use `const` constructors and factory `fromJson` — no code generation
- Repositories take `SupabaseClient` via constructor
- UI handles async state with Riverpod's `.when()` pattern on `AsyncValue`
- Dark theme defined in `core/theme.dart` (Material 3, purple/orange accent)
- No `.env` files — all config via `--dart-define` flags
- Web-specific APIs (e.g., localStorage for email history) use the `web` package
