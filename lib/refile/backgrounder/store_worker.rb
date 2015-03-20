module Refile
  module Backgrounder
    class StoreWorker < ::ActiveJob::Base
      attr_reader :record, :attachment_name
      queue_as :refile

      def perform(record, attachment_name, metadata = nil)
        @record = record
        @attachment_name = attachment_name
        @record.send "#{attachment_name}=", metadata if metadata
        return unless attachment_cached?

        file = attacher.get
        upload file
        cleanup_cache!
        update_record_attachment(file) if file
        yield if block_given?
      end

      private

        def attacher
          @_attacher ||= record.send("#{attachment_name}_attacher")
        end

        def attachment_cached?
          attacher.cache_id
        end

        def upload(file)
          attacher.store.upload(file)
        end

        def cleanup_cache!
          attacher.delete!
        end

        def update_record_attachment(file)
          record._skip_refile_backgrounder = true
          record.send "#{attachment_name}_cache_id=", nil if respond_to? "#{attachment_name}_cache_id="
          record.send "#{attachment_name}_id=", nil if respond_to? "#{attachment_name}_id="
          record.save
        end

    end
  end
end
