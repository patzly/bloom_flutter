import 'package:bloom_flutter/screens/home/bloc/home_bloc.dart';
import 'package:bloom_flutter/screens/home/event/home_event.dart';
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
      create: (_) => HomeBloc(SettingsService())..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(
            title: Text("Bloom"),
            centerTitle: true,
            elevation: 3
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: MainCard(model: state.data),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('Willkommen bei Bloom'));
          },
        ),
      ),
    );
  }
}