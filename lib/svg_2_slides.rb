require 'rexml/document'
require 'getoptlong'

class Svg2Slides

  VERSION = '0.1.0'

  def process(inputfile)
    doc = REXML::Document.new(File.new(inputfile))
    layers = doc.elements.each('descendant::g[attribute::inkscape:groupmode="layer"]') { |e| e }
    n = layers.size
    while n > 0
      filename = inputfile.sub('.svg', options['--suffix'] + '.svg') % n
      File.open(filename, 'w') do |f|
        puts "Writing #{filename} ..."
        doc.write(f)
        layers.last.remove
        layers.pop
        n = n - 1
      end
    end
  end

  OPTIONS = []
  OPTIONS << {
    :name => '--suffix',
    :aliases => [ '-s' ],
    :description => 'Set the suffix for the generated files.',
    :arg => GetoptLong::REQUIRED_ARGUMENT,
    :arg_name => 'SUFFIX',
    :default => '-%03d',
  }
  OPTIONS << {
    :name => '--help',
    :aliases => ['-h'],
    :arg => GetoptLong::NO_ARGUMENT,
    :description => 'Displays help',
  }
  def options
    @options ||=
      begin
        opts = {}
        OPTIONS.each do |item|
          opts[item[:name]] = item[:default]
        end
        opts
      end
  end

  def usage
    puts "Usage: svg2slides [OPTIONS] FILE [FILE ...]"
    OPTIONS.each do |opt|
      spec = [opt[:name]] + (opt[:aliases] || [])
      opt_usage =
        case opt[:arg]
        when GetoptLong::NO_ARGUMENT
          spec.join(', ')
        when GetoptLong::REQUIRED_ARGUMENT
          spec.map { |variant| [variant, opt[:arg_name]].join(' ')}.join(', ')
        else
          raise 'unsupported command line option spec: %s' % opt.inspect
        end
      puts 
      puts '  ' + opt_usage
      puts
      puts '    ' + opt[:description]
      if opt[:default]
        puts '    ' + '(default: "%s")' % opt[:default]
      end
    end
  end

  def run
    opts = GetoptLong.new(*OPTIONS.map { |item| [item[:name]] + (item[:aliases] || []) + [item[:arg]] })
    opts.each do |opt, arg|
      options[opt] = arg
    end
    if ARGV.empty?
      usage
    end
    ARGV.each do |item|
      process(item)
    end
  end
end
