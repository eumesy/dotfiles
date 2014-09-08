#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/param.h>
#include <sys/uio.h>
#include <unistd.h>

#define BUF_LEN 256                      /* バッファのサイズ */

int main(int argc, char *argv[]){
  int s;                               /* ソケットのためのファイルディスクリプタ */
  struct hostent *servhost;            /* ホスト名と IP アドレスを扱うための構造体 */
  struct sockaddr_in server;           /* ソケットを扱うための構造体 */
  struct servent *service;             /* サービス (http など) を扱うための構造体 */
  char buf[BUF_LEN];
  int read_size;

  char *host;
  //char host[BUF_LEN] = "127.0.0.1";    /* 接続するホスト名 */
  char path[BUF_LEN] = "/";            /* 要求するパス */
  unsigned short port = 5000;             /* 接続するポート番号 */

  /* 引数が不足している場合 */
  if (argc < 3) {
    printf("usage: client [hostname] [port]\n");
    exit(1);
  }

  /* コマンドライン引数からサーバ名を取得 */
  if (argc > 1) {
    host = (char *)argv[1];
  }

  if (argc > 2) {
    port = atoi(argv[2]);
  }

  /* ホストの情報(IPアドレスなど)を取得 */
  servhost = gethostbyname(host);
  if ( servhost == NULL ){
    fprintf(stderr, "[%s] から IP アドレスへの変換に失敗しました。\n", host);
    return 0;
  }

  bzero(&server, sizeof(server));            /* 構造体をゼロクリア */

  server.sin_family = AF_INET;

  /* IPアドレスを示す構造体をコピー */
  bcopy(servhost->h_addr, &server.sin_addr, servhost->h_length);

  server.sin_port = htons(port);

  /* ソケット生成 */
  if ( ( s = socket(AF_INET, SOCK_STREAM, 0) ) < 0 ){
    fprintf(stderr, "ソケットの生成に失敗しました。\n");
    return 1;
  }
  /* サーバに接続 */
  if ( connect(s, (struct sockaddr *)&server, sizeof(server)) == -1 ){
    fprintf(stderr, "connect に失敗しました。\n");
    return 1;
  }

  /* 名前の送信 */
  read_size = read(s, buf, BUF_LEN);
  if ( read_size > 0 ){
    write(1, buf, read_size);
  }

  fgets(buf, BUF_LEN, stdin);
  write(s, buf, strlen(buf));

  read_size = read(s, buf, BUF_LEN);
  if ( read_size > 0 ){
    write(1, buf, read_size);
  }

  /* IDとクライアント数、商品数の読み込み */
  read_size = read(s, buf, BUF_LEN);
  if ( read_size > 0 ){
    write(1, buf, read_size);
  }

  read_size = read(s, buf, BUF_LEN);
  if ( read_size > 0 ){
    write(1, buf, read_size);
  }

  /* 送受信ループ */
  /* 標準入力をそのまま送信、入札結果と価格を受信して表示 */
  while (1) {
    fgets(buf, BUF_LEN, stdin);
    write(s, buf, strlen(buf));

    read_size = read(s, buf, BUF_LEN);
    if ( read_size > 0 ){
      write(1, buf, read_size);
    }
    read_size = read(s, buf, BUF_LEN);
    if ( read_size > 0 ){
      write(1, buf, read_size);
    }
  }

  close(s);

  return 0;
}
