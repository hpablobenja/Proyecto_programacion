import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_state.dart';

class ReportDebugWidget extends StatelessWidget {
  const ReportDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Debug - Estado Actual:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Tipo de Estado: ${state.runtimeType}'),
                const SizedBox(height: 8),
                if (state is ReportsLoading)
                  const Text(
                    '🔄 Cargando...',
                    style: TextStyle(color: Colors.blue),
                  )
                else if (state is ReportsError)
                  Text(
                    '❌ Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  )
                else if (state is ReportGenerated)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Reporte Generado:',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text('ID: ${state.report.id}'),
                      Text('Tipo: ${state.report.type}'),
                      Text('Título: ${state.report.title}'),
                      Text('Descripción: ${state.report.description}'),
                      Text('Datos: ${state.report.data}'),
                    ],
                  )
                else if (state is ReportsLoaded)
                  Text('📋 Reportes Cargados: ${state.reports.length}')
                else
                  const Text('⏳ Estado Inicial'),
              ],
            ),
          ),
        );
      },
    );
  }
}
