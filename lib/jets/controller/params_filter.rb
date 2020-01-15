class Jets::Controller
  class ParamsFilter
    FILTERED = '[FILTERED]'.freeze

    def self.filter_values_from_hash(filtered_values, hash_params)
      new(filtered_values).filter_values_from_hash(hash_params)
    end

    def self.filter_values_from_json(filtered_values, json_text)
      new(filtered_values).filter_values_from_json(json_text)
    end

    attr_reader :filtered_values

    def initialize(filtered_values)
      @filtered_values = filtered_values
    end

    # Takes a list of keys and a hash and returns a new
    # hash with corresponding values marked as FILTERED
    def filter_values_from_hash(hash_params)
      if filtered_values.empty? || !hash_params.is_a?(Hash)
        return hash_params
      end

      hash_params.inject({}) do |hash, (key, value)|
        case value
        when Array
          hash[key] = value.map { |item| filter_values_from_hash(item) }
        when Hash
          hash[key] = filter_values_from_hash(value)
        else
          hash[key] = filtered_values.include?(key) ? FILTERED : value
        end

        hash
      end
    end

    # Takes a list of keys and a json string and returns a new
    # string with corresponding values marked as FILTERED
    def filter_values_from_json(json_text)
      return json_text if filtered_values.empty?

      begin
        hash_params = JSON.parse(json_text, symbolize_names: true)
        filtered_params = filter_values_from_hash(hash_params)

        JSON.dump(filtered_params)
      rescue JSON::ParserError
        String.new
      end
    end
  end
end
