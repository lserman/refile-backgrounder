module Refile
  module Backgrounder
    module Attacher

      def background?
        record.respond_to? "#{name}_cache_id"
      end

      def cache_id
        super || (background? and record.send("#{name}_cache_id"))
      end

      def set(*)
        super
        save_cache_id if background?
      end

      def store!
        super unless background?
      end

      def save_cache_id
        record.send "#{name}_cache_id=", cache_id if background?
      end

    end
 end
end

require 'refile/attacher'
::Refile::Attacher.send :prepend, Refile::Backgrounder::Attacher
