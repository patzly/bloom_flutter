import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/widgets/screen_time_card.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      scrolledUnderElevation: 3,
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        IconButton(
          icon: Icon(
            Symbols.settings_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            controller.navigateToSettings();
          },
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 8),
    );
  }

  Widget _buildBody(BuildContext context, BloomModel model) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _buildLandscapeLayout(context, model);
    } else {
      return _buildPortraitLayout(context, model);
    }
  }

  Widget _buildPortraitLayout(BuildContext context, BloomModel model) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildTopCard(context, model),
        ),
        Expanded(child: _buildFlowerImage(context, model)),
        SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, BloomModel model) {
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
                        child: _buildTopCard(context, model),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildFlowerImage(context, model)),
        ],
      ),
    );
  }

  Widget _buildTopCard(BuildContext context, BloomModel model) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child:
            model.isServiceRunning
                ? ScreenTimeCard(model: model)
                : ServiceStateCard(model: model),
      ),
    );
  }

  Widget _buildFlowerImage(BuildContext context, BloomModel model) {
    String assetName = 'assets/flower/flower1.svg';
    if (model.sessionTimeToleranceFraction >= 1 ||
        model.screenTimeFraction >= 1) {
      assetName = 'assets/flower/flower3.svg';
    } else if (model.sessionTimeFraction >= 1 &&
        model.sessionTimeToleranceFraction < 1 &&
        model.screenTimeFraction < 1) {
      assetName = 'assets/flower/flower2.svg';
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SvgPicture.asset(
            assetName,
            semanticsLabel: 'Flower',
            width: 320,
            height: 320,
          ),
        ),
      ),
    );
  }
}
