import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/home/widgets/phone_time_card.dart';
import 'package:bloom_flutter/screens/home/widgets/service_card.dart';
import 'package:bloom_flutter/services/foreground/foreground_service.dart';
import 'package:bloom_flutter/services/foreground/foreground_service_default_impl.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child:
                model.isServiceRunning
                    ? PhoneTimeCard(model: model)
                    : ServiceCard(model: model),
          ),
        ),
      ),
    );
  }
}
