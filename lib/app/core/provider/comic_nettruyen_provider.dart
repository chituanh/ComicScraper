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

  loadComic(String url) async {
    final urlXin = Uri.parse(url);
    if (await domain.loadWebPage(urlXin.path)) {
      print('vào đây');
      return getInfoComic();
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

  getInfoComic() {
    final res = {};

    domain.getElement('html > body > form > main > div > div > div > article > h1', []).forEach((e) {
      res['name'] = e['title'];
    });
    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > img', ['src']).forEach((e) {
      res['image'] = 'http:' + e['attributes']['src'];
    });
    domain.getElement('html > body > form > main > div > div > div > article > time', []).forEach((e) {
      res['timeUpdate'] = e['title'].toString().trim();
    });
    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > ul > li.author.row > p', []).forEach((e) {
      res['author'] = e['title'].toString().trim();
    });
    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > ul > li.author.row > p', []).forEach((e) {
      res['author'] = e['title'].toString().trim();
    });
    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > ul > li.status.row > p', []).forEach((e) {
      res['status'] = e['title'].toString().trim();
    });

    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > ul > li.status.row > p', []).forEach((e) {
      res['status'] = e['title'].toString().trim();
    });
    // res['kind'] = [];
    // domain.getElement('html > body > form > main > div > div > div > article > div > div > div > ul > li.kind.row > p > a', ['href']).forEach((e) {
    //   res['kind'].add({
    //     'kind_title': e['title'],
    //     'kind_href': e['attributes']['href'],
    //   });
    // });

    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > div.mrt5.mrb10 > span', []).forEach((e) {
      res['rank'] = e['title'].toString().trim().split(' - ').first;
      res['evaluate'] = int.parse(e['title'].toString().trim().split(' - ').last.split(' ').first);
    });

    domain.getElement('html > body > form > main > div > div > div > article > div > div > div > div.follow > span', []).forEach((e) {
      res['follow'] = e['title'].toString().trim().split(' ').first;
    });

    // domain.getElement('html > body > form > main > div > div > div > article > div.detail-content > p', []).forEach((e) {
    //   res['content'] = e['title'].toString().trim().replaceAll('\n', ' ');
    // });

    res['list_chapter'] = [];
    domain.getElement('html > body > form > main > div > div > div > article > div.list-chapter > nav > ul > li > div > a', ['href']).forEach((e) {
      res['list_chapter'].add({
        'name': e['title'].toString().trim(),
        'href': e['attributes']['href'].toString().trim(),
      });
    });
    int i = 0;
    domain.getElement(
        'html > body > form > main > div > div > div > article > div.list-chapter > nav > ul > li > div.col-xs-4.text-center.small', []).forEach((e) {
      res['list_chapter'][i]['time'] = e['title'].trim();
      i++;
    });
    i = 0;
    domain.getElement(
        'html > body > form > main > div > div > div > article > div.list-chapter > nav > ul > li > div.col-xs-3.text-center.small', []).forEach((e) {
      res['list_chapter'][i]['view'] = e['title'].trim();
      i++;
    });

    // /html/body/form/main/div[2]/div/div[1]/article/div[3]/nav/ul

    return res;
  }
}
