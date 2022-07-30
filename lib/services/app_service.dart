import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/account_delete.dart';
import '../model/advert.dart';
import '../model/advert_menu_item.dart';
import '../model/advert_page_view.dart';
import '../model/category.dart';
import '../model/room.dart';
import '../model/message.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../model/image_meta_data.dart';
import '../model/report.dart';
import '../model/room_details.dart';
import '../utils/constants.dart';
import '../utils/page_not_found_exception.dart';

class AppService extends ChangeNotifier {
  Future<void> refreshSession() async {
    if (isAuthenticated() && supabase.auth.currentSession != null) {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
          supabase.auth.currentSession!.expiresAt! * 1000);
      if (expiresAt
          .isBefore(DateTime.now().subtract(const Duration(seconds: 2)))) {
        await supabase.auth.refreshSession();
      }
    }
  }

  Future<List<Category>> getCategories({String? filter}) async {
    await refreshSession();

    final query = supabase.from('category').select('id, name');
    late PostgrestResponse response;
    if (filter == null || filter.isEmpty) {
      response = await query.order('order', ascending: false).execute();
    } else {
      response = await query
          .textSearch('name', "$filter:*")
          .order('order', ascending: false)
          .execute();
    }

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => Category.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load categories');
  }

  Future<List<Category>> getCategoriesForMenu({String? filter}) async {
    await refreshSession();

    final query = supabase.from('categoryview').select('id, name');
    late PostgrestResponse response;
    if (filter == null || filter.isEmpty) {
      response = await query.execute();
    } else {
      response = await query.textSearch('name', "$filter:*").execute();
    }

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => Category.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load categories');
  }

  Future<Category> getCategoryById(String id) async {
    await refreshSession();

    final response = await supabase
        .from('category')
        .select('id, name')
        .eq('id', id)
        .execute();

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return Category.fromJson(response.data[0]);
    }

    throw Exception('Failed to load category');
  }

  Future<List<City>> getCities({String? filter}) async {
    await refreshSession();

    final query =
        supabase.from('city').select('id, name').eq('country_id', 'kz');
    late PostgrestResponse response;

    if (filter == null || filter.isEmpty) {
      response = await query.order('order', ascending: false).execute();
    } else {
      response = await query
          .textSearch('name', "$filter:*")
          .order('order', ascending: false)
          .execute();
    }

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => City.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load cities');
  }

  Future<List<City>> getCitiesForMenu({String? filter}) async {
    await refreshSession();

    final query =
        supabase.from('cityview').select('id, name').eq('country_id', 'kz');
    late PostgrestResponse response;

    if (filter == null || filter.isEmpty) {
      response = await query.execute();
    } else {
      response = await query.textSearch('name', "$filter:*").execute();
    }

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => City.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load cities');
  }

  Future<City> getCityById(String id) async {
    await refreshSession();

    final response =
        await supabase.from('city').select('id, name').eq('id', id).execute();

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return City.fromJson(response.data[0]);
    }

    throw Exception('Failed to load city');
  }

  Future<List<AdvertMenuItem>> getAdvertMenuItems(
      String categoryId, String cityId) async {
    await refreshSession();

    final query = supabase
        .from('advert')
        .select('id, name, description, created_at, created_by')
        .eq('city_id', cityId)
        .eq('category_id', categoryId)
        .eq('enabled', true)
        .order('created_at', ascending: false);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => AdvertMenuItem.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load adverts');
  }

  Future<List<AdvertMenuItem>> getMyAdvertMenuItems(String userId) async {
    await refreshSession();

    final query = supabase
        .from('advert')
        .select()
        .eq('created_by', userId)
        .order('created_at', ascending: false);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => AdvertMenuItem.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load adverts');
  }

  Future<AdvertPageView> getAdvertPageView(String id) async {
    await refreshSession();

    final query = supabase
        .from('advert')
        .select('''*, category ( name ), city ( name )''').eq('id', id);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      if ((response.data as List<dynamic>).isEmpty) {
        throw PageNotFoundException();
      }

      return AdvertPageView.fromJson(response.data[0]);
    }

    throw Exception('Failed to load advert');
  }

  Future<int> getCountByCategory(String categoryId) async {
    await refreshSession();

    final query = supabase
        .from('advert')
        .select('id')
        .eq('category_id', categoryId)
        .eq('enabled', true);

    final PostgrestResponse response =
        await query.execute(count: CountOption.exact);
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    return response.count ?? 0;
  }

  Future<int> getCountByCategoryAndCity(
      String categoryId, String cityId) async {
    await refreshSession();

    final query = supabase
        .from('advert')
        .select('id')
        .eq('category_id', categoryId)
        .eq('city_id', cityId)
        .eq('enabled', true);

    final PostgrestResponse response =
        await query.execute(count: CountOption.exact);
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    return response.count ?? 0;
  }

  Future<PostgrestResponse> createAdvert(Advert model) async {
    await refreshSession();

    final response = supabase.from('advert').insert(model.toMap()).execute();
    return response;
  }

  Future<PostgrestResponse> updateAdvert(Advert model) async {
    await refreshSession();

    final response = supabase
        .from('advert')
        .update(model.toMap())
        .eq('id', model.id)
        .execute();
    return response;
  }

  Future<PostgrestResponse> addImageMetaData(ImageMetaData model) async {
    await refreshSession();

    final response = supabase.from('image').insert(model.toMap()).execute();
    return response;
  }

  Future<PostgrestResponse> setPrimaryImage(ImageMetaData model) async {
    await refreshSession();

    final response = supabase
        .from('image')
        .update(model.toMap())
        .eq('id', model.id)
        .execute();
    return response;
  }

  Future<PostgrestResponse> removeImageMetaData(String id) async {
    await refreshSession();

    final response = supabase.from('image').delete().eq('id', id).execute();
    return response;
  }

  Future<List<ImageMetaData>> _getFileList(
      String advertId, String userId) async {
    await refreshSession();

    final query = supabase
        .from('image')
        .select()
        .eq('advert_id', advertId)
        .eq('created_by', userId)
        .order('primary', ascending: false);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => ImageMetaData.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load images');
  }

  Future<ImageMetaData?> _getMainFile(String advertId, String userId) async {
    await refreshSession();

    final query = supabase
        .from('image')
        .select()
        .eq('advert_id', advertId)
        .eq('created_by', userId)
        .eq('primary', true);

    final PostgrestResponse response = await query.execute();

    if (response.data != null && (response.data as List<dynamic>).isNotEmpty) {
      return ImageMetaData.fromJson(response.data[0]);
    }

    return null;
  }

  Future<Uint8List?> downloadImage(ImageMetaData imageMetaData) async {
    await refreshSession();

    final response = await supabase.storage.from(supabaseImageBucket).download(
        '${imageMetaData.createdBy}/${imageMetaData.advertId}/${imageMetaData.imageName}');

    if (response.data != null) {
      return response.data as Uint8List;
    }

    return null;
  }

  Future<List<ImageData>> getImages(String advertId, String userId) async {
    final List<ImageMetaData> metaData = await _getFileList(advertId, userId);
    final List<ImageData> images = [];

    for (var item in metaData) {
      final image = await downloadImage(item);

      if (image != null) {
        images.add(ImageData.fromMetaData(item, image));
      }
    }

    return images;
  }

  Future<int> getImageCount(String advertId, String userId) async {
    await refreshSession();

    final query = supabase
        .from('image')
        .select()
        .eq('advert_id', advertId)
        .eq('created_by', userId);

    final PostgrestResponse response =
        await query.execute(count: CountOption.exact);

    final error = response.error;

    if (error != null && response.status != 406) {
      return 0;
    }

    return response.count ?? 0;
  }

  Future<Uint8List?> getMainImage(String advertId, String userId) async {
    final file = await _getMainFile(advertId, userId);

    if (file != null) {
      final image = await downloadImage(file);
      return image;
    }

    return null;
  }

  Future<Uint8List?> getIcon(String advertId, String userId) async {
    final image = await downloadImage(ImageMetaData(
      id: '',
      imageName: iconFileName,
      advertId: advertId,
      primary: true,
      createdBy: userId,
    ));
    return image;
  }

  Future<PostgrestResponse> removeAccount(String userId) async {
    await refreshSession();

    final response = supabase
        .from('account_delete')
        .insert(AccountDelete(createdBy: userId).toMap())
        .execute();
    return response;
  }

  Future<GotrueJsonResponse> sendOTPCode(String phone) async {
    return await supabase.auth.api.sendMobileOTP(formatPhoneNumber(phone));
  }

  Future<PostgrestResponse> removeAdvert(
    String userId,
    String advertId,
  ) async {
    await refreshSession();

    final images = await getImages(advertId, userId);

    await supabase.storage.from(supabaseImageBucket).remove(images
        .map((image) =>
            _getStoragePath(image.createdBy, image.advertId, image.imageName))
        .toList());

    await removeImage(userId, advertId, iconFileName);

    final responseFromImage = await supabase
        .from('image')
        .delete()
        .eq('advert_id', advertId)
        .execute();
    if (responseFromImage.error != null) {
      return responseFromImage;
    }

    final response =
        supabase.from('advert').delete().eq('id', advertId).execute();
    return response;
  }

  Future<PostgrestResponse> createReport(Report model) async {
    await refreshSession();

    final response = supabase
        .from('report')
        .insert(model.toMap(), returning: ReturningOption.minimal)
        .execute();
    return response;
  }

  Future<StorageResponse> saveImage(
      String userId, String advertId, String fileName, File file) async {
    await refreshSession();

    final response = await supabase.storage
        .from(supabaseImageBucket)
        .upload(_getStoragePath(userId, advertId, fileName), file);

    return response;
  }

  Future<StorageResponse> saveImageBinary(
      String userId, String advertId, String fileName, Uint8List data) async {
    await refreshSession();

    final response = await supabase.storage
        .from(supabaseImageBucket)
        .uploadBinary(_getStoragePath(userId, advertId, fileName), data);

    return response;
  }

  Future<StorageResponse> removeImage(
      String userId, String advertId, String fileName) async {
    await refreshSession();

    final response = await supabase.storage
        .from(supabaseImageBucket)
        .remove([_getStoragePath(userId, advertId, fileName)]);

    return response;
  }

  String _getStoragePath(String userId, String advertId, String fileName) {
    return '$userId/$advertId/$fileName';
  }

  Future<PostgrestResponse> getRoomByAdvert(
      String advertId, String userId) async {
    await refreshSession();

    final response = supabase
        .from('room')
        .select()
        .eq('advert_id', advertId)
        .eq('user_from', userId)
        .execute();

    return response;
  }

  Future<PostgrestResponse> createRoom(Room model) async {
    await refreshSession();

    final response = supabase.from('room').insert(model.toMap()).execute();
    return response;
  }

  Future<PostgrestResponse> sendMessage(
      Message model, String advertName) async {
    await refreshSession();

    final response =
        await supabase.from('message').insert(model.toMap()).execute();

    // if (response.hasError == false) {
    //   await supabase.rpc(
    //     'send_push_notification',
    //     params: {
    //       'receiver_user_id': model.userTo,
    //       'title': advertName,
    //       'message': model.content,
    //     },
    //   ).execute();
    // }

    return response;
  }

  Stream<List<Message>> getMessages(String? roomId) {
    roomId ??= Uuid.NAMESPACE_NIL;

    return supabase
        .from('message:room_id=eq.$roomId')
        .stream(['id'])
        .order('created_at')
        .execute()
        .map((maps) => maps.map((map) => Message.fromJson(map)).toList());
  }

  Future<List<Room>> getRooms(String userId) async {
    await refreshSession();

    final query = supabase
        .from('room')
        .select()
        .or('user_from.eq.$userId,user_to.eq.$userId')
        .order('created_at', ascending: false);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => Room.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load rooms');
  }

  Future<List<RoomDetails>> getRoomDetails(String userId) async {
    await refreshSession();

    final query = supabase
        .from('message')
        .select('id, room_id, content')
        .or('user_from.eq.$userId,user_to.eq.$userId')
        .order('created_at', ascending: false)
        .limit(1);

    final PostgrestResponse response = await query.execute();
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => RoomDetails.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load rooms');
  }

  Future<PostgrestResponse> markAsRead(String id) async {
    await refreshSession();

    final response = supabase
        .from('message')
        .update({'mark_as_read': true})
        .eq('id', id)
        .execute();
    return response;
  }

  Future<int> getCountUnreadMessagesByRoom(String roomId, String userId) async {
    await refreshSession();

    final query = supabase
        .from('message')
        .select('id')
        .eq('room_id', roomId)
        .eq('user_to', userId)
        .eq('mark_as_read', false);

    final PostgrestResponse response =
        await query.execute(count: CountOption.exact);
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    return response.count ?? 0;
  }

  Future<int> getCountUnreadMessages(String userId) async {
    await refreshSession();

    final query = supabase
        .from('message')
        .select('id')
        .eq('user_to', userId)
        .eq('mark_as_read', false);

    final PostgrestResponse response =
        await query.execute(count: CountOption.exact);
    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    return response.count ?? 0;
  }
}
