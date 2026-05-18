// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/post_bloc.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';
import '../widgets/bloom_card.dart';
import '../widgets/bloom_widgets.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const FetchPostsEvent());
  }

  Future<void> _confirmDelete(BuildContext context, int postId) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.frost,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
                color: AppTheme.dustyRose,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 28),
          const Icon(Icons.delete_sweep_outlined,
              color: AppTheme.danger, size: 40),
          const SizedBox(height: 14),
          Text('Remove this note?',
              style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.inkDeep)),
          const SizedBox(height: 6),
          Text('It will be gone forever.',
              style: GoogleFonts.nunito(color: AppTheme.inkSoft, fontSize: 13)),
          const SizedBox(height: 28),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.dustyRose),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: GoogleFonts.nunito(
                        color: AppTheme.inkSoft, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Delete',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ]),
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<PostBloc>().add(DeletePostEvent(postId));
    }
  }

  List<Post> _postsFromState(PostState state) {
    if (state is PostLoaded) return state.posts;
    if (state is PostMutating) return state.posts;
    if (state is PostMutationSuccess) return state.posts;
    if (state is PostError) return state.posts;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.bloom,
          ));
        } else if (state is PostError && state.posts.isNotEmpty) {
          // Error after already loaded — show snackbar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.danger,
          ));
        }
      },
      builder: (context, state) {
        final posts = _postsFromState(state);
        final isMutating = state is PostMutating;

        return Scaffold(
          body: Stack(children: [
            CustomScrollView(slivers: [
              // ── Decorative Header ──────────────────────────────────────
              SliverAppBar(
                expandedHeight: 170,
                pinned: true,
                floating: false,
                backgroundColor: AppTheme.mist,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: AppTheme.bloom),
                    onPressed: state is PostLoading
                        ? null
                        : () => context
                            .read<PostBloc>()
                            .add(const FetchPostsEvent()),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _BloomHeader(
                      noteCount: posts.isEmpty && state is! PostLoaded
                          ? null
                          : posts.length),
                ),
              ),

              // ── Body ──────────────────────────────────────────────────
              if (state is PostLoading)
                const SliverFillRemaining(child: BloomLoader())
              else if (state is PostError && state.posts.isEmpty)
                SliverFillRemaining(
                  child: BloomError(
                    message: state.message,
                    onRetry: () =>
                        context.read<PostBloc>().add(const FetchPostsEvent()),
                  ),
                )
              else if (posts.isEmpty)
                const SliverFillRemaining(child: BloomEmpty())
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final post = posts[i];
                      return BloomCard(
                        post: post,
                        index: i,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailScreen(post: post)),
                        ),
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddEditScreen(post: post)),
                        ),
                        onDelete: () => _confirmDelete(context, post.id),
                      );
                    },
                    childCount: posts.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ]),

            // Mutation overlay spinner
            if (isMutating)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const BloomLoader(label: 'Saving…'),
                ),
              ),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: isMutating
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEditScreen()),
                    ),
            backgroundColor: AppTheme.bloom,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: Text('New Note',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }
}

class _BloomHeader extends StatelessWidget {
  final int? noteCount;
  const _BloomHeader({this.noteCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFCCDF), Color(0xFFFCE4EC), Color(0xFFFFF8FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                const Icon(Icons.spa, size: 15, color: AppTheme.bloom),
                const SizedBox(width: 6),
                Text('PETAL BLOOM',
                    style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.bloom,
                        letterSpacing: 2.0)),
              ]),
              const SizedBox(height: 8),
              Text('My Garden',
                  style: GoogleFonts.cormorantGaramond(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.inkDeep)),
              const SizedBox(height: 2),
              if (noteCount != null)
                Text(
                  noteCount == 0 ? 'No notes yet' : '$noteCount notes in bloom',
                  style:
                      GoogleFonts.nunito(fontSize: 12, color: AppTheme.inkSoft),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
