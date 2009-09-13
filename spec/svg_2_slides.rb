require 'svg_2_slides'
require 'fileutils'

describe Svg2Slides do

  TMP_DIR = File.join(File.dirname(__FILE__), '..', 'trash')

  before(:all) do
    ENV['PATH'] = File.join(File.dirname(__FILE__), '..', 'bin') + ':' + ENV['PATH']
    ENV['RUBYLIB'] =
      File.join(File.dirname(__FILE__), '..', 'lib') + 
      (ENV['RUBYLIB'] ? (':' + ENV['RUBYLIB']) : '')
  end
  before(:each) do
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'sample'), TMP_DIR)
    Dir.chdir(TMP_DIR)
  end
  after(:each) do
    Dir.chdir(File.join(File.dirname(__FILE__), '..'))
    FileUtils.rm_rf(TMP_DIR)
  end

  it 'should display help message' do
    svg2slides '--help'
    stdout.should match(/--help/)
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
    puts ">>>>" + command
  end
  attr_reader :stdout
  attr_reader :stderr
  attr_reader :exit_status

end
