import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';

class ReportFilterWidget extends StatelessWidget {
  const ReportFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final storeIdController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: storeIdController,
            decoration: const InputDecoration(labelText: 'Store ID'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: startDateController,
            decoration: const InputDecoration(
              labelText: 'Start Date (YYYY-MM-DD)',
            ),
          ),
          TextField(
            controller: endDateController,
            decoration: const InputDecoration(
              labelText: 'End Date (YYYY-MM-DD)',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ReportsBloc>().add(
                    GenerateSalesReportEvent(
                      storeId: int.tryParse(storeIdController.text),
                      startDate: DateTime.tryParse(startDateController.text),
                      endDate: DateTime.tryParse(endDateController.text),
                    ),
                  );
                },
                child: const Text('Sales Report'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ReportsBloc>().add(
                    GeneratePurchasesReportEvent(
                      storeId: int.tryParse(storeIdController.text),
                      startDate: DateTime.tryParse(startDateController.text),
                      endDate: DateTime.tryParse(endDateController.text),
                    ),
                  );
                },
                child: const Text('Purchases Report'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
