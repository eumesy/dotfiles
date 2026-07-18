# CLI tools
brew "git"
brew "gh"
brew "ghq"   # リポジトリを ~/ghq/github.com/<user>/<repo> に統一配置
brew "fzf"   # インクリメンタル検索（ghq のリポジトリ選択などに使用）
brew "dockutil"  # Dock の項目を CLI で管理
brew "zoxide"    # 訪れたディレクトリを frecency で記録・ジャンプ
brew "eza"       # ls の現代的代替（色・git 状態・tree 表示）
brew "bat"       # syntax highlight 付き cat/pager（less のハイライトにも使用: zshrc の LESSOPEN）
brew "starship"  # モダンなプロンプト（空行区切り＋色付き ❯ で入力/出力を見分けやすく。zshrc で init）
brew "git-split-diffs" # git diff/show を GitHub 風 side-by-side でハイライト表示（install.sh で core.pager に設定）

# Apps
cask "visual-studio-code"
cask "iterm2"
cask "ghostty"  # ターミナル（GPU 描画・Claude Code の Shift+Enter/通知に無設定で対応）
cask "cmux"     # Ghostty ベースのターミナル。AI エージェント並走用（ワークスペース管理・入力待ち通知・Agent Teams 統合）
cask "claude"   # Claude.app（Claude Code のデスクトップ版もこのアプリ。CLI は自己更新型のため install.sh で導入）
cask "codex"    # OpenAI Codex CLI（cask 配布の CLI。Claude Code から検証用 agent として呼ぶ。導入・認証・秘密情報の扱いは README「OpenAI Codex CLI（検証用 agent）」参照）
cask "chatgpt"  # ChatGPT.app（OpenAI 公式デスクトップ版）。auto_updates の GUI cask なので版更新はアプリ自己更新に任せ、brew は宣言・初回 install のみ担う
cask "karabiner-elements"  # キーボードカスタマイズ（キー remap）。install.sh が Dock にも追加

# Fonts
cask "font-jetbrains-mono-nerd-font"  # Nerd Font グリフ付き JetBrains Mono（iTerm2 プロファイルで使用）
cask "font-plemol-jp-nf"  # PlemolJP NF（IBM Plex Mono + IBM Plex Sans JP 合成、半角:全角=1:2、Nerd Font グリフ付き）。ターミナルの日本語表示用（Ghostty/cmux と VS Code ターミナルで PlemolJP Console NF を使用）

# TeX (MacTeX / TeX Live, GUI アプリなし)
cask "mactex-no-gui"
