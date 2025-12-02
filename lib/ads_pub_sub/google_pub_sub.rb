require "google/cloud/pubsub"
require "ads_pub_sub/exceptions"

module AdsPubSub
  class GooglePubSub
    REQUIRED_CONFIG_METHODS = %i[keyfile scope project_id]

    delegate *REQUIRED_CONFIG_METHODS, to: :config
    attr_accessor :config, :pubsub, :topics, :subscriptions

    def initialize(config)
      @config = validate_config(config)
      @topics = {}
      @subscriptions = {}
      @pubsub = Google::Cloud::PubSub.new(project_id: project_id, credentials: credentials)
    end

    def publish(name, message, opts = {})
      async = opts.delete(:async) || false
      topic_opts = async ? { async: async } : {}
      msg_topic = topic(name, topic_opts)
      return ads_async_publish(msg_topic, message, opts) if async

      ads_publish(msg_topic, message, opts)
    end

    def subscribe(name)
      subscription(name).listen do |msg|
        yield msg
        msg.acknowledge!
      end
    end

    private

    def ads_async_publish(message, opts)
      topic.publish_async(message, **opts) do |result|
        if result.succeed?
          log_results("\t==== Message send correctly #{result.inspect}.")
        else
          log_results("\t==== Message sent with an error: #{result.inspect}")
        end
      end
    end

    def ads_publich(message, opts)
      topic.publish(message, **opts)
    end

    def validate_config(config)
      errors = []

      REQUIRED_CONFIG_METHODS.each do |method|
        errors << method unless config.respond_to?(method)
      end

      raise AdsPubSub::MissingConfigValues.new(errors) if errors.present?

      config
    end

    def topic(name, opts = {})
      topics[name] ||= pubsub.topic("#{base_project_path}/topics/#{name}", **opts)
    end

    def subscription(name)
      subscriptions[name] ||= pubsub.subscription("#{base_project_path}/subscriptions/#{name}")
    end

    def credentials
      @_credentials ||= Google::Cloud::PubSub::Credentials.new(keyfile, scope: scope)
    end

    def base_project_path
      "projects/#{project_id}"
    end

    def log_results(msg)
      if defined?(Rails)
        Rails.logger.info(msg)
      else
        puts(msg)
      end
    end
  end
end
