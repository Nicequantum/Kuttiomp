/// The Twelve Cultural Governance Protocols of Kuttiomp (v2.0).
enum KuttiompProtocol {
  speakerAttribution('1', 'Speaker Attribution'),
  elderApproval('2', 'Elder Approval Workflows'),
  generationalAccessTiers('3', 'Generational Access Tiers'),
  sacredContentProtection('4', 'Sacred/Ceremonial Content Protection'),
  clanVisibility('5', 'Clan Visibility Boundaries'),
  landContextualization('6', 'Land-Based Contextualization'),
  oralTraditionPrimacy('7', 'Oral Tradition Primacy'),
  livingAuthoritySupremacy('8', 'Living Authority Supremacy'),
  dataSovereignty('9', 'Data Sovereignty & Auditability'),
  nonGamificationDignity('10', 'Non-Gamification & Dignity'),
  accessibilityElderCentric('11', 'Accessibility & Elder-Centric Design'),
  longTermCulturalIntegrity('12', 'Long-Term Cultural Integrity');

  const KuttiompProtocol(this.id, this.label);

  final String id;
  final String label;

  static KuttiompProtocol? fromId(String id) {
    for (final protocol in KuttiompProtocol.values) {
      if (protocol.id == id) return protocol;
    }
    return null;
  }

  static const List<KuttiompProtocol> all = KuttiompProtocol.values;
}

/// Bitmask flags for generational access tiers (Protocol 3).
class GenerationalTierBitmask {
  GenerationalTierBitmask._();

  static const int littleOnes = 1 << 0;
  static const int youngLearner = 1 << 1;
  static const int coreAdult = 1 << 2;
  static const int elder = 1 << 3;
  static const int allTiers = littleOnes | youngLearner | coreAdult | elder;
}