import 'package:knjizara/data/books_data.dart';
import 'package:knjizara/models/banner_model.dart';

final List<BannerItem> banners = [
  BannerItem(
    imagePath: 'assets/banner_images/ban4.jpg',
    title: 'Prolećna akcija!',
    subtitle: 'Svi romani -20% ovaj mesec',
    type: BannerType.promo,
  ),
  BannerItem(
    imagePath: 'assets/banner_images/ban1.jpg',
    title: 'Pretražite našu ponudu',
    subtitle: 'Pronađite savršenu knjigu za sebe',
    type: BannerType.explore,
  ),
  BannerItem(
    imagePath: 'assets/banner_images/ban5.jpg',
    title: 'Fjodor Dostojevski',
    subtitle: 'Top autor nedelje',
    type: BannerType.author,
  ),
  BannerItem(
    imagePath: 'assets/banner_images/ban2.jpg',
    title: '',
    subtitle: '',
    type: BannerType.else_,
  ),
  BannerItem(
    imagePath: 'assets/banner_images/ban6.jpg',
    title: 'George Orwell - 1984',
    subtitle: 'Naša preporuka nedelje',
    type: BannerType.book,
    book: booksList.firstWhere((b) => b.id == '4'),
  ),
];
