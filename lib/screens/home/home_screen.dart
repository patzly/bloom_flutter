import 'package:bloom_flutter/screens/home/controller/home_controller.dart';
import 'package:bloom_flutter/screens/home/controller/home_controller_impl.dart';
import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:bloom_flutter/screens/home/widgets/main_card.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeController>(
      create:
          (BuildContext context) => HomeControllerImpl(
            navigationService: NavigationServiceImpl(context),
          ),
      child: BlocBuilder<HomeController, HomeModel>(
        builder: (BuildContext context, HomeModel model) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, model),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final controller = BlocProvider.of<HomeController>(context);
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(12),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurfaceVariant,
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
          icon: const Icon(Icons.settings),
          onPressed: () {
            controller.navigateToSettings();
          },
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 8),
    );
  }

  Widget _buildBody(BuildContext context, HomeModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: MainCard(model: model),
        ),
      ),
    );
  }
}
