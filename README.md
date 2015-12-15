# RubimaProofreader

[![Build Status](https://travis-ci.org/miyohide/rubima-lint.svg)](https://travis-ci.org/miyohide/rubima-lint)

るびま編集において記事が校正ルールに当てはまっているかをチェックします。また、
`-a`オプションをつけると校正ルールに準拠するように修正します。

## Installation

## Usage

1. るびまの記事をテキストファイルとして保存します。
2. `./rubima-proofreader -f 1.で作成したファイル名`と打つと、校正ルールに当てはまらないものは表示されます。
3. `./rubima-proofreader -a -f 1.で作成したファイル名`と打つと、校正ルールに当てはまらないものの一部が修正されて、`-fで作成されたファイル名`で保存します。修正前のファイルは`-fで指定されたファイル名 + .org`で保存されます。

## Contributing

1. Fork it ( https://github.com/miyohide/rubima-proofreader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
