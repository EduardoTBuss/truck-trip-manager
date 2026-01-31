// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip_model.dart';

class StorageService {
  static const String _tripsKey = 'trips';

  Future<List<TripModel>> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = prefs.getString(_tripsKey) ?? '[]';
    final List<dynamic> tripsList = json.decode(tripsJson);
    return tripsList.map((json) => TripModel.fromJson(json)).toList();
  }

  Future<void> saveTrips(List<TripModel> trips) async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = json.encode(trips.map((t) => t.toJson()).toList());
    await prefs.setString(_tripsKey, tripsJson);
  }

  Future<void> addTrip(TripModel trip) async {
    final trips = await loadTrips();
    trips.add(trip);
    await saveTrips(trips);
  }

  Future<void> deleteTrip(int index) async {
    final trips = await loadTrips();
    trips.removeAt(index);
    await saveTrips(trips);
  }

  // Estatísticas
  Future<Map<String, dynamic>> getStatistics() async {
    final trips = await loadTrips();
    
    if (trips.isEmpty) {
      return {
        'totalTrips': 0,
        'totalKm': 0.0,
        'totalExpenses': 0.0,
        'totalRevenue': 0.0,
        'averageConsumption': 0.0,
        'totalCommission': 0.0,
        'totalProfit': 0.0,
        'averageKmPerTrip': 0.0,
        'motoristas': {},
      };
    }

    double totalKm = 0;
    double totalExpenses = 0;
    double totalRevenue = 0;
    double totalLiters = 0;
    double totalCommission = 0;
    Map<String, Map<String, dynamic>> motoristas = {};

    for (var trip in trips) {
      totalKm += double.tryParse(trip.kmRodados) ?? 0;
      totalExpenses += trip.totalDespesas;
      totalRevenue += trip.totalFretes;
      totalLiters += double.tryParse(trip.litrosAbastecidos) ?? 0;
      
      double commission = double.tryParse(trip.comissaoMotorista) ?? 0;
      totalCommission += commission;
      
      double kmRodados = double.tryParse(trip.kmRodados) ?? 0;
      double litros = double.tryParse(trip.litrosAbastecidos) ?? 0;
      int numFretes = trip.fretes.length;
      
      // Combinação de placas
      String combinacao = '${trip.placaCavalo}+${trip.placaCarreta}';
      
      // Estatísticas por motorista
      if (!motoristas.containsKey(trip.motorista)) {
        motoristas[trip.motorista] = {
          'viagens': 0,
          'comissao': 0.0,
          'km': 0.0,
          'fretes': 0,
          'litros': 0.0,
          'combinacoes': <String, Map<String, dynamic>>{},
        };
      }
      
      motoristas[trip.motorista]!['viagens'] = 
          (motoristas[trip.motorista]!['viagens'] as int) + 1;
      motoristas[trip.motorista]!['comissao'] = 
          (motoristas[trip.motorista]!['comissao'] as double) + commission;
      motoristas[trip.motorista]!['km'] = 
          (motoristas[trip.motorista]!['km'] as double) + kmRodados;
      motoristas[trip.motorista]!['fretes'] = 
          (motoristas[trip.motorista]!['fretes'] as int) + numFretes;
      motoristas[trip.motorista]!['litros'] = 
          (motoristas[trip.motorista]!['litros'] as double) + litros;
      
      // Estatísticas por combinação de veículos
      var combinacoes = motoristas[trip.motorista]!['combinacoes'] as Map<String, Map<String, dynamic>>;
      if (!combinacoes.containsKey(combinacao)) {
        combinacoes[combinacao] = {
          'placaCavalo': trip.placaCavalo,
          'placaCarreta': trip.placaCarreta,
          'viagens': 0,
          'km': 0.0,
          'litros': 0.0,
        };
      }
      
      combinacoes[combinacao]!['viagens'] = (combinacoes[combinacao]!['viagens'] as int) + 1;
      combinacoes[combinacao]!['km'] = (combinacoes[combinacao]!['km'] as double) + kmRodados;
      combinacoes[combinacao]!['litros'] = (combinacoes[combinacao]!['litros'] as double) + litros;
    }

    return {
      'totalTrips': trips.length,
      'totalKm': totalKm,
      'totalExpenses': totalExpenses,
      'totalRevenue': totalRevenue,
      'averageConsumption': totalLiters > 0 ? totalKm / totalLiters : 0,
      'profit': totalRevenue - totalExpenses - totalCommission,
      'totalCommission': totalCommission,
      'totalProfit': totalRevenue - totalExpenses - totalCommission,
      'averageKmPerTrip': trips.isNotEmpty ? totalKm / trips.length : 0,
      'motoristas': motoristas,
    };
  }
}