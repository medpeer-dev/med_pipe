# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::Pipeline do
  describe "#run" do
    it "returns a positive number" do
      pipeline = MedPipe::Pipeline.new
      expect(pipeline.run).to be 1
    end
  end
end
