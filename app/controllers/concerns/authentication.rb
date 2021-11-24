
    module Authentication
      def encode(payout, exp = RailsJwtApi.token_expiration)
        payout[:exp] = exp.to_i
        JWT.encode(payout, RailsJwtApi.token_secret_key)
      end
    
      def decode(token)
        decode = JWT.decode(token, 'create some random string 😀')[0]
        HashWithIndifferentAccess.new decode
      end


      module Helpers
        
          def authorize_user!
            header = request.headers[:AuthToken]
            begin
              @decoded = decode(header)
              @current_user = User.find(@decoded[:user_id])

            rescue ActiveRecord::RecordNotFound => e
              render json: {status: :failed, msg: e.message}, status: :not_found

            rescue JWT::DecodeError => e
              render json: {status: :failed, refresh_token: refresh_jwt_user(header), msg: e.message}, status: :not_found
            end
          end


          def refresh_jwt_user(token)
            begin
              user_id = Jwt.find_by(token: token).user_id
              #=> generate new token
              token = encode(user_id: user_id)
              replace_token = Jwt.find_by(user_id: user_id)
              replace_token.update_attribute(:token, token)
              replace_token.token
            rescue  => e
              e
            end
          end

          def current_user
            @current_user
          end

        end
    end 
