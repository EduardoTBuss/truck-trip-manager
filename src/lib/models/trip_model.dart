// lib/models/trip_model.dart
class TripModel {
  final String motorista;
  final String placaCavalo;
  final String placaCarreta;
  final String numeroViagem;
  final String dataSaida;
  final String dataChegada;
  final String litrosAbastecidos;
  final String kmSaida;
  final String kmChegada;
  final String kmRodados;
  final String mediaConsumo;
  final List<Frete> fretes;
  final Despesas despesas;
  final String dinheiroProxViagem;
  final String freteRecebido;
  final String comissaoMotorista;

  TripModel({
    required this.motorista,
    required this.placaCavalo,
    required this.placaCarreta,
    required this.numeroViagem,
    required this.dataSaida,
    required this.dataChegada,
    required this.litrosAbastecidos,
    required this.kmSaida,
    required this.kmChegada,
    required this.kmRodados,
    required this.mediaConsumo,
    required this.fretes,
    required this.despesas,
    required this.dinheiroProxViagem,
    required this.freteRecebido,
    required this.comissaoMotorista,
  });

  Map<String, dynamic> toJson() {
    return {
      'motorista': motorista,
      'placaCavalo': placaCavalo,
      'placaCarreta': placaCarreta,
      'numeroViagem': numeroViagem,
      'dataSaida': dataSaida,
      'dataChegada': dataChegada,
      'litrosAbastecidos': litrosAbastecidos,
      'kmSaida': kmSaida,
      'kmChegada': kmChegada,
      'kmRodados': kmRodados,
      'mediaConsumo': mediaConsumo,
      'fretes': fretes.map((f) => f.toJson()).toList(),
      'despesas': despesas.toJson(),
      'dinheiroProxViagem': dinheiroProxViagem,
      'freteRecebido': freteRecebido,
      'comissaoMotorista': comissaoMotorista,
    };
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      motorista: json['motorista'] ?? '',
      placaCavalo: json['placaCavalo'] ?? '',
      placaCarreta: json['placaCarreta'] ?? '',
      numeroViagem: json['numeroViagem'] ?? '',
      dataSaida: json['dataSaida'] ?? '',
      dataChegada: json['dataChegada'] ?? '',
      litrosAbastecidos: json['litrosAbastecidos'] ?? '',
      kmSaida: json['kmSaida'] ?? '',
      kmChegada: json['kmChegada'] ?? '',
      kmRodados: json['kmRodados'] ?? '',
      mediaConsumo: json['mediaConsumo'] ?? '',
      fretes: (json['fretes'] as List? ?? [])
          .map((f) => Frete.fromJson(f))
          .toList(),
      despesas: Despesas.fromJson(json['despesas'] ?? {}),
      dinheiroProxViagem: json['dinheiroProxViagem'] ?? '0',
      freteRecebido: json['freteRecebido'] ?? '0',
      comissaoMotorista: json['comissaoMotorista'] ?? '0',
    );
  }

  double get totalDespesas {
    return despesas.diesel +
        despesas.pedagios +
        despesas.estacionamento +
        despesas.borracheiro +
        despesas.mecanico +
        despesas.diversos;
  }

  double get totalFretes {
    return fretes.fold(0.0, (sum, f) => sum + f.valor);
  }

  double get saldoViagem {
    return double.parse(freteRecebido) -
        double.parse(comissaoMotorista) -
        totalDespesas;
  }
}

class Frete {
  final String origem;
  final String destino;
  final double valor;
  final String obs;

  Frete({
    required this.origem,
    required this.destino,
    required this.valor,
    required this.obs,
  });

  Map<String, dynamic> toJson() {
    return {
      'origem': origem,
      'destino': destino,
      'valor': valor.toString(),
      'obs': obs,
    };
  }

  factory Frete.fromJson(Map<String, dynamic> json) {
    return Frete(
      origem: json['origem'] ?? '',
      destino: json['destino'] ?? '',
      valor: double.tryParse(json['valor'].toString()) ?? 0.0,
      obs: json['obs'] ?? '',
    );
  }
}

class Despesas {
  final double diesel;
  final double pedagios;
  final double estacionamento;
  final double borracheiro;
  final double mecanico;
  final double diversos;

  Despesas({
    required this.diesel,
    required this.pedagios,
    required this.estacionamento,
    required this.borracheiro,
    required this.mecanico,
    required this.diversos,
  });

  Map<String, dynamic> toJson() {
    return {
      'diesel': diesel.toString(),
      'pedagios': pedagios.toString(),
      'estacionamento': estacionamento.toString(),
      'borracheiro': borracheiro.toString(),
      'mecanico': mecanico.toString(),
      'diversos': diversos.toString(),
    };
  }

  factory Despesas.fromJson(Map<String, dynamic> json) {
    return Despesas(
      diesel: double.tryParse(json['diesel']?.toString() ?? '0') ?? 0.0,
      pedagios: double.tryParse(json['pedagios']?.toString() ?? '0') ?? 0.0,
      estacionamento:
          double.tryParse(json['estacionamento']?.toString() ?? '0') ?? 0.0,
      borracheiro:
          double.tryParse(json['borracheiro']?.toString() ?? '0') ?? 0.0,
      mecanico: double.tryParse(json['mecanico']?.toString() ?? '0') ?? 0.0,
      diversos: double.tryParse(json['diversos']?.toString() ?? '0') ?? 0.0,
    );
  }
}