import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/brand_model.dart';
import 'package:app/models/device_feature_model.dart';
import 'package:app/models/device_list_overview_model.dart';
import 'package:app/models/device_specs_model.dart';
import 'package:app/models/devices_comparison_model.dart';
import 'package:app/models/devices_overview_list_model.dart';
import 'package:app/models/detailed_news_model.dart';
import 'package:app/models/news_overview_model.dart';
import 'package:app/models/specs_model.dart';
import 'package:app/models/two_device_comparison_model.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:string_similarity/string_similarity.dart';

import '../models/device_overview_model.dart';

abstract class BaseGsmarenaRepostiory {
  Future<List<DeviceOverviewModel>> getLatestDevicesOverview([
    bool refreshData = false,
    int maxLength = 14,
  ]);
  Future<List<DeviceOverviewModel>> getPopularDevicesOverview([
    bool refreshData = false,
    int maxLength = 9,
  ]);
  Future<List<DeviceOverviewModel>> getRumouredDevicesOverview([
    int maxLength = 16,
  ]);
  Future<DevicesOverviewListModel> getBrandDevicesOverview(String urlEndpoint);
  Future<List<DeviceDetailedOverviewModel>> getBrandDevicesDetails(
    String brandName,
  );
  Future<List<DeviceOverviewModel>> getAllSearchedDevicesOverview(
    String query, [
    int? maxLength,
  ]);
  Future<DeviceOverviewModel?> getOneDeviceOverviewByName(String deviceName);
  Future<List<BrandModel>> getBrandsList([bool refreshData = false]);
  Future<List<BrandModel>> getAllBrandsList();
  Future<DeviceSpecsModel> getDeviceSpecs(String urlEndpoint);
  Future<DevicesComparisonModel> compareDevices(List<String> ids);
  Future<List<TwoDeviceComparisonModel>> getPopularComparisons([
    bool refreshData = false,
  ]);
  Future<List<NewsOverviewModel>> getTechNews();
  Future<DetailedNewsModel> getDetailedNews(String urlEndpoint);
}

class GsmarenaRepository implements BaseGsmarenaRepostiory {
  String get _baseUrl => 'https://gsmarena.com/';
  BeautifulSoup? _gsmarenaHomepage;
  final Dio _dio = Dio();

  /// Centralized error-handling and HTML scraping
  Future<BeautifulSoup> _scrapWebpage(
    String url, {
    Map<String, dynamic>? queryParameters,
    String? defaultErrorMessage,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return BeautifulSoup(response.data);
    } on DioException catch (e) {
      final data = e.response;
      throw _customException(data, defaultErrorMessage);
    }
  }

  /// Helper to wrap all repository methods for error handling
  CustomException _customException(Response? response, String? customMessage) =>
      CustomException(
        code: response?.statusMessage?.toString() ?? 'Failed',
        message:
            response?.statusMessage ??
            customMessage ??
            'Something went wrong! Please check your internet connection.',
      );

  Future<BeautifulSoup> _getGsmarenaHomepage([bool refresh = false]) async {
    if (_gsmarenaHomepage == null || refresh) {
      _gsmarenaHomepage = await _scrapWebpage(_baseUrl);
    }
    return _gsmarenaHomepage!;
  }

  List<DeviceOverviewModel> _getDevicesOverview(
    List<Bs4Element> elements, {
    includeImgTitle = false,
  }) {
    return elements.map((e) {
      final deviceName = e.text;
      final imgUrl = e.find('img')?.getAttrValue('src');
      final imgTitle = includeImgTitle
          ? e.find('img')?.getAttrValue('title')?.split('.')[1]
          : null;
      final href = e.getAttrValue('href');
      final deviceId = href!.split('-').last.replaceAll('.php', '');
      return DeviceOverviewModel(
        id: deviceId,
        name: deviceName,
        link: href,
        imgUrl: imgUrl!,
        subtitle: imgTitle,
      );
    }).toList();
  }

  Future<T> _safe<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (e) {
      if (e is CustomException) rethrow;
      throw CustomException(code: '500', message: e.toString());
    }
  }

  @override
  Future<List<DeviceOverviewModel>> getLatestDevicesOverview([
    bool refreshData = false,
    int maxLength = 14,
  ]) => _safe(() async {
    final soup = _gsmarenaHomepage ?? await _getGsmarenaHomepage(refreshData);
    final selector = soup
        .findAll('a', selector: '.module-latest a')
        .take(maxLength)
        .toList();
    return _getDevicesOverview(selector);
  });

  @override
  Future<List<DeviceOverviewModel>> getPopularDevicesOverview([
    bool refreshData = false,
    int maxLength = 9,
  ]) => _safe(() async {
    final soup = _gsmarenaHomepage ?? await _getGsmarenaHomepage(refreshData);
    final popularDeviceModule = soup.findAll(
      'dev',
      selector: '.module-latest',
    )[1];
    final selector = popularDeviceModule.findAll('a').take(maxLength).toList();
    return _getDevicesOverview(selector);
  });

  @override
  Future<List<DeviceOverviewModel>> getRumouredDevicesOverview([
    int maxLength = 16,
  ]) => _safe(() async {
    final soup = await _scrapWebpage('${_baseUrl}rumored.php3');
    final selector = soup
        .findAll('a', selector: '.makers ul li a')
        .take(maxLength)
        .toList();
    return _getDevicesOverview(selector);
  });

  @override
  Future<DevicesOverviewListModel> getBrandDevicesOverview(
    String urlEndpoint, [
    int page = 1,
  ]) => _safe(() async {
    String transformedEndpoint = urlEndpoint;
    final lastIndexOfDash = urlEndpoint.lastIndexOf('-');
    if (urlEndpoint.contains('-f-')) {
      transformedEndpoint =
          '${urlEndpoint.substring(0, lastIndexOfDash + 1)}p$page.png';
    } else if (page > 1) {
      final brandIdNumber = urlEndpoint.split('-').last.replaceAll('.php', '');
      transformedEndpoint =
          '${urlEndpoint.substring(0, lastIndexOfDash + 1)}f-$brandIdNumber-0-p$page.php';
    }
    final soup = await _scrapWebpage('$_baseUrl$transformedEndpoint');
    final selector = soup.findAll('a', selector: '.makers li a');
    final devicesOverview = _getDevicesOverview(selector);
    final totalPageAnchors = soup.findAll('a', selector: '.nav-pages > a');
    final totalPageCount = int.parse(
      totalPageAnchors.isNotEmpty
          ? totalPageAnchors[totalPageAnchors.length - 2].text
          : '1',
    );
    return DevicesOverviewListModel(
      devices: devicesOverview,
      totalPages: totalPageCount,
    );
  });

  @override
  Future<List<DeviceDetailedOverviewModel>> getBrandDevicesDetails(
    String brandName,
  ) => _safe(() async {
    final brandNameLowercased = brandName.toLowerCase();
    final soup = await _scrapWebpage(
      'https://www.mysmartprice.com/mobile/pricelist/$brandNameLowercased-mobile-price-list-in-india.html',
    );
    final devicesOverviewWithSpecs = soup
        .findAll(
          'div',
          selector: '.products-list > .spec_card:not(.js-recent-hideshow)',
        )
        .map((productDiv) {
          final productImgSrc =
              productDiv
                  .find('img', selector: '.prdt_sldr .js-list-slider img')
                  ?.getAttrValue('src') ??
              'https://assets.mspimages.in/c/tr:h-300,t-true/22734-1734325509-2.jpg';
          final productName =
              productDiv.find('h2', selector: '.txt-w-b.txt-heading')?.text ??
              'Apple iPhone 16 Pro Max';
          final launchData =
              productDiv.find('span', selector: '.r_date > .date')?.text ??
              '13 Sep, 2024';
          final productPrice =
              productDiv.find('span', selector: '.price.txt-w-b')?.text ??
              '₹135,900';
          final productSpecs = productDiv.findAll(
            'ul',
            selector: '.fltr_specs > .port_specs',
          );
          final leftSideSpecs = productSpecs.first.children;
          final rightSideSpecs = productSpecs.last.children;
          final lssl = leftSideSpecs.length;
          final processor = lssl <= 0
              ? null
              : leftSideSpecs[0].getAttrValue('title');
          final rearCam = lssl <= 1
              ? null
              : leftSideSpecs[1].getAttrValue('title');
          final frontCam = lssl <= 2
              ? null
              : leftSideSpecs[2].getAttrValue('title');
          final display = lssl <= 3
              ? null
              : leftSideSpecs[3].getAttrValue('title');
          final rssl = rightSideSpecs.length;
          final ramStorage = rssl <= 0
              ? null
              : rightSideSpecs[0].getAttrValue('title');
          final battery = rssl <= 1
              ? null
              : rightSideSpecs[1].getAttrValue('title');
          final software = rssl <= 2
              ? null
              : rightSideSpecs[2].getAttrValue('title');
          final hardware = rssl <= 3
              ? null
              : rightSideSpecs[3].getAttrValue('title');
          final List<String> productImages = [];
          final lastIndexOfDash = productImgSrc.lastIndexOf('-');
          final lastIndexOfDot = productImgSrc.lastIndexOf('.');
          for (var i = 0; i <= 3; i++) {
            final generatedImgLink =
                productImgSrc.substring(0, lastIndexOfDash + 1) +
                (i + 1).toString() +
                productImgSrc.substring(lastIndexOfDot);
            productImages.add(generatedImgLink);
          }
          return DeviceDetailedOverviewModel(
            name: productName,
            price: productPrice,
            launchDate: launchData,
            images: productImages,
            processor: processor,
            rearCam: rearCam,
            frontCam: frontCam,
            display: display,
            ramStorage: ramStorage,
            battery: battery,
            software: software,
            hardware: hardware,
          );
        })
        .toList();
    return devicesOverviewWithSpecs;
  });

  @override
  Future<List<BrandModel>> getBrandsList([bool refreshData = false]) => _safe(
    () async {
      final soup = _gsmarenaHomepage ?? await _getGsmarenaHomepage(refreshData);
      final brands = soup.findAll('a', selector: '.brandmenu-v2 li a').map((
        anchor,
      ) {
        final href = anchor.getAttrValue('href');
        final name = anchor.text;
        final imgUrl = 'https://logo.clearbit.com/$name.com';
        return BrandModel(name: name, link: href!, imgUrl: imgUrl);
      }).toList();
      return brands;
    },
  );

  @override
  Future<List<BrandModel>> getAllBrandsList() => _safe(() async {
    final soup = await _scrapWebpage('${_baseUrl}makers.php3');
    final brands = soup.findAll('a', selector: 'table a').map((anchor) {
      final href = anchor.getAttrValue('href');
      final name = href!.split('-')[0];
      final imgUrl = 'https://logo.clearbit.com/$name.com';
      return BrandModel(name: name, link: href, imgUrl: imgUrl);
    }).toList();
    return brands;
  });

  @override
  Future<List<DeviceOverviewModel>> getAllSearchedDevicesOverview(
    String query, [
    int? maxLength,
  ]) => _safe(() async {
    final soup = await _scrapWebpage(
      '${_baseUrl}results.php3?sQuickSearch=yes&sName=$query',
    );
    final selector = soup.findAll('a', selector: '.makers ul li a');
    final devices = _getDevicesOverview(selector, includeImgTitle: true);
    devices.sort(
      (a, b) =>
          query.similarityTo(b.name).compareTo(query.similarityTo(a.name)),
    );
    if (maxLength != null) return devices.take(maxLength).toList();
    return devices;
  });

  @override
  Future<DeviceOverviewModel?> getOneDeviceOverviewByName(String deviceName) =>
      _safe(() async {
        final searchResults = await getAllSearchedDevicesOverview(deviceName);
        if (searchResults.isEmpty) return null;
        final dn = deviceName.replaceFirst('5G', '').trim();
        final bestMatch = searchResults.reduce(
          (a, b) => dn.similarityTo(a.name) > dn.similarityTo(b.name) ? a : b,
        );
        return bestMatch;
      });

  @override
  Future<DeviceSpecsModel> getDeviceSpecs(String urlEndpoint) =>
      _safe(() async {
        final soup = await _scrapWebpage(_baseUrl + urlEndpoint);
        final deviceName = soup
            .find('h1', class_: 'specs-phone-name-title')!
            .text;
        final deviceImg = soup
            .find('img', selector: '.specs-photo-main img')!
            .getAttrValue('src')!;
        final specsTbodies = soup.findAll(
          'tbody',
          selector: '#specs-list > table > tbody',
        );
        final features = List.generate(specsTbodies.length, (index) {
          final tBody = specsTbodies[index];
          final tRows = tBody.findAll('tr');
          if (index == 0) {
            final networkTechnologies = tBody.find('tr .nfo')!.text;
            return DeviceFeatureModel(
              name: 'Network',
              specs: [
                SpecsModel(name: 'Technology', values: [networkTechnologies]),
              ],
            );
          }
          late String featureName;
          List<SpecsModel> specs = [];
          for (var row in tRows) {
            final tHeadText = row.find('th')?.text;
            if (tHeadText != null) {
              featureName = tHeadText;
            }
            final tds = row.findAll('td');
            if (tds.length > 1) {
              final specName = tds[0].text;
              final spec = tds[1].text;
              specs.add(SpecsModel(name: specName, values: [spec]));
            }
          }
          return DeviceFeatureModel(name: featureName, specs: specs);
        }).toList();

        final deviceId = urlEndpoint.split('-').last.replaceAll('.php', '');
        return DeviceSpecsModel(
          overview: DeviceOverviewModel(
            id: deviceId,
            name: deviceName,
            link: urlEndpoint,
            imgUrl: deviceImg,
          ),
          features: features,
        );
      });

  @override
  Future<DevicesComparisonModel> compareDevices(List<String> ids) => _safe(
    () async {
      final endpoint = List.generate(
        ids.length,
        (index) => '${index == 0 ? "" : "&"}idPhone${index + 1}=${ids[index]}',
      ).toList().join('');
      final soup = await _scrapWebpage('${_baseUrl}compare.php3?$endpoint');
      final prices = soup
          .findAll('span', selector: '.offer span')
          .map((span) => span.text)
          .toList();
      final images = soup
          .findAll('img', selector: '.compare-media-wrap > img')
          .map((img) => img.getAttrValue('src'))
          .toList();
      final modelsSelector = soup.findAll(
        'span',
        selector: '[data-spec="modelname"]',
      );
      final deviceOverviews = List.generate(modelsSelector.length, (index) {
        final modelName = modelsSelector[index].text;
        final imgUrl = images[index]!;
        final price = prices.length > index ? prices[index] : '\$0';
        final id = ids[index];
        final link = '${modelName.toLowerCase().replaceAll(' ', '_')}-$id.php';
        return DeviceOverviewModel(
          id: id,
          link: link,
          name: modelName,
          subtitle: price,
          imgUrl: imgUrl,
        );
      }).toList();

      final tBodies = soup.findAll(
        'tbody',
        selector: '#specs-list > table > tbody',
      );
      final featues = List.generate(tBodies.length, (index) {
        final tBody = tBodies[index];
        if (index == 0) {
          final networkInfo = tBody
              .findAll('td', selector: '.collapse > .nfo')
              .map((td) => td.text)
              .toList();
          return DeviceFeatureModel(
            name: 'Network',
            specs: [SpecsModel(name: 'Technology', values: networkInfo)],
          );
        }
        late String featureName;
        final List<SpecsModel> specs = [];
        final List<String> leftOverSpecValues = [];
        tBody.findAll('tr').forEach((tr) {
          final tableHeader = tr.find('th');
          if (tableHeader != null) {
            featureName = tableHeader.text;
          }
          final specName = tr.find('a', selector: '.ttl a')?.text ?? '';
          if (specName == '3D size compare') return;
          final specValues = tr
              .findAll('td', selector: '.nfo')
              .map((td) => td.text)
              .toList();
          if (specName.isEmpty) {
            leftOverSpecValues.addAll(specValues);
            return;
          }
          specs.add(SpecsModel(name: specName, values: specValues));
        });
        return DeviceFeatureModel(name: featureName, specs: specs);
      }).toList();

      return DevicesComparisonModel(
        overviews: deviceOverviews,
        features: featues,
      );
    },
  );

  @override
  Future<List<TwoDeviceComparisonModel>> getPopularComparisons([
    bool refreshData = false,
  ]) => _safe(() async {
    final List<TwoDeviceComparisonModel> comparisons = [];
    final soup = _gsmarenaHomepage ?? await _getGsmarenaHomepage(refreshData);
    final popularComparisonModule = soup
        .findAll('div', selector: '.module.module-rankings.s3')
        .last;
    final tableRows = popularComparisonModule.findAll(
      'tr',
      selector: 'table > tbody > tr',
    );
    for (var tr in tableRows) {
      final anchor = tr.find('a', selector: 'th > a');
      final href =
          '$_baseUrl${anchor?.getAttrValue('href') ?? "compare.php3?idPhone1=13317&idPhone2=13395"}';
      final parsedHrefUri = Uri.parse(href);
      final firstDeviceId =
          parsedHrefUri.queryParameters['idPhone1'] ?? '13317';
      final lastDeviceId = parsedHrefUri.queryParameters['idPhone2'] ?? '13395';
      final twoDeviceNames = anchor?.text ?? 'Device A vs. Device B';
      final seperatedNames = twoDeviceNames.split(' vs. ');
      final firstDeviceName = seperatedNames.first;
      final lastDeviceName = seperatedNames.last;

      comparisons.add(
        TwoDeviceComparisonModel(
          firstDeviceId: firstDeviceId,
          lastDeviceId: lastDeviceId,
          firstDeviceName: firstDeviceName,
          lastDeviceName: lastDeviceName,
        ),
      );
    }
    return comparisons;
  });

  @override
  Future<List<NewsOverviewModel>> getTechNews() => _safe(() async {
    final soup = await _scrapWebpage('${_baseUrl}news.php3');
    final newsList = soup.findAll('div', selector: '.news-item').map((item) {
      final imgUrl = item.find('img')!.getAttrValue('src')!;
      final link = item.find('a')!.getAttrValue('href')!;
      final title = item.find('h3')!.text;
      final subtitle = item.find('p')!.text;
      final uploadedTime = item
          .find('span', selector: '.meta-line > .meta-item-time')!
          .text;
      final id = link.split('-').last.replaceAll('.php', '');
      return NewsOverviewModel(
        id: id,
        title: title,
        subtitle: subtitle,
        imgUrl: imgUrl,
        link: link,
        uploadedTime: uploadedTime,
      );
    }).toList();
    return newsList;
  });

  @override
  Future<DetailedNewsModel> getDetailedNews(String urlEndpoint) =>
      _safe(() async {
        final soup = await _scrapWebpage(_baseUrl + urlEndpoint);
        final title = soup.find('h1')!.text;
        final reviewer = soup.find('a', selector: '.reviewer')!.text;
        final tags = soup
            .findAll('b', selector: '.float-right > a > b')
            .map((t) => t.text)
            .toList();
        final description = soup
            .findAll('p', selector: '.review-body p')
            .map((p) => p.text)
            .toList()
            .join('/n');
        return DetailedNewsModel(
          title: title,
          description: description,
          reviewer: reviewer,
          tags: tags,
        );
      });
}
