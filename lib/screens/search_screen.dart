import 'dart:async';
import 'dart:developer';

import 'package:app/exceptions/custom_exception.dart';
import 'package:app/models/device_overview_model.dart';
import 'package:app/providers/repositories/gsmarena_repo_provider.dart';
import 'package:app/screens/search_results_screen.dart';
import 'package:app/utils/nav_helper.dart';
import 'package:app/widgets/search/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/general/no_data_message.dart';
import '../widgets/search/searched_results.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final List<DeviceOverviewModel>? trendingDevices;
  const SearchScreen({super.key, this.trendingDevices});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchFieldController;
  // bool _isUserSearching = false;
  Timer? _debounce;
  // bool _searchedLoading = false;
  bool _isLoading = false;
  String? _error;
  List<DeviceOverviewModel>? _searchedDevices;
  // List<DeviceOverviewModel>? _searchingDevices;

  @override
  void initState() {
    super.initState();
    _searchFieldController = TextEditingController();
    if (widget.trendingDevices != null) {
      _searchedDevices = widget.trendingDevices;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _searchFieldController.dispose();
  }

  Future<void> _handleSearchFieldChange(String query) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        setState(() => _isLoading = true);
        _searchedDevices = await ref
            .read(gsmarenRepoProvider)
            .getAllSearchedDevicesOverview(query);
        _isLoading = false;
        _error = null;
        setState(() {});
      } on CustomException catch (_) {
        _isLoading = false;
        _error = 'Could not load search results';
        setState(() {});
      }
    });
  }

  void _handleSearchFieldSubmit(String query) {
    NavHelper.push(context, SearchResultsScreen(query: query));
  }

  void _handleClearSearchField() {
    _searchFieldController.clear();
  }

  void _unfocusSearchField() {
    final focusScope = FocusScope.of(context);
    focusScope.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // final mqs = MediaQuery.of(context).size;
    log(_searchedDevices.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Column(
        children: [
          SearchField(
            controller: _searchFieldController,
            onChange: _handleSearchFieldChange,
            onSubmit: _handleSearchFieldSubmit,
            onClear: _handleClearSearchField,
            onTapOutside: _unfocusSearchField,
          ),
          Expanded(
            child: _error != null
                ? _buildNetworkErrorMessage()
                : _searchedDevices == null
                ? _buildStartSearchingMessage()
                : _searchedDevices != null && _searchedDevices!.isEmpty
                ? _buildNoResultsFoundMessage()
                : SearchedResults(
                    isLoading: _isLoading,
                    error: _error,
                    devices: _searchedDevices,
                    onViewMore: () =>
                        _handleSearchFieldSubmit(_searchFieldController.text),
                  ),
            // : _buildDeviceGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkErrorMessage() {
    return NoDataMessage(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      icon: Icons.error_outline,
      title: 'Network Error',
      subtitle: 'Please make sure your internet connection is working',
    );
  }

  Widget _buildNoResultsFoundMessage() {
    return NoDataMessage(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      localImgSrc: 'assets/images/search.png',
      title: 'No Results Found',
      subtitle: 'Type something different in to get results',
    );
  }

  Widget _buildStartSearchingMessage() {
    return NoDataMessage(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      localImgSrc: 'assets/images/search.png',
      title: 'Start Typing',
      subtitle: 'Into the searchbar in order to get results',
    );
  }
}


 // if (_isUserSearching && _searchingDevices.isNotEmpty)
          //   Positioned(
          //     top: 72,
          //     height: 590,
          //     width: mqs.width,
          //     child: ,
          //   ),