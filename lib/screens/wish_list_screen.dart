import 'package:app/exceptions/custom_exception.dart';
import 'package:app/providers/controllers/device_wishlist_controller_provider.dart';
import 'package:app/widgets/general/device_grid_view.dart';
import 'package:app/widgets/general/no_data_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends ConsumerState<WishListScreen> {
  bool _isLoading = false;
  CustomException? _exception;

  @override
  void initState() {
    super.initState();
    _loadWishlistInitially();
  }

  Future<void> _loadWishlistInitially() async {
    try {
      _exception = null;
      setState(() => _isLoading = true);
      await ref.read(deviceWishlistControllerProvider.notifier).fetchWishlist();
      setState(() => _isLoading = false);
    } on CustomException catch (e) {
      _isLoading = false;
      _exception = e;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistedDevices = ref.watch(deviceWishlistControllerProvider);
    return Scaffold(
      body: _exception != null
          ? NoDataMessage(
              icon: Icons.error,
              title: 'Error',
              subtitle: _exception!.message,
            )
          : wishlistedDevices.isEmpty
          ? _buildEmptyListMessage()
          : DeviceGridView(
              isLoading: _isLoading,
              physics: BouncingScrollPhysics(),
              devices: wishlistedDevices,
            ),
    );
  }

  NoDataMessage _buildEmptyListMessage() {
    return NoDataMessage(
      icon: FontAwesomeIcons.heart,
      title: 'No favourites yet.',
      subtitle:
          'Tap any heart next to a product to favourite. We\'ll save them for you here!',
    );
  }
}
