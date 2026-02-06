import 'package:flutter/material.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/models/Apartment.dart';

import '../models/url_config.dart';

class ApartmentInfo extends StatelessWidget {
  const ApartmentInfo({
    super.key,
    required this.apartment,
    this.headerRight,
    this.footer,
    this.onBack,
  });

  final Apartment apartment;

  final Widget? headerRight;
  final Widget? footer;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageUrl = apartment.owner_photo_url != null
        ? '${UrlConfig.storageBaseUrl}/${apartment.owner_photo_url}'
        : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top : screenWidth * 0.032, left: screenWidth * 0.015, right: screenWidth * 0.015), // all
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // price
                  RichText(
                    text: TextSpan(
                      style: th.headlineSmall?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        TextSpan(
                          //to show 456.30 instead of 456.3 beacause it looks more smexy
                          text:
                              '${apartment.rent_price_per_night.toStringAsFixed(2)}\$',
                        ),
                        TextSpan(
                          text: '  ${t.apartment_perNight}',
                          style: th.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // address
                  Text(
                    '${apartment.makeAddress(context)} • ${apartment.apartment_number}',
                    style: th.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),

                  SizedBox(height: screenHeight * 0.015),
                  Divider(color: cs.outlineVariant.withAlpha(150), height: 1),
                  SizedBox(height: screenHeight * 0.01),

                  // quick info
                  Wrap(
                    spacing: screenWidth * 0.032,
                    runSpacing: screenWidth * 0.032,
                    children: [
                      Chip(
                        icon: Icons.bed_outlined,
                        text: '${apartment.number_of_bedrooms}',
                      ),
                      Chip(
                        icon: Icons.bathtub_outlined,
                        text: '${apartment.number_of_bathrooms}',
                      ),
                      Chip(
                        icon: Icons.square_foot_outlined,
                        text: '${apartment.area_sq_meters} m²',
                      ),
                      Chip(
                        icon: Icons.stairs_outlined,
                        text: t.apartment_floorNumber(apartment.floor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Card(
              child: Column(
                children: [
                  RowItem(t.apartment_building, apartment.building_number),
                  RowItem(
                    t.apartment_apartment,
                    '${apartment.apartment_number}',
                  ),
                  RowItem(t.city, apartment.city),
                  RowItem(t.apartment_street, apartment.street),
                  RowItem("ID", "${apartment.id}"),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.apartment_descriptionTitle,
                    style: th.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    apartment.description_en.isEmpty
                        ? '-'
                        : apartment.description_en,
                    style: th.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: screenHeight * 0.005,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            //here we add real user info:
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.apartment_aboutOwner,
                    style: th.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      SizedBox(width: screenWidth * 0.03),
                      CircleAvatar(
                        radius: screenWidth * 0.075,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: SizedBox(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
                            child:
                                (imageUrl != null &&
                                    imageUrl.trim().isNotEmpty)
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/apartments/test.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/apartments/test.jpg',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.085),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //user name
                            apartment.owner_name,
                            style: th.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.5,
                            //bio although it wont be better than this one
                            child: Text(
                              "this is ${apartment.owner_name}, the owner of this amazing apartment",
                              style: th.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.018),
                ],
              ),
            ),

            if (footer != null) ...[
              SizedBox(height: screenHeight * 0.02),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

//makes the one card that has info
class Card extends StatelessWidget {
  const Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.transparent), // cs.outlineVariant.withAlpha(150)
      ),
      child: child,
    );
  }
}

// to not repeat the iconxNum combo 4 times
class Chip extends StatelessWidget {
  const Chip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: t.labelLarge?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

//ex Building --> 44
class RowItem extends StatelessWidget {
  const RowItem(this.title, this.value);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Text(
            value,
            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
