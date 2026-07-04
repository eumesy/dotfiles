---
name: latex-figures
description: LaTeX文書（和文・英文問わず）に図を挿入・参照するときの規約。figure環境の追加、\includegraphics の記述、図番号の参照、外部素材のクレジット表記をおこなう際は必ず適用する。
---

# LaTeXへの図の挿入

## 基本テンプレート

```latex
\begin{figure}[tb]
    \centering
    \includegraphics[width=\columnwidth]{fig/<figure_name>.pdf}
    \caption{...}
    \label{fig:<figure_name>}
\end{figure}
```

- 配置指定は`[tb]`を基本とする（`[h]`は避ける）。
- `width`か`height`の**片方だけ**指定する。片方指定なら縦横比は自動で保持される。
  `keepaspectratio`は width と height を両方指定したときにのみ意味を持つので、
  片方指定の場合は書かない。
- 図ファイルは`fig/`ディレクトリに置き、内容が分かる snake_case 名にする。
  `\label`はファイル名と揃える（例: `fig/transport_problem.pdf` ↔ `fig:transport_problem`）。

## 図の参照

- **先にクラス・スタイルファイル固有の参照マクロがないか確認する。**
  キャプションの番号書式（`\fnum@figure`）と本文中の参照書式は一致させる。
  - 例: ISCIE 会誌（scitrans.cls / sci209.sty）はキャプションが「第1図」形式なので、
    本文参照も`\rfig{fig:...}`（→「第1図」）を使う。`図\ref{...}`（→「図1」）だと食い違う。
- 汎用クラスの場合: 和文は`図\ref{fig:...}`、英文は`Fig.~\ref{fig:...}`。

## エンジン・ドライバの整合

- platex / uplatex + dvipdfmx の場合、プリアンブルは`\usepackage[dvipdfmx]{graphicx}`
  （xcolor を使う場合も`[dvipdfmx]`を付ける）。

## 図ファイルの前処理

- モノクロ誌に載せる図はグレースケール化してから使う:
  ```sh
  gs -o out.pdf -sDEVICE=pdfwrite -sColorConversionStrategy=Gray \
     -dProcessColorModel=/DeviceGray -dNOPAUSE -dBATCH -dQUIET in.pdf
  ```
  変換後、色の区別が濃淡の区別として残っているか必ず目視確認する。

## 外部素材のクレジット

- 他出版物からの流用図や素材サイト（いらすとや等）のイラストを含む図は、
  キャプション・footnote・謝辞のいずれかで出典を明記する（掲載位置は著者に確認）。
- 素材側の利用規約と掲載誌側の規定の両方を確認する。

## 挿入後の確認

- ビルドして (1) 参照が「??」になっていないか、(2) float の飛び先が不自然でないか、
  (3) ページ数制約を超えていないか、を確認する。可能ならページを画像化して紙面を目視する。
