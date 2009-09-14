require 'svg_2_slides'
require 'fileutils'

describe Svg2Slides do

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

  CURDIR = File.expand_path(Dir.pwd)
  TMPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..', 'trash'))

  before(:all) do
    ENV['PATH'] = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin')) + ':' + ENV['PATH']
    ENV['RUBYLIB'] =
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')) + 
      (ENV['RUBYLIB'] ? (':' + ENV['RUBYLIB']) : '')
  end
  before(:each) do
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'sample'), TMPDIR)
    Dir.chdir(TMPDIR)
  end
  after(:each) do
    Dir.chdir(CURDIR)
    FileUtils.rm_rf(TMPDIR)
  end

  def svg2slides(*args)
    command = 'svg2slides ' + args.join(' ') + " >tmp.out 2>tmp.err"
    system(command)
    if $?.is_a?(Fixnum)
      @exit_status = $?
    else
      @exit_status = $?.exitstatus
    end
    @stdout = File.readlines('tmp.out').join
    @stderr = File.readlines('tmp.err').join
  end
  attr_reader :stdout
  attr_reader :stderr
  attr_reader :exit_status
  def files
    Dir.glob('*')
  end

end
