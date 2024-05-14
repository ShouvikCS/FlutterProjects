import 'package:flutter/material.dart';

class TableElement {
  //Note: j'utilise NUM au lieu de DOUBLE car dans le JSON il y a des INT et des DOUBLE pour ces variables
  final String name;
  final String? appearance;
  final num atomicMass;
  final num? boil;
  final String category;
  final num? density;
  final String? discoveredBy;
  final num? melt;
  final num? molarHeat;
  final String? namedBy;
  final int number;
  final int period;
  final String? phase;
  final String? source;
  final String? spectralImg;
  final String? summary;
  final String symbol;
  final int xpos;
  final int ypos;
  final List<int> shells;
  final String? electronConfiguration;
  final String? electronConfigurationSemantic;
  final num? electronAffinity;
  final num? electronegativityPauling;
  final List<num> ionizationEnergies;
  final String? cpkHex;

  TableElement(
      this.name,
      this.appearance,
      this.atomicMass,
      this.boil,
      this.category,
      this.density,
      this.discoveredBy,
      this.melt,
      this.molarHeat,
      this.namedBy,
      this.number,
      this.period,
      this.phase,
      this.source,
      this.spectralImg,
      this.summary,
      this.symbol,
      this.xpos,
      this.ypos,
      this.shells,
      this.electronConfiguration,
      this.electronConfigurationSemantic,
      this.electronAffinity,
      this.electronegativityPauling,
      this.ionizationEnergies,
      this.cpkHex);

  TableElement.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        appearance = json['appearance'],
        atomicMass = json['atomic_mass'],
        boil = json['boil'],
        category = json['category'],
        density = json['density'],
        discoveredBy = json['discovered_by'],
        melt = json['melt'],
        molarHeat = json['molar_heat'],
        namedBy = json['named_by'],
        number = json['number'],
        period = json['period'],
        phase = json['phase'],
        source = json['source'],
        spectralImg = json['spectral_img'],
        summary = json['summary'],
        symbol = json['symbol'],
        xpos = json['xpos'],
        ypos = json['ypos'],
        shells = List<int>.from(json['shells']),
        electronConfiguration = json['electron_configuration'],
        electronConfigurationSemantic = json['electron_configuration_semantic'],
        electronAffinity = json['electron_affinity'],
        electronegativityPauling = json['electronegativity_pauling'],
        ionizationEnergies = List<num>.from(json['ionization_energies']),
        cpkHex = json['cpk-hex'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'appearance': appearance,
        'atomic_mass': atomicMass,
        'boil': boil,
        'category': category,
        'density': density,
        'discovered_by': discoveredBy,
        'melt': melt,
        'molar_heat': molarHeat,
        'named_by': namedBy,
        'number': number,
        'period': period,
        'phase': phase,
        'source': source,
        'spectral_img': spectralImg,
        'summary': summary,
        'symbol': symbol,
        'xpos': xpos,
        'ypos': ypos,
        'shells': List<dynamic>.from(shells),
        'electron_configuration': electronConfiguration,
        'electron_configuration_semantic': electronConfigurationSemantic,
        'electron_affinity': electronAffinity,
        'electronegativity_pauling': electronegativityPauling,
        'ionization_energies': List<dynamic>.from(ionizationEnergies),
        'cpk_hex': cpkHex,
      };
}
