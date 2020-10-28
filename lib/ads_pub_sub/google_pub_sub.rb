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
      method = async ? :publish_async : :publish

      topic(name).
        send(method, message, **opts)
    end

    def subscribe(name)
      subscription(name).listen do |msg|
        yield msg
        msg.acknowledge!
      end
    end

    private

    def validate_config(config)
      errors = []

      REQUIRED_CONFIG_METHODS.each do |method|
        errors << method unless config.respond_to?(method)
      end

      raise AdsPubSub::MissingConfigValues.new(errors) if errors.present?

      config
    end

    def topic(name)
      topics[name] ||= pubsub.topic("projects/amco-ads/topics/#{name}")
    end

    def subscription(name)
      subscriptions[name] ||= pubsub.subscription("projects/amco-ads/subscriptions/#{name}")
    end

    def credentials
      @_credentials ||= Google::Cloud::PubSub::Credentials.new(keyfile, scope: scope)
    end
  end
end
