require_relative './system/application/container.rb'

Application.finalize!

FirstTestClass.new.hi
TestModule::SecondTestClass.new.hi
