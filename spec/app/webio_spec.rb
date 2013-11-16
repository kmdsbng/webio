# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'webio'

describe WebIO do

  context :gets do
    before(:each) do
      @input_line = nil
      @webio_thread = Thread.new do
        @webio = WebIO.new('0.0.0.0:53333')
        puts '---1---'
        puts '---1.1---'
        while l=@webio.gets
          puts '---2---'
          @input_line = l
        end
      end
      sleep 0.5 # getsを呼ぶまで待つ
    end

    after(:each) do
      @webio_thread.kill
      @webio.close
    end

    def send_url(command)
      `curl http://localhost:53333/hoge`
    end

    it 'receive web url parameter' do
      `curl http://localhost:53333/hoge`
      @input_line.should eq 'hoge'
    end
  end

end

