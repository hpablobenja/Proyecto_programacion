import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_state.dart';
import '../widgets/report_filter_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Column(
        children: [
          ReportFilterWidget(),
          Expanded(
            child: BlocBuilder<ReportsBloc, ReportsState>(
              builder: (context, state) {
                if (state is ReportsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SalesReportLoaded) {
                  return ListView.builder(
                    itemCount: state.sales.length,
                    itemBuilder: (context, index) {
                      final sale = state.sales[index];
                      return ListTile(
                        title: Text('Sale #${sale.id}'),
                        subtitle: Text(
                          'Product: ${sale.productId}, Qty: ${sale.quantity}',
                        ),
                      );
                    },
                  );
                } else if (state is PurchasesReportLoaded) {
                  return ListView.builder(
                    itemCount: state.purchases.length,
                    itemBuilder: (context, index) {
                      final purchase = state.purchases[index];
                      return ListTile(
                        title: Text('Purchase #${purchase.id}'),
                        subtitle: Text(
                          'Product: ${purchase.productId}, Qty: ${purchase.quantity}',
                        ),
                      );
                    },
                  );
                } else if (state is DailyGlobalSalesLoaded) {
                  return Center(child: Text('Daily Sales: \$${state.total}'));
                } else if (state is ReportsError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Select a report type'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
