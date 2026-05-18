import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/post_bloc.dart';
import '../models/post.dart';
import '../theme/app_theme.dart';

class AddEditScreen extends StatefulWidget {
  final Post? post;
  const AddEditScreen({super.key, this.post});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late final TextEditingController _userIdCtrl;
  bool _submitted = false;

  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.post?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.post?.body ?? '');
    _userIdCtrl =
        TextEditingController(text: widget.post?.userId.toString() ?? '1');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _userIdCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitted = true);

    final bloc = context.read<PostBloc>();
    if (_isEditing) {
      bloc.add(UpdatePostEvent(
        widget.post!.copyWith(
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
          userId: int.tryParse(_userIdCtrl.text.trim()) ?? 1,
        ),
      ));
    } else {
      bloc.add(CreatePostEvent(
        userId: int.tryParse(_userIdCtrl.text.trim()) ?? 1,
        title: _titleCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (!_submitted) return;
        if (state is PostMutationSuccess) {
          Navigator.pop(context);
        } else if (state is PostError) {
          setState(() => _submitted = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.danger,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.mist,
        appBar: AppBar(
          backgroundColor: AppTheme.mist,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.bloom, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _isEditing ? 'Edit Note' : 'New Note',
            style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkDeep),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFCCDF),
                        Color(0xFFFFF8FA),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.dustyRose, width: 1.5),
                  ),
                  child: Row(children: [
                    const Icon(Icons.spa, color: AppTheme.bloom, size: 28),
                    const SizedBox(width: 12),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing ? 'Edit your note' : 'Plant a new note',
                            style: GoogleFonts.cormorantGaramond(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.inkDeep),
                          ),
                          Text('JSONPlaceholder · Bloc + Dio',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: AppTheme.inkSoft)),
                        ]),
                  ]),
                ),
                const SizedBox(height: 24),

                const _Label('Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  style:
                      GoogleFonts.nunito(color: AppTheme.inkDeep, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Give your note a title…',
                    prefixIcon: Icon(Icons.title, color: AppTheme.bloom),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 20),

                const _Label('Content'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyCtrl,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.nunito(
                      color: AppTheme.inkDeep, fontSize: 15, height: 1.6),
                  decoration: const InputDecoration(
                    hintText: 'Write something beautiful…',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.notes, color: AppTheme.bloom),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Content is required'
                      : null,
                ),
                const SizedBox(height: 20),

                const _Label('User ID'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _userIdCtrl,
                  keyboardType: TextInputType.number,
                  style:
                      GoogleFonts.nunito(color: AppTheme.inkDeep, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 1',
                    prefixIcon:
                        Icon(Icons.person_outline, color: AppTheme.bloom),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                BlocBuilder<PostBloc, PostState>(
                  builder: (_, state) {
                    final busy = state is PostMutating && _submitted;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.bloom,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: busy ? null : _submit,
                        child: busy
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                _isEditing ? 'Save Changes' : 'Create Note',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.inkDeep,
            letterSpacing: 0.2),
      );
}
