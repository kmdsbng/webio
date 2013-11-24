require "webio/version"
require 'webrick'

class WebIO
  def initialize(connection_spec, option={})
    host, port = connection_spec.split(':')
    @mutex = Mutex.new
    @shell_enable = !!option[:shell]
    Thread.new do
      @srv = srv = WEBrick::HTTPServer.new({:BindAddress => host, :Port => port})
      srv.mount_proc('/') {|req, res|
        @mutex.synchronize {
          monitor_thread = nil
          while true
            monitor_thread = @monitor_thread
            if monitor_thread
              break
            else
              Thread.pass
              sleep 0.1
            end
          end
          res.content_type = 'text/plain'
          @input = req.path.sub('/', '')
          @output = ''

          @callback_thread = Thread.current
          @callback_waiting = true
          monitor_thread.run
          while @callback_waiting
            sleep 0.01
          end
          res.body = @output
        }
      }
      trap("INT"){ srv.shutdown }
      srv.start
      @callback_thread = nil
      @monitor_thread.run rescue nil
    end
  end

  def gets
    if @callback_thread
      @callback_waiting = false
    end
    @monitor_thread = Thread.new do
      Thread.stop
    end
    @monitor_thread.join

    if @callback_thread
      input_line = @input
      if @shell_enable
        if input_line =~ /^command\//
          input_line = @input.sub('command/', '')
        end
      end
      input_line
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

  def close
    @srv.shutdown
    @monitor_thread.kill rescue nil
    @callback_thread.kill rescue nil
  end
end

