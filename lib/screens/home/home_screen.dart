import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/widgets/phone_time_card.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BloomController, BloomModel>(
      builder: (context, model) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context, model),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(13),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
          child: Image.asset('assets/icon/monochrome.png'),
        ),
      ),
      title: Text("Bloom"),
      centerTitle: true,
      elevation: 3,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Symbols.settings_rounded),
          onPressed: () {
            controller.navigateToSettings();
          },
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 8),
    );
  }

  Widget _buildBody(BuildContext context, BloomModel model) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final card = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child:
            model.isServiceRunning
                ? PhoneTimeCard(model: model)
                : ServiceStateCard(model: model),
      ),
    );

    final icon = LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Symbols.potted_plant_rounded,
                size: 150,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
        );
      },
    );

    if (isLandscape) {
      final viewPadding = MediaQuery.of(context).viewPadding;
      return Padding(
        padding: EdgeInsets.fromLTRB(viewPadding.left, 0, 0, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            16 + viewPadding.bottom,
                          ),
                          child: card,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: icon),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: card,
          ),
          Expanded(child: icon),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      );
    }
  }
}
