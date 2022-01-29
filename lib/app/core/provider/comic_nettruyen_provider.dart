import 'package:web_scraper/web_scraper.dart';

class ComicNettruyenProvider {
  static ComicNettruyenProvider instance = ComicNettruyenProvider();

  final domain = WebScraper('http://www.nettruyengo.com');

  final addressTruyenDuCu =
      'html > body > form > main > div.container > div.altcontent1.cmszone > div.top-comics.Module.Module-183 > div > div > div > div';

  final addressTruyenMoiCapNhat =
      'html > body > form > main > div.container > div.row > div.center-side.col-md-8 > div > div > div > div > div > figure';

  loadHomePage() async {
    if (await domain.loadWebPage('/')) {
      return {
        'truyen_de_cu': getTruyenDeCu(),
        'truyen_moi_cap_nhat': getTruyenMoiCapNhat(),
      };
    }
  }

  getTruyenDeCu() {
    final res = [];
    domain.getElement('$addressTruyenDuCu > div > h3 > a', ['href', 'title']).forEach((element) {
      res.add(element['attributes']);
    });
    int i = 0;
    domain.getElement('$addressTruyenDuCu > div > a', ['title']).forEach((element) {
      res[i]['chapter'] = element['attributes']['title'];
      i++;
    });
    i = 0;
    domain.getElement('$addressTruyenDuCu > div > span', ['title']).forEach((element) {
      res[i]['time'] = element['title'].toString().trim();
      i++;
    });
    i = 0;
    domain.getElement('$addressTruyenDuCu > a > img', ['src']).forEach((element) {
      res[i]['chapter'] = 'http:' + element['attributes']['src'].toString().trim();
      i++;
    });
    return res;
  }

  getTruyenMoiCapNhat() {
    final res = [];
    domain.getElement('$addressTruyenMoiCapNhat > div > a', ['title', 'href']).forEach((element) {
      res.add(element['attributes']);
    });

    int i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > div > div', ['title', 'href']).forEach((element) {
      final temp = element['title'].toString().trim().split('  ');
      res[i]['eye'] = temp[0];
      res[i]['comment'] = temp[1];
      res[i]['heart'] = temp[2];
      i++;
    });

    i = 0;
    for (int j = 0; j < res.length; j++) {
      res[j]['listChapter'] = [];
    }
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(1) > a', ['title', 'href']).forEach((element) {
      res[i]['listChapter'].add(element['attributes']);
      i++;
    });
    i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(1) > i', []).forEach((element) {
      res[i]['listChapter'][0]['time'] = element['title'];
      i++;
    });

    i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(2) > a', ['title', 'href']).forEach((element) {
      res[i]['listChapter'].add(element['attributes']);
      i++;
    });
    i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(2) > i', []).forEach((element) {
      res[i]['listChapter'][1]['time'] = element['title'];

      i++;
    });

    i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(3) > a', ['title', 'href']).forEach((e) {
      if (e.isNotEmpty) {
        res[i]['listChapter'].add(e['attributes']);
      } else {
        res[i]['listChapter'] = 'cay';
      }
      i++;
    });
    i = 0;
    domain.getElement('$addressTruyenMoiCapNhat > figcaption > ul > li:nth-child(3) > i', []).forEach((e) {
      if (e.isNotEmpty) res[i]['listChapter'][2]['time'] = e['title'];
      i++;
    });

    return res;
  }
}
