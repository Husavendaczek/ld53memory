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
              _numberButton(ref, context, 3),
              _numberButton(ref, context, 4),
              _numberButton(ref, context, 5),
              _numberButton(ref, context, 6),
            ],
          ),
          NormalButton(
            text: 'Switch style to colored or monochrome',
            onTap: () {
              ref.read(AppColorMode.provider).switchColorStyle();
              setState(() {
                value = 1;
              });
            },
          ),
          NormalButton(
              text: 'Licenses', onTap: () => showLicensePage(context: context)),
        ],
      ),
    );
  }

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
      backgroundColor: isSelected ? Theme.of(context).cardColor : null,
    );
  }
}
