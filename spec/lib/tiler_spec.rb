require 'spec_helper'

describe Tiler do


  describe :initialize do
    context "called without args" do
      it "should not throw an error" do
        expect{Tiler.new}.to_not raise_error
      end
    end

    context "called with args" do
      it "sets instance variables" do
        t = Tiler.new(zoom: 4)
        expect(t.zoom).to eql 4
      end
    end
  end

  describe :run do
    let(:tiler) { Tiler.new }

    before :each do
      tiler.stub :download
      tiler.stub :stitch
      tiler.stub :cleanup
      tiler.stub :create_collection
    end

    it "calls Tiler#download" do
      expect(tiler).to receive(:download).exactly(1).times
      tiler.run
    end
  end
end
