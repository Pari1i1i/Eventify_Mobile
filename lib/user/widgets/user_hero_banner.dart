import 'package:flutter/material.dart';

/// Widget Hero Banner Neobrutalism untuk Beranda User
class UserHeroBanner extends StatelessWidget {
  const UserHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF176), // AdminColors.yellowHero
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF2B2630), width: 3),
          boxShadow: const [
            BoxShadow(color: Color(0xFF2B2630), offset: Offset(5, 5)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9EB1),
                    border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -8,
              right: 20,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA8E6CF),
                    border: Border.all(color: const Color(0xFF2B2630), width: 1.5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFF2B2630),
                    child: const Text(
                      'FEATURED EVENTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'POPULAR EVENTS IN INDONESIA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2B2630),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jelajahi dan pilih event favoritmu, dapatkan E-Tiket resmi presensi QR langsung!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2B2630),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
