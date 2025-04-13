import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import 'package:tarsheed/src/core/utils/image_manager.dart';
import 'package:tarsheed/src/modules/settings/cubit/settings_cubit.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    context.read<SettingsCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).profile),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsErrorState) {
            return Center(
              child: Text(
                'Profile has an issue',
                style: TextStyle(color: Colors.red, fontSize: 18.sp),
              ),
            );
          }

          if (state is GetProfileLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GetProfileSuccessState) {
            User user = state.user;

            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _emailController.text = user.email;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundImage: AssetImage(AssetsManager.avatar),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildTextField(
                        S.of(context).firstName, _firstNameController, false),
                    buildTextField(
                        S.of(context).lastName, _lastNameController, false),
                    buildTextField(
                        S.of(context).email, _emailController, false),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        User updatedUser = user.copyWith(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                        );
                        context
                            .read<SettingsCubit>()
                            .updateProfile(updatedUser);
                      },
                      child: Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
          SizedBox(height: 5.h),
          TextField(
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2666DE)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.blue, width: 1.5.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
