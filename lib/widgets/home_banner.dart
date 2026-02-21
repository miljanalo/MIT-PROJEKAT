import 'dart:async';
import 'package:flutter/material.dart';
import 'package:knjizara/models/banner_model.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/banner_provider.dart';
import 'package:knjizara/providers/books_provider.dart';
import 'package:knjizara/screens/book_details_screen.dart';
import 'package:knjizara/screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentIndex = 0;
  Timer? _timer;

  void _startAutoScroll(int bannerConut){
    _timer?.cancel();

    if(bannerConut == 0) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        _currentIndex = (_currentIndex + 1).remainder(bannerConut);
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final bannerProvider = context.watch<BannerProvider>();

    return StreamBuilder<List<BannerItem>>(
      stream: bannerProvider.bannersStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 190);
        }

        final banners = snapshot.data!
          .where((b) => b.isActive)
          .toList();

        if (banners.isEmpty) {
          return const SizedBox(height: 190);
        }

        _startAutoScroll(banners.length);

        return Column(
          children: [
            SizedBox(
              height: 190,
              child: PageView.builder(
                controller: _controller,
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final banner = banners[index];

                  return GestureDetector(
                    onTap: () {
                      switch (banner.type) {
                        case BannerType.book:
                          if (banner.bookId != null) {

                            final booksProvider = context.read<BooksProvider>();

                            booksProvider.booksStream.first.then((List<BookModel>books){
                              final matchingBooks = books
                                .where((b) => b.id == banner.bookId)
                                .toList();
                              if(matchingBooks.isNotEmpty){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookDetailsScreen(book: matchingBooks.first),
                                  ),
                                );
                              }
                            });
                          }
                          break;
                          case BannerType.promo:
                          // TODO: Handle this case.
                          break;
                          case BannerType.author:
                          // TODO: Handle this case.
                          break;
                          case BannerType.explore:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SearchScreen()),
                            );
                          break;
                          case BannerType.other:
                          // TODO: Handle this case.
                          throw UnimplementedError();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              banner.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                    ),
                                );
                              },
                            ),
                            
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.55),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // title
                            Positioned(
                              left: 16,
                              bottom: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if(banner.subtitle.isNotEmpty)
                                    Text(
                                      banner.subtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ]     
                        )
                      ),
                    )
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.black
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
