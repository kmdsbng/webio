# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'webio'

describe WebIO do
  def send_url(command)
    `curl http://localhost:53333/#{command}`
  end

  def responce_for(command)
    send_url(command)
    @responce
  end

  def start_webio_thread(option=nil)
    @responce = nil
    @webio_thread = Thread.new do
      if option
        @webio = WebIO.new('0.0.0.0:53333', option)
      else
        @webio = WebIO.new('0.0.0.0:53333')
      end
      yield @webio
    end
    #sleep 0.5 # getsを呼ぶまで待つ
  end

  after(:each) do
    @webio_thread.kill
    @webio.close
  end

  context :gets do
    before(:each) do
      start_webio_thread do |webio|
        while l=webio.gets
          @responce = 'koge' + l

        end
      end
    end

    it 'receive web url parameter' do
      responce_for('hoge').should eq 'kogehoge'
    end
  end

  context :lines do
    before(:each) do
      start_webio_thread do |webio|
        webio.lines {|l|
          @responce = 'koge' + l
        }
      end
    end

    it 'receive web url parameter' do
      responce_for('hoge').should eq 'kogehoge'
    end
  end

  context :each_line do
    before(:each) do
      start_webio_thread do |webio|
        webio.each_line {|l|
          @responce = 'koge' + l
        }
      end
    end

    it 'receive web url parameter' do
      responce_for('hoge').should eq 'kogehoge'
    end
  end

  context :shell do
    before(:each) do
      start_webio_thread(:shell => true) do |webio|
        while l=webio.gets
          @responce = 'shell' + l
        end
      end
    end

    it 'receive web url parameter' do
      responce_for('hoge').should eq 'shellhoge'
    end

    it 'receive web url parameter under /command/ path' do
      responce_for('/command/hoge').should eq 'shellhoge'
    end
  end


end

