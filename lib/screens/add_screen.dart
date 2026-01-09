import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project/models/Apartment.dart';
import 'package:project/models/Governorates.dart';
import 'package:project/providers/apartmentsProvider.dart';

import '../providers/addApartmentProvider.dart';
import '../providers/cities_provider.dart';

class AddApartmentScreen extends ConsumerStatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  ConsumerState<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends ConsumerState<AddApartmentScreen> {

  bool _isSubmitting = false;

  // Form key so we can validate all fields together in one go (let's goo)(form widget is used below)
  final _formKey = GlobalKey<FormState>();

  // dropdown values
  int? _gov;
  String? _city;
  int? _bedrooms;
  int? _bathrooms;

  final _streetCtrl = TextEditingController();
  final _buildingCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _aptNumCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  // image picker + picked images
  final _picker = ImagePicker();
  final List<XFile> _images = [];

  // pick multiple images from gallery
  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (!mounted || picked.isEmpty) return;

    setState(() {
      _images.addAll(picked);

      // limit max images to 5
      if (_images.length > 5) _images.removeRange(5, _images.length);
    });
  }

  // take 1 photo from camera
  Future<void> _takePhoto() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (!mounted || shot == null) return;

    setState(() {
      _images.add(shot);

      // limit max images to 5
      if (_images.length > 5) _images.removeRange(5, _images.length);
    });
  }

  // remove an image from the list
  void _removeImage(int i) => setState(() => _images.removeAt(i));

  // called when user presses "Add Apartment"(in a seperate func so button doesnt get too crowded)
  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isSubmitting = true);

    try{
      print ("inside try");

      final formData = FormData();

      formData.fields.addAll([
        MapEntry('governorate', _gov.toString()),
        MapEntry('city', _city.toString()),
        MapEntry('street', _streetCtrl.text.trim()),
        MapEntry('building_number', _buildingCtrl.text.trim()),
        MapEntry('floor', _floorCtrl.text.trim()),
        MapEntry('apartment_number', _aptNumCtrl.text.trim()),
        MapEntry('number_of_bedrooms', _bedrooms.toString()),
        MapEntry('number_of_bathrooms', _bathrooms.toString()),
        MapEntry('area_sq_meters', _areaCtrl.text.trim()),
        MapEntry('rent_price_per_night', _priceCtrl.text.trim()),
        MapEntry('description_en', _descCtrl.text.trim()),
        MapEntry('description_ar', _descCtrl.text.trim()),
        MapEntry('has_balcony', '0'),
      ]);

      for (int i = 0; i < _images.length; i++) {
        formData.files.add(
          MapEntry(
            'assets[$i]',
            await MultipartFile.fromFile(
              _images[i].path,
              filename: _images[i].name,
            ),
          ),
        );
      }

      final result = await ref.read(AddApartmentProvider(formData).future);

      print("done inside the try/////////////////////////////");
      //  success
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Apartment added')));

      //  clear fields
      setState(() {
        _gov = null;
        _city = null;
        _bedrooms = null;
        _bathrooms = null;
        _images.clear();
      });

      _streetCtrl.clear();
      _buildingCtrl.clear();
      _floorCtrl.clear();
      _aptNumCtrl.clear();
      _areaCtrl.clear();
      _descCtrl.clear();
      _priceCtrl.clear();

      // close keyboard
      FocusManager.instance.primaryFocus?.unfocus();
    }catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // For bedrooms/bathrooms dropdown
    final nums = List<int>.generate(10, (i) => i + 1);

    final cities = ref.watch(CitiesProvider(_gov as int?));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Add Apartment",
            style: TextStyle(
              color: cs.primary,
              fontSize: screenWidth * 0.065,
              fontWeight: FontWeight.w200,
              fontFamily: 'Monoglyceride',
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Form(
            //form is just a widget that groups multiple input fields,validate them all togethter,reset them all at once..great right?
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------------- PHOTOS ----------------
                Card(
                  elevation: 12, 
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Photos',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // pick from gallery / camera
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('Gallery'),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _takePhoto,
                                icon: const Icon(Icons.photo_camera_outlined),
                                label: const Text('Camera'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Show placeholder if no images, otherwise show preview list
                        if (_images.isEmpty)
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.image_outlined),
                                SizedBox(width: 10),
                                Expanded(child: Text('Add up to 5 images')),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: screenHeight * 0.15,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: screenWidth * 0.04),
                              itemBuilder: (_, i) => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_images[i].path),
                                      width: screenWidth * 0.25,
                                      height: screenHeight * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // small X button to remove image
                                  Positioned(
                                    //widget you use inside a Stack to place a thing in a place using distances from the stack’s edges.
                                    top: 6,
                                    right: 6,
                                    child: InkWell(
                                      onTap: () => _removeImage(i),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          screenWidth * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(128),
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: screenWidth * 0.04,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // ---------------- ADDRESS ----------------
                Card(
                  elevation: 12, 
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Governorate dropdown
                        DropdownButtonFormField<int>(
                          initialValue: _gov,
                          decoration: InputDecoration(
                            labelText: 'Governorate',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: List.generate(
                            Governorates.governorates.length,
                                (i) => DropdownMenuItem(
                              value: i,
                              child: Text(Governorates.governorates[i]),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;

                            print("changed ----- $value");

                            // updating the sheet state
                            setState(() {
                              _gov = value;
                              _city = null;
                            });

                            // updating the button state
                            setState(() {});
                          },
                          validator: (v) =>
                              v == null ? 'Select a governorate' : null,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // City
                        DropdownButtonFormField<String>(
                          key: ValueKey(_gov),
                          initialValue: cities.when(
                            data: (list) {
                              if (_city == null) return null;
                              if (!list.contains(_city)) return null;
                              return _city;
                            },
                            loading: () => null,
                            error: (_, __) => null,
                          ),
                          decoration: InputDecoration(
                            labelText: _gov == null ? "Select a governorate first"
                                : cities.isLoading ? "Loading..."
                                : 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                            items: cities.when(
                              data: (cities) => List.generate(
                                cities.length,
                                    (i) => DropdownMenuItem(
                                  value: cities[i],
                                  child: Text(cities[i]),
                                ),
                              ),
                              loading: () => [],
                              error: (_, __) => [],
                            ),
                            onChanged:
                            (_gov == null || cities.isLoading)
                                ? null
                                : (val) {
                              setState(() {
                                _city = val;
                              });
                            },
                          validator: (v) =>
                          v == null ? 'Select a city' : null,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Street
                        TextFormField(
                          controller: _streetCtrl,
                          decoration: InputDecoration(
                            labelText: 'Street',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Street is required'
                              : null,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Building + Floor row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _buildingCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Building number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: TextFormField(
                                controller: _floorCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Floor',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (v) =>
                                    int.tryParse((v ?? '').trim()) == null
                                    ? 'Enter number'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Apartment number
                        TextFormField(
                          controller: _aptNumCtrl,
                          decoration: InputDecoration(
                            labelText: 'Apartment number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) =>
                              int.tryParse((v ?? '').trim()) == null
                              ? 'Enter number'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // ---------------- AMENITIES ----------------
                Card(
                  elevation: 12, 
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Amenities',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Bedrooms + Bathrooms
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _bedrooms,
                                decoration: InputDecoration(
                                  labelText: 'Bedrooms',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: nums
                                    .map(
                                      (n) => DropdownMenuItem(
                                        value: n,
                                        child: Text('$n'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => _bedrooms = v),
                                validator: (v) => v == null ? 'Select' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _bathrooms,
                                decoration: InputDecoration(
                                  labelText: 'Bathrooms',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: nums
                                    .map(
                                      (n) => DropdownMenuItem(
                                        value: n,
                                        child: Text('$n'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _bathrooms = v),
                                validator: (v) => v == null ? 'Select' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Area
                        TextFormField(
                          controller: _areaCtrl,
                          decoration: InputDecoration(
                            labelText: 'Area (m²)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          validator: (v) {
                            final s = (v ?? '').trim();
                            final n = double.tryParse(s);
                            if (n == null) return 'Enter number';
                            if (n <= 0) return 'Must be > 0';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // ---------------- DESCRIPTION + PRICE ----------------
                Card(
                  elevation: 12, 
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _priceCtrl,
                          decoration: InputDecoration(
                            labelText: 'Rent price per night',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          validator: (v) {
                            final s = (v ?? '').trim();
                            final n = double.tryParse(s);
                            if (n == null) return 'Enter number';
                            if (n <= 0) return 'Must be > 0';
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        TextFormField(
                          controller: _descCtrl,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignLabelWithHint: true,
                          ),
                          minLines: 4,
                          maxLines: 8,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Description required'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // ---------------- SUBMIT BUTTON ----------------
                SizedBox(
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: Text(
                      _isSubmitting ? "Loading...."
                      : 'Add Apartment',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontFamily: 'Monoglyceride',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
