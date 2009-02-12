module Scrooge
  module Strategy
    
    autoload :Controller, 'scrooge/strategy/controller'
    autoload :Stage, 'scrooge/strategy/stage'

    class Base
      
      autoload :Scope, 'scrooge/strategy/scope'
      autoload :Track, 'scrooge/strategy/track'
      autoload :TrackThenScope, 'scrooge/strategy/track_then_scope'
      
      class NoStages < StandardError
      end
      
      @@stages = {}
      @@stages[self.name] = []
      
      class << self
        
        # Stage definition macro.
        #
        # stage :track, :for => 10.minutes do
        #   ....
        # end
        #
        def stage( signature, options = {}, &block )
          @@stages[self.name] << Scrooge::Strategy::Stage.new( signature, options, &block )
        end
        
        # List all defined stages for this klass.
        #
        def stages
          @@stages[self.name]
        end
        
        # Are there any stages defined ?
        #
        def stages?
          !stages.empty?
        end
        
        # Test teardown helper.
        #
        def flush!
          @@stages[self.name] = []
        end
        
      end
      
      # Requires at least one stage definition.
      #
      def initialize
        raise NoStages unless self.class.stages?
      end 
      
      # Piggy back on stages defined for this klass.
      #
      def stages
        self.class.stages
      end
      
    end
  end
end