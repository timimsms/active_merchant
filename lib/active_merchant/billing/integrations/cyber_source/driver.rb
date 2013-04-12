require 'rubygems'
require 'hmac-sha1'
require 'digest/sha1'
require 'base64'


module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module CyberSource
        class Driver
          @@public_key    = nil
          @@private_key   = nil
          @@merchant_id   = nil
          @@serial_number = nil


          def initialize(public_key, private_key, merchant_id, serial_number)
            @@public_key    = public_key
            @@private_key   = private_key
            @@merchant_id   = merchant_id
            @@serial_number = serial_number
          end

          def hopHash(data, key)
            myhmac = HMAC::SHA1.new(key.toutf8)
            myhmac.update(data.toutf8)
            Base64.encode64(myhmac.digest).chomp
          end

          def getMicrotime()
            ((Time.now - Time.gm(1970,1,1)) *1000).to_i.to_s
          end

          def insertSignature(amount, currency)
            timestamp = getMicrotime()
            data = @@merchant_id + amount + currency + timestamp
            pub_digest = hopHash(data, @@public_key)
            "<input type='hidden' name='amount' value='#{amount}' >\n" + 
            "<input type='hidden' name='currency' value='#{currency}' >\n" + 
            "<input type='hidden' name='orderPage_timestamp' value='#{timestamp}' >\n" + 
            "<input type='hidden' name='merchantID' value='#{@@merchant_id}' >\n" + 
            "<input type='hidden' name='orderPage_signaturePublic' value='#{pub_digest}' >\n" +
            "<input type='hidden' name='orderPage_version' value='4' >\n" + 
            "<input type='hidden' name='orderPage_serialNumber' value='#{@@serial_number}' >\n"
          end

          def insertSignature3(amount, currency, orderPage_transactionType)
            timestamp = getMicrotime()
            data = @@merchant_id + amount + currency + timestamp + orderPage_transactionType
            pub_digest = hopHash(data, @@public_key)

            "<input type='hidden' name='orderPage_transactionType' value='#{orderPage_transactionType}' >\n" +
            "<input type='hidden' name='amount' value='#{amount}' >\n" + 
            "<input type='hidden' name='currency' value='#{currency}' >\n" + 
            "<input type='hidden' name='orderPage_timestamp' value='#{timestamp}' >\n" + 
            "<input type='hidden' name='merchantID' value='#{@@merchant_id}' >\n" + 
            "<input type='hidden' name='orderPage_signaturePublic' value='#{pub_digest}' >\n" +
            "<input type='hidden' name='orderPage_version' value='4' >\n" + 
            "<input type='hidden' name='orderPage_serialNumber' value='#{@@serial_number}' >\n"
          end

          def insertSubscriptionSignature(subscriptionAmount,subscriptionStartDate,subscriptionFrequency,subscriptionNumberOfPayments,subscriptionAutomaticRenew)
            data = subscriptionAmount + subscriptionStartDate + subscriptionFrequency + subscriptionNumberOfPayments + subscriptionAutomaticRenew
            pub_digest = hopHash(data, @@public_key)
            "<input type='hidden' name='recurringSubscriptionInfo_amount' value='#{subscriptionAmount}' >\n" + 
            "<input type='hidden' name='recurringSubscriptionInfo_numberOfPayments' value='#{subscriptionNumberOfPayments}' >\n" + 
            "<input type='hidden' name='recurringSubscriptionInfo_frequency' value='#{subscriptionFrequency}' >\n" + 
            "<input type='hidden' name='recurringSubscriptionInfo_automaticRenew' value='#{subscriptionAutomaticRenew}' >\n" + 
            "<input type='hidden' name='recurringSubscriptionInfo_startDate' value='#{subscriptionStartDate}' >\n" + 
            "<input type='hidden' name='recurringSubscriptionInfo_signaturePublic' value='#{pub_digest}' >\n" 
          end

          def insertSubscriptionIDSignature(subscriptionID)
            pub_digest = hopHash(subscriptionID, @@public_key)
            "<input type='hidden' name='paySubscriptionCreateReply_subscriptionID' value='#{subscriptionID}' >\n" + 
            "<input type='hidden' name='paySubscriptionCreateReply_subscriptionIDPublicSignature' value='#{pub_digest}' >\n"
          end

          def verifySignature(data, signature)
            ((hopHash(data, @@public_key).to_s == signature.to_s))
          end

          def verifyTransactionSignature(message)
            fields = message['signedFields'].split(',')
            data = '';
            fields.each { |field| data << message[field] }
            (verifySignature(data, message['transactionSignature']))
          end
        end
      end
    end
  end
end