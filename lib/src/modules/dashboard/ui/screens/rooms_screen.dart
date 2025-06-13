import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rooms),
      ),
      body: BlocProvider(
        create: (context) => DashboardBloc()..add(GetRoomsEvent()),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is GetRoomsLoading) {
              return const CustomLoadingWidget();
            } else if (state is GetRoomsError) {
              return Center(
                child: CustomErrorWidget(exception: state.exception),
              );
            } else if (state is GetRoomsSuccess) {
              if (state.rooms.isEmpty) {
                return const NoDataWidget();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.rooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final room = state.rooms[index];
                  return RoomCard(
                    room: room,
                    onDelete: () {
                      context
                          .read<DashboardBloc>()
                          .add(DeleteRoomEvent(room.id));
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final _formKey = GlobalKey<FormState>();
              String? name;
              String? description;
              return AlertDialog(
                title: Text(S.of(context).addRoom),
                content: BlocProvider(
                  create: (context) => DashboardBloc.get(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: S.of(context).roomName),
                          validator: (value) => value == null || value.isEmpty
                              ? S.of(context).requiredField
                              : null,
                          onSaved: (value) => name = value,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: S.of(context).roomDescription),
                          onSaved: (value) => description = value,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(S.of(context).cancel),
                  ),
                  BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
                      if (state is AddRoomSuccess) {
                        Navigator.of(context).pop();
                        context.read<DashboardBloc>().add(GetRoomsEvent());
                      }
                    },
                    builder: (context, state) {
                      if (state is AddRoomLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context.read<DashboardBloc>().add(
                                  AddRoomEvent(Room(
                                    name: name!,
                                    description: description ?? "",
                                    devicesIds: [],
                                    id: "",
                                  )),
                                );
                          }
                        },
                        child: Text(S.of(context).add),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
