import 'dart:convert';

import 'package:estacionaqui/app/utils/logger.dart';
import 'package:http/http.dart' as http;

abstract class AddressMapService {
  static Future<Map<String, dynamic>?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'estacionaqui-app/1.0 (your_email@example.com)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          final address = data['address'];

          return {
            "fullAddress": data['display_name'],
            "road": address['road'],
            "city": address['city'],
            "country": address['country'],
            "neighbourhood": address['neighbourhood'],
            "suburb": address['suburb'],
            "postcode": address['postcode'],
            "state": address['state'],
            "house_number": address['house_number'],
            "county": address['county'],
          };
        } else {
          Logger.info('Endereço não encontrado');
          return null;
        }
      } else {
        throw Exception('Falha ao buscar endereço');
      }
    } catch (e) {
      Logger.info(e.toString());
      return null;
    }
  }
}
