require 'spec_helper'

describe StringUtil do

  it "should remove double spaces" do
    StringUtil.remove_double_spaces("This has double  spaces.").should eq("This has double spaces.")
  end

  it "should remove last sentence" do
    StringUtil.remove_last_sentence("First. Second.").should eq("First.")
  end

  it "should remove last sentence" do
    StringUtil.remove_last_sentence("First. ").should eq("First.")
  end

  it "should remove last sentence" do
    StringUtil.remove_last_sentence("First").should eq("First.")
  end

  it "should remove last sentence" do
    StringUtil.remove_last_sentence(" ").should eq("")
  end

  it "should remove last sentence" do
    StringUtil.remove_last_sentence("").should eq("")
  end

  it "should clean commas" do
    StringUtil.clean_commas("57/6-7 Moo 5,B. Bangmakham, T. Angthong,Surat Thani, Koh Samui").should eq("57/6-7 Moo 5, B. Bangmakham, T. Angthong, Surat Thani, Koh Samui")
    StringUtil.clean_commas("No321-A , 1 Lorong Selangor , Bandar Baru Taman Melawati").should eq("No321-A, 1 Lorong Selangor, Bandar Baru Taman Melawati")
  end

end

