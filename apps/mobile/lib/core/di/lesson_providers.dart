import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';

/// Filter applied when dashboard Lessons petal is tapped (§6).
class LessonFilter {
  const LessonFilter({
    required this.mode,
    required this.stage,
  });

  final KuttiompMode mode;
  final MasteryStage stage;

  static const LessonFilter defaultFilter = LessonFilter(
    mode: KuttiompMode.littleOnes,
    stage: MasteryStage.awakening,
  );
}

final lessonsRepositoryProvider = Provider<LessonsRepository>((ref) {
  return LessonsRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final lessonFilterProvider = StateProvider<LessonFilter>(
  (ref) => LessonFilter.defaultFilter,
);

final lessonListProvider = FutureProvider<List<LessonModel>>((ref) async {
  final filter = ref.watch(lessonFilterProvider);
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? filter.mode;
  return ref.watch(lessonsRepositoryProvider).watchLessonsForTier(
        mode.tierBitmask,
        stage: filter.stage.id,
      );
});

final lessonDetailProvider = FutureProvider.family<LessonModel, String>((ref, id) async {
  return ref.watch(lessonsRepositoryProvider).getContent(id);
});