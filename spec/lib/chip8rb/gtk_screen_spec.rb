require 'spec_helper'

describe GTKScreen do
  describe "#initialize" do
  end

  describe "#run" do
    before do
      screen = GTKScreen.new("testapp", 64, 32)
      screen.run
    end

    it "shows a screen correctly" do
    end
  end
end
