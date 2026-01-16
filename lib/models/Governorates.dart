import 'package:flutter/material.dart';
import 'package:project/generated/l10n/app_localizations.dart';

class Governorates {
  // govs list like the backend
  static final List<String> keys = [
    'damascus',
    'rif_damascus',
    'aleppo',
    'homs',
    'hama',
    'latakia',
    'tartous',
    'idlib',
    'daraa',
    'as_suwayda',
    'quneitra',
    'deir_ezzor',
    'al_hasakah',
    'raqqa',
  ];

   static String labelByIndex(BuildContext context, int index) {
    final t = AppLocalizations.of(context)!;

    if (index < 0 || index >= keys.length) return '';

    switch (keys[index]) {
      case 'damascus':
        return t.gov_damascus;
      case 'rif_damascus':
        return t.gov_rifDamascus;
      case 'aleppo':
        return t.gov_aleppo;
      case 'homs':
        return t.gov_homs;
      case 'hama':
        return t.gov_hama;
      case 'latakia':
        return t.gov_latakia;
      case 'tartous':
        return t.gov_tartous;
      case 'idlib':
        return t.gov_idlib;
      case 'daraa':
        return t.gov_daraa;
      case 'as_suwayda':
        return t.gov_asSuwayda;
      case 'quneitra':
        return t.gov_quneitra;
      case 'deir_ezzor':
        return t.gov_deirEzzor;
      case 'al_hasakah':
        return t.gov_alHasakah;
      case 'raqqa':
        return t.gov_raqqa;
      default:
        return '';
    }
  }
}