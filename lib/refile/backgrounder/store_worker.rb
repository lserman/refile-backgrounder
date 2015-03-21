module Refile
  module Backgrounder
    class StoreWorker < ::ActiveJob::Base
      attr_reader :record, :attachment_name
      queue_as :refile

      def perform(record, attachment_name)
        @record = record
        @attachment_name = attachment_name
        return unless attachment_cached?

        file = upload attacher.get
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
          record.send "#{attachment_name}_cache_id=", nil if record.respond_to? "#{attachment_name}_cache_id="
          record.send "#{attachment_name}_id=", file.id  if record.respond_to? "#{attachment_name}_id="
          record.send "#{attachment_name}_id_will_change!" if record.respond_to? "#{attachment_name}_id_will_change!"
          record.send "#{attachment_name}_cache_id_will_change!" if record.respond_to? "#{attachment_name}_cache_id_will_change!"
          record.save
        end

    end
  end
end
