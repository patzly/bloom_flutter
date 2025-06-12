import 'package:bloom_flutter/screens/home/state/home_cubit.dart';
import 'package:bloom_flutter/screens/home/state/home_state.dart';
import 'package:bloom_flutter/screens/home/widgets/main_card.dart';
import 'package:bloom_flutter/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(SettingsService()),
      child: Scaffold(
        appBar: AppBar(title: Text("Bloom"), centerTitle: true, elevation: 3),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is HomeLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: MainCard(model: state.data),
          ),
        ),
      );
    }
    return const Center(child: Text('Willkommen bei Bloom'));
  }
}
