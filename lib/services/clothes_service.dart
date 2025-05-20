import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pptm_4/models/clothes_detail_model.dart';

class ClothesApi {
  static const url =
      "https://tpm-api-tugas-872136705893.us-central1.run.app/api/clothes";

  static Future<Map<String, dynamic>> getClothes() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load clothes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clothes: $e');
    }
  }

  static Future<Map<String, dynamic>> getClothesById(int id) async {
    try {
      final response = await http.get(Uri.parse('$url/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load clothes by ID: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clothes by ID: $e');
    }
  }

  static Future<Map<String, dynamic>> addClothes(ClothesDetailData data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add clothes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding clothes: $e');
    }
  }

  static Future<Map<String, dynamic>> editClothes(
    ClothesDetailData data,
    int id,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$url/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": data.name,
          "price": data.price,
          "category": data.category,
          "brand": data.brand,
          "sold": data.sold,
          "rating": data.rating,
          "stock": data.stock,
          "yearReleased": data.yearReleased,
          "material": data.material
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to edit clothes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error editing clothes: $e');
    }
  }

  static Future<void> deleteClothes(String id) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete clothes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting clothes: $e');
    }
  }
}
