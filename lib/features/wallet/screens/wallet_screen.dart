import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/wallet/entities/wallet.dart';
import '../../../domain/wallet/entities/transaction.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  Wallet? _wallet;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWalletData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWalletData() async {
    setState(() => _isLoading = true);
    try {
      final wallet = await ServiceLocator().walletRepository.getWalletInfo();
      final transactions = await ServiceLocator().walletRepository
          .getTransactions();

      setState(() {
        _wallet = wallet;
        _transactions = transactions;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading wallet data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _topUpWallet() async {
    final amount = await _showAmountDialog('Top Up Wallet');
    if (amount == null) return;

    setState(() => _isLoading = true);
    try {
      await ServiceLocator().walletRepository.topUpWallet(
        amount: amount,
        method: 'card',
        idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await _loadWalletData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet topped up successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error topping up wallet: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _withdrawFromWallet() async {
    if (_wallet == null || _wallet!.balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance for withdrawal')),
      );
      return;
    }

    final amount = await _showAmountDialog(
      'Withdraw from Wallet',
      maxAmount: _wallet!.balance,
    );
    if (amount == null) return;

    setState(() => _isLoading = true);
    try {
      await ServiceLocator().walletRepository.withdrawFromWallet(
        amount: amount,
        method: 'bank_transfer',
        idempotencyKey: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await _loadWalletData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawal request submitted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error withdrawing from wallet: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<double?> _showAmountDialog(String title, {double? maxAmount}) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (LYD)',
                hintText: 'Enter amount...',
                suffixText: 'LYD',
              ),
            ),
            if (maxAmount != null) ...[
              const SizedBox(height: 8),
              Text(
                'Available balance: ${maxAmount.toStringAsFixed(2)} LYD',
                style: TextStyle(color: AppColors.gray600, fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                if (maxAmount != null && amount > maxAmount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Amount exceeds available balance'),
                    ),
                  );
                  return;
                }
                Navigator.pop(context, amount);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadWalletData,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildWalletCard(),
                const SizedBox(height: 16),
                Expanded(child: _buildTransactionsTab()),
              ],
            ),
    );
  }

  Widget _buildWalletCard() {
    if (_wallet == null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryCoral,
              AppColors.primaryCoral.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Loading wallet...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryCoral,
            AppColors.primaryCoral.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCoral.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white.withValues(alpha: 0.8),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _wallet!.balanceDisplay,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _topUpWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryCoral,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Top Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _withdrawFromWallet,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Withdraw',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryCoral,
            labelColor: AppColors.primaryCoral,
            unselectedLabelColor: AppColors.gray500,
            tabs: const [
              Tab(text: 'All Transactions'),
              Tab(text: 'Recent'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTransactionsList(_transactions),
              _buildTransactionsList(_transactions.take(10).toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: AppColors.gray400),
            const SizedBox(height: 16),
            Text(
              'No Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any transactions yet',
              style: TextStyle(color: AppColors.gray500, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWalletData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTransactionCard(transaction),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTransactionColor(transaction).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                _getTransactionIcon(transaction),
                color: _getTransactionColor(transaction),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(transaction),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTransactionSubtitle(transaction),
                    style: TextStyle(color: AppColors.gray600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.createdAt.toString().split(' ')[0],
                    style: TextStyle(color: AppColors.gray500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.signedAmountDisplay,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getTransactionColor(transaction),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction.status.name.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(transaction),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionColor(Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.topup:
      case TransactionType.refund:
        return Colors.green;
      case TransactionType.withdrawal:
      case TransactionType.payment:
        return Colors.red;
      case TransactionType.adjustment:
        return Colors.orange;
    }
  }

  IconData _getTransactionIcon(Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.topup:
        return Icons.add_circle;
      case TransactionType.withdrawal:
        return Icons.remove_circle;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.refund:
        return Icons.refresh;
      case TransactionType.adjustment:
        return Icons.admin_panel_settings;
    }
  }

  String _getTransactionTitle(Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.topup:
        return 'Top Up';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.adjustment:
        return 'Admin Adjustment';
    }
  }

  String _getTransactionSubtitle(Transaction transaction) {
    switch (transaction.method) {
      case TransactionMethod.card:
        return 'Credit Card';
      case TransactionMethod.bankTransfer:
        return 'Bank Transfer';
      case TransactionMethod.wallet:
        return 'Wallet Transfer';
      case TransactionMethod.admin:
        return 'Admin Action';
    }
  }

  Color _getStatusColor(Transaction transaction) {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.cancelled:
        return AppColors.gray500;
    }
  }
}
