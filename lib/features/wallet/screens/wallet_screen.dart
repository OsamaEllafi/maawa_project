import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/services/auth_service.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser!;
    final balance = DemoData.getUserWalletBalance(currentUser.id);
    final transactions = DemoData.getTransactionsByUser(currentUser.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.primaryCoral),
            onPressed: _showTransactionHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Card
          _buildBalanceCard(balance, screenWidth),

          // Quick Actions
          _buildQuickActions(screenWidth),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryCoral,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.gray600,
              tabs: const [
                Tab(text: 'Recent'),
                Tab(text: 'All'),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsList(
                  transactions.take(5).toList(),
                  screenWidth,
                ),
                _buildTransactionsList(transactions, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance, double screenWidth) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryCoral, AppColors.primaryMagenta],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCoral.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: _showBalanceInfo,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Current Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${balance.toStringAsFixed(2)} LYD',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth < 400 ? 28 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBalanceStat(
                  'This Month',
                  '+${(balance * 0.3).toStringAsFixed(2)} LYD',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildBalanceStat(
                  'Last Month',
                  '+${(balance * 0.7).toStringAsFixed(2)} LYD',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add,
              label: 'Top Up',
              color: AppColors.primaryCoral,
              onTap: _topUpWallet,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.account_balance,
              label: 'Withdraw',
              color: AppColors.primaryMagenta,
              onTap: _withdrawFunds,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.swap_horiz,
              label: 'Transfer',
              color: AppColors.primaryTurquoise,
              onTap: _transferFunds,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    List<DemoTransaction> transactions,
    double screenWidth,
  ) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: AppColors.gray400),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transaction history will appear here',
              style: TextStyle(color: AppColors.gray500, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction, screenWidth);
      },
    );
  }

  Widget _buildTransactionCard(
    DemoTransaction transaction,
    double screenWidth,
  ) {
    final isPositive = transaction.amount > 0;
    final statusColor = _getStatusColor(transaction.status);
    final typeIcon = _getTransactionTypeIcon(transaction.type);
    final typeColor = _getTransactionTypeColor(transaction.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(
                    color: AppColors.gray900,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(transaction.createdAt),
                      style: TextStyle(color: AppColors.gray600, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction.status.name.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}${transaction.amount.toStringAsFixed(2)} LYD',
                style: TextStyle(
                  color: isPositive ? Colors.green : AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.type.name.toUpperCase(),
                style: TextStyle(
                  color: AppColors.gray500,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return AppColors.error;
      case TransactionStatus.cancelled:
        return AppColors.gray500;
    }
  }

  IconData _getTransactionTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.topup:
        return Icons.add_circle;
      case TransactionType.withdrawal:
        return Icons.remove_circle;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.earning:
        return Icons.trending_up;
      case TransactionType.adjustment:
        return Icons.tune;
    }
  }

  Color _getTransactionTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.topup:
        return Colors.green;
      case TransactionType.withdrawal:
        return AppColors.error;
      case TransactionType.payment:
        return AppColors.primaryCoral;
      case TransactionType.earning:
        return Colors.blue;
      case TransactionType.adjustment:
        return AppColors.gray600;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Action Methods
  void _topUpWallet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTopUpSheet(),
    );
  }

  void _withdrawFunds() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildWithdrawSheet(),
    );
  }

  void _transferFunds() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transfer feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTransactionHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detailed transaction history coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBalanceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet Balance'),
        content: const Text(
          'Your wallet balance includes all completed transactions. '
          'Pending transactions will be reflected once completed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Top Up Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAmountOption(100.0),
          _buildAmountOption(200.0),
          _buildAmountOption(500.0),
          _buildAmountOption(1000.0),
          const SizedBox(height: 20),
          GradientButton(
            text: 'Top Up',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Top-up request submitted!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Withdraw Funds',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter amount to withdraw:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0.00 LYD',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            text: 'Withdraw',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Withdrawal request submitted!'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountOption(double amount) {
    return GestureDetector(
      onTap: () {
        // Handle amount selection
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              '${amount.toStringAsFixed(0)} LYD',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray500),
          ],
        ),
      ),
    );
  }
}
