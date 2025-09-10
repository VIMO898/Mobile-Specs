import 'package:app/exceptions/custom_exception.dart';
import 'package:app/extensions/string_extension.dart';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/screens/device_full_specifications_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/utils/dialog_helper.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/brand_devices/brand_device_list_view.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/device_list_overview_model.dart';
import '../models/devices_overview_list_model.dart';
import '../widgets/brand_devices/brand_devices_grid.dart';
import '../widgets/brand_devices/layout_selection_dialog.dart';

enum DevicesLayout { smallGrid, largeGrid, list, staggeredGrid }

class BrandDevicesScreen extends ConsumerStatefulWidget {
  final String brandName;
  final String link;
  const BrandDevicesScreen({
    super.key,
    required this.brandName,
    required this.link,
  });

  @override
  ConsumerState<BrandDevicesScreen> createState() => _BrandPhonesScreenState();
}

class _BrandPhonesScreenState extends ConsumerState<BrandDevicesScreen> {
  late ScrollController _scrollController;
  int _currPage = 1;
  int _totalPages = 10;
  bool _isLoading = false;
  bool _loadingLinkForGsmareanFullSpecs = false;
  String? _error;
  DevicesOverviewListModel? _devicesOverview;
  List<DeviceDetailedOverviewModel> _devicesWithDetailedOverview = [];
  var _currLayout = DevicesLayout.largeGrid;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _getDevicesOverview(widget.link, _currPage);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() {
    // checks if user hit the bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_currPage >= _totalPages) return;
      _currPage++;
      _getDevicesOverview(widget.link, _currPage);
    }
  }

  Future<void> _getDevicesOverview(String link, int page) async {
    // loading
    setState(() => _isLoading = true);
    try {
      // data
      final data = await ref
          .read(gsmarenRepoProvider)
          .getBrandDevicesOverview(widget.link, page);
      if (_devicesOverview != null) {
        _devicesOverview = DevicesOverviewListModel(
          devices: [..._devicesOverview!.devices, ...data.devices],
          totalPages: data.totalPages,
        );
        _isLoading = false;
        setState(() {});
        return;
      }
      _devicesOverview = data;
      _totalPages = data.totalPages;
      _isLoading = false;
      setState(() {});
    } on CustomException catch (e) {
      // error
      // show error via dialog initial data is already loaded
      if (_currPage > 1) {
        setState(() => _isLoading = false);
        DialogHelper.showErrorDialog(
          context,
          title: 'Error',
          message:
              'Unable to load more devices.\nPlease check your internet connection.',
        );
        return;
      }
      _error = e.message;
      _isLoading = false;
      setState(() {});
    }
  }

  Future<void> _getDevicesWithDetaildedOverview() async {
    // loading
    setState(() => _isLoading = true);
    try {
      // data
      final data = await ref
          .read(gsmarenRepoProvider)
          .getBrandDevicesDetails(widget.brandName);
      _devicesWithDetailedOverview = data;
      _isLoading = false;
      setState(() {});
    } on CustomException catch (e) {
      // error
      _error = e.message;
      _isLoading = false;
      setState(() {});
    }
  }

  Future<void> _getGsmarenaLinkForFullSpecs(String deviceName) async {
    // loading
    setState(() => _loadingLinkForGsmareanFullSpecs = true);
    try {
      // data
      final device = await ref
          .read(gsmarenRepoProvider)
          .getOneDeviceOverviewByName(deviceName);
      _loadingLinkForGsmareanFullSpecs = false;
      setState(() {});
      if (device == null) return;
      NavHelper.push(context, DeviceFullSpecificationsScreen(device));
    } on CustomException {
      // error
      _loadingLinkForGsmareanFullSpecs = false;
      setState(() {});
      // show error via a dialog
      DialogHelper.showWarningDialog(
        context,
        title: "Couldn't get data",
        message: 'Unable to load the specifications of this particular device.',
      );
    }
  }

  void _showLayoutSelectorBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LayoutSelectionDialog(
        context,
        currLayout: _currLayout,
        onSelectLayout: (selectedLayout) {
          if (_currLayout.index == selectedLayout.index) return;
          setState(() {
            if (selectedLayout == DevicesLayout.list) {
              _getDevicesWithDetaildedOverview();
            }
            _currLayout = selectedLayout;
          });
        },
      ),
    );
  }

  void _navigateToSearchScreen() {
    NavHelper.push(context, SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName.capitalizeFirstLetter()} Products'),
        actions: [
          IconButton(
            onPressed: _showLayoutSelectorBottomSheet,
            icon: const Icon(Icons.dashboard),
          ),
          IconButton(
            onPressed: _navigateToSearchScreen,
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
          ),
        ],
      ),
      body:
          // initial error
          _currPage == 1 && _error != null
          ? NoDataMessage(
              icon: Icons.error_outline,
              title: 'Unable to Load Data',
              subtitle:
                  'Please check your internet connection to reload the data',
            )
          // display data in preferred layout
          : _currLayout == DevicesLayout.list
          ? BrandDeviceListView(
              isLoading: _isLoading,
              isBackdropLoading: _loadingLinkForGsmareanFullSpecs,
              devicesWithDetailedOverview: _devicesWithDetailedOverview,
              onTap: _getGsmarenaLinkForFullSpecs,
            )
          : BrandDevicesGrid(
              scrollController: _scrollController,
              devicesOverview: _devicesOverview,
              currLayout: _currLayout,
              isLoading: _currPage == 1 && _isLoading,
              isLoadingMore: _isLoading,
            ),
    );
  }
}
