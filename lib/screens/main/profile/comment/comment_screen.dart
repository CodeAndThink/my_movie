import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/data/models/user_display_info.dart';
import 'package:my_movie/screens/main/other_screens/list_items/comment_box.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_state.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.user});
  final User user;

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  late String userId;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authBloc = context.read<AuthBloc>();
    userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      _loadUserComment(userId);
    }
  }

  void _loadUserComment(String userDocId) {
    context.read<CommentBloc>().add(FetchCommentByUserId(userDocId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.comments,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is FetchCommentByUserIdSucess) {
            final comments = state.listComments;
            final UserDisplayInfo userDisplayInfo = UserDisplayInfo(
                widget.user.displayName, widget.user.avatarPath);
            return Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentBox(
                    comment: comments[index],
                    userDisplayInfo: userDisplayInfo,
                  );
                },
              ),
            );
          } else if (state is CommentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CommentError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
