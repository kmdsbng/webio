require "webio/version"
require 'webrick'

class WebIO
  def initialize(connection_spec)
    host, port = connection_spec.split(':')
    @mutex = Mutex.new
    Thread.new do
      srv = WEBrick::HTTPServer.new({:BindAddress => host, :Port => port})
      srv.mount_proc('/') {|req, res|
        @mutex.synchronize {
          res.content_type = 'text/plain'
          @input = req.path.sub('/', '')
          @output = ''

          @resume_thread = Thread.current
          @monitor_thread.run
          Thread.stop
          res.body = @output
        }
      }
      trap("INT"){ srv.shutdown }
      srv.start
      @resume_thread = nil
      @monitor_thread.run rescue nil
    end
  end

  def gets
    @resume_thread.run rescue nil
    @monitor_thread = Thread.new do
      Thread.stop
    end
    @monitor_thread.join

    if @resume_thread
      @input
    else
      nil
    end
  end

  def read(*argv)
    gets
  end

  def each_line(*argv)
    while(l=self.gets)
      yield(l)
    end
  end

  alias_method :lines, :each_line

  def print(*argv)
    argv.each {|o|
      self.write(o.to_s)
    }
  end

  def puts(*argv)
    argv.each {|o|

      if o.kind_of?(Array)
        o.each {|col|
          self.puts(col)
        }
      else
        self.print(o)
        self.print("\n")
      end
    }

  end

  def write(str)
    @output << str.to_s
  end
end

