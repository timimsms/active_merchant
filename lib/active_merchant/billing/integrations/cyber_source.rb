module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module CyberSource
        autoload  :Helper, File.dirname(__FILE__) + '/cyber_source/helper.rb'
        autoload  :Notification, File.dirname(__FILE__) + '/cyber_source/notification.rb'
        autoload  :Driver, File.dirname(__FILE__) + '/cyber_source/cybersource_driver.rb'
       
        mattr_accessor :service_url
        self.service_url = 'https://www.example.com'

        def self.notification(post)
          Notification.new(post)
        end
        
      end
    end
  end
end