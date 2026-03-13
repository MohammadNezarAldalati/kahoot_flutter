import 'package:flutter/material.dart';

const int kTimeTilChoiceReveal = 3000; // 3 seconds before choices appear
const int kQuestionAnswerTime = 20000; // 20 seconds to answer

// Vibrant gamification answer button colors
const Color kAnswerRed = Color(0xFFFF1744);
const Color kAnswerBlue = Color(0xFF2979FF);
const Color kAnswerYellow = Color(0xFFFFAB00);
const Color kAnswerGreen = Color(0xFF00E676);

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
