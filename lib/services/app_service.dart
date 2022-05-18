import 'package:aqniyet/model/category.dart';
import 'package:aqniyet/model/phonecode.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/advert.dart';
import '../model/city.dart';
import '../utils/constants.dart';

class AppService extends ChangeNotifier {
  Future<List<Category>> getCategory(String? filter) async {
    final query = supabase.from('category').select('id, name');

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

  Future<List<City>> getCity(String? filter) async {
    final query =
        supabase.from('city').select('id, name').eq('country_id', 'kz');

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

  Future<List<PhoneCode>> getPhoneCode(String? filter) async {
    final query = supabase.from('phonecode_view').select();

    late PostgrestResponse response;

    if (filter == null || filter.isEmpty) {
      response = await query.execute();
    } else {
      response = await query.textSearch('countryname', "$filter:*").execute();
    }

    final error = response.error;

    if (error != null && response.status != 406) {
      throw Exception(error.message);
    }

    if (response.data != null) {
      return (response.data as List<dynamic>)
          .map((json) => PhoneCode.fromJson(json))
          .toList();
    }

    throw Exception('Failed to load phone codes');
  }

  Future<PostgrestResponse> createAdvert(Advert model) {
    final response = supabase.from('advert').insert(model.toMap()).execute();
    return response;
  }
}
