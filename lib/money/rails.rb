require 'money'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Money #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        
        def money(name, options = {})
          attr_name = "#{name}_amount".to_sym
          options = {:amount => attr_name}.merge(options)
          mapping = [[options[:amount].to_s, 'amount']]
          mapping << [options[:currency].to_s, 'currency'] if options[:currency]
          composed_of name, :class_name => 'Money', :mapping => mapping, :allow_nil => true,
            :converter => lambda{ |m| m.to_money(options[:precision]) },
            :constructor => lambda{ |*args| 
              cents, currency = args
              ::Money.new(cents, (currency || ::Money.default_currency), options[:precision]) 
            }

          define_method "#{name}_with_cleanup=" do |amount|
            send "#{name}_without_cleanup=", amount.blank? ? nil : amount.to_money(options[:precision])
          end
          alias_method_chain "#{name}=", :cleanup
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::Money
