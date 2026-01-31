// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../models/trip_model.dart';
import '../../services/storage_service.dart';
import '../../services/pdf_service.dart';
import '../../widgets/trip_card.dart';
import '../trip/add_trip_screen.dart';
import '../settings_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  
  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  final PDFService _pdfService = PDFService();
  List<TripModel> _trips = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    final trips = await _storage.loadTrips();
    setState(() {
      _trips = trips;
      _isLoading = false;
    });
  }

  Future<void> _addTrip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTripScreen(),
      ),
    );
    
    if (result != null && result is TripModel) {
      await _storage.addTrip(result);
      _loadTrips();
      _showSuccessMessage('Viagem adicionada com sucesso!');
    }
  }

  Future<void> _deleteTrip(int index) async {
    await _storage.deleteTrip(index);
    _loadTrips();
    _showSuccessMessage('Viagem excluída com sucesso!');
  }

  Future<void> _generatePDF(TripModel trip) async {
    try {
      await _pdfService.generatePDF(trip);
      _showSuccessMessage('PDF gerado com sucesso!');
    } catch (e) {
      _showErrorMessage('Erro ao gerar PDF: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(toggleTheme: widget.toggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Minhas Viagens' : 'Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildTripsView() : const DashboardScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) _loadTrips(); // Atualiza stats ao trocar
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list),
            label: 'Viagens',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _addTrip,
              icon: const Icon(Icons.add),
              label: const Text('Nova Viagem'),
            )
          : null,
    );
  }

  Widget _buildTripsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Nenhuma viagem registrada',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Clique no botão abaixo para adicionar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          return TripCard(
            trip: trip,
            onTap: () {
              // Pode adicionar detalhes da viagem aqui
            },
            onDelete: () => _deleteTrip(index),
            onGeneratePDF: () => _generatePDF(trip),
          );
        },
      ),
    );
  }
}