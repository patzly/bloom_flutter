import 'package:bloom_flutter/screens/home/controller/home_controller.dart';
import 'package:bloom_flutter/screens/home/controller/home_controller_impl.dart';
import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:bloom_flutter/screens/home/widgets/phone_time_card.dart';
import 'package:bloom_flutter/screens/home/widgets/service_card.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service_impl.dart';
import 'package:bloom_flutter/services/navigation/navigation_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PhoneTimeService _phoneTimeService = PhoneTimeServiceImpl.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneTimeService.init((Object data) {
        if (data is Map<String, dynamic>) {
          final timestampMillis = data["timestampMillis"];
          if (timestampMillis != null) {
            final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
              timestampMillis as int,
              isUtc: true,
            );
            print('timestamp: ${timestamp.toString()}');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _phoneTimeService.dispose();
  }

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
        padding: const EdgeInsets.all(14),
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
          child: model.isServiceRunning
              ? PhoneTimeCard(model: model)
              : ServiceCard(model: model,),
        ),
      ),
    );
  }
}