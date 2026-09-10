import 'dart:async';
import 'package:flutter/material.dart';
import 'package:custodiaa/core/theme/app_colors.dart';

class ReelItem {
  final String id;
  final String title;
  final String author;
  final String authorHandle;
  final String likes;
  final int duration;
  final String thumbnail;
  bool liked;

  ReelItem({
    required this.id,
    required this.title,
    required this.author,
    required this.authorHandle,
    required this.likes,
    required this.duration,
    required this.thumbnail,
    this.liked = false,
  });
}

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final List<ReelItem> _reels = [
    ReelItem(
      id: '1',
      title: 'Tips Upgrade Kartu ke 5G — Prosesnya gampang banget, cuma 10 menit di outlet!',
      author: 'CSE Jakarta',
      authorHandle: '@cse.jakarta',
      likes: '29 rb',
      duration: 9,
      thumbnail: 'https://images.unsplash.com/photo-1556155092-490a1ba16284?w=800&auto=format&fit=crop&q=80',
    ),
    ReelItem(
      id: '2',
      title: 'Cara Ganti Kartu Hilang — Jangan panik! Ini langkah-langkahnya step by step',
      author: 'CSE Bandung',
      authorHandle: '@cse.bandung',
      likes: '12.4 rb',
      duration: 12,
      thumbnail: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&auto=format&fit=crop&q=80',
    ),
    ReelItem(
      id: '3',
      title: 'Paket Internet Terbaik 2026 — Data unlimited mulai dari 50 ribu per bulan!',
      author: 'CSE Surabaya',
      authorHandle: '@cse.surabaya',
      likes: '41.7 rb',
      duration: 8,
      thumbnail: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&auto=format&fit=crop&q=80',
    ),
    ReelItem(
      id: '4',
      title: 'Review Outlet Grand Indonesia — Pelayanan top, wajib dikunjungi!',
      author: 'CSE Jakarta',
      authorHandle: '@cse.jakarta.gi',
      likes: '8.9 rb',
      duration: 10,
      thumbnail: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800&auto=format&fit=crop&q=80',
    ),
    ReelItem(
      id: '5',
      title: 'Tutorial eSIM Activation — Aktifkan eSIM mu dalam 3 menit!',
      author: 'CSE Medan',
      authorHandle: '@cse.medan',
      likes: '67.2 rb',
      duration: 7,
      thumbnail: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80',
    ),
  ];

  late PageController _pageController;
  int _currentIndex = 0;
  bool _showHeartAnim = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDoubleTap(ReelItem reel) {
    setState(() {
      reel.liked = true;
      _showHeartAnim = true;
    });
    Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeartAnim = false);
    });
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        final shares = [
          {'label': 'WhatsApp', 'icon': Icons.chat_bubble_rounded, 'color': const Color(0xFF22C55E)},
          {'label': 'Instagram', 'icon': Icons.camera_alt_rounded, 'color': AppColors.accent500},
          {'label': 'Telegram', 'icon': Icons.send_rounded, 'color': AppColors.cyan500},
          {'label': 'Salin Link', 'icon': Icons.link_rounded, 'color': AppColors.primary600},
        ];

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.background300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bagikan ke',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground950,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: shares.map((s) {
                  final color = s['color'] as Color;
                  return InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tautan disalin untuk ${s['label']}!')),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(s['icon'] as IconData, size: 24, color: color),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s['label'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.foreground700),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Stack(
            children: [
              // Vertical PageView
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _reels.length,
                onPageChanged: (idx) => setState(() => _currentIndex = idx),
                itemBuilder: (context, idx) {
                  final reel = _reels[idx];
                  return GestureDetector(
                    onDoubleTap: () => _onDoubleTap(reel),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Image.network(
                          reel.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.videocam_outlined, size: 64, color: Colors.white24),
                            ),
                          ),
                        ),

                        // Gradient Overlays
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent, Colors.black87],
                              stops: [0.0, 0.4, 0.85],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // Double tap animated heart
                        if (_showHeartAnim)
                          Center(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.2, end: 1.2),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticOut,
                              builder: (context, scale, child) => Transform.scale(
                                scale: scale,
                                child: const Icon(
                                  Icons.favorite,
                                  size: 100,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),

                        // Right action buttons
                        Positioned(
                          right: 16,
                          bottom: 110,
                          child: Column(
                            children: [
                              _buildActionButton(
                                icon: reel.liked ? Icons.favorite : Icons.favorite_border,
                                label: reel.likes,
                                color: reel.liked ? Colors.redAccent : Colors.white,
                                onTap: () => setState(() => reel.liked = !reel.liked),
                              ),
                              const SizedBox(height: 18),
                              _buildActionButton(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: 'Komentar',
                                color: Colors.white,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Komentar video dibuka!')),
                                  );
                                },
                              ),
                              const SizedBox(height: 18),
                              _buildActionButton(
                                icon: Icons.share_rounded,
                                label: 'Bagikan',
                                color: Colors.white,
                                onTap: _showShareSheet,
                              ),
                            ],
                          ),
                        ),

                        // Bottom info
                        Positioned(
                          left: 16,
                          right: 80,
                          bottom: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Author row
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white24,
                                    child: const Icon(Icons.person, size: 20, color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    reel.author,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary600,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Gabung',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Title
                              Text(
                                reel.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Music ticker
                              Row(
                                children: [
                                  const Icon(Icons.music_note_rounded, size: 14, color: Colors.white70),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Custodia · Video Edukasi CSE · ${reel.author}',
                                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Progress indicator at bottom
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: LinearProgressIndicator(
                            value: 0.7,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary500),
                            minHeight: 2.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Top dots
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_reels.length, (i) {
                    final isCurrent = i == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: isCurrent ? 24 : 12,
                      height: 3,
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
