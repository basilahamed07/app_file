import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/doctor_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class DoctorSelectionScreen extends StatefulWidget {
  const DoctorSelectionScreen({super.key});

  @override
  State<DoctorSelectionScreen> createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  Map<String, dynamic> _activeFilters = {};
  String _currentSort = 'availability';
  bool _isLoading = false;
  String _searchQuery = '';
  DateTime _lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeDoctors();
  }

  void _initializeDoctors() {
    _allDoctors = [
      {
        "id": 1,
        "name": "Dr. Priya Sharma",
        "specialization": "Cardiologist",
        "photo":
            "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.8,
        "isAvailable": true,
        "consultationFee": "₹800",
        "nextAvailableSlot": "2:30 PM",
        "hospital": "Apollo Hospital",
        "experience": 12,
        "isFavorite": false,
      },
      {
        "id": 2,
        "name": "Dr. Rajesh Kumar",
        "specialization": "Neurologist",
        "photo":
            "https://images.pexels.com/photos/612608/pexels-photo-612608.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.6,
        "isAvailable": false,
        "consultationFee": "₹1200",
        "nextAvailableSlot": "Tomorrow 10:00 AM",
        "hospital": "Fortis Healthcare",
        "experience": 15,
        "isFavorite": true,
      },
      {
        "id": 3,
        "name": "Dr. Anita Desai",
        "specialization": "Dermatologist",
        "photo":
            "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.9,
        "isAvailable": true,
        "consultationFee": "₹600",
        "nextAvailableSlot": "4:00 PM",
        "hospital": "Max Healthcare",
        "experience": 8,
        "isFavorite": false,
      },
      {
        "id": 4,
        "name": "Dr. Vikram Singh",
        "specialization": "Orthopedic Surgeon",
        "photo":
            "https://images.pexels.com/photos/5452293/pexels-photo-5452293.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.7,
        "isAvailable": true,
        "consultationFee": "₹1000",
        "nextAvailableSlot": "3:15 PM",
        "hospital": "AIIMS",
        "experience": 18,
        "isFavorite": false,
      },
      {
        "id": 5,
        "name": "Dr. Meera Patel",
        "specialization": "Pediatrician",
        "photo":
            "https://images.pexels.com/photos/5452201/pexels-photo-5452201.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.5,
        "isAvailable": false,
        "consultationFee": "₹500",
        "nextAvailableSlot": "Tomorrow 9:30 AM",
        "hospital": "Manipal Hospital",
        "experience": 10,
        "isFavorite": true,
      },
      {
        "id": 6,
        "name": "Dr. Arjun Reddy",
        "specialization": "General Medicine",
        "photo":
            "https://images.pexels.com/photos/5452274/pexels-photo-5452274.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.4,
        "isAvailable": true,
        "consultationFee": "₹400",
        "nextAvailableSlot": "1:45 PM",
        "hospital": "Narayana Health",
        "experience": 6,
        "isFavorite": false,
      },
      {
        "id": 7,
        "name": "Dr. Kavitha Nair",
        "specialization": "ENT Specialist",
        "photo":
            "https://images.pexels.com/photos/5452293/pexels-photo-5452293.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.6,
        "isAvailable": true,
        "consultationFee": "₹700",
        "nextAvailableSlot": "5:30 PM",
        "hospital": "Apollo Hospital",
        "experience": 9,
        "isFavorite": false,
      },
      {
        "id": 8,
        "name": "Dr. Suresh Gupta",
        "specialization": "Psychiatrist",
        "photo":
            "https://images.pexels.com/photos/5452201/pexels-photo-5452201.jpeg?auto=compress&cs=tinysrgb&w=400",
        "rating": 4.8,
        "isAvailable": false,
        "consultationFee": "₹900",
        "nextAvailableSlot": "Tomorrow 11:00 AM",
        "hospital": "Fortis Healthcare",
        "experience": 14,
        "isFavorite": false,
      },
    ];

    _filteredDoctors = List.from(_allDoctors);
    _applySorting();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allDoctors);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        final name = (doctor['name'] as String).toLowerCase();
        final specialization =
            (doctor['specialization'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || specialization.contains(query);
      }).toList();
    }

    // Apply active filters
    if (_activeFilters['specializations'] != null) {
      final selectedSpecs = _activeFilters['specializations'] as List<String>;
      if (selectedSpecs.isNotEmpty) {
        filtered = filtered.where((doctor) {
          return selectedSpecs.contains(doctor['specialization'] as String);
        }).toList();
      }
    }

    if (_activeFilters['hospitals'] != null) {
      final selectedHospitals = _activeFilters['hospitals'] as List<String>;
      if (selectedHospitals.isNotEmpty) {
        filtered = filtered.where((doctor) {
          return selectedHospitals.contains(doctor['hospital'] as String);
        }).toList();
      }
    }

    if (_activeFilters['availableOnly'] == true) {
      filtered =
          filtered.where((doctor) => doctor['isAvailable'] == true).toList();
    }

    if (_activeFilters['maxPrice'] != null) {
      final maxPrice = _activeFilters['maxPrice'] as double;
      filtered = filtered.where((doctor) {
        final feeString = doctor['consultationFee'] as String;
        final fee = double.tryParse(
                feeString.replaceAll('₹', '').replaceAll(',', '')) ??
            0;
        return fee <= maxPrice;
      }).toList();
    }

    setState(() {
      _filteredDoctors = filtered;
      _applySorting();
    });
  }

  void _applySorting() {
    switch (_currentSort) {
      case 'availability':
        _filteredDoctors.sort((a, b) {
          final aAvailable = a['isAvailable'] as bool;
          final bAvailable = b['isAvailable'] as bool;
          if (aAvailable && !bAvailable) return -1;
          if (!aAvailable && bAvailable) return 1;
          return 0;
        });
        break;
      case 'rating':
        _filteredDoctors.sort((a, b) {
          final aRating = (a['rating'] as num).toDouble();
          final bRating = (b['rating'] as num).toDouble();
          return bRating.compareTo(aRating);
        });
        break;
      case 'experience':
        _filteredDoctors.sort((a, b) {
          final aExp = a['experience'] as int;
          final bExp = b['experience'] as int;
          return bExp.compareTo(aExp);
        });
        break;
      case 'fee_low':
        _filteredDoctors.sort((a, b) {
          final aFee = double.tryParse((a['consultationFee'] as String)
                  .replaceAll('₹', '')
                  .replaceAll(',', '')) ??
              0;
          final bFee = double.tryParse((b['consultationFee'] as String)
                  .replaceAll('₹', '')
                  .replaceAll(',', '')) ??
              0;
          return aFee.compareTo(bFee);
        });
        break;
      case 'fee_high':
        _filteredDoctors.sort((a, b) {
          final aFee = double.tryParse((a['consultationFee'] as String)
                  .replaceAll('₹', '')
                  .replaceAll(',', '')) ??
              0;
          final bFee = double.tryParse((b['consultationFee'] as String)
                  .replaceAll('₹', '')
                  .replaceAll(',', '')) ??
              0;
          return bFee.compareTo(aFee);
        });
        break;
    }
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search feature coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFiltersAndSearch();
          });
        },
      ),
    );
  }

  void _onSortPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortSelected: (sortType) {
          setState(() {
            _currentSort = sortType;
            _applySorting();
          });
        },
      ),
    );
  }

  void _removeFilter(String filterType) {
    setState(() {
      if (filterType == 'specializations' ||
          filterType == 'hospitals' ||
          filterType == 'consultationTypes') {
        _activeFilters.remove(filterType);
      } else if (filterType == 'availableOnly') {
        _activeFilters.remove('availableOnly');
      } else if (filterType == 'priceRange') {
        _activeFilters.remove('maxPrice');
      }
      _applyFiltersAndSearch();
    });
  }

  void _onDoctorTap(Map<String, dynamic> doctor) {
    Navigator.pushNamed(context, '/token-booking-screen');
  }

  void _onDoctorLongPress(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsWidget(
        onViewProfile: () {
          Navigator.pop(context);
          // Navigate to doctor profile
        },
        onCheckAvailability: () {
          Navigator.pop(context);
          // Show availability
        },
        onAddToFavorites: () {
          Navigator.pop(context);
          _toggleFavorite(doctor);
        },
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> doctor) {
    setState(() {
      final index = _allDoctors.indexWhere((d) => d['id'] == doctor['id']);
      if (index != -1) {
        _allDoctors[index]['isFavorite'] =
            !(_allDoctors[index]['isFavorite'] as bool);
        _applyFiltersAndSearch();
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  List<Widget> _buildActiveFilterChips() {
    List<Widget> chips = [];

    if (_activeFilters['specializations'] != null) {
      final specs = _activeFilters['specializations'] as List<String>;
      if (specs.isNotEmpty) {
        chips.add(FilterChipWidget(
          label: 'Specialization',
          count: specs.length,
          onRemove: () => _removeFilter('specializations'),
        ));
      }
    }

    if (_activeFilters['hospitals'] != null) {
      final hospitals = _activeFilters['hospitals'] as List<String>;
      if (hospitals.isNotEmpty) {
        chips.add(FilterChipWidget(
          label: 'Hospital',
          count: hospitals.length,
          onRemove: () => _removeFilter('hospitals'),
        ));
      }
    }

    if (_activeFilters['availableOnly'] == true) {
      chips.add(FilterChipWidget(
        label: 'Available Only',
        count: 0,
        onRemove: () => _removeFilter('availableOnly'),
      ));
    }

    if (_activeFilters['maxPrice'] != null) {
      chips.add(FilterChipWidget(
        label: 'Price Range',
        count: 0,
        onRemove: () => _removeFilter('priceRange'),
      ));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and search icon
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Select Doctor',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onSortPressed,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'sort',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onVoiceSearch: _onVoiceSearch,
              onFilter: _onFilterPressed,
            ),

            // Active filter chips
            if (_buildActiveFilterChips().isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildActiveFilterChips(),
                ),
              ),

            // Doctor list
            Expanded(
              child: _filteredDoctors.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
                          return DoctorCardWidget(
                            doctor: doctor,
                            onTap: () => _onDoctorTap(doctor),
                            onLongPress: () => _onDoctorLongPress(doctor),
                            onFavoriteToggle: () => _toggleFavorite(doctor),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No doctors found',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'No doctors match your current filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            if (_activeFilters.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _activeFilters.clear();
                    _searchController.clear();
                    _searchQuery = '';
                    _applyFiltersAndSearch();
                  });
                },
                child: Text('Clear Filters'),
              ),
            SizedBox(height: 2.h),
            Text(
              'Last updated: ${_lastUpdated.hour.toString().padLeft(2, '0')}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
