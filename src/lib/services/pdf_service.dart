// lib/services/pdf_service.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/trip_model.dart';

class PDFService {
  Future<void> generatePDF(TripModel trip) async {
    final pdf = pw.Document();

    double totalFretes = trip.totalFretes;
    double totalDespesas = trip.totalDespesas;
    double freteRecebido = double.parse(trip.freteRecebido);
    double comissao = double.parse(trip.comissaoMotorista);
    double saldoViagem = trip.saldoViagem;
    double dinheiroProxViagem = double.parse(trip.dinheiroProxViagem);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Título
            pw.Center(
              child: pw.Text(
                'Folha viagem',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            
            // DADOS DO MOTORISTA E VEÍCULO
            pw.Text('DADOS DO MOTORISTA E VEÍCULO', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('Motorista: ${trip.motorista}          Placa: ${trip.placaCavalo}          Placa: ${trip.placaCarreta}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // DADOS DA VIAGEM
            pw.Text('DADOS DA VIAGEM', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('N° da viagem: ${trip.numeroViagem}     Data de saída: ${trip.dataSaida}     Data de chegada: ${trip.dataChegada}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text('Litros abastecidos: ${trip.litrosAbastecidos}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // QUILOMETRAGEM E CONSUMO
            pw.Text('QUILOMETRAGEM E CONSUMO', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('Km de saída: ${trip.kmSaida}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Km de chegada: ${trip.kmChegada}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 3),
            pw.Text('Km rodados: ${trip.kmRodados}               Média (Km/L): ${trip.mediaConsumo}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // FRETES
            pw.Text('FRETES', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            ...trip.fretes.map((frete) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text('De ${frete.origem} x ${frete.destino}     R\$ ${frete.valor.toStringAsFixed(2)}     ${frete.obs}', 
                style: const pw.TextStyle(fontSize: 10)),
            )).toList(),
            pw.SizedBox(height: 5),
            pw.Text('TOTAL R\$: ${totalFretes.toStringAsFixed(2)}', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.SizedBox(height: 5),
            pw.Text('TOTAL DAS DESPESAS: R\$ ${totalDespesas.toStringAsFixed(2)}', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.SizedBox(height: 15),

            // DESPESAS DA VIAGEM
            pw.Text('DESPESAS DA VIAGEM', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('Óleo Diesel: R\$ ${trip.despesas.diesel.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Pedágios: R\$ ${trip.despesas.pedagios.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Estacionamento: R\$ ${trip.despesas.estacionamento.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Borracheiro: R\$ ${trip.despesas.borracheiro.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Mecânico: R\$ ${trip.despesas.mecanico.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Diversos: R\$ ${trip.despesas.diversos.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 15),

            // RESUMO FINANCEIRO
            pw.Text('RESUMO FINANCEIRO', 
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.SizedBox(height: 5),
            pw.Text('Dinheiro para próx. viagem: R\$ ${dinheiroProxViagem.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Frete recebido: R\$ ${freteRecebido.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('(-) Comissão do motorista: R\$ ${comissao.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('(-) Despesas da viagem: R\$ ${totalDespesas.toStringAsFixed(2)}', 
              style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Saldo da viagem: R\$ ${saldoViagem.toStringAsFixed(2)}', 
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}