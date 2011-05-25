require 'bundler/setup'
require 'lispy'
require 'singleton'

module Stumpy
  class CommandRunner
    # stumpy path-to-test-file taskname
    # i.e. bin/stumpy recipies/test.rb make_datefile
    def initialize(*args)
      path_to_recipie, task_name = *args
      require(path_to_recipie)
      RecipieRunner.new(Recipies.detect { |r| r[0][0].to_s == task_name })
    end
  end

  class RecipieRunner
  end

  class Recipies
    include Singleton
    attr_reader :recipies

    def self.define(&recipie)
      instance.recipies << Lispy.to_data(&recipie)
    end

    def initialize
      @recipies = []
    end
  end
end
