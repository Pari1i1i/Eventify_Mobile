import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class HomeEventsScreen extends ConsumerStatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  ConsumerState<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends ConsumerState<HomeEventsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _ticketSearchController = TextEditingController();
  bool _isSearchExpanded = false;
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Olahraga & Lari',
    'Kompetisi Anak',
    'Teknologi & AI',
    'Musik & Konser',
    'Workshop',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(eventsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _ticketSearchController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.purpleSeed,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textBorder,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final start = picked.start.toIso8601String().split('T')[0];
      final end = picked.end.toIso8601String().split('T')[0];
      ref.read(eventsProvider.notifier).setDateFilter(start, end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsProvider);
    final authState = ref.watch(authStateProvider);

    // Filter local categories if selected
    final displayedEvents = _selectedCategory == 'Semua'
        ? eventsState.events
        : eventsState.events.where((e) {
            final cat = e.category.toLowerCase();
            final target = _selectedCategory.toLowerCase();
            return cat.contains(target) || target.contains(cat);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'KATALOG EVENT',
        actions: [
          NeoIconButton(
            icon: _isSearchExpanded ? LucideIcons.x : LucideIcons.search,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  ref.read(eventsProvider.notifier).setSearchQuery('');
                }
              });
            },
          ),
          const SizedBox(width: 6),
          if (!authState.isAuthenticated)
            NeoButton(
              text: 'MASUK',
              icon: LucideIcons.logIn,
              backgroundColor: AppColors.pink,
              height: 38,
              fontSize: 11,
              fullWidth: false,
              onPressed: () => context.push('/login'),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.textBorder,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          await ref.read(eventsProvider.notifier).loadEvents(refresh: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search & Ticket Quick Lookup (Expandable)
            if (_isSearchExpanded)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: NeoCard(
                    backgroundColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NeoFormLabel('CARI EVENT (JUDUL, KOTA, KATEGORI)'),
                        NeoTextField(
                          controller: _searchController,
                          hint: 'Ketik nama event...',
                          prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.textBorder),
                          onChanged: (val) {
                            ref.read(eventsProvider.notifier).setSearchQuery(val);
                          },
                        ),
                        const SizedBox(height: 12),
                        const NeoFormLabel('CEK KODE TIKET LANGSUNG'),
                        Row(
                          children: [
                            Expanded(
                              child: NeoTextField(
                                controller: _ticketSearchController,
                                hint: 'Contoh: EVT-8823-99',
                                prefixIcon: const Icon(LucideIcons.qrCode, size: 18, color: AppColors.textBorder),
                              ),
                            ),
                            const SizedBox(width: 8),
                            NeoButton(
                              text: 'CEK',
                              backgroundColor: AppColors.yellow,
                              height: 48,
                              fullWidth: false,
                              onPressed: () {
                                final code = _ticketSearchController.text.trim();
                                if (code.isNotEmpty) {
                                  context.push('/tickets/$code');
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Hero Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: NeoCard(
                  backgroundColor: AppColors.yellow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NeoBadge(
                            label: 'OFFICIAL PLATFORM',
                            backgroundColor: AppColors.textBorder,
                            textColor: Colors.white,
                          ),
                          NeoBadge(
                            label: 'TIKET & PRESENSI',
                            backgroundColor: AppColors.mint,
                            textColor: AppColors.textBorder,
                            hasBorder: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'TEMUKAN EVENT SERU & DAPATKAN TIKETMU!',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Beli tiket instant, simpan tiket offline, scan check-in praktis di venue.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          NeoOutlineButton(
                            text: 'FILTER TANGGAL',
                            icon: LucideIcons.calendar,
                            backgroundColor: Colors.white,
                            fontSize: 11,
                            onPressed: _selectDateRange,
                          ),
                          if (eventsState.startDate != null) ...[
                            const SizedBox(width: 8),
                            NeoIconButton(
                              icon: LucideIcons.x,
                              backgroundColor: AppColors.pink,
                              size: 36,
                              iconSize: 16,
                              tooltip: 'Hapus Filter Tanggal',
                              onPressed: () {
                                ref.read(eventsProvider.notifier).setDateFilter(null, null);
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.textBorder : Colors.white,
                            border: Border.all(color: AppColors.textBorder, width: 2),
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: AppColors.yellow,
                                      offset: Offset(2, 2),
                                      blurRadius: 0,
                                    ),
                                  ]
                                : const [
                                    BoxShadow(
                                      color: AppColors.textBorder,
                                      offset: Offset(2, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.spaceGrotesk(
                              color: isSelected ? Colors.white : AppColors.textBorder,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DAFTAR EVENT (${displayedEvents.length})',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (eventsState.searchQuery.isNotEmpty || eventsState.startDate != null)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          ref.read(eventsProvider.notifier).clearFilters();
                        },
                        child: Text(
                          'RESET FILTER',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.magenta,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Events Content List / Loading / Error
            if (eventsState.isLoading && eventsState.events.isEmpty)
              const SliverFillRemaining(
                child: NeoLoadingIndicator(text: 'Memuat katalog event...'),
              )
            else if (eventsState.errorMessage != null && eventsState.events.isEmpty)
              SliverFillRemaining(
                child: NeoErrorState(
                  message: eventsState.errorMessage!,
                  onRetry: () => ref.read(eventsProvider.notifier).loadEvents(refresh: true),
                ),
              )
            else if (displayedEvents.isEmpty)
              SliverFillRemaining(
                child: NeoEmptyState(
                  title: 'TIDAK ADA EVENT',
                  message: 'Tidak ditemukan event sesuai kriteria pencarian.',
                  actionText: 'TAMPILKAN SEMUA',
                  onAction: () {
                    _searchController.clear();
                    setState(() => _selectedCategory = 'Semua');
                    ref.read(eventsProvider.notifier).clearFilters();
                  },
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == displayedEvents.length) {
                        return eventsState.isLoadMore
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                              )
                            : const SizedBox(height: 32);
                      }
                      final event = displayedEvents[index];
                      return EventCard(
                        event: event,
                        onTap: () {
                          context.push('/events/${event.slug}', extra: event);
                        },
                      );
                    },
                    childCount: displayedEvents.length + 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
