import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';


class ChatDetailScreen extends StatefulWidget {
  final MessageTileData message;

  const ChatDetailScreen({super.key, required this.message});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}


class _ChatBubbleData {
  final int id;
  final String text;
  final String time;
  final bool isSent;
  final bool isEdited;

  _ChatBubbleData({
    required this.id,
    required this.text,
    required this.time,
    required this.isSent,
    this.isEdited = false,
  });

  _ChatBubbleData copyWith({String? text, bool? isEdited}) {
    return _ChatBubbleData(
      id: id,
      text: text ?? this.text,
      time: time,
      isSent: isSent,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<_ChatBubbleData> _messages;
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    _messages = [
      _ChatBubbleData(
        id: _nextId++,
        text: widget.message.message,
        time: widget.message.time,
        isSent: false,
      ),
      _ChatBubbleData(
        id: _nextId++,
        text: "Hello, is it available for tomorrow? I'd love to check it out.",
        time: "10:26 AM",
        isSent: true,
      ),
      _ChatBubbleData(
        id: _nextId++,
        text: "Yes, available for visit tomorrow? Let me know time that works for you.",
        time: "",
        isSent: false,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();

    setState(() {
      _messages.add(
        _ChatBubbleData(
          id: _nextId++,
          text: text,
          time: TimeOfDay.now().format(context),
          isSent: true,
        ),
      );
      _textController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Get.back();
    }
  }

  // ── Long-press message actions ──────────────────────────────────────────
  void _showMessageOptions(_ChatBubbleData bubble) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.dividerDark : AppColors.borderMedium,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 8.h),
              // Edit — only for messages you sent
              if (bubble.isSent)
                _optionTile(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _editMessage(bubble);
                  },
                ),
              // Unsend — removes it from BOTH sides (sender + receiver)
              if (bubble.isSent)
                _optionTile(
                  icon: Icons.undo_rounded,
                  label: 'Unsend',
                  isDark: isDark,
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _unsendMessage(bubble.id);
                  },
                ),
              // Remove from me — hides it only on your own side
              _optionTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove from me',
                isDark: isDark,
                isDestructive: true,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _removeFromMe(bubble.id);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    return ListTile(
      leading: Icon(icon, color: color, size: 22.r),
      title: Text(
        label,
        style: TextStyle(color: color, fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  void _editMessage(_ChatBubbleData bubble) {
    final editController = TextEditingController(text: bubble.text);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        title: Text(
          'Edit message',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLines: null,
          style: TextStyle(fontSize: 14.sp),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isEmpty) return;
              setState(() {
                final index = _messages.indexWhere((m) => m.id == bubble.id);
                if (index != -1) {
                  _messages[index] =
                      _messages[index].copyWith(text: newText, isEdited: true);
                }
              });
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _unsendMessage(int id) {
    setState(() {
      _messages.removeWhere((m) => m.id == id);
    });
    // TODO: when a real backend/socket is wired up, this must also tell the
    // server to delete the message for the OTHER participant — unsend means
    // gone from both sender's and receiver's chat, not just this device.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message unsent')),
    );
  }

  void _removeFromMe(int id) {
    setState(() {
      _messages.removeWhere((m) => m.id == id);
    });
    // TODO: with a real backend this should only set a "hidden for me" flag
    // tied to the current user's account — the receiver's copy of this
    // message must stay untouched. A hard delete here is only correct
    // because this demo has no shared/multi-device message store yet.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed for you')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context, isDark),
            
            // Main Chat Area
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.w), // Tablet responsiveness
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        
                        // Property Info Card
                        _buildPropertyCard(isDark),
                        
                        SizedBox(height: 16.h),
                        
                        // Date Divider
                        _buildDateDivider(isDark),
                        
                        SizedBox(height: 16.h),

                        // Chat Messages (dynamic, animated entrance, long-press actions)
                        for (final bubble in _messages) ...[
                          _AnimatedChatBubble(
                            key: ValueKey(bubble.id),
                            isSent: bubble.isSent,
                            child: GestureDetector(
                              onLongPress: () => _showMessageOptions(bubble),
                              child: bubble.isSent
                                  ? _buildSentBubble(
                                      message: bubble.text,
                                      time: bubble.time,
                                      isDark: isDark,
                                      isEdited: bubble.isEdited,
                                    )
                                  : _buildReceivedBubble(
                                      message: bubble.text,
                                      time: bubble.time,
                                      isDark: isDark,
                                      isEdited: bubble.isEdited,
                                    ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Input Field
            _buildBottomInputArea(isDark),
          ],
        ),
      ),
    );
  }

  // --- Header Bar ---
  Widget _buildHeader(BuildContext context, bool isDark) {
    final displayName = widget.message.isSystem ? widget.message.title : widget.message.title;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: isDark ? AppColors.surfaceDark : Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _handleBack(context),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Container(
                  width: 36.r,
                  height: 36.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    size: 20.r,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.darkCharcoal,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.more_horiz,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 20.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Receiver Info
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                backgroundImage: widget.message.avatar != null
                    ? NetworkImage(widget.message.avatar!)
                    : null,
                child: widget.message.avatar == null
                    ? Icon(
                        widget.message.isSystem ? Icons.check : Icons.person,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        size: 20.r,
                      )
                    : null,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.ownerOnline,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.phone_outlined,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                child: Icon(
                  Icons.more_horiz,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  size: 18.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Property Card ---
  Widget _buildPropertyCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              'https://picsum.photos/200/200',
              width: 54.r,
              height: 54.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.tag,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.defaultPropertySpecs,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.defaultPropertyPrice,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkCharcoal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              AppStrings.view,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- Date Divider ---
  Widget _buildDateDivider(bool isDark) {
    return Center(
      child: Text(
        "${AppStrings.today} • ${widget.message.time.isNotEmpty ? widget.message.time : '10:24 AM'}",
        style: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // --- Received Bubble ---
  Widget _buildReceivedBubble({
    required String message,
    required String time,
    required bool isDark,
    bool isEdited = false,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(4.r),
          ),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontSize: 13.sp,
              ),
            ),
            if (time.isNotEmpty || isEdited) ...[
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (time.isNotEmpty)
                    Text(
                      time,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 10.sp,
                      ),
                    ),
                  if (isEdited) ...[
                    SizedBox(width: 4.w),
                    Text(
                      '(edited)',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 10.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- Sent Bubble ---
  Widget _buildSentBubble({
    required String message,
    required String time,
    required bool isDark,
    bool isEdited = false,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEdited) ...[
                  Text(
                    '(edited) ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all,
                  color: Colors.white.withOpacity(0.8),
                  size: 14.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Bottom Input Bar ---
  Widget _buildBottomInputArea(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isDark ? AppColors.dividerDark : AppColors.scaffoldBg,
            child: Icon(
              Icons.attach_file,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              size: 20.r,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 13.sp,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.messageUserHint(widget.message.title),
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _handleSend,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated entrance wrapper for chat bubbles ──────────────────────────────
// Bounces + slides + fades in whenever a NEW bubble is inserted. Existing
// bubbles keep their ValueKey(id) across rebuilds, so Flutter reuses their
// State and does not replay the animation — only the freshly added one animates.
class _AnimatedChatBubble extends StatefulWidget {
  final Widget child;
  final bool isSent;

  const _AnimatedChatBubble({
    super.key,
    required this.child,
    required this.isSent,
  });

  @override
  State<_AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<_AnimatedChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: Offset(widget.isSent ? 0.25 : -0.25, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: FractionalTranslation(
            translation: _slide.value,
            child: Transform.scale(
              scale: _scale.value,
              alignment: widget.isSent
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}