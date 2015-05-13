require "rubima_proofreader/validators/whitespace"

module RubimaProofreader
  class Proofread
    def initialize(filename, options = {})
      @filename = filename
      @options  = options
    end

    def run
      RubimaProofreader::Validators::Whitespace.new(@filename, @options).run
    end
  end
end
