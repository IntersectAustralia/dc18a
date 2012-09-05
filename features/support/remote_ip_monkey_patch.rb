module ActionDispatch
  class Request
    def remote_ip_with_mocking
      if Rails.env == 'cucumber' || Rails.env == 'test'
        test_ip = ENV['RAILS_TEST_IP_ADDRESS']
      end

      unless test_ip.nil? or test_ip.empty?
        test_ip
      else
        remote_ip_without_mocking
      end
    end
    alias_method_chain :remote_ip, :mocking
  end
end