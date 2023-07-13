import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/memo_app_bar.dart';
import '../components/normal_button.dart';
import '../start/app_colors.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MemoAppBar(
        onRestart: null,
      ),
      body: Column(
        children: [
          NormalButton(
            text: 'Switch style',
            onTap: () {
              ref.read(ColorMode.provider).switchColorStyle();
              setState(() {
                value = 1;
              });
            },
          ),
          Text(
            'Number of rows of a memory grid',
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.text,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _numberButton(ref, 3),
              _numberButton(ref, 4),
              _numberButton(ref, 5),
              _numberButton(ref, 6),
            ],
          ),
          NormalButton(
              text: 'Licenses', onTap: () => showLicensePage(context: context)),
        ],
      ),
    );
  }

  Widget _numberButton(WidgetRef ref, int size) {
    var isSelected = ref.read(MemoryGridRowSize.provider).rowSize == size;

    return NormalButton(
      text: '$size',
      onTap: () {
        ref.read(MemoryGridRowSize.provider).setRowSize(size);
        setState(() {
          value = 1;
        });
      },
      // TODO backgroundColor: isSelected
      //     ? ref.watch(AppColors.provider).selectedButtonBackgroundColor
      //     : null,
    );
  }
}