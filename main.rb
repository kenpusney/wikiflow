#!/usr/bin/env ruby

require 'init'
require 'indexing'
require 'wiki_init'

require 'fileutils'
require 'webrick'

command :new, :category do |category_name|
    if File.directory?(File.join('cnmd', *category_name))
        puts "Already a category."
    else
        Dir.mkdir(File.join("cnmd", *category_name))
        FileUtils.touch(File.join("cnmd", *category_name, "README.cn.md"))
    end
end

command :new, :post do |lst|
    if File.exist?(File.join('cnmd', *lst.first(lst.size - 1), lst.last + ".cn.md"))
        puts "Already a post."
    else
        begin
            FileUtils.touch(File.join("cnmd", *lst.first(lst.size - 1), lst.last + ".cn.md"))
        rescue => exception
            puts "please check it is in right category"
        end
    end
end

command :new do |lst|
    if File.directory?(File.join("cnmd", *lst.first(lst.size - 1)))
        FileUtils.touch File.join("cnmd", *lst.first(lst.size - 1), lst.last + ".cn.md");
    else
        puts "not correct category"
    end
end

command :index do |lst|
    FileUtils.mkdir_p("data")
    File.write('data/indexing.json', indexing(Dir['**/*.cn.md']))
end

command :hash do |lst|
    FileUtils.mkdir_p("data")
    File.write('data/hashing.json', hashing(Dir["**/*.cn.md"]))
end

command :serve do |lst|
    s = WEBrick::HTTPServer.new(:Port => 4000, :DocumentRoot => Dir::pwd)
    Signal.trap("INT") { s.shutdown }
    Signal.trap("TERM") { s.shutdown }
    s.start
end

command :init do |lst|
    initwiki
end

run_command();
