---
name: latex-links-refs
description: LaTeXでハイパーリンク(URL)や相互参照(ref/label)を扱うときの規約とトラブル対処。とくにhyperrefが使えない古い和文クラス(学会テンプレート等)でクリック可能リンクを入れる方法。URL・\href・\url・hyperref・クリック可能・相互参照まわりを編集する際に適用する。
---

# LaTeX のリンク・相互参照

## クリック可能な URL の基本

- 標準は hyperref: `\href{URL}{表示テキスト}`（クリック可能＋表示を短縮できる）、`\url{URL}`（URL文字列をそのまま整形）。
- hyperref はプリアンブルで**最後に**読み込むのが定石。dvipdfmx 経路なら `\usepackage[dvipdfmx]{hyperref}`。
- 印刷体裁で枠・色を出したくないときは `hidelinks` オプション。

## 落とし穴1: hyperref は古い和文学会クラスと非互換なことがある

システム制御情報学会の `scitrans`（`sci209.sty` 等）など、1990〜2000年代の和文 jclass は hyperref と競合する。症状は **`Illegal unit of measure (pt inserted)`** が `\Journal`・`\maketitle`（見出し）・`\address`・`\keywords` など複数のクラスマクロで発生。原因はこれらが脚注機構や独自の寸法計算を流用しており、hyperref の再定義で寸法解釈が壊れるため。

- **効かない回避策**（試行済み）: 読み込み順を後ろにする／`implicit=false`／`hyperfootnotes=false`／`bookmarks=false`/`setpagesize=false`。いずれも別のクラスマクロで落ちる。
- `-halt-on-error` を外すと「pt を補って」DVI 自体は出るが、住所・キーワード等の**レイアウトが崩れ**、しかも**リンク注釈は入らない**（＝強行は無意味）。投稿用途では不可。

## 落とし穴2: `\url` は moving argument で fragile

`\caption{... \url{...} ...}` はエラー `\Url Error ->\url used in a moving argument.` になる。対処は `\protect\url{...}`、または robust なマクロにする。

## 解決策: hyperref なしで dvipdfmx の \special でリンク注釈を直接埋め込む

dvipdfmx 専用だが、クラスを一切触らずに「クリック可能＋短縮表示」を実現できる。`\href` と同じ使い勝手のマクロを自前定義する。

```latex
% クリック可能な短縮URL（hyperref はクラス非互換のため、dvipdfmx の \special で注釈を直接埋め込む）
% \pdfurl{リンク先URL}{表示テキスト}
\DeclareRobustCommand{\pdfurl}[2]{%
  \special{pdf:bann<</Type/Annot/Subtype/Link/Border[0 0 0]/A<</S/URI/URI(#1)>>>>}#2\special{pdf:eann}}
```

- 使用例: `\pdfurl{https://www.irasutoya.com/}{\texttt{irasutoya.com}}`
- `\DeclareRobustCommand` なので `\caption` 内でも `\protect` 不要。
- `Border[0 0 0]` で枠なし。注釈の矩形は `bann`〜`eann` で囲んだ内容から dvipdfmx が自動算出（改行をまたいでも可）。
- **dvipdfmx 専用**（pdflatex/lualatex では別の driver 指定が必要）。汎用性が要るなら hyperref を、クラス非互換なら本マクロを、と使い分ける。

## リンクが本当に PDF に入ったかの検証手順

`strings foo.pdf | grep URI` は**圧縮 PDF だと出ない**。dvipdfmx を無圧縮で走らせて確認する。

```sh
dvipdfmx -z 0 -o /tmp/uncmp.pdf foo.dvi
grep -aoE "/Subtype/Link.*URI\([^)]*\)" /tmp/uncmp.pdf   # 注釈が出れば成功
grep -aoiE "/Subtype ?/Link" /tmp/uncmp.pdf | wc -l       # リンク数
```

## 相互参照（ref/label）

- 基本は `\label{key}` と `\ref{key}`／`\pageref{key}`。式は `\eqref`（amsmath）。
- `scitrans` 系は `\Journal` 実行時に `\rfig{fig:...}`（「図N」付き参照）、`\rtab`（「表N」）、`\req`（「(式N)」）などの和文参照マクロを定義する。この系のクラスではこれらを使うと図表番号＋和字ラベルが自動で付く。
- ラベル未定義や番号ズレは複数回コンパイルで解消（latexmk が自動で回す）。
