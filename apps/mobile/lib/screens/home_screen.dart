import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/screens/lexicon_screen.dart';
import 'package:kuttiomp_mobile/screens/speakers_screen.dart';
import 'package:kuttiomp_mobile/services/api_service.dart';
import 'package:kuttiomp_mobile/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _health;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final health = await _api.health();
      setState(() {
        _health = health;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHealth,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              AppConstants.tagline,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusCard(theme),
            const SizedBox(height: 24),
            Text('Learn', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _NavTile(
              icon: Icons.people_outline,
              title: 'Speakers & Clan',
              subtitle: 'Multi-generational Knowledge Keepers',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpeakersScreen()),
              ),
            ),
            _NavTile(
              icon: Icons.menu_book_outlined,
              title: 'Lexicon',
              subtitle: 'Narragansett words and cultural context',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LexiconScreen()),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'v${AppConstants.apiVersion} — Foundation scaffold',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null) {
      return Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('API unreachable', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_error!, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(
                'Start the API: uvicorn app.main:app --reload --port 8000',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    final db = _health?['database'] as Map<String, dynamic>? ?? {};
    final connected = db['status'] == 'connected';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  connected ? Icons.check_circle : Icons.warning_amber,
                  color: connected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  connected ? 'API Connected' : 'API Degraded',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Version: ${_health?['version'] ?? AppConstants.apiVersion}'),
            Text('Speakers: ${db['speaker_count'] ?? '—'}'),
            Text('Migration: ${db['migration_version'] ?? '—'}'),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}