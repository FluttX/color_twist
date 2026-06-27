import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/features/missions/presentation/cubit/missions_cubit.dart';
import 'package:color_twist/features/missions/presentation/cubit/missions_state.dart';
import 'package:color_twist/features/missions/presentation/widgets/mission_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MissionsCubit(
        retentionEngine: AppServices.instance.retentionEngine,
      ),
      child: const _MissionsView(),
    );
  }
}

class _MissionsView extends StatelessWidget {
  const _MissionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missions'),
        backgroundColor: const Color(0xFF0C0C18),
      ),
      backgroundColor: const Color(0xFF0C0C18),
      body: BlocBuilder<MissionsCubit, MissionsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.missions.length,
            itemBuilder: (context, index) {
              final mission = state.missions[index];
              final progress = state.progressById[mission.id];
              if (progress == null) return const SizedBox.shrink();

              return MissionTile(
                mission: mission,
                progress: progress,
              );
            },
          );
        },
      ),
    );
  }
}
