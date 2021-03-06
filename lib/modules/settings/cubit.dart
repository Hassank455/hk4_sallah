import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hk4_sallah/model/address/address_delete_model.dart';
import 'package:hk4_sallah/model/address/address_model.dart';
import 'package:hk4_sallah/model/user_model.dart';
import 'package:hk4_sallah/modules/settings/profile_information.dart';
import 'package:hk4_sallah/modules/settings/setting.dart';
import 'package:hk4_sallah/modules/settings/setting_state.dart';
import 'package:hk4_sallah/shared/components/constants.dart';
import 'package:hk4_sallah/shared/network/local/salla_States.dart';
import 'package:hk4_sallah/shared/network/remot/dio_helper.dart';
import 'package:image_picker/image_picker.dart';

import 'item_model.dart';

class SettingCubit extends Cubit<SallaStates> {
  SettingCubit() : super(InitialSettingState());

  static SettingCubit get(context) => BlocProvider.of<SettingCubit>(context);

  List<ItemModel> itemExpansion = [
    new ItemModel(
      isExpanded: false,
      title: 'Language',
      body: itemLang(),
    ),
    new ItemModel(
      isExpanded: false,
      title: 'Theme',
      body: itemTheme(),
    ),
    new ItemModel(
      isExpanded: false,
      title: 'Profile Information',
      body: ProfileInformation(),
    ),
  ];

  List<String> dropdownElement = ['Home', 'Work'];
  String? currentElementInDropDown;

  AllAddress? addressGroup;
  AddressUpdateAndDelete? updateDeleteAddress;

  bool? isEditing;

  changeEditState({bool? isEditing}) {
    this.isEditing = isEditing!;
    emit(AddOrEditAddressState());
  }

  void changeExpanded(index, isExpanded) {
    itemExpansion[index].isExpanded = isExpanded;
    emit(ChangeStateExpansionSettingState());
  }

  UserDataLogin? userInfoModel;
  UserModel? userModel;

  void getUserInfo() {
    emit(LoadingSettingState());
    SallaDioHelper.getData(endPointUrl: END_POINT_PROFILE, token: token)
        .then((value) {
      // print(value.data);
      UserModel userModel = UserModel.fromJsonLogin(value.data);
      userInfoModel = userModel.dataLogin;
      // print(userInfoModel.email);
      emit(SuccessSettingState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorSettingState());
    });
  }

  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? image,
  }) {
    emit(LoadingUpdateSettingState());
    SallaDioHelper.putData(
        endPointUrl: END_POINT_UPDATE_PROFILE,
        token: token,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'image': image
        }).then((value) {
      userModel = UserModel.fromJsonLogin(value.data);
      // print(userModel.message);
      emit(SuccessUpdateSettingState());
      getUserInfo();
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateSettingState());
    });
  }

  File? image;
  String? base64;

  Future getImage(ImageSource source) async {
    // restoreImage();
    final src = await ImagePicker().getImage(source: source);
    if (src != null) {
      image = File(src.path);
      encodeImage(src.path);
      print(encodeImage(src.path));
      // decodeImage(src.path);
      emit(SuccessImageSettingState());
    } else {
      emit(ErrorImageSettingState());
    }
  }

  void restoreImage() {
    if (image != null) image = null;
  }

  String encodeImage(String path) {
    final Uint8List image = File(path).readAsBytesSync();
    return base64 = base64Encode(image);
  }

  void decodeImage(String path) {
    final Uint8List decode = base64Decode(encodeImage(path));
    image = File(path)..writeAsBytesSync(decode);
    // print('Fiiiiiiiiiiiiiiiile: ${image.path}');
  }

  void setNewDropdownElement(String newValue) {
    currentElementInDropDown = newValue;
    emit(ChangeAddressTypeState());
  }

  void getCurrentAddressForUser() {
    SallaDioHelper.getData(endPointUrl: END_POINT_EDIT_ADDRESS, token: token)
        .then((value) {
      // print(value.data);
      addressGroup = AllAddress.fromJson(value.data);
      // print(address.data.data.length);
      emit(SuccessGetAddressState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetAddressState());
    });
  }

  void updateCurrentAddressForUser({
    required int id,
    required String addressType,
    required String city,
    required String region,
    required String details,
    required String notes,
    double lat = 14.45454,
    double mag = 12.01212154,
  }) {
    String endPoint = END_POINT_EDIT_ADDRESS + id.toString();
    emit(LoadingUpdateAddressState());
    SallaDioHelper.putData(endPointUrl: endPoint, token: token, data: {
      'name': addressType,
      'city': city,
      'region': region,
      'details': details,
      'notes': notes,
      'latitude': lat,
      'longitude': mag,
    }).then((value) {
      if (value.statusCode == 200) {
        getCurrentAddressForUser();
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateAddressState());
    });
  }

  void deleteUndo({int? index, AllAddressData? address}) {
    addressGroup!.data!.data.insert(index!, address!);
    emit(SuccessDeleteUndoAddressState());
  }

  void deleteAddressForUser({int? id, int? index, AllAddressData? address}) {
    String endPoint = END_POINT_EDIT_ADDRESS + id.toString();
    addressGroup!.data!.data.removeAt(index!);
    emit(LoadingDeleteAddressState());
    SallaDioHelper.deleteData(endPointUrl: endPoint, token: token)
        .then((value) {
      if (value.data != null) {
        updateDeleteAddress = AddressUpdateAndDelete.fromJson(value.data);
        emit(SuccessDeleteAddressState());
      } else {
        deleteUndo(index: index, address: address);
      }
    }).catchError((error) {
      print(error.toString());
      deleteUndo(index: index, address: address);
      emit(ErrorDeleteAddressState());
    });
  }

  void addAddressForUser({
    required String addressType,
    required String city,
    required String region,
    required String details,
    String notes = '',
    double lat = 14.45454,
    double mag = 12.01212154,
  }) {
    emit(LoadingUpdateAddressState());
    SallaDioHelper.postData(
        endPointUrl: END_POINT_ADD_ADDRESS,
        token: token,
        data: {
          'name': addressType,
          'city': city,
          'region': region,
          'details': details,
          'notes': notes,
          'latitude': lat,
          'longitude': mag,
        }).then((value) {
      if (value.statusCode == 200) {
        getCurrentAddressForUser();
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateAddressState());
    });
  }

/* void getCurrentAddressUpdate(int id) {
    String endPoint = END_POINT_ADDRESS + id.toString();
    SallaDioHelper.putData(endPointUrl: endPoint, token: token, data: {})
        .then((value) {
      updateDeleteAddress = AddressUpdateAndDelete.fromJson(value.data);
      emit(SuccessGetAddressState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetAddressState());
    });
  }*/
}
