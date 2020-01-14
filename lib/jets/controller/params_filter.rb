class Jets::Controller
  class ParamsFilter
    FILTERED = '[FILTERED]'.freeze

    # Takes a list of keys and a hash and returns a new
    # hash with corresponding values marked as FILTERED
    def self.filter_values_from_hash(filtered_values:, hash_params:)
      if filtered_values.empty? || !hash_params.is_a?(Hash)
        return hash_params
      end

      hash_params.inject({}) do |hash, (key, value)|
        case value
        when Array
          hash[key] = value.map { |item| filter_values_from_hash(filtered_values: filtered_values, hash_params: item) }
        when Hash
          hash[key] = filter_values_from_hash(filtered_values: filtered_values, hash_params: value)
        else
          hash[key] = filtered_values.include?(key) ? FILTERED : value
        end

        hash
      end
    end

    # Takes a list of keys and a json string and returns a new
    # string with corresponding values marked as FILTERED
    def self.filter_values_from_json(filtered_values:, json_text:)
      return json_text if filtered_values.empty?

      begin
        hash_params = JSON.parse(json_text, symbolize_names: true)
        filtered_params = filter_values_from_hash(filtered_values: filtered_values, hash_params: hash_params) 

        JSON.dump(filtered_params)
      rescue JSON::ParserError
        String.new
      end
    end
  end
end
