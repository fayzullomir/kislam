import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/halal_map_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halol xarita — nearby halal restaurants, shops and mosques. A stylized
/// map preview sits up top with the active area + "open in maps" action;
/// below it a search field, category filter chips and the result list.
///
/// Reached from `HomePage`'s "Halol xarita" quick link. Data is mock
/// ([HalalMapMockData]); tapping a place (or the preview's action) opens
/// the device's maps app at that venue.
@RoutePage()
class HalalMapPage extends StatefulWidget {
  const HalalMapPage({super.key});

  @override
  State<HalalMapPage> createState() => _HalalMapPageState();
}

class _HalalMapPageState extends State<HalalMapPage> {
  final TextEditingController _searchController = TextEditingController();

  /// Active category filter — `null` means "Hammasi" (all).
  HalalCategory? _filter;
  String _query = '';

  /// Gates the screen: while [_LocationGate.checking] we show a loader,
  /// [_LocationGate.disabled] shows the "turn on location" empty state,
  /// and [_LocationGate.ready] reveals the list.
  _LocationGate _gate = _LocationGate.checking;

  @override
  void initState() {
    super.initState();
    _resolveLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _resolveLocation() async {
    if (mounted) setState(() => _gate = _LocationGate.checking);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _gate = _LocationGate.disabled);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _gate = _LocationGate.disabled);
      return;
    }

    if (mounted) setState(() => _gate = _LocationGate.ready);
  }

  /// "Joylashuvni yoqish" — opens the OS location panel when GPS is off,
  /// then re-runs the permission/service check.
  Future<void> _onEnableLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    await _resolveLocation();
  }

  /// "Shaharni qo'lda tanlash" — skips GPS and shows the list anyway.
  void _onSelectCityManually() {
    setState(() => _gate = _LocationGate.ready);
  }

  List<HalalPlace> get _filtered {
    final query = _query.trim().toLowerCase();
    return HalalMapMockData.all.where((place) {
      if (_filter != null && place.category != _filter) return false;
      if (query.isEmpty) return true;
      return place.name.toLowerCase().contains(query) ||
          place.address.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _openInMaps(String query) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query='
      '${Uri.encodeComponent(query)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Scaffold(
      backgroundColor: n.neutral,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HalalMapHeader(onBack: () => context.router.maybePop()),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_gate) {
      case _LocationGate.checking:
        return Center(
          child: CircularProgressIndicator(color: context.noor.primary),
        );
      case _LocationGate.disabled:
        return _LocationDisabledView(
          onEnable: _onEnableLocation,
          onSelectManually: _onSelectCityManually,
        );
      case _LocationGate.ready:
        return _buildList(context);
    }
  }

  Widget _buildList(BuildContext context) {
    final n = context.noor;
    final places = _filtered;
    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
                  _MapPreviewCard(
                    areaLabel: Strings.halalMapArea,
                    onOpenInMaps: () => _openInMaps(Strings.halalMapArea),
                  ),
                  const SizedBox(height: 16),
                  _SearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 14),
                  _FilterChipsRow(
                    selected: _filter,
                    onSelected: (filter) => setState(() => _filter = filter),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    Strings.halalMapResultsCount('${places.length}')
                        .toUpperCase(),
                    style: n.tEyebrow,
                  ),
                  const SizedBox(height: 12),
                  if (places.isEmpty)
                    _EmptyResults()
                  else
                    ...List.generate(places.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: i == places.length - 1 ? 0 : 12,
                        ),
                        child: _PlaceCard(
                          place: places[i],
                          onTap: () => _openInMaps(
                            '${places[i].name} ${places[i].address}',
                          ),
                        ),
                      );
                    }),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header — back chevron + "Halol xarita" title.
// ---------------------------------------------------------------------------

class _HalalMapHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _HalalMapHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Row(
        children: [
          InkResponse(
            onTap: onBack,
            radius: 22,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.chevron_left_rounded, color: n.ink, size: 30),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            Strings.halalMapTitle,
            style: n.tH2.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Map preview — stylized streets + dot markers + center pin. Carries the
// active-area pill (bottom-left) and the "Xaritada ochish" action
// (bottom-right).
// ---------------------------------------------------------------------------

class _MapPreviewCard extends StatelessWidget {
  final String areaLabel;
  final VoidCallback onOpenInMaps;

  const _MapPreviewCard({required this.areaLabel, required this.onOpenInMaps});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusMd),
      child: SizedBox(
        height: 168,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(
                  street: n.lineStrong,
                  marker: n.secondary,
                  pin: n.primary,
                  pinWash: n.primary.withOpacity(0.12),
                ),
                child: Container(color: n.neutralSage),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: _AreaPill(label: areaLabel),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: _OpenInMapsButton(onTap: onOpenInMaps),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaPill extends StatelessWidget {
  final String label;

  const _AreaPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        boxShadow: n.shadowPop,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: n.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: n.tLabel.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _OpenInMapsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OpenInMapsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.primary,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                Strings.halalMapOpenInMaps,
                style: n.tLabel.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative street grid + markers + a centered radius circle and pin.
class _MapPainter extends CustomPainter {
  final Color street;
  final Color marker;
  final Color pin;
  final Color pinWash;

  _MapPainter({
    required this.street,
    required this.marker,
    required this.pin,
    required this.pinWash,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = street.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Two diagonal avenues + two cross streets — loosely mirrors the design.
    canvas.drawLine(
      Offset(-20, size.height * 0.32),
      Offset(size.width + 20, size.height * 0.2),
      streetPaint,
    );
    canvas.drawLine(
      Offset(-20, size.height * 0.78),
      Offset(size.width + 20, size.height * 0.62),
      streetPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, -20),
      Offset(size.width * 0.36, size.height + 20),
      streetPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, -20),
      Offset(size.width * 0.64, size.height + 20),
      streetPaint,
    );

    // Scattered place markers.
    final markerPaint = Paint()..color = marker.withOpacity(0.85);
    for (final p in [
      Offset(size.width * 0.2, size.height * 0.28),
      Offset(size.width * 0.16, size.height * 0.62),
      Offset(size.width * 0.78, size.height * 0.34),
    ]) {
      canvas.drawCircle(p, 4.5, markerPaint);
    }

    // Center radius + active pin.
    final center = Offset(size.width / 2, size.height * 0.48);
    canvas.drawCircle(center, 46, Paint()..color = pinWash);
    canvas.drawCircle(
      center,
      46,
      Paint()
        ..color = pin.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    _drawPin(canvas, center, pin);
  }

  void _drawPin(Canvas canvas, Offset tip, Color color) {
    final paint = Paint()..color = color;
    const r = 9.0;
    final headCenter = Offset(tip.dx, tip.dy - 16);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..quadraticBezierTo(
          tip.dx - r, tip.dy - 14, headCenter.dx - r, headCenter.dy)
      ..arcToPoint(Offset(headCenter.dx + r, headCenter.dy),
          radius: Radius.circular(r), clockwise: true)
      ..quadraticBezierTo(tip.dx + r, tip.dy - 14, tip.dx, tip.dy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(headCenter, 3.4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) =>
      old.street != street || old.pin != pin || old.marker != marker;
}

// ---------------------------------------------------------------------------
// Search field.
// ---------------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusMd),
        border: Border.all(color: n.line, width: 0.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: n.tBody.copyWith(fontSize: 15),
        cursorColor: n.primary,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: Icon(Icons.search_rounded, color: n.inkSoft, size: 22),
          hintText: Strings.halalMapSearchHint,
          hintStyle: n.tBody.copyWith(color: n.inkSoft, fontSize: 15),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category filter chips — Hammasi / Restoranlar / Do'konlar / Masjidlar.
// ---------------------------------------------------------------------------

class _FilterChipsRow extends StatelessWidget {
  final HalalCategory? selected;
  final ValueChanged<HalalCategory?> onSelected;

  const _FilterChipsRow({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final filters = <_FilterOption>[
      _FilterOption(null, Strings.halalMapFilterAll),
      _FilterOption(HalalCategory.restaurant, Strings.halalMapFilterRestaurants),
      _FilterOption(HalalCategory.shop, Strings.halalMapFilterShops),
      _FilterOption(HalalCategory.mosque, Strings.halalMapFilterMosques),
    ];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final option = filters[i];
          return _FilterChip(
            label: option.label,
            isSelected: option.category == selected,
            onTap: () => onSelected(option.category),
          );
        },
      ),
    );
  }
}

class _FilterOption {
  final HalalCategory? category;
  final String label;

  _FilterOption(this.category, this.label);
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: isSelected ? n.primary : n.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusPill),
            border: Border.all(
              color: isSelected ? Colors.transparent : n.lineStrong,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: n.tLabel.copyWith(
              color: isSelected ? Colors.white : n.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Place card — icon tile + name + "Category · address" + Halol/status
// badges, with the distance on the trailing edge.
// ---------------------------------------------------------------------------

class _PlaceCard extends StatelessWidget {
  final HalalPlace place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: place.category.tileBackground(n),
                  borderRadius:
                      BorderRadius.circular(IslamicDesignTokens.radiusSm),
                ),
                child: Icon(
                  place.category.icon,
                  color: place.category.tileForeground(n),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: n.tH3.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_categoryLabel(place.category)} · ${place.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: n.tBodySm.copyWith(color: n.inkSoft, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _HalalBadge(),
                        const SizedBox(width: 12),
                        _StatusBadge(isOpen: place.isOpen),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _distanceLabel(place),
                style: n.tBodySm.copyWith(
                  color: n.inkMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HalalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: n.success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, color: n.success, size: 14),
          const SizedBox(width: 4),
          Text(
            Strings.halalMapBadgeHalal,
            style: n.tCaption.copyWith(
              color: n.success,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;

  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final color = isOpen ? n.success : n.inkSoft;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          isOpen ? Strings.halalMapStatusOpen : Strings.halalMapStatusClosed,
          style: n.tCaption.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, color: n.inkSoft, size: 40),
          const SizedBox(height: 12),
          Text(
            Strings.halalMapEmpty,
            textAlign: TextAlign.center,
            style: n.tBodySm.copyWith(color: n.inkMuted),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Location gate — shown when GPS is off or permission is denied.
// ---------------------------------------------------------------------------

enum _LocationGate { checking, disabled, ready }

class _LocationDisabledView extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onSelectManually;

  const _LocationDisabledView({
    required this.onEnable,
    required this.onSelectManually,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 132,
              height: 132,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: n.danger.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                color: n.danger,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              Strings.halalMapLocationDisabledTitle,
              textAlign: TextAlign.center,
              style: n.tH2.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              Strings.halalMapLocationDisabledDesc,
              textAlign: TextAlign.center,
              style: n.tBody.copyWith(color: n.inkMuted, fontSize: 15),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: n.primary,
                borderRadius:
                    BorderRadius.circular(IslamicDesignTokens.radiusMd),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(IslamicDesignTokens.radiusMd),
                  onTap: onEnable,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          Strings.halalMapEnableLocation,
                          style: n.tBody.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: onSelectManually,
              child: Text(
                Strings.halalMapSelectCityManually,
                style: n.tBody.copyWith(
                  color: n.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline_rounded, color: n.inkSoft, size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    Strings.halalMapLocationPrivacyNote,
                    style: n.tBodySm.copyWith(color: n.inkSoft),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryLabel(HalalCategory category) {
  switch (category) {
    case HalalCategory.restaurant:
      return Strings.halalMapCategoryRestaurant;
    case HalalCategory.shop:
      return Strings.halalMapCategoryShop;
    case HalalCategory.mosque:
      return Strings.halalMapCategoryMosque;
  }
}

String _distanceLabel(HalalPlace place) {
  return place.isFarEnoughForKm
      ? Strings.halalMapDistanceKm(place.distanceKm)
      : Strings.halalMapDistanceMeters('${place.distanceMeters}');
}
