module RhnSatellite
    module Connection
        class Handler
            
            include RhnSatellite::Common::Debug
            
            class << self
                attr_accessor :default_hostname,:default_username, :default_password
                
                def instance_for(identifier,hostname=nil,username=nil,password=nil,https=true)
                    instances[identifier] ||= Handler.new(
                        hostname||default_hostname,
                        username||default_username,
                        password||default_password,
                        https
                    )
                end
                
                def reset_instance(identifier)
                    instances.delete(identifier)
                end
                
                private
                def instances
                    @instances ||= {}
                end
            end
            
            def initialize(hostname,username=nil,password=nil,https=true)
                @hostname = hostname
                @username = username
                @password = password
                @https = https
            end
            
            def login(duration=nil)
                @auth_token ||= make_call('auth.login', *[@username, @password, duration].compact)
            end
            
            def logout
                make_call('auth.logout',@auth_token) if @auth_token
                true
            ensure
                @auth_token = nil
            end
            
            
            # Makes a remote call.
            def make_call(*args)
                raise "No connection established on #{@hostname}." unless connected?
                
                debug("Remote call: #{args.first} (#{args[1..-1].inspect})")
                result = connection.call(*args)
                debug("Result: #{result}\n")
                result
            end
            
            def in_transaction(do_login=false,&blk)
                begin
                    begin_transaction
                    token = do_login ? login : nil 
                    result = yield(token)
                    logout if do_login
                ensure
                    end_transaction
                end
                result
            end
            
            def connected?
                !connection.nil?
            end

            def connect
                debug("Connecting to #{url}")
                @connection = XMLRPC::Client.new2(url)
            end
            
            def disconnect
                @connection = nil
            end

            def default_call(cmd,*args)
              in_transaction(true) {|token| make_call(cmd,token,*args) }
            end
            
            private                
            def begin_transaction
                connect
            end
            # Ends a transaction and disconnects.
            def end_transaction
                @connection = @auth_token = @version = nil
            end
            
            def connection
                @connection
            end
            
            def url
                @url ||= "#{@https ? 'https' : 'http'}://#{@hostname}#{api_path}"
            end
            
            def api_path
               "/rpc/api" 
            end
            
        end
    end
end
