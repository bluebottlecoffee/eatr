module Eatr
  module Transformation
    class AddDateId
      def initialize(args)
        @source = args.fetch('source')
        @destination = args.fetch('destination')
      end

      def call(*objs)
        Array(objs.flatten).map do |o|
          if !o[@source].nil?
            o[@destination] = o[@source].strftime('%Y%m%d').to_i
          end

          o
        end
      end
    end
  end
end
