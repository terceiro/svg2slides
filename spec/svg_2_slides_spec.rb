require 'svg_2_slides'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'spec_helper')

describe Svg2Slides do

  include CommandRunner

  it 'displays help message' do
    svg2slides '--help'
    stdout.should match(/--help/)
  end

  it 'displays version number' do
    svg2slides '--version'
    stdout.should match(Svg2Slides::VERSION)
  end

  it 'processes a simple drawing' do
    svg2slides 'simple.svg'
    files.should include('simple-001.svg')
    files.should include('simple-002.svg')
  end

  it 'changes the suffix' do
    svg2slides '--suffix', '_%06d', 'simple.svg'
    files.should include('simple_000001.svg')
    files.should include('simple_000002.svg')
  end

  it 'can be quiet' do
    svg2slides '--quiet', 'simple.svg'
    files.should include('simple-001.svg')
    stdout.should == ''
  end

end
