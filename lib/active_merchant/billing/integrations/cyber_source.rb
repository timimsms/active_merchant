module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module CyberSource
        autoload :Helper, File.dirname(__FILE__) + '/cyber_source/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/cyber_source/notification.rb'
       
        mattr_accessor :service_url
        self.service_url = 'https://ssl.ditonlinebetalingssystem.dk/integration/ewindow/Default.aspx'

        def self.notification(post, options = {})
          Notification.new(post)
        end
        
        def self.return(post, options = {})
          Return.new(post, options)
        end
      end
    end
  end
end