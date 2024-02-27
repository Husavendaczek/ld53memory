import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/buttons/normal_icon_btn.dart';
import 'package:memoryfun/src/sound/sound_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/app_bar/memo_app_bar.dart';
import '../components/buttons/normal_button.dart';
import '../utils/theme/app_color_mode.dart';
import '../game_type/memory_grid_row_size.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int value = 0;
  bool isMusicOn = true;
  bool isSoundEffectsOn = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      isMusicOn = ref.read(SoundPlayer.provider).isMusicOn;
      isSoundEffectsOn = ref.read(SoundPlayer.provider).isSoundEffectsOn;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const MemoryAppBar(
          onRestart: null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.settings_music,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    NormalIconBtn(
                      icon: isMusicOn ? Icons.headset : Icons.headset_off,
                      onTap: () {
                        ref.read(SoundPlayer.provider).turnMusicOn(!isMusicOn);
                        setState(() {
                          isMusicOn = !isMusicOn;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.settings_sound,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    NormalIconBtn(
                      icon:
                          isSoundEffectsOn ? Icons.headset : Icons.headset_off,
                      onTap: () {
                        ref
                            .read(SoundPlayer.provider)
                            .turnSoundEffectsOn(!isSoundEffectsOn);
                        setState(() {
                          isSoundEffectsOn = !isSoundEffectsOn;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Text(
                AppLocalizations.of(context)!.settings_card_amount,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _numberButton(ref, context, 3),
                  _numberButton(ref, context, 4),
                  _numberButton(ref, context, 5),
                  _numberButton(ref, context, 6),
                ],
              ),
              //TODO add switch for light and dark mode
              NormalButton(
                text: AppLocalizations.of(context)!.settings_switch_color_style,
                onTap: () {
                  ref.read(AppColorMode.provider).switchColorStyle();
                  setState(() {
                    value = 1;
                  });
                },
              ),
              NormalButton(
                text: AppLocalizations.of(context)!.settings_licenses,
                onTap: () => showLicensePage(context: context),
              ),
              Text(AppLocalizations.of(context)!.settings_music_ref)
            ],
          ),
        ),
      );

  Widget _numberButton(WidgetRef ref, BuildContext context, int size) {
    var isSelected = ref.read(MemoryGridRowSize.provider).rowSize == size;

    return NormalButton(
      text: '$size',
      onTap: () {
        ref.read(MemoryGridRowSize.provider).setRowSize(size);
        setState(() {
          value = 1;
        });
      },
      backgroundColor: isSelected ? Theme.of(context).canvasColor : null,
    );
  }
}
