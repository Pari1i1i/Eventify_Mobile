import 'package:flutter/material.dart';

/// Widget Search & Ticket Code Lookup Bar Neobrutalism
class UserSearchTicketBar extends StatelessWidget {
  final bool isExpanded;
  final TextEditingController searchController;
  final TextEditingController kodeTiketController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCariKodeTiket;

  const UserSearchTicketBar({
    super.key,
    required this.isExpanded,
    required this.searchController,
    required this.kodeTiketController,
    required this.onSearchChanged,
    required this.onCariKodeTiket,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF2B2630), width: 3),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF2B2630), offset: Offset(4, 4)),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PENCARIAN EVENT & TIKET',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B2630),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: 'Cari event, kategori, atau lokasi...',
                        prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF2B2630)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(0xFF2B2630), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                            ],
                          ),
                          child: TextField(
                            controller: kodeTiketController,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'Cek Kode Tiket (EVT-XXXX)',
                              prefixIcon: Icon(Icons.confirmation_number, size: 18, color: Color(0xFF2B2630)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Color(0xFF2B2630), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Color(0xFF2B2630), width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Color(0xFF2B2630), offset: Offset(2, 2)),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9EB1), // AdminColors.pink
                            foregroundColor: const Color(0xFF2B2630),
                            side: const BorderSide(color: Color(0xFF2B2630), width: 1.5),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: onCariKodeTiket,
                          child: const Text('Cari', style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
