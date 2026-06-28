import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/models/speaker.dart';
import 'package:kuttiomp_mobile/services/api_service.dart';

class SpeakersScreen extends StatefulWidget {
  const SpeakersScreen({super.key});

  @override
  State<SpeakersScreen> createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends State<SpeakersScreen> {
  final _api = ApiService();
  List<Speaker> _speakers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final speakers = await _api.getSpeakers();
      setState(() {
        _speakers = speakers;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Speakers & Clan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _speakers.length,
                    itemBuilder: (context, index) {
                      final speaker = _speakers[index];
                      return Card(
                        child: ListTile(
                          title: Text(speaker.displayName),
                          subtitle: Text(
                            '${speaker.role} · ${speaker.generation}',
                          ),
                          trailing: speaker.isElder
                              ? const Chip(label: Text('Elder'))
                              : speaker.isTwoSpirit
                                  ? const Chip(label: Text('Sharente'))
                                  : null,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}