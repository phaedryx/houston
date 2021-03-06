# frozen_string_literal: true

module Lita
  module Handlers
    class Webhooks < Handler
      template_root File.expand_path('../../views', __FILE__)

      http.get '/', :index
      http.post '/echo', :echo
      http.post '/webhooks', :webhooks
      http.get '/payload', :payload

      def index(request, response)
        methods = request.methods.select { |name| request.method(name).arity.zero? }
        request_values = methods.each_with_object({}) do |name, hash|
          hash[name] = request.send(name).to_s
        rescue
          hash[name] = '¯\_(ツ)_/¯'
        end
        vars = { params: request.params, request_values: request_values }
        response.write(render_template('index', vars))
      end

      def echo(request, response)
        response.write(request.body.string)
      end

      def webhooks(request, response)
        payload = request.body.string

        case request.env['HTTP_X_GITHUB_EVENT']
        when 'create' then create(payload)
        when 'pull_request' then pull_request(payload)
        when 'pull_request_review' then pull_request_review(payload)
        when 'push' then push(payload)
        end
        response.write('ok')
      end

      def payload(_request, response)
        action = redis.get('action')
        payload = JSON.parse(redis.get('payload'))
        response.write(render_template('payload', action: action, payload: payload))
      end

      private

      def create(payload)
        redis.set('action', 'create')
        redis.set('payload', payload)
      end

      def pull_request(payload)
        redis.set('action', 'pull_request')
        redis.set('payload', payload)
      end

      def pull_request_review(payload)
        redis.set('action', 'pull_request_review')
        redis.set('payload', payload)
      end

      def push(payload)
        redis.set('action', 'push')
        redis.set('payload', payload)
      end
    end

    Lita.register_handler(Webhooks)
  end
end
