require "rubima_proofreader/version"

module RubimaProofreader
  class Proofreader
    NOT_ASCII  = '[^[:ascii:]]'     # 非ASCII
    ASCII_CHAR = '[\w&&[:ascii:]]'  # ASCII

    OPEN_PARENTHESES  = '[(]'  # 開き丸括弧
    CLOSE_PARENTHESES = '[)]'  # 閉じ丸括弧

    QUESTION_EXCLAMATION = '[？！]'  # 疑問符・感嘆符
    PUNCTUATION = "[、。#{QUESTION_EXCLAMATION}]"  # 句読点

    OPEN_BRANCKETS  = '[「『]'  # 開き括弧類
    CLOSE_BRANCKETS = '[』」]'  # 閉じ括弧類

    THREE_POINT_LEADER = '[…]'  # 三点リーダ

    OTHER_OK_LETTER = "[#{THREE_POINT_LEADER}〜：　]"  # その他OK文字

    HEAD_CHAR = "'''　"  # 発言頭

    # ASCII直前のOK文字
    OK_BEFORE_ASCII = "[#{PUNCTUATION}#{OPEN_BRANCKETS}#{OTHER_OK_LETTER}]"
    # ASCII直後のOK文字
    OK_AFTER_ASCII = "[#{PUNCTUATION}#{CLOSE_BRANCKETS}#{OTHER_OK_LETTER}]"
    # 非ASCIIの直後にASCII
    ASCII_AFTER_NOT_ASCII = /(?<=#{NOT_ASCII})(?=#{ASCII_CHAR})(?<!#{OK_BEFORE_ASCII})(?<!#{HEAD_CHAR})/o
    # ASCIIの直後に非ASCII
    NOT_ASCII_AFTER_ASCII = /(?<=#{ASCII_CHAR})(?=#{NOT_ASCII})(?!#{OK_AFTER_ASCII})/o
    # 空白抜け
    MISSING_BLANK = /#{ASCII_AFTER_NOT_ASCII}|#{NOT_ASCII_AFTER_ASCII}/o

    attr_accessor :datas, :wrong_lines

    def initialize(datas)
      @datas = datas
      @wrong_lines = {}
    end

    def valid?
      valid_result = true
      datas.each_with_index do |line, i|
        line.chomp!
        valid_result = valid_white_space?(line, i + 1)
        break if !valid_result
      end
      valid_result
    end

    private
    # 半角スペースが正しく挿入されている時、trueを返す。
    # 半角スペースが正しく挿入されていない時、falseを返す。
    def valid_white_space?(line, line_no)
      if line.match(MISSING_BLANK).nil?
        true
      else
        @wrong_lines[line_no] = line.gsub(MISSING_BLANK) { "\e[7m \e[m" }
        false
      end
    end
  end
end
