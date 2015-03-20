module Refile
  module Backgrounder
    module ActiveRecord

      def attachment(name, background: false, worker: Refile::Backgrounder::StoreWorker, **options)
        super name, **options
        return unless background

        attr_accessor :_skip_refile_backgrounder
        after_save(unless: :_skip_refile_backgrounder) do |record|
          metadata = record.send(name)
          metadata = nil unless metadata.is_a? String
          worker.perform_later record, name.to_s, metadata
        end
      end

    end
  end
end

require 'refile/attachment/active_record'
::ActiveRecord::Base.extend Refile::Backgrounder::ActiveRecord
