# BrainHub

A real-time multiplayer quiz game built with Flutter and Supabase — think Kahoot, but open source. A host creates a game from a quiz set, players join via a link or QR code, and everyone answers questions in real time with live leaderboards.

## Features

- **Host dashboard** — create and manage quiz games
- **Player experience** — join via link/QR code, answer timed questions
- **Real-time sync** — live participant list, answer tracking, and leaderboards powered by Supabase Realtime
- **Admin panel** — full CRUD for quiz sets, questions, games, participants, and answers
- **platform** — runs on Web.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK `^3.11.0`)
- [Supabase](https://supabase.com/) (free tier works)

## Setup

### 1. Clone the repository

### 2. Create a Supabase project

1. Go to [supabase.com](https://supabase.com/) and create a new project.
2. Note your **Project URL** and **anon (public) key** from **Settings > API**.

### 3. Apply the database schema

Run the migration to create all required tables, views, indexes, and RLS policies.

**Option A — Supabase Dashboard:**
1. Open the **SQL Editor** in your Supabase dashboard.
2. Paste the contents of `supabase/migrations/20260305000000_create_quiz_game_schema.sql` and run it.

**Option B — Supabase CLI (local dev):**
```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

### 4. Enable Supabase Auth

1. In your Supabase dashboard, go to **Authentication > Providers**.
2. Enable **Email** sign-in (used for host/admin login).
3. Enable **Anonymous sign-ins** under **Authentication > Settings** (used for players joining games without an account).

### 5. Run the app

Pass your Supabase credentials as compile-time environment variables:

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=<your-supabase-url> \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key> \
  --dart-define=APP_NAME=<your-app-name>
```

## How It Works

1. **Host** logs in and selects a quiz set to start a game.
2. **Players** navigate to `/game/<game-id>` (or scan the QR code) and enter a nickname — no account needed.
3. The host advances through questions. Each question has a countdown timer, and players pick from multiple-choice answers.
4. Scores are calculated based on correctness and speed. A live leaderboard updates after each question.
5. At the end, final results are displayed for everyone.


## License

This project is open source. See [LICENSE](LICENSE) for details.

#
#
