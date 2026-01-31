// lib/screens/home/driver_profile_screen.dart
import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  final String motorista;
  final Map<String, dynamic> data;

  const DriverProfileScreen({
    Key? key,
    required this.motorista,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viagens = data['viagens'] as int;
    final comissao = data['comissao'] as double;
    final km = data['km'] as double;
    final fretes = data['fretes'] as int;
    final litros = data['litros'] as double;
    final mediaGeral = litros > 0 ? km / litros : 0.0;
    final combinacoes = data['combinacoes'] as Map<String, Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: Text(motorista),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header com avatar e nome
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  motorista,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$viagens viagens realizadas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Cards de estatísticas gerais
          const Text(
            'Estatísticas Gerais',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: [
              _buildStatCard(
                'Comissão Total',
                'R\$ ${comissao.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
              ),
              _buildStatCard(
                'KM Rodados',
                '${km.toStringAsFixed(0)} km',
                Icons.route,
                Colors.purple,
              ),
              _buildStatCard(
                'Total de Fretes',
                '$fretes fretes',
                Icons.description,
                Colors.orange,
              ),
              _buildStatCard(
                'Média Geral',
                '${mediaGeral.toStringAsFixed(2)} km/L',
                Icons.speed,
                Colors.teal,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Combinações de veículos
          Row(
            children: [
              const Text(
                'Combinações de Veículos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${combinacoes.length} combinações',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (combinacoes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Nenhuma combinação registrada',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ...combinacoes.entries.map((entry) {
              final comb = entry.value;
              final viagensComb = comb['viagens'] as int;
              final kmComb = comb['km'] as double;
              final litrosComb = comb['litros'] as double;
              final mediaComb = litrosComb > 0 ? kmComb / litrosComb : 0.0;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_shipping,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        comb['placaCavalo'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.add, size: 16),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        comb['placaCarreta'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$viagensComb viagens com esta combinação',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCombInfo(
                              Icons.speed,
                              'Média',
                              '${mediaComb.toStringAsFixed(2)} km/L',
                              _getMediaColor(mediaComb, mediaGeral),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            _buildCombInfo(
                              Icons.route,
                              'KM Total',
                              '${kmComb.toStringAsFixed(0)} km',
                              Colors.purple,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            _buildCombInfo(
                              Icons.local_gas_station,
                              'Litros',
                              '${litrosComb.toStringAsFixed(0)} L',
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                      if (mediaComb != mediaGeral) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              mediaComb > mediaGeral
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 16,
                              color: mediaComb > mediaGeral
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${((mediaComb - mediaGeral) / mediaGeral * 100).toStringAsFixed(1)}% ${mediaComb > mediaGeral ? 'acima' : 'abaixo'} da média geral',
                              style: TextStyle(
                                fontSize: 12,
                                color: mediaComb > mediaGeral
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCombInfo(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getMediaColor(double media, double mediaGeral) {
    if (media > mediaGeral * 1.1) return Colors.green;
    if (media < mediaGeral * 0.9) return Colors.red;
    return Colors.orange;
  }
}