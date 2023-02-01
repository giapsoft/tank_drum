import 'package:g_entities/entities.dart';
import 'package:g_utils/utils.dart';

part '_generated/silence_node._.dart';

@Entity_(fields: [
  F_<int>('start'),
  F_<int>('duration'),
  F_<String>('text'),
])
class SilenceNode extends SilenceNode$Auto {
  static SilenceNode? parseCsv(String e) {
    final parts = e.split('\t');
    if (parts.length > 3) {
      if (!parts[0].startsWith('Name')) {
        final vocal = parts[0].startsWith('t:') ? parts[0].split('t:')[1] : '';
        final start = DateTimeUt.parseMillisecond(parts[1]);
        final duration = DateTimeUt.parseMillisecond(parts[2]);
        return SilenceNode()
          ..set(duration: duration, start: start, text: vocal);
      }
    }
    return null;
  }

  @override
  void addDefaultFields() {}
}

extension SilenceNode$RemoteListExt on RemoteListField<SilenceNode> {}

extension SilenceNode$RefExt on RefField<SilenceNode> {}

extension SilenceNode$ListExt on List<SilenceNode> {}

extension SilenceNode$FutureExt on Future<SilenceNode?> {}

extension SilenceNode$FutureListExt on Future<List<SilenceNode>> {}
