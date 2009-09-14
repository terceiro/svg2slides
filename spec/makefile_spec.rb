require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Makefile snippet' do

  include CommandRunner

  it 'builds the slides' do
    make
    files.should include('simple-001.svg')
    files.should include('simple-002.svg')
  end

  it 'cleans the slides up' do
    original_files  = files
    make
    make 'clean'
    files.should == original_files
  end

end
