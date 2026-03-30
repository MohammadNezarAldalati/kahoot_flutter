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

# Run a single test file
flutter test test/<file>_test.dart

# Build for release
flutter build web --release

# Apply database schema (via Supabase CLI)
supabase link --project-ref <ref>
supabase db push
```

## Architecture

**State management:** Flutter Riverpod. Static data uses `FutureProvider` (quiz sets, questions). Real-time data uses `StreamProvider.family` keyed by ID (game state, participants, answers). Game control logic lives in `AsyncNotifier` subclasses (`HostGameController`, `GameInitializationController` in `providers/game_providers.dart`).

**Routing:** GoRouter with auth redirect guards in `lib/router.dart`. The `authNotifier` is a **global singleton** (not a Riverpod provider) — a `ChangeNotifier` that listens to Supabase auth state changes and determines admin status via the `check_login_type` RPC. Host routes (`/host/*`) require email login. Admin routes (`/host/admin/*`) require `authNotifier.isAdmin`. Player routes (`/game/:id`) are public (anonymous auth).

**Data flow:** UI (`ConsumerWidget`) → Riverpod providers → Repositories → Supabase. Real-time updates flow back via Supabase `.stream(primaryKey:)` subscriptions through `StreamProvider`.

**Game lifecycle:** A game has three phases: `lobby` → `quiz` → `result`. The host advances the phase. Within `quiz`, the host cycles through questions by incrementing `current_question_sequence` and toggling `is_answer_revealed`. When creating a new game, old finished games for the same quiz set are deleted to prevent stale answer data.

**Auth:** Three tiers — admin (password login, detected via `check_login_type` RPC), host (email magic link OTP), player (anonymous signup). Admin status is checked on every auth state change.

## Code Layout

```
lib/
├── main.dart              # Supabase init, ProviderScope
├── app.dart               # MaterialApp.router
├── router.dart            # GoRouter config + auth guards + global AuthNotifier
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
- Repositories take `SupabaseClient` via constructor (provided through `supabaseClientProvider`)
- Provider wiring: each provider file creates repository providers, then data providers that depend on them
- UI handles async state with Riverpod's `.when()` pattern on `AsyncValue`
- Dark theme defined in `core/theme.dart` (Material 3, purple/orange accent)
- No `.env` files — all config via `--dart-define` flags
- Web-specific APIs (e.g., localStorage for email history) use the `web` package
