//枚举类定义API常量
enum MusicApi {

  Url(
      song:"https://interface.music.163.com/eapi/song/enhance/player/url/v1",
      list: "https://interface.music.163.com/eapi/search/song/list/page"
  ),
  Path(
      song : "/api/song/enhance/player/url/v1",
      list : "/api/search/song/list/page"
  );

  final String song;
  final String list;
  const MusicApi({required this.song, required this.list});
}

void main() {
  print(MusicApi.Path.list);
}
