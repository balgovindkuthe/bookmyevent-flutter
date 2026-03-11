import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../../../../di/service_locator.dart';

class EventAnalyticsScreen extends StatefulWidget {
  final int eventId;

  const EventAnalyticsScreen({super.key, required this.eventId});

  @override
  State<EventAnalyticsScreen> createState() => _EventAnalyticsScreenState();
}

class _EventAnalyticsScreenState extends State<EventAnalyticsScreen> {
  late AnalyticsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<AnalyticsBloc>()..add(FetchEventAnalytics(widget.eventId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Event Analytics')),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnalyticsError) {
              return Center(child: Text(state.message));
            } else if (state is AnalyticsLoaded) {
              final data = state.analytics;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(data.eventTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    _buildSummaryCards(data.totalRevenue, data.totalCheckIns),
                    const SizedBox(height: 32),
                    const Text('Tickets Sold per Tier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: _buildPieChart(data.ticketsSoldPerTier),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double revenue, int checkIns) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.deepPurple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.attach_money, size: 40, color: Colors.deepPurple),
                  const SizedBox(height: 8),
                  Text('\$${revenue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Total Revenue'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   const Icon(Icons.qr_code_scanner, size: 40, color: Colors.green),
                  const SizedBox(height: 8),
                  Text('$checkIns', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Total Check-Ins'),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No ticket sales data available yet.'));
    }

    List<PieChartSectionData> sections = [];
    final colors = [Colors.blue, Colors.red, Colors.yellow, Colors.green, Colors.purple];
    int colorIndex = 0;

    data.forEach((tierName, soldCount) {
      if (soldCount > 0) {
        sections.add(
          PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: soldCount.toDouble(),
            title: '$tierName\n($soldCount)',
            radius: 100,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          )
        );
        colorIndex++;
      }
    });

    if (sections.isEmpty) {
       return const Center(child: Text('0 tickets sold.'));
    }

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}
