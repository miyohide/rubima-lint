module RubimaProofreader
  module Validators
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

    class Whitespace
      attr_reader :warning_lines

      def initialize(filename, options = {})
        @filename = filename
        @options  = options
        @warning_lines = {}
        dirname = File.dirname(@filename)
        basename = File.basename(@filename)
        @backup_filename = File.join(dirname, basename + ".org")
      end

      def run
        if @options[:a]
          validate_and_auto-correct
        else
          validate
        end

        if warning_lines.empty?
          puts "エラー無し"
        else
          warning_lines.each do |key, val|
            puts "#{key}行目：#{val}"
          end
        end
      end

      def validate_and_auto-correct
        file_backup

        File.open(@filename, "w") do { |file|
          file_read(@backup_filename).each_with_index do |line, line_no|
            if line.gsub!(MISSING_BLANK) { " " }
              @warning_lines[line_no + 1] = line
            end
          end
          file.print(line)
        }
      end

      def validate
        file_read.each_with_index do |line, line_no|
          if line.gsub!(MISSING_BLANK) { "\e[7m \e[m" }
            @warning_lines[line_no + 1] = line
          end
        end
      end

      def file_read(fname = @filename)
        File.readlines(fname)
      end

      def file_backup
        FileUtils.cp(@filename, @backup_filename)
      end
    end
  end
end
