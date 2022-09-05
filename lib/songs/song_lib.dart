import 'song.dart';

class SongLib {
  static Song castleInTheSky = Song('Castle In The Sky')
    ..addLine('6,7,6D-1U,1,3,7,1U,3U.,7-3D,5D,7D,3,5.')
    ..addLine('3.,6-4D,6D,1,5,6,1U., 1-5., 3D., 5D.')
    ..addLine('3., 6D-4..,3,4.,1U.,1-3.,5D.,3D')
    ..addLine('1U,1U,1U, 7-7D.,3D,7D,3,7D,3,7,3U..')
    ..addLine('6,7,6D-1U,1,3,7,1U,3U.,7-3D,5D,7D,3,5.')
    ..addLine('3.,6-4D,6D,1,5,6,1U., 1-5., 3D., 5D.')
    ..addLine('3., 6D-4.,1U,7,1U,5D-2U,2U,7D,3U,1U-6D')
    ..addLine('1,3,1,1U-4D,7,6.,7-5D,7D,7.,6-6D., 3D., 6D.')
    ..addLine('1,2,1-3., 5D,2,3,5.,5D-2..')
    ..addLine('7D,5D.,1-6D.,7D,1,3,3-3D..,5D.,7D.,5D.')
    ..addLine('6D-4D,7D,1.,7D-5D,1,2.,1-3D.,5D')
    ..addLine('6D-4.,3.,2-3D.,1, 3-7D.,7.,3..')
    ..addLine('6-6D, 6D, 1, 6, 5-5D,7D,2,5, 7D-3,2,1..')
    ..addLine('1, 2-4D., 1,2..')
    ..addLine('5, 3-7D, 3D, 5D, 1, 3.')
    ..addLine('6-6D, 6D, 1, 6, 5-5D,7D,2,5, 7D-3,2,1..')
    ..addLine('1, 2-4D., 1,2.., 7D.,3D-6D.');

  static Song endlessLove = Song('Endless Love')
    ..addLine('6D.,3.,7D-5D...,6D-4D,1,2,1,3-5D...,')
    ..addLine('6D-4D.,6.,5-5D,6,5,2,3-1,5D,1,2,1-6D...')
    ..addLine('6D-4D.,6.,5-5D,2,3,4,3-1.,2-7D.,1-6D')
    ..addLine('6D-4D.,3.,2-5D..,7D,6D-4D,3D,6D,7D,1...')
    ..addLine('6D,3D,3-6D,3D,7D,3D,7D,3D,6D-4D,1,2,1,3-1')
    ..addLine('5D,1,5D,6D-4D,1,6-4,1,5-5D,6,5,2,3-1')
    ..addLine('5D,1,5D,1,5D,1,2')
    ..addLine('6D-4D,1,6-4,1,5-5D,2,3,4,3-1')
    ..addLine('5D,2-7D,5D,1-6D,3D,6D,1')
    ..addLine('6D-4D.,3-1.,2-5D,5D,2,7D,6D,')
    ..addLine('3D,6D,3D,6D,3,6D,7D,1-6D,')
    ..addLine('2,3,1,7D-5D.,5D.,6D-4D,1,2,3,3-1,5D,6D,7D,')
    ..addLine('1-6D,2,3,1,7D-5D.,5D.,6D-4D,1,2,1')
    ..addLine('1-5D,5D,6D,7D,1-6D,2,3,1,7D-5D.,5D.,6D-4D,1,2,3')
    ..addLine('3-1,5D,6D,7D,1-6D,2,3,1,7D-5D.,5D.,6D-4D,1,2,1')
    ..addLine('1-5D,5D,6D,7D,1-6D,2,3,1,7D-5D.,5D.,3-2,1,2-1,3')
    ..addLine('3-1,5D,6D,7D,1,2-5D,3-1,1-5D,7D-5D.,5D.,1.,7D-5D.')
    ..addLine('5D..,7D,6D,3D,6D,7D,1.,7D,6D.');

  static Song happyBirthDay = Song('HappyBirdDay')
    ..addLine('1,1,2,1,4,3')
    ..addLine('1,1,2,1,5,4')
    ..addLine('1,1,1U,6,4,4,3,2')
    ..addLine('1U,1U,6,4,5,4');

  static Song proudOfYou = Song('proudOfYou')
    ..addLine('3-5D.,3,4,5-7D.,6,7,1U-6D.,3,4,5-5D...')
    ..addLine('5.,1-6D...,6,5-2,1U,5,1,4-2..,1,2.,3.')
    ..addLine('3-1.,3,4,5-7D.,6,7,1U-6D,1U,3,4,5-5D.,2,3')
    ..addLine('4-6D,3,4-1U,1U-3,2,3,4-2,3,4-2U,2U-5D,1U,7')
    ..addLine('1U-1...,2U,3U-7D,2U,1U,7,1U-6D..,1U,7-5D,5,5,1')
    ..addLine('6-4..,6,5-3,1,1,3,2-6D..,3,4-5D,5,1U,7')
    ..addLine('1U-1..,2U,3U-7D,2U,1U,7,1U-6D..,1U,7-5D,5,5,1')
    ..addLine('6-4..,6,5-5D,5,1U,7,1-1U');

  static List<Song?> get songs =>
      [null, castleInTheSky, endlessLove, happyBirthDay, proudOfYou];
}
