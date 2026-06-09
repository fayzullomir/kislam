import 'package:flutter/material.dart';

import 'noor_tokens.dart';

/// Halol xarita / Halal map mock data — mirrors the standalone design's
/// PLACES list. Each entry is a nearby halal venue (restaurant, shop or
/// mosque) around the Itaewon / Yongsan area in Seoul. Brand names and
/// Korean street addresses stay constant across locales; only the
/// category / status / chrome strings flow through easy_localization.
class HalalMapMockData {
  HalalMapMockData._();

  static List<HalalPlace> get all => const [
        HalalPlace(
          id: 'eid',
          name: 'Eid',
          category: HalalCategory.restaurant,
          address: '이태원로49길 24, 용산구',
          distanceMeters: 140,
          isOpen: true,
        ),
        HalalPlace(
          id: 'salam',
          name: 'Salam Restaurant',
          category: HalalCategory.restaurant,
          address: '우사단로10길 7, 용산구',
          distanceMeters: 230,
          isOpen: true,
        ),
        HalalPlace(
          id: 'foreign-food-mart',
          name: 'Foreign Food Mart',
          category: HalalCategory.shop,
          address: '이태원로 45, 용산구',
          distanceMeters: 310,
          isOpen: true,
        ),
        HalalPlace(
          id: 'seoul-central-masjid',
          name: 'Seoul Central Masjid',
          category: HalalCategory.mosque,
          address: '우사단로10길 39, 용산구',
          distanceMeters: 420,
          isOpen: true,
        ),
        HalalPlace(
          id: 'kervan',
          name: 'Kervan',
          category: HalalCategory.restaurant,
          address: '이태원로27가길, 용산구',
          distanceMeters: 480,
          isOpen: true,
        ),
        HalalPlace(
          id: 'sulaiman-halal-mart',
          name: 'Sulaiman Halal Mart',
          category: HalalCategory.shop,
          address: '우사단로 14, 용산구',
          distanceMeters: 560,
          isOpen: false,
        ),
        HalalPlace(
          id: 'murree',
          name: 'Murree',
          category: HalalCategory.restaurant,
          address: '이태원로 132, 용산구',
          distanceMeters: 780,
          isOpen: true,
        ),
        HalalPlace(
          id: 'makkah-halal-mart',
          name: 'Makkah Halal Mart',
          category: HalalCategory.shop,
          address: '한남동 738, 용산구',
          distanceMeters: 1100,
          isOpen: true,
        ),
        HalalPlace(
          id: 'petra-palace',
          name: 'Petra Palace',
          category: HalalCategory.restaurant,
          address: '보광로 60, 용산구',
          distanceMeters: 1300,
          isOpen: false,
        ),
      ];
}

/// Venue category — drives the filter chips, the per-card icon + icon
/// tile palette, and the "Restoran · address" subtitle label.
enum HalalCategory { restaurant, shop, mosque }

extension HalalCategoryX on HalalCategory {
  IconData get icon {
    switch (this) {
      case HalalCategory.restaurant:
        return Icons.restaurant_rounded;
      case HalalCategory.shop:
        return Icons.shopping_bag_outlined;
      case HalalCategory.mosque:
        return Icons.mosque_rounded;
    }
  }

  /// Icon-tile foreground / background pulled from the active palette so
  /// the screen stays correct in both light and dark mode.
  Color tileForeground(NoorTokens n) {
    switch (this) {
      case HalalCategory.restaurant:
        return n.primary;
      case HalalCategory.shop:
        return n.secondaryInk;
      case HalalCategory.mosque:
        return n.info;
    }
  }

  Color tileBackground(NoorTokens n) {
    switch (this) {
      case HalalCategory.restaurant:
        return n.tertiaryWash;
      case HalalCategory.shop:
        return n.secondaryWash;
      case HalalCategory.mosque:
        return n.info.withOpacity(0.12);
    }
  }
}

class HalalPlace {
  final String id;
  final String name;
  final HalalCategory category;
  final String address;
  final int distanceMeters;
  final bool isOpen;

  const HalalPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.distanceMeters,
    required this.isOpen,
  });

  bool get isFarEnoughForKm => distanceMeters >= 1000;

  /// "1.1" for 1100 m — the "km" suffix is appended by the localized
  /// formatter at the call site.
  String get distanceKm => (distanceMeters / 1000).toStringAsFixed(1);
}
