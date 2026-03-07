import 'package:flutter/material.dart';

const int kTimeTilChoiceReveal = 3000; // 3 seconds before choices appear
const int kQuestionAnswerTime = 20000; // 20 seconds to answer

// Kahoot-style answer button colors
const Color kAnswerRed = Color(0xFFE21B3C);
const Color kAnswerBlue = Color(0xFF1368CE);
const Color kAnswerYellow = Color(0xFFFFA602);
const Color kAnswerGreen = Color(0xFF26890C);

const List<Color> kAnswerColors = [
  kAnswerRed,
  kAnswerBlue,
  kAnswerYellow,
  kAnswerGreen,
];

const appName = String.fromEnvironment(
  'APP_NAME',
  defaultValue: 'Kahoot Flutter',
);
