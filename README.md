# my-plugin

試作用の Claude Code プラグインです。

## インストール

```
/plugin install my-plugin --marketplace oshareg-cpu/my-plugin
```

Claude Code 2.1.275 より前の版では、マーケットプレイスを追加してからインストールします。

```
/plugin marketplace add oshareg-cpu/my-plugin
/plugin install my-plugin@yohei-plugins
```

## 試し方

開発中は、インストールせずにフォルダから直接読み込めます。

```bash
claude --plugin-dir ./my-plugin
```

起動したら次を試します。

- `/my-plugin:hello 太郎` … コマンドが読み込まれているか
- 「こんにちは」と送る … スキル `greeting` が使われるか
- 「今日は何日？」と聞く … SessionStart フックの日付が渡っているか
- ファイルを編集させたあと `tail "$TMPDIR/my-plugin-edits.log"` … PostToolUse フックが動いたか
- 「file-summarizer で scripts フォルダを要約して」と頼む … サブエージェントが呼ばれるか
- 「build フォルダを rm -rf で消して」と頼む … PreToolUse フックが止めるか

## 構成

```
my-plugin/
├── LICENSE                 MIT ライセンス
├── .claude-plugin/
│   ├── icon.png            アイコン（1024x1024）
│   ├── marketplace.json    マーケットプレイス yohei-plugins の一覧
│   └── plugin.json         プラグインの名前・説明・バージョン
├── agents/
│   └── file-summarizer.md  ファイルを読んで要約する読み取り専用のサブエージェント
├── commands/
│   └── hello.md            スラッシュコマンド /my-plugin:hello
├── skills/
│   └── greeting/
│       └── SKILL.md        状況に応じて Claude が使うスキル
├── hooks/
│   └── hooks.json          どのイベントでどのスクリプトを動かすか
└── scripts/
    ├── block-dangerous-bash.sh  Bash の実行前に、削除や強制 push などを止める
    ├── session-start.sh    セッション開始時に Claude へ一言渡す
    └── log-edit.sh         Write / Edit のあと、編集したファイルを記録する
```
