import 'package:knjizara/models/book_model.dart';

List<BookModel> booksList = [
  BookModel(
    id: '1',
    title: 'Na Drini ćuprija',
    author: 'Ivo Andrić',
    description: 'Roman o mostu na Drini i sudbinama ljudi kroz vekove.',
    price: 1200,
    imagePath: 'assets/images/nadrini.jpg',
  ),
  BookModel(
    id: '2',
    title: 'Prokleta avlija',
    author: 'Ivo Andrić',
    description: 'Priča o ljudskoj patnji i sudbinama.',
    price: 900,
    imagePath: 'assets/images/PROKLETAAVLIJA.png',
  ),
  BookModel(
    id: '3',
    title: 'Zločin i kazna',
    author: 'Fjodor Dostojevski',
    description: 'Psihološki roman o krivici i iskupljenju.',
    price: 1500,
    imagePath: 'assets/images/zlocin_i_kazna.jpg',
  ),
  BookModel(
    id: '4',
    title: '1984',
    author: 'George Orwell',
    description: 'Distopijski roman o totalitarnom društvu.',
    price: 1100,
    imagePath: 'assets/images/1984.png',
  ),
];