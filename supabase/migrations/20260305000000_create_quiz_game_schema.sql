-- ============================================
-- Quiz Game Schema
-- ============================================

-- 1. quiz_sets
create table public.quiz_sets (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  description text
);

-- 2. questions
create table public.questions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  body text not null,
  image_url text,
  "order" int not null,
  quiz_set_id uuid not null references public.quiz_sets(id) on delete cascade
);

-- 3. choices
create table public.choices (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  question_id uuid not null references public.questions(id) on delete cascade,
  body text not null,
  is_correct boolean not null default false
);

-- 4. games
create table public.games (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  current_question_sequence int not null default 0,
  is_answer_revealed boolean not null default false,
  phase text not null default 'lobby',
  quiz_set_id uuid not null references public.quiz_sets(id) on delete cascade,
  host_user_id uuid default auth.uid()
);

-- 5. participants
create table public.participants (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  nickname text not null,
  game_id uuid not null references public.games(id) on delete cascade,
  user_id uuid not null default auth.uid()
);

-- 6. answers
create table public.answers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  participant_id uuid not null references public.participants(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete cascade,
  choice_id uuid references public.choices(id) on delete set null,
  score int not null default 0
);

-- 7. game_results view (aggregates scores per participant)
create view public.game_results
with (security_invoker = true)
as
select
  p.id as participant_id,
  p.nickname,
  coalesce(sum(a.score), 0)::int as total_score,
  p.game_id
from public.participants p
left join public.answers a on a.participant_id = p.id
group by p.id, p.nickname, p.game_id;

-- ============================================
-- Indexes
-- ============================================
create index idx_questions_quiz_set_id on public.questions(quiz_set_id);
create index idx_choices_question_id on public.choices(question_id);
create index idx_games_quiz_set_id on public.games(quiz_set_id);
create index idx_participants_game_id on public.participants(game_id);
create index idx_participants_user_id on public.participants(user_id);
create index idx_answers_participant_id on public.answers(participant_id);
create index idx_answers_question_id on public.answers(question_id);

-- ============================================
-- Enable RLS
-- ============================================
alter table public.quiz_sets enable row level security;
alter table public.questions enable row level security;
alter table public.choices enable row level security;
alter table public.games enable row level security;
alter table public.participants enable row level security;
alter table public.answers enable row level security;

-- ============================================
-- RLS Policies
-- ============================================

-- quiz_sets: anyone authenticated can read
create policy "Anyone can read quiz sets"
  on public.quiz_sets for select
  to authenticated
  using (true);

-- questions: anyone authenticated can read
create policy "Anyone can read questions"
  on public.questions for select
  to authenticated
  using (true);

-- choices: anyone authenticated can read
create policy "Anyone can read choices"
  on public.choices for select
  to authenticated
  using (true);

-- games: anyone authenticated can read
create policy "Anyone can read games"
  on public.games for select
  to authenticated
  using (true);

-- games: anyone authenticated can create
create policy "Anyone can create games"
  on public.games for insert
  to authenticated
  with check (true);

-- games: only host can update their game
create policy "Host can update their game"
  on public.games for update
  to authenticated
  using (host_user_id = auth.uid());

-- participants: anyone authenticated can read
create policy "Anyone can read participants"
  on public.participants for select
  to authenticated
  using (true);

-- participants: anyone authenticated can join (insert)
create policy "Anyone can join a game"
  on public.participants for insert
  to authenticated
  with check (true);

-- answers: anyone authenticated can read
create policy "Anyone can read answers"
  on public.answers for select
  to authenticated
  using (true);

-- answers: anyone authenticated can submit
create policy "Anyone can submit answers"
  on public.answers for insert
  to authenticated
  with check (true);

-- ============================================
-- Enable Realtime for live game tables
-- ============================================
alter publication supabase_realtime add table public.games;
alter publication supabase_realtime add table public.participants;
alter publication supabase_realtime add table public.answers;
