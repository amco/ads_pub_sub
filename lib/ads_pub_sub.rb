require "ads_pub_sub/version"
require "ads_pub_sub/google_pub_sub"

module AdsPubSub
  class Base
    def initialize(config_obj, adapter = :google)
      @service = adapter_class(adapter).new(config_obj)
    end

    def publish(topic, message, opts = {})
      @service.publish(topic, message)
    end

    def subscribe(subscription, &block)
      @service.subscribe(subscription, &block)
    end

    private

    def adapter_class(name)
      class_name = "ads_pub_sub::_#{name}_pub_sub".split('_').map(&:capitalize).join
      Module.const_get(class_name)
    end
  end
end
