import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/account_delete.dart';
import '../model/advert.dart';
import '../model/advert_menu_item.dart';
import '../model/advert_page_view.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/image_data.dart';
import '../model/image_meta_data.dart';
import '../model/report.dart';
import '../utils/constants.dart';

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
      return AdvertPageView.fromJson(response.data[0]);
    }

    throw Exception('Failed to load adverts');
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

  Future<PostgrestResponse> removeImage(String id) async {
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

  Future<Uint8List?> _downloadImage(ImageMetaData imageMetaData) async {
    await refreshSession();

    final response = await supabase.storage.from('public-images').download(
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
      final image = await _downloadImage(item);

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
      final image = await _downloadImage(file);
      return image;
    }

    return null;
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

  Future<PostgrestResponse> removeAdvert(String id) async {
    await refreshSession();

    final responseFromImage =
        await supabase.from('image').delete().eq('advert_id', id).execute();
    if (responseFromImage.error != null) {
      return responseFromImage;
    }

    final response = supabase.from('advert').delete().eq('id', id).execute();
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
}
