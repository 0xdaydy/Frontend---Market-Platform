import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../../core/data/models/models.dart';
import '../../../../core/notifications/notifications.dart';
import '../../../farmers/presentation/providers/farmer_providers.dart';
import '../../../repayments/presentation/providers/repayment_providers.dart';

class RecordRepaymentScreen extends ConsumerStatefulWidget {
  const RecordRepaymentScreen({super.key});

  @override
  ConsumerState<RecordRepaymentScreen> createState() =>
      _RecordRepaymentScreenState();
}

class _RecordRepaymentScreenState extends ConsumerState<RecordRepaymentScreen> {
  bool isCommodity = false;
  final _amountController = TextEditingController();
  final _kgController = TextEditingController();
  int? _selectedFarmerId;
  String? _selectedFarmerName;
  int? _selectedCommodityId;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _kgController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _kgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final farmersAsync = ref.watch(farmersProvider);
    final commoditiesAsync = ref.watch(commoditiesProvider);
    final createAsync = ref.watch(createRepaymentProvider);
    final debtsAsync = _selectedFarmerId != null
        ? ref.watch(farmerDebtsProvider(_selectedFarmerId!))
        : null;

    // Listen for repayment creation state changes
    ref.listen(createRepaymentProvider, (previous, next) {
      next.whenOrNull(
        data: (repayment) {
          if (repayment != null) {
            context.push(AppRoutes.repaymentConfirmation);
          }
        },
        error: (error, _) {
          if (error is Failure) {
            ref.read(notificationGatewayProvider).notify(error);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordRepaymentTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farmer picker
              farmersAsync.when(
                data: (farmers) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: _selectedFarmerId != null
                          ? Text(
                              _getInitials(_selectedFarmerName ?? ''),
                              style: tt.titleSmall?.copyWith(
                                  color: cs.onPrimaryContainer),
                            )
                          : Icon(Icons.person_outline,
                              color: cs.onPrimaryContainer),
                    ),
                    title: Text(_selectedFarmerName ?? l10n.selectFarmer),
                    subtitle: _selectedFarmerId != null
                        ? Text('ID: $_selectedFarmerId')
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showFarmerPicker(context, farmers),
                  ),
                ),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (_, __) => Card(
                  child: ListTile(
                    title: Text(l10n.errorLoading),
                    leading: Icon(Icons.error, color: cs.error),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Payment type
              Text(l10n.paymentType,
                  style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
              SizedBox(height: 8.h),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.cash)),
                  ButtonSegment(value: true, label: Text(l10n.commodity)),
                ],
                selected: {isCommodity},
                onSelectionChanged: (set) =>
                    setState(() => isCommodity = set.first),
              ),
              SizedBox(height: 16.h),
              if (!isCommodity)
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    suffixText: l10n.currency,
                  ),
                )
              else
                commoditiesAsync.when(
                  data: (commodities) => Column(
                    children: [
                      DropdownButtonFormField<int>(
                        decoration:
                            const InputDecoration(labelText: 'Commodity'),
                        value: _selectedCommodityId,
                        items: commodities.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(
                                '${c.name} — ${c.rateFcfaPerUnit.toStringAsFixed(0)} FCFA/${c.unit}'),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCommodityId = value),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _kgController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: l10n.kg,
                          suffixText: 'kg',
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => Text(
                    l10n.errorLoading,
                    style: tt.bodyMedium?.copyWith(color: cs.error),
                  ),
                ),
              SizedBox(height: 16.h),
              // Allocation preview
              if (_selectedFarmerId != null && debtsAsync != null)
                debtsAsync.when(
                  data: (debts) {
                    final allocation = _calculateAllocation(debts);
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.allocationPreview,
                                style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.h),
                            if (allocation.isEmpty)
                              Text(
                                '${l10n.appliedTo}: ${l10n.noDebts}',
                                style: tt.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant),
                              )
                            else
                              ...allocation.map((item) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 4.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item['reference']}',
                                          style: tt.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${(item['applied'] as double).toStringAsFixed(0)} FCFA',
                                        style: tt.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: cs.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            if (_getSurplus(debts) > 0) ...[
                              Divider(height: 16.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.creditSurplus,
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: cs.tertiary,
                                    ),
                                  ),
                                  Text(
                                    '${_getSurplus(debts).toStringAsFixed(0)} FCFA',
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: cs.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (_, __) => Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        l10n.errorLoading,
                        style: tt.bodyMedium?.copyWith(color: cs.error),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton(
                  onPressed: _selectedFarmerId == null || createAsync.isLoading
                      ? null
                      : _confirmRepayment,
                  child: createAsync.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.confirmRepayment),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFarmerPicker(BuildContext context, List<FarmerModel> farmers) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                l10n.selectFarmer,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: farmers.length,
                itemBuilder: (context, index) {
                  final farmer = farmers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.theme.colorScheme.primaryContainer,
                      child: Text(
                        _getInitials(farmer.name),
                        style: TextStyle(
                          color: context.theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(farmer.name),
                    subtitle: Text(farmer.cardId),
                    onTap: () {
                      setState(() {
                        _selectedFarmerId = farmer.id;
                        _selectedFarmerName = farmer.name;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRepayment() {
    if (_selectedFarmerId == null) return;

    final data = <String, dynamic>{
      'farmer_id': _selectedFarmerId,
      'farmer_name': _selectedFarmerName,
      'payment_method': isCommodity ? 'commodity' : 'cash',
    };

    if (!isCommodity) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) return;
      data['amount'] = amount;
    } else {
      final kg = double.tryParse(_kgController.text);
      if (kg == null || kg <= 0 || _selectedCommodityId == null) return;
      data['commodity_id'] = _selectedCommodityId;
      data['quantity'] = kg;
    }

    ref.read(createRepaymentProvider.notifier).createRepayment(data);
  }

  double _getRepaymentAmount() {
    if (!isCommodity) {
      return double.tryParse(_amountController.text) ?? 0;
    }
    final kg = double.tryParse(_kgController.text) ?? 0;
    final commodities = ref.read(commoditiesProvider).value;
    final commodity = commodities?.firstWhere(
      (c) => c.id == _selectedCommodityId,
      orElse: () => const CommodityModel(id: 0, name: '', unit: '', rateFcfaPerUnit: 0),
    );
    return kg * (commodity?.rateFcfaPerUnit ?? 0);
  }

  List<Map<String, dynamic>> _calculateAllocation(List<DebtModel> debts) {
    final amount = _getRepaymentAmount();
    if (amount <= 0) return [];

    var remaining = amount;
    final allocations = <Map<String, dynamic>>[];

    final openDebts = debts
        .where((d) => d.status == 'open' || d.status == 'partially_paid')
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (final debt in openDebts) {
      if (remaining <= 0) break;
      final toApply = remaining < debt.balance ? remaining : debt.balance;
      remaining -= toApply;
      allocations.add({
        'reference': debt.reference ?? 'DEBT-${debt.id}',
        'applied': toApply,
        'balance': debt.balance - toApply,
      });
    }

    return allocations;
  }

  double _getSurplus(List<DebtModel> debts) {
    final amount = _getRepaymentAmount();
    if (amount <= 0) return 0;

    var remaining = amount;
    final openDebts = debts
        .where((d) => d.status == 'open' || d.status == 'partially_paid')
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (final debt in openDebts) {
      if (remaining <= 0) break;
      final toApply = remaining < debt.balance ? remaining : debt.balance;
      remaining -= toApply;
    }

    return remaining > 0 ? remaining : 0;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '??';
  }
}
