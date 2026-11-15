/// Tüm veriler tek yerde. Kaynaklar README'de.

class CompareStat {
  final String label;
  final double messi;
  final double ronaldo;
  final bool lowerIsBetter;
  final String suffix;
  final int decimals;
  final String? note;

  const CompareStat(
    this.label,
    this.messi,
    this.ronaldo, {
    this.lowerIsBetter = false,
    this.suffix = '',
    this.decimals = 0,
    this.note,
  });

  /// 1 = Messi önde, -1 = Ronaldo önde, 0 = eşit
  int get leader {
    if (messi == ronaldo) return 0;
    final messiHigher = messi > ronaldo;
    return (messiHigher ^ lowerIsBetter) ? 1 : -1;
  }

  String fmt(double v) => '${v.toStringAsFixed(decimals)}$suffix';
}

class StatGroup {
  final String title;
  final String subtitle;
  final List<CompareStat> stats;
  const StatGroup(this.title, this.subtitle, this.stats);
}

// ---------------- VERSUS ----------------

/// İspanya'daki kulüp kupaları — Messi: Barcelona 2004–21, Ronaldo: Real Madrid 2009–18
const clubTrophies = <CompareStat>[
  CompareStat('LaLiga', 10, 2),
  CompareStat('UEFA Champions League', 4, 4),
  CompareStat('Copa del Rey', 7, 2),
  CompareStat('Supercopa de España', 8, 2),
  CompareStat('UEFA Super Cup', 3, 2),
  CompareStat('FIFA Club World Cup', 3, 3),
];

/// İspanya yıllarında kazanılan bireysel ödüller
const individualAwards = <CompareStat>[
  CompareStat("Ballon d'Or", 6, 4, note: 'Messi: 09·10·11·12·15·19  —  Ronaldo: 13·14·16·17'),
  CompareStat('Pichichi (LaLiga gol kralı)', 8, 3),
  CompareStat('Avrupa Altın Ayakkabı', 6, 3),
  CompareStat('FIFA The Best', 1, 2),
];

const elClasico = <CompareStat>[
  CompareStat('El Clásico golü', 26, 18,
      note: 'Messi Clásico tarihinin gol rekortmeni; 14 asistle asist rekoru da onda'),
];

/// 2009–2018: ikisinin de İspanya'da olduğu dönem, tüm turnuvalar (Opta)
const versusGroups = <StatGroup>[
  StatGroup('Goller & Asistler', 'İspanya yılları 2009–2018 · tüm turnuvalar', [
    CompareStat('Maç', 476, 438, note: 'Karşılaştırma için referans'),
    CompareStat('Gol', 472, 450),
    CompareStat('Asist', 177, 131),
    CompareStat('Gol + Asist', 649, 581),
    CompareStat('Hat-trick', 39, 43),
  ]),
  StatGroup('Duran Toplar', 'İspanya yılları 2009–2018 · tüm turnuvalar', [
    CompareStat('Frikik golü', 33, 33),
    CompareStat('Penaltı golü', 56, 79),
    CompareStat('Penaltı isabeti', 75.7, 85.9, suffix: '%', decimals: 1),
  ]),
  StatGroup('Çalım & Oyun Kurma', 'LaLiga 2009–2015 · 90 dk başına (Opta)', [
    CompareStat('Denenen çalım / 90', 8.5, 4.2, decimals: 1),
    CompareStat('Çalım başarısı', 59.1, 49.4, suffix: '%', decimals: 1),
    CompareStat('Key pass / sezon', 70, 65, note: 'Sezon ortalaması'),
    CompareStat('İsabetli pas / 90', 59.3, 36.7, decimals: 1),
    CompareStat('Pas isabeti', 84.6, 79.1, suffix: '%', decimals: 1),
  ]),
  StatGroup('Verimlilik', 'İspanya yılları 2009–2018 · dakika başına (düşük = iyi)', [
    CompareStat('Dakika / gol', 85, 84, lowerIsBetter: true),
    CompareStat('Dakika / penaltısız gol', 96, 101, lowerIsBetter: true),
    CompareStat('Dakika / gol katkısı', 62, 66, lowerIsBetter: true),
  ]),
];

/// LaLiga sezon bazlı goller (aynı ligde geçen 9 sezon)
const sharedSeasons = ['09/10', '10/11', '11/12', '12/13', '13/14', '14/15', '15/16', '16/17', '17/18'];
const messiSharedGoals = [34, 31, 50, 46, 28, 43, 26, 37, 34];
const ronaldoSharedGoals = [26, 40, 46, 34, 31, 48, 35, 25, 26];

// ---------------- WHY MESSI IS COMPLETE ----------------

class Pillar {
  final String title;
  final String tagline;
  final String bigNumber;
  final String bigLabel;
  final List<String> facts;
  const Pillar(this.title, this.tagline, this.bigNumber, this.bigLabel, this.facts);
}

const pillars = <Pillar>[
  Pillar(
    'THE PLAYMAKER',
    'He scores like a striker and thinks like a number 10.',
    '192',
    'LaLiga asisti — tüm zamanların rekoru',
    [
      'Bir LaLiga sezonunda rekor 21 asist (2019/20)',
      'Aynı sezonda 20+ gol ve 20+ asist yapan tek LaLiga oyuncusu',
      '90 dakikada 59.3 isabetli pas — Ronaldo: 36.7',
    ],
  ),
  Pillar(
    'THE FINISHER',
    'The greatest goalscorer Spain has ever seen.',
    '474',
    'LaLiga golü — 520 maçta',
    [
      'Tek LaLiga sezonunda 50 gol (2011/12)',
      '2012 takvim yılında 91 gol — Guinness rekoru',
      'Rekor 8 Pichichi ödülü',
    ],
  ),
  Pillar(
    'THE SET-PIECE MASTER',
    'A dead ball is a live threat.',
    '39',
    'Direkt frikik golü — LaLiga rekoru',
    [
      'LaLiga frikik rekorunu Ronaldo\'dan devraldı',
      'Hem gol kralı hem asist kralı olduğu 3 sezon (11/12, 17/18, 19/20)',
    ],
  ),
  Pillar(
    'THE DRIBBLER',
    'The ball never leaves his left foot.',
    '8.5',
    'Denenen çalım / 90 dk — %59.1 başarı',
    [
      'Ronaldo aynı dönemde: 4.2 çalım / 90, %49.4 başarı',
      'Çalım sayısında iki kattan fazla, başarı oranında +10 puan',
    ],
  ),
];

/// Radar: aynı dönem verilerinden göreli endeks (lider = 100)
const radarAxes = ['Gol', 'Asist', 'Çalım', 'Key Pass', 'Pas', 'Frikik'];
const radarMessi = [100.0, 100.0, 100.0, 100.0, 100.0, 100.0];
const radarRonaldo = [95.0, 74.0, 49.0, 93.0, 62.0, 100.0];

// ---------------- RECORDS ----------------

enum RecordCat { laliga, europe, world }

class RecordItem {
  final String number;
  final String title;
  final String detail;
  final RecordCat cat;
  final bool hero;
  const RecordItem(this.number, this.title, this.detail, this.cat, {this.hero = false});
}

const records = <RecordItem>[
  // ---- hero (en üstte büyük kartlar) ----
  RecordItem('91', 'Bir takvim yılında gol', "2012 yılında 91 resmi gol. Gerd Müller'in 40 yıllık 85 golünü geçti. Guinness Dünya Rekoru.", RecordCat.world, hero: true),
  RecordItem('73', 'Tek sezonda gol', '2011/12 sezonunda tüm turnuvalarda 73 gol. Bunların 50\'si LaLiga\'da.', RecordCat.laliga, hero: true),
  RecordItem('5', 'Tek Şampiyonlar Ligi maçında gol', "7 Mart 2012, Barcelona 7–1 Leverkusen. Şampiyonlar Ligi tarihinde bir maçta 5 gol atan ilk oyuncu.", RecordCat.europe, hero: true),
  RecordItem('5/5', 'Dünya Kupası\'nın her turunda gol', '2022: grup, son 16, çeyrek final, yarı final ve final. Bugünkü formatta her turda gol atan ilk oyuncu.', RecordCat.world, hero: true),

  // ---- LaLiga ----
  RecordItem('474', 'LaLiga golü', '520 maçta. Ligin tüm zamanlar gol kralı; en yakın takipçi 311.', RecordCat.laliga),
  RecordItem('50', 'Tek LaLiga sezonunda gol', '2011/12 sezonunda 37 maçta 50 gol. Lig rekoru.', RecordCat.laliga),
  RecordItem('21', 'Üst üste gol attığı LaLiga maçı', '2012/13: 21 maçta durmadan 33 gol. Ligdeki tüm rakiplere art arda gol attı.', RecordCat.laliga),
  RecordItem('36', 'LaLiga hat-trick', '31 hat-trick + 5 kez dört gol. Lig rekoru.', RecordCat.laliga),
  RecordItem('116', 'LaLiga\'da 2 gollü maç', 'LaLiga tarihinde en çok 2 gol atılan maç sayısı.', RecordCat.laliga),
  RecordItem('277', 'LaLiga iç saha golü', 'Deplasmanda da rekor: 197 gol. İkisi de lig tarihinin en fazlası.', RecordCat.laliga),
  RecordItem('39', 'LaLiga frikik golü', 'Direkt frikikten en çok gol atan LaLiga oyuncusu.', RecordCat.laliga),
  RecordItem('8', 'Pichichi ödülü', 'LaLiga gol krallığı. Son 5\'ini üst üste kazandı.', RecordCat.laliga),
  RecordItem('9', '30+ gollü LaLiga sezonu', '9 ayrı sezonda ligde 30 ve üzeri gol atan tek oyuncu.', RecordCat.laliga),
  RecordItem('26', 'El Clásico golü', "Real Madrid'e karşı tarihin en golcü oyuncusu.", RecordCat.laliga),

  // ---- Avrupa ----
  RecordItem('672', 'Barcelona golü', 'Bir kulüp için atılmış en fazla gol. 778 maç.', RecordCat.europe),
  RecordItem('6', 'Avrupa Altın Ayakkabı', 'Tarihte en çok Altın Ayakkabı kazanan oyuncu.', RecordCat.europe),
  RecordItem('6', 'Kez Şampiyonlar Ligi gol kralı', 'Üst üste 3 sezon gol krallığı yaşayan ilk oyuncu.', RecordCat.europe),
  RecordItem('4', 'ŞL çeyrek finalinde tek maçta gol', 'Barcelona – Arsenal, 6 Nisan 2010. Çeyrek final rekoru.', RecordCat.europe),
  RecordItem('80', 'ŞL grup aşaması golü', 'Şampiyonlar Ligi grup/lig aşamasında en çok gol.', RecordCat.europe),
  RecordItem('48', 'Barcelona hat-trick\'i', '41 hat-trick, 6 kez dört gol, 1 kez beş gol.', RecordCat.europe),

  // ---- Dünya ----
  RecordItem('900+', 'Kariyer golü', 'Kulüp ve milli takımda toplam 900\'ü aşkın resmi gol.', RecordCat.world),
  RecordItem('8', "Ballon d'Or", "Tarihte en çok Ballon d'Or kazanan oyuncu.", RecordCat.world),
  RecordItem('7', '2022 Dünya Kupası golü', 'Katar\'da 7 gol + 3 asist; Arjantin şampiyon oldu.', RecordCat.world),
];

/// Messi LaLiga gol grafiği (2004/05 – 2020/21)
const messiAllSeasons = ['04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'];
const messiAllGoals = [1, 6, 14, 10, 23, 34, 31, 50, 46, 28, 43, 26, 37, 34, 36, 25, 30];

// ---------------- QUOTES ----------------

class Quote {
  final String text;
  final String author;
  final String role;
  const Quote(this.text, this.author, this.role);
}

const quotes = <Quote>[
  Quote("Don't write about him, don't try to describe him. Just watch him.", 'Pep Guardiola', 'Teknik direktör'),
  Quote('I look for weaknesses in his game and I can\'t find them.', 'Pep Guardiola', 'Teknik direktör'),
  Quote('Who is the best player in the world? Leo Messi. Who is the best player ever? Leo Messi.', 'Arsène Wenger', 'Teknik direktör'),
  Quote('I have seen the player who will inherit my place in Argentine football and his name is Messi.', 'Diego Maradona', 'Efsane'),
  Quote('Is Messi a real player or a PlayStation character?', 'Radamel Falcao', 'Forvet'),
  Quote('Although he may not be human, it\'s good that Messi still thinks he is.', 'Javier Mascherano', 'Takım arkadaşı'),
  Quote('…without doubt, Messi is better than Maradona.', 'Diego Simeone', 'Teknik direktör'),
  Quote("There is no doubt, you're from another galaxy. Thanks Leo.", 'Maxi Rodríguez', 'Milli takım arkadaşı'),
];

// ---------------- INDIVIDUAL AWARDS ----------------

enum AwardCat { world, europe, national, iffhs, mls }

class AwardItem {
  final String count;
  final String name;
  final String years;
  final AwardCat cat;
  final String? note;
  const AwardItem(this.count, this.name, this.years, this.cat, {this.note});
}

const awardCatLabels = {
  AwardCat.world: 'DÜNYA',
  AwardCat.europe: 'AVRUPA',
  AwardCat.national: 'MİLLİ',
  AwardCat.iffhs: 'IFFHS',
  AwardCat.mls: 'MLS',
};

/// En üstteki 3 büyük kart
const bigThreeAwards = <AwardItem>[
  AwardItem('8', "Ballon d'Or", '2009 · 10 · 11 · 12 · 15 · 19 · 21 · 23', AwardCat.world, note: 'Tarihte en çok'),
  AwardItem('8', 'FIFA Yılın Oyuncusu', '2009 · 10 · 11 · 12 · 15 · 19 · 22 · 23', AwardCat.world, note: 'World Player / FIFA Ballon d\'Or / The Best'),
  AwardItem('2', 'Dünya Kupası Altın Top', '2014 · 2022', AwardCat.national, note: 'Turnuva MVP\'si — iki kez kazanan tek oyuncu'),
];

const awards = <AwardItem>[
  // Dünya
  AwardItem('17', 'FIFPro Dünya 11\'i', '17 kez yılın en iyi 11\'inde', AwardCat.world),
  AwardItem('2', 'Laureus Yılın Sporcusu', '2020 · 2023', AwardCat.world, note: 'Tüm spor dallarında yılın erkek sporcusu'),
  AwardItem('2', 'Kulüpler Dünya Kupası Altın Top', '2009 · 2011', AwardCat.world),
  AwardItem('1', 'TIME Yılın Sporcusu', '2023', AwardCat.world),
  // Avrupa
  AwardItem('6', 'Avrupa Altın Ayakkabı', '2010 · 12 · 13 · 17 · 18 · 19', AwardCat.europe, note: 'Tarihte en çok'),
  AwardItem('6', 'Şampiyonlar Ligi gol krallığı', '2009 · 10 · 11 · 12 · 15 · 19', AwardCat.europe),
  AwardItem('9', 'LaLiga Yılın Oyuncusu', '9 kez', AwardCat.europe),
  AwardItem('8', 'Pichichi (LaLiga gol kralı)', '2010 · 12 · 13 · 17 · 18 · 19 · 20 · 21', AwardCat.europe),
  AwardItem('2', 'UEFA Yılın Oyuncusu', '2010/11 · 2014/15', AwardCat.europe),
  AwardItem('1', 'UEFA Kulüp Futbolcusu', '2008/09', AwardCat.europe),
  // Milli
  AwardItem('2', 'Copa América MVP', '2015 · 2021', AwardCat.national),
  AwardItem('1', 'Dünya Kupası Gümüş Ayakkabı', '2022', AwardCat.national),
  AwardItem('2', 'U-20 Dünya Kupası Altın Top + Gol Kralı', '2005', AwardCat.national),
  // IFFHS
  AwardItem('1', 'IFFHS Tüm Zamanların En İyi Oyuncusu', '2025', AwardCat.iffhs),
  AwardItem('1', 'IFFHS On Yılın Oyuncusu', '2011 – 2020', AwardCat.iffhs),
  AwardItem('1', 'IFFHS Dünyanın En İyi Oyuncusu', '2022', AwardCat.iffhs),
  AwardItem('5', 'IFFHS Dünyanın En İyi Oyun Kurucusu', '2015 · 16 · 17 · 19 · 22', AwardCat.iffhs, note: 'Rekor'),
  // MLS
  AwardItem('2', 'MLS MVP (Landon Donovan)', '2024 · 2025', AwardCat.mls, note: 'Üst üste kazanan ilk oyuncu'),
  AwardItem('1', 'MLS Altın Ayakkabı', '2025 · 29 gol', AwardCat.mls),
];

// ---------------- MİLLİ TAKIM (Arjantin vs Portekiz) ----------------
// İkisi de 2026 Dünya Kupası sonrası milli takımı bıraktı; sayılar kesinleşti.

const nationalTrophies = <CompareStat>[
  CompareStat('Dünya Kupası', 1, 0, note: 'Messi: 2022 · ayrıca 2014 ve 2026 finalleri'),
  CompareStat('Kıta şampiyonluğu', 2, 1, note: 'Copa América 2021, 2024  —  EURO 2016'),
  CompareStat('Finalissima', 1, 0),
  CompareStat('UEFA Uluslar Ligi', 0, 2, note: 'Portekiz: 2019, 2025 · Arjantin bu turnuvada yok'),
];

const nationalGroups = <StatGroup>[
  StatGroup('Milli Takım Kariyeri', 'Arjantin 2005–2026  ·  Portekiz 2003–2026', [
    CompareStat('Maç', 207, 234, note: 'Ronaldo: erkeklerde dünya rekoru'),
    CompareStat('Gol', 125, 146, note: 'Ronaldo: erkeklerde dünya rekoru'),
    CompareStat('Asist', 68, 45, note: 'Messi: milli takımlarda dünya rekoru'),
    CompareStat('Gol + Asist', 193, 191),
  ]),
  StatGroup('Dünya Kupası', 'İkisi de 6 Dünya Kupası\'nda oynadı (2006–2026)', [
    CompareStat('Dünya Kupası golü', 21, 11),
    CompareStat('Dünya Kupası asisti', 12, 2, note: 'Messi: Dünya Kupası tarihinin asist rekoru'),
    CompareStat('Oynanan final', 3, 0),
    CompareStat('Altın Top (turnuvanın en iyisi)', 2, 0, note: 'Messi: 2014 ve 2022 · iki kez kazanan tek oyuncu'),
  ]),
];
