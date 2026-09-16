import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../events/models/event_model.dart';
import '../providers/organizer_provider.dart';
import '../services/organizer_api_service.dart';

class CreateEditEventScreen extends ConsumerStatefulWidget {
  final int? eventId;
  final EventModel? initialEvent;

  const CreateEditEventScreen({
    super.key,
    this.eventId,
    this.initialEvent,
  });

  @override
  ConsumerState<CreateEditEventScreen> createState() => _CreateEditEventScreenState();
}

class _CreateEditEventScreenState extends ConsumerState<CreateEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _venueNameController;
  late final TextEditingController _venueAddressController;
  late final TextEditingController _cityController;

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String _status = 'published';
  XFile? _selectedBanner;
  bool _isLoading = false;

  final List<String> _categoryOptions = [
    'Olahraga',
    'Teknologi',
    'Konser',
    'Workshop',
    'Umum',
  ];

  @override
  void initState() {
    super.initState();
    final ev = widget.initialEvent;
    _titleController = TextEditingController(text: ev?.title ?? '');
    _categoryController = TextEditingController(text: ev?.category ?? 'Umum');
    _descriptionController = TextEditingController(text: ev?.description ?? '');
    _venueNameController = TextEditingController(text: ev?.venueName ?? '');
    _venueAddressController = TextEditingController(text: ev?.venueAddress ?? '');
    _cityController = TextEditingController(text: ev?.city ?? 'Jakarta');

    if (ev?.startTime != null) {
      _startDate = ev!.startTime;
      _startTime = TimeOfDay.fromDateTime(ev.startTime!);
    } else {
      _startDate = DateTime.now().add(const Duration(days: 7));
      _startTime = const TimeOfDay(hour: 9, minute: 0);
    }

    if (ev?.endTime != null) {
      _endDate = ev!.endTime;
      _endTime = TimeOfDay.fromDateTime(ev.endTime!);
    } else {
      _endDate = DateTime.now().add(const Duration(days: 7));
      _endTime = const TimeOfDay(hour: 17, minute: 0);
    }

    _status = ev?.status ?? 'published';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _venueNameController.dispose();
    _venueAddressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedBanner = image);
    }
  }

  Future<void> _pickStartDate() async {
    if (!mounted) return;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (!mounted) return;
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
      );
      if (pickedTime != null) {
        setState(() {
          _startDate = pickedDate;
          _startTime = pickedTime;
        });
      }
    }
  }

  Future<void> _pickEndDate() async {
    if (!mounted) return;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (!mounted) return;
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _endTime ?? const TimeOfDay(hour: 17, minute: 0),
      );
      if (pickedTime != null) {
        setState(() {
          _endDate = pickedDate;
          _endTime = pickedTime;
        });
      }
    }
  }

  DateTime? _combineDateTime(DateTime? d, TimeOfDay? t) {
    if (d == null) return null;
    final time = t ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(d.year, d.month, d.day, time.hour, time.minute);
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final startDateTime = _combineDateTime(_startDate, _startTime);
    final endDateTime = _combineDateTime(_endDate, _endTime);

    final eventData = <String, dynamic>{
      'name': _titleController.text.trim(),
      'title': _titleController.text.trim(),
      'category': _categoryController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _venueNameController.text.trim(),
      'venue_name': _venueNameController.text.trim(),
      'venue_address': _venueAddressController.text.trim(),
      'address': _venueAddressController.text.trim(),
      'city': _cityController.text.trim(),
      'status': _status,
      'terms_conditions': 'Tiket tidak dapat dikembalikan / Tiket berlaku untuk 1 orang.',
      'ticket_tiers': <Map<String, dynamic>>[],
      if (startDateTime != null) ...{
        'start_at': startDateTime.toUtc().toIso8601String(),
        'start_time': startDateTime.toUtc().toIso8601String(),
      },
      if (endDateTime != null) ...{
        'end_at': endDateTime.toUtc().toIso8601String(),
        'end_time': endDateTime.toUtc().toIso8601String(),
      },
    };

    try {
      final orgApi = ref.read(organizerApiServiceProvider);
      EventModel savedEvent;

      if (widget.eventId != null) {
        savedEvent = await orgApi.updateEvent(widget.eventId!, eventData);
        if (_selectedBanner != null) {
          try {
            await orgApi.uploadBanner(widget.eventId!, _selectedBanner!);
          } catch (e) {
            debugPrint('[Banner Upload Error] $e');
          }
        }
      } else {
        savedEvent = await orgApi.createEvent(eventData);
        if (_selectedBanner != null && savedEvent.id > 0) {
          try {
            await orgApi.uploadBanner(savedEvent.id, _selectedBanner!);
          } catch (e) {
            debugPrint('[Banner Upload Error] $e');
          }
        }
      }

      await ref.read(organizerProvider.notifier).loadMyEvents();

      if (mounted) {
        setState(() => _isLoading = false);
        if (widget.eventId != null) {
          showNeoSnackBar(context, 'Event berhasil diperbarui!', isSuccess: true);
        } else {
          showNeoSnackBar(context, 'Event berhasil dibuat!', isSuccess: true);
        }
        if (widget.eventId == null) {
          // New event: ask to manage ticket tiers
          context.pushReplacement('/organizer/events/${savedEvent.id}/tiers', extra: savedEvent);
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showNeoSnackBar(context, e.toString(), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.eventId != null;

    final startStr = _startDate != null && _startTime != null
        ? '${DateFormat('d MMM yyyy').format(_startDate!)}, ${_startTime!.format(context)}'
        : 'Pilih waktu mulai';

    final endStr = _endDate != null && _endTime != null
        ? '${DateFormat('d MMM yyyy').format(_endDate!)}, ${_endTime!.format(context)}'
        : 'Pilih waktu selesai';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: isEditing ? 'EDIT EVENT' : 'BUAT EVENT',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Picker Box
              NeoCard(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NeoFormLabel('POSTER / BANNER EVENT'),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border.all(color: AppColors.textBorder, width: 2),
                        ),
                        child: _selectedBanner != null
                            ? Image.file(
                                File(_selectedBanner!.path),
                                fit: BoxFit.cover,
                              )
                            : widget.initialEvent?.bannerUrl != null
                                ? Image.network(
                                    widget.initialEvent!.bannerUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(LucideIcons.image, size: 36, color: AppColors.textBorder),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(LucideIcons.uploadCloud, size: 36, color: AppColors.textBorder),
                                      const SizedBox(height: 8),
                                      Text(
                                        'PILIH GAMBAR BANNER DARI GALERI',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textBorder,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Basic Info Card
              NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NeoFormLabel('JUDUL EVENT', isRequired: true),
                    NeoTextField(
                      controller: _titleController,
                      hint: 'Contoh: 8Finity Charity Fun Run 2026',
                      prefixIcon: const Icon(LucideIcons.fileText, size: 18, color: AppColors.textBorder),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Judul event wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('KATEGORI EVENT', isRequired: true),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _categoryOptions.map((cat) {
                        final isSel = _categoryController.text == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _categoryController.text = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.yellow : Colors.white,
                              border: Border.all(color: AppColors.textBorder, width: isSel ? 2 : 1.5),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('DESKRIPSI LENGKAP EVENT', isRequired: true),
                    NeoTextField(
                      controller: _descriptionController,
                      hint: 'Jelaskan jadwal, rute, aturan, dan fasilitas event...',
                      maxLines: 4,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Date & Venue Card
              NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NeoFormLabel('WAKTU MULAI EVENT', isRequired: true),
                    NeoCard(
                      backgroundColor: AppColors.orange,
                      padding: const EdgeInsets.all(12),
                      onTap: _pickStartDate,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 18, color: AppColors.textBorder),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              startStr,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textBorder),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('WAKTU SELESAI EVENT', isRequired: true),
                    NeoCard(
                      backgroundColor: AppColors.toska,
                      padding: const EdgeInsets.all(12),
                      onTap: _pickEndDate,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.clock, size: 18, color: AppColors.textBorder),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              endStr,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textBorder),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('NAMA TEMPAT / VENUE', isRequired: true),
                    NeoTextField(
                      controller: _venueNameController,
                      hint: 'Contoh: Gelora Bung Karno / Lapangan Sumenep',
                      prefixIcon: const Icon(LucideIcons.mapPin, size: 18, color: AppColors.textBorder),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Nama venue wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('ALAMAT LENGKAP'),
                    NeoTextField(
                      controller: _venueAddressController,
                      hint: 'Jl. Pintu Satu Senayan, Gelora, Jakarta Pusat',
                      prefixIcon: const Icon(LucideIcons.navigation, size: 18, color: AppColors.textBorder),
                    ),
                    const SizedBox(height: 12),

                    const NeoFormLabel('KOTA'),
                    NeoTextField(
                      controller: _cityController,
                      hint: 'Jakarta / Surabaya / Sumenep',
                      prefixIcon: const Icon(LucideIcons.building, size: 18, color: AppColors.textBorder),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Status Selector
              NeoCard(
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NeoFormLabel('STATUS PUBLIKASI'),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _status = 'published'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _status == 'published' ? AppColors.mint : Colors.white,
                                border: Border.all(color: AppColors.textBorder, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  'PUBLISHED',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _status = 'draft'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _status == 'draft' ? AppColors.yellow : Colors.white,
                                border: Border.all(color: AppColors.textBorder, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  'DRAFT',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              NeoButton(
                text: isEditing ? 'SIMPAN PERUBAHAN EVENT' : 'BUAT EVENT & LANJUT KE TIER TIKET',
                icon: LucideIcons.check,
                backgroundColor: AppColors.yellow,
                isLoading: _isLoading,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
