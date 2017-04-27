var albumPicasso = {
  title: 'The Colors',
  artist: 'Pablo Picasso',
  label: ' Cubism',
  year: '1881',
  albumArtUrl: 'assets/images/album_covers/01.png',
  songs: [
    { title: 'Blue', duration: '4:26'},
    { title: 'Green', duration: '3:14'},
    { title: 'Red', duration: '5:01'},
    { title: 'Pink', duration: '3:21'},
    { title: 'Magenta', duration: '2:15'},
  ]
};

var albumMarconi = {
  title: 'The Telephone',
  artist: 'Guglielmo Marconi',
  label: ' EM',
  year: '1909',
  albumArtUrl: 'assets/images/album_covers/20.png',
  songs: [
    { title: 'Hello, Operator?', duration: '1:01'},
    { title: 'Ring, ringm ring', duration: '5:01'},
    { title: 'Fits in your pocket', duration: '3:21'},
    { title: 'Can you hear me now?', duration: '3:14'},
    { title: 'Wrong phone number', duration: '2:15'},
  ]
};

var albumKnifeParty = {
  title: 'Abandon Ship',
  artist: 'Knife Party',
  label: ' Earstorm',
  year: '2014',
  albumArtUrl: 'assets/images/album_covers/Knife_Party_-_Abandon_Ship.jpg',
  songs: [
    { title: 'Boss Mode', duration: '3:47'},
    { title: '404', duration: '4:59'},
    { title: 'Give it up', duration: '4:11'},
    { title: 'Red Dawn', duration: '6:07'},
    { title: 'Begin Again', duration: '5:55'},
  ]
};

var createSongRow = function(songNumber, songName, songLength) {
  var template =
    '<tr class="album-view-song-item">'
    +'  <td class="song-item-number" data-song-number="' + songNumber + '">' + songNumber + '</td>'
    +'  <td class="song-item-title">' + songName + '</td>'
    +'  <td class="song-item-duration">' + songLength + '</td>'
    +'</tr>'
    ;
  return template;
};

var albumTitle = document.getElementsByClassName('album-view-title')[0];
var albumArtist = document.getElementsByClassName('album-view-artist')[0];
var albumReleaseInfo = document.getElementsByClassName('album-view-release-info')[0];
var albumImage = document.getElementsByClassName('album-cover-art')[0];
var albumSongList = document.getElementsByClassName('album-view-song-list')[0];

var setCurrentAlbum = function(album) {
    albumTitle.firstChild.nodeValue = album.title;
    albumArtist.firstChild.nodeValue = album.artist;
    albumReleaseInfo.firstChild.nodeValue = album.year + ' ' + album.label;
    albumImage.setAttribute('src', album.albumArtUrl);

    albumSongList.innerHTML = '';

    for (var i = 0; i < album.songs.length; i++) {
        albumSongList.innerHTML += createSongRow(i + 1, album.songs[i].title, album.songs[i].duration);
    }
};

var songListContainer = document.getElementsByClassName('album-view-song-list')[0];
var songRows = document.getElementsByClassName('album-view-song-item');
var playButtonTemplate = '<a class="album-song-button"><span class="ion-play"></span></a>';

window.onload = function() {
    setCurrentAlbum(albumPicasso);

    songListContainer.addEventListener('mouseover', function(event) {
      console.log(event.target);
      if (event.target.parentElement.className === 'album-view-song-item') {
        event.target.parentElement.querySelector('.song-item-number').innerHTML = playButtonTemplate;
      }
    });

    for (var i = 0; i < songRows.length; i++) {
      songRows[i].addEventListener('mouseleave', function(event) {
        this.children[0].innerHTML = this.children[0].getAttribute('data-song-number');
      });
    }

    var albums = [albumPicasso, albumMarconi, albumKnifeParty];
    var index = 0;
    albumImage.addEventListener("click", function(event) {
      setCurrentAlbum(albums[index]);
      index++;
      if (index == albums.length) {
        index = 0;
      }

    });
};
