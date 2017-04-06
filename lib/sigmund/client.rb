module Sigmund
    class Client

      def initialize(options)
        @options = options
      end

      def fetch_all
        providers.flat_map(&:fetch)
      end

      private

      attr_reader :options

      def providers
        @providers ||= PROVIDERS.map do |provider_code, provider_class|
          provider_options = options.fetch(provider_code){Hash.new}
          provider_class.new(provider_options)
        end
      end

      PROVIDERS = {
          basecamp: Providers::Basecamp
      }

    end
end