// lib/screens/trip/add_trip_screen.dart
import 'package:flutter/material.dart';
import '../../models/trip_model.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _motoristaController = TextEditingController();
  final _placaCavaloController = TextEditingController();
  final _placaCarretaController = TextEditingController();
  
  final _numeroViagemController = TextEditingController();
  final _dataSaidaController = TextEditingController();
  final _dataChegadaController = TextEditingController();
  final _litrosAbastecidosController = TextEditingController();
  
  final _kmSaidaController = TextEditingController();
  final _kmChegadaController = TextEditingController();
  final _kmRodadosController = TextEditingController();
  final _mediaConsumoController = TextEditingController();
  
  List<Map<String, TextEditingController>> _fretes = [
    {
      'origem': TextEditingController(),
      'destino': TextEditingController(),
      'valor': TextEditingController(),
      'obs': TextEditingController(),
    }
  ];
  
  final _dieselController = TextEditingController(text: '0');
  final _pedagiosController = TextEditingController(text: '0');
  final _estacionamentoController = TextEditingController(text: '0');
  final _borrachiroController = TextEditingController(text: '0');
  final _mecanicoController = TextEditingController(text: '0');
  final _diversosController = TextEditingController(text: '0');
  
  final _dinheiroProxViagemController = TextEditingController(text: '0');
  final _freteRecebidoController = TextEditingController(text: '0');
  final _comissaoMotoristaController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _dataSaidaController.text = _formatDate(DateTime.now());
    _dataChegadaController.text = _formatDate(DateTime.now());
    
    _kmSaidaController.addListener(_calcularKmRodados);
    _kmChegadaController.addListener(_calcularKmRodados);
    
    _kmRodadosController.addListener(_calcularMedia);
    _litrosAbastecidosController.addListener(_calcularMedia);
  }

  void _calcularKmRodados() {
    if (_kmSaidaController.text.isNotEmpty && _kmChegadaController.text.isNotEmpty) {
      try {
        double kmSaida = double.parse(_kmSaidaController.text);
        double kmChegada = double.parse(_kmChegadaController.text);
        _kmRodadosController.text = (kmChegada - kmSaida).toStringAsFixed(0);
      } catch (e) {}
    }
  }

  void _calcularMedia() {
    if (_kmRodadosController.text.isNotEmpty && _litrosAbastecidosController.text.isNotEmpty) {
      try {
        double km = double.parse(_kmRodadosController.text);
        double litros = double.parse(_litrosAbastecidosController.text);
        if (litros > 0) {
          _mediaConsumoController.text = (km / litros).toStringAsFixed(2);
        }
      } catch (e) {}
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (date != null) {
      controller.text = _formatDate(date);
    }
  }

  void _addFrete() {
    setState(() {
      _fretes.add({
        'origem': TextEditingController(),
        'destino': TextEditingController(),
        'valor': TextEditingController(),
        'obs': TextEditingController(),
      });
    });
  }

  void _removeFrete(int index) {
    setState(() {
      _fretes.removeAt(index);
    });
  }

  void _saveTrip() {
    if (_formKey.currentState!.validate()) {
      List<Frete> fretes = _fretes.map((f) => Frete(
        origem: f['origem']!.text,
        destino: f['destino']!.text,
        valor: double.tryParse(f['valor']!.text) ?? 0.0,
        obs: f['obs']!.text,
      )).toList();

      Despesas despesas = Despesas(
        diesel: double.tryParse(_dieselController.text) ?? 0.0,
        pedagios: double.tryParse(_pedagiosController.text) ?? 0.0,
        estacionamento: double.tryParse(_estacionamentoController.text) ?? 0.0,
        borracheiro: double.tryParse(_borrachiroController.text) ?? 0.0,
        mecanico: double.tryParse(_mecanicoController.text) ?? 0.0,
        diversos: double.tryParse(_diversosController.text) ?? 0.0,
      );

      TripModel trip = TripModel(
        motorista: _motoristaController.text,
        placaCavalo: _placaCavaloController.text,
        placaCarreta: _placaCarretaController.text,
        numeroViagem: _numeroViagemController.text,
        dataSaida: _dataSaidaController.text,
        dataChegada: _dataChegadaController.text,
        litrosAbastecidos: _litrosAbastecidosController.text,
        kmSaida: _kmSaidaController.text,
        kmChegada: _kmChegadaController.text,
        kmRodados: _kmRodadosController.text,
        mediaConsumo: _mediaConsumoController.text,
        fretes: fretes,
        despesas: despesas,
        dinheiroProxViagem: _dinheiroProxViagemController.text,
        freteRecebido: _freteRecebidoController.text,
        comissaoMotorista: _comissaoMotoristaController.text,
      );

      Navigator.pop(context, trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Viagem'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTrip,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('MOTORISTA E VEÍCULO', Icons.person),
            _buildTextField(_motoristaController, 'Motorista', required: true, icon: Icons.person_outline),
            Row(
              children: [
                Expanded(child: _buildTextField(_placaCavaloController, 'Placa Cavalo', required: true, icon: Icons.local_shipping)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_placaCarretaController, 'Placa Carreta', icon: Icons.local_shipping)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('DADOS DA VIAGEM', Icons.map),
            _buildTextField(_numeroViagemController, 'Número da Viagem', required: true, icon: Icons.numbers),
            Row(
              children: [
                Expanded(child: _buildDateField(_dataSaidaController, 'Data de Saída')),
                const SizedBox(width: 12),
                Expanded(child: _buildDateField(_dataChegadaController, 'Data de Chegada')),
              ],
            ),
            _buildTextField(_litrosAbastecidosController, 'Litros Abastecidos', 
              keyboardType: TextInputType.number, required: true, icon: Icons.local_gas_station),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('QUILOMETRAGEM', Icons.straighten),
            Row(
              children: [
                Expanded(child: _buildTextField(_kmSaidaController, 'KM Saída', 
                  keyboardType: TextInputType.number, required: true, icon: Icons.play_arrow)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_kmChegadaController, 'KM Chegada', 
                  keyboardType: TextInputType.number, required: true, icon: Icons.stop)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildTextField(_kmRodadosController, 'KM Rodados', 
                  keyboardType: TextInputType.number, enabled: false, icon: Icons.route)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_mediaConsumoController, 'Média (Km/L)', 
                  keyboardType: TextInputType.number, enabled: false, icon: Icons.speed)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('FRETES', Icons.attach_money),
            ..._fretes.asMap().entries.map((entry) {
              int index = entry.key;
              var frete = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (_fretes.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeFrete(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(frete['origem']!, 'De', required: true)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward),
                          ),
                          Expanded(child: _buildTextField(frete['destino']!, 'Para', required: true)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(frete['valor']!, 'Valor (R\$)', 
                              keyboardType: TextInputType.number, required: true, icon: Icons.attach_money),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _buildTextField(frete['obs']!, 'Observação', icon: Icons.note),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            OutlinedButton.icon(
              onPressed: _addFrete,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Frete'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('DESPESAS', Icons.receipt_long),
            _buildTextField(_dieselController, 'Óleo Diesel (R\$)', keyboardType: TextInputType.number, icon: Icons.local_gas_station),
            _buildTextField(_pedagiosController, 'Pedágios (R\$)', keyboardType: TextInputType.number, icon: Icons.toll),
            _buildTextField(_estacionamentoController, 'Estacionamento (R\$)', keyboardType: TextInputType.number, icon: Icons.local_parking),
            _buildTextField(_borrachiroController, 'Borracheiro (R\$)', keyboardType: TextInputType.number, icon: Icons.build),
            _buildTextField(_mecanicoController, 'Mecânico (R\$)', keyboardType: TextInputType.number, icon: Icons.construction),
            _buildTextField(_diversosController, 'Diversos (R\$)', keyboardType: TextInputType.number, icon: Icons.more_horiz),
            
            const SizedBox(height: 24),
            
            _buildSectionHeader('RESUMO FINANCEIRO', Icons.account_balance_wallet),
            _buildTextField(_dinheiroProxViagemController, 'Dinheiro p/ próxima viagem (R\$)', 
              keyboardType: TextInputType.number, icon: Icons.money),
            _buildTextField(_freteRecebidoController, 'Frete recebido (R\$)', 
              keyboardType: TextInputType.number, icon: Icons.payments),
            _buildTextField(_comissaoMotoristaController, 'Comissão do motorista (R\$)', 
              keyboardType: TextInputType.number, icon: Icons.person_outline),
            
            const SizedBox(height: 32),
            
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveTrip,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Viagem', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool required = false,
    bool enabled = true,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        keyboardType: keyboardType,
        enabled: enabled,
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null
            : null,
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _selectDate(controller),
        validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}