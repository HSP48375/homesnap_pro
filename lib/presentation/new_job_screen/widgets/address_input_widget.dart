import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sizer/sizer.dart';


class AddressInputWidget extends StatefulWidget {
  final Function(String, String) onAddressSelected; // address, placeId
  final String? initialAddress;

  const AddressInputWidget({
    super.key,
    required this.onAddressSelected,
    this.initialAddress,
  });

  @override
  State<AddressInputWidget> createState() => _AddressInputWidgetState();
}

class _AddressInputWidgetState extends State<AddressInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _controller.text = widget.initialAddress!;
    }

    _focusNode.addListener(() {
      setState(() {
        _isExpanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded ? Colors.blue : Colors.grey[300]!,
          width: _isExpanded ? 2 : 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: Colors.blue.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Property Address',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Google Places Autocomplete
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _controller,
                  googleAPIKey: const String.fromEnvironment(
                      'GOOGLE_PLACES_API_KEY',
                      defaultValue: ''),
                  focusNode: _focusNode,
                  inputDecoration: InputDecoration(
                    hintText: 'Enter property address...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _controller.clear();
                              widget.onAddressSelected('', '');
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                  debounceTime: 600,
                  countries: const ['us'], // Restrict to US addresses
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    final address = prediction.description ?? '';
                    final placeId = prediction.placeId ?? '';

                    setState(() {
                      _controller.text = address;
                      _isExpanded = false;
                    });

                    _focusNode.unfocus();
                    widget.onAddressSelected(address, placeId);
                  },
                  itemClick: (Prediction prediction) {
                    final address = prediction.description ?? '';
                    final placeId = prediction.placeId ?? '';

                    setState(() {
                      _controller.text = address;
                      _isExpanded = false;
                    });

                    _focusNode.unfocus();
                    widget.onAddressSelected(address, placeId);
                  },
                  seperatedBuilder: const Divider(height: 1),
                  containerHorizontalPadding: 16,
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prediction.structuredFormatting?.mainText ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (prediction
                                        .structuredFormatting?.secondaryText !=
                                    null)
                                  Text(
                                    prediction
                                        .structuredFormatting!.secondaryText!,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Additional Info
          if (_controller.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(13),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Address selected successfully',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
