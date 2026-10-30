import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/exercises.dart';
import '../../l10n/l10n.dart';
import '../../models/settings.dart';
import 'break_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.libraryTitle), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          for (final area in BodyArea.values) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text('${area.emoji} ${l.areaLabel(area)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            for (final ex in kExercises.where((e) => e.area == area))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: SvgPicture.asset(ex.frameAssets.first, width: 52, height: 52),
                    title: Text(l.exerciseName(ex.id), style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(l.exerciseSteps(ex.id).first, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text('${ex.seconds}s'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => BreakScreen(exercises: [ex]),
                    )),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
