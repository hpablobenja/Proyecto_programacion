import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import 'report_filters_page.dart';
import 'report_detail_page.dart';
import '../widgets/report_debug_widget.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar reportes al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsBloc>().add(LoadReportsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ReportsBloc>().add(LoadReportsEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ReportDebugWidget(),
          Expanded(
            child: BlocConsumer<ReportsBloc, ReportsState>(
              listener: (context, state) {
                if (state is ReportsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ReportGenerated) {
                  // Navegar a la página de detalle del reporte
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportDetailPage(report: state.report),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ReportsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ReportsLoaded) {
                  final reports = state.reports;

                  if (reports.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assessment, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No hay reportes generados',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Genera tu primer reporte',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getReportColor(report.type),
                            child: Icon(
                              _getReportIcon(report.type),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            report.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(report.description),
                              Text(
                                'Generado: ${_formatDate(report.generatedAt)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportDetailPage(report: report),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ReportsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar reportes: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ReportsBloc>().add(LoadReportsEvent());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('No hay datos disponibles'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "test_report",
            onPressed: () {
              print('🧪 Generando reporte de prueba...');
              context.read<ReportsBloc>().add(
                GenerateSalesReportEvent(
                  storeId: null,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now(),
                ),
              );
            },
            child: const Icon(Icons.bug_report),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "add_report",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportFiltersPage(),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Color _getReportColor(String type) {
    switch (type) {
      case 'sales':
        return Colors.green;
      case 'purchases':
        return Colors.blue;
      case 'transfers':
        return Colors.orange;
      case 'daily_sales':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getReportIcon(String type) {
    switch (type) {
      case 'sales':
        return Icons.shopping_cart;
      case 'purchases':
        return Icons.shopping_bag;
      case 'transfers':
        return Icons.swap_horiz;
      case 'daily_sales':
        return Icons.trending_up;
      default:
        return Icons.assessment;
    }
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
