import 'package:doc_truyen_tranh/app/core/provider/comic_nettruyen_provider.dart';
import 'package:doc_truyen_tranh/app/env/env.dart';
import 'package:get/get.dart';
import 'package:web_scraper/web_scraper.dart';

class HomeController extends GetxController {
  List<String> data = <String>[];

  init() async {
    final data = await ComicNettruyenProvider.instance.loadHomePage();
    print(data);
  }

  fetchData() async {
    final webScr = WebScraper('https://truyenkinhdien.com');

    if (await webScr.loadWebPage('/truyen-tranh/truyen-tranh-one-punch-man-doc-online-full')) {
      for (int i = 1; i < 10000; i++) {
        List<Map<String, dynamic>> elements = webScr.getElement(Env.e.strLickChap(i), ['href', 'title']);

        if (elements.isEmpty) break;

        data.add(elements[0]['title']);
      }
      update();
    }
  }
}
