// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';

class BloomCard extends StatelessWidget {
  final Post post;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BloomCard({
    super.key,
    required this.post,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _stripe => AppTheme.stripes[index % AppTheme.stripes.length];

  // Alternating offset for a staggered feel
  double get _topPadding => index.isEven ? 6.0 : 10.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
            EdgeInsets.only(left: 16, right: 16, top: _topPadding, bottom: 4),
        decoration: BoxDecoration(
          color: AppTheme.frost,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _stripe, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.bloom.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top color ribbon
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: _stripe,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(17)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _cap(post.title),
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkDeep,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Action menu
                      _MoreMenu(onEdit: onEdit, onDelete: onDelete),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.body,
                    style: GoogleFonts.nunito(
                      fontSize: 12.5,
                      color: AppTheme.inkSoft,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Tag(icon: Icons.tag, label: '${post.id.abs()}'),
                      const SizedBox(width: 8),
                      _Tag(
                          icon: Icons.person_outline,
                          label: 'User ${post.userId}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.mauveTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: AppTheme.bloom),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkSoft)),
      ]),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _MoreMenu({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppTheme.inkSoft),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (v) {
        if (v == 'edit') onEdit();
        if (v == 'delete') onDelete();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(children: [
            const Icon(Icons.edit_outlined, size: 16, color: AppTheme.bloom),
            const SizedBox(width: 8),
            Text('Edit',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600, color: AppTheme.inkDeep)),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            const Icon(Icons.delete_outline, size: 16, color: AppTheme.danger),
            const SizedBox(width: 8),
            Text('Delete',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600, color: AppTheme.danger)),
          ]),
        ),
      ],
    );
  }
}
