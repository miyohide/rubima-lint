require 'spec_helper'

describe RubimaProofreader do
  it 'has a version number' do
    expect(RubimaProofreader::VERSION).not_to be nil
  end

  describe "missing blank data" do
    before do
      check_file_datas = File.readlines("spec/datas/missing_blank_data.txt")
      @rubima_lint = RubimaProofreader::RubimaLint.new(check_file_datas)
    end

    it "check result is false" do
      expect(@rubima_lint.valid?).to be_falsey
    end

    it "wrong_lines is not empty" do
      @rubima_lint.valid?
      expect(@rubima_lint.wrong_lines).to eq({})
    end
  end

  describe "no missing blank data" do
    before do
      check_file_datas = File.readlines("spec/datas/no_missing_blank_data.txt")
      @rubima_lint = RubimaProofreader::RubimaLint.new(check_file_datas)
    end

    it "check result is true" do
      expect(@rubima_lint.valid?).to be_truthy
    end

    it "wrong_lines is empty" do
      @rubima_lint.valid?
      expect(@rubima_lint.wrong_lines).to eq({})
    end
  end
end
