CURDIR = File.expand_path(Dir.pwd)
TMPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..', 'trash'))

Spec::Runner.configure do |config|

  config.before(:all) do
    ENV['PATH'] = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin')) + ':' + ENV['PATH']
    ENV['RUBYLIB'] =
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')) + 
      (ENV['RUBYLIB'] ? (':' + ENV['RUBYLIB']) : '')
  end

  config.before(:each) do
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '..', 'sample'), TMPDIR)
    Dir.chdir(TMPDIR)
  end

  config.after(:each) do
    Dir.chdir(CURDIR)
    FileUtils.rm_rf(TMPDIR)
  end

end

module CommandRunner
  def make(*args)
    args.unshift('make --quiet')
    run_command(args)
  end
  def svg2slides(*args)
    args.unshift('svg2slides')
    run_command(*args)
  end
  def run_command(*command_line)
    command = command_line.join(' ') + " >tmp.out 2>tmp.err"
    system(command)
    if $?.is_a?(Fixnum)
      @exit_status = $?
    else
      @exit_status = $?.exitstatus
    end
    @stdout = File.readlines('tmp.out').join
    @stderr = File.readlines('tmp.err').join
    FileUtils.rm_f('tmp.out')
    FileUtils.rm_f('tmp.err')
  end
  attr_reader :stdout
  attr_reader :stderr
  attr_reader :exit_status
  def files
    Dir.glob('*')
  end
end
