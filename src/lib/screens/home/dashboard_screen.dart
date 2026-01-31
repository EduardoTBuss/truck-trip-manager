// lib/screens/home/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../widgets/stat_card.dart';
import 'driver_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final StorageService _storage = StorageService();
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    final stats = await _storage.getStatistics();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Estatísticas Gerais',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Estatísticas por motorista
          if ((_stats['motoristas'] as Map).isNotEmpty) ...[
            Text(
              'Estatísticas por Motorista',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...(_stats['motoristas'] as Map).entries.map((entry) {
              final motorista = entry.key as String;
              final data = entry.value as Map<String, dynamic>;
              final mediaGeral = (data['litros'] as double) > 0 
                  ? (data['km'] as double) / (data['litros'] as double)
                  : 0.0;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverProfileScreen(
                          motorista: motorista,
                          data: data,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
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
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    motorista,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${data['viagens']} viagens • ${data['fretes']} fretes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMotoristaInfo(
                              Icons.attach_money,
                              'Comissão',
                              'R\$ ${(data['comissao'] as double).toStringAsFixed(2)}',
                              Colors.green,
                            ),
                            _buildMotoristaInfo(
                              Icons.route,
                              'Km Rodados',
                              '${(data['km'] as double).toStringAsFixed(0)} km',
                              Colors.purple,
                            ),
                            _buildMotoristaInfo(
                              Icons.speed,
                              'Média Geral',
                              '${mediaGeral.toStringAsFixed(2)} km/L',
                              Colors.teal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
          
          const SizedBox(height: 20),
          
          // Cards principais em grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            children: [
              StatCard(
                title: 'Total de Viagens',
                value: '${_stats['totalTrips'] ?? 0}',
                icon: Icons.local_shipping,
                color: Colors.blue,
              ),
              StatCard(
                title: 'Total KM',
                value: '${(_stats['totalKm'] ?? 0).toStringAsFixed(0)} km',
                icon: Icons.route,
                color: Colors.purple,
              ),
              StatCard(
                title: 'Receita Total',
                value: 'R\$ ${(_stats['totalRevenue'] ?? 0).toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              StatCard(
                title: 'Despesas Totais',
                value: 'R\$ ${(_stats['totalExpenses'] ?? 0).toStringAsFixed(2)}',
                icon: Icons.money_off,
                color: Colors.orange,
              ),
              StatCard(
                title: 'Comissões Pagas',
                value: 'R\$ ${(_stats['totalCommission'] ?? 0).toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                color: Colors.indigo,
                subtitle: 'Total aos motoristas',
              ),
              StatCard(
                title: 'Média KM/Viagem',
                value: '${(_stats['averageKmPerTrip'] ?? 0).toStringAsFixed(0)} km',
                icon: Icons.analytics,
                color: Colors.teal,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Card de lucro destacado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (_stats['profit'] ?? 0) >= 0
                    ? [Colors.green, Colors.green.withOpacity(0.7)]
                    : [Colors.red, Colors.red.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ((_stats['profit'] ?? 0) >= 0 ? Colors.green : Colors.red)
                      .withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          (_stats['profit'] ?? 0) >= 0 ? 'Lucro Total' : 'Prejuízo Total',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${(_stats['profit'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    (_stats['profit'] ?? 0) >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Consumo médio
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.teal.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_gas_station,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Consumo Médio',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(_stats['averageConsumption'] ?? 0).toStringAsFixed(2)} km/L',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Informações adicionais
          if (_stats['totalTrips'] == 0)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma viagem registrada ainda',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione sua primeira viagem para ver estatísticas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMotoristaInfo(IconData icon, String label, String value, Color color) {
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
}