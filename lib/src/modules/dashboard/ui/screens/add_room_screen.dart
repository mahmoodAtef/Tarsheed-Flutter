import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addRoom),
        actions: [
          BlocConsumer<DashboardBloc, DashboardState>(
            listenWhen: (context, state) =>
                state is AddRoomSuccess || state is AddRoomError,
            listener: (context, state) {
              if (state is AddRoomSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).roomAddedSuccessfully ??
                        'Room added successfully'),
                  ),
                );
              } else if (state is AddRoomError) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: _saveRoom,
                child: Text(
                  S.of(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).roomDetails ?? 'Room Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: S.of(context).roomName,
                          prefixIcon: const Icon(Icons.meeting_room),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? S.of(context).requiredField
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: S.of(context).roomDescription,
                          prefixIcon: const Icon(Icons.description),
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocProvider.value(
                value: DashboardBloc.get(),
                child: BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    if (state is AddRoomSuccess) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).roomAddedSuccessfully ??
                              'Room added successfully'),
                        ),
                      );
                    } else if (state is AddRoomError) {
                      ExceptionManager.showMessage(state.exception);
                    }
                  },
                  buildWhen: (current, previous) =>
                      current is AddRoomLoading || current is AddRoomSuccess,
                  builder: (context, state) {
                    return DefaultButton(
                      title: S.of(context).save,
                      onPressed: _saveRoom,
                      isLoading: state is AddRoomLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRoom() {
    if (_formKey.currentState!.validate()) {
      DashboardBloc.get().add(
        AddRoomEvent(
          Room(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            devicesIds: [],
            id: "",
          ),
        ),
      );
    }
  }
}
