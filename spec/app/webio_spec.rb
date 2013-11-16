# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'webio'

describe WebIO do

  context :gets do
    before(:each) do
      @response = nil
      @webio_thread = Thread.new do
        @webio = WebIO.new('0.0.0.0:53333')
        while l=@webio.gets
          @response = 'koge' + l
        end
      end
      sleep 0.5 # getsを呼ぶまで待つ
    end

    after(:each) do
      @webio_thread.kill
      @webio.close
    end

    def send_url(command)
      `curl http://localhost:53333/#{command}`
    end

    def response_for(command)
      send_url(command)
      @response
    end

    it 'receive web url parameter' do
      response_for('hoge').should eq 'kogehoge'
    end
  end

end

