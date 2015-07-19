require "spec_helper"

RSpec.describe RubimaProofreader::Validators::Whitespace do
  describe "#validate" do
    context "has a validation error" do
      let(:read_data) { ["ここにはabc半角スペースが必要\n"] }

      before do
        allow(File).to receive(:readlines).and_return(read_data)

        @validator = RubimaProofreader::Validators::Whitespace.new("foobar")
        @validator.validate
      end

      it "warning_lines has a line" do
        expect(@validator.warning_lines).to eq({ 1 => "ここには\e[7m \e[mabc\e[7m \e[m半角スペースが必要\n" })
      end
    end

    context "has a validation error line and a valid line" do
      let(:read_data) { ["ここには半角スペースが不要\n", "ここにはabc半角スペースが必要\n"] }

      before do
        allow(File).to receive(:readlines).and_return(read_data)

        @validator = RubimaProofreader::Validators::Whitespace.new("foobar")
        @validator.validate
      end

      it "warning_lines has a line" do
        expect(@validator.warning_lines.size).to eq(1)
        expect(@validator.warning_lines).to eq({ 2 => "ここには\e[7m \e[mabc\e[7m \e[m半角スペースが必要\n" })
      end
    end
  end

  describe "#validate_and_auto_correct" do
    let(:read_data) { ["ここにはabc半角スペースが必要\n"] }

    before do
      allow(File).to receive(:readlines).and_return(read_data)
      allow(FileUtils).to receive(:cp)

      @validator = RubimaProofreader::Validators::Whitespace.new("foobar")
      @validator.validate_and_auto_correct
    end

    it "warning_lines has a line" do
      expect(@validator.warning_lines.size).to eq(1)
      expect(@validator.warning_lines).to eq({ 1 => "ここには abc 半角スペースが必要\n" })
    end

    after do
      FileUtils.rm("foobar")
    end
  end
end
