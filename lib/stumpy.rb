require 'bundler/setup'
require 'lispy'
require 'singleton'

module Stumpy
  class CommandRunner
    def initialize(*args)
      path_to_recipie = *args
      require(path_to_recipie) # requires a relative path i.e. ./blah.rb, not just blah.rb
      RecipieRunner.new(Recipies.instance.recipies.first) # only supports one at a time, at the moment.
    end
  end

  class RecipieRunner
    def initialize(recipie)
      recipie.each do |step|
        name = step[1]
        setup = step.last.detect { |s| s[0] == :setup }[1]
        verify = step.last.detect { |s| s[0] == :verify }[1]
        puts name
        if verify.call
          puts '  ALREADY DONE, VERIFIED.'
        else
          puts '  NOT DONE, WORKING...'
          setup.call
          if verify.call
            puts '  DONE, VERIFIED.'
          else
            puts '  DONE, VERIFICATION FAILED, EXITING.'
            break
          end
        end
      end
    end
  end

  class Recipies
    include Singleton
    attr :recipies

    def self.define(&recipie)
      instance.recipies << Lispy.new.to_data(&recipie)
    end

    def self.detect(&test)
      instance.recipies.detect(&test)
    end

    def initialize
      @recipies = []
    end
  end
end
