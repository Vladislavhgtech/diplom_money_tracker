import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/login_event.dart';
import '../blocs/events/profile_event.dart';
import '../blocs/bloc/login_bloc.dart';
import '../blocs/bloc/profile_bloc.dart';
import '../blocs/states/profile_state.dart';
import '../styles/colors.dart';
import '../styles/consts.dart';
import 'loading_indicator.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, required this.isSave, required this.isLoading, required this.imageFile}) : super(key: key);

  final bool isSave;
  final bool isLoading;
  final String imageFile;

  FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  ScrollController controller = ScrollController(initialScrollOffset: 0);

  Future<void> _setImage(ProfileState state, BuildContext context) async {
    _displayPickImageDialog(state, context);
  }

  void _setImageFromFile(XFile? value, ProfileState state, BuildContext context) {
    String newImageFile = value == null ? '' : <XFile>[value][0].path;
    BlocProvider.of<ProfileBloc>(context).add(
        ProfileRequested(state.isSave, state.isLoading, newImageFile)
    );
    if (newImageFile != auth.currentUser!.photoURL && newImageFile.isNotEmpty) {
      BlocProvider.of<ProfileBloc>(context).add(
          ProfileRequested(true, false, newImageFile)
      );
    }
  }

  void _setImageFromStandardIcon(String path, ProfileState state, BuildContext context) {
    BlocProvider.of<ProfileBloc>(context).add(
        ProfileRequested(state.isSave, state.isLoading, path)
    );
    if (path != auth.currentUser!.photoURL) {
      BlocProvider.of<ProfileBloc>(context).add(
          ProfileRequested(true, false, path)
      );
    }
  }

  Future<void> _saveImage(ProfileState state, BuildContext context) async {
    BlocProvider.of<ProfileBloc>(context).add(
        ProfileRequested(false, true, state.imageFile)
    );
  }

  Future<void> _checkSave(String imageFile) async {
    auth.currentUser!.updatePhotoURL(imageFile);
  }

  Future<void> _displayPickImageDialog(ProfileState state, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Откуда выбрать изображение?')),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Стандартные иконки'),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      final manifestJson = await DefaultAssetBundle.of(context)
                          .loadString('AssetManifest.json');
                      final images = json.decode(manifestJson).keys;
                      List<String> listImages = [];
                      for (var item in images) {
                        if (item.startsWith(pathStandardIcons)) {
                          listImages.add(item);
                        }
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width - 50,
                                width: MediaQuery.of(context).size.width - 50,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  scrollDirection: Axis.vertical,
                                  children: <Widget>[
                                    ...listImages
                                        .map((item) => ListTile(
                                              title: Image.asset(item),
                                              // ),
                                              onTap: () {
                                                _setImageFromStandardIcon(item, state, context);
                                                Navigator.of(context).pop();
                                              },
                                            ))
                                        .toList(),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                TextButton(
                    child: const Text('Галерея'),
                    onPressed: () async {
                      try {
                        final XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery);
                        _setImageFromFile(pickedFile, state, context);
                      } catch (e) {}
                      Navigator.of(context).pop();
                    },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Профиль'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _setImage(state, context),
                      child: (state.imageFile.isEmpty &&
                          auth.currentUser!.photoURL == null)
                          ? CircleAvatar(
                        backgroundColor: customColorGrey,
                        radius: 40,
                        child: Icon(Icons.photo_camera,
                            size: 30, color: Colors.grey[500]),
                      )
                          : imageWidget(state.imageFile),
                    ),
                    const SizedBox(
                      height: 13,
                    ),

                    if (state.isLoading)
                      FutureBuilder(
                        future: _checkSave(state.imageFile),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const SizedBox.shrink();
                          }
                          else {
                            return const LoadingIndicator();
                          }
                        },
                      ),

                    if (state.isSave)
                      GestureDetector(
                        onTap: () => _saveImage(state, context),
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: customColorViolet,
                          ),
                        ),
                      ),

                    if (!state.isLoading && !state.isSave)
                      const SizedBox.shrink(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.currentUser!.email!,
                      style: const TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context).add(SignOutRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(145.0, 50.0),
                        primary: customColorViolet,
                        onPrimary: customColorWhite,
                        textStyle: const TextStyle(fontSize: 17),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget imageWidget(String imageFile) {
    ImageProvider imageProvider;
    String path = imageFile.isEmpty ? (auth.currentUser!.photoURL ?? '') : imageFile;
    if (path.startsWith(pathStandardIcons)) {
      imageProvider = AssetImage(imageFile.isNotEmpty
          ? imageFile
          : (auth.currentUser!.photoURL ?? ''));
    } else {
      imageProvider = FileImage(File(imageFile.isNotEmpty
          ? imageFile
          : (auth.currentUser!.photoURL ?? '')));
    }

    return CircleAvatar(
      backgroundColor: customColorWhite,
      backgroundImage: imageProvider,
      radius: 40,
    );
  }
}
