import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/saved_rides_bloc/saved_rides_bloc.dart';

class SavedRidesPage extends StatefulWidget {
  const SavedRidesPage({super.key});

  @override
  State<SavedRidesPage> createState() => _SavedRidesPageState();
}

class _SavedRidesPageState extends State<SavedRidesPage> {
  @override
  void initState() {
    context.read<SavedRidesBloc>().add(const GetRidesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved rides'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<SavedRidesBloc, SavedRidesState>(
        builder: (context, state) {
          if (state is SavedRidesLoaded) {
            if (state.rides.isEmpty) {
              return const Center(child: Text('No booked rides'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.rides.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Origin: ${state.rides[index].originString}'),
                          Text(
                            'Destination: ${state.rides[index].destinationString}',
                          ),
                          Text(
                            'Date and Time: ${DateFormat('yyyy-MM-dd – hh:mm a').format(state.rides[index].dateTime)}',
                          ),
                          Text(
                            'Passengers count: ${state.rides[index].passengersCount}',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
