/// Business logic and data for home screen
/// Separated from UI for better testability and reusability
class HomeScreenUsecase {
  /// Get all available stations
  List<String> getAllStations() {
    return [
      // Western Line (Churchgate → Dahanu Road)
      'Churchgate (WR)',
      'Marine Lines (WR)',
      'Charni Road (WR)',
      'Grant Road (WR)',
      'Mumbai Central (WR)',
      'Mahalaxmi (WR)',
      'Lower Parel (WR)',
      'Prabhadevi (WR)',
      'Dadar (WR)',
      'Matunga Road (WR)',
      'Mahim (WR)',
      'Bandra (WR)',
      'Khar Road (WR)',
      'Santacruz (WR)',
      'Vile Parle (WR)',
      'Andheri (WR)',
      'Jogeshwari (WR)',
      'Ram Mandir (WR)',
      'Goregaon (WR)',
      'Malad (WR)',
      'Kandivali (WR)',
      'Borivali (WR)',
      'Dahisar (WR)',
      'Mira Road (WR)',
      'Bhayandar (WR)',
      'Naigaon (WR)',
      'Vasai Road (WR)',
      'Nalasopara (WR)',
      'Virar (WR)',
      'Vaitarna (WR)',
      'Saphale (WR)',
      'Kelve Road (WR)',
      'Palghar (WR)',
      'Umroli (WR)',
      'Boisar (WR)',
      'Vangaon (WR)',
      'Dahanu Road (WR)',

      // Central Line Main (CSMT → Kalyan)
      'CSMT (CR)',
      'Masjid (CR)',
      'Sandhurst Road (CR)',
      'Byculla (CR)',
      'Chinchpokli (CR)',
      'Currey Road (CR)',
      'Parel (CR)',
      'Dadar (CR)',
      'Matunga (CR)',
      'Sion (CR)',
      'Kurla (CR)',
      'Vidyavihar (CR)',
      'Ghatkopar (CR)',
      'Vikhroli (CR)',
      'Kanjurmarg (CR)',
      'Bhandup (CR)',
      'Nahur (CR)',
      'Mulund (CR)',
      'Thane (CR)',
      'Kalwa (CR)',
      'Mumbra (CR)',
      'Diva (CR)',
      'Kopar (CR)',
      'Dombivli (CR)',
      'Thakurli (CR)',
      'Kalyan (CR)',

      // Central Line Kasara Branch
      'Shahad (CR)',
      'Ambivli (CR)',
      'Titwala (CR)',
      'Khadavli (CR)',
      'Vasind (CR)',
      'Asangaon (CR)',
      'Kasara (CR)',

      // Central Line Karjat Branch
      'Vitthalwadi (CR)',
      'Ulhasnagar (CR)',
      'Ambernath (CR)',
      'Badlapur (CR)',
      'Vangani (CR)',
      'Shelu (CR)',
      'Neral (CR)',
      'Bhivpuri (CR)',
      'Karjat (CR)',

      // Harbour Line (CSMT → Panvel / Goregaon)
      'CSMT (HL)',
      'Masjid (HL)',
      'Sandhurst Road (HL)',
      'Dockyard Road (HL)',
      'Reay Road (HL)',
      'Cotton Green (HL)',
      'Sewri (HL)',
      'Wadala Road (HL)',
      'Guru Tegh Bahadur Nagar (HL)',
      'Chunabhatti (HL)',
      'Kurla (HL)',
      'Tilak Nagar (HL)',
      'Chembur (HL)',
      'Govandi (HL)',
      'Mankhurd (HL)',
      'Vashi (HL)',
      'Sanpada (HL)',
      'Juinagar (HL)',
      'Nerul (HL)',
      'Seawoods (HL)',
      'Belapur (HL)',
      'Kharghar (HL)',
      'Mansarovar (HL)',
      'Khandeshwar (HL)',
      'Panvel (HL)',

      // Harbour Line Goregaon Branch
      'Mahim (HL)',
      'Bandra (HL)',
      'Khar Road (HL)',
      'Santacruz (HL)',
      'Vile Parle (HL)',
      'Andheri (HL)',
      'Jogeshwari (HL)',
      'Goregaon (HL)',

      // Trans Harbour Line (Thane → Panvel / Vashi)
      'Thane (THL)',
      'Airoli (THL)',
      'Rabale (THL)',
      'Ghansoli (THL)',
      'Koparkhairane (THL)',
      'Turbhe (THL)',
      'Sanpada (THL)',
      'Vashi (THL)',
      'Juinagar (THL)',
      'Nerul (THL)',
      'Seawoods (THL)',
      'Belapur (THL)',
      'Kharghar (THL)',
      'Mansarovar (THL)',
      'Khandeshwar (THL)',
      'Panvel (THL)',
    ];
  }

  /// Validate if source and destination are different
  bool validateStations(String source, String destination) {
    return source != destination;
  }

  /// Get ticket classes available
  List<String> getTicketClasses() {
    return ['First Class', 'Second Class', 'AC Class'];
  }

  /// Get ticket types available
  List<String> getTicketTypes() {
    return ['Single', 'Return'];
  }
}
