// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BloomLoader extends StatelessWidget {
  final String label;
  const BloomLoader({super.key, this.label = 'Loading notes…'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
                colors: [AppTheme.mauveTint, AppTheme.mist]),
          ),
          child:
              const Icon(Icons.filter_vintage, size: 36, color: AppTheme.bloom),
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator(color: AppTheme.bloom, strokeWidth: 2),
        const SizedBox(height: 14),
        Text(label,
            style: GoogleFonts.nunito(color: AppTheme.inkSoft, fontSize: 14)),
      ]),
    );
  }
}

class BloomError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const BloomError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppTheme.mauveTint, shape: BoxShape.circle),
            child: const Icon(Icons.cloud_off, size: 36, color: AppTheme.bloom),
          ),
          const SizedBox(height: 20),
          Text('Something went wrong',
              style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.inkSoft)),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bloom,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Retry',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
      ),
    );
  }
}

class BloomEmpty extends StatelessWidget {
  const BloomEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.spa_outlined, size: 64, color: AppTheme.dustyRose),
        const SizedBox(height: 16),
        Text('No notes blooming yet',
            style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkDeep)),
        const SizedBox(height: 8),
        Text('Tap + to plant your first note.',
            style: GoogleFonts.nunito(fontSize: 14, color: AppTheme.inkSoft)),
      ]),
    );
  }
}
