import 'package:flutter/material.dart';
import 'package:knjizara/providers/banner_provider.dart';
import 'package:knjizara/screens/admin/banner_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/models/banner_model.dart';

class AdminBannersScreen extends StatelessWidget {
  const AdminBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bannersProvider = Provider.of<BannerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Banners'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BannerFormScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<BannerItem>>(
        stream: bannersProvider.bannersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nema banera'));
          }

          final banners = snapshot.data!;

          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  /*leading: banner.imagePath.isNotEmpty
                      ? Image.network(
                          banner.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 60),*/
                  title: Text(banner.title),
                  subtitle: Text(banner.subtitle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BannerFormScreen(banner: banner),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          bannersProvider.removeBanner(banner.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}