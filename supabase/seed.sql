-- insert english quiz for GA week
insert into public.quiz_sets
    (id, name, description)
    values ('188f5625-e3e7-4bbb-b7c2-20650b3883c8', '2026 Section G2 Conclave', 'A quiz for the 2026 section conclave');


select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'Who is not a 2026 section officer?'::text,
    "order" => 0,
    choices => array[
      '{"body": "Mark Randall", "is_correct": true}'::json,
      '{"body": "Otto Havens", "is_correct": false}'::json,
      '{"body": "Alex Pintaralli", "is_correct": false}'::json,
      '{"body": "Logan Wenger", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'What is the name of the Section G2 conclave?'::text,
    "order" => 1,
    choices => array[
      '{"body": "Lone Star Fellowship", "is_correct": true}'::json,
      '{"body": "Spring Fellowship", "is_correct": false}'::json,
      '{"body": "Cardinal Conclave", "is_correct": false}'::json,
      '{"body": "Minionclave", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'How many officers does the section have?'::text,
    "order" => 2,
    choices => array[
      '{"body": "6", "is_correct": false}'::json,
      '{"body": "7", "is_correct": false}'::json,
      '{"body": "3", "is_correct": true}'::json,
      '{"body": "9", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'Where is this year\'s conclave located?'::text,
    "order" => 3,
    choices => array[
      '{"body": "Camp Strake (Coldspring, TX)", "is_correct": false}'::json,
      '{"body": "Camp Karankawa (Mathis, TX)", "is_correct": true}'::json,
      '{"body": "Camp Karankawa (Sweeny, TX)", "is_correct": false}'::json,
      '{"body": "University of the Incarnate Word (San Antonio)", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'How many Texas counties are in our section?'::text,
    "order" => 4,
    choices => array[
      '{"body": "102", "is_correct": false}'::json,
      '{"body": "254, "is_correct": false}'::json,
      '{"body": "95", "is_correct": true}'::json,
      '{"body": "67", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'Which conclave activity allows us explore new skills, trades, and hobbies?'::text,
    "order" => 5,
    choices => array[
      '{"body": "SOAP", "is_correct": false}'::json,
      '{"body": "Expo", "is_correct": true}'::json,
      '{"body": "OA Fair", "is_correct": false}'::json,
      '{"body": "Patch Trading", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'How many lodges are in G2?'::text,
    "order" => 6,
    choices => array[
      '{"body": "9", "is_correct": true}'::json,
      '{"body": "24", "is_correct": false}'::json,
      '{"body": "14", "is_correct": false}'::json,
      '{"body": "2", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'What is the most important thing for adults?'::text,
    "order" => 7,
    choices => array[
      '{"body": "A chair", "is_correct": false}'::json,
      '{"body": "Urgent work calls", "is_correct": false}'::json,
      '{"body": "Paperwork", "is_correct": false}'::json,
      '{"body": "Coffee", "is_correct": true}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'What year was the first LSF?'::text,
    "order" => 8,
    choices => array[
      '{"body": "1916", "is_correct": false}'::json,
      '{"body": "2009", "is_correct": true}'::json,
      '{"body": "1984", "is_correct": false}'::json,
      '{"body": "2020", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'What is the theme for this year?'::text,
    "order" => 9,
    choices => array[
      '{"body": "The Legacy Begins", "is_correct": false}'::json,
      '{"body": "Chart Your Course", "is_correct": false}'::json,
      '{"body": "Beyond the Horizon", "is_correct": true}'::json,
      '{"body": "The Power of One", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'Lodges participate in competitions for which award?'::text,
    "order" => 10,
    choices => array[
      '{"body": "The Longhorn Trophy", "is_correct": false}'::json,
      '{"body": "The Golden Arrow", "is_correct": true}'::json,
      '{"body": "The Golden Acorn", "is_correct": false}'::json,
      '{"body": "The Spirit Award", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'What\'s the Saturday night activity and Lone Star Fellowship where lodges bring food and games?'::text,
    "order" => 11,
    choices => array[
      '{"body": "Lodge-A-Palooza", "is_correct": true}'::json,
      '{"body": "Arrow Fest", "is_correct": false}'::json,
      '{"body": "Arrowman Bash", "is_correct": false}'::json,
      '{"body": "Order of the Awesome", "is_correct": false}'::json
    ]
  );
select
  add_question (
    quiz_set_id => '188f5625-e3e7-4bbb-b7c2-20650b3883c8'::uuid,
    body => 'Where will you be on March 27-29th?'::text,
    "order" => 12,
    choices => array[
      '{"body": "Playing Video Games", "is_correct": false}'::json,
      '{"body": "Doing Homework", "is_correct": false}'::json,
      '{"body": "Cleaning My Room", "is_correct": false}'::json,
      '{"body": "Attending Lone Star Fellowship"", "is_correct": true}'::json
    ]
  );