class PremiumUser {
  final String uid;
  // final List<String> history;
  final int generationCount;
  final int tokensConsumed;

  PremiumUser({
    required this.uid,
    // required this.history,
    required this.generationCount,
    required this.tokensConsumed,
  });

  factory PremiumUser.fromMap(Map<String, dynamic> data, String uid) =>
      PremiumUser(
        uid: uid,
        // history: (data['history'] as List)?.cast<String>() ?? [],
        generationCount: data['generationCount'] as int,
        tokensConsumed: data['tokensConsumed'] as int,
      );
}
