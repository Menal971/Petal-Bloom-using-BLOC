// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';
import 'add_edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final Post post;
  const DetailScreen({super.key, required this.post});

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mist,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 210,
          pinned: true,
          backgroundColor: AppTheme.bloom,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditScreen(post: post)),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE05C8A), Color(0xFFAD1457)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wrap(spacing: 8, children: [
                        _PillBadge('Note #${post.id.abs()}'),
                        _PillBadge('User ${post.userId}'),
                      ]),
                      const SizedBox(height: 10),
                      Text(
                        _cap(post.title),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              // Content card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.frost,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dustyRose, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.bloom.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.menu_book_outlined,
                            size: 14, color: AppTheme.bloom),
                        const SizedBox(width: 6),
                        Text('CONTENT',
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.bloom,
                                letterSpacing: 1.5)),
                      ]),
                      const SizedBox(height: 14),
                      Text(
                        _cap(post.body),
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: AppTheme.inkSoft, height: 1.7),
                      ),
                    ]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bloom,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddEditScreen(post: post)),
                  ),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text('Edit Note',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  const _PillBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.nunito(
              fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }
}
