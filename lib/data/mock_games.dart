import 'package:gameshelf/models/game.dart';

const mockGames = [
  Game(
    id: 1,
    title: "The Witcher 3",
    platform: "PC",
    rating: 3,
    length: 28,
    finished: true,
    cover: "assets/covers/tw3.jpg",
    review:"",
  ),

  Game(
    id: 2,
    title: "Elden Ring",
    platform: "Switch 2",
    rating: 4,
    length: 19,
    finished: true,
    cover: "assets/covers/elden.jpg",
    review: "Una obra mestra. El món és increïble i l'exploració és de les millors que he jugat.",
  ),

  Game(
    id: 3,
    title: "Hollow Knight",
    platform: "Switch",
    rating: 4,
    length: 1,
    finished: false,
    cover: "assets/covers/hollow.jpg",
    review: "",
  ),
];