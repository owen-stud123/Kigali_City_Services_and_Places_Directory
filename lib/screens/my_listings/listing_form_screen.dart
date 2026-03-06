import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/listing_model.dart';
import '../../providers/listing_provider.dart';
import '../../providers/auth_provider.dart';

class ListingFormScreen extends StatefulWidget {
  final Listing?
  listing; // If null, we are creating. If provided, we are editing.

  const ListingFormScreen({super.key, this.listing});

  @override
  State<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends State<ListingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _descController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  String _selectedCategory = 'Other';
  bool _isLoading = false;

  final List<String> _categories = [
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if editing, or empty if creating
    _nameController = TextEditingController(text: widget.listing?.name ?? '');
    _addressController = TextEditingController(
      text: widget.listing?.address ?? '',
    );
    _contactController = TextEditingController(
      text: widget.listing?.contact ?? '',
    );
    _descController = TextEditingController(
      text: widget.listing?.description ?? '',
    );
    _latController = TextEditingController(
      text: widget.listing?.latitude.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: widget.listing?.longitude.toString() ?? '',
    );

    if (widget.listing != null) {
      _selectedCategory = widget.listing!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      final provider = Provider.of<ListingProvider>(context, listen: false);

      // Create Listing Object
      final newListing = Listing(
        id:
            widget.listing?.id ??
            '', // Empty ID for new, existing ID for update
        name: _nameController.text.trim(),
        category: _selectedCategory,
        address: _addressController.text.trim(),
        contact: _contactController.text.trim(),
        description: _descController.text.trim(),
        latitude: double.tryParse(_latController.text) ?? 0.0,
        longitude: double.tryParse(_lngController.text) ?? 0.0,
        createdBy: user!.uid,
        timestamp: DateTime.now(),
      );

      if (widget.listing == null) {
        // Create
        await provider.addListing(newListing);
      } else {
        // Update
        await provider.updateListing(widget.listing!.id, newListing.toMap());
      }

      if (mounted) {
        Navigator.pop(context); // Close screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Listing Saved Successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listing == null ? "Add Listing" : "Edit Listing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Place Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _categories.contains(_selectedCategory)
                    ? _selectedCategory
                    : 'Other',
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),

              // Contact
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: "Contact Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),

              // Description
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Coordinates Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(
                        labelText: "Latitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) =>
                          double.tryParse(val!) == null ? "Invalid" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lngController,
                      decoration: const InputDecoration(
                        labelText: "Longitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) =>
                          double.tryParse(val!) == null ? "Invalid" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                "Tip: Use Kigali Lat: -1.9441, Lng: 30.0619 for testing.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFACC15),
                    foregroundColor: Colors.black,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "SAVE LISTING",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
