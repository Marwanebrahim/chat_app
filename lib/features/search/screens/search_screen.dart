import 'package:chat_app/bloc/search/user_search_bloc.dart';
import 'package:chat_app/bloc/search/user_search_event.dart';
import 'package:chat_app/bloc/search/user_search_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/helpers/chat_helpers.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/themes/app_colors.dart';
import 'package:chat_app/core/themes/app_text_styles.dart';
import 'package:chat_app/features/chats/args/chat_screen_args.dart';
import 'package:chat_app/features/profile/widgets/user_avatar_widget.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/widgets/retry_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 8,
            bottom: MediaQuery.paddingOf(context).bottom,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.text1),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: colors.purple),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: (value) => context
                            .read<UserSearchBloc>()
                            .add(SearchQueryChangedEvent(value)),
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search, color: colors.purple),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<UserSearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitialState) {
                      return _buildInitial(colors, appTextStyles);
                    }

                    if (state is SearchLoadingState) {
                      return _buildLoadingSkeleton();
                    }

                    if (state is SearchErrorState) {
                      return RetryWidget(
                        message: state.errorMessage,
                        onRetry: () => context.read<UserSearchBloc>().add(
                          SearchQueryChangedEvent(_controller.text),
                        ),
                      );
                    }

                    final users = (state as SearchLoadedState).users;

                    if (users.isEmpty) {
                      return _buildNoResults(colors, appTextStyles);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PEOPLE",
                          style: appTextStyles.labelMedium.copyWith(
                            color: colors.text3,
                            letterSpacing: 1,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return ListTile(
                                leading: UserAvatarWidget(
                                  user: user,
                                  radius: 24,
                                ),
                                title: Text(
                                  user.username,
                                  style: appTextStyles.titleLarge.copyWith(
                                    color: colors.text1,
                                  ),
                                ),
                                subtitle: Text(
                                  user.email,
                                  style: appTextStyles.bodyMedium.copyWith(
                                    color: colors.text2,
                                  ),
                                ),
                                onTap: () {
                                  final currentUserId =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  final conversationId =
                                      ChatHelpers.generateConversationId(
                                        currentUserId,
                                        user.uid,
                                      );

                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chat,
                                    arguments: ChatScreenArgs(
                                      peerUserModel: user,
                                      conversationId: conversationId,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitial(AppColors colors, AppTextStyles appTextStyles) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: colors.lightPurple,
            child: Icon(Icons.search, size: 40, color: colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            "Search for people",
            style: appTextStyles.titleLarge.copyWith(color: colors.text1),
          ),
          const SizedBox(height: 4),
          Text(
            "Find someone by their name to start chatting",
            textAlign: TextAlign.center,
            style: appTextStyles.bodyMedium.copyWith(color: colors.text2),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(AppColors colors, AppTextStyles appTextStyles) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: colors.lightPurple,
            child: Icon(Icons.person_search, size: 40, color: colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: appTextStyles.titleLarge.copyWith(color: colors.text1),
          ),
          const SizedBox(height: 4),
          Text(
            "Try a different name",
            style: appTextStyles.bodyMedium.copyWith(color: colors.text2),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) => ListTile(
          leading: UserAvatarWidget(user: UserModel.empty(), radius: 24),
          title: const Text("Loading Name"),
          subtitle: const Text("loading@example.com"),
        ),
      ),
    );
  }
}
