import 'package:flutter/material.dart';
import '../../../core/services/app_shell.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/airbnb_card.dart';
import '../../../l10n/app_localizations.dart';

class StyleGuideScreen extends StatelessWidget {
  const StyleGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Style Guide'),
        actions: const [
          QuickToggleButtons(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Branding',
              _buildBrandingSection(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Colors',
              _buildColorsSection(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Typography',
              _buildTypographySection(context, theme),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Buttons',
              _buildButtonsSection(context, l10n),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Cards',
              _buildCardsSection(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Form Elements',
              _buildFormElementsSection(context, l10n),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Spacing & Layout',
              _buildSpacingSection(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              context,
              'Settings',
              _buildSettingsSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        content,
      ],
    );
  }

  Widget _buildBrandingSection(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Image.asset(
              'frontend/assets/branding/Logo1.png',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('MAAWA Logo', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildColorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand Colors', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildColorSwatch('Coral', AppColors.primaryCoral),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Turquoise', AppColors.primaryTurquoise),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Orange', AppColors.primaryCoral),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Magenta', AppColors.primaryTurquoise),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Neutral Colors', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildColorSwatch('Gray 100', AppColors.gray100),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Gray 300', AppColors.gray300),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Gray 500', AppColors.gray500),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Gray 700', AppColors.gray700),
            const SizedBox(width: AppSpacing.md),
            _buildColorSwatch('Gray 900', AppColors.gray900),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildTypographySection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: theme.textTheme.displayLarge),
        Text('Display Medium', style: theme.textTheme.displayMedium),
        Text('Headline Large', style: theme.textTheme.headlineLarge),
        Text('Headline Medium', style: theme.textTheme.headlineMedium),
        Text('Title Large', style: theme.textTheme.titleLarge),
        Text('Title Medium', style: theme.textTheme.titleMedium),
        Text('Body Large', style: theme.textTheme.bodyLarge),
        Text('Body Medium', style: theme.textTheme.bodyMedium),
        Text('Label Large', style: theme.textTheme.labelLarge),
        Text('Label Medium', style: theme.textTheme.labelMedium),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gradient Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            GradientButton(
              text: l10n?.login ?? 'Login',
              onPressed: () {},
            ),
            const SizedBox(width: AppSpacing.md),
            GradientButton(
              text: l10n?.search ?? 'Search',
              onPressed: () {},
              isLoading: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Outline Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            const SizedBox(width: AppSpacing.md),
            OutlinedButton(
              onPressed: () {},
              child: Text(l10n?.edit ?? 'Edit'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Standard Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n?.save ?? 'Save'),
            ),
            const SizedBox(width: AppSpacing.md),
            TextButton(
              onPressed: () {},
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            const SizedBox(width: AppSpacing.md),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Property Cards', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                child: AirbnbCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Beautiful Property ${index + 1}', 
                           style: Theme.of(context).textTheme.titleMedium),
                      Text('Dubai, UAE', 
                           style: Theme.of(context).textTheme.bodySmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${(index + 1) * 100}/night'),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              Text('${4.5 + (index * 0.2)}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Standard Cards', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Title', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text('This is a standard Material card with default styling applied from the theme.'),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Action')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormElementsSection(BuildContext context, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: l10n?.email ?? 'Email',
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: InputDecoration(
            labelText: l10n?.password ?? 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.visibility),
          ),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Checkbox(value: true, onChanged: (value) {}),
            const Text('Checkbox option'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Radio(value: 1, groupValue: 1, onChanged: (value) {}),
            const Text('Radio option 1'),
            const SizedBox(width: AppSpacing.lg),
            Radio(value: 2, groupValue: 1, onChanged: (value) {}),
            const Text('Radio option 2'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Slider(
          value: 0.5,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSpacingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing Scale', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _buildSpacingExample('XS (4px)', AppSpacing.xs),
        _buildSpacingExample('SM (8px)', AppSpacing.sm),
        _buildSpacingExample('MD (16px)', AppSpacing.md),
        _buildSpacingExample('LG (24px)', AppSpacing.lg),
        _buildSpacingExample('XL (32px)', AppSpacing.xl),
        _buildSpacingExample('XXL (48px)', 48.0),
        const SizedBox(height: AppSpacing.lg),
        Text('Border Radius', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildRadiusExample('SM (4px)', AppRadius.sm),
            const SizedBox(width: AppSpacing.md),
            _buildRadiusExample('MD (8px)', AppRadius.md),
            const SizedBox(width: AppSpacing.md),
            _buildRadiusExample('LG (12px)', AppRadius.lg),
            const SizedBox(width: AppSpacing.md),
            _buildRadiusExample('XL (16px)', AppRadius.xl),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingExample(String label, double spacing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: spacing,
            height: 20,
            color: AppColors.primaryCoral,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildRadiusExample(String label, double radius) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryTurquoise,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return const AppSettingsWidget();
  }
}
