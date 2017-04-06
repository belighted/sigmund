module Sigmund
    class Project

      def initialize(attributes = {})
        attributes.each do |k,v|
          self.send("#{k}=", v)
        end
      end

      attr_reader :provider, :uid
      attr_reader :name, :url

      private

      attr_writer :provider, :uid
      attr_writer :name, :url




    end
end